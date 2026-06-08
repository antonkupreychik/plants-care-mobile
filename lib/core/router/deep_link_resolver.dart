/// Преобразует входящий URI (deep link / universal link) в app-путь для go_router.
///
/// Поддерживаемые форматы (issue #127):
///
/// **Custom scheme (magic-link):**
///   `plantcare://auth/verify?token=<opaque>` → `/auth/verify?token=<opaque>`
///
/// **Universal links (HTTPS, backend #215):**
///   `https://plants-care.up.railway.app/auth/verify?token=<opaque>` →
///     `/auth/verify?token=<opaque>`
///   `https://plants-care.up.railway.app/plants/:id` →
///     `/home/plants/:id`
///
/// Возвращает `null`, если URI не распознан (неизвестная схема/путь, отсутствующие
/// обязательные параметры). Вызывающий код должен игнорировать `null`.
///
/// Класс — чистый Dart (без Flutter-импортов), тестируется unit-тестами.
class DeepLinkResolver {
  const DeepLinkResolver({String? universalLinkHost})
      : _host = universalLinkHost ?? 'plants-care.up.railway.app';

  final String _host;

  static final _plantPathRegex = RegExp(r'^/plants/(\d+)$');

  /// Возвращает app-путь (`/auth/verify?token=…`, `/home/plants/7`, …) или
  /// `null` если URI не распознан.
  String? resolve(Uri uri) {
    // 1. Custom scheme: plantcare://auth/verify?token=…
    if (uri.scheme == 'plantcare') {
      return _resolveAuthVerify(uri.queryParameters);
    }

    // 2. Universal links: https://<_host>/…
    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host == _host) {
      return _resolveUniversalPath(uri.path, uri.queryParameters);
    }

    return null;
  }

  String? _resolveAuthVerify(Map<String, String> params) {
    final token = params['token'];
    if (token == null || token.isEmpty) return null;
    return '/auth/verify?token=$token';
  }

  String? _resolveUniversalPath(
      String path, Map<String, String> queryParams) {
    // /auth/verify?token=… — magic-link вход
    if (path == '/auth/verify') {
      return _resolveAuthVerify(queryParams);
    }

    // /plants/:id — открыть карточку растения
    final plantMatch = _plantPathRegex.firstMatch(path);
    if (plantMatch != null) {
      final plantId = plantMatch.group(1);
      return '/home/plants/$plantId';
    }

    return null;
  }
}
