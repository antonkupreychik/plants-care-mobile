import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/sdui/domain/sdui_screen_layout.dart';
import '../../../core/sdui/presentation/screen_layout_provider.dart';
import '../../../core/sdui/presentation/screen_layout_view.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/offline_state.dart';
import '../../../l10n/app_localizations.dart';
import 'home_view_state.dart';
import 'widgets/home_header.dart';
import 'widgets/home_loading_skeleton.dart';

/// Экран 01 «Главная — Мой сад» — теперь Server-Driven (MADR-015).
///
/// Тело экрана собирает сервер: `GET /api/v1/ui/home` → [SduiScreenLayout] →
/// [ScreenLayoutView] рендерит блоки по порядку через `BlockRegistry`,
/// переиспользуя существующие виджеты home (weather strip, today summary,
/// чипы локаций, сетка растений). Действие «полить» в блоке `plant_grid` идёт
/// через `ActionRunner` → существующий care-event флоу.
///
/// Нативными остаются «обвязка»: хедер (поиск/уведомления/профиль) и FAB
/// добавления растения. Гостевой баннер и пустое состояние сада, наоборот, с
/// MADR-017 пришли в SDUI — их видимость/тексты/CTA решает сервер (блоки
/// `guest_banner` / `empty_state`), нативного ветвления по гостю/пустому саду
/// в Home больше нет.
///
/// Состояния сохранены: skeleton (28) при холодной загрузке лейаута,
/// OfflineState (29) при сетевой ошибке без кэша, ErrorState при прочих
/// ошибках, контент при данных.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final layout = ref.watch(homeScreenLayoutProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: layout.when(
        // Холодная загрузка лейаута без данных → полноэкранный скелетон (28).
        loading: () => const HomeLoadingSkeleton(),
        // Ошибка композиции. Сетевая без кэша → офлайн (29); прочее → контент с
        // посекционным ErrorState (тело пустое, но хедер/FAB живы).
        error: (error, _) {
          if (error.isNetworkError) {
            return OfflineState(
              title: l10n.offlineTitleLead,
              titleAccent: l10n.offlineTitleAccent,
              message: l10n.offlineMessage,
              retryLabel: l10n.retry,
              bannerTitle: l10n.offlineBannerTitle,
              bannerStatus: l10n.offlineBannerStatus,
              lastSavedLabel: null,
              onRetry: () => ref.invalidate(homeScreenLayoutProvider),
            );
          }
          return _HomeShell(
            body: ErrorState(
              message: l10n.messageForError(error),
              retryLabel: l10n.retry,
              onRetry: () => ref.invalidate(homeScreenLayoutProvider),
            ),
          );
        },
        data: (data) => _HomeShell(body: ScreenLayoutView(layout: data)),
      ),
    );
  }
}

/// Каркас контента Home: хедер + серверное тело + FAB.
///
/// Скроллируемая колонка. Хедер/FAB — нативный интерактив (не SDUI); [body] —
/// серверная витрина ([ScreenLayoutView]) (включая блоки `guest_banner` /
/// `empty_state`) либо посекционный ErrorState.
class _HomeShell extends ConsumerWidget {
  const _HomeShell({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();

    // Открыть экран унифицированного поиска (issue #69) поверх shell.
    void openSearch() => context.push('/search');

    // Открыть мастер добавления растения (экран 04) поверх shell.
    void openAddPlant() => context.push('/home/add');

    // Открыть ленту уведомлений (экран 24) поверх shell.
    void openNotifications() => context.push('/home/notifications');

    // Перейти на экран профиля (кнопка в упрощённой шапке пустого сада).
    void openProfile() => context.go('/profile');

    // Pull-to-refresh (#142): для SDUI-home источник тела экрана — серверный
    // лейаут, поэтому рефреш инвалидирует именно [homeScreenLayoutProvider]
    // (а не homePlants/homeTasks/homeLocations — их теперь композирует сервер).
    // Ждём перезагрузки лейаута, чтобы индикатор не пропадал мгновенно; ошибки
    // рисует layout.when(...) в [HomeScreen] через AsyncValue.error.
    Future<void> onRefresh() async {
      ref.invalidate(homeScreenLayoutProvider);
      try {
        await ref.read(homeScreenLayoutProvider.future);
      } catch (_) {}
    }

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: onRefresh,
            // AlwaysScrollableScrollPhysics — чтобы pull-to-refresh работал и
            // на коротком контенте (пустой сад / посекционный ErrorState).
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                    child: HomeHeader(
                      now: nowLocal,
                      onSearch: openSearch,
                      onNotifications: openNotifications,
                      onProfile: openProfile,
                      // SDUI-витрина сама решает, что показывать; шапку держим
                      // в обычном режиме (пустой сад сервер отдаёт пустыми блоками).
                      isEmptyGarden: false,
                    ),
                  ),

                  // Гостевой баннер и пустое состояние больше НЕ нативные:
                  // их видимость, тексты и место в лейауте решает сервер
                  // (MADR-017) — они приходят как блоки `guest_banner` /
                  // `empty_state` внутри [body].
                  body,

                  // Запас под плавающую навигацию и FAB.
                  const SizedBox(height: 120),
                ],
              ),
            ),
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
