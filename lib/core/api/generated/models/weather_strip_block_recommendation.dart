// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// Рекомендация по поливу: `DEFER_OK` (можно отложить),.
/// `DO_NOT_DEFER` (лучше не откладывать), `NEUTRAL`.
/// `null`, если `available = false`.
///
@JsonEnum()
enum WeatherStripBlockRecommendation {
  @JsonValue('DEFER_OK')
  deferOk('DEFER_OK'),
  @JsonValue('DO_NOT_DEFER')
  doNotDefer('DO_NOT_DEFER'),
  @JsonValue('NEUTRAL')
  neutral('NEUTRAL'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const WeatherStripBlockRecommendation(this.json);

  factory WeatherStripBlockRecommendation.fromJson(String json) => values.firstWhere(
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
  static List<WeatherStripBlockRecommendation> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
