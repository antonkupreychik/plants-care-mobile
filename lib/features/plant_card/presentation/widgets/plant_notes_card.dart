import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Секция «Заметки» пользователя о растении. Рисуется только когда заметка
/// есть — пустую секцию не показываем (вызывающий экран решает по `notes`).
class PlantNotesCard extends StatelessWidget {
  const PlantNotesCard({super.key, required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.plantCardNotesTitle.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: c.inkSoft,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            notes,
            style: TextStyle(fontSize: 14, color: c.ink, height: 1.45),
          ),
        ],
      ),
    );
  }
}
