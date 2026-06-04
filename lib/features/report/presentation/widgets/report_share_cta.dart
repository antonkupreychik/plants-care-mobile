import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Нижняя CTA «Поделиться отчётом» (дизайн v4 «SHARE CTA»). Заливка `fab`,
/// инверсный текст. Тап → coming-soon (передаётся экраном). Tap-зона ≥ 48dp.
class ReportShareCta extends StatelessWidget {
  const ReportShareCta({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: l10n.reportShareCta,
      child: Material(
        color: c.fab,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.ios_share_rounded, size: 18, color: c.fabInk),
                const SizedBox(width: 8),
                Text(
                  l10n.reportShareCta,
                  style: TextStyle(
                    fontSize: 14,
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
