import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/add_plant_repository_provider.dart';
import '../domain/species_detail.dart';
import '../domain/species_summary.dart';

part 'species_providers.g.dart';

/// State-слой справочника видов для мастера (шаг 1 + превью шага 3).
///
/// Контракт для ui-builder: оба провайдера отдают `AsyncValue<...>`
/// (loading / error / data); в `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.

/// Поиск видов по строке запроса (family). Пустой запрос (`''`) → топ видов
/// (backend отдаёт без фильтра) — список не пустой при первом открытии шага 1.
///
/// Debounce ввода — забота UI (watch с уже «успокоившимся» запросом): провайдер
/// просто family по нормализованной строке, без таймеров в state.
@riverpod
Future<List<SpeciesSummary>> speciesSearch(Ref ref, String query) async {
  final result = await ref
      .watch(addPlantRepositoryProvider)
      .searchSpecies(query: query.trim());
  return _unwrap(result);
}

/// Детали вида по id (family) — нужны на превью ради `description`. Интервалы
/// для «плана ухода» уже есть в выбранном [SpeciesSummary] (см. wizard-контроллер),
/// так что этот запрос делается лениво и только когда UI показывает описание.
@riverpod
Future<SpeciesDetail> speciesDetail(Ref ref, int id) async {
  final result = await ref.watch(addPlantRepositoryProvider).getSpeciesDetail(id);
  return _unwrap(result);
}

/// Разворачивает `Result<T>`: успех → значение, ошибка → бросок [ApiError],
/// который Riverpod упакует в `AsyncError` (типизированный, не строка).
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      Failure<T>(:final error) => throw error,
    };
