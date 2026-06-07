// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_convert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestConvertRequest _$GuestConvertRequestFromJson(Map<String, dynamic> json) =>
    GuestConvertRequest(
      provider: GuestConvertRequestProvider.fromJson(
        json['provider'] as String,
      ),
      email: json['email'] as String?,
      idToken: json['idToken'] as String?,
    );

Map<String, dynamic> _$GuestConvertRequestToJson(
  GuestConvertRequest instance,
) => <String, dynamic>{
  'provider': instance.provider,
  'email': instance.email,
  'idToken': instance.idToken,
};
