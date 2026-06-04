import '../../../core/error/result.dart';
import '../../../core/locations/garden_location.dart';
import 'plant.dart';
import 'today_tasks_result.dart';

/// Контракт data-слоя для экрана «Главная — Мой сад» (01).
///
/// Один интерфейс на фичу: три чтения (today / plants / locations) логически
/// принадлежат одному экрану и одной реализации [HomeRepositoryImpl]. Методы
/// возвращают `Future<Result<T>>` и НЕ бросают наружу (MADR-011).
///
/// Domain-контракт: реализация скрыта в data, presentation зависит только
/// от этого интерфейса (MADR-002).
abstract interface class HomeRepository {
  /// Задачи ухода на сегодня со сводкой прогресса (`GET /today`, scope chat).
  ///
  /// Возвращает [TodayTasksResult] с полным списком задач (включая выполненные)
  /// и счётчиками завершения из `TodaySummary` для прогресс-бара в [TodayCard].
  Future<Result<TodayTasksResult>> getTodayTasks();

  /// Растения пользователя (`GET /plants`, scope user).
  /// [limit] — размер страницы (backend обрезает до [1, 100]).
  Future<Result<List<Plant>>> getPlants({int limit});

  /// Локации пользователя (`GET /locations`, scope user).
  Future<Result<List<GardenLocation>>> getLocations();
}
