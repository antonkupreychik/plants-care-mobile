import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../home/presentation/plant_illustration.dart';

/// Hero-иллюстрация прайминга: мягкий круг-фон, растение и бейдж-колокольчик
/// с точкой-индикатором (экран 27, `PushPermissionScreen`).
class PushPrimingHero extends StatelessWidget {
  const PushPrimingHero({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: c.primarySoft.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
          const PlantIllustration(speciesName: 'monstera', size: 160),
          Positioned(
            top: 16,
            right: 28,
            child: Transform.rotate(
              angle: 0.14, // ~8°, как в дизайне
              child: _BellBadge(c: c),
            ),
          ),
        ],
      ),
    );
  }
}

class _BellBadge extends StatelessWidget {
  const _BellBadge({required this.c});

  final PcColors c;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: c.ink,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 26, color: c.fabInk),
          Positioned(
            top: 12,
            right: 14,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: c.terracotta,
                shape: BoxShape.circle,
                border: Border.all(color: c.ink, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
