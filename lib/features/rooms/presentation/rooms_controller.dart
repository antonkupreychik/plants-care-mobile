import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../../core/locations/garden_location.dart';
// Кросс-фичевая инвалидация после успешной мутации: чипы комнат на главной
// (home) должны обновиться. Импорт presentation-провайдера home — осознанное
// исключение из границы слоёв (как в log_care_event_controller): иного канала
// «данные устарели» в Riverpod нет, зависим только от объявления провайдера.
import '../../home/presentation/home_providers.dart';
import '../data/rooms_repository_provider.dart';

part 'rooms_controller.g.dart';

/// State-слой фичи «Управление комнатами» (CRUD локаций).
///
/// Список комнат — `AsyncValue<List<GardenLocation>>` (loading / error / data);
/// в `AsyncError` лежит типизированный `ApiError` (репозиторий вернул `Failure`,
/// разворачиваем броском). UI читает через
/// `ref.watch(roomsControllerProvider)`.
///
/// Контракт для ui-builder — методы мутаций возвращают
/// `Future<Result<GardenLocation>>` / `Future<Result<void>>` (НЕ `void`,
/// FLUTTER.md: ошибку не глотаем). UI матчит `Success`/`Failure(:final error)`
/// и рисует баннер/тост по типу `ApiError` через `AppLocalizations`. Выбор
/// `Result` (а не `ApiError?`): тип сохраняет данные успеха (созданная/
/// обновлённая локация) и единообразен со слоем data — одно pattern-matching
/// на всех слоях.
///
/// **LOCATION_NOT_EMPTY:** [delete] при удалении непустой локации без
/// [targetLocationId] вернёт `Failure(LocationNotEmptyError())`. UI проверяет
/// `result case Failure(error: LocationNotEmptyError())`, показывает пикер
/// целевой локации и повторяет [delete] с заданным [targetLocationId].
///
/// После любой успешной мутации список рефетчится и инвалидируется
/// [homeLocationsProvider] (чипы комнат на главной).
@riverpod
class RoomsController extends _$RoomsController {
  @override
  Future<List<GardenLocation>> build() async {
    final result = await ref.watch(roomsRepositoryProvider).getLocations();
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }

  /// Создать комнату. На успех — рефетч списка + инвалидация home-чипов.
  Future<Result<GardenLocation>> create({
    required String name,
    String? emoji,
  }) async {
    final result = await ref
        .read(roomsRepositoryProvider)
        .createLocation(name: name, emoji: emoji);
    if (result is Success<GardenLocation>) await _refreshAll();
    return result;
  }

  /// Переименовать / обновить комнату (PATCH-семантика: шлём только заданные
  /// поля). Имя `rename` (а не `update`) — `update` занято базовым
  /// `AsyncNotifier`. На успех — рефетч списка + инвалидация home-чипов.
  Future<Result<GardenLocation>> rename({
    required int id,
    String? name,
    String? emoji,
  }) async {
    final result = await ref
        .read(roomsRepositoryProvider)
        .updateLocation(id: id, name: name, emoji: emoji);
    if (result is Success<GardenLocation>) await _refreshAll();
    return result;
  }

  /// Удалить комнату.
  ///
  /// При непустой локации вернёт `Failure(LocationNotEmptyError())` — UI должен
  /// показать пикер переноса и вызвать [moveAndDelete] (клиентский каскад,
  /// issue #183). На успех — рефетч списка + инвалидация home-чипов.
  ///
  /// [targetLocationId] backend больше не принимает (issue #250) — параметр
  /// сохранён для совместимости сигнатуры, в перенос не участвует.
  Future<Result<void>> delete({
    required int id,
    int? targetLocationId,
  }) async {
    final result = await ref
        .read(roomsRepositoryProvider)
        .deleteLocation(id: id, targetLocationId: targetLocationId);
    if (result is Success<void>) await _refreshAll();
    return result;
  }

  /// Перенести растения в [targetLocationId] и удалить комнату [id]
  /// (клиентский каскад, issue #183: серверного переноса больше нет).
  ///
  /// Вызывается из UI после выбора целевой комнаты в пикере (delete вернул
  /// `LocationNotEmptyError`). На успех — рефетч списка + инвалидация
  /// home-чипов. При ошибке переноса репозиторий не удаляет комнату и вернёт
  /// `Failure` — UI покажет тост, список не трогаем.
  Future<Result<void>> moveAndDelete({
    required int id,
    required int targetLocationId,
  }) async {
    final result = await ref.read(roomsRepositoryProvider).movePlantsAndDelete(
          fromLocationId: id,
          targetLocationId: targetLocationId,
        );
    if (result is Success<void>) await _refreshAll();
    return result;
  }

  /// Перечитать список комнат и обновить чипы на главной (home).
  ///
  /// Список здесь — источник правды фичи: рефетчим через
  /// `AsyncValue.guard` (loading → data/error). Параллельно инвалидируем
  /// [homeLocationsProvider], т.к. главная держит свой кеш локаций.
  Future<void> _refreshAll() async {
    ref.invalidate(homeLocationsProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(roomsRepositoryProvider).getLocations();
      return switch (result) {
        Success(:final value) => value,
        Failure(:final error) => throw error,
      };
    });
  }
}
