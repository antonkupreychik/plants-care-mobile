import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/rooms/data/rooms_repository_provider.dart';
import 'package:plantcare_mobile/features/rooms/domain/rooms_repository.dart';
import 'package:plantcare_mobile/features/rooms/presentation/rooms_screen.dart';
import 'package:plantcare_mobile/features/rooms/presentation/widgets/room_list_tile.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRoomsRepo extends Mock implements RoomsRepository {}

const _kitchen = GardenLocation(id: 1, name: 'Кухня', isDefault: true);
const _balcony = GardenLocation(id: 2, name: 'Балкон', isDefault: false);

Future<T> _pending<T>() => Completer<T>().future;

Widget _wrap(_MockRoomsRepo repo) {
  return ProviderScope(
    overrides: [roomsRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const RoomsScreen(),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(RoomsScreen)));

void main() {
  late _MockRoomsRepo repo;

  setUp(() => repo = _MockRoomsRepo());

  testWidgets('should_show_skeletons_when_loading', (tester) async {
    when(repo.getLocations).thenAnswer((_) => _pending());

    await tester.pumpWidget(_wrap(repo));
    await tester.pump();

    expect(find.byType(SkeletonBox), findsWidgets);
    expect(find.byType(ErrorState), findsNothing);
    expect(find.byType(RoomListTile), findsNothing);
  });

  testWidgets('should_show_error_with_retry_when_load_fails', (tester) async {
    when(repo.getLocations)
        .thenAnswer((_) async => const Result.failure(ApiError.network()));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text(_l10n(tester).retry), findsOneWidget);
  });

  testWidgets('should_refetch_when_retry_tapped', (tester) async {
    // Пока флаг не снят — отдаём ошибку (build провайдера может вызвать
    // getLocations не один раз до первого кадра); после тапа «Повторить»
    // переключаем стаб на успех.
    var fail = true;
    when(repo.getLocations).thenAnswer((_) async => fail
        ? const Result.failure(ApiError.network())
        : const Result.success([_kitchen]));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorState), findsOneWidget);

    fail = false;
    await tester.tap(find.text(_l10n(tester).retry));
    await tester.pumpAndSettle();

    // Повторная загрузка отдала данные → ошибка исчезла, появилась комната.
    expect(find.byType(ErrorState), findsNothing);
    expect(find.text('Кухня'), findsOneWidget);
    // Был хотя бы один повторный вызов после ретрая.
    verify(repo.getLocations).called(greaterThanOrEqualTo(2));
  });

  testWidgets('should_show_empty_state_when_no_rooms', (tester) async {
    when(repo.getLocations)
        .thenAnswer((_) async => const Result.success(<GardenLocation>[]));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text(_l10n(tester).roomsEmptyTitle), findsOneWidget);
    expect(find.byType(RoomListTile), findsNothing);
  });

  testWidgets('should_render_rooms_with_default_badge_and_no_delete_for_default',
      (tester) async {
    when(repo.getLocations)
        .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    expect(find.byType(RoomListTile), findsNWidgets(2));
    expect(find.text('Кухня'), findsOneWidget);
    expect(find.text('Балкон'), findsOneWidget);
    // Дефолтная комната помечена badge'ем (одна дефолтная в списке).
    expect(find.text(l10n.roomsDefaultBadge), findsOneWidget);

    // Изменить — у обеих комнат; удалить — только у НЕдефолтной (у дефолтной
    // кнопка удаления скрыта). Считаем по иконкам действий.
    expect(find.byIcon(Icons.edit_outlined), findsNWidgets(2));
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
  });
}
