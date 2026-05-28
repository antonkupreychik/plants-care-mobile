import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/plant_health.dart';
import '../plant_card_providers.dart';
import 'health_zone_color.dart';

/// Мини-кольцо здоровья (G1) на карточке растения в сетке Home (01).
///
/// Потребляет общий `plantHealthProvider(plantId)` (family/autoDispose) — тот же,
/// что бейдж на карточке 02. Health — декоративная доп-инфа, поэтому НЕ ломает
/// карточку: на ошибке кольцо тихо исчезает, на загрузке — нейтральный серый
/// плейсхолдер, при недостатке данных — серое кольцо с «—».
class HealthRing extends ConsumerWidget {
  const HealthRing({super.key, required this.plantId, this.size = 26});

  final int plantId;

  /// Внешний диаметр кольца (на карточке Home ≈ 26).
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(plantHealthProvider(plantId));

    return health.when(
      // error → health тихо скрываем, карточка живёт (декоративная доп-инфа).
      error: (_, _) => SizedBox(width: size, height: size),
      loading: () => _RingPlaceholder(size: size),
      data: (h) => h.hasReliableScore
          ? _ScoredRing(size: size, health: h)
          : _RingPlaceholder(size: size, showDash: true),
    );
  }
}

/// Нейтральное кольцо: серый ободок без дуги. Loading (без «—») и недостаток
/// данных (с «—»).
class _RingPlaceholder extends StatelessWidget {
  const _RingPlaceholder({required this.size, this.showDash = false});

  final double size;
  final bool showDash;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: showDash ? l10n.healthSemanticUnknown : null,
      child: CustomPaint(
        size: Size.square(size),
        painter: _HealthRingPainter(
          progress: 1,
          arcColor: c.surfaceWarm,
          trackColor: c.surfaceWarm,
          centerColor: c.surface,
        ),
        child: SizedBox.square(
          dimension: size,
          child: showDash
              ? Center(
                  child: Text(
                    '—',
                    style: TextStyle(
                      fontSize: size * 0.36,
                      fontWeight: FontWeight.w700,
                      color: c.inkMute,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// Кольцо с достоверным score: дуга на score% цветом зоны + число в центре.
class _ScoredRing extends StatelessWidget {
  const _ScoredRing({required this.size, required this.health});

  final double size;
  final PlantHealth health;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    // hasReliableScore (call-site) гарантирует zone/score != null.
    final score = health.score!;
    final zoneColor = health.zone!.foreground(c);
    return Semantics(
      label: l10n.healthSemanticScore(score),
      child: CustomPaint(
        size: Size.square(size),
        painter: _HealthRingPainter(
          progress: (score / 100).clamp(0.0, 1.0),
          arcColor: zoneColor,
          trackColor: c.surfaceWarm,
          centerColor: c.surface,
        ),
        child: SizedBox.square(
          dimension: size,
          child: Center(
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: size * 0.36,
                fontWeight: FontWeight.w700,
                color: zoneColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Рисует кольцо: трек на 360°, поверх — дуга прогресса от 12 часов по часовой,
/// внутри — кружок [centerColor] (под число). Толщина пропорциональна размеру.
class _HealthRingPainter extends CustomPainter {
  const _HealthRingPainter({
    required this.progress,
    required this.arcColor,
    required this.trackColor,
    required this.centerColor,
  });

  final double progress;
  final Color arcColor;
  final Color trackColor;
  final Color centerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final stroke = size.width * 0.135;
    final ringRadius = radius - stroke / 2;
    final rect = Rect.fromCircle(center: center, radius: ringRadius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = trackColor;
    canvas.drawCircle(center, ringRadius, trackPaint);

    if (progress > 0) {
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = arcColor;
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        arcPaint,
      );
    }

    // Внутренний кружок-подложка под число.
    final centerPaint = Paint()..color = centerColor;
    canvas.drawCircle(center, ringRadius - stroke / 2, centerPaint);
  }

  @override
  bool shouldRepaint(_HealthRingPainter old) =>
      old.progress != progress ||
      old.arcColor != arcColor ||
      old.trackColor != trackColor ||
      old.centerColor != centerColor;
}
