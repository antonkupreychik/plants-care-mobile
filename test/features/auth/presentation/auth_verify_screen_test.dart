import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plantcare_mobile/core/env/app_config.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_verify_controller.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_verify_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

const _token = 'opaque-token';

/// Контроллер, который никогда не завершает build → экран остаётся в loading
/// (брендовый сплеш). Не мок: честный never-complete future.
class _LoadingController extends AuthVerifyController {
  @override
  Future<void> build(String token) => Completer<void>().future;
}

/// build бросает [ApiError] → экран в состоянии error.
class _ErrorController extends AuthVerifyController {
  @override
  Future<void> build(String token) async => throw const ApiError.badRequest();
}

/// build завершается успехом (void) → экран должен уйти на /home.
class _SuccessController extends AuthVerifyController {
  @override
  Future<void> build(String token) async {}
}

/// Монтирует verify-экран под реальным GoRouter, чтобы `context.go('/home')`
/// при успехе имел куда уходить (заглушка `/home`). [token] прокидывается в
/// `/auth/verify`.
Future<GoRouter> _pump(
  WidgetTester tester, {
  required List<Override> overrides,
  String? token,
}) async {
  final router = GoRouter(
    initialLocation: '/auth/verify',
    routes: [
      GoRoute(
        path: '/auth/verify',
        builder: (_, _) => AuthVerifyScreen(token: token),
      ),
      GoRoute(
        path: '/home',
        builder: (_, _) => const Scaffold(body: Text('home-route')),
      ),
      GoRoute(
        path: '/auth/welcome',
        builder: (_, _) => const Scaffold(body: Text('welcome-route')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    ),
  );
  return router;
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(AuthVerifyScreen)));

void main() {
  testWidgets('should_show_branded_splash_with_spinner_while_verifying',
      (tester) async {
    await _pump(
      tester,
      token: _token,
      overrides: [
        authVerifyControllerProvider(_token)
            .overrideWith(_LoadingController.new),
      ],
    );
    await tester.pump();

    final l10n = _l10n(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text(l10n.authVerifying), findsOneWidget);
  });

  testWidgets('should_show_error_message_and_retry_when_verify_fails',
      (tester) async {
    await _pump(
      tester,
      token: _token,
      overrides: [
        authVerifyControllerProvider(_token).overrideWith(_ErrorController.new),
      ],
    );
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    expect(find.text(l10n.authVerifyError), findsOneWidget);
    // Кнопка возврата ко входу.
    expect(find.text(l10n.authVerifyRetry), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should_navigate_to_home_when_verify_succeeds', (tester) async {
    final router = await _pump(
      tester,
      token: _token,
      overrides: [
        authVerifyControllerProvider(_token)
            .overrideWith(_SuccessController.new),
      ],
    );
    // ref.listen ловит AsyncData → context.go('/home').
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.uri.path, '/home');
    expect(find.text('home-route'), findsOneWidget);
    expect(find.byType(AuthVerifyScreen), findsNothing);
  });

  testWidgets('should_show_dev_token_form_when_token_empty_and_dev_build',
      (tester) async {
    // Dev-хук: пустой токен + dev-конфиг → ручной ввод токена (нет сетевого
    // вызова, нет подписки на verify-controller).
    await _pump(
      tester,
      token: null,
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(flavor: Flavor.dev, apiUrl: 'https://example.test'),
        ),
      ],
    );
    await tester.pump();

    final l10n = _l10n(tester);
    expect(find.text('DEV'), findsOneWidget);
    expect(find.text(l10n.authDevTokenLabel), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('should_show_error_when_token_empty_and_prod_build',
      (tester) async {
    // В prod пустой токен → короткая ошибка с возвратом, без dev-формы.
    await _pump(
      tester,
      token: null,
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(flavor: Flavor.prod, apiUrl: 'https://example.test'),
        ),
      ],
    );
    await tester.pump();

    final l10n = _l10n(tester);
    expect(find.text(l10n.authVerifyError), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('DEV'), findsNothing);
  });
}
