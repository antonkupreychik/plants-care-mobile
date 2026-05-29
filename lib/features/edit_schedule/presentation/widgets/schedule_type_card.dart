import 'package:flutter/material.dart';

import '../../../../core/care/care_task_l10n.dart';
import '../../../../core/care/care_task_type.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/plant_care_schedule.dart';
import '../next_due_label.dart';
import 'value_stepper.dart';

/// Шаг изменения объёма воды (мл).
const _kWaterStepMl = 50;

/// Дефолт объёма воды, когда `amountMl == null`, но пользователь жмёт «+».
const _kWaterDefaultMl = 200;

/// Карточка одного типа ухода на экране 22: иконка+подпись типа, строка
/// «Следующий уход · {когда}» (или «Выключено»), тумблер активности, степпер
/// интервала и (для полива) степпер объёма воды.
///
/// Чистая презентация: значения берёт из [schedule] (драфт), действия зовут
/// колбэки экрана (которые дёргают контроллер). Выключенная карточка приглушена
/// (opacity), контролы dim, но доступны — как в дизайне.
class ScheduleTypeCard extends StatelessWidget {
  const ScheduleTypeCard({
    super.key,
    required this.schedule,
    required this.nowLocal,
    required this.saving,
    required this.onToggle,
    required this.onEveryChanged,
    required this.onAmountChanged,
  });

  final PlantCareSchedule schedule;

  /// Текущий момент (локальная TZ) для относительного «следующего ухода».
  final DateTime nowLocal;

  /// Идёт сохранение — блокируем интерактив.
  final bool saving;

  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onEveryChanged;
  final ValueChanged<int?> onAmountChanged;

  bool get _isWatering => schedule.type == CareTaskType.watering;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final enabled = schedule.enabled;

    return Opacity(
      opacity: enabled ? 1 : 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: c.line),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeadRow(
              schedule: schedule,
              nowLocal: nowLocal,
              saving: saving,
              onToggle: onToggle,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Divider(height: 1, thickness: 1, color: c.line),
            ),
            const SizedBox(height: 14),
            // Степпер интервала «Каждые N дн.».
            _ControlRow(
              label: l10n.editScheduleEvery,
              stepper: ValueStepper(
                valueLabel: l10n.editScheduleDaysUnit(schedule.every),
                dim: !enabled,
                decrementSemantics:
                    '${l10n.editScheduleEvery} ${l10n.editScheduleDaysUnit(schedule.every - 1)}',
                incrementSemantics:
                    '${l10n.editScheduleEvery} ${l10n.editScheduleDaysUnit(schedule.every + 1)}',
                onDecrement: saving || schedule.every <= 1
                    ? null
                    : () => onEveryChanged(schedule.every - 1),
                onIncrement:
                    saving ? null : () => onEveryChanged(schedule.every + 1),
              ),
            ),
            // Объём воды — только для полива.
            if (_isWatering) ...[
              const SizedBox(height: 12),
              _ControlRow(
                label: l10n.editScheduleWaterAmount,
                stepper: _amountStepper(l10n, saving: saving, enabled: enabled),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _amountStepper(
    AppLocalizations l10n, {
    required bool saving,
    required bool enabled,
  }) {
    final amount = schedule.amountMl;
    final label = amount == null
        ? l10n.editScheduleAmountUnset
        : l10n.editScheduleMlUnit(amount);
    final current = amount ?? _kWaterDefaultMl;
    return ValueStepper(
      valueLabel: label,
      dim: !enabled,
      decrementSemantics: l10n.editScheduleWaterAmount,
      incrementSemantics: l10n.editScheduleWaterAmount,
      onDecrement: saving || current - _kWaterStepMl < 0
          ? null
          : () => onAmountChanged(current - _kWaterStepMl),
      onIncrement:
          saving ? null : () => onAmountChanged(current + _kWaterStepMl),
    );
  }
}

/// Верхняя строка карточки: иконка типа, подпись + «Следующий уход», тумблер.
class _HeadRow extends StatelessWidget {
  const _HeadRow({
    required this.schedule,
    required this.nowLocal,
    required this.saving,
    required this.onToggle,
  });

  final PlantCareSchedule schedule;
  final DateTime nowLocal;
  final bool saving;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final enabled = schedule.enabled;
    final due = enabled ? nextDueLabel(l10n, schedule.nextDueAt, nowLocal) : null;
    final isUrgent = due == l10n.editScheduleDueToday ||
        due == l10n.editScheduleDueOverdue;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: c.surfaceWarm,
            borderRadius: BorderRadius.circular(13),
          ),
          alignment: Alignment.center,
          child: Icon(schedule.type.icon, size: 19, color: c.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.type.label(l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: c.ink,
                ),
              ),
              const SizedBox(height: 1),
              if (!enabled)
                Text(
                  l10n.editScheduleDisabled,
                  style: TextStyle(fontSize: 11, color: c.inkSoft),
                )
              else if (due != null)
                Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 11, color: c.inkSoft),
                    children: [
                      TextSpan(text: '${l10n.editScheduleNextCare} · '),
                      TextSpan(
                        text: due,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isUrgent ? c.terracotta : c.ink,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Semantics(
          label: schedule.type.label(l10n),
          toggled: enabled,
          child: Switch(
            value: enabled,
            onChanged: saving ? null : onToggle,
            activeThumbColor: c.surface,
            activeTrackColor: c.primary,
          ),
        ),
      ],
    );
  }
}

/// Строка «подпись слева — степпер справа».
class _ControlRow extends StatelessWidget {
  const _ControlRow({required this.label, required this.stepper});

  final String label;
  final Widget stepper;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
        ),
        const SizedBox(width: 10),
        stepper,
      ],
    );
  }
}
