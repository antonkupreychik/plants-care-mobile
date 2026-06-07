import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/app.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/env/app_config.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/auth/auth_providers.dart';
import 'package:plantcare_mobile/core/auth/auth_status_notifier.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/network/connectivity_provider.dart';
import 'package:plantcare_mobile/features/auth/data/auth_repository_provider.dart';
import 'package:plantcare_mobile/features/auth/domain/auth_repository.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_welcome_screen.dart';
import 'package:plantcare_mobile/features/catalog/data/catalog_repository_provider.dart';
import 'package:plantcare_mobile/features/catalog/domain/catalog_repository.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_page.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_providers.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/domain/today_tasks_result.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/profile/data/profile_repository_provider.dart';
import 'package:plantcare_mobile/features/profile/domain/profile_repository.dart';
import 'package:plantcare_mobile/features/profile/presentation/delete_account_screen.dart';
import 'package:plantcare_mobile/features/profile/presentation/profile_screen.dart';
import 'package:plantcare_mobile/core/widgets/app_bottom_nav.dart';
import 'package:plantcare_mobile/features/rooms/data/rooms_repository_provider.dart';
import 'package:plantcare_mobile/features/rooms/domain/rooms_repository.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

class _MockCatalogRepo extends Mock implements CatalogRepository {}

class _MockRoomsRepo extends Mock implements RoomsRepository {}

class _MockAuthRepo extends Mock implements AuthRepository {}

class _MockProfileRepo extends Mock implements ProfileRepository {}

const _config = AppConfig(
  flavor: Flavor.dev,
  apiUrl: 'https://example.test',
);

final _utcNow = DateTime.utc(2026, 5, 27, 9);

Widget _wrap({
  AuthStatusNotifier? authStatus,
  AuthRepository? authRepo,
  ProfileRepository? profileRepo,
}) {
  final catalogRepo = _MockCatalogRepo();
  when(() => catalogRepo.searchSpecies(
        query: any(named: 'query'),
        offset: any(named: 'offset'),
        limit: any(named: 'limit'),
      )).thenAnswer(
    (_) async => const Result.success(
      SpeciesPage(items: [], total: 0, offset: 0, limit: kSpeciesPageLimit),
    ),
  );

  final roomsRepo = _MockRoomsRepo();
  when(roomsRepo.getLocations)
      .thenAnswer((_) async => const Result.success(<GardenLocation>[]));

  return ProviderScope(
    overrides: [
      authStatusProvider
          .overrideWithValue(authStatus ?? AuthStatusNotifier(true)),
      appConfigProvider.overrideWithValue(_config),
      clockProvider.overrideWithValue(_FixedClock(_utcNow)),
      connectivityProvider.overrideWith((_) => Stream.value(true)),
      homeTasksProvider.overrideWith(
        (ref) async =>
            TodayTasksResult(tasks: const [], completedCount: 0, totalCount: 0),
      ),
      homePlantsProvider.overrideWith((ref) async => const <Plant>[]),
      homeLocationsProvider
          .overrideWith((ref) async => const <GardenLocation>[]),
      catalogRepositoryProvider.overrideWithValue(catalogRepo),
      roomsRepositoryProvider.overrideWithValue(roomsRepo),
      if (authRepo != null)
        authRepositoryProvider.overrideWithValue(authRepo),
      if (profileRepo != null)
        profileRepositoryProvider.overrideWithValue(profileRepo),
    ],
    child: const PlantCareApp(),
  );
}

/// Навигирует в профиль и прокручивает до строки [title].
Future<void> _navigateToProfileRow(
  WidgetTester tester,
  AppLocalizations l10n,
  String title,
) async {
  await tester.tap(find.text(l10n.navProfile));
  await tester.pumpAndSettle();

  await tester.scrollUntilVisible(
    find.text(title).last,
    100,
    scrollable: find.descendant(
      of: find.byType(ProfileScreen),
      matching: find.byType(Scrollable),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(AppBottomNav)));

  group('DeleteAccountScreen — навигация', () {
    testWidgets(
        'should_show_delete_account_row_in_profile',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await tester.tap(find.text(l10n.navProfile));
      await tester.pumpAndSettle();

      // Прокручиваем до строки «Удалить аккаунт».
      await tester.scrollUntilVisible(
        find.text(l10n.profileDeleteAccount).last,
        100,
        scrollable: find.descendant(
          of: find.byType(ProfileScreen),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.profileDeleteAccount), findsOneWidget);
    });

    testWidgets(
        'should_open_delete_account_screen_when_row_tapped',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await _navigateToProfileRow(
          tester, l10n, l10n.profileDeleteAccount);

      await tester.tap(find.text(l10n.profileDeleteAccount).last);
      await tester.pumpAndSettle();

      expect(find.byType(DeleteAccountScreen), findsOneWidget);
      expect(find.text(l10n.deleteAccountScreenTitle), findsOneWidget);
    });
  });

  group('DeleteAccountScreen — подтверждение', () {
    testWidgets(
        'should_enable_delete_button_only_when_checkbox_ticked',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await _navigateToProfileRow(
          tester, l10n, l10n.profileDeleteAccount);
      await tester.tap(find.text(l10n.profileDeleteAccount).last);
      await tester.pumpAndSettle();

      // Кнопка неактивна — чекбокс не отмечен.
      final buttonFinder = find.text(l10n.deleteAccountCta);
      expect(
        tester.widget<FilledButton>(
          find.ancestor(
            of: buttonFinder,
            matching: find.byType(FilledButton),
          ),
        ).enabled,
        isFalse,
      );

      // Отмечаем чекбокс.
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(
        tester.widget<FilledButton>(
          find.ancestor(
            of: buttonFinder,
            matching: find.byType(FilledButton),
          ),
        ).enabled,
        isTrue,
      );
    });

    testWidgets(
        'should_show_confirmation_dialog_when_delete_button_pressed',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await _navigateToProfileRow(
          tester, l10n, l10n.profileDeleteAccount);
      await tester.tap(find.text(l10n.profileDeleteAccount).last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.deleteAccountCta));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(l10n.deleteAccountDialogTitle), findsOneWidget);
    });

    testWidgets(
        'should_dismiss_dialog_without_deleting_on_cancel',
        (tester) async {
      final profileRepo = _MockProfileRepo();
      final authRepo = _MockAuthRepo();

      await tester.pumpWidget(
          _wrap(profileRepo: profileRepo, authRepo: authRepo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await _navigateToProfileRow(
          tester, l10n, l10n.profileDeleteAccount);
      await tester.tap(find.text(l10n.profileDeleteAccount).last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.deleteAccountCta));
      await tester.pumpAndSettle();

      // Нажимаем «Отмена».
      await tester.tap(find.text(l10n.deleteAccountDialogCancel));
      await tester.pumpAndSettle();

      // Диалог закрыт, остаёмся на экране, ничего не вызвано.
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(DeleteAccountScreen), findsOneWidget);
      verifyNever(profileRepo.deleteAccount);
    });

    testWidgets(
        'should_delete_account_and_redirect_to_welcome_on_confirm',
        (tester) async {
      final profileRepo = _MockProfileRepo();
      final authRepo = _MockAuthRepo();
      final status = AuthStatusNotifier(true);

      when(profileRepo.deleteAccount)
          .thenAnswer((_) async => const Result.success(null));
      when(authRepo.signOut).thenAnswer((_) async => status.set(false));

      await tester.pumpWidget(
        _wrap(authStatus: status, profileRepo: profileRepo, authRepo: authRepo),
      );
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await _navigateToProfileRow(
          tester, l10n, l10n.profileDeleteAccount);
      await tester.tap(find.text(l10n.profileDeleteAccount).last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.deleteAccountCta));
      await tester.pumpAndSettle();

      // Финальное подтверждение в диалоге.
      await tester.tap(find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(l10n.deleteAccountDialogConfirm),
      ));
      await tester.pumpAndSettle();

      verify(profileRepo.deleteAccount).called(1);
      verify(authRepo.signOut).called(1);
      // Router-guard уводит на Welcome после signOut.
      expect(find.byType(AuthWelcomeScreen), findsOneWidget);
      expect(find.byType(DeleteAccountScreen), findsNothing);
    });
  });
}
