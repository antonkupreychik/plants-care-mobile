import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Индикатор дозагрузки следующей страницы списка каталога.
class CatalogLoadMoreIndicator extends StatelessWidget {
  const CatalogLoadMoreIndicator({super.key});

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

/// Компактная плашка ошибки дозагрузки страницы: текст + кнопка «Повторить».
/// Показанный список при этом сохраняется (ошибка только у футера).
class CatalogLoadMoreError extends StatelessWidget {
  const CatalogLoadMoreError({super.key, required this.onRetry});

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
              l10n.catalogLoadMoreError,
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
