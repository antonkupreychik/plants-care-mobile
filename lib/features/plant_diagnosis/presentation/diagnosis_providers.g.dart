// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnosis_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой экрана «Диагноз растения» (15).
///
/// Два независимых family-провайдера (по [plantId]): диагноз и базовая
/// инфа о растении для шапки. Раздельные провайдеры — загружаются и падают
/// независимо, UI рисует skeleton/ошибку по секциям.
///
/// Контракт для ui-builder:
///
/// - [plantDiagnosisProvider] — `AsyncValue<PlantDiagnosis>`.
///   В `AsyncError` лежит типизированный [ApiError].
///   Из `data` UI читает `value.issues`, `value.recommendations`,
///   `value.isHealthy`.
///
/// - [diagnosisPlantProvider] — `AsyncValue<Plant>` (имя, вид, локация для
///   шапки экрана). Переиспользует `CareHistoryRepository.getPlant` —
///   идентичный метод, не дублируем логику.
///
/// Оба провайдера `keepAlive: false` (autoDispose по умолчанию с codegen):
/// данные диагностики не кешируются; при повторном открытии экрана загружаются
/// заново (свежий диагноз).
/// Диагноз растения (`GET /plants/{id}/diagnosis`, scope user).
///
/// Разворачивает [Result] в значение или бросает [ApiError], который Riverpod
/// упакует в `AsyncError` (типизированный, не строка).

@ProviderFor(plantDiagnosis)
final plantDiagnosisProvider = PlantDiagnosisFamily._();

/// State-слой экрана «Диагноз растения» (15).
///
/// Два независимых family-провайдера (по [plantId]): диагноз и базовая
/// инфа о растении для шапки. Раздельные провайдеры — загружаются и падают
/// независимо, UI рисует skeleton/ошибку по секциям.
///
/// Контракт для ui-builder:
///
/// - [plantDiagnosisProvider] — `AsyncValue<PlantDiagnosis>`.
///   В `AsyncError` лежит типизированный [ApiError].
///   Из `data` UI читает `value.issues`, `value.recommendations`,
///   `value.isHealthy`.
///
/// - [diagnosisPlantProvider] — `AsyncValue<Plant>` (имя, вид, локация для
///   шапки экрана). Переиспользует `CareHistoryRepository.getPlant` —
///   идентичный метод, не дублируем логику.
///
/// Оба провайдера `keepAlive: false` (autoDispose по умолчанию с codegen):
/// данные диагностики не кешируются; при повторном открытии экрана загружаются
/// заново (свежий диагноз).
/// Диагноз растения (`GET /plants/{id}/diagnosis`, scope user).
///
/// Разворачивает [Result] в значение или бросает [ApiError], который Riverpod
/// упакует в `AsyncError` (типизированный, не строка).

final class PlantDiagnosisProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlantDiagnosis>,
          PlantDiagnosis,
          FutureOr<PlantDiagnosis>
        >
    with $FutureModifier<PlantDiagnosis>, $FutureProvider<PlantDiagnosis> {
  /// State-слой экрана «Диагноз растения» (15).
  ///
  /// Два независимых family-провайдера (по [plantId]): диагноз и базовая
  /// инфа о растении для шапки. Раздельные провайдеры — загружаются и падают
  /// независимо, UI рисует skeleton/ошибку по секциям.
  ///
  /// Контракт для ui-builder:
  ///
  /// - [plantDiagnosisProvider] — `AsyncValue<PlantDiagnosis>`.
  ///   В `AsyncError` лежит типизированный [ApiError].
  ///   Из `data` UI читает `value.issues`, `value.recommendations`,
  ///   `value.isHealthy`.
  ///
  /// - [diagnosisPlantProvider] — `AsyncValue<Plant>` (имя, вид, локация для
  ///   шапки экрана). Переиспользует `CareHistoryRepository.getPlant` —
  ///   идентичный метод, не дублируем логику.
  ///
  /// Оба провайдера `keepAlive: false` (autoDispose по умолчанию с codegen):
  /// данные диагностики не кешируются; при повторном открытии экрана загружаются
  /// заново (свежий диагноз).
  /// Диагноз растения (`GET /plants/{id}/diagnosis`, scope user).
  ///
  /// Разворачивает [Result] в значение или бросает [ApiError], который Riverpod
  /// упакует в `AsyncError` (типизированный, не строка).
  PlantDiagnosisProvider._({
    required PlantDiagnosisFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'plantDiagnosisProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantDiagnosisHash();

  @override
  String toString() {
    return r'plantDiagnosisProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PlantDiagnosis> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlantDiagnosis> create(Ref ref) {
    final argument = this.argument as int;
    return plantDiagnosis(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantDiagnosisProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantDiagnosisHash() => r'55349be3ab7e0479b0234e9713e34f3ad6b48986';

/// State-слой экрана «Диагноз растения» (15).
///
/// Два независимых family-провайдера (по [plantId]): диагноз и базовая
/// инфа о растении для шапки. Раздельные провайдеры — загружаются и падают
/// независимо, UI рисует skeleton/ошибку по секциям.
///
/// Контракт для ui-builder:
///
/// - [plantDiagnosisProvider] — `AsyncValue<PlantDiagnosis>`.
///   В `AsyncError` лежит типизированный [ApiError].
///   Из `data` UI читает `value.issues`, `value.recommendations`,
///   `value.isHealthy`.
///
/// - [diagnosisPlantProvider] — `AsyncValue<Plant>` (имя, вид, локация для
///   шапки экрана). Переиспользует `CareHistoryRepository.getPlant` —
///   идентичный метод, не дублируем логику.
///
/// Оба провайдера `keepAlive: false` (autoDispose по умолчанию с codegen):
/// данные диагностики не кешируются; при повторном открытии экрана загружаются
/// заново (свежий диагноз).
/// Диагноз растения (`GET /plants/{id}/diagnosis`, scope user).
///
/// Разворачивает [Result] в значение или бросает [ApiError], который Riverpod
/// упакует в `AsyncError` (типизированный, не строка).

final class PlantDiagnosisFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PlantDiagnosis>, int> {
  PlantDiagnosisFamily._()
    : super(
        retry: null,
        name: r'plantDiagnosisProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// State-слой экрана «Диагноз растения» (15).
  ///
  /// Два независимых family-провайдера (по [plantId]): диагноз и базовая
  /// инфа о растении для шапки. Раздельные провайдеры — загружаются и падают
  /// независимо, UI рисует skeleton/ошибку по секциям.
  ///
  /// Контракт для ui-builder:
  ///
  /// - [plantDiagnosisProvider] — `AsyncValue<PlantDiagnosis>`.
  ///   В `AsyncError` лежит типизированный [ApiError].
  ///   Из `data` UI читает `value.issues`, `value.recommendations`,
  ///   `value.isHealthy`.
  ///
  /// - [diagnosisPlantProvider] — `AsyncValue<Plant>` (имя, вид, локация для
  ///   шапки экрана). Переиспользует `CareHistoryRepository.getPlant` —
  ///   идентичный метод, не дублируем логику.
  ///
  /// Оба провайдера `keepAlive: false` (autoDispose по умолчанию с codegen):
  /// данные диагностики не кешируются; при повторном открытии экрана загружаются
  /// заново (свежий диагноз).
  /// Диагноз растения (`GET /plants/{id}/diagnosis`, scope user).
  ///
  /// Разворачивает [Result] в значение или бросает [ApiError], который Riverpod
  /// упакует в `AsyncError` (типизированный, не строка).

  PlantDiagnosisProvider call(int plantId) =>
      PlantDiagnosisProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantDiagnosisProvider';
}

/// Базовая инфа о растении для шапки экрана (имя, вид, локация).
///
/// Переиспользует `CareHistoryRepository.getPlant` (`GET /plants/{id}`, scope
/// user) — тот же эндпоинт, тот же результирующий тип [Plant]. Не дублируем
/// сетевой вызов и маппер: зависимость на domain соседней фичи допустима
/// (FLUTTER.md / MADR-003), зависимость на её presentation — запрещена.
///
/// Паттерн скопирован из [careHistoryPlantProvider].

@ProviderFor(diagnosisPlant)
final diagnosisPlantProvider = DiagnosisPlantFamily._();

/// Базовая инфа о растении для шапки экрана (имя, вид, локация).
///
/// Переиспользует `CareHistoryRepository.getPlant` (`GET /plants/{id}`, scope
/// user) — тот же эндпоинт, тот же результирующий тип [Plant]. Не дублируем
/// сетевой вызов и маппер: зависимость на domain соседней фичи допустима
/// (FLUTTER.md / MADR-003), зависимость на её presentation — запрещена.
///
/// Паттерн скопирован из [careHistoryPlantProvider].

final class DiagnosisPlantProvider
    extends $FunctionalProvider<AsyncValue<Plant>, Plant, FutureOr<Plant>>
    with $FutureModifier<Plant>, $FutureProvider<Plant> {
  /// Базовая инфа о растении для шапки экрана (имя, вид, локация).
  ///
  /// Переиспользует `CareHistoryRepository.getPlant` (`GET /plants/{id}`, scope
  /// user) — тот же эндпоинт, тот же результирующий тип [Plant]. Не дублируем
  /// сетевой вызов и маппер: зависимость на domain соседней фичи допустима
  /// (FLUTTER.md / MADR-003), зависимость на её presentation — запрещена.
  ///
  /// Паттерн скопирован из [careHistoryPlantProvider].
  DiagnosisPlantProvider._({
    required DiagnosisPlantFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'diagnosisPlantProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diagnosisPlantHash();

  @override
  String toString() {
    return r'diagnosisPlantProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Plant> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Plant> create(Ref ref) {
    final argument = this.argument as int;
    return diagnosisPlant(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiagnosisPlantProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diagnosisPlantHash() => r'cecbe19271842c68bbc26659b23f2d07da481e16';

/// Базовая инфа о растении для шапки экрана (имя, вид, локация).
///
/// Переиспользует `CareHistoryRepository.getPlant` (`GET /plants/{id}`, scope
/// user) — тот же эндпоинт, тот же результирующий тип [Plant]. Не дублируем
/// сетевой вызов и маппер: зависимость на domain соседней фичи допустима
/// (FLUTTER.md / MADR-003), зависимость на её presentation — запрещена.
///
/// Паттерн скопирован из [careHistoryPlantProvider].

final class DiagnosisPlantFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Plant>, int> {
  DiagnosisPlantFamily._()
    : super(
        retry: null,
        name: r'diagnosisPlantProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Базовая инфа о растении для шапки экрана (имя, вид, локация).
  ///
  /// Переиспользует `CareHistoryRepository.getPlant` (`GET /plants/{id}`, scope
  /// user) — тот же эндпоинт, тот же результирующий тип [Plant]. Не дублируем
  /// сетевой вызов и маппер: зависимость на domain соседней фичи допустима
  /// (FLUTTER.md / MADR-003), зависимость на её presentation — запрещена.
  ///
  /// Паттерн скопирован из [careHistoryPlantProvider].

  DiagnosisPlantProvider call(int plantId) =>
      DiagnosisPlantProvider._(argument: plantId, from: this);

  @override
  String toString() => r'diagnosisPlantProvider';
}
