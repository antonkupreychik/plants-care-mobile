import 'package:flutter/material.dart';

import '../../../../core/care/care_task_type.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/species_summary.dart';
import 'care_plan_preview.dart';
import 'wizard_chrome.dart';

/// Шаг 3 мастера: план ухода с редактируемыми интервалами.
///
/// Степперы стартуют с рекомендаций вида; изменения хранятся в
/// [intervalOverrides] и передаются через [onIntervalChanged] в контроллер.
/// Если вид не выбран — нейтральная подсказка.
class StepCarePlan extends StatelessWidget {
  const StepCarePlan({
    super.key,
    required this.species,
    required this.intervalOverrides,
    required this.onIntervalChanged,
  });

  /// Выбранный вид (null → вид не выбирали на шаге 1).
  final SpeciesSummary? species;

  /// Текущие оверрайды из черновика визарда.
  final Map<CareTaskType, int> intervalOverrides;

  /// Колбэк изменения степпера: тип + новое значение в днях.
  final void Function(CareTaskType, int) onIntervalChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final plan = species?.carePlan ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardStepTitle(
          overline: l10n.addPlantOverline,
          title: l10n.addPlantCarePlanTitle,
          subtitle: l10n.addPlantCarePlanSubtitle,
        ),
        const SizedBox(height: 18),
        if (species == null)
          CarePlanHint(message: l10n.addPlantCarePlanEmpty)
        else if (plan.isEmpty)
          CarePlanHint(message: l10n.addPlantCarePlanNone)
        else
          CarePlanPreview(
            items: plan,
            overrides: intervalOverrides,
            onIntervalChanged: onIntervalChanged,
          ),
        // Лёгкий хвост, чтобы карточки не липли к панели действий.
        SizedBox(height: 8, child: ColoredBox(color: c.bg)),
      ],
    );
  }
}
