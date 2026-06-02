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
    this.loading = false,
  });

  final String label;
  final IconData icon;

  /// Колбэк нажатия. `null` — кнопка выключена (например, идёт другой вход).
  final VoidCallback? onTap;

  /// Акцентный стиль (основной способ): фон primary, белый текст.
  final bool accent;

  /// Идёт запрос именно по этой кнопке: вместо иконки крутится индикатор.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final disabled = onTap == null;
    final bg = accent ? c.primary : c.surface;
    final fg = accent ? c.surface : c.ink;
    // Приглушаем выключенную кнопку, не трогая токены цвета.
    final opacity = disabled ? 0.5 : 1.0;

    return Semantics(
      button: true,
      enabled: !disabled,
      label: label,
      child: Opacity(
        opacity: opacity,
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
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: loading
                        ? CircularProgressIndicator(strokeWidth: 2.2, color: fg)
                        : Icon(icon, size: 20, color: fg),
                  ),
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
      ),
    );
  }
}
