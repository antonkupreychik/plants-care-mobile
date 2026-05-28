import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/rooms/data/rooms_repository_provider.dart';
import 'package:plantcare_mobile/features/rooms/domain/rooms_repository.dart';
import 'package:plantcare_mobile/features/rooms/presentation/rooms_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRoomsRepo extends Mock implements RoomsRepository {}

const _kitchen = GardenLocation(id: 1, name: 'Кухня', isDefault: true);
const _balcony = GardenLocation(id: 2, name: 'Балкон', isDefault: false);

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
  testWidgets(
      'should_open_move_picker_and_retry_delete_with_target_when_room_not_empty',
      (tester) async {
    final repo = _MockRoomsRepo();
    when(repo.getLocations)
        .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));

    // Первый delete (без target) → LOCATION_NOT_EMPTY. Второй (с target) → ok.
    when(() => repo.deleteLocation(id: 2, targetLocationId: null))
        .thenAnswer((_) async => const Result.failure(ApiError.locationNotEmpty()));
    when(() => repo.deleteLocation(id: 2, targetLocationId: 1))
        .thenAnswer((_) async => const Result.success(null));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    // 1. Тап «удалить» на непустой комнате «Балкон».
    await tester.tap(find.bySemanticsLabel(l10n.roomsDeleteAction));
    await tester.pumpAndSettle();

    // 2. Диалог подтверждения → подтверждаем удаление.
    expect(find.text(l10n.roomDeleteConfirmTitle), findsOneWidget);
    await tester.tap(find.text(l10n.roomDeleteConfirmDelete));
    await tester.pumpAndSettle();

    // 3. Backend вернул LOCATION_NOT_EMPTY → открылся пикер переноса.
    expect(find.text(l10n.roomMoveTitle), findsOneWidget);

    // 4. Выбираем целевую комнату «Кухня» (единственный target). Имя «Кухня»
    // встречается и в списке под модалкой, и в пикере — тапаем плитку пикера.
    await tester.tap(find.text('Кухня').last);
    await tester.pumpAndSettle();

    // 5. Повторный delete с targetLocationId = 1 (id «Кухни»).
    verify(() => repo.deleteLocation(id: 2, targetLocationId: null)).called(1);
    verify(() => repo.deleteLocation(id: 2, targetLocationId: 1)).called(1);
    // Успех → SnackBar об удалении.
    expect(find.text(l10n.roomDeleted), findsOneWidget);
  });

  testWidgets('should_not_call_delete_when_confirm_cancelled', (tester) async {
    final repo = _MockRoomsRepo();
    when(repo.getLocations)
        .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    await tester.tap(find.bySemanticsLabel(l10n.roomsDeleteAction));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.roomDeleteConfirmCancel));
    await tester.pumpAndSettle();

    verifyNever(() => repo.deleteLocation(
          id: any(named: 'id'),
          targetLocationId: any(named: 'targetLocationId'),
        ));
  });

  testWidgets('should_not_start_second_delete_when_tapped_again_during_flow',
      (tester) async {
    // Re-entrancy guard (Set<int> _deleting): пока delete-флоу комнаты активен
    // (delete висит), повторный тап по той же кнопке удаления не должен
    // запускать второй delete.
    final repo = _MockRoomsRepo();
    when(repo.getLocations)
        .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));

    // Первый delete (без target) держим незавершённым — флоу остаётся активным.
    final gate = Completer<Result<void>>();
    when(() => repo.deleteLocation(id: 2, targetLocationId: null))
        .thenAnswer((_) => gate.future);

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    // 1. Удаляем «Балкон» → подтверждаем. delete уходит и зависает (gate).
    await tester.tap(find.bySemanticsLabel(l10n.roomsDeleteAction));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.roomDeleteConfirmDelete));
    await tester.pumpAndSettle();

    // 2. Флоу активен (delete pending). Повторный тап по той же кнопке удаления
    // должен быть проигнорирован guard'ом.
    await tester.tap(find.bySemanticsLabel(l10n.roomsDeleteAction));
    await tester.pumpAndSettle();

    // Только один вызов delete, несмотря на два тапа.
    verify(() => repo.deleteLocation(id: 2, targetLocationId: null)).called(1);

    // Завершаем зависший delete, чтобы не оставлять висящий таймер/future.
    gate.complete(const Result.success(null));
    await tester.pumpAndSettle();
  });
}
