import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/care/care_task.dart';
import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/offline_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../care_event/data/mappers/task_type_mapper.dart';
import '../../care_event/presentation/log_care_event_sheet.dart';
import '../../weather/presentation/widgets/weather_strip.dart';
import '../../../core/locations/garden_location.dart';
import '../domain/plant.dart';
import 'home_filter.dart';
import 'home_providers.dart';
import 'home_view_state.dart';
import 'widgets/garden_empty.dart';
import 'widgets/home_header.dart';
import 'widgets/home_loading_skeleton.dart';
import 'widgets/location_chips.dart';
import 'widgets/plant_card.dart';
import 'widgets/today_card.dart';

/// Экран 01 «Главная — Мой сад».
///
/// Потребляет три независимых провайдера ([homeTasksProvider],
/// [homePlantsProvider], [homeLocationsProvider]) — каждая секция рисует
/// loading/error/empty/data самостоятельно (провайдеры падают независимо).
///
/// Кольцо здоровья на карточке (G1) показываем — справа от имени растения
/// (см. [PlantCard] → [HealthRing]). Микро-строка погоды (G4) — под хедером
/// ([WeatherStrip], тихо сворачивается, если погода не настроена). Скрыто как
/// заглушки каркаса: алерт «проблемное растение» (BACKEND-GAPS G3),
/// mood/voiceLine (G2).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    // Top-level состояние Home (28 скелетон / 29 офлайн / контент). Ключуется
    // на первичный провайдер сада (см. [homeViewStateProvider]); вторичные
    // секции отрисовываются посекционно уже внутри content.
    final viewState = ref.watch(homeViewStateProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: switch (viewState) {
        HomeViewState.coldLoading => const HomeLoadingSkeleton(),
        HomeViewState.offline => OfflineState(
          title: l10n.offlineTitleLead,
          titleAccent: l10n.offlineTitleAccent,
          message: l10n.offlineMessage,
          retryLabel: l10n.retry,
          bannerTitle: l10n.offlineBannerTitle,
          bannerStatus: l10n.offlineBannerStatus,
          // Реального кэш-снапшота нет — строку last-saved не показываем
          // (время не фабрикуем).
          lastSavedLabel: null,
          onRetry: () {
            ref.invalidate(homePlantsProvider);
            ref.invalidate(homeTasksProvider);
            ref.invalidate(homeLocationsProvider);
          },
        ),
        HomeViewState.content => const _HomeContent(),
      },
    );
  }
}

/// Контентное состояние Home: посекционная раскладка (каждая секция рисует
/// своё loading/error/empty/data) + FAB добавления растения.
class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();

    void comingSoon() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
    }

    // Открыть мастер добавления растения (экран 04) поверх shell.
    void openAddPlant() => context.push('/home/add');

    final tasks = ref.watch(homeTasksProvider);
    final plants = ref.watch(homePlantsProvider);
    final locations = ref.watch(homeLocationsProvider);

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                sliver: SliverToBoxAdapter(
                  child: HomeHeader(now: nowLocal, onComingSoon: comingSoon),
                ),
              ),

              // WEATHER STRIP (G4) — под хедером, над карточкой «Сегодня».
              // Свой паддинг внутри виджета; тихо сворачивается, если погода
              // недоступна/грузится/ошибка (Home не блокируется).
              const SliverToBoxAdapter(child: WeatherStrip()),

              // TODAY — секция задач (своё loading/error/empty/data).
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: _TodaySection(
                    tasks: tasks,
                    now: nowLocal,
                    // Тап по задаче /today → sheet ухода с предвыбранным
                    // типом. Внутренний taskType нормализуем в публичный
                    // CareEventKind маппером data-слоя (SOIL_CHECK/unknown →
                    // unknown, контроллер откатит на дефолт).
                    onTaskTap: (task) => showLogCareEventSheet(
                      context,
                      plantId: task.plantId,
                      presetType: careEventKindFromTaskType(task.type),
                      plantName: task.plantName,
                    ),
                    onSeeAll: () => context.push('/home/today'),
                    onRetry: () => ref.invalidate(homeTasksProvider),
                  ),
                ),
              ),

              // MY GARDEN — заголовок + счётчик.
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                sliver: SliverToBoxAdapter(
                  child: _GardenHeader(plants: plants),
                ),
              ),

              // CHIPS — локации (своё loading/error/data; ошибку прячем тихо).
              SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 14),
                sliver: SliverToBoxAdapter(
                  child: _LocationChipsSection(
                    locations: locations,
                    plants: plants,
                  ),
                ),
              ),

              // GRID — растения (loading/error/empty/data).
              _PlantGridSection(
                plants: plants,
                onAdd: openAddPlant,
                onRecognizePhoto: comingSoon,
                onOpenCatalog: () => context.go('/catalog'),
                onPlantTap: (plant) => context.push('/home/plants/${plant.id}'),
                onRetry: () => ref.invalidate(homePlantsProvider),
              ),

              // Запас под плавающую навигацию и FAB.
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // FAB «добавить» → мастер добавления растения (экран 04).
          Positioned(
            right: 20,
            bottom: 92,
            child: _AddFab(onPressed: openAddPlant),
          ),
        ],
      ),
    );
  }
}

/// Секция «Сегодня»: skeleton / ошибка / данные (пустой список → подпись
/// внутри карточки).
class _TodaySection extends StatelessWidget {
  const _TodaySection({
    required this.tasks,
    required this.now,
    required this.onTaskTap,
    required this.onSeeAll,
    required this.onRetry,
  });

  final AsyncValue<List<CareTask>> tasks;
  final DateTime now;
  final void Function(CareTask task) onTaskTap;
  final VoidCallback onSeeAll;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return tasks.when(
      loading: () => const TodayCardSkeleton(),
      error: (error, _) => ErrorState(
        message: l10n.messageForError(error),
        retryLabel: l10n.retry,
        onRetry: onRetry,
      ),
      data: (list) => TodayCard(
        tasks: list,
        now: now,
        onTaskTap: onTaskTap,
        onSeeAll: onSeeAll,
      ),
    );
  }
}

/// Заголовок «Мой сад» + счётчик растений (счётчик мягко скрывается, пока
/// растения грузятся/в ошибке).
class _GardenHeader extends StatelessWidget {
  const _GardenHeader({required this.plants});

  final AsyncValue<List<Plant>> plants;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final count = plants.value?.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeGardenTitle.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          count == null ? l10n.homeGardenTitle : l10n.homePlantsCount(count),
          style: AppTheme.serif(fontSize: 24, color: c.ink),
        ),
      ],
    );
  }
}

/// Чипы локаций. Ошибку локаций прячем тихо (не критично для сада) — просто
/// не показываем ленту; растения остаются доступны.
class _LocationChipsSection extends ConsumerWidget {
  const _LocationChipsSection({required this.locations, required this.plants});

  final AsyncValue<List<GardenLocation>> locations;
  final AsyncValue<List<Plant>> plants;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return locations.when(
      loading: () => const LocationChipsSkeleton(),
      error: (_, _) => const SizedBox.shrink(),
      data: (locs) {
        if (locs.isEmpty) return const SizedBox.shrink();
        final plantList = plants.value ?? const <Plant>[];
        final countByLocation = <int, int>{};
        for (final p in plantList) {
          final id = p.locationId;
          if (id != null) {
            countByLocation[id] = (countByLocation[id] ?? 0) + 1;
          }
        }
        final selected = ref.watch(selectedLocationProvider);
        return LocationChips(
          locations: locs,
          plantCountByLocation: countByLocation,
          totalPlants: plantList.length,
          selectedLocationId: selected,
          onSelected: (id) =>
              ref.read(selectedLocationProvider.notifier).select(id),
        );
      },
    );
  }
}

/// Сетка растений 2×N: skeleton / ошибка / пусто / данные.
/// Фильтрация по выбранной локации — в UI (растение несёт `locationId`).
class _PlantGridSection extends ConsumerWidget {
  const _PlantGridSection({
    required this.plants,
    required this.onAdd,
    required this.onRecognizePhoto,
    required this.onOpenCatalog,
    required this.onPlantTap,
    required this.onRetry,
  });

  final AsyncValue<List<Plant>> plants;
  final VoidCallback onAdd;
  final VoidCallback onRecognizePhoto;
  final VoidCallback onOpenCatalog;
  final void Function(Plant plant) onPlantTap;
  final VoidCallback onRetry;

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 0.72,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return plants.when(
      loading: () => const SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: _gridDelegate,
          delegate: SliverChildBuilderDelegate(_skeletonBuilder, childCount: 4),
        ),
      ),
      error: (error, _) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverToBoxAdapter(
          child: ErrorState(
            message: l10n.messageForError(error),
            retryLabel: l10n.retry,
            onRetry: onRetry,
          ),
        ),
      ),
      data: (all) {
        if (all.isEmpty) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: GardenEmpty(
                onAdd: onAdd,
                onRecognizePhoto: onRecognizePhoto,
                onOpenCatalog: onOpenCatalog,
              ),
            ),
          );
        }
        final selected = ref.watch(selectedLocationProvider);
        final visible = selected == null
            ? all
            : all.where((p) => p.locationId == selected).toList();

        if (visible.isEmpty) {
          // Выбранная комната пуста — мягкая подсказка (не голый экран).
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                l10n.homeRoomEmpty,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: _gridDelegate,
            delegate: SliverChildBuilderDelegate((context, index) {
              final plant = visible[index];
              return PlantCard(
                plant: plant,
                tintWarm: index.isEven,
                onTap: () => onPlantTap(plant),
              );
            }, childCount: visible.length),
          ),
        );
      },
    );
  }

  static Widget _skeletonBuilder(BuildContext context, int index) =>
      const PlantCardSkeleton();
}

class _AddFab extends StatelessWidget {
  const _AddFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: l10n.homeAddPlant,
      child: Material(
        color: c.fab,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.25),
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add_rounded, size: 26, color: c.fabInk),
          ),
        ),
      ),
    );
  }
}
