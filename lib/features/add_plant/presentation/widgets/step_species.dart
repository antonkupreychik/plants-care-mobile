import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/api_error_l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/care_difficulty.dart';
import '../../domain/species_summary.dart';
import '../care_difficulty_l10n.dart';
import '../species_providers.dart';
import 'wizard_chrome.dart';

/// Шаг 1 мастера: поиск и выбор вида. Вид опционален — есть строка «создать без
/// вида» (пропуск). Debounce ввода ~300мс держит локальный [Timer]: в state
/// провайдера уходит только «успокоившийся» запрос, не каждый кейстрок.
class StepSpecies extends ConsumerStatefulWidget {
  const StepSpecies({super.key, required this.onSelected, required this.onSkip});

  /// Вид выбран → контроллер.selectSpecies(...) + переход на шаг 2.
  final ValueChanged<SpeciesSummary> onSelected;

  /// Создать без вида → шаг 2 (имя вводится вручную).
  final VoidCallback onSkip;

  @override
  ConsumerState<StepSpecies> createState() => _StepSpeciesState();
}

class _StepSpeciesState extends ConsumerState<StepSpecies> {
  static const _debounce = Duration(milliseconds: 300);

  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  /// «Успокоившийся» запрос, по которому реально дёргаем провайдер.
  String _query = '';

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () {
      if (!mounted) return;
      setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final results = ref.watch(speciesSearchProvider(_query));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardStepTitle(
          overline: l10n.addPlantOverline,
          title: l10n.addPlantSpeciesTitle,
          subtitle: l10n.addPlantSpeciesSubtitle,
        ),
        const SizedBox(height: 18),
        _SearchField(controller: _controller, onChanged: _onChanged),
        const SizedBox(height: 16),
        _SkipCard(onTap: widget.onSkip),
        const SizedBox(height: 14),
        results.when(
          loading: () => const _SpeciesListSkeleton(),
          error: (error, _) => ErrorState(
            message: l10n.messageForError(error),
            retryLabel: l10n.retry,
            onRetry: () => ref.invalidate(speciesSearchProvider(_query)),
          ),
          data: (species) {
            if (species.isEmpty) return const _SpeciesEmpty();
            return Column(
              children: [
                for (final s in species) ...[
                  _SpeciesCard(species: s, onTap: () => widget.onSelected(s)),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: TextStyle(fontSize: 14, color: c.ink),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search_rounded, size: 20, color: c.inkSoft),
        hintText: l10n.addPlantSearchHint,
        hintStyle: TextStyle(fontSize: 14, color: c.inkMute),
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: c.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: c.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: c.primary),
        ),
      ),
    );
  }
}

class _SpeciesCard extends StatelessWidget {
  const _SpeciesCard({required this.species, required this.onTap});

  final SpeciesSummary species;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final difficulty = species.careDifficulty.labelOrNull(l10n);

    return Semantics(
      button: true,
      label: species.name,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: c.line),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: c.surfaceWarm,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.local_florist_outlined,
                      size: 28, color: c.leaf),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        species.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.serif(fontSize: 20, color: c.ink),
                      ),
                      if (species.latinName != null &&
                          species.latinName!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          species.latinName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: c.inkSoft,
                          ),
                        ),
                      ],
                      if (difficulty != null) ...[
                        const SizedBox(height: 6),
                        _DifficultyBadge(
                          label: difficulty,
                          difficulty: species.careDifficulty,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 22, color: c.inkMute),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.label, required this.difficulty});

  final String label;
  final CareDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final dot = switch (difficulty) {
      CareDifficulty.easy => c.primary,
      CareDifficulty.medium => c.terracotta,
      CareDifficulty.hard => c.terracotta,
      CareDifficulty.unknown => c.inkMute,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: c.inkSoft,
          ),
        ),
      ],
    );
  }
}

/// Карточка «создать без выбора вида» (пунктирная рамка).
class _SkipCard extends StatelessWidget {
  const _SkipCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: l10n.addPlantSkipSpeciesTitle,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: DottedBorderBox(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.surfaceWarm,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '?',
                    style: AppTheme.serif(fontSize: 22, color: c.inkSoft),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addPlantSkipSpeciesTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        l10n.addPlantSkipSpeciesHint,
                        style: TextStyle(fontSize: 12, color: c.inkSoft),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 18, color: c.inkSoft),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Контейнер с пунктирной рамкой (используем сплошную мягкую рамку — пунктир
/// без доп. пакета; визуально отделяет «нейтральное» действие от карточек видов).
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line, width: 1.5),
      ),
      child: child,
    );
  }
}

class _SpeciesEmpty extends StatelessWidget {
  const _SpeciesEmpty();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 32, color: c.inkMute),
          const SizedBox(height: 12),
          Text(
            l10n.addPlantSearchEmpty,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.addPlantSearchEmptyHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _SpeciesListSkeleton extends StatelessWidget {
  const _SpeciesListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 4; i++) ...[
          const _SpeciesSkeletonCard(),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SpeciesSkeletonCard extends StatelessWidget {
  const _SpeciesSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          const SkeletonBox(width: 56, height: 56, radius: 16),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 120, height: 18),
                SizedBox(height: 8),
                SkeletonBox(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
