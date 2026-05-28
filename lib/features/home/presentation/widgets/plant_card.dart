import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../plant_card/presentation/widgets/health_ring.dart';
import '../../domain/plant.dart';
import '../plant_illustration.dart';

/// Карточка растения в сетке «Мой сад».
///
/// Кольцо здоровья (G1) показываем справа от имени через [HealthRing]
/// (общий `plantHealthProvider` фичи plant_card — established cross-feature
/// паттерн, как [PlantIllustration]). Без mood/voiceLine (G2). Показываем вид
/// (overline), имя (сериф), иллюстрацию по виду и локацию (если есть).
class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plant,
    required this.tintWarm,
    required this.onTap,
  });

  final Plant plant;

  /// Чередование фона плашки иллюстрации (тёплый / мягко-зелёный) — как в дизайне.
  final bool tintWarm;

  /// Тап по карточке (пока no-op/snackbar — маршрут /plant/:id в фиче 02).
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: c.line),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plant.speciesName != null)
                Text(
                  plant.speciesName!.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: c.inkSoft,
                  ),
                ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.serif(fontSize: 22, color: c.ink),
                    ),
                  ),
                  const SizedBox(width: 6),
                  HealthRing(plantId: plant.id),
                ],
              ),
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: tintWarm ? c.surfaceWarm : c.primarySoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: PlantIllustration(
                    speciesName: plant.speciesName,
                    size: 96,
                  ),
                ),
              ),
              if (plant.locationName != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.place_outlined, size: 14, color: c.inkMute),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        plant.locationName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: c.inkSoft),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PlantCardSkeleton extends StatelessWidget {
  const PlantCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.all(14),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 60, height: 10),
          SizedBox(height: 6),
          SkeletonBox(width: 90, height: 20),
          SizedBox(height: 10),
          AspectRatio(aspectRatio: 1, child: SkeletonBox(radius: 18)),
        ],
      ),
    );
  }
}
