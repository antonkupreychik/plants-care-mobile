/// Продуктовое событие аналитики (issue #126).
///
/// Все ключевые события приложения — sealed-класс, чтобы список событий был
/// выражен на уровне типов. Добавление нового события = новый вариант, а не
/// строка. Никаких PII в полях: userId — анонимный хэш, имена растений — НЕ
/// логируются (personalInfo).
sealed class AnalyticsEvent {
  const AnalyticsEvent();

  /// Название события для транспорта (Sentry breadcrumb category).
  String get name;

  /// Произвольные параметры события (без PII).
  Map<String, dynamic> get params;
}

// ---------------------------------------------------------------------------
// Lifecycle
// ---------------------------------------------------------------------------

/// Приложение запущено (первый кадр после bootstrap).
final class AppStarted extends AnalyticsEvent {
  const AppStarted({required this.flavor});

  final String flavor; // 'dev' | 'prod'

  @override
  String get name => 'app_started';

  @override
  Map<String, dynamic> get params => {'flavor': flavor};
}

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

/// Пользователь успешно вошёл (любой метод).
final class UserLoggedIn extends AnalyticsEvent {
  const UserLoggedIn({required this.method});

  /// Метод: 'magic_link' | 'google' | 'apple' | 'guest'.
  final String method;

  @override
  String get name => 'user_logged_in';

  @override
  Map<String, dynamic> get params => {'method': method};
}

/// Пользователь вышел из аккаунта.
final class UserLoggedOut extends AnalyticsEvent {
  const UserLoggedOut();

  @override
  String get name => 'user_logged_out';

  @override
  Map<String, dynamic> get params => const {};
}

// ---------------------------------------------------------------------------
// Plants
// ---------------------------------------------------------------------------

/// Растение добавлено (мастер add_plant завершён).
final class PlantAdded extends AnalyticsEvent {
  const PlantAdded({required this.speciesId});

  /// ID вида (не имя, без PII).
  final String? speciesId;

  @override
  String get name => 'plant_added';

  @override
  Map<String, dynamic> get params => {
        if (speciesId != null) 'species_id': speciesId,
      };
}

// ---------------------------------------------------------------------------
// Care events
// ---------------------------------------------------------------------------

/// Уход за растением отмечен (полив / опрыскивание / удобрение).
final class CareEventRecorded extends AnalyticsEvent {
  const CareEventRecorded({required this.careType});

  /// Тип ухода: 'WATER' | 'SPRAY' | 'FERTILIZE' | … (из domain CareTaskType).
  final String careType;

  @override
  String get name => 'care_event_recorded';

  @override
  Map<String, dynamic> get params => {'care_type': careType};
}
