// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rooms_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(RoomsController)
final roomsControllerProvider = RoomsControllerProvider._();

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
final class RoomsControllerProvider
    extends $AsyncNotifierProvider<RoomsController, List<GardenLocation>> {
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
  RoomsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomsControllerHash();

  @$internal
  @override
  RoomsController create() => RoomsController();
}

String _$roomsControllerHash() => r'7ad7b64a1a6affa3bfaf0b2c5dffe6c75b585525';

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

abstract class _$RoomsController extends $AsyncNotifier<List<GardenLocation>> {
  FutureOr<List<GardenLocation>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<GardenLocation>>, List<GardenLocation>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<GardenLocation>>,
                List<GardenLocation>
              >,
              AsyncValue<List<GardenLocation>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
