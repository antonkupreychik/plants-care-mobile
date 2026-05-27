import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/schedule_repository_provider.dart';
import '../domain/schedule_week.dart';

part 'schedule_providers.g.dart';

/// State-слой экрана «График» (11).
///
/// Провайдер-семейство по `weekStart`: каждая неделя грузится и кешируется
/// независимо, поэтому листание назад/вперёд переиспользует уже загруженные
/// недели, а `ref.invalidate(scheduleWeekProvider(weekStart))` обновляет только
/// одну неделю (например, после `POST /care-events`). Текущий `weekStart`
/// поставляет `scheduleWeekStartProvider`.
///
/// Контракт для ui-builder: `ref.watch(scheduleWeekProvider(weekStart))`
/// → `AsyncValue<ScheduleWeek>` (loading / error / data). В `AsyncError` лежит
/// типизированный [ApiError] (см. [_unwrap]) — UI маппит его в текст через
/// `AppLocalizations`.
///
/// `keepAlive: false` (дефолт): неделя без активных слушателей выгружается из
/// кеша, чтобы не держать весь горизонт листания в памяти.
@riverpod
Future<ScheduleWeek> scheduleWeek(Ref ref, DateTime weekStart) async {
  final result =
      await ref.watch(scheduleRepositoryProvider).getWeek(weekStart: weekStart);
  return _unwrap(result);
}

/// Разворачивает `Result<T>`: успех → значение, ошибка → бросок [ApiError],
/// который Riverpod упакует в `AsyncError` (типизированный, не строка).
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      Failure<T>(:final error) => throw error,
    };
