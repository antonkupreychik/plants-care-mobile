import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/schedule/data/schedule_repository_provider.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_day.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_repository.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_week.dart';
import 'package:plantcare_mobile/features/schedule/presentation/schedule_providers.dart';

class _MockRepo extends Mock implements ScheduleRepository {}

ProviderContainer _containerWith(ScheduleRepository repo) {
  final container = ProviderContainer(
    overrides: [scheduleRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Удерживает AutoDispose-провайдер живым подпиской и ждёт первую ошибку.
/// Подписка (а не `.future`) не даёт провайдеру диспоузнуться в loading.
Future<Object?> _awaitError(
  ProviderSubscription<AsyncValue<ScheduleWeek>> Function(
    void Function(
      AsyncValue<ScheduleWeek>? prev,
      AsyncValue<ScheduleWeek> next,
    ) listener,
  ) listen,
) {
  final completer = Completer<Object?>();
  late final ProviderSubscription<AsyncValue<ScheduleWeek>> sub;
  sub = listen((_, next) {
    // Riverpod 3 во время неудачного rebuild эмитит AsyncLoading с ошибкой →
    // ловим по hasError.
    if (next.hasError && !completer.isCompleted) {
      completer.complete(next.error);
    }
  });
  addTearDown(sub.close);
  return completer.future;
}

void main() {
  setUpAll(() => registerFallbackValue(DateTime(2026, 5, 18)));

  late _MockRepo repo;
  final weekStart = DateTime(2026, 5, 18);

  setUp(() => repo = _MockRepo());

  test('should_emit_AsyncData_with_week_when_repository_succeeds', () async {
    final week = ScheduleWeek(
      weekStart: weekStart,
      days: [
        ScheduleDay(
          date: weekStart,
          tasks: [
            CareTask(
              scheduleId: 1,
              plantId: 1,
              plantName: 'Monstera',
              type: CareTaskType.watering,
              dueAt: DateTime.utc(2026, 5, 18, 9),
            ),
          ],
        ),
      ],
    );
    when(() => repo.getWeek(weekStart: any(named: 'weekStart')))
        .thenAnswer((_) async => Result.success(week));
    final container = _containerWith(repo);

    final value = await container.read(scheduleWeekProvider(weekStart).future);

    expect(value, week);
    verify(() => repo.getWeek(weekStart: weekStart)).called(1);
  });

  test('should_throw_typed_ApiError_into_AsyncError_when_repository_fails',
      () async {
    when(() => repo.getWeek(weekStart: any(named: 'weekStart')))
        .thenAnswer((_) async => const Result.failure(ApiError.network()));
    final container = _containerWith(repo);

    final error = await _awaitError(
      (listener) =>
          container.listen(scheduleWeekProvider(weekStart), listener),
    );

    // Типизированный ApiError в AsyncError, не строка.
    expect(error, isA<ApiError>());
    expect(error, const ApiError.network());
  });

  test('should_pass_the_requested_weekStart_to_repository', () async {
    when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
      (_) async => Result.success(
        ScheduleWeek(weekStart: weekStart, days: const []),
      ),
    );
    final container = _containerWith(repo);
    final otherWeek = DateTime(2026, 5, 25);

    await container.read(scheduleWeekProvider(otherWeek).future);

    verify(() => repo.getWeek(weekStart: otherWeek)).called(1);
  });
}
