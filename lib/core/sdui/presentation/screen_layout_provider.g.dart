// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_layout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой SDUI главного экрана (MADR-015).
///
/// Отдаёт `AsyncValue<SduiScreenLayout>` (loading / error / data). В `AsyncError`
/// лежит типизированный `ApiError` — UI маппит его в текст через
/// `AppLocalizations`, как остальные home-провайдеры.
///
/// Фильтр по комнате: провайдер `watch`-ит [homeRoomFilterProvider] (запрошенный
/// `locationId`, `null` = «Все») и прокидывает его в
/// `GET /api/v1/ui/home?locationId=`. Тап по чипу меняет [HomeRoomFilter] →
/// провайдер автоматически перезапрашивает лейаут → сервер отдаёт
/// отфильтрованную витрину + выделенный чип. Клиент сам список НЕ фильтрует.
///
/// Инвалидируется после успешного действия ухода (см. `ActionRunner`), чтобы
/// сервер пересобрал лейаут (`today_summary`, доступность действий).

@ProviderFor(homeScreenLayout)
final homeScreenLayoutProvider = HomeScreenLayoutProvider._();

/// State-слой SDUI главного экрана (MADR-015).
///
/// Отдаёт `AsyncValue<SduiScreenLayout>` (loading / error / data). В `AsyncError`
/// лежит типизированный `ApiError` — UI маппит его в текст через
/// `AppLocalizations`, как остальные home-провайдеры.
///
/// Фильтр по комнате: провайдер `watch`-ит [homeRoomFilterProvider] (запрошенный
/// `locationId`, `null` = «Все») и прокидывает его в
/// `GET /api/v1/ui/home?locationId=`. Тап по чипу меняет [HomeRoomFilter] →
/// провайдер автоматически перезапрашивает лейаут → сервер отдаёт
/// отфильтрованную витрину + выделенный чип. Клиент сам список НЕ фильтрует.
///
/// Инвалидируется после успешного действия ухода (см. `ActionRunner`), чтобы
/// сервер пересобрал лейаут (`today_summary`, доступность действий).

final class HomeScreenLayoutProvider
    extends
        $FunctionalProvider<
          AsyncValue<SduiScreenLayout>,
          SduiScreenLayout,
          FutureOr<SduiScreenLayout>
        >
    with $FutureModifier<SduiScreenLayout>, $FutureProvider<SduiScreenLayout> {
  /// State-слой SDUI главного экрана (MADR-015).
  ///
  /// Отдаёт `AsyncValue<SduiScreenLayout>` (loading / error / data). В `AsyncError`
  /// лежит типизированный `ApiError` — UI маппит его в текст через
  /// `AppLocalizations`, как остальные home-провайдеры.
  ///
  /// Фильтр по комнате: провайдер `watch`-ит [homeRoomFilterProvider] (запрошенный
  /// `locationId`, `null` = «Все») и прокидывает его в
  /// `GET /api/v1/ui/home?locationId=`. Тап по чипу меняет [HomeRoomFilter] →
  /// провайдер автоматически перезапрашивает лейаут → сервер отдаёт
  /// отфильтрованную витрину + выделенный чип. Клиент сам список НЕ фильтрует.
  ///
  /// Инвалидируется после успешного действия ухода (см. `ActionRunner`), чтобы
  /// сервер пересобрал лейаут (`today_summary`, доступность действий).
  HomeScreenLayoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeScreenLayoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeScreenLayoutHash();

  @$internal
  @override
  $FutureProviderElement<SduiScreenLayout> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SduiScreenLayout> create(Ref ref) {
    return homeScreenLayout(ref);
  }
}

String _$homeScreenLayoutHash() => r'3f1056aac54d2a3e8b20ed7912622f3e2a828ba8';
