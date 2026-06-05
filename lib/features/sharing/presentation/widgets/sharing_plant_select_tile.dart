import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../home/domain/plant.dart';
import '../../../home/presentation/plant_illustration.dart';

/// Строка выбора растения для приглашения (экран 26): иллюстрация, имя/вид,
/// чекбокс. Рамка подсвечивается при выборе.
class SharingPlantSelectTile extends StatelessWidget {
  const SharingPlantSelectTile({
    super.key,
    required this.plant,
    required this.selected,
    required this.onToggle,
  });

  final Plant plant;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      checked: selected,
      label: plant.name,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: selected ? c.primarySoft : c.line),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: c.surfaceWarm,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: PlantIllustration(
                    speciesName: plant.speciesName,
                    size: 38,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: c.ink,
                        ),
                      ),
                      if (plant.speciesName != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          plant.speciesName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: c.inkSoft),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _Checkbox(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: selected ? c.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        border: selected ? null : Border.all(color: c.line, width: 2),
      ),
      alignment: Alignment.center,
      child: selected
          ? Icon(Icons.check_rounded, size: 16, color: c.surface)
          : null,
    );
  }
}
