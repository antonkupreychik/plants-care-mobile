import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Карточка-toggle способа размножения (экран 18).
///
/// Активная: `bg: ink`, `color: surface`, без рамки; неактивная: `bg: surface`,
/// `border: line`.
class CuttingMethodCard extends StatelessWidget {
  const CuttingMethodCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.sub,
    required this.active,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final String sub;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final fg = active ? c.surface : c.ink;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: Material(
        color: active ? c.ink : c.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: active ? null : Border.all(color: c.line),
            ),
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: fg.withAlpha(190),
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
