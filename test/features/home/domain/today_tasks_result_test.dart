import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/home/domain/today_tasks_result.dart';

CareTask _task() => CareTask(
      scheduleId: 1,
      plantId: 1,
      plantName: 'Monstera',
      type: CareTaskType.watering,
      dueAt: DateTime.utc(2026, 5, 27, 9),
    );

void main() {
  group('TodayTasksResult', () {
    test('progressFraction_returns_zero_when_totalCount_is_zero', () {
      final result = TodayTasksResult(
        tasks: const [],
        completedCount: 0,
        totalCount: 0,
      );
      expect(result.progressFraction, 0.0);
    });

    test('progressFraction_returns_0_5_when_half_done', () {
      final result = TodayTasksResult(
        tasks: [_task(), _task()],
        completedCount: 1,
        totalCount: 2,
      );
      expect(result.progressFraction, 0.5);
    });

    test('progressFraction_returns_1_0_when_all_done', () {
      final result = TodayTasksResult(
        tasks: [_task()],
        completedCount: 1,
        totalCount: 1,
      );
      expect(result.progressFraction, 1.0);
    });

    test('progressPercent_returns_zero_when_totalCount_is_zero', () {
      final result = TodayTasksResult(
        tasks: const [],
        completedCount: 0,
        totalCount: 0,
      );
      expect(result.progressPercent, 0);
    });

    test('progressPercent_returns_50_when_half_done', () {
      final result = TodayTasksResult(
        tasks: [_task(), _task()],
        completedCount: 1,
        totalCount: 2,
      );
      expect(result.progressPercent, 50);
    });

    test('progressPercent_returns_100_when_all_done', () {
      final result = TodayTasksResult(
        tasks: [_task()],
        completedCount: 1,
        totalCount: 1,
      );
      expect(result.progressPercent, 100);
    });

    test('progressPercent_rounds_correctly_for_one_third', () {
      final result = TodayTasksResult(
        tasks: [_task(), _task(), _task()],
        completedCount: 1,
        totalCount: 3,
      );
      expect(result.progressPercent, 33);
    });
  });
}
