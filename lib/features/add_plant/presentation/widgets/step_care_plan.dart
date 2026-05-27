import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/species_summary.dart';
import 'care_plan_preview.dart';
import 'wizard_chrome.dart';

/// Шаг 3 мастера: read-only превью плана ухода по выбранному виду.
///
/// Ничего не редактируется и не персистится — это рекомендация по виду
/// (backend не сохраняет расписания, см. BACKEND-GAPS). Если вид не выбран —
/// нейтральная подсказка.
class StepCarePlan extends StatelessWidget {
  const StepCarePlan({super.key, required this.species});

  /// Выбранный вид (null → вид не выбирали на шаге 1).
  final SpeciesSummary? species;

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
        const SizedBox(height: 12),
        _ReadOnlyNotice(text: l10n.addPlantCarePlanReadOnly),
        const SizedBox(height: 18),
        if (species == null)
          CarePlanHint(message: l10n.addPlantCarePlanEmpty)
        else if (plan.isEmpty)
          CarePlanHint(message: l10n.addPlantCarePlanNone)
        else
          CarePlanPreview(items: plan),
        // Лёгкий хвост, чтобы карточки не липли к панели действий.
        SizedBox(height: 8, child: ColoredBox(color: c.bg)),
      ],
    );
  }
}

/// Бейдж-пометка «рекомендация, изменить нельзя».
class _ReadOnlyNotice extends StatelessWidget {
  const _ReadOnlyNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, size: 16, color: c.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: c.ink, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
