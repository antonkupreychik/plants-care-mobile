import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../diagnosis_providers.dart';

/// Hero-секция экрана «Диагноз растения».
///
/// Отображает имя/вид/локацию растения и опциональный badge-предупреждение.
/// Пока [diagnosisPlantProvider] грузится — skeleton. Наличие badge
/// определяется параметром [hasIssues], который передаётся из экрана
/// (уже загруженный диагноз), независимо от загрузки данных растения.
class DiagnosisHero extends ConsumerWidget {
  const DiagnosisHero({
    super.key,
    required this.plantId,
    required this.hasIssues,
    required this.onBack,
  });

  final int plantId;

  /// True — показывать badge «⚠ Что‑то не так» (хотя бы одна проблема).
  final bool hasIssues;

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final plantAsync = ref.watch(diagnosisPlantProvider(plantId));

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final heroBg = isDark ? const Color(0xFF3a2419) : const Color(0xFFFBEFE4);

    return Container(
      color: heroBg,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Кнопка «назад»
          Semantics(
            button: true,
            label: l10n.plantCardBack,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onBack,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.arrow_back_rounded, size: 22),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Горизонтальный layout: иллюстрация + текст
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Карточка-иллюстрация 88×88 с terracotta-border
              _PlantIllustrationCard(color: c.terracotta),
              const SizedBox(width: 16),
              Expanded(
                child: plantAsync.when(
                  loading: () => const _PlantInfoSkeleton(),
                  error: (e, st) => const _PlantInfoSkeleton(),
                  data: (plant) => _PlantInfo(
                    name: plant.name,
                    speciesName: plant.speciesName,
                    locationName: plant.locationName,
                    hasIssues: hasIssues,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Иконка-заглушка растения в рамке.
class _PlantIllustrationCard extends StatelessWidget {
  const _PlantIllustrationCard({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Icon(
        Icons.local_florist_rounded,
        size: 44,
        color: color,
      ),
    );
  }
}

/// Текстовая информация о растении: badge + имя + вид/локация.
class _PlantInfo extends StatelessWidget {
  const _PlantInfo({
    required this.name,
    required this.speciesName,
    required this.locationName,
    required this.hasIssues,
  });

  final String name;
  final String? speciesName;
  final String? locationName;
  final bool hasIssues;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final subtitleParts = <String>[
      if (speciesName != null && speciesName!.trim().isNotEmpty)
        speciesName!.trim(),
      if (locationName != null && locationName!.trim().isNotEmpty)
        locationName!.trim(),
    ];
    final subtitle = subtitleParts.join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasIssues) ...[
          _WarningBadge(label: l10n.diagnosisBadgeWarning, color: c.terracotta),
          const SizedBox(height: 6),
        ],
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.serif(fontSize: 28, color: c.ink),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.3),
          ),
        ],
      ],
    );
  }
}

/// Badge «⚠ Что‑то не так» в terracotta-цвете.
class _WarningBadge extends StatelessWidget {
  const _WarningBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: color,
          height: 1.2,
        ),
      ),
    );
  }
}

/// Skeleton для состояния загрузки данных растения.
class _PlantInfoSkeleton extends StatelessWidget {
  const _PlantInfoSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SkeletonBox(width: 100, height: 18, color: c.inkMute),
        const SizedBox(height: 8),
        _SkeletonBox(width: 160, height: 28, color: c.inkMute),
        const SizedBox(height: 6),
        _SkeletonBox(width: 120, height: 14, color: c.inkMute),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
