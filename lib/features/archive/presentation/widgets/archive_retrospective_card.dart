import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/archive_view.dart';

/// Карточка «Ретроспектива» внизу экрана 17: фон primarySoft, eyebrow,
/// серифный текст со средним сроком жизни и подпись.
class ArchiveRetrospectiveCard extends StatelessWidget {
  const ArchiveRetrospectiveCard({super.key, required this.retrospective});

  final ArchiveRetrospective retrospective;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.archiveRetrospectiveLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              color: c.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.archiveRetrospectiveText(retrospective.averageLivedLabel),
            style: AppTheme.serif(fontSize: 22, color: c.ink).copyWith(
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.archiveRetrospectiveHint,
            style: TextStyle(fontSize: 13, color: c.ink, height: 1.4),
          ),
        ],
      ),
    );
  }
}
