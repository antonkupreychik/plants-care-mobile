import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Строка настроек (`screens-v4.jsx` `SettingsRow`): иконка + заголовок +
/// необязательное значение справа + шеврон. Тап-зона ≥ 56dp.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.value,
    this.divider = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  /// Значение справа (например «1 дом · 6 комнат»). В объёме задачи не задаётся.
  final String? value;

  /// Рисовать ли разделитель сверху (для строк, кроме первой в секции).
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: divider
                  ? Border(top: BorderSide(color: c.line))
                  : null,
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: c.inkSoft),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                ),
                if (value != null) ...[
                  Text(
                    value!,
                    style: TextStyle(fontSize: 13, color: c.inkSoft),
                  ),
                  const SizedBox(width: 8),
                ],
                Icon(Icons.chevron_right_rounded, size: 20, color: c.inkMute),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
