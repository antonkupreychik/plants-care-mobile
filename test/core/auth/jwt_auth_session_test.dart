import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/auth/jwt_auth_session.dart';
import 'package:plantcare_mobile/core/auth/token_store.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

const _access = 'access-abc';
const _refresh = 'refresh-xyz';
const _tokens = AuthTokens(accessToken: _access, refreshToken: _refresh);

void main() {
  late _MockStorage storage;
  late TokenStore store;

  setUp(() {
    storage = _MockStorage();
    // Запись/удаление в защищённое хранилище — no-op в тесте, проверяем через verify.
    when(() => storage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => storage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});
    store = TokenStore(storage);
  });

  group('headersFor', () {
    test('should_return_bearer_for_user_scope_when_authenticated', () {
      final session = JwtAuthSession(store, initial: _tokens);

      expect(
        session.headersFor(AuthScope.user),
        {'Authorization': 'Bearer $_access'},
      );
    });

    test('should_return_bearer_for_chat_scope_when_authenticated', () {
      final session = JwtAuthSession(store, initial: _tokens);

      expect(
        session.headersFor(AuthScope.chat),
        {'Authorization': 'Bearer $_access'},
      );
    });

    test('should_return_empty_for_none_scope_when_authenticated', () {
      final session = JwtAuthSession(store, initial: _tokens);

      expect(session.headersFor(AuthScope.none), isEmpty);
    });

    test('should_return_empty_for_any_scope_when_no_token', () {
      final session = JwtAuthSession(store);

      expect(session.headersFor(AuthScope.user), isEmpty);
      expect(session.headersFor(AuthScope.chat), isEmpty);
      expect(session.headersFor(AuthScope.none), isEmpty);
    });
  });

  group('isAuthenticated', () {
    test('should_be_true_when_initial_pair_present', () {
      final session = JwtAuthSession(store, initial: _tokens);

      expect(session.isAuthenticated, isTrue);
    });

    test('should_be_false_when_no_initial_pair', () {
      final session = JwtAuthSession(store);

      expect(session.isAuthenticated, isFalse);
    });
  });

  group('refreshToken', () {
    test('should_return_refresh_token_when_authenticated', () {
      final session = JwtAuthSession(store, initial: _tokens);

      expect(session.refreshToken, _refresh);
    });

    test('should_return_null_when_no_token', () {
      final session = JwtAuthSession(store);

      expect(session.refreshToken, isNull);
    });
  });

  group('updateTokens', () {
    test('should_expose_bearer_after_update_when_starting_empty', () async {
      final session = JwtAuthSession(store);

      await session.updateTokens(_tokens);

      // Память отражает новую пару: bearer и refresh доступны.
      expect(session.isAuthenticated, isTrue);
      expect(
        session.headersFor(AuthScope.user),
        {'Authorization': 'Bearer $_access'},
      );
      expect(session.refreshToken, _refresh);
    });

    test('should_persist_pair_to_store_when_updating', () async {
      final session = JwtAuthSession(store);

      await session.updateTokens(_tokens);

      // Персист: обе части пары записаны в защищённое хранилище.
      verify(() => storage.write(
            key: 'auth_access_token',
            value: _access,
          )).called(1);
      verify(() => storage.write(
            key: 'auth_refresh_token',
            value: _refresh,
          )).called(1);
    });

    test('should_replace_previous_pair_when_rotating', () async {
      final session = JwtAuthSession(store, initial: _tokens);

      const rotated = AuthTokens(
        accessToken: 'access-new',
        refreshToken: 'refresh-new',
      );
      await session.updateTokens(rotated);

      expect(
        session.headersFor(AuthScope.user),
        {'Authorization': 'Bearer access-new'},
      );
      expect(session.refreshToken, 'refresh-new');
    });
  });

  group('clear', () {
    test('should_drop_memory_when_cleared', () async {
      final session = JwtAuthSession(store, initial: _tokens);

      await session.clear();

      // Память сброшена: больше не аутентифицированы, заголовков нет.
      expect(session.isAuthenticated, isFalse);
      expect(session.headersFor(AuthScope.user), isEmpty);
      expect(session.refreshToken, isNull);
    });

    test('should_delete_pair_from_store_when_cleared', () async {
      final session = JwtAuthSession(store, initial: _tokens);

      await session.clear();

      // Персист очищен: после рестарта мёртвый токен не подхватится.
      verify(() => storage.delete(key: 'auth_access_token')).called(1);
      verify(() => storage.delete(key: 'auth_refresh_token')).called(1);
    });
  });
}
