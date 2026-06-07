// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/accept_invite_response.dart';
import '../models/location_invite_response.dart';
import '../models/location_members_response.dart';
import '../models/shared_locations_response.dart';

part 'location_sharing_client.g.dart';

@RestApi()
abstract class LocationSharingClient {
  factory LocationSharingClient(Dio dio, {String? baseUrl}) = _LocationSharingClient;

  /// Создать приглашение к локации.
  ///
  /// Генерирует одноразовый токен приглашения к локации. Только OWNER локации.
  /// (`locations.user_id = current user`) может создавать приглашения.
  /// Токен действует 7 дней. Повторная попытка принять использованный токен → 410.
  ///
  /// [id] - Идентификатор локации.
  @POST('/api/v1/locations/{id}/invites')
  Future<LocationInviteResponse> createLocationInvite({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Список участников локации.
  ///
  /// Возвращает всех участников локации (OWNER + CARETAKER) с ролями.
  /// Доступно OWNER'у и CARETAKER'ам локации.
  ///
  /// [id] - Идентификатор локации.
  @GET('/api/v1/locations/{id}/members')
  Future<LocationMembersResponse> listLocationMembers({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Отозвать доступ участника.
  ///
  /// Удаляет доступ пользователя к локации. Только OWNER может отзывать доступ.
  /// Нельзя удалить последнего OWNER'а локации → 409.
  /// OWNER не может удалить себя (нельзя удалить последнего OWNER) → 409.
  ///
  /// [id] - Идентификатор локации.
  ///
  /// [userId] - Идентификатор пользователя, у которого отзывается доступ.
  @DELETE('/api/v1/locations/{id}/members/{userId}')
  Future<void> revokeLocationAccess({
    @Path('id') required int id,
    @Path('userId') required int userId,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Принять приглашение к локации.
  ///
  /// Принимает одноразовый токен приглашения и выдаёт роль CARETAKER текущему пользователю.
  /// Идемпотентно: повторный accept тем же пользователем возвращает 200.
  /// Токен просрочен → 410. Токен уже использован другим пользователем → 410.
  /// Владелец не может принять собственное приглашение → 403.
  ///
  /// [token] - Одноразовый токен приглашения.
  @POST('/api/v1/invites/{token}/accept')
  Future<AcceptInviteResponse> acceptLocationInvite({
    @Path('token') required String token,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Локации с доступом CARETAKER.
  ///
  /// Возвращает локации, к которым у текущего пользователя есть доступ.
  /// как CARETAKER (т.е. не его собственные, а те, куда его пригласили).
  @GET('/api/v1/shared-locations')
  Future<SharedLocationsResponse> listSharedLocations({
    @Extras() Map<String, dynamic>? extras,
  });
}
