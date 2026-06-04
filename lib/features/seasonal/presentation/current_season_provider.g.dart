// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_season_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Текущий сезон для подсветки на экране 35.
///
/// Считается по месяцу из инжектируемого [Clock] (FLUTTER.md «Время»: не зовём
/// `DateTime.now()` напрямую — детерминируемо в тестах через
/// `clockProvider.overrideWithValue(FakeClock(...))`).
///
/// Это ТОЛЬКО презентационная классификация «какой сейчас сезон» для подсветки
/// карточки/столбца — НЕ расчёт интервалов ухода. Интервалы считает backend
/// (`CareScheduleDto.seasonal`); клиент их не пересчитывает. Месяц берём из
/// UTC-времени (грубой привязки месяца к сезону достаточно — это не про
/// границы суток в таймзоне).

@ProviderFor(currentSeason)
final currentSeasonProvider = CurrentSeasonProvider._();

/// Текущий сезон для подсветки на экране 35.
///
/// Считается по месяцу из инжектируемого [Clock] (FLUTTER.md «Время»: не зовём
/// `DateTime.now()` напрямую — детерминируемо в тестах через
/// `clockProvider.overrideWithValue(FakeClock(...))`).
///
/// Это ТОЛЬКО презентационная классификация «какой сейчас сезон» для подсветки
/// карточки/столбца — НЕ расчёт интервалов ухода. Интервалы считает backend
/// (`CareScheduleDto.seasonal`); клиент их не пересчитывает. Месяц берём из
/// UTC-времени (грубой привязки месяца к сезону достаточно — это не про
/// границы суток в таймзоне).

final class CurrentSeasonProvider
    extends $FunctionalProvider<Season, Season, Season>
    with $Provider<Season> {
  /// Текущий сезон для подсветки на экране 35.
  ///
  /// Считается по месяцу из инжектируемого [Clock] (FLUTTER.md «Время»: не зовём
  /// `DateTime.now()` напрямую — детерминируемо в тестах через
  /// `clockProvider.overrideWithValue(FakeClock(...))`).
  ///
  /// Это ТОЛЬКО презентационная классификация «какой сейчас сезон» для подсветки
  /// карточки/столбца — НЕ расчёт интервалов ухода. Интервалы считает backend
  /// (`CareScheduleDto.seasonal`); клиент их не пересчитывает. Месяц берём из
  /// UTC-времени (грубой привязки месяца к сезону достаточно — это не про
  /// границы суток в таймзоне).
  CurrentSeasonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSeasonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSeasonHash();

  @$internal
  @override
  $ProviderElement<Season> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Season create(Ref ref) {
    return currentSeason(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Season value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Season>(value),
    );
  }
}

String _$currentSeasonHash() => r'4c8a04031531a22e1d609190a548bf65ae4c9015';
