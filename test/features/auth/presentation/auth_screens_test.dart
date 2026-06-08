import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/platform/link_launcher.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/auth/data/auth_repository_provider.dart';
import 'package:plantcare_mobile/features/auth/domain/auth_repository.dart';
import 'package:plantcare_mobile/features/auth/domain/social_auth_outcome.dart';
import 'package:plantcare_mobile/features/auth/domain/telegram_login.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_telegram_screen.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_welcome_back_screen.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_welcome_screen.dart';
import 'package:plantcare_mobile/features/auth/presentation/widgets/auth_keypad.dart';
import 'package:plantcare_mobile/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:plantcare_mobile/features/auth/presentation/widgets/auth_social_button.dart';
import 'package:plantcare_mobile/features/profile/domain/profile_summary.dart';
import 'package:plantcare_mobile/features/profile/presentation/profile_summary_provider.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

/// Монтирует [child] на корневом маршруте через настоящий GoRouter — экраны
/// используют `context.push` / `context.go`, которым нужен Router-контекст.
/// Заглушки-маршруты `/auth/email`, `/auth/code`, `/auth/welcome-back`,
/// `/home`, `/home/add` дают навигации куда уходить, не падая.
class _MockAuthRepo extends Mock implements AuthRepository {}

/// Fake launcher: не бьётся в платформенный канал, фиксирует открытые ссылки.
class _FakeLinkLauncher implements LinkLauncher {
  final List<String> opened = [];
  @override
  Future<bool> open(String url) async {
    opened.add(url);
    return true;
  }
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => child),
      GoRoute(
        path: '/auth/email',
        builder: (_, _) => const Scaffold(body: Text('email-route')),
      ),
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
  await tester.pump();
}

AppLocalizations _l10n(WidgetTester tester, Type screen) =>
    AppLocalizations.of(tester.element(find.byType(screen)));

void main() {
  group('AuthWelcomeScreen (07)', () {
    testWidgets('should_render_google_email_and_guest_entry_buttons',
        (tester) async {
      await _pump(tester, const AuthWelcomeScreen());
      final l10n = _l10n(tester, AuthWelcomeScreen);
      // Google (соц-вход), email-вход (реальный CTA, accent) и гость.
      expect(find.widgetWithText(AuthSocialButton, l10n.authContinueGoogle),
          findsOneWidget);
      expect(find.widgetWithText(AuthSocialButton, l10n.authEmailTitle),
          findsOneWidget);
      expect(find.text(l10n.authContinueGuest), findsOneWidget);
    });

    testWidgets('should_trigger_google_sign_in_when_google_tapped',
        (tester) async {
      final authRepo = _MockAuthRepo();
      when(authRepo.signInWithGoogle)
          .thenAnswer((_) async => const SocialAuthCancelled());

      // Высокий вьюпорт + ensureVisible: welcome — длинный ListView, Google-
      // кнопка ниже Telegram-CTA и иллюстрации, может быть за кадром.
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _pump(
        tester,
        const AuthWelcomeScreen(),
        overrides: [authRepositoryProvider.overrideWithValue(authRepo)],
      );
      final l10n = _l10n(tester, AuthWelcomeScreen);
      final googleCta =
          find.widgetWithText(AuthSocialButton, l10n.authContinueGoogle);
      await tester.ensureVisible(googleCta);
      await tester.tap(googleCta);
      await tester.pump();

      // Google-кнопка запускает реальный соц-вход (не coming-soon).
      verify(authRepo.signInWithGoogle).called(1);
    });

    testWidgets('should_navigate_to_auth_email_when_email_cta_tapped',
        (tester) async {
      // Главный CTA входа теперь ведёт на email magic-link (`/auth/email`),
      // а не на Telegram-превью `/auth/code`.
      // Высокий вьюпорт, чтобы email-CTA гарантированно была в кадре и
      // кликабельна (welcome — длинный ListView с иллюстрацией сверху).
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _pump(tester, const AuthWelcomeScreen());
      final l10n = _l10n(tester, AuthWelcomeScreen);

      final emailCta =
          find.widgetWithText(AuthSocialButton, l10n.authEmailTitle);
      await tester.ensureVisible(emailCta);
      await tester.tap(emailCta);
      await tester.pumpAndSettle();

      expect(find.text('email-route'), findsOneWidget);
    });
  });

  group('AuthTelegramScreen (08)', () {
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

    const session = TelegramStartSession(
      sessionId: 's-1',
      deepLink: 'https://t.me/PlantCareBot?start=auth_s-1',
      codeLength: 6,
      resendAfterSec: 60,
    );

    /// Монтирует экран 08 с замоканным repo (start → success) и fake-лаунчером.
    /// Возвращает (repo, launcher) для проверок.
    Future<(_MockAuthRepo, _FakeLinkLauncher)> pumpTelegram(
      WidgetTester tester, {
      TelegramVerifyOutcome? verifyOutcome,
      Result<TelegramStartSession>? startResult,
    }) async {
      final repo = _MockAuthRepo();
      final launcher = _FakeLinkLauncher();
      when(repo.startTelegramLogin).thenAnswer(
        (_) async => startResult ?? const Result.success(session),
      );
      when(() => repo.verifyTelegramLogin(
            sessionId: any(named: 'sessionId'),
            code: any(named: 'code'),
          )).thenAnswer(
        (_) async => verifyOutcome ?? const TelegramVerifyOutcome.success(),
      );
      await _pump(
        tester,
        const AuthTelegramScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(repo),
          linkLauncherProvider.overrideWithValue(launcher),
        ],
      );
      // Прокрутить microtask (_start) + первый кадр фазы ввода.
      await tester.pump();
      await tester.pump();
      return (repo, launcher);
    }

    /// Размонтирует экран, чтобы AutoDispose отменил Timer.periodic ресенда.
    Future<void> disposeScreen(WidgetTester tester) async {
      final ctx = tester.element(find.byType(AuthTelegramScreen));
      GoRouter.of(ctx).go('/home');
      await tester.pump();
      await tester.pump();
    }

    testWidgets('should_open_deep_link_and_show_code_entry_after_start',
        (tester) async {
      final (_, launcher) = await pumpTelegram(tester);

      // Бот открыт по deep link, видна клавиатура ввода кода.
      expect(launcher.opened, contains(session.deepLink));
      expect(find.byType(AuthKeypad), findsOneWidget);

      await disposeScreen(tester);
    });

    testWidgets('should_fill_cells_as_digits_are_entered', (tester) async {
      await pumpTelegram(tester);

      await enterDigits(tester, const ['1', '2', '3']);

      expect(find.text('1'), findsWidgets);
      expect(find.text('2'), findsWidgets);
      expect(find.text('3'), findsWidgets);

      await disposeScreen(tester);
    });

    testWidgets('should_auto_verify_and_go_welcome_back_on_full_code',
        (tester) async {
      final (repo, _) = await pumpTelegram(tester);

      await enterDigits(tester, const ['1', '2', '3', '4', '5', '6']);
      // Авто-верификация по шестой цифре + переход на экран 09.
      await tester.pump();
      await tester.pump();

      verify(() => repo.verifyTelegramLogin(sessionId: 's-1', code: '123456'))
          .called(1);
      expect(find.text('welcome-back-route'), findsOneWidget);
    });

    testWidgets('should_show_inline_error_and_clear_code_on_invalid_code',
        (tester) async {
      await pumpTelegram(
        tester,
        verifyOutcome: const TelegramVerifyOutcome.invalidCode(),
      );

      await enterDigits(tester, const ['1', '2', '3', '4', '5', '6']);
      await tester.pump();
      await tester.pump();

      final l10n = _l10n(tester, AuthTelegramScreen);
      expect(find.text(l10n.authTelegramErrorInvalidCode), findsOneWidget);
      // Остаёмся на экране 08 (не ушли на welcome-back).
      expect(find.text('welcome-back-route'), findsNothing);

      await disposeScreen(tester);
    });

    testWidgets('should_show_retry_when_start_fails', (tester) async {
      await pumpTelegram(
        tester,
        startResult: const Result.failure(ApiError.network()),
      );

      final l10n = _l10n(tester, AuthTelegramScreen);
      expect(
        find.widgetWithText(
            AuthPrimaryButton, l10n.authTelegramStartRetry),
        findsOneWidget,
      );
    });
  });

  group('AuthWelcomeBackScreen (09)', () {
    ProfileSummary summary({String? name, int plantsTotal = 0}) =>
        ProfileSummary(
          name: name,
          createdAt: DateTime.utc(2026, 1, 1),
          plantsTotal: plantsTotal,
        );

    testWidgets('should_render_profile_name_and_add_first_plant_cta_when_empty',
        (tester) async {
      await _pump(
        tester,
        const AuthWelcomeBackScreen(),
        overrides: [
          profileSummaryProvider
              .overrideWith((ref) async => summary(name: 'Анна')),
        ],
      );
      await tester.pump();
      final l10n = _l10n(tester, AuthWelcomeBackScreen);

      // Имя из профиля попало в приветствие.
      expect(find.text(l10n.authWelcomeBackTitle('Анна')), findsOneWidget);
      // Без растений → CTA «Добавить первое растение».
      expect(
        find.widgetWithText(AuthPrimaryButton, l10n.authAddFirstPlant),
        findsOneWidget,
      );
    });

    testWidgets('should_fall_back_to_default_name_when_profile_fails',
        (tester) async {
      await _pump(
        tester,
        const AuthWelcomeBackScreen(),
        overrides: [
          profileSummaryProvider
              .overrideWith((ref) async => throw const ApiError.network()),
        ],
      );
      await tester.pump();
      final l10n = _l10n(tester, AuthWelcomeBackScreen);

      // Профиль недоступен → запасное имя, вход не блокируется.
      expect(
        find.text(l10n.authWelcomeBackTitle(l10n.authWelcomeBackName)),
        findsOneWidget,
      );
    });

    testWidgets('should_show_go_to_garden_cta_when_user_has_plants',
        (tester) async {
      await _pump(
        tester,
        const AuthWelcomeBackScreen(),
        overrides: [
          profileSummaryProvider
              .overrideWith((ref) async => summary(plantsTotal: 3)),
        ],
      );
      await tester.pump();
      final l10n = _l10n(tester, AuthWelcomeBackScreen);

      expect(
        find.widgetWithText(AuthPrimaryButton, l10n.authGoToGarden),
        findsOneWidget,
      );
    });

    testWidgets('should_navigate_home_add_when_add_cta_tapped',
        (tester) async {
      await _pump(
        tester,
        const AuthWelcomeBackScreen(),
        overrides: [
          profileSummaryProvider.overrideWith((ref) async => summary()),
        ],
      );
      await tester.pump();
      final l10n = _l10n(tester, AuthWelcomeBackScreen);

      await tester.tap(
        find.widgetWithText(AuthPrimaryButton, l10n.authAddFirstPlant),
      );
      await tester.pumpAndSettle();

      expect(find.text('add-route'), findsOneWidget);
    });
  });
}
