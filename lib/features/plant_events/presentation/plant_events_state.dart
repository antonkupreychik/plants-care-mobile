import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/plant_event.dart';

part 'plant_events_state.freezed.dart';

/// Накопленное состояние журнала событий растения (presentation-state, роль
/// ViewModel).
///
/// Держит ВСЕ подгруженные страницы ([items]), метаданные пагинации
/// ([total]/[offset]), флаг подзагрузки ([isLoadingMore]) и ошибку подзагрузки
/// ([loadMoreError]). Иммутабелен — мутируется только `PlantEventsNotifier`.
/// Первичная загрузка/ошибка выражается через `AsyncValue` снаружи.
@freezed
abstract class PlantEventsState with _$PlantEventsState {
  const factory PlantEventsState({
    /// Все загруженные события (накоплены по страницам), порядок backend.
    required List<PlantEvent> items,

    /// Всего событий журнала (из ответа backend).
    required int total,

    /// Сдвиг для СЛЕДУЮЩЕЙ страницы (= числу уже загруженных событий).
    required int offset,

    /// Идёт подзагрузка следующей страницы ([loadMore]).
    @Default(false) bool isLoadingMore,

    /// Ошибка последней подзагрузки. Показанный список сохраняется (не уходим
    /// в `AsyncError` всего провайдера) — UI рисует строку + retry. `null` — нет.
    ApiError? loadMoreError,
  }) = _PlantEventsState;

  const PlantEventsState._();

  /// Есть ли ещё страницы: число загруженных меньше общего числа событий.
  bool get hasMore => offset < total;
}
