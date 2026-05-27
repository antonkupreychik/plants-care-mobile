import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/locations/garden_location.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';

/// Горизонтальная лента чипов комнат. `null` в [selectedLocationId] = «Все».
///
/// Счётчик у чипа — число растений в локации (считается в UI из уже
/// загруженного списка растений: это не доменная логика, а отображение).
class LocationChips extends StatelessWidget {
  const LocationChips({
    super.key,
    required this.locations,
    required this.plantCountByLocation,
    required this.totalPlants,
    required this.selectedLocationId,
    required this.onSelected,
  });

  final List<GardenLocation> locations;
  final Map<int, int> plantCountByLocation;
  final int totalPlants;
  final int? selectedLocationId;
  final void Function(int? locationId) onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: locations.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _Chip(
              label: l10n.homeLocationAll,
              count: totalPlants,
              active: selectedLocationId == null,
              onTap: () => onSelected(null),
            );
          }
          final loc = locations[index - 1];
          return _Chip(
            label: loc.emoji == null ? loc.name : '${loc.emoji} ${loc.name}',
            count: plantCountByLocation[loc.id] ?? 0,
            active: selectedLocationId == loc.id,
            onTap: () => onSelected(loc.id),
          );
        },
      ),
    );
  }
}

class LocationChipsSkeleton extends StatelessWidget {
  const LocationChipsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, _) =>
            const SkeletonBox(width: 84, height: 36, radius: 999),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final fg = active ? c.surface : c.ink;
    return Material(
      color: active ? c.ink : c.chipBg,
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: fg.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
