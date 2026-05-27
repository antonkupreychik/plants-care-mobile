// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'species_summary_dto.dart';

part 'page_response_species_summary_dto.g.dart';

/// Постраничный ответ со списком видов. Унифицирован под `{items, total,.
/// offset, limit}` — отличается от прошлой реализации, где было.
/// `{content, page, size, totalElements, totalPages}`. Это **breaking.
/// change** для существующих клиентов `/api/v1/species`.
///
@JsonSerializable()
class PageResponseSpeciesSummaryDto {
  const PageResponseSpeciesSummaryDto({
    required this.items,
    required this.total,
    required this.offset,
    required this.limit,
  });
  
  factory PageResponseSpeciesSummaryDto.fromJson(Map<String, Object?> json) => _$PageResponseSpeciesSummaryDtoFromJson(json);
  
  final List<SpeciesSummaryDto> items;

  /// Общее количество видов (с учётом фильтра `q`).
  final int total;
  final int offset;
  final int limit;

  Map<String, Object?> toJson() => _$PageResponseSpeciesSummaryDtoToJson(this);
}
