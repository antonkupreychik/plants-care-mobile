// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/sharing_invite_create_request.dart';
import '../models/sharing_member_dto.dart';
import '../models/sharing_members_response.dart';

part 'sharing_client.g.dart';

@RestApi()
abstract class SharingClient {
  factory SharingClient(Dio dio, {String? baseUrl}) = _SharingClient;

  /// Соухаживающие текущего пользователя.
  ///
  /// Возвращает приглашения, выпущенные текущим пользователем.
  /// (`sub` из bearer-токена), со статусом (`PENDING`/`ACCEPTED`),.
  /// правом `canLogCare` и набором растений каждого приглашения.
  @GET('/api/v1/sharing')
  Future<SharingMembersResponse> listSharingMembers({
    @Extras() Map<String, dynamic>? extras,
  });

  /// Пригласить соухаживающего.
  ///
  /// Создаёт приглашение на набор растений с правом `canLogCare`.
  /// Растения должны принадлежать текущему пользователю — иначе 404.
  /// Пустой набор растений или пустой контакт — 400.
  @POST('/api/v1/sharing/invites')
  Future<SharingMemberDto> createSharingInvite({
    @Body() required SharingInviteCreateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });
}
