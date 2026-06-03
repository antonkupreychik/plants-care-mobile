import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import '../../care_history/data/care_history_repository_provider.dart';
import '../data/diagnosis_repository_provider.dart';
import '../domain/plant_diagnosis.dart';

part 'diagnosis_providers.g.dart';

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
@riverpod
Future<PlantDiagnosis> plantDiagnosis(Ref ref, int plantId) async {
  final result =
      await ref.watch(diagnosisRepositoryProvider).getDiagnosis(plantId);
  return _unwrap(result);
}

/// Базовая инфа о растении для шапки экрана (имя, вид, локация).
///
/// Переиспользует `CareHistoryRepository.getPlant` (`GET /plants/{id}`, scope
/// user) — тот же эндпоинт, тот же результирующий тип [Plant]. Не дублируем
/// сетевой вызов и маппер: зависимость на domain соседней фичи допустима
/// (FLUTTER.md / MADR-003), зависимость на её presentation — запрещена.
///
/// Паттерн скопирован из [careHistoryPlantProvider].
@riverpod
Future<Plant> diagnosisPlant(Ref ref, int plantId) async {
  final result =
      await ref.watch(careHistoryRepositoryProvider).getPlant(plantId);
  return _unwrap(result);
}

/// Разворачивает [Result<T>]: успех → значение, ошибка → бросок [ApiError],
/// который Riverpod упакует в `AsyncError` (типизированный, не строка).
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      Failure<T>(:final error) => throw error,
    };
