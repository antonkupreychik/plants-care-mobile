import 'package:freezed_annotation/freezed_annotation.dart';

import 'plant_event.dart';

part 'plant_events_page.freezed.dart';

/// Одна страница журнала событий растения (источник — `GET /plants/{id}/events`,
/// backend #220).
///
/// Чистый Dart. Несёт записи страницы ([items]) и метаданные пагинации
/// ([total]/[limit]/[offset]) ровно как их отдаёт backend — клиент их не
/// пересчитывает. Накопление страниц делает presentation
/// (`PlantEventsNotifier`), а не эта модель (как `CareHistoryPage`).
@freezed
abstract class PlantEventsPage with _$PlantEventsPage {
  const factory PlantEventsPage({
    /// События этой страницы, в порядке backend (новые сверху).
    required List<PlantEvent> items,

    /// Общее количество событий журнала (по всем страницам).
    required int total,

    /// Размер запрошенной страницы (echo из ответа).
    required int limit,

    /// Сдвиг этой страницы от начала журнала (echo из ответа).
    required int offset,
  }) = _PlantEventsPage;

  const PlantEventsPage._();

  /// Есть ли ещё страницы за этой.
  bool get hasMore => offset + items.length < total;
}
