import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';

part 'me_provider.g.dart';

/// Флаг гостевого аккаунта из `GET /api/v1/me`.
///
/// Используется баннером конвертации на Home-экране. Провайдер инвалидируется
/// после успешной конвертации (баннер исчезает). При ошибке возвращает `null`
/// (баннер тихо скрывается — не блокируем пользователя).
///
/// Не переиспользует [profileSummaryProvider], чтобы инвалидация баннера не
/// сбрасывала всю шапку профиля.
@riverpod
Future<bool?> meIsGuest(Ref ref) async {
  final api = ref.watch(plantsCareApiProvider);
  try {
    final me = await api.me.getMe(extras: authScopeExtra(AuthScope.user));
    return me.isGuest;
  } on DioException catch (_) {
    return null;
  }
}
