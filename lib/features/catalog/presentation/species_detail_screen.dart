import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../plant_card/presentation/widgets/section_title.dart';
import '../domain/species_detail.dart';
import 'catalog_providers.dart';
import 'widgets/species_add_cta.dart';
import 'widgets/species_care_section.dart';
import 'widgets/species_description_card.dart';
import 'widgets/species_facts_grid.dart';
import 'widgets/species_hero.dart';
import 'widgets/species_light_meter.dart';
import 'widgets/species_toxicity_banner.dart';

/// Экран 13 «Деталь вида».
///
/// Потребляет family-провайдер [speciesDetailProvider] по [id]. Состояния:
/// loading (скелетон hero) / error (`ErrorState` + retry через invalidate) /
/// data (hero + описание + уход). Секции описания/ухода скрываются, если
/// данных нет (nullable-поля).
class SpeciesDetailScreen extends ConsumerWidget {
  const SpeciesDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final detail = ref.watch(speciesDetailProvider(id));

    // CTA закреплена снизу только в data-состоянии. Резерв под неё в контенте
    // (нижний sliver-отступ), чтобы кнопка не перекрывала последний блок.
    final hasData = detail.hasValue;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                  sliver: SliverToBoxAdapter(child: _TopBar()),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
                  sliver: SliverToBoxAdapter(
                    child: detail.when(
                      loading: () => const SpeciesHeroSkeleton(),
                      error: (error, _) => _DetailError(
                        error: error,
                        onRetry: () =>
                            ref.invalidate(speciesDetailProvider(id)),
                      ),
                      data: (data) => _DetailContent(detail: data),
                    ),
                  ),
                ),
                // Под закреплённую CTA (96) + базовый отступ, иначе без CTA.
                SliverToBoxAdapter(
                  child: SizedBox(height: hasData ? 112 : 32),
                ),
              ],
            ),
            if (hasData)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SpeciesAddCta(
                  bottomInset: MediaQuery.viewPaddingOf(context).bottom,
                  onPressed: () => context.push(
                    '/home/add?speciesId=${detail.requireValue.id}',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ErrorState(
      message: l10n.messageForError(error),
      retryLabel: l10n.retry,
      onRetry: onRetry,
    );
  }
}

/// Контент детали: hero, описание (если есть), уход (если есть интервалы).
class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.detail});

  final SpeciesDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final description = detail.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;
    final hasFacts = SpeciesFactsGrid.hasAny(detail);
    final hasCare = SpeciesCareSection.hasAny(detail);
    final hasLight = SpeciesLightMeter.hasData(detail);
    // G28: токсичность пока всегда скрыта (нет поля в API).
    final hasToxicity = SpeciesToxicityBanner.shouldShow(detail);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpeciesHero(detail: detail),
        // 1. Факты-сетка 2×2 (сразу после hero).
        if (hasFacts) ...[
          const SizedBox(height: 16),
          SpeciesFactsGrid(detail: detail),
        ],
        // 2. Баннер токсичности (TODO BACKEND-GAPS G28 — сейчас не рисуется).
        if (hasToxicity) ...[
          const SizedBox(height: 16),
          SpeciesToxicityBanner(detail: detail),
        ],
        // 3. Рекомендованный уход.
        if (hasCare) ...[
          const SizedBox(height: 24),
          SectionTitle(title: l10n.speciesCareTitle),
          const SizedBox(height: 12),
          SpeciesCareSection(detail: detail),
        ],
        // 4. Шкала света.
        if (hasLight) ...[
          const SizedBox(height: 24),
          SectionTitle(title: l10n.speciesLightTitle),
          const SizedBox(height: 12),
          SpeciesLightMeter(detail: detail),
        ],
        // 5. О растении (описание).
        if (hasDescription) ...[
          const SizedBox(height: 24),
          SectionTitle(title: l10n.speciesDescriptionTitle),
          const SizedBox(height: 12),
          SpeciesDescriptionCard(description: description),
        ],
      ],
    );
  }
}

/// Шапка: кнопка «назад» + overline «Вид».
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        _TopBarButton(
          icon: Icons.arrow_back_rounded,
          tooltip: l10n.plantCardBack,
          onPressed: () => _onBack(context),
        ),
        Expanded(
          child: Text(
            l10n.speciesDetailOverline.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: c.inkSoft,
            ),
          ),
        ),
        // Зеркальный отступ под центрирование overline (баланс к кнопке).
        const SizedBox(width: 44),
      ],
    );
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/catalog');
    }
  }
}

class _TopBarButton extends StatelessWidget {
  const _TopBarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Icon(icon, size: 22, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}
