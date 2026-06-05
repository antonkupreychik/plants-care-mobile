/// Решение пользователя на экране прайминга пуш-уведомлений (экран 27).
///
/// Прайминг — это «мягкий» запрос перед системным диалогом разрешений: мы
/// объясняем ценность пушей и спрашиваем согласие. Реальный системный запрос
/// (`Notifications.requestPermissions`) и регистрация push-токена
/// (`POST /api/v1/devices`) подключаются позже — после решения по push-стеку
/// (Expo Push vs FCM/APNs, README §9 #3) и появления эндпоинта на бэкенде
/// (backend #187). Здесь фиксируется только намерение пользователя.
enum PushPrimingDecision {
  /// Прайминг ещё не показывали либо пользователь не сделал выбор.
  notDecided,

  /// Пользователь согласился получать уведомления.
  allowed,

  /// Пользователь отложил («Позже»/«Пропустить»).
  postponed;

  /// Код для персиста. Неизвестное значение → [notDecided].
  static PushPrimingDecision fromCode(String? code) {
    switch (code) {
      case 'allowed':
        return PushPrimingDecision.allowed;
      case 'postponed':
        return PushPrimingDecision.postponed;
      default:
        return PushPrimingDecision.notDecided;
    }
  }

  String get code => name;
}
