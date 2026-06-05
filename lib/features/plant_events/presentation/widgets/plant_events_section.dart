import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/api_error_l10n.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../plant_events_providers.dart';
import 'plant_event_tile.dart';

/// Секция «Журнал событий» для карточки растения (02): последние 3 события.
///
/// Грузит [recentPlantEventsProvider] (loading/error/empty/data). Пусто →
/// строка-приглашение с кнопкой добавить. [onAdd] открывает sheet добавления.
class PlantEventsSection extends ConsumerWidget {
  const PlantEventsSection({
    super.key,
    required this.plantId,
    required this.onAdd,
  });

  final int plantId;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recent = ref.watch(recentPlantEventsProvider(plantId));

    return recent.when(
      loading: () => const _SectionShell(child: _SectionSkeleton()),
      error: (error, _) => _SectionShell(
        child: ErrorState(
          message: l10n.messageForError(error),
          retryLabel: l10n.retry,
          onRetry: () => ref.invalidate(recentPlantEventsProvider(plantId)),
          compact: true,
        ),
      ),
      data: (events) {
        if (events.isEmpty) {
          return _SectionShell(child: _EmptyRow(onAdd: onAdd));
        }
        return _SectionShell(
          child: Column(
            children: List.generate(
              events.length,
              (i) => PlantEventTile(event: events[i], showDivider: i > 0),
            ),
          ),
        );
      },
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({required this.child});

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

/// Пустая секция: короткая подпись + кнопка «Добавить событие».
class _EmptyRow extends StatelessWidget {
  const _EmptyRow({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            l10n.plantEventsEmptyTitle,
            style: TextStyle(fontSize: 14, color: c.inkSoft),
          ),
          const SizedBox(height: 12),
          Semantics(
            button: true,
            label: l10n.addPlantEventButton,
            child: Material(
              color: c.primary,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onAdd,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, size: 18, color: c.fabInk),
                      const SizedBox(width: 8),
                      Text(
                        l10n.addPlantEventButton,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.fabInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          _SkeletonRow(),
          SizedBox(height: 16),
          _SkeletonRow(),
        ],
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

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
