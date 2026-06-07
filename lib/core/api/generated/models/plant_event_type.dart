// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// Тип события в журнале растения. Редкие разовые события (не регулярный.
/// уход): пересадка, замена грунта, обрезка, обработка от вредителей.
///
@JsonEnum()
enum PlantEventType {
  @JsonValue('TRANSPLANT')
  transplant('TRANSPLANT'),
  @JsonValue('SOIL_CHANGE')
  soilChange('SOIL_CHANGE'),
  @JsonValue('PRUNING')
  pruning('PRUNING'),
  @JsonValue('PEST_TREATMENT')
  pestTreatment('PEST_TREATMENT'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const PlantEventType(this.json);

  factory PlantEventType.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
  String toJson() {
    final value = json;
    if (value == null) {
      throw StateError('Cannot convert enum value with null JSON representation to String. '
          'This usually happens for \$unknown or @JsonValue(null) entries.');
    }
    return value as String;
  }

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<PlantEventType> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
