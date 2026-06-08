// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_room_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Запрошенный фильтр-комната главной SDUI-витрины. `null` = «Все комнаты».
///
/// ВАЖНО (MADR-017): это НЕ источник правды выделения — выбранный чип сервер
/// возвращает в `location_chips.selectedLocationId`. Этот провайдер хранит лишь
/// **какой `locationId` сейчас запрошен**, чтобы [homeScreenLayout] прокинул его
/// в `GET /api/v1/ui/home?locationId=`. Тап по чипу пишет сюда новое значение →
/// перезапрос лейаута → сервер пересобирает витрину под комнату.
///
/// Через codegen — **autoDispose**: уход с Главной сбрасывает фильтр (не залипает
/// на исчезнувшей после рефреша комнате).

@ProviderFor(HomeRoomFilter)
final homeRoomFilterProvider = HomeRoomFilterProvider._();

/// Запрошенный фильтр-комната главной SDUI-витрины. `null` = «Все комнаты».
///
/// ВАЖНО (MADR-017): это НЕ источник правды выделения — выбранный чип сервер
/// возвращает в `location_chips.selectedLocationId`. Этот провайдер хранит лишь
/// **какой `locationId` сейчас запрошен**, чтобы [homeScreenLayout] прокинул его
/// в `GET /api/v1/ui/home?locationId=`. Тап по чипу пишет сюда новое значение →
/// перезапрос лейаута → сервер пересобирает витрину под комнату.
///
/// Через codegen — **autoDispose**: уход с Главной сбрасывает фильтр (не залипает
/// на исчезнувшей после рефреша комнате).
final class HomeRoomFilterProvider
    extends $NotifierProvider<HomeRoomFilter, int?> {
  /// Запрошенный фильтр-комната главной SDUI-витрины. `null` = «Все комнаты».
  ///
  /// ВАЖНО (MADR-017): это НЕ источник правды выделения — выбранный чип сервер
  /// возвращает в `location_chips.selectedLocationId`. Этот провайдер хранит лишь
  /// **какой `locationId` сейчас запрошен**, чтобы [homeScreenLayout] прокинул его
  /// в `GET /api/v1/ui/home?locationId=`. Тап по чипу пишет сюда новое значение →
  /// перезапрос лейаута → сервер пересобирает витрину под комнату.
  ///
  /// Через codegen — **autoDispose**: уход с Главной сбрасывает фильтр (не залипает
  /// на исчезнувшей после рефреша комнате).
  HomeRoomFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRoomFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRoomFilterHash();

  @$internal
  @override
  HomeRoomFilter create() => HomeRoomFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$homeRoomFilterHash() => r'a8baab300ac3e8fd3c0645468af8cad2d9c21c9d';

/// Запрошенный фильтр-комната главной SDUI-витрины. `null` = «Все комнаты».
///
/// ВАЖНО (MADR-017): это НЕ источник правды выделения — выбранный чип сервер
/// возвращает в `location_chips.selectedLocationId`. Этот провайдер хранит лишь
/// **какой `locationId` сейчас запрошен**, чтобы [homeScreenLayout] прокинул его
/// в `GET /api/v1/ui/home?locationId=`. Тап по чипу пишет сюда новое значение →
/// перезапрос лейаута → сервер пересобирает витрину под комнату.
///
/// Через codegen — **autoDispose**: уход с Главной сбрасывает фильтр (не залипает
/// на исчезнувшей после рефреша комнате).

abstract class _$HomeRoomFilter extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
