import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Пустое состояние родословной: у растения нет ни родителя, ни отводков.
class FamilyEmpty extends StatelessWidget {
  const FamilyEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 40, 22, 24),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: c.surfaceWarm,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.spa_outlined, size: 32, color: c.inkMute),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.plantFamilyEmptyTitle,
            textAlign: TextAlign.center,
            style: AppTheme.serif(fontSize: 24, color: c.ink),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.plantFamilyEmptyBody,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.4, color: c.inkSoft),
          ),
        ],
      ),
    );
  }
}
