// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone_options_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Курируемый список таймзон для экрана выбора (37).
///
/// Контракт для ui-builder:
/// - [timezoneOptionsProvider] → `List<KnownTimezone>` (статичный курируемый
///   список `kKnownTimezones`: ianaId, city, gmtLabel). Провайдер — точка для
///   подмены в тестах и будущего расширения (поиск/полный список).
///
/// Выбранная таймзона определяется СРАВНЕНИЕМ `option.ianaId` с
/// `quietHoursControllerProvider` → `state.draft.timezone`: UI помечает «✓» ту
/// запись, у которой `ianaId == draft.timezone`. По тапу UI зовёт
/// `quietHoursController.setTimezone(option.ianaId)`. Если текущая таймзона
/// пользователя НЕ из списка (`knownTimezoneById` вернёт `null`), UI показывает
/// её отдельной raw-строкой (помечена выбранной по той же `ianaId`-проверке).

@ProviderFor(timezoneOptions)
final timezoneOptionsProvider = TimezoneOptionsProvider._();

/// Курируемый список таймзон для экрана выбора (37).
///
/// Контракт для ui-builder:
/// - [timezoneOptionsProvider] → `List<KnownTimezone>` (статичный курируемый
///   список `kKnownTimezones`: ianaId, city, gmtLabel). Провайдер — точка для
///   подмены в тестах и будущего расширения (поиск/полный список).
///
/// Выбранная таймзона определяется СРАВНЕНИЕМ `option.ianaId` с
/// `quietHoursControllerProvider` → `state.draft.timezone`: UI помечает «✓» ту
/// запись, у которой `ianaId == draft.timezone`. По тапу UI зовёт
/// `quietHoursController.setTimezone(option.ianaId)`. Если текущая таймзона
/// пользователя НЕ из списка (`knownTimezoneById` вернёт `null`), UI показывает
/// её отдельной raw-строкой (помечена выбранной по той же `ianaId`-проверке).

final class TimezoneOptionsProvider
    extends
        $FunctionalProvider<
          List<KnownTimezone>,
          List<KnownTimezone>,
          List<KnownTimezone>
        >
    with $Provider<List<KnownTimezone>> {
  /// Курируемый список таймзон для экрана выбора (37).
  ///
  /// Контракт для ui-builder:
  /// - [timezoneOptionsProvider] → `List<KnownTimezone>` (статичный курируемый
  ///   список `kKnownTimezones`: ianaId, city, gmtLabel). Провайдер — точка для
  ///   подмены в тестах и будущего расширения (поиск/полный список).
  ///
  /// Выбранная таймзона определяется СРАВНЕНИЕМ `option.ianaId` с
  /// `quietHoursControllerProvider` → `state.draft.timezone`: UI помечает «✓» ту
  /// запись, у которой `ianaId == draft.timezone`. По тапу UI зовёт
  /// `quietHoursController.setTimezone(option.ianaId)`. Если текущая таймзона
  /// пользователя НЕ из списка (`knownTimezoneById` вернёт `null`), UI показывает
  /// её отдельной raw-строкой (помечена выбранной по той же `ianaId`-проверке).
  TimezoneOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timezoneOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timezoneOptionsHash();

  @$internal
  @override
  $ProviderElement<List<KnownTimezone>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<KnownTimezone> create(Ref ref) {
    return timezoneOptions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<KnownTimezone> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<KnownTimezone>>(value),
    );
  }
}

String _$timezoneOptionsHash() => r'69c9dc7d7bbd4bf3d9a310c28cebf80a67a2b2a1';
