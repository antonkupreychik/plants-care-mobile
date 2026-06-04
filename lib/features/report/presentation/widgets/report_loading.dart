import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import 'report_header.dart';

/// Loading-состояние отчёта: реальная шапка (back + share работают) + кости
/// [SkeletonBox] под раскладку — hero, сетка 2×2 больших чисел и блок тренда.
class ReportLoading extends StatelessWidget {
  const ReportLoading({super.key, required this.onShare});

  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
      children: [
        ReportHeader(onShare: onShare),
        const SizedBox(height: 18),
        // Hero.
        const SkeletonBox(width: 140, height: 14, radius: 7),
        const SizedBox(height: 12),
        const SkeletonBox(width: 240, height: 36),
        const SizedBox(height: 10),
        const SkeletonBox(height: 14),
        const SizedBox(height: 20),
        // Большие числа 2×2.
        Row(
          children: const [
            Expanded(child: _StatSkeleton()),
            SizedBox(width: 10),
            Expanded(child: _StatSkeleton()),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(child: _StatSkeleton()),
            SizedBox(width: 10),
            Expanded(child: _StatSkeleton()),
          ],
        ),
        const SizedBox(height: 24),
        // Тренд.
        const SkeletonBox(height: 120, radius: 22),
      ],
    );
  }
}

class _StatSkeleton extends StatelessWidget {
  const _StatSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      height: 116,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          SkeletonBox(width: 56, height: 32),
          SizedBox(height: 8),
          SkeletonBox(width: 80, height: 12, radius: 6),
        ],
      ),
    );
  }
}
