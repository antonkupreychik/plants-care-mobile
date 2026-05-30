import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/care_event/presentation/next_care_due_provider.dart';
import 'package:plantcare_mobile/features/edit_schedule/data/edit_schedule_repository_provider.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/care_schedule_unit.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/edit_schedule_repository.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/plant_care_schedule.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';

class _MockRepo extends Mock implements EditScheduleRepository {}

const _plantId = 42;
final _nextDue = DateTime.utc(2026, 6, 1, 9);

/// Фикстура расписания (домен экрана 22). nextDueAt/enabled/type варьируем.
PlantCareSchedule _schedule({
  required CareTaskType type,
  bool enabled = true,
  DateTime? nextDueAt,
}) =>
    PlantCareSchedule(
      type: type,
      rawType: type.name,
      every: 7,
      unit: CareScheduleUnit.day,
      rawUnit: 'DAY',
      amountMl: 200,
      enabled: enabled,
      nextDueAt: nextDueAt,
    );

void main() {
  group('nextDueForKind', () {
    test('should_return_nextDueAt_when_enabled_schedule_of_kind', () {
      final schedules = [
        _schedule(type: CareTaskType.watering, nextDueAt: _nextDue),
      ];

      final result = nextDueForKind(schedules, CareEventKind.water);

      expect(result, _nextDue);
    });

    test('should_pick_only_schedule_matching_the_kind_type', () {
      // Тип ухода → конкретное расписание, не первое попавшееся.
      final schedules = [
        _schedule(
          type: CareTaskType.misting,
          nextDueAt: DateTime.utc(2026, 6, 2),
        ),
        _schedule(type: CareTaskType.fertilizing, nextDueAt: _nextDue),
      ];

      final result = nextDueForKind(schedules, CareEventKind.fertilize);

      expect(result, _nextDue);
    });

    test('should_return_null_when_matching_schedule_disabled', () {
      // Выключенное расписание задач не генерирует → срока нет, даже с nextDueAt.
      final schedules = [
        _schedule(
          type: CareTaskType.watering,
          enabled: false,
          nextDueAt: _nextDue,
        ),
      ];

      final result = nextDueForKind(schedules, CareEventKind.water);

      expect(result, isNull);
    });

    test('should_return_null_when_no_schedule_of_kind_type', () {
      final schedules = [
        _schedule(type: CareTaskType.misting, nextDueAt: _nextDue),
      ];

      final result = nextDueForKind(schedules, CareEventKind.water);

      expect(result, isNull);
    });

    test('should_return_null_when_kind_unknown', () {
      // unknown не имеет внутреннего типа → счётчик не показываем.
      final schedules = [
        _schedule(type: CareTaskType.watering, nextDueAt: _nextDue),
      ];

      final result = nextDueForKind(schedules, CareEventKind.unknown);

      expect(result, isNull);
    });

    test('should_return_null_when_matching_schedule_nextDueAt_null', () {
      final schedules = [
        _schedule(type: CareTaskType.watering, nextDueAt: null),
      ];

      final result = nextDueForKind(schedules, CareEventKind.water);

      expect(result, isNull);
    });

    test('should_return_null_when_schedules_empty', () {
      expect(
        nextDueForKind(const <PlantCareSchedule>[], CareEventKind.water),
        isNull,
      );
    });
  });

  group('plantSchedules / nextCareDue providers', () {
    late _MockRepo repo;

    setUp(() {
      repo = _MockRepo();
    });

    ProviderContainer makeContainer() {
      final container = ProviderContainer(
        overrides: [editScheduleRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('should_emit_nextDueAt_when_repo_success_with_matching_schedule',
        () async {
      when(() => repo.getSchedules(_plantId)).thenAnswer(
        (_) async => Result.success([
          _schedule(type: CareTaskType.watering, nextDueAt: _nextDue),
        ]),
      );

      final container = makeContainer();

      final due = await container.read(
        nextCareDueProvider(plantId: _plantId, kind: CareEventKind.water)
            .future,
      );

      expect(due, _nextDue);
    });

    test('should_emit_null_when_repo_success_but_schedule_disabled', () async {
      when(() => repo.getSchedules(_plantId)).thenAnswer(
        (_) async => Result.success([
          _schedule(
            type: CareTaskType.watering,
            enabled: false,
            nextDueAt: _nextDue,
          ),
        ]),
      );

      final container = makeContainer();

      final due = await container.read(
        nextCareDueProvider(plantId: _plantId, kind: CareEventKind.water)
            .future,
      );

      expect(due, isNull);
    });

    /// Прокачивает контейнер: даёт резолвиться внутреннему `await` провайдера
    /// (две async-ступени: репо → провайдер) и применяет эффекты.
    Future<void> settle(ProviderContainer container) async {
      for (var i = 0; i < 3; i++) {
        await Future<void>.delayed(Duration.zero);
        await container.pump();
      }
    }

    test('should_capture_error_in_plantSchedules_when_repo_failure', () async {
      when(() => repo.getSchedules(_plantId))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      final container = makeContainer();
      // Держим подписку живой, пока провайдер резолвится.
      final sub = container.listen(plantSchedulesProvider(_plantId), (_, _) {});
      addTearDown(sub.close);

      await settle(container);

      final state = container.read(plantSchedulesProvider(_plantId));
      // Failure-репо → провайдер бросает → ошибка захвачена (hasError), не value.
      expect(state.hasError, isTrue);
      expect(state.hasValue, isFalse);
      expect(state.error, const ApiError.network());
    });

    // ИСТИННОЕ поведение деривации (зафиксировано, НЕ замаскировано — см. отчёт):
    // nextCareDue делает `await ref.watch(plantSchedules.future)`. При
    // upstream-failure derived-провайдер в этой версии Riverpod НЕ
    // ретранслирует ошибку как AsyncError и НЕ деградирует в data(null) — он
    // ОСТАЁТСЯ в AsyncLoading (hasError=false, hasValue=false). Для футера это
    // безопасно: loading и error одинаково → generic hint (см. widget-тесты).
    // Контракт, который держим тестом: derived НИКОГДА не отдаёт data(non-null)
    // при упавшем upstream, т.е. ложного срока счётчик не покажет.
    test('should_stay_non_data_in_nextCareDue_when_repo_failure', () async {
      when(() => repo.getSchedules(_plantId))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      final container = makeContainer();
      final subUp = container.listen(plantSchedulesProvider(_plantId), (_, _) {});
      final sub = container.listen(
        nextCareDueProvider(plantId: _plantId, kind: CareEventKind.water),
        (_, _) {},
      );
      addTearDown(subUp.close);
      addTearDown(sub.close);

      await settle(container);

      final state = container.read(
        nextCareDueProvider(plantId: _plantId, kind: CareEventKind.water),
      );
      // Главное: НЕ data со значением — ложного «через N дн.» не будет.
      expect(state.hasValue, isFalse);
      // Зафиксировано фактическое: остаётся loading, не превращается в error.
      expect(state.isLoading, isTrue);
      expect(state.hasError, isFalse);
    });

    // Auth-слот: scope (user) ставит репозиторий (покрыто в его repo-тесте).
    // Здесь подтверждаем, что наш потребительский провайдер НЕ меняет контракт —
    // зовёт getSchedules с тем же plantId и ничем больше, не подменяя scope.
    test('should_call_getSchedules_with_plantId_unchanged', () async {
      when(() => repo.getSchedules(any())).thenAnswer(
        (_) async => Result.success([
          _schedule(type: CareTaskType.watering, nextDueAt: _nextDue),
        ]),
      );

      final container = makeContainer();

      await container.read(plantSchedulesProvider(_plantId).future);

      verify(() => repo.getSchedules(_plantId)).called(1);
      verifyNoMoreInteractions(repo);
    });
  });
}
