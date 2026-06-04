// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'token_pair_response.g.dart';

/// Пара токенов доступа (issue
@JsonSerializable()
class TokenPairResponse {
  const TokenPairResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });
  
  factory TokenPairResponse.fromJson(Map<String, Object?> json) => _$TokenPairResponseFromJson(json);
  
  /// Короткоживущий access-JWT для авторизации запросов к API.
  final String accessToken;

  /// Долгоживущий refresh-JWT для получения новой пары.
  final String refreshToken;

  /// Время жизни access-токена в секундах.
  final int expiresIn;

  /// Тип токена для заголовка Authorization.
  final String tokenType;

  Map<String, Object?> toJson() => _$TokenPairResponseToJson(this);
}
