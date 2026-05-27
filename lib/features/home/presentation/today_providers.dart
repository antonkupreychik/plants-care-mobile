import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/clock/clock_provider.dart';
import 'home_providers.dart';
import 'today_filter.dart';
import 'today_view.dart';

part 'today_providers.g.dart';

/// State-слой экрана 03 «Сегодня» — производный от Home, БЕЗ своего data-слоя.
///
/// Watch'ит:
///  * `homeTasksProvider` (`GET /today`) — тот же источник, что у Home-карточки.
///    Поэтому после отметки ухода (sheet 06 инвалидирует `homeTasksProvider`)
///    список здесь обновляется сам;
///  * `clockProvider` — текущий момент, переведённый в local (как на Home);
///  * `selectedTodayFilterProvider` — активная пилюля.
///
/// Деривацию делает чистая [buildTodayView] (в `today_view.dart`, тестируется
/// отдельно без Riverpod) — провайдер лишь собирает входы и прокидывает их.
///
/// Контракт для ui-builder: `AsyncValue<TodayView>` (loading / error / data).
/// В `AsyncError` — типизированный `ApiError` (проброшен из `homeTasksProvider`),
/// UI маппит его в текст через `AppLocalizations`.
@riverpod
Future<TodayView> todayView(Ref ref) async {
  final tasks = await ref.watch(homeTasksProvider.future);
  final filter = ref.watch(selectedTodayFilterProvider);
  final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();

  return buildTodayView(tasks: tasks, nowLocal: nowLocal, filter: filter);
}
