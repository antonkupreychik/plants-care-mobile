import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/tokens.dart';

/// Унифицированная кнопка «Назад» для экранов вне таб-бара.
///
/// Стратегия: если стек непуст — [context.pop()]; иначе — [context.go(fallback)].
/// Это гарантирует, что пользователь никогда не выходит из приложения случайно
/// при deep link или прямом открытии экрана.
///
/// По умолчанию [fallback] = `/home`; экраны, логически привязанные к другой
/// ветке (например, `/profile`), передают нужный маршрут явно.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    required this.tooltip,
    this.fallback = '/home',
    this.onPressed,
  });

  /// Текст для accessibility / Tooltip.
  final String tooltip;

  /// Маршрут go_router, на который переходим при пустом стеке.
  final String fallback;

  /// Опциональный кастомный обработчик. Если задан — заменяет логику
  /// pop/go целиком (используется для экранов с несохранёнными изменениями).
  final VoidCallback? onPressed;

  void _defaultOnPressed(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(fallback);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: c.surface,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed ?? () => _defaultOnPressed(context),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Icon(Icons.arrow_back_rounded, size: 22, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// Вспомогательная функция — единый обработчик «назад» без виджета.
///
/// Используется в колбэках вида `onPressed: () => navigateBack(context)`.
/// [fallback] — маршрут при пустом стеке, по умолчанию `/home`.
void navigateBack(BuildContext context, {String fallback = '/home'}) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallback);
  }
}
