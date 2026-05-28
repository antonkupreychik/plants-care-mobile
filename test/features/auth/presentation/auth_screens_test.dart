import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_code_screen.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_welcome_back_screen.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_welcome_screen.dart';
import 'package:plantcare_mobile/features/auth/presentation/widgets/auth_keypad.dart';
import 'package:plantcare_mobile/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:plantcare_mobile/features/auth/presentation/widgets/auth_social_button.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

/// Монтирует [child] на корневом маршруте через настоящий GoRouter — экраны
/// используют `context.push` / `context.go`, которым нужен Router-контекст.
/// Заглушки-маршруты `/auth/code`, `/auth/welcome-back`, `/home`, `/home/add`
/// дают навигации куда уходить, не падая.
Future<void> _pump(WidgetTester tester, Widget child) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => child),
      GoRoute(
        path: '/auth/code',
        builder: (_, _) => const Scaffold(body: Text('code-route')),
      ),
      GoRoute(
        path: '/auth/welcome-back',
        builder: (_, _) => const Scaffold(body: Text('welcome-back-route')),
      ),
      GoRoute(
        path: '/home',
        builder: (_, _) => const Scaffold(body: Text('home-route')),
      ),
      GoRoute(
        path: '/home/add',
        builder: (_, _) => const Scaffold(body: Text('add-route')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp.router(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();
}

AppLocalizations _l10n(WidgetTester tester, Type screen) =>
    AppLocalizations.of(tester.element(find.byType(screen)));

void main() {
  group('AuthWelcomeScreen (07)', () {
    testWidgets('should_render_all_three_entry_buttons', (tester) async {
      await _pump(tester, const AuthWelcomeScreen());
      final l10n = _l10n(tester, AuthWelcomeScreen);
      expect(find.widgetWithText(AuthSocialButton, l10n.authContinueGoogle),
          findsOneWidget);
      expect(find.widgetWithText(AuthSocialButton, l10n.authContinueTelegram),
          findsOneWidget);
      expect(find.text(l10n.authContinueGuest), findsOneWidget);
    });

    testWidgets('should_show_coming_soon_snackbar_when_google_tapped',
        (tester) async {
      await _pump(tester, const AuthWelcomeScreen());
      final l10n = _l10n(tester, AuthWelcomeScreen);
      await tester.tap(
          find.widgetWithText(AuthSocialButton, l10n.authContinueGoogle));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(l10n.comingSoon), findsOneWidget);
    });
  });

  group('AuthCodeScreen (08)', () {
    // ВНИМАНИЕ: экран держит активный Timer.periodic — pumpAndSettle зависнет.
    // Используем точечный pump(). Перед завершением теста уводим экран на
    // другой маршрут (context.go), чтобы AutoDispose-контроллер отменил таймер.

    /// Тапает цифры на клавиатуре. Ищем текст цифры именно внутри [AuthKeypad]
    /// (в ячейках кода те же цифры тоже появляются — отделяем по поддереву).
    Future<void> enterDigits(
        WidgetTester tester, List<String> digits) async {
      for (final d in digits) {
        await tester.tap(
          find.descendant(
            of: find.byType(AuthKeypad),
            matching: find.text(d),
          ),
        );
        await tester.pump();
      }
    }

    /// Размонтирует экран, чтобы AutoDispose отменил Timer.periodic и тест не
    /// упал с «Timer still pending».
    Future<void> disposeScreen(WidgetTester tester) async {
      final ctx = tester.element(find.byType(AuthCodeScreen));
      GoRouter.of(ctx).go('/home');
      await tester.pump();
      await tester.pump();
    }

    testWidgets('should_fill_cells_as_digits_are_entered', (tester) async {
      await _pump(tester, const AuthCodeScreen());

      await enterDigits(tester, const ['1', '2', '3']);

      // Введённые цифры отрисованы в ячейках кода.
      expect(find.text('1'), findsWidgets);
      expect(find.text('2'), findsWidgets);
      expect(find.text('3'), findsWidgets);

      await disposeScreen(tester);
    });

    testWidgets('should_keep_continue_disabled_until_six_digits',
        (tester) async {
      await _pump(tester, const AuthCodeScreen());

      // До шести цифр CTA «Продолжить» disabled.
      await enterDigits(tester, const ['1', '2', '3', '4', '5']);
      var btn = tester.widget<AuthPrimaryButton>(
        find.byType(AuthPrimaryButton),
      );
      expect(btn.enabled, isFalse);

      // Шестая цифра → CTA активна.
      await enterDigits(tester, const ['6']);
      btn = tester.widget<AuthPrimaryButton>(find.byType(AuthPrimaryButton));
      expect(btn.enabled, isTrue);

      await disposeScreen(tester);
    });

    testWidgets('should_remove_digit_when_backspace_tapped', (tester) async {
      await _pump(tester, const AuthCodeScreen());
      await enterDigits(tester, const ['1', '2', '3', '4', '5', '6']);
      expect(
        tester.widget<AuthPrimaryButton>(find.byType(AuthPrimaryButton)).enabled,
        isTrue,
      );

      await tester.tap(
        find.descendant(
          of: find.byType(AuthKeypad),
          matching: find.byIcon(Icons.backspace_outlined),
        ),
      );
      await tester.pump();

      // Удалили одну цифру → снова неполный код, CTA disabled.
      expect(
        tester.widget<AuthPrimaryButton>(find.byType(AuthPrimaryButton)).enabled,
        isFalse,
      );

      await disposeScreen(tester);
    });

    testWidgets('should_navigate_to_welcome_back_when_continue_tapped_full_code',
        (tester) async {
      await _pump(tester, const AuthCodeScreen());
      await enterDigits(tester, const ['1', '2', '3', '4', '5', '6']);

      await tester.tap(find.byType(AuthPrimaryButton));
      await tester.pump();
      await tester.pump();

      // CTA «Продолжить» (push) открыла заглушку приветствия поверх стека.
      expect(find.text('welcome-back-route'), findsOneWidget);

      // Уводим стек на /home (go), чтобы AutoDispose отменил Timer.periodic
      // экрана кода — иначе «Timer still pending» в конце теста.
      final ctx = tester.element(find.text('welcome-back-route'));
      GoRouter.of(ctx).go('/home');
      await tester.pump();
      // Дать route-анимации завершиться (без pumpAndSettle — таймер ещё жив до
      // размонтирования экрана кода).
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(AuthCodeScreen), findsNothing);
      expect(find.text('home-route'), findsOneWidget);
    });
  });

  group('AuthWelcomeBackScreen (09)', () {
    testWidgets('should_render_greeting_and_add_first_plant_cta',
        (tester) async {
      await _pump(tester, const AuthWelcomeBackScreen());
      final l10n = _l10n(tester, AuthWelcomeBackScreen);

      expect(
        find.text(l10n.authWelcomeBackTitle(l10n.authWelcomeBackName)),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(AuthPrimaryButton, l10n.authAddFirstPlant),
        findsOneWidget,
      );
    });

    testWidgets('should_navigate_home_add_when_cta_tapped', (tester) async {
      await _pump(tester, const AuthWelcomeBackScreen());
      final l10n = _l10n(tester, AuthWelcomeBackScreen);

      await tester.tap(
        find.widgetWithText(AuthPrimaryButton, l10n.authAddFirstPlant),
      );
      await tester.pumpAndSettle();

      expect(find.text('add-route'), findsOneWidget);
    });
  });
}
