import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/offline_state.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import 'shopping_providers.dart';
import 'shopping_state.dart';
import 'widgets/shopping_add_sheet.dart';
import 'widgets/shopping_empty.dart';
import 'widgets/shopping_item_tile.dart';

/// Экран 19 «Список покупок».
///
/// Потребляет [shoppingControllerProvider] (`AsyncValue<ShoppingState>`,
/// контракт flutter-coder):
/// - **loading** — skeleton строк;
/// - **error** — [NetworkError] → полноэкранный [OfflineState] (экран 29),
///   прочие [ApiError] → [ErrorState]; retry в обоих → `refresh()`;
/// - **empty** (`state.isEmpty`) → [ShoppingEmpty] с CTA «Добавить позицию»;
/// - **data** — плоский список позиций (порядок backend: некупленные сверху) с
///   pull-to-refresh; чекбокс → `toggleChecked(id)`, удаление (свайп/иконка) →
///   `deleteItem(id)`, строка «Добавить позицию» внизу → шит ввода → `addItem`.
///
/// Ошибки мутаций (toggle/delete) бросаются контроллером — ловим тут и
/// показываем снэкбар. Заголовок-счётчик «N позиций · M куплено» считается из
/// `items` (M = `checked`).
class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final async = ref.watch(shoppingControllerProvider);

    final total = async.value?.items.length ?? 0;
    final bought = total - (async.value?.pendingCount ?? 0);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(total: total, bought: bought),
            Expanded(
              child: async.when(
                loading: () => const _LoadingView(),
                error: (error, _) => _ErrorView(
                  error: error,
                  onRetry: () =>
                      ref.read(shoppingControllerProvider.notifier).refresh(),
                ),
                data: (state) => _DataView(state: state),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: «назад», overline «Список покупок» и серифный счётчик-резюме.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.total, required this.bought});

  final int total;
  final int bought;

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
                  l10n.shoppingTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: c.inkSoft,
                  ),
                ),
              ),
              const SizedBox(width: 44),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              l10n.shoppingHeroSummary(total, bought),
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
      context.go('/profile');
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

/// Loading первичной загрузки: skeleton нескольких строк.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: const [
        _SkeletonRow(),
        SizedBox(height: 10),
        _SkeletonRow(),
        SizedBox(height: 10),
        _SkeletonRow(),
        SizedBox(height: 10),
        _SkeletonRow(),
      ],
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: const [
          SkeletonBox(width: 26, height: 26, radius: 13),
          SizedBox(width: 12),
          Expanded(child: SkeletonBox(height: 14, radius: 7)),
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

/// Данные: список позиций (или пустое состояние) в RefreshIndicator.
/// Мутации делегируются контроллеру; ошибки toggle/delete ловятся и показываются
/// снэкбаром.
class _DataView extends ConsumerWidget {
  const _DataView({required this.state});

  final ShoppingState state;

  Future<void> _refresh(WidgetRef ref) =>
      ref.read(shoppingControllerProvider.notifier).refresh();

  Future<void> _toggle(BuildContext context, WidgetRef ref, int id) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(shoppingControllerProvider.notifier).toggleChecked(id);
    } catch (error) {
      _showError(messenger, l10n.messageForError(error));
    }
  }

  /// Удаляет позицию и сообщает исход вызвавшему (свайпу/иконке).
  ///
  /// Возвращает `true`, только если позиция **реально** ушла из состояния —
  /// тогда `Dismissible` может завершить свайп без рассинхрона. При ошибке
  /// (контроллер бросил `ApiError`, напр. офлайн) показываем снэкбар и
  /// возвращаем `false`. При no-op контроллера (`isMutating` → позиция осталась
  /// в state) тоже `false`, без снэкбара: ничего не произошло, виджет на месте.
  Future<bool> _delete(BuildContext context, WidgetRef ref, int id) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(shoppingControllerProvider.notifier).deleteItem(id);
    } catch (error) {
      _showError(messenger, l10n.messageForError(error));
      return false;
    }

    // Подтверждаем удаление только если позиции действительно нет в state
    // (отсекает no-op контроллера при идущей мутации).
    final stillPresent =
        ref.read(shoppingControllerProvider).value?.items.any((i) => i.id == id) ??
            false;
    if (stillPresent) return false;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.shoppingItemDeleted)));
    return true;
  }

  void _showError(ScaffoldMessengerState messenger, String message) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;

    if (state.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _refresh(ref),
        color: c.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 60),
            ShoppingEmpty(onAdd: () => showShoppingAddSheet(context)),
          ],
        ),
      );
    }

    final items = state.items;
    return RefreshIndicator(
      onRefresh: () => _refresh(ref),
      color: c.primary,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        // Позиции + завершающая строка «Добавить позицию».
        itemCount: items.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _AddRow(onTap: () => showShoppingAddSheet(context));
          }
          final item = items[index];
          return ShoppingItemTile(
            item: item,
            onToggle: () => _toggle(context, ref, item.id),
            onDelete: () => _delete(context, ref, item.id),
          );
        },
      ),
    );
  }
}

/// Пунктирная строка «+ Добавить позицию» внизу списка (как в дизайне 19).
class _AddRow extends StatelessWidget {
  const _AddRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      label: l10n.shoppingAddItem,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.line),
            ),
            child: Row(
              children: [
                Icon(Icons.add_rounded, size: 20, color: c.primary),
                const SizedBox(width: 12),
                Text(
                  l10n.shoppingAddItem,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
