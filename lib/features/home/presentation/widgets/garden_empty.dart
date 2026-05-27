import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../plant_illustration.dart';

/// Дружелюбная заглушка пустого сада (НЕ полноэкранный онбординг — экран 10).
/// Просто пустое состояние секции «Мой сад» с приглашением добавить растение.
class GardenEmpty extends StatelessWidget {
  const GardenEmpty({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PlantIllustration(speciesName: null, size: 96),
          const SizedBox(height: 16),
          Text(
            l10n.homeGardenEmptyTitle,
            textAlign: TextAlign.center,
            style: AppTheme.serif(fontSize: 24, color: c.ink),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.homeGardenEmptyHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(l10n.homeAddPlant),
            style: FilledButton.styleFrom(
              backgroundColor: c.fab,
              foregroundColor: c.fabInk,
              minimumSize: const Size(0, 48),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
