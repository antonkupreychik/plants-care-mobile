import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_summary.freezed.dart';

/// Доменная модель шапки и статистики экрана «Я» (экран 13).
///
/// Источник — `GET /api/v1/me` (`MeResponse`). В отличие от
/// `UserSettings` (тихие часы/таймзона/язык, экран 23), эта модель несёт
/// «представительские» поля профиля: имя, email, аватар, дату регистрации и
/// счётчики.
///
/// [totalCareEvents] = «уходов за всё время». Поле ещё НЕ отдаётся бэкендом
/// (ждёт plants-care#226), поэтому здесь оно `null` — UI тихо скрывает блок
/// «Уходов» (graceful degradation, не заглушка с нулём). Когда backend начнёт
/// отдавать поле — маппер заполнит его, и блок появится без правок UI.
///
/// Чистый Dart, иммутабельна.
@freezed
abstract class ProfileSummary with _$ProfileSummary {
  const factory ProfileSummary({
    /// Отображаемое имя пользователя. `null` → UI показывает
    /// «Пользователь» (анонимный).
    String? name,

    /// Email пользователя. `null` для чисто Telegram-юзеров — UI не показывает
    /// строку email.
    String? email,

    /// URL аватара. `null` → initials-плейсхолдер. На текущей схеме backend
    /// всегда отдаёт `null` (нет хранилища аватаров).
    String? avatar,

    /// Момент регистрации (UTC). Шапка форматирует как «С нами с {MMM yyyy}».
    required DateTime createdAt,

    /// Число неархивированных растений пользователя.
    required int plantsTotal,

    /// Число уходов за всё время. `null` пока backend не отдаёт поле
    /// (plants-care#226) — блок «Уходов» скрыт.
    int? totalCareEvents,
  }) = _ProfileSummary;

  const ProfileSummary._();

  /// Первая буква имени для initials-плейсхолдера аватара; «?» если имени нет.
  String get initial {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1).toUpperCase();
  }
}
