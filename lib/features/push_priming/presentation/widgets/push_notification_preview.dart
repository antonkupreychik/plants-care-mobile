import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/plant_illustration.dart';

/// Превью образца пуш-уведомления: аватар растения, имя + время, voice line
/// и эмодзи капли (экран 27). Чисто иллюстративный, не интерактивный.
class PushNotificationPreview extends StatelessWidget {
  const PushNotificationPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.surfaceWarm,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const PlantIllustration(speciesName: 'monstera', size: 34),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.pushPrimingPreviewTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  l10n.pushPrimingPreviewBody,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.serif(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: c.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text('💧', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
