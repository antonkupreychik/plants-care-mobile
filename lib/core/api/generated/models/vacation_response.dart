// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'vacation_response.g.dart';

/// Статус режима отпуска. Если отпуск не активен — `active = false`.
/// и `pausedUntil = null`.
///
@JsonSerializable()
class VacationResponse {
  const VacationResponse({
    required this.active,
    this.pausedUntil,
  });
  
  factory VacationResponse.fromJson(Map<String, Object?> json) => _$VacationResponseFromJson(json);
  
  /// `true` — режим отпуска сейчас включён.
  final bool active;

  /// Момент до которого паузированы напоминания (UTC). `null` если отпуск.
  /// неактивен.
  ///
  final DateTime? pausedUntil;

  Map<String, Object?> toJson() => _$VacationResponseToJson(this);
}
