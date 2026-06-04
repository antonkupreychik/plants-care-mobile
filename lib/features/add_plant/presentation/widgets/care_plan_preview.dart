import 'package:flutter/material.dart';

import '../../../../core/care/care_task_l10n.dart';
import '../../../../core/care/care_task_type.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/value_stepper.dart';
import '../../domain/care_plan_item.dart';

/// Редактируемый список типов ухода: иконка, подпись и степпер интервала.
///
/// Стартовые значения — рекомендации из вида ([CarePlanItem.everyDays]).
/// Изменённые хранятся в [overrides]; [onIntervalChanged] вызывается при
/// каждом тапе ±1. Клампинг (>= 1) — в контроллере.
class CarePlanPreview extends StatelessWidget {
  const CarePlanPreview({
    super.key,
    required this.items,
    required this.overrides,
    required this.onIntervalChanged,
  });

  final List<CarePlanItem> items;

  /// Пользовательские оверрайды (ключ — тип, значение — дни).
  final Map<CareTaskType, int> overrides;

  /// Вызывается при изменении степпера: тип + новое значение в днях.
  final void Function(CareTaskType, int) onIntervalChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          _CarePlanCard(
            item: items[i],
            currentEvery: overrides[items[i].type] ?? items[i].everyDays,
            onIntervalChanged: onIntervalChanged,
          ),
          if (i != items.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _CarePlanCard extends StatelessWidget {
  const _CarePlanCard({
    required this.item,
    required this.currentEvery,
    required this.onIntervalChanged,
  });

  final CarePlanItem item;
  final int currentEvery;
  final void Function(CareTaskType, int) onIntervalChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.type.icon, size: 20, color: c.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.type.label(l10n),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: c.line),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.editScheduleEvery,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
              ),
              ValueStepper(
                valueLabel: l10n.editScheduleDaysUnit(currentEvery),
                decrementSemantics:
                    '${l10n.editScheduleEvery} ${l10n.editScheduleDaysUnit(currentEvery - 1)}',
                incrementSemantics:
                    '${l10n.editScheduleEvery} ${l10n.editScheduleDaysUnit(currentEvery + 1)}',
                onDecrement: currentEvery <= 1
                    ? null
                    : () => onIntervalChanged(item.type, currentEvery - 1),
                onIncrement: () => onIntervalChanged(item.type, currentEvery + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Нейтральная подсказка-плейсхолдер на месте плана ухода (вид не выбран или у
/// вида нет интервалов).
class CarePlanHint extends StatelessWidget {
  const CarePlanHint({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Icon(Icons.spa_outlined, size: 22, color: c.inkMute),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
