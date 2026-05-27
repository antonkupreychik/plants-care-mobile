import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../home/presentation/plant_illustration.dart';
import '../../domain/species_detail.dart';
import 'species_meta_row.dart';

/// Hero детали вида: крупная иллюстрация на плашке, имя (сериф), латынь
/// (курсив) и строка метаданных (сложность/свет).
class SpeciesHero extends StatelessWidget {
  const SpeciesHero({super.key, required this.detail});

  final SpeciesDetail detail;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.4,
          child: Container(
            decoration: BoxDecoration(
              color: c.surfaceWarm,
              borderRadius: BorderRadius.circular(28),
            ),
            alignment: Alignment.center,
            child: PlantIllustration(
              speciesName: detail.latinName ?? detail.name,
              size: 150,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          detail.name,
          style: AppTheme.serif(fontSize: 34, color: c.ink),
        ),
        if (detail.latinName != null) ...[
          const SizedBox(height: 4),
          Text(
            detail.latinName!,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: c.inkSoft,
            ),
          ),
        ],
        const SizedBox(height: 12),
        SpeciesMetaRow(
          difficulty: detail.careDifficulty,
          light: detail.lightPreference,
        ),
      ],
    );
  }
}

/// Скелетон hero детали вида.
class SpeciesHeroSkeleton extends StatelessWidget {
  const SpeciesHeroSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(aspectRatio: 1.4, child: SkeletonBox(radius: 28)),
        SizedBox(height: 18),
        SkeletonBox(width: 180, height: 30),
        SizedBox(height: 10),
        SkeletonBox(width: 120, height: 14),
        SizedBox(height: 14),
        SkeletonBox(width: 160, height: 12),
      ],
    );
  }
}
