import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/disease.dart';
import 'disease_catalog_providers.dart';

/// Экран «Карточка болезни» (issue #68).
///
/// Потребляет family-провайдер [diseaseDetailProvider] по [id]. Состояния:
/// loading (спиннер) / error (ErrorState + retry через invalidate) / data:
/// название, латинское название (курсивом, если задано) и три секции —
/// «Симптомы» / «Лечение» / «Профилактика».
class DiseaseDetailScreen extends ConsumerWidget {
  const DiseaseDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(diseaseDetailProvider(id));

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.bg,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/profile'),
        ),
      ),
      body: SafeArea(
        top: false,
        child: detail.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
            child: ErrorState(
              message: l10n.messageForError(error),
              retryLabel: l10n.retry,
              onRetry: () => ref.invalidate(diseaseDetailProvider(id)),
            ),
          ),
          data: (disease) => _DiseaseContent(disease: disease),
        ),
      ),
    );
  }
}

class _DiseaseContent extends StatelessWidget {
  const _DiseaseContent({required this.disease});

  final Disease disease;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final latin = disease.latinName?.trim();

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
      children: [
        Text(
          disease.name,
          style: AppTheme.serif(fontSize: 32, color: c.ink),
        ),
        if (latin != null && latin.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            latin,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: c.inkSoft,
            ),
          ),
        ],
        const SizedBox(height: 24),
        _DiseaseSection(
          title: l10n.diseaseDetailSymptomsTitle,
          body: disease.symptoms,
        ),
        const SizedBox(height: 16),
        _DiseaseSection(
          title: l10n.diseaseDetailTreatmentTitle,
          body: disease.treatment,
        ),
        const SizedBox(height: 16),
        _DiseaseSection(
          title: l10n.diseaseDetailPreventionTitle,
          body: disease.prevention,
        ),
      ],
    );
  }
}

/// Секция карточки болезни: серифный заголовок + текст в карточке.
class _DiseaseSection extends StatelessWidget {
  const _DiseaseSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.serif(fontSize: 20, color: c.ink)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.line),
          ),
          child: Text(
            body,
            style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.45),
          ),
        ),
      ],
    );
  }
}
