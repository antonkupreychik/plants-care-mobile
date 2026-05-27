import 'package:freezed_annotation/freezed_annotation.dart';

import 'species.dart';

part 'species_page.freezed.dart';

/// Одна страница списка видов (источник — `PageResponseSpeciesSummaryDto`).
///
/// Несёт [total] — общее число видов с учётом фильтра `q`. По нему presentation
/// решает, есть ли ещё страницы (`accumulated.length < total`). [offset]/[limit]
/// сохранены для прозрачности и расчёта следующего запроса.
@freezed
abstract class SpeciesPage with _$SpeciesPage {
  const factory SpeciesPage({
    required List<Species> items,

    /// Общее количество видов под фильтром `q` (для пагинации).
    required int total,
    required int offset,
    required int limit,
  }) = _SpeciesPage;
}
