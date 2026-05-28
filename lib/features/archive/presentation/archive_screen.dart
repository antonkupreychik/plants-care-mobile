import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/archive_view.dart';
import 'archive_providers.dart';
import 'widgets/archive_header.dart';
import 'widgets/archived_plant_card.dart';
import 'widgets/archive_empty.dart';
import 'widgets/archive_loading.dart';
import 'widgets/archive_retrospective_card.dart';

/// Экран 17 «Архив» (memorial) — растения, с которыми «пути разошлись».
///
/// Полноэкранно поверх shell (push на root navigator, своя кнопка «назад», без
/// таб-бара), как [RoomsScreen]/PlantCard. Потребляет один агрегатный провайдер
/// [archiveViewProvider] (`AsyncValue<ArchiveView>`):
/// - loading → [_ArchiveLoading] (шапка-заглушка + skeleton-карточки);
/// - error → шапка + [ErrorState] с retry (`ref.invalidate(archiveViewProvider)`),
///   текст по типу `ApiError` через `messageForError`;
/// - empty (`view.plants.isEmpty`) → шапка + [ArchiveEmpty] (без карточек и
///   ретроспективы);
/// - data → шапка + карточки [ArchivedPlantCard] + [ArchiveRetrospectiveCard].
///
/// Чипы «Открыть дневник»/«Вспомнить» — coming-soon (SnackBar), целевых
/// эндпоинтов нет.
class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(archiveViewProvider);

    void comingSoon() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: async.when(
          loading: () => const ArchiveLoading(),
          error: (error, _) => _ArchiveError(
            message: l10n.messageForError(error),
            onRetry: () => ref.invalidate(archiveViewProvider),
          ),
          data: (view) => _ArchiveContent(view: view, onComingSoon: comingSoon),
        ),
      ),
    );
  }
}

/// Контент data-состояния: шапка + список карточек + ретроспектива (или
/// пустое состояние, если архив пуст).
class _ArchiveContent extends StatelessWidget {
  const _ArchiveContent({required this.view, required this.onComingSoon});

  final ArchiveView view;
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    if (view.plants.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 120),
        children: [
          const ArchiveHeader(count: 0),
          const SizedBox(height: 28),
          const ArchiveEmpty(),
        ],
      );
    }

    final plants = view.plants;
    final retrospective = view.retrospective;
    // Один элемент-шапка + N карточек + опциональная ретроспектива.
    final extra = retrospective != null ? 2 : 1;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: plants.length + extra,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 20),
            child: ArchiveHeader(count: plants.length),
          );
        }
        final plantIndex = index - 1;
        if (plantIndex < plants.length) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ArchivedPlantCard(
              plant: plants[plantIndex],
              onComingSoon: onComingSoon,
            ),
          );
        }
        // Последний элемент — карточка ретроспективы.
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ArchiveRetrospectiveCard(retrospective: retrospective!),
        );
      },
    );
  }
}

/// Error: шапка + блок ошибки с retry (стек может быть пуст — кнопка «назад»
/// внутри шапки уходит на /profile).
class _ArchiveError extends StatelessWidget {
  const _ArchiveError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
      children: [
        const ArchiveHeader(),
        const SizedBox(height: 24),
        ErrorState(
          message: message,
          retryLabel: l10n.retry,
          onRetry: onRetry,
        ),
      ],
    );
  }
}

/// Серифный hero-заголовок «В памяти» с выделением слова «памяти» в primary
/// italic — общий для нескольких состояний экрана.
class ArchiveHeading extends StatelessWidget {
  const ArchiveHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    // Акцент задаётся отдельными ARB-ключами (lead + accent), а не split по
    // пробелу — устойчиво к переводу/переформулировке на других локалях.
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: l10n.archiveHeadingLead),
          TextSpan(
            text: l10n.archiveHeadingAccent,
            style: AppTheme.serif(
              fontSize: 42,
              color: c.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      style: AppTheme.serif(fontSize: 42, color: c.ink),
    );
  }
}
