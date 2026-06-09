import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';

/// Ряд из [length] ячеек кода (экран 08).
///
/// Рисует буфер [code]: заполненные ячейки — цифрой и primary-рамкой, пустые —
/// точкой и тонкой [PcColors.line]-рамкой. Первая пустая ячейка (позиция ввода)
/// подсвечивается primary-рамкой как «фокус». [length] берётся из ответа
/// backend (`codeLength`).
class AuthCodeCells extends StatelessWidget {
  const AuthCodeCells({super.key, required this.code, this.length = 6});

  final String code;

  /// Сколько ячеек рисовать (длина кода из `telegram/start.codeLength`).
  final int length;

  @override
  Widget build(BuildContext context) {
    final filled = code.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          _Cell(
            char: i < filled ? code[i] : null,
            focused: i == filled,
          ),
        ],
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.char, required this.focused});

  /// Введённая цифра или `null`, если ячейка пустая.
  final String? char;

  /// Текущая позиция ввода (первая пустая) — подсветка рамкой.
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final active = char != null || focused;
    return Container(
      width: 46,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? c.primary : c.line,
          width: active ? 2 : 1,
        ),
      ),
      child: char != null
          ? Text(char!, style: AppTheme.serif(fontSize: 28, color: c.ink))
          : Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: c.inkMute,
                shape: BoxShape.circle,
              ),
            ),
    );
  }
}
