// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'action_descriptor_kind.dart';

part 'action_descriptor.g.dart';

/// Декларативное описание действия (SDUI): что и как отправить на backend.
/// Клиент выполняет HTTP-запрос `method path` с телом `payloadTemplate`.
///
@JsonSerializable()
class ActionDescriptor {
  const ActionDescriptor({
    required this.kind,
    required this.method,
    required this.path,
    this.payloadTemplate,
  });
  
  factory ActionDescriptor.fromJson(Map<String, Object?> json) => _$ActionDescriptorFromJson(json);
  
  /// Тип действия. Клиент сопоставляет его с обработчиком.
  final ActionDescriptorKind kind;

  /// HTTP-метод запроса действия (например, `POST`).
  final String method;

  /// Относительный путь запроса действия (например, `/care-events`).
  final String path;

  /// Шаблон тела запроса действия. Свободная форма (object): backend.
  /// задаёт набор полей. Для `log_care` содержит, например,.
  /// `plantId` и `type`.
  ///
  final dynamic payloadTemplate;

  Map<String, Object?> toJson() => _$ActionDescriptorToJson(this);
}
