import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Верхняя плашка бренда auth-флоу: «назад» + логотип + название + метка языка.
///
/// «Назад» уводит на предыдущий экран стека (`pop`), а если стек пуст — на
/// [fallbackRoute] (welcome для email-экрана, home для welcome).
class AuthBrandBar extends StatelessWidget {
  const AuthBrandBar({super.key, required this.fallbackRoute});

  /// Куда уходить, если в стеке нечего «попать».
  final String fallbackRoute;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 28, 0),
      child: Row(
        children: [
          _BackButton(label: l10n.authBack, fallbackRoute: fallbackRoute),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.eco_rounded, size: 20, color: c.surface),
          ),
          const SizedBox(width: 10),
          Text(
            l10n.authBrand,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.17,
              color: c.ink,
            ),
          ),
          const Spacer(),
          Text(
            l10n.authLocale,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}

/// Круглая кнопка возврата в шапке.
class _BackButton extends StatelessWidget {
  const _BackButton({required this.label, required this.fallbackRoute});

  final String label;
  final String fallbackRoute;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.canPop()
              ? context.pop()
              : context.go(fallbackRoute),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
          ),
        ),
      ),
    );
  }
}
