import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../error/result.dart';
import '../data/sdui_repository_provider.dart';
import '../domain/sdui_screen_layout.dart';
import 'home_room_filter.dart';

part 'screen_layout_provider.g.dart';

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
@riverpod
Future<SduiScreenLayout> homeScreenLayout(Ref ref) async {
  final locationId = ref.watch(homeRoomFilterProvider);
  final result = await ref
      .watch(sduiRepositoryProvider)
      .getHomeLayout(locationId: locationId);
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}
