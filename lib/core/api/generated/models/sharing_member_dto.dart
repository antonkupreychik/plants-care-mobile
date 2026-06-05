// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'sharing_status.dart';

part 'sharing_member_dto.g.dart';

/// Соухаживающий — приглашение, выпущенное владельцем.
@JsonSerializable()
class SharingMemberDto {
  const SharingMemberDto({
    required this.id,
    required this.contact,
    required this.status,
    required this.canLogCare,
    required this.plantIds,
  });
  
  factory SharingMemberDto.fromJson(Map<String, Object?> json) => _$SharingMemberDtoFromJson(json);
  
  /// Идентификатор приглашения (membership).
  final int id;

  /// Контакт приглашённого (@username или телефон).
  final String contact;
  final SharingStatus status;

  /// Может ли приглашённый отмечать уход за растениями набора.
  final bool canLogCare;

  /// Растения, на которые распространяется приглашение.
  final List<int> plantIds;

  Map<String, Object?> toJson() => _$SharingMemberDtoToJson(this);
}
