import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Индикатор активной дозагрузки следующей страницы ленты (`isLoadingMore`).
class NotificationsLoadMoreIndicator extends StatelessWidget {
  const NotificationsLoadMoreIndicator({super.key});

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
/// Показанный список при этом сохраняется (контроллер не уходит в AsyncError).
class NotificationsLoadMoreError extends StatelessWidget {
  const NotificationsLoadMoreError({super.key, required this.onRetry});

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
              l10n.notificationsLoadMoreError,
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
