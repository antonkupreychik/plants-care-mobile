import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/species.dart';
import '../catalog_providers.dart';

/// Экран 30 «Пустой поиск каталога».
///
/// Четыре секции:
/// 1. Иллюстрация кактуса с кружковым фоном и бейджем-поиском.
/// 2. Серифный заголовок с запросом и подсказка.
/// 3. Горизонтальный Wrap чипов популярных видов (из [popularSpeciesProvider]).
/// 4. CTA-карточка «Нет в каталоге?» с кнопкой добавления.
class CatalogSearchEmpty extends ConsumerWidget {
  const CatalogSearchEmpty({
    super.key,
    required this.query,
    required this.onSuggestionTap,
    required this.onAddPlant,
  });

  final String query;

  /// Вызывается с именем вида при нажатии на чип-подсказку.
  final ValueChanged<String> onSuggestionTap;

  /// Вызывается при нажатии «Добавить» в CTA-карточке.
  final VoidCallback onAddPlant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = Theme.of(context).extension<PcColors>()!;
    final popularAsync = ref.watch(popularSpeciesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          _CactusIllustration(c: c),
          const SizedBox(height: 20),
          _TitleSection(query: query, l10n: l10n, c: c),
          const SizedBox(height: 20),
          _SuggestionsSection(
            l10n: l10n,
            c: c,
            popularAsync: popularAsync,
            onSuggestionTap: onSuggestionTap,
          ),
          const SizedBox(height: 16),
          _NotInCatalogCard(
            l10n: l10n,
            c: c,
            onAddPlant: onAddPlant,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section 1: Illustration
// ---------------------------------------------------------------------------

class _CactusIllustration extends StatelessWidget {
  const _CactusIllustration({required this.c});

  final PcColors c;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Warm circle background
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: c.surfaceWarm.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
          // Cactus SVG slightly dimmed
          ExcludeSemantics(
            child: Opacity(
              opacity: 0.6,
              child: SvgPicture.asset(
                'assets/illustrations/cactus.svg',
                width: 120,
                height: 120,
              ),
            ),
          ),
          // Search badge — top-right corner
          Positioned(
            right: 8,
            top: 8,
            child: _SearchBadge(c: c),
          ),
        ],
      ),
    );
  }
}

class _SearchBadge extends StatelessWidget {
  const _SearchBadge({required this.c});

  final PcColors c;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.line),
      ),
      child: Center(
        child: Icon(Icons.search_rounded, size: 18, color: c.inkMute),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section 2: Title + hint
// ---------------------------------------------------------------------------

class _TitleSection extends StatelessWidget {
  const _TitleSection({
    required this.query,
    required this.l10n,
    required this.c,
  });

  final String query;
  final AppLocalizations l10n;
  final PcColors c;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.catalogSearchEmptyTitle(query),
          textAlign: TextAlign.center,
          style: AppTheme.serif(fontSize: 26, color: c.ink),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.catalogSearchEmptyMessage,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section 3: Suggestion chips
// ---------------------------------------------------------------------------

class _SuggestionsSection extends StatelessWidget {
  const _SuggestionsSection({
    required this.l10n,
    required this.c,
    required this.popularAsync,
    required this.onSuggestionTap,
  });

  final AppLocalizations l10n;
  final PcColors c;
  final AsyncValue<List<Species>> popularAsync;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    // loading or error → chips are not critical, show nothing
    final species = popularAsync.value;
    if (species == null || species.isEmpty) return const SizedBox.shrink();

    final capped = species.take(4).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.catalogSuggestionsTitle,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: c.inkMute,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final sp in capped)
              _SuggestionChip(
                label: sp.name,
                c: c,
                onTap: () => onSuggestionTap(sp.name),
              ),
          ],
        ),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.label,
    required this.c,
    required this.onTap,
  });

  final String label;
  final PcColors c;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.chipBg,
        borderRadius: BorderRadius.circular(999),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section 4: "Нет в каталоге?" CTA card
// ---------------------------------------------------------------------------

class _NotInCatalogCard extends StatelessWidget {
  const _NotInCatalogCard({
    required this.l10n,
    required this.c,
    required this.onAddPlant,
  });

  final AppLocalizations l10n;
  final PcColors c;
  final VoidCallback onAddPlant;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: c.primarySoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Decorative leaf — bottom-right, partially outside
            Positioned(
              right: -16,
              bottom: -20,
              child: ExcludeSemantics(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: _LeafPainter(color: c.leafDark),
                  ),
                ),
              ),
            ),
            // Content row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.catalogNotInCatalogTitle,
                          style: AppTheme.serif(fontSize: 18, color: c.ink),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.catalogNotInCatalogHint,
                          style: TextStyle(
                            fontSize: 12,
                            color: c.inkSoft,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _AddButton(
                    label: l10n.catalogNotInCatalogAdd,
                    c: c,
                    onPressed: onAddPlant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.label,
    required this.c,
    required this.onPressed,
  });

  final String label;
  final PcColors c;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.ink,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.surface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Decorative leaf painter
// ---------------------------------------------------------------------------

class _LeafPainter extends CustomPainter {
  const _LeafPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(100, 20)
      ..cubicTo(60, 20, 30, 50, 30, 90)
      ..cubicTo(50, 90, 80, 60, 100, 20);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LeafPainter oldDelegate) => oldDelegate.color != color;
}
