import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/care/care_task_type.dart';
import '../../../core/error/api_error.dart';
import '../domain/plant_care_schedule.dart';

part 'edit_schedule_state.freezed.dart';

/// Состояние редактируемого драфта расписаний (экран 22).
///
/// Стратегия: «draft + save dirty on Готово». Держим ДВА снимка —
/// [loaded] (последнее подтверждённое backend состояние) и [draft] (текущий
/// редактируемый). Пользователь правит [draft]; «грязные» (изменённые
/// относительно [loaded]) типы вычисляются на лету ([dirtyTypes]). По «Готово»
/// контроллер сохраняет PUT'ом только грязные расписания; по успеху
/// `loaded = draft`, грязь исчезает.
///
/// [loaded] и [draft] сопоставляются ПО ТИПУ ([CareTaskType]), а не по индексу
/// — порядок и состав списков могут расходиться (напр. backend вернул PUT в
/// другом порядке), это не должно ломать вычисление грязи.
@freezed
abstract class EditScheduleState with _$EditScheduleState {
  const factory EditScheduleState({
    /// Последнее подтверждённое backend состояние (база для dirty/отката).
    required List<PlantCareSchedule> loaded,

    /// Текущий редактируемый драфт (то, что показывает UI).
    required List<PlantCareSchedule> draft,

    /// Идёт ли сохранение (`save()` в полёте) — UI блокирует «Готово».
    @Default(false) bool saving,

    /// Ошибка последнего сохранения (общий статус частичной/полной неудачи).
    /// `null` — ошибки нет. Успешно сохранённые типы НЕ откатываются: см.
    /// `save()`.
    ApiError? saveError,
  }) = _EditScheduleState;

  const EditScheduleState._();

  /// Типы расписаний, изменённые в [draft] относительно [loaded].
  ///
  /// Сопоставление по типу (а не по индексу): для каждого типа из [draft]
  /// ищем одноимённый в [loaded] и сравниваем редактируемые поля
  /// ([PlantCareSchedule.sameEditableFields]). Тип грязный, если в [loaded] нет
  /// такого типа (новый/недозагруженный) ИЛИ поля отличаются. Не зависит от
  /// порядка/состава списков.
  Set<CareTaskType> get dirtyTypes {
    final dirty = <CareTaskType>{};
    for (final d in draft) {
      final base = loadedOf(d.type);
      if (base == null || !d.sameEditableFields(base)) {
        dirty.add(d.type);
      }
    }
    return dirty;
  }

  /// Есть ли несохранённые изменения (UI активирует «Готово»).
  bool get isDirty => dirtyTypes.isNotEmpty;

  /// Расписание драфта по типу, либо `null` (тип не загружен).
  PlantCareSchedule? draftOf(CareTaskType type) => _byType(draft, type);

  /// Подтверждённое backend расписание по типу, либо `null`.
  /// Симметрично [draftOf]; база для вычисления грязи по типу.
  PlantCareSchedule? loadedOf(CareTaskType type) => _byType(loaded, type);

  static PlantCareSchedule? _byType(
    List<PlantCareSchedule> list,
    CareTaskType type,
  ) {
    for (final s in list) {
      if (s.type == type) return s;
    }
    return null;
  }
}
