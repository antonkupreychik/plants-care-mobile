import 'package:dio/dio.dart';

import 'auth_scope.dart';

/// Ключ в `RequestOptions.extra`, по которому data source передаёт [AuthScope],
/// а [AuthInterceptor] его читает. Единая точка правды для обеих сторон.
const String kAuthScopeExtraKey = 'authScope';

/// Хелпер для data source при прямом вызове dio:
/// `dio.get(path, options: withAuthScope(AuthScope.chat))`.
Options withAuthScope(AuthScope scope) =>
    Options(extra: {kAuthScopeExtraKey: scope});

/// Хелпер для сгенерированного Retrofit-клиента (`@Extras()` параметр):
/// `api.plants.listPlants(extras: authScopeExtra(AuthScope.user))`.
Map<String, dynamic> authScopeExtra(AuthScope scope) =>
    {kAuthScopeExtraKey: scope};
