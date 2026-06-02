import '../../../../core/api/generated/models/me_response.dart';
import '../../domain/quiet_time.dart';
import '../../domain/user_locale.dart';
import '../../domain/user_settings.dart';

/// Маппинг `MeResponse` → domain [UserSettings] (MADR-002/007). Делаем руками —
/// сгенерированный код не правим.
///
/// Берёт ТОЛЬКО подмножество `/me`, нужное экрану «Тихие часы и время»:
/// `quietHoursStart`/`quietHoursEnd` (строки `HH:mm` → [QuietTime]), `timezone`
/// (IANA-строка как есть), `locale` (enum → доменный [UserLocale]). Остальные
/// поля `MeResponse` (счётчики, сезонность, погода, *Linked) игнорируются.
///
/// Защита от мусора: если backend пришлёт нераспознанное `HH:mm`
/// ([QuietTime.parse] вернёт `null`), подставляем безопасный дефолт (`00:00`)
/// вместо краша — UI всё равно перезапишет значение через пикер.
extension MeResponseSettingsMapper on MeResponse {
  UserSettings toUserSettings() => UserSettings(
        quietHoursStart: QuietTime.parse(quietHoursStart) ??
            const QuietTime(hour: 0, minute: 0),
        quietHoursEnd:
            QuietTime.parse(quietHoursEnd) ?? const QuietTime(hour: 0, minute: 0),
        timezone: timezone,
        // `locale` — сгенерированный enum; берём backend-строку через `.json`.
        locale: UserLocale.fromApi(locale.json),
      );
}
