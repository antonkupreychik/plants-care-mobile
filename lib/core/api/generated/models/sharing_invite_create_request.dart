// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'sharing_invite_create_request.g.dart';

@JsonSerializable()
class SharingInviteCreateRequest {
  const SharingInviteCreateRequest({
    required this.plantIds,
    required this.inviteeContact,
    this.canLogCare = false,
  });
  
  factory SharingInviteCreateRequest.fromJson(Map<String, Object?> json) => _$SharingInviteCreateRequestFromJson(json);
  
  /// Растения, на которые выдаётся доступ. Минимум одно.
  final List<int> plantIds;

  /// Контакт приглашённого — @username или телефон.
  final String inviteeContact;

  /// Дать ли приглашённому право отмечать уход. По умолчанию false.
  final bool canLogCare;

  Map<String, Object?> toJson() => _$SharingInviteCreateRequestToJson(this);
}
