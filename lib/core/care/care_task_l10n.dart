import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import 'care_task.dart';
import 'care_task_type.dart';

/// UI-обвязка для [CareTask]: локализованные подписи действия и срока.
///
/// Без бизнес-логики: только перевод enum в строку и форматирование уже
/// посчитанного backend-времени [CareTask.dueAt] (UTC → локаль). Группировку
/// «утро/вечер» здесь НЕ делаем (это экран 03 Today).
///
/// Общая UI-обвязка двух фич (home/schedule) → живёт в `core/care/`.
extension CareTaskTypeL10n on CareTaskType {
  String label(AppLocalizations l10n) => switch (this) {
        CareTaskType.watering => l10n.careActionWatering,
        CareTaskType.misting => l10n.careActionMisting,
        CareTaskType.fertilizing => l10n.careActionFertilizing,
        CareTaskType.soilCheck => l10n.careActionSoilCheck,
        CareTaskType.unknown => l10n.careActionUnknown,
      };

  IconData get icon => switch (this) {
        CareTaskType.watering => Icons.water_drop_outlined,
        CareTaskType.misting => Icons.shower_outlined,
        CareTaskType.fertilizing => Icons.eco_outlined,
        CareTaskType.soilCheck => Icons.grass_outlined,
        CareTaskType.unknown => Icons.spa_outlined,
      };
}

extension CareTaskL10n on CareTask {
  /// Подпись срока: просрочено / сегодня в HH:mm / просто сегодня.
  ///
  /// Время приходит с backend в UTC уже посчитанным — клиент лишь переводит
  /// в локаль (`.toLocal()`) и форматирует, интервалы НЕ пересчитывает.
  String dueLabel(AppLocalizations l10n, DateTime now) {
    final local = dueAt.toLocal();
    if (local.isBefore(now)) return l10n.careDueOverdue;
    final time = DateFormat.Hm(l10n.localeName).format(local);
    return l10n.careDueAt(time);
  }
}
