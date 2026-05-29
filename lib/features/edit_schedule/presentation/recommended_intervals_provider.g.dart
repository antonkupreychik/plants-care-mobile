// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_intervals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Рекомендованные интервалы ухода (в днях) для вида растения — основа кнопки
/// «Сбросить» на экране 22.
///
/// Family по [plantId]. Источник:
/// 1. деталь растения (`plantDetailProvider`) → `speciesId`;
/// 2. деталь вида (`speciesDetailProvider`) → `wateringDays` / `mistingDays` /
///    `fertilizingDays` / `soilCheckDays`.
///
/// Переиспользует существующие family-провайдеры (общий кэш, без дублирующих
/// запросов).
///
/// Контракт для ui-builder: `AsyncValue<Map<CareTaskType, int>?>`.
/// - `null` (data) → у растения нет `speciesId`, вид не загрузился, или у вида
///   нет ни одного интервала → UI скрывает «Сбросить»;
/// - непустой `Map` → доступные рекомендации (только те *Days, что не `null`),
///   передаётся в `EditScheduleController.reset(...)`.
///
/// Ошибку загрузки растения/вида НЕ пробрасываем как `AsyncError`: «Сбросить» —
/// необязательная функция, её отсутствие не должно ломать экран. Любая неудача
/// или отсутствие данных → `null`.

@ProviderFor(recommendedIntervals)
final recommendedIntervalsProvider = RecommendedIntervalsFamily._();

/// Рекомендованные интервалы ухода (в днях) для вида растения — основа кнопки
/// «Сбросить» на экране 22.
///
/// Family по [plantId]. Источник:
/// 1. деталь растения (`plantDetailProvider`) → `speciesId`;
/// 2. деталь вида (`speciesDetailProvider`) → `wateringDays` / `mistingDays` /
///    `fertilizingDays` / `soilCheckDays`.
///
/// Переиспользует существующие family-провайдеры (общий кэш, без дублирующих
/// запросов).
///
/// Контракт для ui-builder: `AsyncValue<Map<CareTaskType, int>?>`.
/// - `null` (data) → у растения нет `speciesId`, вид не загрузился, или у вида
///   нет ни одного интервала → UI скрывает «Сбросить»;
/// - непустой `Map` → доступные рекомендации (только те *Days, что не `null`),
///   передаётся в `EditScheduleController.reset(...)`.
///
/// Ошибку загрузки растения/вида НЕ пробрасываем как `AsyncError`: «Сбросить» —
/// необязательная функция, её отсутствие не должно ломать экран. Любая неудача
/// или отсутствие данных → `null`.

final class RecommendedIntervalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<CareTaskType, int>?>,
          Map<CareTaskType, int>?,
          FutureOr<Map<CareTaskType, int>?>
        >
    with
        $FutureModifier<Map<CareTaskType, int>?>,
        $FutureProvider<Map<CareTaskType, int>?> {
  /// Рекомендованные интервалы ухода (в днях) для вида растения — основа кнопки
  /// «Сбросить» на экране 22.
  ///
  /// Family по [plantId]. Источник:
  /// 1. деталь растения (`plantDetailProvider`) → `speciesId`;
  /// 2. деталь вида (`speciesDetailProvider`) → `wateringDays` / `mistingDays` /
  ///    `fertilizingDays` / `soilCheckDays`.
  ///
  /// Переиспользует существующие family-провайдеры (общий кэш, без дублирующих
  /// запросов).
  ///
  /// Контракт для ui-builder: `AsyncValue<Map<CareTaskType, int>?>`.
  /// - `null` (data) → у растения нет `speciesId`, вид не загрузился, или у вида
  ///   нет ни одного интервала → UI скрывает «Сбросить»;
  /// - непустой `Map` → доступные рекомендации (только те *Days, что не `null`),
  ///   передаётся в `EditScheduleController.reset(...)`.
  ///
  /// Ошибку загрузки растения/вида НЕ пробрасываем как `AsyncError`: «Сбросить» —
  /// необязательная функция, её отсутствие не должно ломать экран. Любая неудача
  /// или отсутствие данных → `null`.
  RecommendedIntervalsProvider._({
    required RecommendedIntervalsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'recommendedIntervalsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recommendedIntervalsHash();

  @override
  String toString() {
    return r'recommendedIntervalsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<CareTaskType, int>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<CareTaskType, int>?> create(Ref ref) {
    final argument = this.argument as int;
    return recommendedIntervals(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecommendedIntervalsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recommendedIntervalsHash() =>
    r'795157842797e7a704c6b18f0a6a1f538e89231c';

/// Рекомендованные интервалы ухода (в днях) для вида растения — основа кнопки
/// «Сбросить» на экране 22.
///
/// Family по [plantId]. Источник:
/// 1. деталь растения (`plantDetailProvider`) → `speciesId`;
/// 2. деталь вида (`speciesDetailProvider`) → `wateringDays` / `mistingDays` /
///    `fertilizingDays` / `soilCheckDays`.
///
/// Переиспользует существующие family-провайдеры (общий кэш, без дублирующих
/// запросов).
///
/// Контракт для ui-builder: `AsyncValue<Map<CareTaskType, int>?>`.
/// - `null` (data) → у растения нет `speciesId`, вид не загрузился, или у вида
///   нет ни одного интервала → UI скрывает «Сбросить»;
/// - непустой `Map` → доступные рекомендации (только те *Days, что не `null`),
///   передаётся в `EditScheduleController.reset(...)`.
///
/// Ошибку загрузки растения/вида НЕ пробрасываем как `AsyncError`: «Сбросить» —
/// необязательная функция, её отсутствие не должно ломать экран. Любая неудача
/// или отсутствие данных → `null`.

final class RecommendedIntervalsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<CareTaskType, int>?>, int> {
  RecommendedIntervalsFamily._()
    : super(
        retry: null,
        name: r'recommendedIntervalsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Рекомендованные интервалы ухода (в днях) для вида растения — основа кнопки
  /// «Сбросить» на экране 22.
  ///
  /// Family по [plantId]. Источник:
  /// 1. деталь растения (`plantDetailProvider`) → `speciesId`;
  /// 2. деталь вида (`speciesDetailProvider`) → `wateringDays` / `mistingDays` /
  ///    `fertilizingDays` / `soilCheckDays`.
  ///
  /// Переиспользует существующие family-провайдеры (общий кэш, без дублирующих
  /// запросов).
  ///
  /// Контракт для ui-builder: `AsyncValue<Map<CareTaskType, int>?>`.
  /// - `null` (data) → у растения нет `speciesId`, вид не загрузился, или у вида
  ///   нет ни одного интервала → UI скрывает «Сбросить»;
  /// - непустой `Map` → доступные рекомендации (только те *Days, что не `null`),
  ///   передаётся в `EditScheduleController.reset(...)`.
  ///
  /// Ошибку загрузки растения/вида НЕ пробрасываем как `AsyncError`: «Сбросить» —
  /// необязательная функция, её отсутствие не должно ломать экран. Любая неудача
  /// или отсутствие данных → `null`.

  RecommendedIntervalsProvider call(int plantId) =>
      RecommendedIntervalsProvider._(argument: plantId, from: this);

  @override
  String toString() => r'recommendedIntervalsProvider';
}
