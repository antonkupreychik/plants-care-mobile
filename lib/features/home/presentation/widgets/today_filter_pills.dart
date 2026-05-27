import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../today_filter.dart';
import '../today_view.dart';

/// Горизонтальная лента фильтр-пилюль экрана 03 «Сегодня».
///
/// Пилюли: Всё / Полив / Опрыскивание / Подкормка / Просрочено. Счётчики
/// берутся из [TodayView] (по полному списку, не зависят от активного
/// фильтра). Пилюля с нулевым счётчиком скрывается, кроме «Всё» — она видна
/// всегда. Тап → [onSelected]. Активная подсвечена.
class TodayFilterPills extends StatelessWidget {
  const TodayFilterPills({super.key, required this.view, required this.onSelected});

  final TodayView view;
  final ValueChanged<TodayFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final entries = <(TodayFilter, String, int)>[
      (TodayFilter.all, l10n.todayFilterAll, view.totalCount),
      (TodayFilter.watering, l10n.todayFilterWatering, view.wateringCount),
      (TodayFilter.misting, l10n.todayFilterMisting, view.mistingCount),
      (TodayFilter.fertilizing, l10n.todayFilterFertilizing, view.fertilizingCount),
      (TodayFilter.overdue, l10n.todayFilterOverdue, view.overdueCount),
    ];

    // Скрываем пустые пилюли (кроме «Всё»), но активную не прячем, даже если
    // её счётчик 0 — иначе пользователь не увидит, какой фильтр включён.
    final visible = entries
        .where((e) => e.$1 == TodayFilter.all || e.$3 > 0 || e.$1 == view.filter)
        .toList();

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: visible.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (filter, label, count) = visible[i];
          return _Pill(
            label: label,
            count: count,
            active: filter == view.filter,
            onTap: () => onSelected(filter),
          );
        },
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final fg = active ? c.surface : c.ink;

    return Semantics(
      button: true,
      selected: active,
      label: '$label, $count',
      child: Material(
        color: active ? c.ink : c.chipBg,
        borderRadius: BorderRadius.circular(999),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: fg.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
