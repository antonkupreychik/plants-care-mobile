import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/home/domain/plant.dart';
import '../../../features/home/presentation/widgets/location_chips.dart';
import '../../../features/home/presentation/widgets/plant_card.dart';
import '../../../features/home/presentation/widgets/today_card.dart';
import '../../../features/weather/presentation/widgets/weather_strip.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/sdui_action.dart';
import '../domain/sdui_block.dart';
import 'action_runner.dart';

/// Реестр SDUI-рендереров (MADR-015): отображение типа доменного блока
/// ([SduiBlock]) в нативный виджет, который рисует СУЩЕСТВУЮЩИЕ виджеты home
/// (`WeatherStripContent`, `TodayCard`, `LocationChips`, `PlantCard`) из данных
/// блока. Новые виджеты не пишем — переиспользуем (FLUTTER.md «Правила виджетов»).
///
/// Диспетчеризация — pattern matching по подтипу sealed-класса (компилятор
/// проверяет полноту). Нераспознанный блок ([SduiUnknownBlock]) сюда не доходит
/// (репозиторий его отфильтровал), но на всякий случай рендерится в
/// [SizedBox.shrink] — graceful degradation, ничего не рисуется.
class BlockRegistry {
  const BlockRegistry._();

  /// Отрисовывает один доменный блок. `key` стабилизирует элемент в списке
  /// (порядок блоков задаёт сервер).
  static Widget build(BuildContext context, WidgetRef ref, SduiBlock block) {
    return switch (block) {
      SduiWeatherStripBlock(:final available, :final humidityPercent, :final recommendation) =>
        (available && humidityPercent != null)
            ? WeatherStripContent(
                humidityPercent: humidityPercent,
                recommendation: recommendation,
              )
            // Погода недоступна → тихо сворачиваем (как нативный WeatherStrip).
            : const SizedBox.shrink(),
      SduiTodaySummaryBlock(:final total, :final done) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          // Переиспользуем TodayCard как карточку-сводку: списка задач в блоке
          // нет (его несут нативные секции), показываем счётчики прогресса.
          child: TodayCard(
            tasks: const [],
            now: DateTime.now(),
            onTaskTap: (_) {},
            completedCount: done,
            totalCount: total,
          ),
        ),
      SduiLocationChipsBlock(:final locations) => Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 14),
          child: LocationChips(
            locations: locations,
            // Счётчики растений несёт нативная композиция, не SDUI-блок чипов.
            plantCountByLocation: const {},
            totalPlants: 0,
            selectedLocationId: null,
            onSelected: (_) {},
          ),
        ),
      SduiPlantGridBlock(:final plants) => _PlantGrid(items: plants),
      SduiUnknownBlock() => const SizedBox.shrink(),
    };
  }
}

/// Сетка растений из SDUI-блока `plant_grid`. Переиспользует [PlantCard];
/// действие «полить» (`ActionDescriptor`) исполняется через [ActionRunner].
class _PlantGrid extends ConsumerWidget {
  const _PlantGrid({required this.items});

  final List<SduiPlantGridItem> items;

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 0.72,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _gridDelegate,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return PlantCard(
            // PlantCard ждёт domain Plant — собираем из элемента блока.
            plant: Plant(
              id: item.id,
              name: item.name,
              locationName: item.locationName,
            ),
            tintWarm: index.isEven,
            // Тап по карточке = выполнить привязанное действие (полить).
            // Нет действия → no-op (витрина без интерактива).
            onTap: () => _runAction(context, ref, item.action),
          );
        },
      ),
    );
  }

  Future<void> _runAction(
    BuildContext context,
    WidgetRef ref,
    SduiAction? action,
  ) async {
    if (action == null) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final result = await ref.read(actionRunnerProvider).run(action);
    // unsupported (неизвестный kind) — тихо игнорируем, не шумим тостом.
    final message = switch (result) {
      SduiActionResult.success => l10n.careDoneUnknown,
      SduiActionResult.failure => l10n.errorGeneric,
      SduiActionResult.unsupported => null,
    };
    if (message == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
