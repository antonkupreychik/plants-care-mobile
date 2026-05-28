import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Кнопка способа входа (экран 07): иконка + подпись.
///
/// Два варианта: нейтральный (на [PcColors.surface] с рамкой) и акцентный
/// ([accent] — на [PcColors.primary], белый текст) для Telegram-кнопки. Тап-зона
/// ≥ 52dp, помечена [Semantics] как кнопка.
class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.accent = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  /// Акцентный стиль (основной способ — Telegram): фон primary, белый текст.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final bg = accent ? c.primary : c.surface;
    final fg = accent ? c.surface : c.ink;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: bg,
        clipBehavior: Clip.antiAlias,
        // Только shape (не borderRadius одновременно — Material это запрещает
        // ассертом). Нейтральный вариант добавляет рамку через side.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: accent ? BorderSide.none : BorderSide(color: c.line),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 52,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: fg),
                const SizedBox(width: 12),
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
