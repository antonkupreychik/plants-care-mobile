import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Основной CTA auth-флоу (full-width).
///
/// Фон — [PcColors.fab], текст — [PcColors.fabInk]; при `enabled == false`
/// гасится (приглушённый фон, тап отключён) — так экран 08 показывает CTA
/// «Продолжить», пока код не введён полностью. Опциональная ведущая иконка.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final bg = enabled ? c.fab : c.fab.withValues(alpha: 0.35);
    final fg = c.fabInk;

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: fg),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
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
