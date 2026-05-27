import 'package:flutter_test/flutter_test.dart';
import 'package:plantcate_mobile/core/auth/dev_auth_session.dart';
import 'package:plantcate_mobile/core/env/app_config.dart';
import 'package:plantcate_mobile/core/network/auth_scope.dart';

void main() {
  const config = AppConfig(
    flavor: Flavor.dev,
    apiUrl: 'https://x',
    chatId: '9000001',
    userId: '1',
  );
  const session = DevAuthSession(config);

  test('user scope → только X-User-Id', () {
    expect(session.headersFor(AuthScope.user), {'X-User-Id': '1'});
  });

  test('chat scope → только X-Chat-Id', () {
    expect(session.headersFor(AuthScope.chat), {'X-Chat-Id': '9000001'});
  });

  test('none scope → без заголовков', () {
    expect(session.headersFor(AuthScope.none), isEmpty);
  });

  test('без id в конфиге заголовки не проставляются', () {
    const empty = AppConfig(flavor: Flavor.prod, apiUrl: 'https://x');
    const s = DevAuthSession(empty);
    expect(s.headersFor(AuthScope.user), isEmpty);
    expect(s.headersFor(AuthScope.chat), isEmpty);
    expect(s.isAuthenticated, isFalse);
  });
}
