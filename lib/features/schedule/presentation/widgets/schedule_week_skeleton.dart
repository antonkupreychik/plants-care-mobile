import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';

/// Skeleton недельного графика (loading-состояние): hero-заголовок + 7
/// строк-плейсхолдеров дней. Хедер недели рисуется отдельно (он доступен и в
/// loading), поэтому здесь только тело.
class ScheduleWeekSkeleton extends StatelessWidget {
  const ScheduleWeekSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SkeletonBox(width: 220, height: 30),
        const SizedBox(height: 8),
        const SkeletonBox(width: 160, height: 14),
        const SizedBox(height: 18),
        ...List.generate(7, (i) {
          return Container(
            decoration: i < 6
                ? BoxDecoration(
                    border: Border(bottom: BorderSide(color: c.line)),
                  )
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: const Row(
              children: [
                SizedBox(
                  width: 44,
                  child: Column(
                    children: [
                      SkeletonBox(width: 24, height: 10),
                      SizedBox(height: 4),
                      SkeletonBox(width: 28, height: 22),
                    ],
                  ),
                ),
                SizedBox(width: 14),
                Expanded(child: SkeletonBox(height: 14)),
              ],
            ),
          );
        }),
      ],
    );
  }
}
