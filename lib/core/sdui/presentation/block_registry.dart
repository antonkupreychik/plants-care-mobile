import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/care_event/data/mappers/task_type_mapper.dart';
import '../../../features/care_event/presentation/log_care_event_sheet.dart';
import '../../../features/home/domain/plant.dart';
import '../../../features/home/presentation/widgets/guest_banner.dart';
import '../../../features/home/presentation/widgets/location_chips.dart';
import '../../../features/home/presentation/widgets/plant_card.dart';
import '../../../features/home/presentation/widgets/today_card.dart';
import '../../../features/weather/presentation/widgets/weather_strip.dart';
import '../../../l10n/app_localizations.dart';
import '../../care/care_task.dart';
import '../../clock/clock_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/tokens.dart';
import '../domain/sdui_action.dart';
import '../domain/sdui_block.dart';
import 'action_runner.dart';
import 'home_room_filter.dart';
import 'sdui_l10n_keys.dart';

/// Реестр SDUI-рендереров (MADR-015): отображение типа доменного блока
/// ([SduiBlock]) в нативный виджет, который рисует СУЩЕСТВУЮЩИЕ виджеты home
/// (`WeatherStripContent`, `TodayCard`, `LocationChips`, `PlantCard`) из данных
/// блока. Новые виджеты не пишем — переиспользуем (FLUTTER.md «Правила виджетов»).
///
/// Диспетчеризация — pattern matching по подтипу sealed-класса (компилятор
/// проверяет полноту). Нераспознанный блок ([SduiUnknownBlock]) сюда не доходит
/// (репозиторий его отфильтровал), но на всякий случай рендерится в
/// [SizedBox.shrink] — graceful degradation, ничего не рисуется.
class BlockRegistry {
  const BlockRegistry._();

  /// Отрисовывает один доменный блок. `key` стабилизирует элемент в списке
  /// (порядок блоков задаёт сервер).
  static Widget build(BuildContext context, WidgetRef ref, SduiBlock block) {
    return switch (block) {
      SduiWeatherStripBlock(:final available, :final humidityPercent, :final recommendation) =>
        (available && humidityPercent != null)
            ? WeatherStripContent(
                humidityPercent: humidityPercent,
                recommendation: recommendation,
              )
            // Погода недоступна → тихо сворачиваем (как нативный WeatherStrip).
            : const SizedBox.shrink(),
      SduiTodaySummaryBlock(:final total, :final done) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          // Переиспользуем TodayCard как карточку-сводку: списка задач в блоке
          // нет (его несут нативные секции), показываем счётчики прогресса.
          child: TodayCard(
            tasks: const [],
            now: DateTime.now(),
            onTaskTap: (_) {},
            completedCount: done,
            totalCount: total,
          ),
        ),
      SduiTodayTasksBlock(:final tasks, :final completedCount, :final totalCount) =>
        _TodayTasks(
          tasks: tasks,
          completedCount: completedCount,
          totalCount: totalCount,
        ),
      SduiLocationChipsBlock(
        :final locations,
        :final selectedLocationId,
        :final totalCount
      ) =>
        _LocationChips(
          chips: locations,
          selectedLocationId: selectedLocationId,
          totalCount: totalCount,
        ),
      SduiPlantGridBlock(:final plants, :final emptyTitleKey, :final emptyBodyKey) =>
        // Пустая комната с контекстными ключами → контекстный пустой стейт
        // комнаты (MADR-016), иначе — сетка растений.
        (plants.isEmpty && emptyTitleKey != null && emptyBodyKey != null)
            ? _RoomEmpty(titleKey: emptyTitleKey, bodyKey: emptyBodyKey)
            : _PlantGrid(items: plants),
      SduiGuestBannerBlock(:final titleKey, :final bodyKey, :final ctaAction) =>
        _GuestBanner(
          titleKey: titleKey,
          bodyKey: bodyKey,
          ctaAction: ctaAction,
        ),
      SduiEmptyStateBlock(
        :final iconKey,
        :final titleKey,
        :final bodyKey,
        :final ctaAction
      ) =>
        _EmptyState(
          iconKey: iconKey,
          titleKey: titleKey,
          bodyKey: bodyKey,
          ctaAction: ctaAction,
        ),
      SduiUnknownBlock() => const SizedBox.shrink(),
    };
  }
}

/// Исполняет SDUI-[action] через [ActionRunner] и шумит тостом только при
/// ошибке/успехе ухода (навигация/unsupported — тихо). Общий хелпер для CTA
/// блоков и кнопки «полить».
Future<void> _runSduiAction(
  BuildContext context,
  WidgetRef ref,
  SduiAction? action, {
  bool toastOnSuccess = false,
}) async {
  if (action == null) return;
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context);
  final result = await ref.read(actionRunnerProvider).run(action);
  final message = switch (result) {
    SduiActionResult.success => toastOnSuccess ? l10n.careDoneUnknown : null,
    SduiActionResult.failure => l10n.errorGeneric,
    // unsupported (неизвестный kind / навигация без target) — тихо игнорируем.
    SduiActionResult.unsupported => null,
  };
  if (message == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Тапабельный список задач «Сегодня» из SDUI-блока `today_tasks`.
///
/// Переиспользует нативный [TodayCard] и нативный care-sheet-флоу: тап по
/// задаче открывает существующий [showLogCareEventSheet] с `presetType`,
/// выведенным из [CareTask.type] тем же маппером [careEventKindFromTaskType],
/// что использовал home до перехода на SDUI. Это интерактив — он нативный, НЕ
/// через [ActionRunner]. `now` берём из [clockProvider] (тестируемость, MADR
/// «Время»).
class _TodayTasks extends ConsumerWidget {
  const _TodayTasks({
    required this.tasks,
    required this.completedCount,
    required this.totalCount,
  });

  final List<CareTask> tasks;
  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: TodayCard(
        tasks: tasks,
        now: nowLocal,
        // Тап по задаче → нативный sheet ухода с предвыбранным типом
        // (FERTILIZING → fertilize и т.д.). SOIL_CHECK/unknown дают unknown —
        // контроллер sheet откатит на дефолтный тип.
        onTaskTap: (task) => showLogCareEventSheet(
          context,
          plantId: task.plantId,
          presetType: careEventKindFromTaskType(task.type),
          plantName: task.plantName,
        ),
        completedCount: completedCount,
        totalCount: totalCount,
      ),
    );
  }
}

/// Сетка растений из SDUI-блока `plant_grid`. Переиспользует [PlantCard];
/// действие «полить» (`ActionDescriptor`) исполняется через [ActionRunner].
class _PlantGrid extends ConsumerWidget {
  const _PlantGrid({required this.items});

  final List<SduiPlantGridItem> items;

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 0.72,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _gridDelegate,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return PlantCard(
            // PlantCard ждёт domain Plant — собираем из элемента блока.
            plant: Plant(
              id: item.id,
              name: item.name,
              locationName: item.locationName,
            ),
            tintWarm: index.isEven,
            // Тап по ТЕЛУ карточки = navigate-действие (карточка растения).
            // Нет действия → no-op (витрина без интерактива).
            onTap: () => _runSduiAction(context, ref, item.action),
          );
        },
      ),
    );
  }
}

/// Чипы комнат из SDUI-блока `location_chips`. Single source of truth выделения
/// — серверный [selectedLocationId] (не локальный state): подсветка идёт по
/// нему. Тап по чипу пишет выбранный `locationId` в [HomeRoomFilter] →
/// `homeScreenLayout` перезапрашивает витрину с `?locationId=` → сервер отдаёт
/// отфильтрованную сетку и новый `selectedLocationId`. Повторный тап по уже
/// выбранному чипу и тап по «Все» дают `null` (сброс фильтра) — это делает сам
/// [LocationChips] (он зовёт `onSelected(null)` для «Все», `onSelected(loc.id)`
/// для комнаты; «повторный тап = сброс» решаем здесь).
class _LocationChips extends ConsumerWidget {
  const _LocationChips({
    required this.chips,
    required this.selectedLocationId,
    required this.totalCount,
  });

  final List<SduiLocationChip> chips;
  final int? selectedLocationId;
  final int totalCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 14),
      child: LocationChips(
        locations: [for (final c in chips) c.location],
        plantCountByLocation: {
          for (final c in chips) c.location.id: c.count,
        },
        totalPlants: totalCount,
        // Выделение — по серверному ответу, не по локальному состоянию.
        selectedLocationId: selectedLocationId,
        onSelected: (locationId) {
          // Повторный тап по уже выбранной комнате → сброс на «Все» (null).
          final next = locationId == selectedLocationId ? null : locationId;
          ref.read(homeRoomFilterProvider.notifier).select(next);
        },
      ),
    );
  }
}

/// Контекстный пустой стейт комнаты из блока `plant_grid` (MADR-016): когда
/// фильтр по комнате дал пустую сетку. Тексты — l10n-КЛЮЧИ
/// ([titleKey]/[bodyKey]), резолвятся через [resolveSduiTextKey] (неизвестный
/// ключ → фолбэк без краша). Лёгкий, в стиле `_EmptyState`, но без CTA — это не
/// пустой сад, а лишь пустая комната (выбор другой комнаты вернёт растения).
class _RoomEmpty extends StatelessWidget {
  const _RoomEmpty({required this.titleKey, required this.bodyKey});

  final String titleKey;
  final String bodyKey;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_florist_outlined, size: 48, color: c.primary),
          const SizedBox(height: 14),
          Text(
            resolveSduiTextKey(l10n, titleKey),
            textAlign: TextAlign.center,
            style: AppTheme.serif(fontSize: 22, color: c.ink),
          ),
          const SizedBox(height: 8),
          Text(
            resolveSduiTextKey(l10n, bodyKey),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.4, color: c.inkSoft),
          ),
        ],
      ),
    );
  }
}

/// SDUI-блок `guest_banner` (MADR-017): переиспользует визуал [GuestBannerCard],
/// тексты резолвит из l10n-КЛЮЧЕЙ, CTA исполняет `ctaAction` через ActionRunner.
class _GuestBanner extends ConsumerWidget {
  const _GuestBanner({
    required this.titleKey,
    required this.bodyKey,
    required this.ctaAction,
  });

  final String titleKey;
  final String bodyKey;
  final SduiAction? ctaAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return GuestBannerCard(
      title: resolveSduiTextKey(l10n, titleKey),
      subtitle: resolveSduiTextKey(l10n, bodyKey),
      onTap: () => _runSduiAction(context, ref, ctaAction),
    );
  }
}

/// SDUI-блок `empty_state` (MADR-017): аккуратное пустое состояние сада из
/// l10n-КЛЮЧЕЙ (иконка/заголовок/подпись) + CTA → `ctaAction`. Не тащит тяжёлый
/// нативный `GardenEmpty` (тот несёт собственные нативные CTA каталога/фото) —
/// рисует лёгкий вариант на токенах под опаковый контракт.
class _EmptyState extends ConsumerWidget {
  const _EmptyState({
    required this.iconKey,
    required this.titleKey,
    required this.bodyKey,
    required this.ctaAction,
  });

  final String iconKey;
  final String titleKey;
  final String bodyKey;
  final SduiAction? ctaAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: c.line),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(resolveSduiIconKey(iconKey), size: 64, color: c.primary),
              const SizedBox(height: 16),
              Text(
                resolveSduiTextKey(l10n, titleKey),
                textAlign: TextAlign.center,
                style: AppTheme.serif(fontSize: 26, color: c.ink),
              ),
              const SizedBox(height: 8),
              Text(
                resolveSduiTextKey(l10n, bodyKey),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.4, color: c.inkSoft),
              ),
              if (ctaAction != null) ...[
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => _runSduiAction(context, ref, ctaAction),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text(l10n.homeAddPlant),
                  style: FilledButton.styleFrom(
                    backgroundColor: c.fab,
                    foregroundColor: c.fabInk,
                    minimumSize: const Size.fromHeight(52),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
