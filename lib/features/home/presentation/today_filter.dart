import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'today_filter.g.dart';

/// Фильтр-пилюли экрана 03 «Сегодня» (полный список задач `/today`).
///
/// Имена — под пилюли дизайна: Всё / Полив / Опрыскивание / Подкормка /
/// Просрочено. `soilCheck`/`unknown` своей пилюли НЕ имеют — попадают только
/// под [TodayFilter.all] (см. деривацию в `today_view.dart`).
enum TodayFilter {
  /// Все задачи (включая soilCheck/unknown).
  all,

  /// Только полив (`CareTaskType.watering`).
  watering,

  /// Только опрыскивание (`CareTaskType.misting`).
  misting,

  /// Только подкормка (`CareTaskType.fertilizing`).
  fertilizing,

  /// Только просроченные (любого типа): `dueAt.toLocal() < nowLocal`.
  overdue,
}

/// UI-состояние: выбранная пилюля-фильтр на экране 03. Дефолт — [TodayFilter.all].
///
/// Presentation-only (выбор чипа), не доменные данные. Через codegen —
/// **autoDispose**: при уходе с экрана фильтр сбрасывается на «Всё» (по образцу
/// [SelectedLocation] из `home_filter.dart`). Сама фильтрация делается чистой
/// функцией в `today_view.dart` над уже загруженным из `homeTasksProvider`
/// списком — без сети.
@riverpod
class SelectedTodayFilter extends _$SelectedTodayFilter {
  @override
  TodayFilter build() => TodayFilter.all;

  void select(TodayFilter filter) => state = filter;
}
