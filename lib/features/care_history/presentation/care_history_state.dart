import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../../plant_card/domain/care_history_entry.dart';

part 'care_history_state.freezed.dart';

/// Накопленное состояние таймлайна истории ухода (экран 21).
///
/// Presentation-state (роль ViewModel): держит ВСЕ подгруженные страницы
/// ([entries]), метаданные пагинации ([total]/[offset]), флаг подзагрузки
/// ([isLoadingMore]) и активный клиентский фильтр по типу ([filter]).
/// Иммутабелен — мутируется только `CareHistoryController`.
///
/// Группировку по месяцам и маркер появления растения делает UI из
/// `entries[i].performedAt.toLocal()` и `Plant.createdAt` — в state этого нет
/// (это контракт для ui-builder).
@freezed
abstract class CareHistoryState with _$CareHistoryState {
  const factory CareHistoryState({
    /// Все загруженные записи (накоплены по страницам), порядок backend.
    required List<CareHistoryEntry> entries,

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

    /// Активный фильтр по типу ухода (клиентский). `null` — без фильтра.
    CareEventKind? filter,
  }) = _CareHistoryState;

  const CareHistoryState._();

  /// Есть ли ещё страницы: число загруженных меньше общего числа записей.
  bool get hasMore => offset < total;

  /// Записи под текущий фильтр. `null`-фильтр → все. Группировку/сортировку
  /// (месяцы) UI делает поверх этого списка.
  List<CareHistoryEntry> get visibleEntries {
    final kind = filter;
    if (kind == null) return entries;
    return entries
        .where((e) => e.kind == kind)
        .toList(growable: false);
  }
}
