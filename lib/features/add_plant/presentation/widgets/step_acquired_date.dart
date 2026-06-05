import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Шаг 5 мастера: «Когда завели {name}?» — дата приобретения растения.
///
/// Предлагает 5 вариантов быстрого выбора через chips:
/// - «Сегодня» → DateTime.now()
/// - «На этой неделе» → now - 3 дня
/// - «Месяц назад» → now - 30 дней
/// - «Раньше» → открывает DatePicker (только прошлые даты)
/// - «Пропустить» → acquiredAt = null
///
/// Шаг опционален: кнопка «Пропустить» всегда доступна.
class StepAcquiredDate extends StatelessWidget {
  const StepAcquiredDate({
    super.key,
    required this.plantName,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onSkip,
  });

  /// Имя растения для заголовка «Когда завели {name}?».
  final String plantName;

  /// Текущая выбранная дата (null → не выбрано / пропущено).
  final DateTime? selectedDate;

  /// Коллбэк при выборе даты (или null — пропуск).
  final ValueChanged<DateTime?> onDateSelected;

  /// Коллбэк кнопки «Пропустить» — переходит дальше без выбора.
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок
        Text(
          l10n.addPlantStepAcquiredTitle(plantName),
          style: TextStyle(
            fontFamily: 'InstrumentSerif',
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: c.ink,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 32),

        // Chips быстрого выбора
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _DateChip(
              label: l10n.addPlantStepAcquiredToday,
              selected: _isSameDay(selectedDate, now),
              onTap: () => onDateSelected(now),
            ),
            _DateChip(
              label: l10n.addPlantStepAcquiredThisWeek,
              selected: _isSameDay(selectedDate, now.subtract(const Duration(days: 3))),
              onTap: () => onDateSelected(now.subtract(const Duration(days: 3))),
            ),
            _DateChip(
              label: l10n.addPlantStepAcquiredMonthAgo,
              selected: _isSameDay(selectedDate, now.subtract(const Duration(days: 30))),
              onTap: () => onDateSelected(now.subtract(const Duration(days: 30))),
            ),
            _DateChip(
              label: l10n.addPlantStepAcquiredEarlier,
              selected: selectedDate != null &&
                  !_isSameDay(selectedDate!, now) &&
                  !_isSameDay(selectedDate!, now.subtract(const Duration(days: 3))) &&
                  !_isSameDay(selectedDate!, now.subtract(const Duration(days: 30))),
              onTap: () => _openDatePicker(context, now),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Если дата выбрана через DatePicker — показываем выбранную дату
        if (selectedDate != null &&
            !_isSameDay(selectedDate!, now) &&
            !_isSameDay(selectedDate!, now.subtract(const Duration(days: 3))) &&
            !_isSameDay(selectedDate!, now.subtract(const Duration(days: 30))))
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              _formatDate(selectedDate!),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: c.primary,
              ),
            ),
          ),

        // Кнопка «Пропустить»
        GestureDetector(
          onTap: () {
            onDateSelected(null);
            onSkip();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.addPlantStepAcquiredSkip,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: c.inkSoft,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openDatePicker(BuildContext context, DateTime now) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  bool _isSameDay(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? c.primary : c.surface,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: selected ? c.primary : c.inkSoft.withAlpha(51),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : c.ink,
          ),
        ),
      ),
    );
  }
}
