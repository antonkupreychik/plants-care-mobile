import 'package:freezed_annotation/freezed_annotation.dart';

import '../../plant_card/domain/care_history_entry.dart';

part 'care_history_page.freezed.dart';

/// Одна страница истории ухода (источник — `GET /plants/{id}/history`,
/// `PlantHistoryResponse`).
///
/// Чистый Dart. Несёт записи страницы ([items]) и метаданные пагинации
/// ([total]/[limit]/[offset]) ровно как их отдаёт backend — клиент их не
/// пересчитывает. Накопление страниц и клиентскую фильтрацию делает
/// presentation (`CareHistoryController`), а не эта модель.
///
/// [CareHistoryEntry] переиспользуется из domain фичи `plant_card` (та же
/// модель, тот же DTO) — не дублируем (FLUTTER.md / MADR-003: кросс-фичевая
/// зависимость на domain допустима).
@freezed
abstract class CareHistoryPage with _$CareHistoryPage {
  const factory CareHistoryPage({
    /// Записи этой страницы, в порядке backend (новые сверху). Клиент порядок
    /// не меняет.
    required List<CareHistoryEntry> items,

    /// Общее количество активных записей истории (по всем страницам).
    required int total,

    /// Размер запрошенной страницы (echo из ответа).
    required int limit,

    /// Сдвиг этой страницы от начала истории (echo из ответа).
    required int offset,
  }) = _CareHistoryPage;

  const CareHistoryPage._();

  /// Есть ли ещё страницы за этой: позиция конца текущей страницы
  /// (`offset + items.length`) меньше общего числа записей.
  bool get hasMore => offset + items.length < total;
}
