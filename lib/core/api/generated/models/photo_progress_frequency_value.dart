// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// Частота напоминаний о фото: `OFF` — выключено, `P2W` — раз в 2 недели,.
/// `P1M` — раз в месяц.
///
@JsonEnum()
enum PhotoProgressFrequencyValue {
  @JsonValue('OFF')
  off('OFF'),
  @JsonValue('P2W')
  p2W('P2W'),
  @JsonValue('P1M')
  p1M('P1M'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const PhotoProgressFrequencyValue(this.json);

  factory PhotoProgressFrequencyValue.fromJson(String json) => values.firstWhere(
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
  static List<PhotoProgressFrequencyValue> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
