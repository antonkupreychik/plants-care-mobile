// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'day_progress.dart';
export 'day_progress.dart';

/// Карта `date → {planned, done}` для эндпоинта `/api/v1/calendar/progress`.
/// Ключи — строки `YYYY-MM-DD`, отсортированы по возрастанию. Значения —.
/// объекты `DayProgress`.
///
typedef CalendarProgressResponse = Map<String, DayProgress>;
