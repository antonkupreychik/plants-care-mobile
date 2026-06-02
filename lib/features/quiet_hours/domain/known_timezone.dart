/// Справочник IANA-таймзоны для экрана выбора (37).
///
/// Чистый Dart value object: [ianaId] — то, что уходит в `PATCH /me`
/// ([UserSettings.timezone]); [city] — отображаемое имя (как в дизайне 37,
/// контент-строка, не l10n); [gmtLabel] — детерминированная метка смещения
/// (`GMT+3`).
///
/// GMT-метка считается из ЗАФИКСИРОВАННОГО базового смещения [_offsetMinutes],
/// а не из системного времени и не из пакета `timezone`. Это сознательно: все
/// курируемые зоны (Россия) с 2014 года НЕ переходят на летнее время, поэтому
/// базовое смещение постоянно круглый год и метка детерминирована без DST-
/// вычислений. Для зон с DST (которых в курируемом списке нет) такой подход
/// был бы неточен — тогда понадобился бы пакет `timezone` (вне объёма, СТОП).
class KnownTimezone {
  const KnownTimezone({
    required this.ianaId,
    required this.city,
    required this.offsetMinutes,
  });

  /// IANA-идентификатор (`Europe/Moscow`) — значение для записи в backend.
  final String ianaId;

  /// Отображаемое имя города/региона (`Москва`).
  final String city;

  /// Фиксированное смещение от UTC в минутах (без DST — см. док класса).
  /// Публично для тестов маппинга метки; UI обычно читает [gmtLabel].
  final int offsetMinutes;

  /// Детерминированная метка смещения для UI: `GMT+3`, `GMT-1`, `GMT+5:30`.
  /// Минуты показываются только если ненулевые (для будущих зон с :30/:45).
  String get gmtLabel {
    final sign = offsetMinutes < 0 ? '-' : '+';
    final abs = offsetMinutes.abs();
    final hours = abs ~/ 60;
    final minutes = abs % 60;
    final minutePart =
        minutes == 0 ? '' : ':${minutes.toString().padLeft(2, '0')}';
    return 'GMT$sign$hours$minutePart';
  }
}

/// Курируемый список таймзон для экрана 37 (issue #116 + дизайн
/// `screenshots/light/37-timezone.png`, раздел «Россия»).
///
/// Порядок — по возрастанию смещения, как в дизайне (Калининград → Владивосток),
/// но с Москвой первой (дефолт/основная зона). Список сознательно небольшой и
/// статичный; полный перечень IANA не тянем (UI — поиск по этим записям).
const List<KnownTimezone> kKnownTimezones = [
  KnownTimezone(
    ianaId: 'Europe/Moscow',
    city: 'Москва',
    offsetMinutes: 180, // GMT+3
  ),
  KnownTimezone(
    ianaId: 'Europe/Kaliningrad',
    city: 'Калининград',
    offsetMinutes: 120, // GMT+2
  ),
  KnownTimezone(
    ianaId: 'Europe/Samara',
    city: 'Самара',
    offsetMinutes: 240, // GMT+4
  ),
  KnownTimezone(
    ianaId: 'Asia/Yekaterinburg',
    city: 'Екатеринбург',
    offsetMinutes: 300, // GMT+5
  ),
  KnownTimezone(
    ianaId: 'Asia/Novosibirsk',
    city: 'Новосибирск',
    offsetMinutes: 420, // GMT+7
  ),
  KnownTimezone(
    ianaId: 'Asia/Vladivostok',
    city: 'Владивосток',
    offsetMinutes: 600, // GMT+10
  ),
];

/// Находит [KnownTimezone] по [ianaId] в курируемом списке, либо `null`, если
/// таймзона пользователя не из списка (UI покажет её как «прочую»/raw IANA).
KnownTimezone? knownTimezoneById(String ianaId) {
  for (final tz in kKnownTimezones) {
    if (tz.ianaId == ianaId) return tz;
  }
  return null;
}
