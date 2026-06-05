// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер экрана 25 «Режим отпуска». Не family (статус один на пользователя).
///
/// Контракт для ui-builder:
/// - провайдер `vacationControllerProvider` → `AsyncValue<VacationState>`.
/// - `build` грузит `GET /api/v1/vacation`, кладёт `status` и инициализирует
///   `range` пресетом (сегодня … +13 дней по [Clock]). Ошибка загрузки →
///   `AsyncError(ApiError)`.
/// - чтение: `state.status` (включён ли отпуск), `state.range` (выбранный
///   диапазон), `state.isActive`, `state.canEnable`, `state.busy`,
///   `state.actionError`.
/// - правка дат: [setFrom] / [setTo] (только локально, без сети).
/// - действия: [enable] (`POST`), [disable] (`DELETE`) → возвращают [ApiError]?
///   (`null` = успех).

@ProviderFor(VacationController)
final vacationControllerProvider = VacationControllerProvider._();

/// Контроллер экрана 25 «Режим отпуска». Не family (статус один на пользователя).
///
/// Контракт для ui-builder:
/// - провайдер `vacationControllerProvider` → `AsyncValue<VacationState>`.
/// - `build` грузит `GET /api/v1/vacation`, кладёт `status` и инициализирует
///   `range` пресетом (сегодня … +13 дней по [Clock]). Ошибка загрузки →
///   `AsyncError(ApiError)`.
/// - чтение: `state.status` (включён ли отпуск), `state.range` (выбранный
///   диапазон), `state.isActive`, `state.canEnable`, `state.busy`,
///   `state.actionError`.
/// - правка дат: [setFrom] / [setTo] (только локально, без сети).
/// - действия: [enable] (`POST`), [disable] (`DELETE`) → возвращают [ApiError]?
///   (`null` = успех).
final class VacationControllerProvider
    extends $AsyncNotifierProvider<VacationController, VacationState> {
  /// Контроллер экрана 25 «Режим отпуска». Не family (статус один на пользователя).
  ///
  /// Контракт для ui-builder:
  /// - провайдер `vacationControllerProvider` → `AsyncValue<VacationState>`.
  /// - `build` грузит `GET /api/v1/vacation`, кладёт `status` и инициализирует
  ///   `range` пресетом (сегодня … +13 дней по [Clock]). Ошибка загрузки →
  ///   `AsyncError(ApiError)`.
  /// - чтение: `state.status` (включён ли отпуск), `state.range` (выбранный
  ///   диапазон), `state.isActive`, `state.canEnable`, `state.busy`,
  ///   `state.actionError`.
  /// - правка дат: [setFrom] / [setTo] (только локально, без сети).
  /// - действия: [enable] (`POST`), [disable] (`DELETE`) → возвращают [ApiError]?
  ///   (`null` = успех).
  VacationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vacationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vacationControllerHash();

  @$internal
  @override
  VacationController create() => VacationController();
}

String _$vacationControllerHash() =>
    r'613466f83782b6716b2c2645033a3b304b794a38';

/// Контроллер экрана 25 «Режим отпуска». Не family (статус один на пользователя).
///
/// Контракт для ui-builder:
/// - провайдер `vacationControllerProvider` → `AsyncValue<VacationState>`.
/// - `build` грузит `GET /api/v1/vacation`, кладёт `status` и инициализирует
///   `range` пресетом (сегодня … +13 дней по [Clock]). Ошибка загрузки →
///   `AsyncError(ApiError)`.
/// - чтение: `state.status` (включён ли отпуск), `state.range` (выбранный
///   диапазон), `state.isActive`, `state.canEnable`, `state.busy`,
///   `state.actionError`.
/// - правка дат: [setFrom] / [setTo] (только локально, без сети).
/// - действия: [enable] (`POST`), [disable] (`DELETE`) → возвращают [ApiError]?
///   (`null` = успех).

abstract class _$VacationController extends $AsyncNotifier<VacationState> {
  FutureOr<VacationState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<VacationState>, VacationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VacationState>, VacationState>,
              AsyncValue<VacationState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
