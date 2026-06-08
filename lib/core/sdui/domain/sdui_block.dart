import 'package:freezed_annotation/freezed_annotation.dart';

import '../../care/care_task.dart';
import '../../locations/garden_location.dart';
import '../../../features/weather/domain/watering_recommendation.dart';
import 'sdui_action.dart';

part 'sdui_block.freezed.dart';

/// Доменный SDUI-блок главного экрана (`Block` → domain, MADR-015).
///
/// Чистый Dart, sealed. Каждый вариант несёт ровно те данные, что нужны
/// нативному виджету-обёртке (`BlockRegistry`) для рендера существующего
/// виджета home. Дискриминатор `type` из DTO в domain не пробрасываем — его
/// роль играет сам подтип sealed-класса.
///
/// [SduiUnknownBlock] — нераспознанный/новый `type`, который клиент этой версии
/// каталога ([kUiCatalogVersion]) рендерить не умеет. Маппер кладёт его сюда
/// (или вовсе пропускает на уровне репозитория), рендерер — ничего не рисует
/// (graceful degradation, forward-compatibility).
@freezed
sealed class SduiBlock with _$SduiBlock {
  /// Строка погоды (`weather_strip`): влажность + рекомендация по поливу.
  /// При [available] = false поля пусты — виджет тихо сворачивается.
  const factory SduiBlock.weatherStrip({
    required bool available,
    int? humidityPercent,
    WateringRecommendation? recommendation,
  }) = SduiWeatherStripBlock;

  /// Сводка задач на сегодня (`today_summary`).
  const factory SduiBlock.todaySummary({
    required int total,
    required int done,
    required int remaining,
    required int overdue,
  }) = SduiTodaySummaryBlock;

  /// Тапабельный список задач «Сегодня» (`today_tasks`).
  ///
  /// Несёт реальные задачи ([CareTask]) — в отличие от [SduiTodaySummaryBlock]
  /// (только счётчики). Рендерер ([BlockRegistry]) рисует `TodayCard` со списком
  /// и навешивает тап → нативный care-sheet с `presetType`, выведенным из
  /// [CareTask.type] (тот же интерактив, что был на home до перехода на SDUI).
  const factory SduiBlock.todayTasks({
    required int completedCount,
    required int totalCount,
    required List<CareTask> tasks,
  }) = SduiTodayTasksBlock;

  /// Чипы локаций (`location_chips`).
  const factory SduiBlock.locationChips({
    required List<GardenLocation> locations,
  }) = SduiLocationChipsBlock;

  /// Сетка растений (`plant_grid`) с привязанным действием ухода.
  const factory SduiBlock.plantGrid({
    required List<SduiPlantGridItem> plants,
  }) = SduiPlantGridBlock;

  /// Гостевой баннер (`guest_banner`): приглашение привязать email.
  /// Раньше был нативным (`GuestBanner`) — теперь его видимость и место в
  /// лейауте решает сервер (MADR-017). [titleKey]/[bodyKey] — l10n-КЛЮЧИ
  /// (резолвятся на клиенте), не готовый текст. CTA → [ctaAction].
  const factory SduiBlock.guestBanner({
    required String titleKey,
    required String bodyKey,
    SduiAction? ctaAction,
  }) = SduiGuestBannerBlock;

  /// Пустое состояние сада (`empty_state`): заменяет `plant_grid`, когда у
  /// пользователя нет растений (решает сервер, MADR-017). [iconKey]/[titleKey]/
  /// [bodyKey] — l10n-КЛЮЧИ. CTA → [ctaAction].
  const factory SduiBlock.emptyState({
    required String iconKey,
    required String titleKey,
    required String bodyKey,
    SduiAction? ctaAction,
  }) = SduiEmptyStateBlock;

  /// Нераспознанный тип блока — клиент его не рендерит.
  const factory SduiBlock.unknown() = SduiUnknownBlock;
}

/// Элемент сетки растений в блоке `plant_grid` (`PlantGridItem` → domain).
///
/// Несёт минимум для карточки (`PlantCard`) + два опциональных действия:
/// [action] — тап по ТЕЛУ карточки (`navigate` на карточку растения), и
/// [waterAction] — кнопка-иконка «полить» (`log_care`), которое `ActionRunner`
/// исполнит через care-event флоу (MADR-017).
@freezed
abstract class SduiPlantGridItem with _$SduiPlantGridItem {
  const factory SduiPlantGridItem({
    required int id,
    required String name,
    String? locationName,
    SduiAction? action,
    SduiAction? waterAction,
  }) = _SduiPlantGridItem;
}
