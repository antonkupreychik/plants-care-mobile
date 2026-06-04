import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Виджет выбора месяца для экрана отчёта (экран 14).
///
/// Отображает `[ < ]  <Месяц год>  [ > ]` по дизайну:
/// - `<` (prevMonth) — всегда активен, если [canGoPrev].
/// - `>` (nextMonth) — задизейблен, если [canGoNext] == false (текущий месяц).
/// - Метка — локализованное название месяца + год (`MMM yyyy`), по-русски.
///
/// Виджет **не** работает с провайдерами напрямую: получает колбэки и флаги
/// от экрана, следуя принципу «виджет без бизнес-логики» (FLUTTER.md).
class ReportMonthPicker extends StatelessWidget {
  const ReportMonthPicker({
    super.key,
    required this.month,
    required this.canGoPrev,
    required this.canGoNext,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  /// Выбранный месяц в формате `YYYY-MM`.
  final String month;

  /// Можно ли перейти на предыдущий месяц.
  final bool canGoPrev;

  /// Можно ли перейти на следующий месяц (false → на текущем месяце).
  final bool canGoNext;

  /// Колбэк перехода на предыдущий месяц.
  final VoidCallback onPrevMonth;

  /// Колбэк перехода на следующий месяц.
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final label = _formatMonthLabel(month);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavArrow(
          icon: Icons.chevron_left_rounded,
          semanticsLabel: l10n.reportPrevMonth,
          enabled: canGoPrev,
          onTap: onPrevMonth,
          colors: c,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: c.ink,
          ),
        ),
        const SizedBox(width: 4),
        _NavArrow(
          icon: Icons.chevron_right_rounded,
          semanticsLabel: l10n.reportNextMonth,
          enabled: canGoNext,
          onTap: onNextMonth,
          colors: c,
        ),
      ],
    );
  }

  /// Форматирует `YYYY-MM` → `«Май 2026»` (первая буква заглавная, ru).
  static String _formatMonthLabel(String yyyyMM) {
    final parts = yyyyMM.split('-');
    final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]));
    final formatted = DateFormat('MMM yyyy', 'ru').format(dt);
    // Делаем первую букву заглавной (DateFormat ru даёт строчную).
    if (formatted.isEmpty) return formatted;
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({
    required this.icon,
    required this.semanticsLabel,
    required this.enabled,
    required this.onTap,
    required this.colors,
  });

  final IconData icon;
  final String semanticsLabel;
  final bool enabled;
  final VoidCallback onTap;
  final PcColors colors;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      enabled: enabled,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: enabled ? colors.line : colors.line.withValues(alpha: 0.4),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              icon,
              size: 18,
              color: enabled
                  ? colors.ink
                  : colors.ink.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}
