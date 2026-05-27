// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'task_dto.dart';
export 'task_dto.dart';

/// Карта `date → tasks` для эндпоинта `/api/v1/calendar`. Ключи — строки.
/// в формате `YYYY-MM-DD`. В JSON отсортированы по возрастанию.
///
/// ⚠️ Внутренний $ref на TaskDto использует bundle-путь.
/// `#/components/schemas/TaskDto` (а не относительный к этому файлу),.
/// потому что openapi-generator 7.10 теряет типизацию items внутри.
/// `additionalProperties` при cross-file разрешении.
///
typedef CalendarResponse = Map<String, List<TaskDto>>;
