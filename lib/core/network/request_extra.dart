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

/// Ключ в `RequestOptions.extra` со множеством имён query-параметров, значения
/// которых [DateQueryInterceptor] должен усечь до date-only (`YYYY-MM-DD`).
const String kDateOnlyQueryKeysExtraKey = 'dateOnlyQueryKeys';

/// Хелпер для сгенерированного Retrofit-клиента: помечает query-параметры,
/// которые backend ждёт как `date` (без времени), но кодген сериализует через
/// `DateTime.toIso8601String()`. См. [DateQueryInterceptor].
///
/// Extras от разных хелперов объединяются в месте вызова, т.к. это `Map`:
/// `extras: {...authScopeExtra(AuthScope.chat), ...dateOnlyQueryExtra({'from', 'to'})}`.
Map<String, dynamic> dateOnlyQueryExtra(Set<String> keys) =>
    {kDateOnlyQueryKeysExtraKey: keys};
