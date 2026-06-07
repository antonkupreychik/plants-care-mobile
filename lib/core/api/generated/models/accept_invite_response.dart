// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'location_access_role.dart';

part 'accept_invite_response.g.dart';

/// Результат принятия приглашения.
@JsonSerializable()
class AcceptInviteResponse {
  const AcceptInviteResponse({
    required this.locationId,
    required this.locationName,
    required this.role,
  });
  
  factory AcceptInviteResponse.fromJson(Map<String, Object?> json) => _$AcceptInviteResponseFromJson(json);
  
  /// Идентификатор локации, к которой выдан доступ.
  final int locationId;

  /// Отображаемое имя локации.
  final String locationName;
  final LocationAccessRole role;

  Map<String, Object?> toJson() => _$AcceptInviteResponseToJson(this);
}
