import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/care_history_entry.dart';
import '../care_event_kind_l10n.dart';

/// Секция «Дневник ухода»: лента истории ([CareHistoryEntry]).
///
/// Записи приходят отсортированными backend — порядок не меняем. Время
/// `performedAt` приходит в UTC, показываем в локальной TZ (`.toLocal()`).
/// Пустой список → дружелюбная подпись (не голая карточка).
class PlantJournalCard extends StatelessWidget {
  const PlantJournalCard({super.key, required this.entries});

  final List<CareHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    if (entries.isEmpty) {
      return _JournalShell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(Icons.history_rounded, size: 28, color: c.inkMute),
              const SizedBox(height: 10),
              Text(
                l10n.plantCardJournalEmpty,
                textAlign: TextAlign.center,
                style: AppTheme.serif(fontSize: 20, color: c.ink),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.plantCardJournalEmptyHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
              ),
            ],
          ),
        ),
      );
    }

    return _JournalShell(
      child: Column(
        children: List.generate(entries.length, (i) {
          return _JournalRow(entry: entries[i], showDivider: i > 0);
        }),
      ),
    );
  }
}

/// Skeleton секции дневника (loading).
class PlantJournalCardSkeleton extends StatelessWidget {
  const PlantJournalCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _JournalShell(
      child: Column(
        children: [
          _JournalRowSkeleton(),
          SizedBox(height: 16),
          _JournalRowSkeleton(),
          SizedBox(height: 16),
          _JournalRowSkeleton(),
        ],
      ),
    );
  }
}

class _JournalShell extends StatelessWidget {
  const _JournalShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: child,
    );
  }
}

class _JournalRow extends StatelessWidget {
  const _JournalRow({required this.entry, required this.showDivider});

  final CareHistoryEntry entry;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final local = entry.performedAt.toLocal();
    final dateLabel = l10n.plantCardHistoryDate(
      DateFormat.MMMd(l10n.localeName).format(local),
      DateFormat.Hm(l10n.localeName).format(local),
    );

    return Column(
      children: [
        if (showDivider) Divider(height: 1, color: c.line),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(entry.kind.icon, size: 16, color: c.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            entry.kind.doneLabel(l10n),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: c.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateLabel,
                          style: TextStyle(fontSize: 11, color: c.inkSoft),
                        ),
                      ],
                    ),
                    if (entry.onTime) ...[
                      const SizedBox(height: 4),
                      _OnTimeBadge(label: l10n.plantCardJournalOnTime),
                    ],
                    if (entry.note != null && entry.note!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        entry.note!,
                        style: TextStyle(
                          fontSize: 12,
                          color: c.inkSoft,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnTimeBadge extends StatelessWidget {
  const _OnTimeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 12, color: c.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalRowSkeleton extends StatelessWidget {
  const _JournalRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(width: 32, height: 32, radius: 16),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 120, height: 13),
              SizedBox(height: 6),
              SkeletonBox(width: 80, height: 11),
            ],
          ),
        ),
      ],
    );
  }
}
