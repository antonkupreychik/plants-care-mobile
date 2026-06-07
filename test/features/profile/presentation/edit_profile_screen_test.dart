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
import 'package:plantcare_mobile/features/catalog/data/catalog_repository_provider.dart';
import 'package:plantcare_mobile/features/catalog/domain/catalog_repository.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_page.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_providers.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/domain/today_tasks_result.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/profile/data/profile_repository_provider.dart';
import 'package:plantcare_mobile/features/profile/domain/edit_profile_draft.dart';
import 'package:plantcare_mobile/features/profile/domain/profile_repository.dart';
import 'package:plantcare_mobile/features/profile/domain/profile_summary.dart';
import 'package:plantcare_mobile/features/profile/presentation/edit_profile_screen.dart';
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

class _MockProfileRepo extends Mock implements ProfileRepository {}

const _config = AppConfig(
  flavor: Flavor.dev,
  apiUrl: 'https://example.test',
);

final _utcNow = DateTime.utc(2026, 5, 27, 9);

final _mockSummary = ProfileSummary(
  name: 'Антон',
  email: 'anton@example.com',
  createdAt: DateTime.utc(2025, 1, 1),
  plantsTotal: 5,
);

final _mockDraft = EditProfileDraft(
  displayName: 'Антон',
  quietHoursStart: '22:00',
  quietHoursEnd: '08:00',
  timezone: 'Europe/Moscow',
);

_MockProfileRepo _defaultProfileRepo() {
  final repo = _MockProfileRepo();
  when(repo.getSummary).thenAnswer((_) async => Result.success(_mockSummary));
  when(repo.getEditDraft).thenAnswer((_) async => Result.success(_mockDraft));
  return repo;
}

Widget _wrap({ProfileRepository? profileRepo}) {
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
      authStatusProvider.overrideWithValue(AuthStatusNotifier(true)),
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
      profileRepositoryProvider
          .overrideWithValue(profileRepo ?? _defaultProfileRepo()),
    ],
    child: const PlantCareApp(),
  );
}

AppLocalizations l10nOf(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(AppBottomNav)));

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  group('EditProfileScreen — navigation', () {
    testWidgets('should_show_edit_button_in_profile_when_data_loaded',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await tester.tap(find.text(l10n.navProfile));
      await tester.pumpAndSettle();

      expect(find.text(l10n.editProfileEditButton), findsOneWidget);
    });

    testWidgets('should_navigate_to_edit_profile_screen_when_edit_tapped',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await tester.tap(find.text(l10n.navProfile));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.editProfileEditButton));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreen), findsOneWidget);
    });
  });

  group('EditProfileScreen — form', () {
    testWidgets('should_show_form_fields_with_initial_values', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await tester.tap(find.text(l10n.navProfile));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.editProfileEditButton));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreen), findsOneWidget);
      // Fields should contain the initial values.
      expect(find.text('22:00'), findsWidgets);
      expect(find.text('08:00'), findsWidgets);
      expect(find.text('Europe/Moscow'), findsWidgets);
    });

    testWidgets('should_show_save_button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await tester.tap(find.text(l10n.navProfile));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.editProfileEditButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.editProfileSave), findsOneWidget);
    });

    testWidgets('should_show_screen_title', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await tester.tap(find.text(l10n.navProfile));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.editProfileEditButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.editProfileTitle), findsOneWidget);
    });
  });
}
