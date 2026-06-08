import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../catalog/data/catalog_repository_provider.dart';
import '../../catalog/domain/species.dart';
import '../../disease_catalog/data/disease_catalog_repository_provider.dart';
import '../../home/domain/plant.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/disease.dart';

part 'search_providers.g.dart';

/// State-слой унифицированного поиска (issue #69, экран Search).
///
/// Три независимых раздела (растения / виды / болезни), а не один агрегат:
/// каждый грузится и падает самостоятельно, UI рисует skeleton/empty/data
/// посекционно. Все провайдеры ключуются на «успокоившуюся» строку запроса —
/// дебаунс сырого ввода (400 мс) делает UI и кладёт сюда уже trim'нутое
/// значение через [UnifiedSearchQuery.setQuery].

/// Минимальная длина запроса, при которой запускаются сетевые/фильтрующие
/// провайдеры. Короче — секции пусты, экран показывает подсказку.
const int kSearchMinChars = 2;

/// Макс. число результатов-растений в секции (клиентская фильтрация).
const int kPlantResultsLimit = 3;

/// Макс. число результатов в сетевых секциях (виды/болезни).
const int kSearchResultsLimit = 5;

/// Текущая committed-строка поиска (не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
/// (Timer 400 мс), сюда кладётся уже «успокоившееся» trim'нутое значение.
/// autoDispose (дефолт): строка живёт пока открыт экран поиска, сброс при выходе.
@riverpod
class UnifiedSearchQuery extends _$UnifiedSearchQuery {
  @override
  String build() => '';

  /// Заменяет строку поиска. Зависящие провайдеры пересоздаются по `ref.watch`.
  void setQuery(String query) {
    final trimmed = query.trim();
    if (trimmed == state) return;
    state = trimmed;
  }
}

/// Результаты раздела «Мои растения» — клиентская фильтрация
/// [homePlantsProvider] по `plant.name` (contains, ignoreCase), максимум
/// [kPlantResultsLimit]. Запрос короче [kSearchMinChars] → пустой список.
///
/// Не делает отдельного сетевого запроса: переиспользует уже загруженный (с
/// лимитом 50) список растений Home. `AsyncError`/`loading` прокидываются как
/// есть — секция нарисует skeleton/ошибку.
@riverpod
Future<List<Plant>> plantSearchResults(Ref ref, String query) async {
  final q = query.trim();
  if (q.length < kSearchMinChars) return const [];

  final plants = await ref.watch(homePlantsProvider.future);
  final lower = q.toLowerCase();
  return plants
      .where((p) => p.name.toLowerCase().contains(lower))
      .take(kPlantResultsLimit)
      .toList();
}

/// Результаты раздела «Виды» — `GET /species?q=&limit=5` через
/// [catalogRepositoryProvider]. Запрос короче [kSearchMinChars] → пустой список
/// (сетевой запрос не уходит). Ошибка репозитория пробрасывается в `AsyncError`.
@riverpod
Future<List<Species>> speciesSearchResults(Ref ref, String query) async {
  final q = query.trim();
  if (q.length < kSearchMinChars) return const [];

  final result = await ref.watch(catalogRepositoryProvider).searchSpecies(
        query: q,
        offset: 0,
        limit: kSearchResultsLimit,
      );
  return switch (result) {
    Success(:final value) => value.items,
    Failure(:final error) => throw error,
  };
}

/// Результаты раздела «Болезни и вредители» — `GET /diseases?q=` через
/// [diseaseCatalogRepositoryProvider] (полнотекстовый поиск на стороне backend).
/// Запрос короче [kSearchMinChars] → пустой список (сетевой запрос не уходит).
/// Ошибка репозитория пробрасывается в `AsyncError`.
///
/// Полная доменная модель справочника (`disease_catalog/domain/disease.dart`)
/// маппится в лёгкую `search/domain/Disease` (только id/name/latinName), которой
/// достаточно секции поиска; результат обрезается до [kSearchResultsLimit].
@riverpod
Future<List<Disease>> diseaseSearchResults(Ref ref, String query) async {
  final q = query.trim();
  if (q.length < kSearchMinChars) return const [];

  final result = await ref.watch(diseaseCatalogRepositoryProvider).search(q);
  return switch (result) {
    Success(:final value) => value
        .take(kSearchResultsLimit)
        .map((d) => Disease(id: d.id, name: d.name, latinName: d.latinName))
        .toList(),
    Failure(:final error) => throw error,
  };
}
