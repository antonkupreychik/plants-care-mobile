import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';

/// Секция результатов поиска (issue #69): заголовок с количеством + кнопка
/// «Показать все», тело — skeleton (loading) / результаты (data) / тихо
/// сворачивается, если результатов нет.
///
/// Каждая секция (растения / виды / болезни) рисует своё состояние независимо
/// от остальных, потребляя отдельный провайдер на уровне экрана.
class SearchSection extends StatelessWidget {
  const SearchSection({
    super.key,
    required this.title,
    required this.isLoading,
    required this.count,
    required this.onShowAll,
    required this.children,
  });

  final String title;
  final bool isLoading;

  /// Число найденных элементов (для бейджа `(N)`). Игнорируется при [isLoading].
  final int count;

  /// Тап по кнопке «Показать все» (видна только при `count > 0`).
  final VoidCallback onShowAll;

  /// Готовые плитки результатов (пусто при загрузке/отсутствии результатов).
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                color: c.inkSoft,
              ),
            ),
            if (!isLoading && count > 0) ...[
              const SizedBox(width: 6),
              Text(
                '($count)',
                style: TextStyle(fontSize: 13, color: c.inkMute),
              ),
            ],
            const Spacer(),
            if (!isLoading && count > 0)
              TextButton(
                onPressed: onShowAll,
                style: TextButton.styleFrom(
                  foregroundColor: c.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 40),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.searchShowAll,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (isLoading)
          const _SectionSkeleton()
        else
          ...children,
      ],
    );
  }
}

/// Skeleton секции: пара «костей» под плитки результатов.
class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SkeletonBox(height: 52, radius: 16),
        SizedBox(height: 8),
        SkeletonBox(height: 52, radius: 16),
      ],
    );
  }
}
