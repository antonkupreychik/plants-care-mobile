import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/diagnosis_issue.dart';
import 'diagnosis_providers.dart';
import 'widgets/_diagnosis_hero.dart';
import 'widgets/_healthy_state.dart';
import 'widgets/_issues_list.dart';
import 'widgets/_recommendations_list.dart';

/// Экран 15 «Диагноз растения».
///
/// Потребляет два независимых провайдера по [plantId]:
/// - [plantDiagnosisProvider] — список проблем и рекомендаций;
/// - [diagnosisPlantProvider] — данные растения для hero-шапки.
///
/// Провайдеры загружаются независимо: hero показывает skeleton пока
/// [diagnosisPlantProvider] грузится, секция диагноза рисуется когда
/// [plantDiagnosisProvider] готов.
///
/// Состояния:
/// - loading → skeleton-карточки;
/// - error → сообщение об ошибке + кнопка «Повторить»;
/// - data + isHealthy → [HealthyState];
/// - data + !isHealthy → [IssuesList] и/или [RecommendationsList].
class PlantDiagnosisScreen extends ConsumerWidget {
  const PlantDiagnosisScreen({super.key, required this.plantId});

  final int plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final diagnosisAsync = ref.watch(plantDiagnosisProvider(plantId));

    void onBack() {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    }

    // Определяем hasIssues для hero-секции на основе загруженного диагноза.
    final hasIssues = switch (diagnosisAsync) {
      AsyncData(:final value) => value.issues.isNotEmpty,
      _ => false,
    };

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Hero-секция всегда рендерится (независимо от диагноза).
            SliverToBoxAdapter(
              child: DiagnosisHero(
                plantId: plantId,
                hasIssues: hasIssues,
                onBack: onBack,
              ),
            ),
            // Тело: loading / error / data (healthy / issues+recs)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 60),
              sliver: SliverToBoxAdapter(
                child: diagnosisAsync.when(
                  loading: () => const _DiagnosisLoadingBody(),
                  error: (error, _) => ErrorState(
                    message: l10n.messageForError(error),
                    retryLabel: l10n.diagnosisRetry,
                    onRetry: () =>
                        ref.invalidate(plantDiagnosisProvider(plantId)),
                  ),
                  data: (diagnosis) {
                    if (diagnosis.isHealthy) {
                      return const HealthyState();
                    }
                    return _DiagnosisDataBody(
                      issues: diagnosis.issues,
                      recommendations: diagnosis.recommendations,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading-состояние секции диагноза: skeleton-карточки.
class _DiagnosisLoadingBody extends StatelessWidget {
  const _DiagnosisLoadingBody();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок-skeleton
        Container(
          width: 100,
          height: 14,
          decoration: BoxDecoration(
            color: c.inkMute.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 12),
        const IssuesListSkeleton(count: 2),
        const SizedBox(height: 24),
        Container(
          width: 130,
          height: 14,
          decoration: BoxDecoration(
            color: c.inkMute.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: c.inkMute.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }
}

/// Data-состояние с проблемами и/или рекомендациями.
class _DiagnosisDataBody extends StatelessWidget {
  const _DiagnosisDataBody({
    required this.issues,
    required this.recommendations,
  });

  final List<DiagnosisIssue> issues;
  final List<String> recommendations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (issues.isNotEmpty) ...[
          IssuesList(issues: issues),
          if (recommendations.isNotEmpty) const SizedBox(height: 24),
        ],
        if (recommendations.isNotEmpty)
          RecommendationsList(recommendations: recommendations),
      ],
    );
  }
}
