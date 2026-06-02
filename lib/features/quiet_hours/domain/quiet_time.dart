import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiet_time.freezed.dart';

/// Время суток `HH:mm` для тихих часов (экраны 23/36).
///
/// Доменный value object вместо `flutter` `TimeOfDay` — domain остаётся чистым
/// Dart (FLUTTER.md: ни одного `import 'package:flutter/...'`). Пикер времени
/// (экран 36) читает/пишет [hour] и [minute]; backend хранит/принимает строку
/// `HH:mm` (24-часовой формат), парсинг и форматирование — [parse]/[format].
///
/// Инварианты: `0 <= hour <= 23`, `0 <= minute <= 59`. Значения вне диапазона
/// клампятся в [QuietTime.clamped] (защита от мусора с backend/UI).
@freezed
abstract class QuietTime with _$QuietTime {
  const factory QuietTime({
    required int hour,
    required int minute,
  }) = _QuietTime;

  const QuietTime._();

  /// Конструктор с клампом в допустимый диапазон (часы 0..23, минуты 0..59).
  /// Используем при разборе значений извне (backend/UI), чтобы модель всегда
  /// держала инвариант.
  factory QuietTime.clamped({required int hour, required int minute}) =>
      QuietTime(
        hour: hour.clamp(0, 23),
        minute: minute.clamp(0, 59),
      );

  /// Разбирает строку backend `HH:mm` (например `22:00`). Допускает `H:mm` и
  /// лишние пробелы. Возвращает `null`, если строка не похожа на время —
  /// маппер сам решит, чем заменить (fallback на дефолт).
  static QuietTime? parse(String raw) {
    final parts = raw.trim().split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0].trim());
    final minute = int.tryParse(parts[1].trim());
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return QuietTime(hour: hour, minute: minute);
  }

  /// Сериализует в backend-формат `HH:mm` (zero-padded, например `08:00`).
  String format() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
