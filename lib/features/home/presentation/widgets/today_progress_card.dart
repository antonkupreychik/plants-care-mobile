import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../today_view.dart';

/// Прогресс-карточка экрана 03 «Сегодня» (дизайн screens-v2 → TodayScreen).
///
/// Кольцо прогресса `done/total` + подпись «X из N выполнено» / «Осталось K ·
/// M просрочено» + бейдж с числом просроченных (если есть). Чистый stateless:
/// все числа берутся из [TodayView] (`doneCount` / `totalCount` /
/// `remainingCount` / `overdueCount`).
class TodayProgressCard extends StatelessWidget {
  const TodayProgressCard({super.key, required this.view});

  final TodayView view;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final progress = view.totalCount == 0
        ? 0.0
        : (view.doneCount / view.totalCount).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          _ProgressRing(
            progress: progress,
            done: view.doneCount,
            track: c.surfaceWarm,
            fill: c.primary,
            label: c.ink,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.todayProgress(view.doneCount, view.totalCount),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.todayProgressRemaining(view.remainingCount)} · '
                  '${l10n.todayProgressOverdue(view.overdueCount)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: c.inkSoft),
                ),
              ],
            ),
          ),
          if (view.overdueCount > 0) ...[
            const SizedBox(width: 10),
            _OverdueChip(count: view.overdueCount, bg: c.terracotta),
          ],
        ],
      ),
    );
  }
}

/// Круговое кольцо прогресса с числом выполненных в центре.
class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.progress,
    required this.done,
    required this.track,
    required this.fill,
    required this.label,
  });

  final double progress;
  final int done;
  final Color track;
  final Color fill;
  final Color label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(36, 36),
            painter: _RingPainter(progress: progress, track: track, fill: fill),
          ),
          Text(
            '$done',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: label,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.track,
    required this.fill,
  });

  final double progress;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 4.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(center: center, radius: radius);
    // Старт сверху (-90°), по часовой.
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.track != track || old.fill != fill;
}

class _OverdueChip extends StatelessWidget {
  const _OverdueChip({required this.count, required this.bg});

  final int count;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.white),
        ],
      ),
    );
  }
}
