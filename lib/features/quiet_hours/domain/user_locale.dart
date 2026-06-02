/// Язык интерфейса/уведомлений пользователя (read-only для фичи «Тихие часы»).
///
/// Доменный enum поверх сгенерированного `MeResponseLocale` — экран 23 может
/// показать текущий язык; запись локали в объём этой фичи не входит (отдельный
/// экран настроек). Маппинг строки делает маппер data-слоя (MADR-002).
enum UserLocale {
  ru,
  en,

  /// Нераспознанный backend-код (forward-compatible).
  unknown;

  /// Нормализует строку backend (`ru`/`en`) в доменный [UserLocale].
  /// Неизвестное значение → [UserLocale.unknown] (UI покажет fallback).
  static UserLocale fromApi(String? raw) => switch (raw) {
        'ru' => UserLocale.ru,
        'en' => UserLocale.en,
        _ => UserLocale.unknown,
      };
}
