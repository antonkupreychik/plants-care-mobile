import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/quiet_time.dart';

/// Кольцо-визуализатор суток (24ч) экрана 23.
///
/// Полный круг — «напоминания идут» ([PcColors.leafDark]); дуга
/// `quietStart → quietEnd` (по часовой, с учётом перехода через полночь) —
/// «тишина» ([PcColors.leafLight]). В центре — время старта/конца и подпись
/// «N часов тишины». Часы откладываются как на циферблате: 0ч сверху, по часовой.
///
/// Длительность тишины ([_quietSpanMinutes]) — чистая презентационная
/// геометрия/формат (как и углы дуги), не доменная логика: ни валидации, ни
/// сети. Совпадение start == end backend отвергает на save (экран 23 покажет
/// снэкбар) — здесь рисуем как «0 часов» без падения.
class QuietHoursRing extends StatelessWidget {
  const QuietHoursRing({
    super.key,
    required this.start,
    required this.end,
  });

  final QuietTime start;
  final QuietTime end;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final quietHours = _quietSpanMinutes(start, end) ~/ 60;

    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Semantics(
          label: l10n.quietHoursRingCount(quietHours),
          child: CustomPaint(
            painter: _RingPainter(
              startMinutes: start.hour * 60 + start.minute,
              endMinutes: end.hour * 60 + end.minute,
              activeColor: c.leafDark,
              quietColor: c.leafLight,
              tickColor: c.surface,
            ),
            child: _RingCenter(start: start, end: end, quietHours: quietHours),
          ),
        ),
      ),
    );
  }
}

/// Минуты «тишины» от [start] до [end] по часовой, с переходом через полночь
/// (22:00 → 08:00 = 600 мин = 10 ч). Равные точки → 0.
int _quietSpanMinutes(QuietTime start, QuietTime end) {
  final s = start.hour * 60 + start.minute;
  final e = end.hour * 60 + end.minute;
  final span = (e - s) % (24 * 60);
  return span < 0 ? span + 24 * 60 : span;
}

class _RingCenter extends StatelessWidget {
  const _RingCenter({
    required this.start,
    required this.end,
    required this.quietHours,
  });

  final QuietTime start;
  final QuietTime end;
  final int quietHours;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Иконка-луна как акцент центра (декоративная).
          Icon(Icons.nightlight_round, size: 22, color: c.leafLight),
          const SizedBox(height: 4),
          ExcludeSemantics(
            child: Text(
              start.format(),
              style: AppTheme.serif(fontSize: 26, color: c.ink),
            ),
          ),
          ExcludeSemantics(
            child: Text(
              end.format(),
              style: AppTheme.serif(fontSize: 26, color: c.ink),
            ),
          ),
          const SizedBox(height: 4),
          ExcludeSemantics(
            child: Text(
              l10n.quietHoursRingCount(quietHours),
              style: TextStyle(fontSize: 11, color: c.inkSoft),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.startMinutes,
    required this.endMinutes,
    required this.activeColor,
    required this.quietColor,
    required this.tickColor,
  });

  final int startMinutes;
  final int endMinutes;
  final Color activeColor;
  final Color quietColor;
  final Color tickColor;

  static const double _stroke = 22;
  static const double _twoPi = 2 * math.pi;

  // Угол точки суток на циферблате: 0ч сверху (-90°), по часовой.
  double _angleOf(int minutes) =>
      -math.pi / 2 + (minutes / (24 * 60)) * _twoPi;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - _stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.butt
      ..color = activeColor;

    // Базовое кольцо «напоминания идут» — полный круг.
    canvas.drawArc(rect, 0, _twoPi, false, activePaint);

    // Дуга тишины start → end (по часовой, с переходом через полночь).
    var sweep =
        ((endMinutes - startMinutes) / (24 * 60)) * _twoPi;
    if (sweep < 0) sweep += _twoPi;
    if (sweep > 0) {
      final quietPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.round
        ..color = quietColor;
      canvas.drawArc(rect, _angleOf(startMinutes), sweep, false, quietPaint);
    }

    // Часовые метки: 0/6/12/18 — короткие риски на кольце.
    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = tickColor;
    for (final hour in const [0, 6, 12, 18]) {
      final a = _angleOf(hour * 60);
      final outer = center +
          Offset(math.cos(a), math.sin(a)) * (radius + _stroke / 2 - 2);
      final inner = center +
          Offset(math.cos(a), math.sin(a)) * (radius - _stroke / 2 + 2);
      canvas.drawLine(inner, outer, tickPaint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.startMinutes != startMinutes ||
      old.endMinutes != endMinutes ||
      old.activeColor != activeColor ||
      old.quietColor != quietColor ||
      old.tickColor != tickColor;
}
