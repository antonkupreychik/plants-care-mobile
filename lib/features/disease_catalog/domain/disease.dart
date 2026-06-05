import 'package:freezed_annotation/freezed_annotation.dart';

part 'disease.freezed.dart';

/// Болезнь/вредитель из справочника (issue #68).
///
/// Чистый Dart, иммутабельна (MADR-002). Источник — backend-справочник
/// (`plants-care#225`), до появления эндпоинтов данные отдаёт
/// `FakeDiseaseCatalogRepositoryImpl`. Контент-поля (`name`, `symptoms`,
/// `treatment`, `prevention`) показываются как пришли с backend (MADR-012);
/// `latinName` опционально (не у каждой записи есть латинское название).
@freezed
abstract class Disease with _$Disease {
  const factory Disease({
    required int id,
    required String name,

    /// Латинское название (`Tetranychus urticae`). Может отсутствовать —
    /// тогда строка в детали скрывается.
    String? latinName,

    /// Описание симптомов.
    required String symptoms,

    /// Способы лечения.
    required String treatment,

    /// Меры профилактики.
    required String prevention,
  }) = _Disease;
}
