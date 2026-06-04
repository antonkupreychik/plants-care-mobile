import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../plant_card/domain/care_event_kind.dart';
import '../../../plant_card/presentation/care_event_kind_l10n.dart';

/// Горизонтальная лента фильтр-чипов экрана 21 по типу ухода.
///
/// Чипы: Всё / Полив / Опрыскивание / Подкормка. Счётчики считаются в UI по
/// УЖЕ ЗАГРУЖЕННЫМ записям (`entries`) — это отображение, не доменная логика.
/// Чип типа с нулевым счётчиком скрывается, кроме активного (иначе непонятно,
/// какой фильтр включён). «Всё» видна всегда. `null` в [active] = «Всё».
class CareHistoryFilterChips extends StatelessWidget {
  const CareHistoryFilterChips({
    super.key,
    required this.totalLoaded,
    required this.countByKind,
    required this.active,
    required this.onSelected,
  });

  /// Сколько записей загружено всего (счётчик «Всё»).
  final int totalLoaded;

  /// Число загруженных записей по каждому типу.
  final Map<CareEventKind, int> countByKind;

  /// Активный фильтр; `null` — «Всё».
  final CareEventKind? active;

  final ValueChanged<CareEventKind?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Только содержательные типы (без unknown в виде отдельного чипа — он
    // попадает под «Всё», отдельной кнопки для него нет).
    const kinds = [
      CareEventKind.water,
      CareEventKind.spray,
      CareEventKind.fertilize,
    ];

    final entries = <(CareEventKind?, String, int)>[
      (null, l10n.careHistoryFilterAll, totalLoaded),
      for (final k in kinds) (k, k.doneLabel(l10n), countByKind[k] ?? 0),
    ];

    final visible = entries
        .where((e) => e.$1 == null || e.$3 > 0 || e.$1 == active)
        .toList(growable: false);

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: visible.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (kind, label, count) = visible[i];
          return _Chip(
            label: label,
            count: count,
            selected: kind == active,
            onTap: () => onSelected(kind),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final fg = selected ? c.surface : c.ink;

    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      child: Material(
        color: selected ? c.ink : c.chipBg,
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
