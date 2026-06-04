import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Горизонтальная лента фильтр-чипов каталога (экран 12, `screens-v4`).
///
/// Чипы: «Все», «Для новичка», «Безопасно для котов 🐈», «Цветущие».
///
/// СТАТУС функциональности (issue #80, п.1): backend-контракт `GET /species`
/// поддерживает только подстрочный поиск (`q`), отдельных серверных фильтров
/// «новичок/коты/цветущие» нет. Поэтому активен только чип «Все» (он же —
/// фактический текущий режим списка); категорийные чипы рендерятся как
/// дизайн-плейсхолдеры (приглушены, не тапаются), пока на бэкенде не появится
/// параметр фильтрации. Это явно разрешённый issue вариант «UI без функции».
/// Счётчик показываем только у «Все» (реальный `total`); фейковых чисел из
/// макета (12/8/6) не выдумываем — их источника на бэкенде нет.
class CatalogFilterChips extends StatelessWidget {
  const CatalogFilterChips({super.key, required this.total});

  /// Общее число видов под текущим запросом — счётчик чипа «Все».
  /// `null` — данные ещё не загружены (счётчик скрываем).
  final int? total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final items = <_ChipData>[
      _ChipData(label: l10n.catalogFilterAll, count: total, active: true),
      _ChipData(label: l10n.catalogFilterBeginner),
      _ChipData(label: l10n.catalogFilterPetSafe),
      _ChipData(label: l10n.catalogFilterFlowering),
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) => _Chip(data: items[i]),
      ),
    );
  }
}

class _ChipData {
  const _ChipData({required this.label, this.count, this.active = false});

  final String label;
  final int? count;
  final bool active;
}

class _Chip extends StatelessWidget {
  const _Chip({required this.data});

  final _ChipData data;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final fg = data.active ? c.surface : c.ink;
    // Неактивные (категорийные) чипы — пока декоративные плейсхолдеры: чуть
    // приглушаем, чтобы не выглядели как рабочие фильтры.
    final opacity = data.active ? 1.0 : 0.55;

    return Opacity(
      opacity: opacity,
      child: Semantics(
        button: data.active,
        selected: data.active,
        label: data.count != null ? '${data.label}, ${data.count}' : data.label,
        child: Container(
          decoration: BoxDecoration(
            color: data.active ? c.ink : c.chipBg,
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              if (data.count != null) ...[
                const SizedBox(width: 6),
                Text(
                  '${data.count}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: fg.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
