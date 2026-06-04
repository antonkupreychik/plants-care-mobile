import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/quiet_hours/data/user_settings_repository_provider.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/quiet_time.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_locale.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_settings.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_settings_repository.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/quiet_hours_controller.dart';

class _MockRepo extends Mock implements UserSettingsRepository {}

class _FakeQuietTime extends Fake implements QuietTime {}

const _start = QuietTime(hour: 22, minute: 0);
const _end = QuietTime(hour: 8, minute: 0);

UserSettings _settings({
  QuietTime start = _start,
  QuietTime end = _end,
  String timezone = 'Europe/Moscow',
}) =>
    UserSettings(
      quietHoursStart: start,
      quietHoursEnd: end,
      timezone: timezone,
      locale: UserLocale.ru,
    );

ProviderContainer _container(UserSettingsRepository repo) {
  final container = ProviderContainer(
    overrides: [userSettingsRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeQuietTime());
  });

  void stubLoad(_MockRepo repo, UserSettings loaded) {
    when(() => repo.getSettings())
        .thenAnswer((_) async => Result.success(loaded));
  }

  group('build', () {
    test('should_set_draft_equal_to_loaded_and_not_dirty', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      final container = _container(repo);

      final state = await container.read(quietHoursControllerProvider.future);

      expect(state.loaded, _settings());
      expect(state.draft, _settings());
      expect(state.isDirty, isFalse);
      expect(state.isQuietHoursDirty, isFalse);
      expect(state.isTimezoneDirty, isFalse);
      expect(state.saving, isFalse);
      expect(state.saveError, isNull);
    });

    test('should_emit_AsyncError_when_load_fails', () async {
      final repo = _MockRepo();
      when(() => repo.getSettings())
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);

      final completer = Completer<Object?>();
      final sub = container.listen(
        quietHoursControllerProvider,
        (_, next) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        },
      );
      addTearDown(sub.close);

      expect(await completer.future, const ApiError.network());
    });
  });

  group('draft edits', () {
    test('should_set_quiet_start_in_draft_and_mark_quiet_hours_dirty',
        () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      notifier.setQuietStart(const QuietTime(hour: 23, minute: 30));

      final state = container.read(quietHoursControllerProvider).value!;
      expect(state.draft.quietHoursStart,
          const QuietTime(hour: 23, minute: 30));
      // loaded не тронут.
      expect(state.loaded.quietHoursStart, _start);
      expect(state.isQuietHoursDirty, isTrue);
      expect(state.isTimezoneDirty, isFalse);
      expect(state.isDirty, isTrue);
      // setQuietStart НЕ ходит в сеть.
      verifyNever(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          ));
      verifyNever(() => repo.updateTimezone(any()));
    });

    test('should_set_quiet_end_in_draft_and_mark_quiet_hours_dirty', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      notifier.setQuietEnd(const QuietTime(hour: 7, minute: 15));

      final state = container.read(quietHoursControllerProvider).value!;
      expect(state.draft.quietHoursEnd, const QuietTime(hour: 7, minute: 15));
      expect(state.isQuietHoursDirty, isTrue);
      expect(state.isTimezoneDirty, isFalse);
    });

    test('should_set_timezone_in_draft_and_mark_timezone_dirty', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      notifier.setTimezone('Asia/Yekaterinburg');

      final state = container.read(quietHoursControllerProvider).value!;
      expect(state.draft.timezone, 'Asia/Yekaterinburg');
      expect(state.loaded.timezone, 'Europe/Moscow');
      expect(state.isTimezoneDirty, isTrue);
      expect(state.isQuietHoursDirty, isFalse);
      expect(state.isDirty, isTrue);
      // Чисто draft — записи нет до save().
      verifyNever(() => repo.updateTimezone(any()));
    });
  });

  group('discardChanges', () {
    test('should_revert_draft_to_loaded_and_clear_dirty', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      notifier.setQuietStart(const QuietTime(hour: 1, minute: 0));
      notifier.setTimezone('Asia/Vladivostok');
      expect(container.read(quietHoursControllerProvider).value!.isDirty,
          isTrue);

      notifier.discardChanges();

      final state = container.read(quietHoursControllerProvider).value!;
      expect(state.draft, _settings());
      expect(state.isDirty, isFalse);
      expect(state.saveError, isNull);
      // discardChanges не ходит в сеть.
      verifyNever(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          ));
    });
  });

  group('save', () {
    test('should_be_noop_and_return_null_when_no_dirty', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      final error = await notifier.save();

      expect(error, isNull);
      verifyNever(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          ));
      verifyNever(() => repo.updateTimezone(any()));
    });

    test('should_call_updateQuietHours_with_dirty_fields_and_fix_loaded',
        () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      // Backend эхом возвращает сохранённое (с нормализацией).
      when(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          )).thenAnswer((_) async => Result.success(
            _settings(start: const QuietTime(hour: 23, minute: 0)),
          ));
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      notifier.setQuietStart(const QuietTime(hour: 23, minute: 0));
      final error = await notifier.save();

      expect(error, isNull);
      // При грязных тихих часах контроллер шлёт обе границы (start+end) из
      // драфта — repo сам решает PATCH-семантику; уходит изменённый start (23:00)
      // и текущий end (08:00).
      final captured = verify(() => repo.updateQuietHours(
            start: captureAny(named: 'start'),
            end: captureAny(named: 'end'),
          )).captured;
      expect(captured[0], const QuietTime(hour: 23, minute: 0));
      expect(captured[1], const QuietTime(hour: 8, minute: 0));
      // Таймзона чистая → updateTimezone не дёргается.
      verifyNever(() => repo.updateTimezone(any()));

      final state = container.read(quietHoursControllerProvider).value!;
      // Серверный ответ зафиксирован в loaded и draft → грязь исчезла.
      expect(state.loaded.quietHoursStart, const QuietTime(hour: 23, minute: 0));
      expect(state.draft.quietHoursStart, const QuietTime(hour: 23, minute: 0));
      expect(state.isDirty, isFalse);
      expect(state.saving, isFalse);
      expect(state.saveError, isNull);
    });

    test('should_call_only_updateTimezone_when_only_timezone_dirty', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      when(() => repo.updateTimezone(any())).thenAnswer(
        (_) async => Result.success(_settings(timezone: 'Asia/Novosibirsk')),
      );
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      notifier.setTimezone('Asia/Novosibirsk');
      final error = await notifier.save();

      expect(error, isNull);
      verify(() => repo.updateTimezone('Asia/Novosibirsk')).called(1);
      verifyNever(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          ));
      final state = container.read(quietHoursControllerProvider).value!;
      expect(state.loaded.timezone, 'Asia/Novosibirsk');
      expect(state.isDirty, isFalse);
    });

    test('should_call_both_updates_when_quiet_hours_and_timezone_dirty',
        () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      when(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          )).thenAnswer((_) async => Result.success(
            _settings(start: const QuietTime(hour: 21, minute: 0)),
          ));
      when(() => repo.updateTimezone(any())).thenAnswer(
        (_) async => Result.success(
          _settings(
            start: const QuietTime(hour: 21, minute: 0),
            timezone: 'Asia/Samara',
          ),
        ),
      );
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      notifier.setQuietStart(const QuietTime(hour: 21, minute: 0));
      notifier.setTimezone('Asia/Samara');
      final error = await notifier.save();

      expect(error, isNull);
      verify(() => repo.updateQuietHours(
            start: const QuietTime(hour: 21, minute: 0),
            end: const QuietTime(hour: 8, minute: 0),
          )).called(1);
      verify(() => repo.updateTimezone('Asia/Samara')).called(1);
      final state = container.read(quietHoursControllerProvider).value!;
      expect(state.isDirty, isFalse);
      expect(state.loaded.timezone, 'Asia/Samara');
      expect(state.loaded.quietHoursStart, const QuietTime(hour: 21, minute: 0));
    });

    test(
        'should_commit_quiet_hours_to_loaded_when_timezone_patch_fails_after_'
        'quiet_hours_ok', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      // Первый PATCH (тихие часы) — ОК, эхо сохранённого (часы новые, таймзона
      // ещё старая).
      when(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          )).thenAnswer((_) async => Result.success(
            _settings(start: const QuietTime(hour: 21, minute: 0)),
          ));
      // Второй PATCH (таймзона) — падает (например, backend 400 на IANA).
      when(() => repo.updateTimezone(any())).thenAnswer(
        (_) async => const Result.failure(ApiError.badRequest()),
      );
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      // Оба поля грязные.
      notifier.setQuietStart(const QuietTime(hour: 21, minute: 0));
      notifier.setTimezone('Asia/Samara');
      final error = await notifier.save();

      // Оба PATCH'а отправлены; второй упал.
      verify(() => repo.updateQuietHours(
            start: const QuietTime(hour: 21, minute: 0),
            end: const QuietTime(hour: 8, minute: 0),
          )).called(1);
      verify(() => repo.updateTimezone('Asia/Samara')).called(1);

      // Возвращён ApiError второго PATCH, saveError выставлен, saving сброшен.
      expect(error, const ApiError.badRequest());
      final state = container.read(quietHoursControllerProvider).value!;
      expect(state.saveError, const ApiError.badRequest());
      expect(state.saving, isFalse);

      // Часы УЖЕ записаны на бэке → инкрементально зафиксированы в loaded:
      // isQuietHoursDirty == false.
      expect(state.loaded.quietHoursStart, const QuietTime(hour: 21, minute: 0));
      expect(state.draft.quietHoursStart, const QuietTime(hour: 21, minute: 0));
      expect(state.isQuietHoursDirty, isFalse);

      // Таймзона НЕ записана → грязь по таймзоне сохраняется (loaded со старой,
      // draft с желаемой) → пользователь повторит save (уйдёт только таймзона).
      expect(state.loaded.timezone, 'Europe/Moscow');
      expect(state.draft.timezone, 'Asia/Samara');
      expect(state.isTimezoneDirty, isTrue);
      expect(state.isDirty, isTrue);
    });

    test(
        'should_return_ApiError_and_set_saveError_when_repo_rejects_equal_start_end',
        () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      // start == end → backend 400 → Failure(badRequest).
      when(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          )).thenAnswer(
        (_) async => const Result.failure(ApiError.badRequest()),
      );
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      // Делаем start == end (08:00) → грязь по тихим часам.
      notifier.setQuietStart(const QuietTime(hour: 8, minute: 0));
      final error = await notifier.save();

      expect(error, const ApiError.badRequest());
      final state = container.read(quietHoursControllerProvider).value!;
      expect(state.saveError, const ApiError.badRequest());
      expect(state.saving, isFalse);
      // Драфт сохранён (пользователь повторит), грязь остаётся.
      expect(state.draft.quietHoursStart, const QuietTime(hour: 8, minute: 0));
      expect(state.isDirty, isTrue);
      // loaded не тронут.
      expect(state.loaded.quietHoursStart, _start);
    });

    test('should_keep_saving_true_while_in_flight', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      final completer = Completer<Result<UserSettings>>();
      when(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          )).thenAnswer((_) => completer.future);
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      notifier.setQuietStart(const QuietTime(hour: 23, minute: 0));
      final saveFuture = notifier.save();

      expect(container.read(quietHoursControllerProvider).value!.saving, isTrue);

      completer.complete(Result.success(
        _settings(start: const QuietTime(hour: 23, minute: 0)),
      ));
      await saveFuture;

      expect(
          container.read(quietHoursControllerProvider).value!.saving, isFalse);
    });

    test('should_be_noop_when_save_called_again_while_in_flight', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings());
      final completer = Completer<Result<UserSettings>>();
      when(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          )).thenAnswer((_) => completer.future);
      final container = _container(repo);
      await container.read(quietHoursControllerProvider.future);
      final notifier = container.read(quietHoursControllerProvider.notifier);

      notifier.setQuietStart(const QuietTime(hour: 23, minute: 0));

      final f1 = notifier.save();
      final r2 = await notifier.save();

      // Повторный save в полёте — guard `saving` → no-op, второго PATCH нет.
      expect(r2, isNull);
      verify(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          )).called(1);

      completer.complete(Result.success(
        _settings(start: const QuietTime(hour: 23, minute: 0)),
      ));
      final r1 = await f1;

      expect(r1, isNull);
      verifyNever(() => repo.updateQuietHours(
            start: any(named: 'start'),
            end: any(named: 'end'),
          ));
    });
  });
}
