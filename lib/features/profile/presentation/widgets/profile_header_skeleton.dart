import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';

/// Skeleton шапки и статистики профиля на время загрузки `profileSummary`.
/// Повторяет геометрию [ProfileHeader] + [ProfileStats], чтобы переход
/// loading → data не «прыгал».
class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SkeletonBox(width: 56, height: 56, radius: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 140, height: 18),
                SizedBox(height: 8),
                SkeletonBox(width: 180, height: 13),
                SizedBox(height: 6),
                SkeletonBox(width: 110, height: 13),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 76,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.line),
          ),
        ),
      ],
    );
  }
}
