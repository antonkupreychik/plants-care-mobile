import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../plant_illustration.dart';

/// Описание одного стартового вида в блоке «Идеи на старт» (экран 10).
/// Статичный контент UI (не данные backend): подбирает локализованные подписи
/// по [AppLocalizations] и иллюстрацию по [speciesKey].
@immutable
class _StarterIdea {
  const _StarterIdea({
    required this.speciesKey,
    required this.highlight,
  });

  /// Ключ вида для [PlantIllustration.speciesName] (он маппит на ассет).
  final String speciesKey;

  /// Первый чип акцентируется фоном primarySoft, остальные — surfaceWarm.
  final bool highlight;

  String label(AppLocalizations l10n) => switch (speciesKey) {
        'monstera' => l10n.homeStarterMonstera,
        'succulent' => l10n.homeStarterSucculent,
        _ => l10n.homeStarterPothos,
      };

  String hint(AppLocalizations l10n) => switch (speciesKey) {
        'monstera' => l10n.homeStarterMonsteraHint,
        'succulent' => l10n.homeStarterSucculentHint,
        _ => l10n.homeStarterPothosHint,
      };
}

/// Блок «Идеи на старт» под карточкой пустого сада (экран 10):
/// надзаголовок + горизонтальная лента из 3 чипов-карточек. Тап по любому
/// чипу ведёт в общий каталог через [onOpenCatalog].
class StarterIdeas extends StatelessWidget {
  const StarterIdeas({super.key, required this.onOpenCatalog});

  final VoidCallback onOpenCatalog;

  static const _ideas = <_StarterIdea>[
    _StarterIdea(speciesKey: 'monstera', highlight: true),
    _StarterIdea(speciesKey: 'succulent', highlight: false),
    _StarterIdea(speciesKey: 'pothos', highlight: false),
  ];

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeStarterIdeasTitle.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 176,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: _ideas.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final idea = _ideas[index];
              return _StarterChip(
                label: idea.label(l10n),
                hint: idea.hint(l10n),
                speciesKey: idea.speciesKey,
                highlight: idea.highlight,
                onTap: onOpenCatalog,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StarterChip extends StatelessWidget {
  const _StarterChip({
    required this.label,
    required this.hint,
    required this.speciesKey,
    required this.highlight,
    required this.onTap,
  });

  final String label;
  final String hint;
  final String speciesKey;
  final bool highlight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.line),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: highlight ? c.primarySoft : c.surfaceWarm,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: PlantIllustration(speciesName: speciesKey, size: 70),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: c.ink,
                  ),
                ),
                Text(
                  hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: c.inkSoft),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
