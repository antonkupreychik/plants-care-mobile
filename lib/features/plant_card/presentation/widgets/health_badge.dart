import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/health_zone.dart';
import '../../domain/plant_health.dart';
import '../plant_card_providers.dart';
import 'health_zone_color.dart';

/// Бейдж здоровья (G1) в ряду чипов на карточке растения (02).
///
/// GREEN → «♥ HEALTH {score}», нетапабельный.
/// YELLOW/RED → «⚠ Что‑то не так», тапабельный → экран 15 «Диагноз».
/// При недостатке данных → нейтральный «HEALTH —».
/// На ошибке скрывается тихо (декоративная доп-инфа).
class HealthBadge extends ConsumerWidget {
  const HealthBadge({super.key, required this.plantId});

  final int plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(plantHealthProvider(plantId));
    return health.when(
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const _BadgeSkeleton(),
      data: (h) {
        if (!h.hasReliableScore) return const _NeutralBadge();

        final zone = h.zone!;
        final isProblematic =
            zone == HealthZone.red || zone == HealthZone.yellow;

        final badge = isProblematic
            ? _WarningBadge(health: h)
            : _ScoredBadge(health: h);

        if (!isProblematic) return badge;

        return GestureDetector(
          onTap: () => context.pushNamed(
            'plantDiagnosis',
            pathParameters: {'id': plantId.toString()},
          ),
          child: badge,
        );
      },
    );
  }
}

/// Каркас чипа: плашка с padding 4×8 и скруглением 8.
class _BadgeShell extends StatelessWidget {
  const _BadgeShell({
    required this.background,
    required this.foreground,
    required this.label,
    required this.icon,
    this.semanticsLabel,
    this.button = false,
  });

  final Color background;
  final Color foreground;
  final String label;
  final IconData icon;
  final String? semanticsLabel;
  final bool button;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      button: button,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Бейдж с достоверным score (zone == GREEN) — нетапабельный.
class _ScoredBadge extends StatelessWidget {
  const _ScoredBadge({required this.health});

  final PlantHealth health;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final zone = health.zone!;
    return _BadgeShell(
      background: zone.badgeBackground(c),
      foreground: zone.foreground(c),
      icon: Icons.favorite_rounded,
      label: l10n.healthBadgeLabel(health.score!),
      semanticsLabel: l10n.healthSemanticScore(health.score!),
    );
  }
}

/// Предупреждающий бейдж (zone == YELLOW/RED) — тапабельный, ведёт на диагноз.
class _WarningBadge extends StatelessWidget {
  const _WarningBadge({required this.health});

  final PlantHealth health;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final zone = health.zone!;
    return _BadgeShell(
      background: zone.badgeBackground(c),
      foreground: zone.foreground(c),
      icon: Icons.warning_amber_rounded,
      label: l10n.diagnosisBadgeWarning,
      semanticsLabel: l10n.diagnosisBadgeWarning,
      button: true,
    );
  }
}

/// Нейтральный бейдж «HEALTH —» при недостатке данных.
class _NeutralBadge extends StatelessWidget {
  const _NeutralBadge();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return _BadgeShell(
      background: c.surfaceWarm,
      foreground: c.inkSoft,
      icon: Icons.favorite_rounded,
      label: l10n.healthScoreUnknown,
      semanticsLabel: l10n.healthSemanticUnknown,
    );
  }
}

/// Нейтральный шиммер на время загрузки.
class _BadgeSkeleton extends StatelessWidget {
  const _BadgeSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(width: 84, height: 22, radius: 8);
  }
}
