import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Маленький степпер «− значение +» для интервала/объёма (экран 22).
///
/// Чистый презентационный виджет: не знает доменной логики, лишь рисует
/// готовый [valueLabel] и зовёт [onDecrement]/[onIncrement] (клампинг —
/// в контроллере). Кнопки disabled (`null` колбэк) рисуются приглушённо;
/// [dim] дополнительно гасит весь степпер для выключенной карточки (контролы
/// доступны, но визуально тусклее — как в дизайне).
class ValueStepper extends StatelessWidget {
  const ValueStepper({
    super.key,
    required this.valueLabel,
    required this.onDecrement,
    required this.onIncrement,
    required this.decrementSemantics,
    required this.incrementSemantics,
    this.dim = false,
  });

  /// Готовая локализованная подпись значения (например «7 дн.» / «200 мл»).
  final String valueLabel;

  /// Колбэки шага. `null` — кнопка заблокирована (например на нижней границе).
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  /// Semantics-подписи для кнопок (доступность иконочных кнопок).
  final String decrementSemantics;
  final String incrementSemantics;

  /// Приглушить степпер (карточка выключена).
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final content = Container(
      decoration: BoxDecoration(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove_rounded,
            onPressed: onDecrement,
            semanticsLabel: decrementSemantics,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 64),
            child: Text(
              valueLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: c.ink,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            onPressed: onIncrement,
            semanticsLabel: incrementSemantics,
          ),
        ],
      ),
    );
    return dim ? Opacity(opacity: 0.55, child: content) : content;
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
    required this.semanticsLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final enabled = onPressed != null;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Semantics(
            button: true,
            enabled: enabled,
            label: semanticsLabel,
            child: Icon(
              icon,
              size: 20,
              color: enabled ? c.ink : c.inkMute,
            ),
          ),
        ),
      ),
    );
  }
}
