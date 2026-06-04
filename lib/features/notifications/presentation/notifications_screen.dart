import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/offline_state.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/notification_item.dart';
import 'notifications_providers.dart';
import 'notifications_state.dart';
import 'widgets/notification_card.dart';
import 'widgets/notifications_empty.dart';
import 'widgets/notifications_group_header.dart';
import 'widgets/notifications_load_more.dart';

/// Экран 24 «Лента уведомлений».
///
/// Потребляет [notificationsControllerProvider]
/// (`AsyncValue<NotificationsState>`, контракт flutter-coder):
/// - **loading** — skeleton карточек;
/// - **error** — [NetworkError] → полноэкранный [OfflineState] (экран 29),
///   прочие [ApiError] → [ErrorState]; retry в обоих → `refresh()`;
/// - **empty** (`state.isEmpty`) → [NotificationsEmpty] (экран 32);
/// - **data** — список, сгруппированный по дням (Сегодня/Вчера/дата) из
///   `createdAt.toLocal()`, с pull-to-refresh, пагинацией и футером.
///
/// Тап по непрочитанному → `markRead(item.id)`. Время/группировка считаются в
/// локальной TZ (backend отдаёт `createdAt` в UTC).
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final _scrollController = ScrollController();

  /// Порог автозагрузки до конца ленты (px), как в истории ухода/каталоге.
  static const double _loadMoreThreshold = 400;

  /// Размер страницы (echo контроллера) — для `hasMoreFor`.
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels < pos.maxScrollExtent - _loadMoreThreshold) return;

    final state = ref.read(notificationsControllerProvider).value;
    if (state == null ||
        state.isLoadingMore ||
        !state.hasMoreFor(_pageSize)) {
      return;
    }
    if (state.loadMoreError != null) return; // ждём ручного повтора
    ref.read(notificationsControllerProvider.notifier).loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final async = ref.watch(notificationsControllerProvider);
    final unread = async.value?.unreadCount ?? 0;
    final hasUnread = unread > 0;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(
              unreadCount: unread,
              showMarkAll: hasUnread,
              onMarkAll: hasUnread ? _markAllVisibleRead : null,
            ),
            Expanded(
              child: async.when(
                loading: () => const _LoadingView(),
                error: (error, _) => _ErrorView(
                  error: error,
                  onRetry: () => ref
                      .read(notificationsControllerProvider.notifier)
                      .refresh(),
                ),
                data: (state) {
                  if (state.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      color: c.primary,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 80),
                          NotificationsEmpty(),
                        ],
                      ),
                    );
                  }
                  return _DataView(
                    state: state,
                    scrollController: _scrollController,
                    onRefresh: _refresh,
                    onMarkRead: (id) => ref
                        .read(notificationsControllerProvider.notifier)
                        .markRead(id),
                    onRetryLoadMore: () => ref
                        .read(notificationsControllerProvider.notifier)
                        .retryLoadMore(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() =>
      ref.read(notificationsControllerProvider.notifier).refresh();

  /// «Прочитать» в шапке: помечает прочитанными все непрочитанные среди уже
  /// загруженных. Оркестрацию (оптимизм + реконсиляция при ошибке) держит
  /// контроллер — UI только делегирует.
  void _markAllVisibleRead() =>
      ref.read(notificationsControllerProvider.notifier).markAllRead();
}

/// Шапка: «назад», overline «Уведомления», серифный счётчик непрочитанных и
/// кнопка «Прочитать» (видна, только когда есть непрочитанные).
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.unreadCount,
    required this.showMarkAll,
    required this.onMarkAll,
  });

  final int unreadCount;
  final bool showMarkAll;
  final VoidCallback? onMarkAll;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _BackButton(
                tooltip: l10n.plantCardBack,
                onPressed: () => _onBack(context),
              ),
              Expanded(
                child: Text(
                  l10n.notificationsTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: c.inkSoft,
                  ),
                ),
              ),
              if (showMarkAll && onMarkAll != null)
                _MarkAllButton(
                  label: l10n.notificationsMarkAllRead,
                  onPressed: onMarkAll!,
                )
              else
                const SizedBox(width: 44),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              l10n.notificationsHeroCount(unreadCount),
              style: AppTheme.serif(fontSize: 28, color: c.ink),
            ),
          ),
        ],
      ),
    );
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: c.surface,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Icon(Icons.arrow_back_rounded, size: 22, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}

class _MarkAllButton extends StatelessWidget {
  const _MarkAllButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: c.line),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Loading первичной загрузки: skeleton нескольких карточек.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: const [
        SkeletonBox(width: 90, height: 12, radius: 6),
        SizedBox(height: 14),
        _SkeletonCard(),
        SizedBox(height: 12),
        _SkeletonCard(),
        SizedBox(height: 12),
        _SkeletonCard(),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonBox(width: 44, height: 44, radius: 14),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 14, radius: 7),
                SizedBox(height: 8),
                SkeletonBox(width: 180, height: 12, radius: 6),
                SizedBox(height: 10),
                SkeletonBox(width: 80, height: 10, radius: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Error первичной загрузки. [NetworkError] → офлайн-состояние (экран 29),
/// прочее — компактный [ErrorState]. Retry в обоих случаях → `refresh()`.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (error is NetworkError) {
      return OfflineState(
        title: l10n.offlineTitleLead,
        titleAccent: l10n.offlineTitleAccent,
        message: l10n.offlineMessage,
        retryLabel: l10n.retry,
        bannerTitle: l10n.offlineBannerTitle,
        bannerStatus: l10n.offlineBannerStatus,
        lastSavedLabel: null,
        onRetry: onRetry,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      child: ErrorState(
        message: l10n.messageForError(error),
        retryLabel: l10n.retry,
        onRetry: onRetry,
      ),
    );
  }
}

/// Данные: сгруппированный по дням список + футер пагинации, в RefreshIndicator.
class _DataView extends StatelessWidget {
  const _DataView({
    required this.state,
    required this.scrollController,
    required this.onRefresh,
    required this.onMarkRead,
    required this.onRetryLoadMore,
  });

  final NotificationsState state;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final void Function(int id) onMarkRead;
  final VoidCallback onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final groups = _groupByDay(state.items, l10n);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: c.primary,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          for (final group in groups) ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: NotificationsGroupHeader(label: group.label),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.separated(
                itemCount: group.items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = group.items[i];
                  return NotificationCard(
                    item: item,
                    onTap: () => onMarkRead(item.id),
                  );
                },
              ),
            ),
          ],
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _Footer(
                state: state,
                onRetryLoadMore: onRetryLoadMore,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  /// Группировка по локальному дню (Сегодня / Вчера / дата) с сохранением
  /// порядка backend (новые сверху): идём по списку, открывая новую группу при
  /// смене календарного дня. `createdAt` приводим к локальной TZ.
  static List<_DayGroup> _groupByDay(
    List<NotificationItem> items,
    AppLocalizations l10n,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateFmt = DateFormat.MMMMd(l10n.localeName);

    final groups = <_DayGroup>[];
    DateTime? curDay;
    for (final item in items) {
      final local = item.createdAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      if (groups.isEmpty || day != curDay) {
        curDay = day;
        final String label;
        if (day == today) {
          label = l10n.notificationsGroupToday;
        } else if (day == yesterday) {
          label = l10n.notificationsGroupYesterday;
        } else {
          label = dateFmt.format(local);
        }
        groups.add(_DayGroup(label: label, items: [item]));
      } else {
        groups.last.items.add(item);
      }
    }
    return groups;
  }
}

class _DayGroup {
  _DayGroup({required this.label, required this.items});
  final String label;
  final List<NotificationItem> items;
}

/// Футер пагинации: ошибка дозагрузки (retry) → индикатор → пусто (конец ленты
/// либо ждём порога автоскролла).
class _Footer extends StatelessWidget {
  const _Footer({
    required this.state,
    required this.onRetryLoadMore,
  });

  final NotificationsState state;
  final VoidCallback onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    if (state.loadMoreError != null) {
      return NotificationsLoadMoreError(onRetry: onRetryLoadMore);
    }
    if (state.isLoadingMore) {
      return const NotificationsLoadMoreIndicator();
    }
    return const SizedBox.shrink();
  }
}
