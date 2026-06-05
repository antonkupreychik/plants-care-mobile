import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/care_history_entry.dart';

part 'plant_card_history_state.freezed.dart';

/// Накопленное состояние дневника ухода на карточке растения (02).
///
/// Presentation-state (роль ViewModel): держит первые [_kPageSize] + дозагруженные
/// записи ([items]), метаданные пагинации ([total]/[offset]), флаг подзагрузки
/// ([isLoadingMore]). Иммутабелен — мутируется только [PlantCardHistoryNotifier].
@freezed
abstract class PlantCardHistoryState with _$PlantCardHistoryState {
  const factory PlantCardHistoryState({
    /// Все загруженные записи (накоплены по страницам), порядок backend.
    required List<CareHistoryEntry> items,

    /// Всего активных записей истории (из `PlantHistoryResponse.total`).
    required int total,

    /// Сдвиг для СЛЕДУЮЩЕЙ страницы (= числу уже загруженных записей).
    required int offset,

    /// Идёт подзагрузка следующей страницы ([loadMore]). Первичная загрузка
    /// выражается через `AsyncLoading` снаружи, а не этим флагом.
    @Default(false) bool isLoadingMore,

    /// Ошибка последней подзагрузки страницы. Показанный список при этом
    /// сохраняется (не уходим в `AsyncError` всего провайдера) — UI рисует
    /// строку «не удалось дозагрузить» + retry. `null` — ошибки нет.
    ApiError? loadMoreError,
  }) = _PlantCardHistoryState;

  const PlantCardHistoryState._();

  /// Есть ли ещё страницы: число загруженных меньше общего числа записей.
  bool get hasMore => offset < total;
}
