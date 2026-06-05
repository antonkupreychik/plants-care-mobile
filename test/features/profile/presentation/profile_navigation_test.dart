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
import 'package:plantcare_mobile/core/widgets/app_bottom_nav.dart';
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
import 'package:plantcare_mobile/features/profile/presentation/profile_screen.dart';
import 'package:plantcare_mobile/features/rooms/data/rooms_repository_provider.dart';
import 'package:plantcare_mobile/features/rooms/domain/rooms_repository.dart';
import 'package:plantcare_mobile/features/rooms/presentation/rooms_screen.dart';
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

const _config = AppConfig(
  flavor: Flavor.dev,
  apiUrl: 'https://example.test',
);

final _utcNow = DateTime.utc(2026, 5, 27, 9);

Widget _wrap(
  RoomsRepository roomsRepo, {
  AuthStatusNotifier? authStatus,
  AuthRepository? authRepo,
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

  return ProviderScope(
    overrides: [
      // Снимаем auth-гард: иначе redirect увёл бы старт на /auth/welcome.
      authStatusProvider.overrideWithValue(authStatus ?? AuthStatusNotifier(true)),
      appConfigProvider.overrideWithValue(_config),
      clockProvider.overrideWithValue(_FixedClock(_utcNow)),
      connectivityProvider.overrideWith((_) => Stream.value(true)),
      homeTasksProvider.overrideWith(
        (ref) async => TodayTasksResult(tasks: const [], completedCount: 0, totalCount: 0),
      ),
      homePlantsProvider.overrideWith((ref) async => const <Plant>[]),
      homeLocationsProvider
          .overrideWith((ref) async => const <GardenLocation>[]),
      catalogRepositoryProvider.overrideWithValue(catalogRepo),
      roomsRepositoryProvider.overrideWithValue(roomsRepo),
      if (authRepo != null)
        authRepositoryProvider.overrideWithValue(authRepo),
    ],
    child: const PlantCareApp(),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(AppBottomNav)));

  testWidgets('should_show_profile_with_rooms_row_when_profile_tab_tapped',
      (tester) async {
    final roomsRepo = _MockRoomsRepo();
    when(roomsRepo.getLocations)
        .thenAnswer((_) async => const Result.success(<GardenLocation>[]));

    await tester.pumpWidget(_wrap(roomsRepo));
    await tester.pumpAndSettle();

    final l10n = l10nOf(tester);
    await tester.tap(find.text(l10n.navProfile));
    await tester.pumpAndSettle();

    // Активный branch — Профиль; видна строка «Дома и места».
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text(l10n.profileRoomsTitle), findsOneWidget);
    expect(find.byType(AppBottomNav), findsOneWidget);
  });

  testWidgets('should_navigate_to_rooms_when_rooms_row_tapped', (tester) async {
    final roomsRepo = _MockRoomsRepo();
    when(roomsRepo.getLocations).thenAnswer(
      (_) async => const Result.success([
        GardenLocation(id: 1, name: 'Кухня', isDefault: true),
      ]),
    );

    await tester.pumpWidget(_wrap(roomsRepo));
    await tester.pumpAndSettle();

    final l10n = l10nOf(tester);
    await tester.tap(find.text(l10n.navProfile));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.profileRoomsTitle));
    await tester.pumpAndSettle();

    // Экран комнат открыт поверх shell (push на root-навигаторе) — таб-бар скрыт.
    expect(find.byType(RoomsScreen), findsOneWidget);
    expect(find.byType(AppBottomNav), findsNothing);
    expect(find.text('Кухня'), findsOneWidget);
    verify(roomsRepo.getLocations).called(1);
  });

  testWidgets(
      'should_sign_out_and_redirect_to_welcome_when_signout_confirmed',
      (tester) async {
    final roomsRepo = _MockRoomsRepo();
    when(roomsRepo.getLocations)
        .thenAnswer((_) async => const Result.success(<GardenLocation>[]));

    // Реальный notifier: signOut флипает его в false, как прод-репозиторий,
    // и router-guard уводит на /auth/welcome (через refreshListenable).
    final status = AuthStatusNotifier(true);
    final authRepo = _MockAuthRepo();
    when(authRepo.signOut).thenAnswer((_) async => status.set(false));

    await tester.pumpWidget(
      _wrap(roomsRepo, authStatus: status, authRepo: authRepo),
    );
    await tester.pumpAndSettle();

    final l10n = l10nOf(tester);
    await tester.tap(find.text(l10n.navProfile));
    await tester.pumpAndSettle();

    // Прокручиваем до кнопки «Выйти» — шапка, статистика и новые секции
    // могут вытолкнуть её за пределы viewport в тестовом окне 800×600.
    await tester.scrollUntilVisible(
      find.text(l10n.profileSignOut).last,
      100,
      scrollable: find.descendant(
        of: find.byType(ProfileScreen),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();

    // Тап по «Выйти» открывает диалог подтверждения (репозиторий ещё не зван).
    await tester.tap(find.text(l10n.profileSignOut).last);
    await tester.pumpAndSettle();
    expect(find.text(l10n.profileSignOutConfirmTitle), findsOneWidget);
    verifyNever(authRepo.signOut);

    // Подтверждаем выход → signOut + редирект гарда на экран входа.
    // Текст кнопки совпадает со строкой «Выйти», поэтому целимся в диалог.
    await tester.tap(find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text(l10n.profileSignOutConfirmAction),
    ));
    await tester.pumpAndSettle();

    verify(authRepo.signOut).called(1);
    expect(find.byType(AuthWelcomeScreen), findsOneWidget);
    expect(find.byType(ProfileScreen), findsNothing);
  });

  testWidgets('should_dismiss_signout_dialog_without_calling_repo_on_cancel',
      (tester) async {
    final roomsRepo = _MockRoomsRepo();
    when(roomsRepo.getLocations)
        .thenAnswer((_) async => const Result.success(<GardenLocation>[]));
    final authRepo = _MockAuthRepo();

    await tester.pumpWidget(_wrap(roomsRepo, authRepo: authRepo));
    await tester.pumpAndSettle();

    final l10n = l10nOf(tester);
    await tester.tap(find.text(l10n.navProfile));
    await tester.pumpAndSettle();

    // Прокручиваем до кнопки «Выйти» перед тапом.
    await tester.scrollUntilVisible(
      find.text(l10n.profileSignOut).last,
      100,
      scrollable: find.descendant(
        of: find.byType(ProfileScreen),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.profileSignOut).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.profileSignOutConfirmCancel));
    await tester.pumpAndSettle();

    // Отмена: диалог закрыт, выхода нет, остаёмся в профиле.
    verifyNever(authRepo.signOut);
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
