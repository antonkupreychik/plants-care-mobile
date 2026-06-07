import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Чипы-предложения имён ростка под полем ввода (экран 18).
///
/// Набор: «{parent}» (имя родителя как есть), «Мини-{parent}», «Зелёныш-2»,
/// «Дочка». Пока имя родителя не загружено — варианты, завязанные на него,
/// опускаются (показываем только статические).
class CuttingNameSuggestions extends StatelessWidget {
  const CuttingNameSuggestions({
    super.key,
    required this.parentName,
    required this.onSelected,
  });

  /// Имя родителя (из `plantDetailProvider`). null → деталь ещё грузится.
  final String? parentName;

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final parent = parentName?.trim();
    final suggestions = <String>[
      if (parent != null && parent.isNotEmpty) ...[
        parent,
        l10n.takeCuttingSuggestionMini(parent),
      ],
      l10n.takeCuttingSuggestionSprout,
      l10n.takeCuttingSuggestionDaughter,
    ];

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final name in suggestions)
          _SuggestionChip(label: name, onTap: () => onSelected(name)),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(999),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: c.line),
            ),
            child: Text(
              label,
              style: AppTheme.serif(fontSize: 14, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}
