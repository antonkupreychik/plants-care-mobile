import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/light_preference.dart';
import '../../domain/species_detail.dart';

/// Шкала света вида (блок «Свет» по дизайну v5 — LIGHT meter): 4 ступени
/// Тень / Полутень / Рассеянный / Прямое. Активная ступень окрашена `primary`,
/// остальные — `surfaceWarm`. Маппинг [LightPreference] → индекс активной
/// ступени в [_activeIndex].
///
/// Статический текст-описание под шкалой опущен — данных для него в API нет.
/// Если `lightPreference == unknown` — блок не строится (см. [hasData]).
class SpeciesLightMeter extends StatelessWidget {
  const SpeciesLightMeter({super.key, required this.detail});

  final SpeciesDetail detail;

  /// Есть ли распознанное предпочтение света (иначе блок скрываем).
  static bool hasData(SpeciesDetail detail) =>
      detail.lightPreference != LightPreference.unknown;

  /// Индекс активной ступени шкалы (0 — Тень ... 3 — Прямое). Для `unknown`
  /// возвращает null (блок не показывается, см. [hasData]).
  static int? _activeIndex(LightPreference light) => switch (light) {
        LightPreference.shade => 0,
        LightPreference.partialShade => 1,
        LightPreference.brightIndirect => 2,
        LightPreference.fullSun => 3,
        LightPreference.unknown => null,
      };

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final active = _activeIndex(detail.lightPreference);

    final steps = <String>[
      l10n.speciesLightStepShade,
      l10n.speciesLightStepPartial,
      l10n.speciesLightStepIndirect,
      l10n.speciesLightStepDirect,
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == active ? c.primary : c.surfaceWarm,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < steps.length; i++)
                Expanded(
                  child: Text(
                    steps[i],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          i == active ? FontWeight.w700 : FontWeight.w500,
                      color: i == active ? c.primary : c.inkMute,
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
