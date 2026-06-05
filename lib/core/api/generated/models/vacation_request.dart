// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'vacation_request.g.dart';

/// Запрос на включение режима отпуска.
@JsonSerializable()
class VacationRequest {
  const VacationRequest({
    required this.from,
    required this.to,
  });
  
  factory VacationRequest.fromJson(Map<String, Object?> json) => _$VacationRequestFromJson(json);
  
  /// Начало отпуска (включительно). Формат `YYYY-MM-DD`. Как правило,.
  /// сегодняшняя дата или ближайшая в будущем.
  ///
  final DateTime from;

  /// Конец отпуска (включительно). Формат `YYYY-MM-DD`. Должно быть.
  /// ≥ `from` и не более 60 дней от `from`.
  ///
  final DateTime to;

  Map<String, Object?> toJson() => _$VacationRequestToJson(this);
}
