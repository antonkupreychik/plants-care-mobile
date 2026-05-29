import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/plant_illustration.dart';

/// Пустой дневник (экран 31): у растения ещё нет событий ухода (`total == 0`).
///
/// Иллюстрация в мягком ореоле, серифный заголовок с акцентом, speech-bubble с
/// репликой растения и CTA «Отметить первый уход». [plantName] и [speciesName]
/// приходят из загруженной детали растения; если имени нет — bubble подписи не
/// рисует (мягкая деградация).
class CareHistoryEmpty extends StatelessWidget {
  const CareHistoryEmpty({
    super.key,
    required this.plantName,
    required this.speciesName,
    required this.onLogCare,
  });

  final String? plantName;
  final String? speciesName;
  final VoidCallback onLogCare;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HaloIllustration(speciesName: speciesName),
                  const SizedBox(height: 18),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${l10n.careHistoryEmptyTitle} '),
                        TextSpan(
                          text: l10n.careHistoryEmptyTitleAccent,
                          style: AppTheme.serif(
                            fontSize: 30,
                            fontStyle: FontStyle.italic,
                            color: c.primary,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: AppTheme.serif(fontSize: 30, color: c.ink),
                  ),
                  const SizedBox(height: 14),
                  _SpeechBubble(plantName: plantName),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
          child: FilledButton.icon(
            onPressed: onLogCare,
            icon: const Icon(Icons.check_rounded, size: 18),
            label: Text(l10n.careHistoryEmptyCta),
            style: FilledButton.styleFrom(
              backgroundColor: c.fab,
              foregroundColor: c.fabInk,
              minimumSize: const Size.fromHeight(52),
              textStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HaloIllustration extends StatelessWidget {
  const _HaloIllustration({required this.speciesName});

  final String? speciesName;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: c.primarySoft.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
          PlantIllustration(speciesName: speciesName, size: 140),
        ],
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.plantName});

  final String? plantName;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final name = plantName?.trim();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        children: [
          // Хвостик пузыря (повёрнутый квадрат с верхней/левой границей).
          Transform.rotate(
            angle: 0.785398, // 45°
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(
                  top: BorderSide(color: c.line),
                  left: BorderSide(color: c.line),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: c.line),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.careHistoryEmptyBubble,
                    textAlign: TextAlign.center,
                    style: AppTheme.serif(
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                      color: c.ink,
                    ).copyWith(height: 1.4),
                  ),
                  if (name != null && name.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      l10n.careHistoryEmptyAuthor(name),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: c.inkSoft,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
