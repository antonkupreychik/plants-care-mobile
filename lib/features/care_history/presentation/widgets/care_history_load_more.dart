import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Кнопка «Показать ещё» — ручная дозагрузка следующей страницы истории.
/// Видна при `hasMore && !isLoadingMore && loadMoreError == null`.
class CareHistoryLoadMoreButton extends StatelessWidget {
  const CareHistoryLoadMoreButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: c.ink,
            minimumSize: const Size(0, 48),
            side: BorderSide(color: c.line),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            textStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(l10n.careHistoryLoadMore),
        ),
      ),
    );
  }
}

/// Индикатор активной дозагрузки следующей страницы (`isLoadingMore`).
class CareHistoryLoadMoreIndicator extends StatelessWidget {
  const CareHistoryLoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: c.primary),
        ),
      ),
    );
  }
}

/// Плашка ошибки дозагрузки страницы (`loadMoreError != null`): текст + повтор.
/// Показанный список при этом сохраняется.
class CareHistoryLoadMoreError extends StatelessWidget {
  const CareHistoryLoadMoreError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              l10n.careHistoryLoadMoreError,
              style: TextStyle(fontSize: 13, color: c.inkSoft),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(l10n.retry),
            style: TextButton.styleFrom(
              foregroundColor: c.primary,
              minimumSize: const Size(0, 48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}
