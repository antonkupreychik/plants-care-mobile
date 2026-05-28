import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Центральная иллюстрация пустого сада (экран 10): пустой горшок с крошечным
/// ростком, солнечное пятно и спаркл. Перенос SVG из дизайн-референса
/// (`screens-v3.jsx`, строки 824–841) на [CustomPaint] и токены [PcColors].
///
/// В отличие от [PlantIllustration] (готовые ботанические SVG-ассеты «под
/// светлую тему»), этот элемент рисуется из токенов и корректно следует теме.
class EmptyPotIllustration extends StatelessWidget {
  const EmptyPotIllustration({super.key, this.size = 160});

  final double size;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _EmptyPotPainter(c),
        // Статичная картинка: репейнт только при смене палитры → разрешаем
        // движку закэшировать растр (isComplex без willChange — половинчато).
        isComplex: true,
        willChange: false,
      ),
    );
  }
}

class _EmptyPotPainter extends CustomPainter {
  const _EmptyPotPainter(this.c);

  final PcColors c;

  @override
  void paint(Canvas canvas, Size size) {
    // viewBox 160×160 в дизайне → масштабируем под фактический размер.
    final s = size.width / 160.0;
    double x(double v) => v * s;
    double y(double v) => v * s;

    final fill = Paint()..style = PaintingStyle.fill;

    // sun spot — два круга
    fill.color = c.primarySoft.withValues(alpha: 0.6);
    canvas.drawCircle(Offset(x(118), y(32)), x(22), fill);
    fill.color = c.primary.withValues(alpha: 0.4);
    canvas.drawCircle(Offset(x(118), y(32)), x(10), fill);

    // soil shadow
    fill.color = c.potShadow.withValues(alpha: 0.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x(80), y(92)), width: x(68), height: y(12)),
      fill,
    );

    // tiny seedling stem
    final stem = Paint()
      ..color = c.leafDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = x(2.5)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x(80), y(92)), Offset(x(80), y(78)), stem);

    // two leaves (rotated ellipses)
    fill.color = c.leaf;
    _rotatedOval(canvas, fill, cx: x(74), cy: y(78), rx: x(8), ry: y(4), deg: -30);
    _rotatedOval(canvas, fill, cx: x(86), cy: y(76), rx: x(9), ry: y(4.5), deg: 30);

    // pot body
    final pot = Path()
      ..moveTo(x(50), y(92))
      ..lineTo(x(110), y(92))
      ..lineTo(x(104), y(142))
      ..quadraticBezierTo(x(102), y(150), x(94), y(150))
      ..lineTo(x(66), y(150))
      ..quadraticBezierTo(x(58), y(150), x(56), y(142))
      ..close();
    fill.color = c.pot;
    canvas.drawPath(pot, fill);

    // pot rim shadow
    fill.color = c.potShadow;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x(80), y(92)), width: x(60), height: y(8)),
      fill,
    );

    // sparkle (cross)
    final sparkle = Paint()
      ..color = c.terracotta
      ..style = PaintingStyle.stroke
      ..strokeWidth = x(2)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x(118), y(58)), Offset(x(118), y(70)), sparkle);
    canvas.drawLine(Offset(x(112), y(64)), Offset(x(124), y(64)), sparkle);
  }

  void _rotatedOval(
    Canvas canvas,
    Paint paint, {
    required double cx,
    required double cy,
    required double rx,
    required double ry,
    required double deg,
  }) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(deg * math.pi / 180);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _EmptyPotPainter old) => old.c != c;
}
