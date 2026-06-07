import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import 'disease_catalog_providers.dart';
import 'widgets/disease_empty.dart';
import 'widgets/disease_search_field.dart';
import 'widgets/disease_tile.dart';

/// Экран «Болезни и вредители» (issue #68) — список + поиск.
///
/// Потребляет [diseaseQueryProvider] (committed-строка) и [diseaseListProvider]
/// (`AsyncValue<List<Disease>>`). Дебаунс/порог ввода — в [DiseaseSearchField].
/// Состояния: loading (скелетоны) / error (ErrorState + retry) / empty / data.
/// Pull-to-refresh перезагружает список (invalidate провайдера).
class DiseaseCatalogScreen extends ConsumerWidget {
  const DiseaseCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(diseaseQueryProvider);
    final listState = ref.watch(diseaseListProvider);

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.bg,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.diseaseCatalogTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/profile'),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
              child: DiseaseSearchField(
                initialValue: query,
                onSubmitted: (value) =>
                    ref.read(diseaseQueryProvider.notifier).setQuery(value),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(diseaseListProvider),
                color: c.primary,
                child: listState.when(
                  loading: () => ListView.separated(
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
                    itemCount: 6,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, _) => const _DiseaseTileSkeleton(),
                  ),
                  error: (error, _) => ListView(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                    children: [
                      ErrorState(
                        message: l10n.messageForError(error),
                        retryLabel: l10n.retry,
                        onRetry: () => ref.invalidate(diseaseListProvider),
                      ),
                    ],
                  ),
                  data: (diseases) {
                    if (diseases.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                        children: [
                          DiseaseEmpty(title: l10n.diseaseCatalogEmpty),
                        ],
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
                      itemCount: diseases.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final disease = diseases[index];
                        return DiseaseTile(
                          disease: disease,
                          onTap: () =>
                              context.push('/profile/diseases/${disease.id}'),
                        );
                      },
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

/// Скелетон строки списка во время загрузки.
class _DiseaseTileSkeleton extends StatelessWidget {
  const _DiseaseTileSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
    );
  }
}
