import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';

/// Loading-состояние экрана «Архив»: кнопка «назад» + шапка-заглушка +
/// несколько skeleton-карточек растений.
class ArchiveLoading extends StatelessWidget {
  const ArchiveLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: _ArchiveHeaderSkeleton(),
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < 3; i++) ...[
          const _ArchiveCardSkeleton(),
          if (i < 2) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ArchiveHeaderSkeleton extends StatelessWidget {
  const _ArchiveHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: true,
          label: l10n.archiveBack,
          child: Material(
            color: c.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: c.line),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () =>
                  context.canPop() ? context.pop() : context.go('/profile'),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const SkeletonBox(width: 120, height: 12),
        const SizedBox(height: 10),
        const SkeletonBox(width: 180, height: 32),
        const SizedBox(height: 12),
        const SkeletonBox(width: double.infinity, height: 14),
      ],
    );
  }
}

class _ArchiveCardSkeleton extends StatelessWidget {
  const _ArchiveCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 80, height: 96, radius: 18),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 120, height: 20),
                SizedBox(height: 8),
                SkeletonBox(width: 80, height: 12),
                SizedBox(height: 14),
                SkeletonBox(width: double.infinity, height: 12),
                SizedBox(height: 12),
                SkeletonBox(width: 140, height: 12),
                SizedBox(height: 14),
                Row(
                  children: [
                    SkeletonBox(width: 90, height: 24, radius: 8),
                    SizedBox(width: 6),
                    SkeletonBox(width: 70, height: 24, radius: 8),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
