import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_filter.g.dart';

/// UI-состояние: выбранная локация-фильтр на Главной. `null` = «Все».
///
/// Presentation-only (выбор чипа), не доменные данные. Через codegen —
/// **autoDispose**: при уходе с Главной фильтр сбрасывается (не залипает на
/// исчезнувшей после рефреша комнате). Фильтрация списка растений по этому id
/// делается в UI из уже загруженного списка (`plant.locationId`), без сети.
@riverpod
class SelectedLocation extends _$SelectedLocation {
  @override
  int? build() => null;

  void select(int? locationId) => state = locationId;
}
