import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/disease_catalog_repository_provider.dart';
import '../domain/disease.dart';

part 'disease_catalog_providers.g.dart';

/// State-слой справочника болезней (issue #68): список + поиск + деталь.
///
/// Контракт для UI:
/// - [diseaseQueryProvider] — committed-строка поиска (`Notifier<String>`).
///   Дебаунс сырого ввода (Timer, 400 мс) и порог «минимум 2 символа» —
///   забота UI; сюда кладётся уже «успокоившееся» значение через `setQuery`.
/// - [diseaseListProvider] — `AsyncValue<List<Disease>>` под текущей строкой.
///   Пустой запрос → весь список; иначе — результат `search`. Retry/refresh —
///   `ref.invalidate(diseaseListProvider)` (pull-to-refresh).
/// - [diseaseDetailProvider] — `AsyncValue<Disease>` по `id` (family).

/// Минимальная длина запроса для поиска (AC issue #68).
const int kDiseaseSearchMinLength = 2;

/// Committed-строка поиска по справочнику болезней (не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Сброс — `setQuery('')`.
@riverpod
class DiseaseQuery extends _$DiseaseQuery {
  @override
  String build() => '';

  /// Заменяет строку поиска. [diseaseListProvider] зависит от неё через
  /// `ref.watch` → при изменении перезагружается.
  void setQuery(String query) {
    final trimmed = query.trim();
    if (trimmed == state) return;
    state = trimmed;
  }
}

/// Список болезней под текущей строкой поиска.
///
/// `watch(diseaseQueryProvider)` в [build]: смена строки пересоздаёт провайдер
/// (loading → данные). Пустая строка ИЛИ короче [kDiseaseSearchMinLength] →
/// полный список (`getAll`); иначе — `search(query)`. `Result.failure`
/// пробрасывается броском `ApiError`, Riverpod упакует в `AsyncError`.
@riverpod
Future<List<Disease>> diseaseList(Ref ref) async {
  final query = ref.watch(diseaseQueryProvider);
  final repo = ref.watch(diseaseCatalogRepositoryProvider);
  final result = query.length < kDiseaseSearchMinLength
      ? await repo.getAll()
      : await repo.search(query);
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}

/// Деталь болезни по `id` (family). `AsyncError` несёт типизированный
/// `ApiError` (напр. `notFound`).
@riverpod
Future<Disease> diseaseDetail(Ref ref, int id) async {
  final result = await ref.watch(diseaseCatalogRepositoryProvider).getById(id);
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}
