import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/api_error_l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/quiet_time.dart';
import '../quiet_hours_controller.dart';

/// Какое поле тихих часов редактирует пикер 36.
enum QuietHoursField { start, end }

/// Шаг минут на колесе пикера (00 / 15 / 30 / 45, как в дизайне 36).
const List<int> _kMinuteSteps = [0, 15, 30, 45];

/// Открывает bottom-sheet «Пикер времени» (экран 36) для поля [field].
///
/// [initial] — текущее значение из драфта (стартовая позиция колёс). Применение
/// идёт через контроллер: `setQuietStart/​setQuietEnd` + `save()` (см.
/// [_QuietTimePickerSheet]). Возвращает `void` — результат живёт в контроллере,
/// не в `Navigator.pop` (контракт coder'а).
Future<void> showQuietTimePickerSheet(
  BuildContext context, {
  required QuietHoursField field,
  required QuietTime initial,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _QuietTimePickerSheet(field: field, initial: initial),
  );
}

class _QuietTimePickerSheet extends ConsumerStatefulWidget {
  const _QuietTimePickerSheet({required this.field, required this.initial});

  final QuietHoursField field;
  final QuietTime initial;

  @override
  ConsumerState<_QuietTimePickerSheet> createState() =>
      _QuietTimePickerSheetState();
}

class _QuietTimePickerSheetState
    extends ConsumerState<_QuietTimePickerSheet> {
  late int _hour = widget.initial.hour;
  // Стартовый шаг минут — ближайший к текущему (драфт мог прийти как 22:07).
  late int _minuteIndex = _nearestMinuteIndex(widget.initial.minute);

  late final FixedExtentScrollController _hourCtrl =
      FixedExtentScrollController(initialItem: _hour);
  late final FixedExtentScrollController _minuteCtrl =
      FixedExtentScrollController(initialItem: _minuteIndex);

  bool _saving = false;

  static int _nearestMinuteIndex(int minute) {
    var best = 0;
    var bestDiff = 60;
    for (var i = 0; i < _kMinuteSteps.length; i++) {
      final diff = (minute - _kMinuteSteps[i]).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = i;
      }
    }
    return best;
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  Future<void> _onDone() async {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);
    final value = QuietTime(hour: _hour, minute: _kMinuteSteps[_minuteIndex]);
    final controller = ref.read(quietHoursControllerProvider.notifier);
    switch (widget.field) {
      case QuietHoursField.start:
        controller.setQuietStart(value);
      case QuietHoursField.end:
        controller.setQuietEnd(value);
    }

    setState(() => _saving = true);
    final error = await controller.save();
    if (!mounted) return;

    if (error == null) {
      Navigator.of(context).pop();
    } else {
      // Напр. start == end → 400: остаёмся в шите, показываем снэкбар.
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.messageForError(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final isStart = widget.field == QuietHoursField.start;
    final overline =
        isStart ? l10n.timePickerStartOverline : l10n.timePickerEndOverline;
    final title =
        isStart ? l10n.timePickerStartTitle : l10n.timePickerEndTitle;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              overline.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: c.inkSoft,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: AppTheme.serif(fontSize: 26, color: c.ink)),
            const SizedBox(height: 12),
            _Wheels(
              hourController: _hourCtrl,
              minuteController: _minuteCtrl,
              selectedHour: _hour,
              selectedMinuteIndex: _minuteIndex,
              onHour: (h) => setState(() => _hour = h),
              onMinuteIndex: (i) => setState(() => _minuteIndex = i),
            ),
            const SizedBox(height: 16),
            _DoneButton(saving: _saving, onPressed: _saving ? null : _onDone),
          ],
        ),
      ),
    );
  }
}

/// Два колеса: часы 00..23 и минуты 00/15/30/45, с подсветкой центра и «:».
class _Wheels extends StatelessWidget {
  const _Wheels({
    required this.hourController,
    required this.minuteController,
    required this.selectedHour,
    required this.selectedMinuteIndex,
    required this.onHour,
    required this.onMinuteIndex,
  });

  final FixedExtentScrollController hourController;
  final FixedExtentScrollController minuteController;
  final int selectedHour;
  final int selectedMinuteIndex;
  final ValueChanged<int> onHour;
  final ValueChanged<int> onMinuteIndex;

  static const double _itemExtent = 44;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final selectedStyle = AppTheme.serif(fontSize: 28, color: c.ink);
    final mutedStyle = AppTheme.serif(fontSize: 24, color: c.inkMute);

    return SizedBox(
      height: _itemExtent * 5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Подсветка центральной (выбранной) строки.
          Container(
            height: _itemExtent,
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 90,
                child: _Wheel(
                  controller: hourController,
                  count: 24,
                  selectedIndex: selectedHour,
                  onSelected: onHour,
                  labelOf: (i) => i.toString().padLeft(2, '0'),
                  selectedStyle: selectedStyle,
                  mutedStyle: mutedStyle,
                  itemExtent: _itemExtent,
                ),
              ),
              SizedBox(
                width: 24,
                child: Center(
                  child: Text(':', style: selectedStyle),
                ),
              ),
              SizedBox(
                width: 90,
                child: _Wheel(
                  controller: minuteController,
                  count: _kMinuteSteps.length,
                  selectedIndex: selectedMinuteIndex,
                  onSelected: onMinuteIndex,
                  labelOf: (i) => _kMinuteSteps[i].toString().padLeft(2, '0'),
                  selectedStyle: selectedStyle,
                  mutedStyle: mutedStyle,
                  itemExtent: _itemExtent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.controller,
    required this.count,
    required this.selectedIndex,
    required this.onSelected,
    required this.labelOf,
    required this.selectedStyle,
    required this.mutedStyle,
    required this.itemExtent,
  });

  final FixedExtentScrollController controller;
  final int count;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final String Function(int index) labelOf;
  final TextStyle selectedStyle;
  final TextStyle mutedStyle;
  final double itemExtent;

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      scrollController: controller,
      itemExtent: itemExtent,
      childCount: count,
      onSelectedItemChanged: onSelected,
      selectionOverlay: const SizedBox.shrink(),
      itemBuilder: (context, index) => Center(
        // Центральный (выбранный) пункт — тёмным акцентом, остальные — приглушены.
        child: Text(
          labelOf(index),
          style: index == selectedIndex ? selectedStyle : mutedStyle,
        ),
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton({required this.saving, required this.onPressed});

  final bool saving;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: l10n.timePickerDone,
      child: Material(
        color: c.fab,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 52),
            alignment: Alignment.center,
            child: saving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: c.fabInk,
                    ),
                  )
                : Text(
                    l10n.timePickerDone,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.fabInk,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
