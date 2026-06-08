import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_room_filter.g.dart';

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
@riverpod
class HomeRoomFilter extends _$HomeRoomFilter {
  @override
  int? build() => null;

  /// Установить запрошенную комнату (`null` = «Все»). No-op, если значение не
  /// изменилось — лишний перезапрос лейаута не нужен.
  void select(int? locationId) {
    if (state == locationId) return;
    state = locationId;
  }
}
