import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/diagnosis_issue.dart';
import '../../domain/diagnosis_severity.dart';

/// Секция «Проблемы»: заголовок-капс + список карточек проблем.
class IssuesList extends StatelessWidget {
  const IssuesList({super.key, required this.issues});

  final List<DiagnosisIssue> issues;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок секции uppercase
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: Text(
            l10n.diagnosisTitleIssues.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: c.inkSoft,
            ),
          ),
        ),
        ...issues.map((issue) => _IssueCard(issue: issue)),
      ],
    );
  }
}

/// Карточка одной проблемы: title + severity badge + code.
class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.issue});

  final DiagnosisIssue issue;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final (badgeColor, badgeBg) = _severityColors(issue.severity, c);
    final severityLabel = _severityLabel(issue.severity, l10n);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        label: '${issue.title}, $severityLabel',
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      issue.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _SeverityBadge(
                    label: severityLabel.toUpperCase(),
                    color: badgeColor,
                    backgroundColor: badgeBg,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                issue.code,
                style: TextStyle(
                  fontSize: 11,
                  color: c.inkSoft,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Возвращает (foreground, background) цвет бейджа по severity.
  (Color, Color) _severityColors(DiagnosisSeverity severity, PcColors c) {
    return switch (severity) {
      DiagnosisSeverity.high => (c.terracotta, c.terracotta.withValues(alpha: 0.15)),
      DiagnosisSeverity.medium => (c.amberFg, c.amberBg),
      DiagnosisSeverity.low => (c.leaf, c.leafLight.withValues(alpha: 0.25)),
      DiagnosisSeverity.unknown => (c.inkMute, c.inkMute.withValues(alpha: 0.12)),
    };
  }

  String _severityLabel(DiagnosisSeverity severity, AppLocalizations l10n) {
    return switch (severity) {
      DiagnosisSeverity.high => l10n.diagnosisSeverityHigh,
      DiagnosisSeverity.medium => l10n.diagnosisSeverityMedium,
      DiagnosisSeverity.low => l10n.diagnosisSeverityLow,
      DiagnosisSeverity.unknown => l10n.diagnosisSeverityUnknown,
    };
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: color,
          height: 1.2,
        ),
      ),
    );
  }
}

/// Skeleton-карточки при загрузке диагноза.
class IssuesListSkeleton extends StatelessWidget {
  const IssuesListSkeleton({super.key, this.count = 2});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (_) => const _IssueCardSkeleton(),
      ),
    );
  }
}

class _IssueCardSkeleton extends StatelessWidget {
  const _IssueCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: c.inkMute.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
