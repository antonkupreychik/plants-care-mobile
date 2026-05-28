import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/plant_health.dart';
import '../plant_card_providers.dart';
import 'health_zone_color.dart';

/// Бейдж «♥ HEALTH {score}» (G1) в ряду чипов на карточке растения (02).
///
/// Потребляет общий `plantHealthProvider(plantId)` — тот же, что кольцо на Home.
/// Health — декоративная доп-инфа: на ошибке бейдж тихо скрывается (карточка
/// живёт), на загрузке — нейтральный шиммер, при недостатке данных —
/// нейтральный «HEALTH —» (не выглядит как ошибка).
class HealthBadge extends ConsumerWidget {
  const HealthBadge({super.key, required this.plantId});

  final int plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(plantHealthProvider(plantId));
    return health.when(
      // error → health-бейдж скрываем тихо (декоративная доп-инфа).
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const _BadgeSkeleton(),
      data: (h) =>
          h.hasReliableScore ? _ScoredBadge(health: h) : const _NeutralBadge(),
    );
  }
}

/// Каркас чипа: плашка с padding 4×8 и скруглением 8 (как в дизайне).
class _BadgeShell extends StatelessWidget {
  const _BadgeShell({
    required this.background,
    required this.foreground,
    required this.label,
    this.semanticsLabel,
  });

  final Color background;
  final Color foreground;
  final String label;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_rounded, size: 12, color: foreground),
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

/// Бейдж с достоверным score — фон/текст по зоне.
class _ScoredBadge extends StatelessWidget {
  const _ScoredBadge({required this.health});

  final PlantHealth health;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    // hasReliableScore (call-site) гарантирует zone/score != null.
    final zone = health.zone!;
    final score = health.score!;
    return _BadgeShell(
      background: zone.badgeBackground(c),
      foreground: zone.foreground(c),
      label: l10n.healthBadgeLabel(score),
      semanticsLabel: l10n.healthSemanticScore(score),
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
      label: l10n.healthScoreUnknown,
      semanticsLabel: l10n.healthSemanticUnknown,
    );
  }
}

/// Нейтральный шиммер на время загрузки (не спиннер на всю карточку).
class _BadgeSkeleton extends StatelessWidget {
  const _BadgeSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(width: 84, height: 22, radius: 8);
  }
}
