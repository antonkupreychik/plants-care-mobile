import 'package:flutter/material.dart';

import '../../../../core/care/care_task_type.dart';
import '../../../../core/theme/tokens.dart';

/// Цвет-тинт кнопки-чека по типу ухода (экран 11 «График», спека §4).
///
/// Полить → primary, Опрыскать → terracotta, Подкормить → leafDark,
/// Осмотр(soilCheck)/unknown → leaf. Все токены из [PcColors] — работает и в
/// тёмной теме без правок.
extension CareActionTint on CareTaskType {
  Color tint(PcColors c) => switch (this) {
        CareTaskType.watering => c.primary,
        CareTaskType.misting => c.terracotta,
        CareTaskType.fertilizing => c.leafDark,
        CareTaskType.soilCheck => c.leaf,
        CareTaskType.unknown => c.leaf,
      };
}
