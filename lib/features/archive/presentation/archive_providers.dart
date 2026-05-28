import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/archive_repository_provider.dart';
import '../domain/archive_view.dart';

part 'archive_providers.g.dart';

/// State-слой экрана «Архив» (17).
///
/// Один агрегатный провайдер: список архивных растений и ретроспектива грузятся
/// и показываются вместе (в отличие от home, где секции независимы) — это один
/// логический экран без посекционных мутаций.
///
/// Контракт для ui-builder: `ref.watch(archiveViewProvider)` отдаёт
/// `AsyncValue<ArchiveView>`:
/// - loading → skeleton карточек;
/// - error → `AsyncError` с типизированным [ApiError] (репозиторий вернул
///   `Failure`, разворачиваем броском) — UI маппит в текст через
///   `AppLocalizations`;
/// - data → [ArchiveView]; empty-state определяется самим UI по
///   `view.plants.isEmpty` (тогда `view.retrospective == null`).
@riverpod
Future<ArchiveView> archiveView(Ref ref) async {
  final result = await ref.watch(archiveRepositoryProvider).getArchive();
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}
