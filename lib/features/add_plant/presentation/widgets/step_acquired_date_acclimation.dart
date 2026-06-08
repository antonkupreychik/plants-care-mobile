import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Шаг 5 мастера (объединённый): «Когда завели {name}?» + «Растение новое?».
///
/// Объединяет бывшие шаги 5 и 6 на одном экране:
///
/// — Верхняя секция: дата приобретения (chips быстрого выбора + DatePicker).
///   Опционально: можно пропустить, не выбрав дату.
///
/// — Нижняя секция: период акклиматизации («Да, только купил» / «Нет, уже
///   адаптировалось»). Опционально: isNew остаётся null до явного выбора.
///
/// Inline-ошибка сабмита (errorMessage) показывается под второй секцией.
class StepAcquiredDateAcclimation extends StatelessWidget {
  const StepAcquiredDateAcclimation({
    super.key,
    required this.plantName,
    required this.selectedDate,
    required this.onDateSelected,
    required this.isNew,
    required this.onIsNewChanged,
    this.errorMessage,
  });

  /// Имя растения для заголовка «Когда завели {name}?».
  final String plantName;

  /// Текущая выбранная дата (null → не выбрано / пропущено).
  final DateTime? selectedDate;

  /// Коллбэк при выборе / сбросе даты.
  final ValueChanged<DateTime?> onDateSelected;

  /// Текущее значение: null → не выбрано, true → новое, false → адаптировалось.
  final bool? isNew;

  /// Коллбэк при выборе варианта акклиматизации.
  final ValueChanged<bool> onIsNewChanged;

  /// Локализованный текст ошибки сабмита (null → ошибки нет).
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Секция 1: Дата приобретения ──────────────────────────────────────

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

        const SizedBox(height: 24),

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
              selected: _isSameDay(
                  selectedDate, now.subtract(const Duration(days: 3))),
              onTap: () =>
                  onDateSelected(now.subtract(const Duration(days: 3))),
            ),
            _DateChip(
              label: l10n.addPlantStepAcquiredMonthAgo,
              selected: _isSameDay(
                  selectedDate, now.subtract(const Duration(days: 30))),
              onTap: () =>
                  onDateSelected(now.subtract(const Duration(days: 30))),
            ),
            _DateChip(
              label: l10n.addPlantStepAcquiredEarlier,
              selected: selectedDate != null &&
                  !_isSameDay(selectedDate!, now) &&
                  !_isSameDay(
                      selectedDate!, now.subtract(const Duration(days: 3))) &&
                  !_isSameDay(
                      selectedDate!, now.subtract(const Duration(days: 30))),
              onTap: () => _openDatePicker(context, now),
            ),
          ],
        ),

        // Выбранная дата через DatePicker
        if (selectedDate != null &&
            !_isSameDay(selectedDate!, now) &&
            !_isSameDay(
                selectedDate!, now.subtract(const Duration(days: 3))) &&
            !_isSameDay(
                selectedDate!, now.subtract(const Duration(days: 30)))) ...[
          const SizedBox(height: 12),
          Text(
            _formatDate(selectedDate!),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: c.primary,
            ),
          ),
        ],

        const SizedBox(height: 32),

        // ── Секция 2: Акклиматизация ──────────────────────────────────────────

        Text(
          l10n.addPlantStepAcclimationTitle,
          style: TextStyle(
            fontFamily: 'InstrumentSerif',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: c.ink,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 16),

        _AcclimationOption(
          label: l10n.addPlantStepAcclimationYes,
          selected: isNew == true,
          onTap: () => onIsNewChanged(true),
        ),

        const SizedBox(height: 12),

        _AcclimationOption(
          label: l10n.addPlantStepAcclimationNo,
          selected: isNew == false,
          onTap: () => onIsNewChanged(false),
        ),

        const SizedBox(height: 16),

        // Подсказка об акклиматизации
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: c.primarySoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            l10n.addPlantStepAcclimationHint,
            style: TextStyle(
              fontSize: 13,
              color: c.ink,
              height: 1.4,
            ),
          ),
        ),

        // Inline-ошибка сабмита
        if (errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEF9A9A)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 18, color: Color(0xFFD32F2F)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

class _AcclimationOption extends StatelessWidget {
  const _AcclimationOption({
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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? c.primarySoft : c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? c.primary : c.inkSoft.withAlpha(51),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: c.ink,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: c.primary, size: 22),
          ],
        ),
      ),
    );
  }
}
