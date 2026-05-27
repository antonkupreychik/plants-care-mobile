import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/domain/plant.dart';
import '../../../home/presentation/plant_illustration.dart';

/// Hero-шапка карточки растения: иллюстрация по виду на тёплой плашке,
/// затем имя (сериф), overline «вид · локация» и подпись «со мной …».
///
/// Сознательно БЕЗ кольца/бейджа здоровья (BACKEND-GAPS G1 — поля healthScore
/// нет) и БЕЗ реплики-настроения (G2 — voiceLine генерится не из данных;
/// экран 01 её тоже не показывает, повторяем решение, чтобы не выдумывать
/// данные). Длительность владения — формат по `createdAt` (UI-форматирование
/// уже имеющейся даты, не доменный расчёт).
class PlantHero extends StatelessWidget {
  const PlantHero({super.key, required this.plant, required this.now});

  final Plant plant;

  /// Текущий момент (локальная TZ) для вычисления «со мной …».
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final overline = [
      if (plant.speciesName != null && plant.speciesName!.trim().isNotEmpty)
        plant.speciesName!.trim(),
      if (plant.locationName != null && plant.locationName!.trim().isNotEmpty)
        plant.locationName!.trim(),
    ].join(' · ');

    final ageLabel = _ageLabel(l10n, plant.createdAt, now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Иллюстрация на мягкой плашке (hero).
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: c.primarySoft,
            borderRadius: BorderRadius.circular(28),
          ),
          alignment: Alignment.center,
          child: PlantIllustration(speciesName: plant.speciesName, size: 180),
        ),
        const SizedBox(height: 18),
        if (overline.isNotEmpty)
          Text(
            overline.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: c.inkSoft,
            ),
          ),
        const SizedBox(height: 4),
        Text(
          plant.name,
          style: AppTheme.serif(fontSize: 36, color: c.ink),
        ),
        if (ageLabel != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  ageLabel,
                  style: TextStyle(fontSize: 13, color: c.inkSoft),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Форматирует длительность владения из [createdAt]. Это UI-форматирование
  /// уже имеющейся даты (не доменный расчёт расписаний): годы / месяцы / дни.
  static String? _ageLabel(
    AppLocalizations l10n,
    DateTime? createdAt,
    DateTime now,
  ) {
    if (createdAt == null) return null;
    final from = createdAt.toLocal();
    if (from.isAfter(now)) return null;
    final days = now.difference(from).inDays;

    final String duration;
    if (days >= 365) {
      duration = l10n.plantCardAgeYears(days ~/ 365);
    } else if (days >= 30) {
      duration = l10n.plantCardAgeMonths(days ~/ 30);
    } else {
      duration = l10n.plantCardAgeDays(days);
    }
    return l10n.plantCardWithMeFor(duration);
  }
}

/// Skeleton hero-шапки (loading-состояние секции детали).
class PlantHeroSkeleton extends StatelessWidget {
  const PlantHeroSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 1.6,
            child: SkeletonBox(radius: 28),
          ),
        ),
        SizedBox(height: 18),
        SkeletonBox(width: 160, height: 12),
        SizedBox(height: 8),
        SkeletonBox(width: 200, height: 32),
        SizedBox(height: 10),
        SkeletonBox(width: 140, height: 13),
      ],
    );
  }
}
