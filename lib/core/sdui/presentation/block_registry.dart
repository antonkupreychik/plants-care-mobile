import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/care_event/data/mappers/task_type_mapper.dart';
import '../../../features/care_event/presentation/log_care_event_sheet.dart';
import '../../../features/home/domain/plant.dart';
import '../../../features/home/presentation/widgets/location_chips.dart';
import '../../../features/home/presentation/widgets/plant_card.dart';
import '../../../features/home/presentation/widgets/today_card.dart';
import '../../../features/weather/presentation/widgets/weather_strip.dart';
import '../../../l10n/app_localizations.dart';
import '../../care/care_task.dart';
import '../../clock/clock_provider.dart';
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
      SduiTodayTasksBlock(:final tasks, :final completedCount, :final totalCount) =>
        _TodayTasks(
          tasks: tasks,
          completedCount: completedCount,
          totalCount: totalCount,
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

/// Тапабельный список задач «Сегодня» из SDUI-блока `today_tasks`.
///
/// Переиспользует нативный [TodayCard] и нативный care-sheet-флоу: тап по
/// задаче открывает существующий [showLogCareEventSheet] с `presetType`,
/// выведенным из [CareTask.type] тем же маппером [careEventKindFromTaskType],
/// что использовал home до перехода на SDUI. Это интерактив — он нативный, НЕ
/// через [ActionRunner]. `now` берём из [clockProvider] (тестируемость, MADR
/// «Время»).
class _TodayTasks extends ConsumerWidget {
  const _TodayTasks({
    required this.tasks,
    required this.completedCount,
    required this.totalCount,
  });

  final List<CareTask> tasks;
  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: TodayCard(
        tasks: tasks,
        now: nowLocal,
        // Тап по задаче → нативный sheet ухода с предвыбранным типом
        // (FERTILIZING → fertilize и т.д.). SOIL_CHECK/unknown дают unknown —
        // контроллер sheet откатит на дефолтный тип.
        onTaskTap: (task) => showLogCareEventSheet(
          context,
          plantId: task.plantId,
          presetType: careEventKindFromTaskType(task.type),
          plantName: task.plantName,
        ),
        completedCount: completedCount,
        totalCount: totalCount,
      ),
    );
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
