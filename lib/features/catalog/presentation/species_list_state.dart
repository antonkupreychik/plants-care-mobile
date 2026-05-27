import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/species.dart';

part 'species_list_state.freezed.dart';

/// Состояние загруженного списка видов (data-ветка `AsyncValue`).
///
/// Аккумулирует страницы в [items]. [total] — сколько всего видов под текущим
/// фильтром (из `PageResponse.total`); по нему считается [hasMore]. Дозагрузка
/// следующей страницы (`loadMore`) не сбрасывает уже показанный список в
/// loading — флаг [isLoadingMore] и отдельная [loadMoreError] позволяют UI
/// показать спиннер/ретрай в футере, не теряя контент.
///
/// Первичная загрузка и смена строки поиска проходят через `AsyncValue.loading`
/// / `AsyncError` самого нотифаера — сюда не попадают.
@freezed
abstract class SpeciesListState with _$SpeciesListState {
  const factory SpeciesListState({
    required List<Species> items,

    /// Всего видов под текущим фильтром `q` (для расчёта [hasMore]).
    required int total,

    /// Идёт дозагрузка следующей страницы (показанный список остаётся).
    @Default(false) bool isLoadingMore,

    /// Ошибка последней попытки `loadMore` (первичная загрузка — в `AsyncError`).
    ApiError? loadMoreError,
  }) = _SpeciesListState;

  const SpeciesListState._();

  /// Есть ли ещё незагруженные виды (аккумулировано меньше, чем всего).
  bool get hasMore => items.length < total;
}
