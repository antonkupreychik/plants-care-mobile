import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Изогнутая пунктирная стрелка-связь «родитель → потомок» (как в дизайне
/// экрана 18). Чисто декоративная, исключена из дерева семантики.
class FamilyConnector extends StatelessWidget {
  const FamilyConnector({super.key, this.size = const Size(44, 76)});

  final Size size;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return ExcludeSemantics(
      child: CustomPaint(
        size: size,
        painter: _ConnectorPainter(color: c.primary),
      ),
    );
  }
}

class _ConnectorPainter extends CustomPainter {
  _ConnectorPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final midY = size.height / 2;

    // Дугообразная связь слева направо.
    final path = Path()
      ..moveTo(size.width * 0.1, midY)
      ..quadraticBezierTo(
        size.width * 0.5,
        midY - size.height * 0.25,
        size.width * 0.9,
        midY,
      );
    _drawDashed(canvas, path, paint);

    // Наконечник стрелки справа.
    final arrow = Path()
      ..moveTo(size.width * 0.74, midY - 6)
      ..lineTo(size.width * 0.9, midY)
      ..lineTo(size.width * 0.74, midY + 6);
    canvas.drawPath(arrow, paint);
  }

  /// Рисует [source] пунктиром (3px штрих / 4px пропуск).
  void _drawDashed(Canvas canvas, Path source, Paint paint) {
    const dash = 3.0;
    const gap = 4.0;
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_ConnectorPainter oldDelegate) =>
      oldDelegate.color != color;
}
