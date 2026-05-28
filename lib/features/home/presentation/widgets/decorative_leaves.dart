import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Декоративные листья на фоне карточки пустого сада (экран 10).
/// Перенос фонового SVG из `screens-v3.jsx` (строки 812–820): два листа по
/// нижне-левому и верхне-правому углам с opacity ~0.20, на токенах
/// [PcColors.leaf] / [PcColors.leafDark]. Чисто декоративный слой.
class DecorativeLeaves extends StatelessWidget {
  const DecorativeLeaves({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Positioned.fill(
      child: IgnorePointer(
        // Прозрачность запекаем в цвет пейнтера (alpha 0.20), а не через
        // Opacity — последний форсит saveLayer/offscreen-буфер на перерисовку.
        child: CustomPaint(painter: _LeavesPainter(c)),
      ),
    );
  }
}

class _LeavesPainter extends CustomPainter {
  const _LeavesPainter(this.c);

  final PcColors c;

  @override
  void paint(Canvas canvas, Size size) {
    // Декоративная прозрачность ~0.20 запечена прямо в цвет (без Opacity).
    final fill = Paint()..style = PaintingStyle.fill;

    // Лист в нижне-левом углу (translate(-20, h) rotate(-30)).
    canvas.save();
    canvas.translate(-20, size.height);
    canvas.rotate(-30 * math.pi / 180);
    fill.color = c.leaf.withValues(alpha: 0.20);
    canvas.drawPath(_leaf(scale: 1.0), fill);
    canvas.restore();

    // Лист в верхне-правом углу (translate(w+20, 30) rotate(45)).
    canvas.save();
    canvas.translate(size.width + 20, 30);
    canvas.rotate(45 * math.pi / 180);
    fill.color = c.leafDark.withValues(alpha: 0.20);
    canvas.drawPath(_leaf(scale: 1.1), fill);
    canvas.restore();
  }

  /// Силуэт листа из дизайна (path по кривым Безье), масштабируемый.
  Path _leaf({required double scale}) {
    double v(double x) => x * scale;
    return Path()
      ..moveTo(v(0), v(0))
      ..cubicTo(v(-30), v(-20), v(-50), v(-70), v(-40), v(-130))
      ..cubicTo(v(0), v(-130), v(40), v(-90), v(50), v(-30))
      ..cubicTo(v(50), v(-10), v(30), v(8), v(0), v(0))
      ..close();
  }

  @override
  bool shouldRepaint(covariant _LeavesPainter old) => old.c != c;
}
