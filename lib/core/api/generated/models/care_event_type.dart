// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// Публичный тип ухода. **Намеренно не совпадает** один-к-одному с.
/// внутренним `TaskType`: API-контракт стабилен и не зависит от.
/// эволюции доменной модели. Тип `SOIL_CHECK` через REST не доступен.
///
@JsonEnum()
enum CareEventType {
  @JsonValue('WATER')
  water('WATER'),
  @JsonValue('SPRAY')
  spray('SPRAY'),
  @JsonValue('FERTILIZE')
  fertilize('FERTILIZE'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const CareEventType(this.json);

  factory CareEventType.fromJson(String json) => values.firstWhere(
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
  static List<CareEventType> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
