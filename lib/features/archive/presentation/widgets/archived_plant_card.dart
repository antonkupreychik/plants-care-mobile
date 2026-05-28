import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/plant_illustration.dart';
import '../../domain/archived_plant.dart';

/// Карточка архивного (memorial) растения на экране 17.
///
/// Row[ приглушённая иллюстрация 80×96 + контент ]. Контент: серифное имя +
/// дата справа, вид, divider, строка срока жизни с точкой-маркером,
/// italic-заметка о причине, два coming-soon чипа.
class ArchivedPlantCard extends StatelessWidget {
  const ArchivedPlantCard({
    super.key,
    required this.plant,
    required this.onComingSoon,
  });

  final ArchivedPlant plant;

  /// Тап по чипам «Открыть дневник»/«Вспомнить» (целевых эндпоинтов нет).
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MemorialIllustration(speciesName: plant.speciesName),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        plant.name,
                        style: AppTheme.serif(fontSize: 22, color: c.ink),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        plant.archivedDateLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: c.inkSoft,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  plant.speciesName,
                  style: TextStyle(fontSize: 12, color: c.inkSoft),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _LivedRow(plant: plant),
                const SizedBox(height: 4),
                Text(
                  '«${plant.cause}»',
                  style: AppTheme.serif(
                    fontSize: 13,
                    color: c.inkSoft,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _ArchiveChip(
                      label: l10n.archiveOpenDiary,
                      onTap: onComingSoon,
                    ),
                    _ArchiveChip(
                      label: l10n.archiveRemember,
                      onTap: onComingSoon,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Иллюстрация вида на тёплой плашке, приглушённая под memorial-эффект:
/// grayscale (десатурация через [ColorFilter.matrix]) + лёгкая прозрачность.
class _MemorialIllustration extends StatelessWidget {
  const _MemorialIllustration({required this.speciesName});

  final String speciesName;

  /// Матрица десатурации (~0.7): смешивает исходные каналы с яркостью.
  /// При amount=1 — полный grayscale; здесь оставляем 30% исходного цвета.
  static const _grayscale = ColorFilter.matrix(<double>[
    0.2126 * 0.7 + 0.3, 0.7152 * 0.7, 0.0722 * 0.7, 0, 0, //
    0.2126 * 0.7, 0.7152 * 0.7 + 0.3, 0.0722 * 0.7, 0, 0, //
    0.2126 * 0.7, 0.7152 * 0.7, 0.0722 * 0.7 + 0.3, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: 80,
      height: 96,
      decoration: BoxDecoration(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Opacity(
        opacity: 0.85,
        child: ColorFiltered(
          colorFilter: _grayscale,
          child: PlantIllustration(speciesName: speciesName, size: 72),
        ),
      ),
    );
  }
}

/// Строка «Прожил{о} рядом · `livedLabel`» с точкой-маркером.
/// gifted → primary + «Прожил» (без «о»); иначе terracotta + «Прожило».
class _LivedRow extends StatelessWidget {
  const _LivedRow({required this.plant});

  final ArchivedPlant plant;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final prefix =
        plant.gifted ? l10n.archiveLivedPrefixGifted : l10n.archiveLivedPrefix;
    final dotColor = plant.gifted ? c.primary : c.terracotta;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$prefix '),
                  TextSpan(
                    text: plant.livedLabel,
                    style: TextStyle(
                      color: c.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 11, color: c.inkSoft),
            ),
          ),
        ],
      ),
    );
  }
}

/// Чип на тёплой плашке (coming-soon), тап-зона ≥ 44dp по высоте контейнера.
class _ArchiveChip extends StatelessWidget {
  const _ArchiveChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 32),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
