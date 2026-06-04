import 'package:freezed_annotation/freezed_annotation.dart';

part 'disease.freezed.dart';

/// Краткая карточка болезни/вредителя для секции поиска (issue #69).
///
/// Чистый Dart, иммутабельна. Источник данных — `GET /diseases?q=&limit=5`,
/// которого ПОКА НЕТ на бэкенде (ждёт plants-care#225). До его появления
/// `diseaseSearchResultsProvider` отдаёт пустой список (заглушка), а полноценный
/// маппинг DTO ↔ domain и репозиторий добавляются вместе с эндпоинтом. Модель
/// заведена здесь заранее, чтобы `SearchResult.disease` и UI секции уже имели тип.
@freezed
abstract class Disease with _$Disease {
  const factory Disease({
    required int id,
    required String name,

    /// Латинское/научное имя (`Tetranychus urticae`). Может отсутствовать.
    String? latinName,
  }) = _Disease;
}
