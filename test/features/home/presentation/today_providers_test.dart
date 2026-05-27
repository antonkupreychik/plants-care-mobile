import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/features/home/domain/care_task.dart';
import 'package:plantcare_mobile/features/home/domain/care_task_type.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/today_filter.dart';
import 'package:plantcare_mobile/features/home/presentation/today_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/today_view.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

/// Никогда не завершающийся Future → провайдер остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

/// Полдень по локальной TZ процесса теста в UTC (как вернул бы clock).
final _nowUtc = DateTime(2026, 5, 27, 12).toUtc();

/// UTC-дедлайн, попадающий на [localHour] в локальной TZ процесса.
DateTime _localDue(int localHour) => DateTime(2026, 5, 27, localHour).toUtc();

CareTask _task({
  required DateTime dueUtc,
  CareTaskType type = CareTaskType.watering,
  int scheduleId = 1,
}) =>
    CareTask(
      scheduleId: scheduleId,
      plantId: scheduleId,
      plantName: 'Monstera',
      type: type,
      dueAt: dueUtc,
    );

ProviderContainer _container({
  required Future<List<CareTask>> Function() tasks,
  TodayFilter? filter,
}) {
  final container = ProviderContainer(
    // Гасим авто-ретрай Riverpod 3 на упавших провайдерах — иначе тест ошибки
    // не дождётся error-эмиссии (провайдер вечно «висит» в retry-loop).
    retry: (_, _) => null,
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_nowUtc)),
      homeTasksProvider.overrideWith((ref) => tasks()),
      if (filter != null)
        selectedTodayFilterProvider.overrideWith(
          () => _StubFilter(filter),
        ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Подменяет дефолт фильтра на нужное значение для теста деривации.
class _StubFilter extends SelectedTodayFilter {
  _StubFilter(this._initial);
  final TodayFilter _initial;
  @override
  TodayFilter build() => _initial;
}

void main() {
  group('todayViewProvider', () {
    test('should_build_view_from_tasks_and_clock_when_succeeds', () async {
      final container = _container(
        tasks: () async => [
          _task(dueUtc: _localDue(8), scheduleId: 1),
          _task(
              dueUtc: _localDue(18),
              type: CareTaskType.misting,
              scheduleId: 2),
        ],
      );

      final view = await container.read(todayViewProvider.future);

      expect(view.filter, TodayFilter.all);
      expect(view.totalCount, 2);
      expect(view.wateringCount, 1);
      expect(view.mistingCount, 1);
      // now=12 локально: задача 8ч просрочена.
      expect(view.overdueCount, 1);
      expect(view.groups.first.phase, TodayPhase.morning);
    });

    test('should_apply_selected_filter_when_overridden', () async {
      final container = _container(
        tasks: () async => [
          _task(dueUtc: _localDue(8), type: CareTaskType.watering),
          _task(
              dueUtc: _localDue(9),
              type: CareTaskType.misting,
              scheduleId: 2),
        ],
        filter: TodayFilter.misting,
      );

      final view = await container.read(todayViewProvider.future);

      expect(view.filter, TodayFilter.misting);
      final shown =
          view.groups.expand((g) => g.items).map((i) => i.task.type).toSet();
      expect(shown, {CareTaskType.misting});
    });

    test('should_stay_loading_while_tasks_pending', () async {
      final container = _container(tasks: _pending<List<CareTask>>);

      final value = container.read(todayViewProvider);

      expect(value.isLoading, isTrue);
    });

    test('should_propagate_ApiError_into_AsyncError_when_tasks_fail',
        () async {
      final container = _container(
        tasks: () async => throw const ApiError.network(),
      );

      final completer = Completer<Object?>();
      final sub = container.listen<AsyncValue<TodayView>>(
        todayViewProvider,
        (_, next) {
          // Riverpod 3 во время неудачного rebuild эмитит AsyncLoading с
          // прикреплённой ошибкой → ловим по hasError (а не по типу AsyncError).
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        },
        fireImmediately: true,
      );
      addTearDown(sub.close);

      expect(await completer.future, const ApiError.network());
    });
  });

  group('selectedTodayFilterProvider', () {
    test('should_default_to_all', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(selectedTodayFilterProvider), TodayFilter.all);
    });

    test('should_update_state_when_select_called', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(selectedTodayFilterProvider.notifier)
          .select(TodayFilter.overdue);

      expect(container.read(selectedTodayFilterProvider), TodayFilter.overdue);
    });

    test('should_rebuild_todayView_when_filter_changes', () async {
      final container = _container(
        tasks: () async => [
          _task(dueUtc: _localDue(8), type: CareTaskType.watering),
          _task(
              dueUtc: _localDue(9),
              type: CareTaskType.fertilizing,
              scheduleId: 2),
        ],
      );

      // Держим подписку, чтобы autoDispose-провайдер не диспоузился.
      final sub = container.listen(todayViewProvider, (_, _) {});
      addTearDown(sub.close);

      final first = await container.read(todayViewProvider.future);
      expect(first.filter, TodayFilter.all);

      container
          .read(selectedTodayFilterProvider.notifier)
          .select(TodayFilter.fertilizing);

      final second = await container.read(todayViewProvider.future);
      expect(second.filter, TodayFilter.fertilizing);
      final shown =
          second.groups.expand((g) => g.items).map((i) => i.task.type).toSet();
      expect(shown, {CareTaskType.fertilizing});
    });
  });
}
