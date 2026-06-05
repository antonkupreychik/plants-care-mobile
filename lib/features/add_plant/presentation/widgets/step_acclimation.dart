import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Шаг 6 мастера: «Растение новое?» — включить ли период акклиматизации.
///
/// Два варианта:
/// - «Да, только купил» → isNew = true (включает 21-дневный мягкий режим).
/// - «Нет, уже адаптировалось» → isNew = false.
///
/// Подсказка объясняет смысл акклиматизации.
/// Шаг опционален: пропуск (кнопка «Далее» без выбора) оставляет isNew = null.
class StepAcclimation extends StatelessWidget {
  const StepAcclimation({
    super.key,
    required this.isNew,
    required this.onIsNewChanged,
    required this.onSkip,
    this.errorMessage,
  });

  /// Текущее значение: null → не выбрано, true → новое, false → адаптировалось.
  final bool? isNew;

  /// Коллбэк при выборе варианта.
  final ValueChanged<bool> onIsNewChanged;

  /// Пропустить шаг (isNew остаётся null).
  final VoidCallback onSkip;

  /// Локализованный текст ошибки сабмита (null → ошибки нет).
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок
        Text(
          l10n.addPlantStepAcclimationTitle,
          style: TextStyle(
            fontFamily: 'InstrumentSerif',
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: c.ink,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 32),

        // Кнопка «Да, только купил»
        _AcclimationOption(
          label: l10n.addPlantStepAcclimationYes,
          selected: isNew == true,
          onTap: () => onIsNewChanged(true),
        ),

        const SizedBox(height: 12),

        // Кнопка «Нет, уже адаптировалось»
        _AcclimationOption(
          label: l10n.addPlantStepAcclimationNo,
          selected: isNew == false,
          onTap: () => onIsNewChanged(false),
        ),

        const SizedBox(height: 20),

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

        const SizedBox(height: 24),

        // Кнопка «Пропустить»
        GestureDetector(
          onTap: onSkip,
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

        // Inline-ошибка сабмита (показывается после неудачного POST /plants).
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
