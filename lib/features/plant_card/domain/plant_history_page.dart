import 'care_history_entry.dart';

/// Одна страница истории ухода (источник — `GET /plants/{id}/history`,
/// `PlantHistoryResponse`).
///
/// Чистый Dart. Несёт записи страницы ([items]) и метаданные пагинации
/// ([total]/[limit]/[offset]). Накопление страниц делает presentation
/// (`PlantCardHistoryNotifier`), а не эта модель.
class PlantHistoryPage {
  const PlantHistoryPage({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  /// Записи этой страницы, в порядке backend (новые сверху).
  final List<CareHistoryEntry> items;

  /// Общее количество активных записей истории (из `PlantHistoryResponse.total`).
  final int total;

  /// Размер запрошенной страницы (echo из ответа).
  final int limit;

  /// Сдвиг этой страницы от начала истории (echo из ответа).
  final int offset;

  /// Есть ли ещё страницы за этой.
  bool get hasMore => offset + items.length < total;
}
