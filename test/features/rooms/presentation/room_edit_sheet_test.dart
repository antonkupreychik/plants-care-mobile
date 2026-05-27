import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/api_error_l10n.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/rooms/data/rooms_repository_provider.dart';
import 'package:plantcare_mobile/features/rooms/domain/rooms_repository.dart';
import 'package:plantcare_mobile/features/rooms/presentation/room_edit_sheet.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRoomsRepo extends Mock implements RoomsRepository {}

const _balcony = GardenLocation(id: 2, name: 'Балкон', isDefault: false);

/// Хост с кнопкой, открывающей sheet — даёт корректный context/Navigator.
Widget _wrap(_MockRoomsRepo repo, {GardenLocation? room}) {
  return ProviderScope(
    overrides: [roomsRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => showRoomEditSheet(context, room: room),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _openSheet(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.text('open')));

/// Подтверждение через клавиатурный «Готово» (onSubmitted). Кнопка submit в
/// sheet включается лишь после rebuild (после неуспешной отправки/валидации),
/// поэтому штатный путь свежей отправки — клавиатурное действие. См. заметку в
/// отчёте о дизайне.
Future<void> _submitViaKeyboard(WidgetTester tester) async {
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

/// Подтверждение тапом по большой submit-кнопке `_SubmitButton`. После фикса
/// ревью кнопка загорается по мере набора валидного имени (безусловный
/// setState в `_NameField.onChanged`), поэтому этот путь больше не требует
/// клавиатурного «Готово». Кнопка обёрнута в `Semantics(label: ...)`.
Future<void> _tapSubmitButton(WidgetTester tester, String label) async {
  final button = find.ancestor(
    of: find.text(label),
    matching: find.byType(InkWell),
  );
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  late _MockRoomsRepo repo;

  setUp(() {
    repo = _MockRoomsRepo();
    when(repo.getLocations)
        .thenAnswer((_) async => const Result.success(<GardenLocation>[]));
  });

  testWidgets('should_not_create_when_name_empty', (tester) async {
    await tester.pumpWidget(_wrap(repo));
    await _openSheet(tester);

    // Имя пустое → submit (через «Готово») не вызывает create, показывает
    // inline-ошибку валидации.
    await _submitViaKeyboard(tester);

    final l10n = _l10n(tester);
    expect(find.text(l10n.roomSheetNameError(30)), findsOneWidget);
    verifyNever(() => repo.createLocation(
          name: any(named: 'name'),
          emoji: any(named: 'emoji'),
        ));
  });

  testWidgets('should_clamp_name_to_max_length_via_field_formatter',
      (tester) async {
    when(() => repo.createLocation(
          name: any(named: 'name'),
          emoji: any(named: 'emoji'),
        )).thenAnswer((_) async => const Result.success(_balcony));

    await tester.pumpWidget(_wrap(repo));
    await _openSheet(tester);

    // Поле имени само ограничивает ввод 30 символами (maxLength-форматтер):
    // ввод 35 символов → отправляется усечённое до 30 имя, не невалидное.
    await tester.enterText(find.byType(TextField).first, 'a' * 35);
    await _submitViaKeyboard(tester);

    verify(() => repo.createLocation(name: 'a' * 30, emoji: null)).called(1);
  });

  testWidgets('should_create_and_close_sheet_and_show_snackbar_on_success',
      (tester) async {
    when(() => repo.createLocation(
          name: any(named: 'name'),
          emoji: any(named: 'emoji'),
        )).thenAnswer((_) async => const Result.success(_balcony));

    await tester.pumpWidget(_wrap(repo));
    await _openSheet(tester);

    await tester.enterText(find.byType(TextField).first, 'Балкон');
    await _submitViaKeyboard(tester);

    final l10n = _l10n(tester);
    verify(() => repo.createLocation(name: 'Балкон', emoji: null)).called(1);
    // Sheet закрыт (поле имени исчезло), показан SnackBar.
    expect(find.byType(TextField), findsNothing);
    expect(find.text(l10n.roomCreated), findsOneWidget);
  });

  testWidgets(
      'should_create_and_close_sheet_when_submit_button_tapped_after_typing',
      (tester) async {
    // Регрессия на BLOCKING-ревью: до фикса submit-кнопка не загоралась по
    // мере набора (требовался клавиатурный «Готово»), и тап по большой кнопке
    // не запускал create. Здесь подтверждаем ИМЕННО тапом по `_SubmitButton`.
    when(() => repo.createLocation(
          name: any(named: 'name'),
          emoji: any(named: 'emoji'),
        )).thenAnswer((_) async => const Result.success(_balcony));

    await tester.pumpWidget(_wrap(repo));
    await _openSheet(tester);

    final l10n = _l10n(tester);

    // Набираем валидное имя — кнопка должна стать активной без «Готово».
    await tester.enterText(find.byType(TextField).first, 'Балкон');
    await tester.pump();

    await _tapSubmitButton(tester, l10n.roomSheetCreateSubmit);

    verify(() => repo.createLocation(name: 'Балкон', emoji: null)).called(1);
    // Sheet закрыт (поле имени исчезло), показан SnackBar успеха.
    expect(find.byType(TextField), findsNothing);
    expect(find.text(l10n.roomCreated), findsOneWidget);
  });

  testWidgets('should_trim_name_and_send_emoji_on_create', (tester) async {
    when(() => repo.createLocation(
          name: any(named: 'name'),
          emoji: any(named: 'emoji'),
        )).thenAnswer((_) async => const Result.success(_balcony));

    await tester.pumpWidget(_wrap(repo));
    await _openSheet(tester);

    final fields = find.byType(TextField);
    // Emoji вводим первым, имя — последним, чтобы фокус (и onSubmitted
    // «Готово») остался на поле имени.
    await tester.enterText(fields.at(1), '🪴');
    await tester.enterText(fields.at(0), '  Балкон  ');
    await _submitViaKeyboard(tester);

    // Имя тримится, emoji уходит как есть.
    verify(() => repo.createLocation(name: 'Балкон', emoji: '🪴')).called(1);
  });

  testWidgets('should_show_inline_error_when_create_fails', (tester) async {
    when(() => repo.createLocation(
          name: any(named: 'name'),
          emoji: any(named: 'emoji'),
        )).thenAnswer(
      (_) async => const Result.failure(ApiError.badRequest(message: 'dup')),
    );

    await tester.pumpWidget(_wrap(repo));
    await _openSheet(tester);

    await tester.enterText(find.byType(TextField).first, 'Кухня');
    await _submitViaKeyboard(tester);

    final l10n = _l10n(tester);
    // Failure → sheet остаётся открытым, inline-ошибка показана.
    expect(find.byType(TextField), findsWidgets);
    expect(find.text(l10n.messageForError(const ApiError.badRequest())),
        findsOneWidget);
  });

  testWidgets('should_prefill_name_and_call_rename_in_edit_mode',
      (tester) async {
    when(() => repo.updateLocation(
          id: any(named: 'id'),
          name: any(named: 'name'),
          emoji: any(named: 'emoji'),
        )).thenAnswer((_) async => const Result.success(_balcony));

    await tester.pumpWidget(_wrap(repo, room: _balcony));
    await _openSheet(tester);

    // Имя предзаполнено значением комнаты.
    expect(find.widgetWithText(TextField, 'Балкон'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Лоджия');
    await _submitViaKeyboard(tester);

    final l10n = _l10n(tester);
    verify(() => repo.updateLocation(id: 2, name: 'Лоджия', emoji: null))
        .called(1);
    expect(find.text(l10n.roomUpdated), findsOneWidget);
  });
}
