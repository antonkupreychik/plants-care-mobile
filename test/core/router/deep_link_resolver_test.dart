import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/router/deep_link_resolver.dart';

void main() {
  const resolver = DeepLinkResolver();

  group('DeepLinkResolver — custom scheme (plantcare://)', () {
    test('should_resolve_magic_link_custom_scheme', () {
      final uri =
          Uri.parse('plantcare://auth/verify?token=abc123');
      expect(resolver.resolve(uri), '/auth/verify?token=abc123');
    });

    test('should_return_null_when_token_is_empty_custom_scheme', () {
      final uri = Uri.parse('plantcare://auth/verify?token=');
      expect(resolver.resolve(uri), isNull);
    });

    test('should_return_null_when_token_is_missing_custom_scheme', () {
      final uri = Uri.parse('plantcare://auth/verify');
      expect(resolver.resolve(uri), isNull);
    });
  });

  group('DeepLinkResolver — universal links (https://)', () {
    test('should_resolve_magic_link_https', () {
      final uri = Uri.parse(
          'https://plants-care.up.railway.app/auth/verify?token=xyz');
      expect(resolver.resolve(uri), '/auth/verify?token=xyz');
    });

    test('should_resolve_plant_card_https', () {
      final uri =
          Uri.parse('https://plants-care.up.railway.app/plants/42');
      expect(resolver.resolve(uri), '/home/plants/42');
    });

    test('should_return_null_for_unknown_path_https', () {
      final uri =
          Uri.parse('https://plants-care.up.railway.app/unknown/path');
      expect(resolver.resolve(uri), isNull);
    });

    test('should_return_null_when_token_is_missing_https', () {
      final uri =
          Uri.parse('https://plants-care.up.railway.app/auth/verify');
      expect(resolver.resolve(uri), isNull);
    });

    test('should_return_null_when_plant_id_is_non_numeric_https', () {
      final uri =
          Uri.parse('https://plants-care.up.railway.app/plants/abc');
      expect(resolver.resolve(uri), isNull);
    });

    test('should_return_null_for_wrong_host', () {
      final uri = Uri.parse('https://evil.example.com/auth/verify?token=x');
      expect(resolver.resolve(uri), isNull);
    });

    test('should_return_null_for_http_scheme_wrong_host', () {
      final uri = Uri.parse('http://evil.example.com/plants/7');
      expect(resolver.resolve(uri), isNull);
    });

    test('should_resolve_http_universal_link_correct_host', () {
      // app_links может вернуть http на эмуляторе — обрабатываем.
      final uri =
          Uri.parse('http://plants-care.up.railway.app/plants/7');
      expect(resolver.resolve(uri), '/home/plants/7');
    });
  });

  group('DeepLinkResolver — unknown schemes', () {
    test('should_return_null_for_tel_scheme', () {
      final uri = Uri.parse('tel:+1234567890');
      expect(resolver.resolve(uri), isNull);
    });

    test('should_return_null_for_mailto_scheme', () {
      final uri = Uri.parse('mailto:user@example.com');
      expect(resolver.resolve(uri), isNull);
    });
  });

  group('DeepLinkResolver — custom host override', () {
    const devResolver = DeepLinkResolver(
        universalLinkHost: 'plants-care-development.up.railway.app');

    test('should_resolve_plant_card_on_dev_host', () {
      final uri = Uri.parse(
          'https://plants-care-development.up.railway.app/plants/5');
      expect(devResolver.resolve(uri), '/home/plants/5');
    });

    test('should_return_null_for_prod_host_on_dev_resolver', () {
      final uri =
          Uri.parse('https://plants-care.up.railway.app/plants/5');
      expect(devResolver.resolve(uri), isNull);
    });
  });
}
