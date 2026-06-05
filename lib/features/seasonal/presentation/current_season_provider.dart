import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/clock/clock_provider.dart';
import '../domain/season.dart';

part 'current_season_provider.g.dart';

/// Текущий сезон для подсветки на экране 35.
///
/// Считается по месяцу из инжектируемого [Clock] (FLUTTER.md «Время»: не зовём
/// `DateTime.now()` напрямую — детерминируемо в тестах через
/// `clockProvider.overrideWithValue(FakeClock(...))`).
///
/// Это ТОЛЬКО презентационная классификация «какой сейчас сезон» для подсветки
/// карточки/столбца — НЕ расчёт интервалов ухода. Интервалы считает backend
/// (`CareScheduleDto.seasonal`); клиент их не пересчитывает. Месяц берём из
/// UTC-времени (грубой привязки месяца к сезону достаточно — это не про
/// границы суток в таймзоне).
@riverpod
Season currentSeason(Ref ref) {
  final clock = ref.watch(clockProvider);
  return Season.ofMonth(clock.nowUtc().month);
}
