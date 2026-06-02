import 'package:freezed_annotation/freezed_annotation.dart';

import 'quiet_time.dart';
import 'user_locale.dart';

part 'user_settings.freezed.dart';

/// Доменная модель настроек «Тихие часы и время» (экран 23).
///
/// Источник — `GET /api/v1/me` (`MeResponse`); записываемое подмножество —
/// `PATCH /api/v1/me` (`MeUpdateRequest`). В объёме этой фичи редактируются
/// только три поля: [quietHoursStart], [quietHoursEnd] (пикер времени, экран 36)
/// и [timezone] (выбор IANA, экран 37). Остальные поля `/me` (счётчики хедера,
/// сезонность, погода, *Linked) в эту модель НЕ маппятся — не нужны экрану.
///
/// [locale] read-only: показывается на экране 23, но не редактируется здесь
/// (отдельный экран языка). Backend сам пересчитывает `next_run_at` расписаний
/// при смене таймзоны — клиент НИЧЕГО не пересчитывает (FLUTTER.md «Время»).
///
/// Тумблеры дизайна 23, которых нет в `/me` («Не беспокоить ночью», «Утренний
/// дайджест 9:00», «Перенести просроченное на утро»), здесь НЕ представлены как
/// записываемые — это backend-gap (см. отчёт/docs/BACKEND-GAPS.md). Модель их
/// просто не несёт; добавление полей backend в `/me` не сломает существующее.
///
/// Чистый Dart, иммутабельна.
@freezed
abstract class UserSettings with _$UserSettings {
  const factory UserSettings({
    /// Начало тихих часов (локальное время, экран 36).
    required QuietTime quietHoursStart,

    /// Конец тихих часов (локальное время, экран 36).
    required QuietTime quietHoursEnd,

    /// IANA-идентификатор таймзоны пользователя (`Europe/Moscow`). Backend
    /// валидирует при записи: невалидный → `400`.
    required String timezone,

    /// Язык интерфейса (read-only в этой фиче).
    required UserLocale locale,
  }) = _UserSettings;

  const UserSettings._();
}
