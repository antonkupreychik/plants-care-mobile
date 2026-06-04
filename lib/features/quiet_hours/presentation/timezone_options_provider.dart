import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/known_timezone.dart';

part 'timezone_options_provider.g.dart';

/// Курируемый список таймзон для экрана выбора (37).
///
/// Контракт для ui-builder:
/// - [timezoneOptionsProvider] → `List<KnownTimezone>` (статичный курируемый
///   список `kKnownTimezones`: ianaId, city, gmtLabel). Провайдер — точка для
///   подмены в тестах и будущего расширения (поиск/полный список).
///
/// Выбранная таймзона определяется СРАВНЕНИЕМ `option.ianaId` с
/// `quietHoursControllerProvider` → `state.draft.timezone`: UI помечает «✓» ту
/// запись, у которой `ianaId == draft.timezone`. По тапу UI зовёт
/// `quietHoursController.setTimezone(option.ianaId)`. Если текущая таймзона
/// пользователя НЕ из списка (`knownTimezoneById` вернёт `null`), UI показывает
/// её отдельной raw-строкой (помечена выбранной по той же `ianaId`-проверке).
@riverpod
List<KnownTimezone> timezoneOptions(Ref ref) => kKnownTimezones;
