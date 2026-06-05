import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/seasonal_settings.dart';

part 'seasonal_state.freezed.dart';

/// Состояние экрана 35 «Сезонные интервалы».
///
/// [settings] — текущее подтверждённое backend состояние (рисуем тумблер по
/// нему). [saving] — идёт оптимистичный PATCH тумблера. [saveError] — ошибка
/// последнего переключения (UI показывает снэкбар, тумблер откатывается на
/// [settings]).
///
/// Стратегия тумблера — оптимистичная с откатом: UI меняет вид сразу
/// (`enabled` в [settings] обновляется до запроса), при ошибке возвращаем
/// прежнее значение. Так переключатель отзывчив, но не врёт при фейле.
@freezed
abstract class SeasonalState with _$SeasonalState {
  const factory SeasonalState({
    required SeasonalSettings settings,
    @Default(false) bool saving,
    ApiError? saveError,
  }) = _SeasonalState;

  const SeasonalState._();
}
