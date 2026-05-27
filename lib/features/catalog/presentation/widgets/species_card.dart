import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../home/presentation/plant_illustration.dart';
import '../../domain/species.dart';
import 'species_meta_row.dart';

/// Карточка-строка вида в списке каталога (экран 12).
///
/// Композиция из дизайна (`screens-v4`, экран 12): слева плашка с ботанической
/// иллюстрацией (подбор по имени, как в саду), справа — имя (сериф), латынь
/// (курсив, приглушённо) и строка метаданных (сложность/свет), шеврон.
class SpeciesCard extends StatelessWidget {
  const SpeciesCard({super.key, required this.species, required this.onTap});

  final Species species;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.line),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: c.surfaceWarm,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: PlantIllustration(
                  speciesName: species.latinName ?? species.name,
                  size: 60,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      species.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.serif(fontSize: 22, color: c.ink),
                    ),
                    if (species.latinName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        species.latinName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: c.inkSoft,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    SpeciesMetaRow(
                      difficulty: species.careDifficulty,
                      light: species.lightPreference,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, size: 22, color: c.inkMute),
            ],
          ),
        ),
      ),
    );
  }
}

/// Скелетон строки вида для loading-состояния списка.
class SpeciesCardSkeleton extends StatelessWidget {
  const SpeciesCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.all(14),
      child: const Row(
        children: [
          SkeletonBox(width: 72, height: 72, radius: 18),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBox(width: 120, height: 20),
                SizedBox(height: 8),
                SkeletonBox(width: 90, height: 11),
                SizedBox(height: 10),
                SkeletonBox(width: 140, height: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
