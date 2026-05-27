import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/app.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/env/app_config.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/router/app_router.dart';
import 'package:plantcare_mobile/core/widgets/app_bottom_nav.dart';
import 'package:plantcare_mobile/features/catalog/data/catalog_repository_provider.dart';
import 'package:plantcare_mobile/features/catalog/domain/catalog_repository.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_page.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_providers.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
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

const _config = AppConfig(
  flavor: Flavor.dev,
  apiUrl: 'https://example.test',
  chatId: '9000001',
  userId: '1',
);

final _utcNow = DateTime.utc(2026, 5, 27, 9);

Widget _wrap(RoomsRepository roomsRepo) {
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
      appConfigProvider.overrideWithValue(_config),
      clockProvider.overrideWithValue(_FixedClock(_utcNow)),
      homeTasksProvider.overrideWith((ref) async => const <CareTask>[]),
      homePlantsProvider.overrideWith((ref) async => const <Plant>[]),
      homeLocationsProvider
          .overrideWith((ref) async => const <GardenLocation>[]),
      catalogRepositoryProvider.overrideWithValue(catalogRepo),
      roomsRepositoryProvider.overrideWithValue(roomsRepo),
    ],
    child: const PlantCareApp(),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  setUp(() => appRouter.go('/home'));

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
}
