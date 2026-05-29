import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';

/// Полноэкранный скелетон холодного старта Home (экран 28).
///
/// Повторяет посекционную раскладку [HomeScreen] «костями» из [SkeletonBox]
/// (header → карточка «Сегодня» → заголовок секции → сетка 2×2), а внизу по
/// центру — росток «🌱» и курсивная подпись «Собираю твой сад…».
///
/// Скелетон не скроллится: верхний блок прокручиваемых секций обёрнут в
/// [SingleChildScrollView] (`NeverScrollableScrollPhysics` — статика, без
/// инерции) исключительно чтобы на низких экранах вместо overflow контент
/// мягко обрезался, а подпись внизу удерживалась в безопасной зоне.
class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return ColoredBox(
      color: c.bg,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Прокрутка отключена: на маленьких экранах низ скелетона уходит
            // под подпись, overflow исключён физикой и clip-ом.
            const SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderBones(),
                  _TodayCardBones(),
                  _SectionTitleBones(),
                  _GridBones(),
                  SizedBox(height: 96),
                ],
              ),
            ),

            // Росток + курсивная подпись — закреплены у нижнего края.
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 8),
                  Text(
                    l10n.homeLoadingCaption,
                    textAlign: TextAlign.center,
                    style: AppTheme.serif(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: c.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Кости шапки: круг-аватар + полоса имени, две квадратные кнопки справа;
/// ниже — надзаголовок и крупный заголовок-приветствие.
class _HeaderBones extends StatelessWidget {
  const _HeaderBones();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 20, 22, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 36, height: 36, radius: 12),
              SizedBox(width: 10),
              SkeletonBox(width: 96, height: 16),
              Spacer(),
              SkeletonBox(width: 40, height: 40, radius: 14),
              SizedBox(width: 6),
              SkeletonBox(width: 40, height: 40, radius: 14),
            ],
          ),
          SizedBox(height: 18),
          SkeletonBox(width: 120, height: 12),
          SizedBox(height: 10),
          SkeletonBox(width: 200, height: 34, radius: 12),
        ],
      ),
    );
  }
}

/// Кость карточки «Сегодня»: заголовок + бейдж, прогресс-полоса и две строки
/// задач (иконка + текст + кнопка).
class _TodayCardBones extends StatelessWidget {
  const _TodayCardBones();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: c.line),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 70, height: 12),
                    SizedBox(height: 8),
                    SkeletonBox(width: 110, height: 22),
                  ],
                ),
                SkeletonBox(width: 60, height: 26, radius: 999),
              ],
            ),
            SizedBox(height: 16),
            SkeletonBox(height: 4, radius: 2),
            _TodayTaskRowBones(),
            _TodayTaskRowBones(),
          ],
        ),
      ),
    );
  }
}

class _TodayTaskRowBones extends StatelessWidget {
  const _TodayTaskRowBones();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          SkeletonBox(width: 48, height: 48, radius: 16),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.55,
                  child: SkeletonBox(height: 14),
                ),
                SizedBox(height: 6),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.8,
                  child: SkeletonBox(height: 11),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          SkeletonBox(width: 84, height: 32, radius: 999),
        ],
      ),
    );
  }
}

/// Кости надзаголовка + заголовка секции «Мой сад».
class _SectionTitleBones extends StatelessWidget {
  const _SectionTitleBones();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 22, 22, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 70, height: 12),
          SizedBox(height: 8),
          SkeletonBox(width: 140, height: 22),
        ],
      ),
    );
  }
}

/// Сетка 2×2 карточек-костей растений.
class _GridBones extends StatelessWidget {
  const _GridBones();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _PlantCardBone(),
          _PlantCardBone(),
          _PlantCardBone(),
          _PlantCardBone(),
        ],
      ),
    );
  }
}

class _PlantCardBone extends StatelessWidget {
  const _PlantCardBone();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.6,
            child: SkeletonBox(height: 10),
          ),
          SizedBox(height: 8),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.8,
            child: SkeletonBox(height: 20),
          ),
          SizedBox(height: 10),
          Expanded(child: SkeletonBox(height: double.infinity, radius: 18)),
          SizedBox(height: 10),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.5,
            child: SkeletonBox(height: 12),
          ),
        ],
      ),
    );
  }
}
