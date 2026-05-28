import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Пустое состояние экрана «Архив»: аккуратная заглушка без карточек и
/// ретроспективы (показывается, когда `view.plants.isEmpty`).
class ArchiveEmpty extends StatelessWidget {
  const ArchiveEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 36, color: c.leaf),
          const SizedBox(height: 14),
          Text(
            l10n.archiveEmpty,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.archiveEmptyHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
          ),
        ],
      ),
    );
  }
}
