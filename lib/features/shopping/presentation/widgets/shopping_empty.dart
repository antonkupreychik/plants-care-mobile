import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Пустое состояние экрана 19 «Список покупок» (данные есть, но `isEmpty`).
///
/// Дружелюбная иллюстрация, серифный заголовок «Список пуст», поясняющий текст
/// и приглашение добавить позицию (CTA). Тексты — через [AppLocalizations]
/// (ru-only, ARB). Рендерится внутри прокручиваемой области (для pull-to-refresh)
/// вызывающим экраном.
class ShoppingEmpty extends StatelessWidget {
  const ShoppingEmpty({super.key, required this.onAdd});

  /// Открыть шит добавления первой позиции.
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Illustration(),
            const SizedBox(height: 18),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: l10n.shoppingEmptyTitleLead),
                  TextSpan(
                    text: l10n.shoppingEmptyTitleAccent,
                    style: AppTheme.serif(
                      fontSize: 30,
                      color: c.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: AppTheme.serif(fontSize: 30, color: c.ink),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.shoppingEmptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: c.inkSoft),
            ),
            const SizedBox(height: 20),
            _AddButton(label: l10n.shoppingAddItem, onPressed: onAdd),
          ],
        ),
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: c.primarySoft.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
          ExcludeSemantics(
            child: SvgPicture.asset(
              'assets/illustrations/succulent.svg',
              width: 130,
              height: 130,
            ),
          ),
          Positioned(
            right: 16,
            top: 22,
            child: Icon(
              Icons.shopping_basket_rounded,
              size: 30,
              color: c.terracotta,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.fab,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 22),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 20, color: c.fabInk),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.fabInk,
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
