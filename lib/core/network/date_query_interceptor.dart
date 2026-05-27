import 'package:dio/dio.dart';

import 'request_extra.dart';

/// Усекает помеченные query-параметры до date-only (`YYYY-MM-DD`).
///
/// ВОРКЭРАУНД бага кодгена: в спеке `from`/`to` объявлены как
/// `type: string, format: date`, но swagger_parser маппит `format: date` в Dart
/// `DateTime`, а Retrofit безусловно сериализует его через `toIso8601String()`
/// → `2026-05-20T00:00:00.000`. Backend на таком значении отдаёт HTTP 500
/// (ждёт `2026-05-20`). См. docs/BACKEND-GAPS.md.
///
/// Opt-in по образцу `authScopeExtra`: data source помечает нужные ключи через
/// [dateOnlyQueryExtra], интерсептор читает [kDateOnlyQueryKeysExtraKey] из
/// `options.extra` и усекает только перечисленные параметры. Снимается, когда
/// кодген/спека починят сериализацию даты — тогда хелпер и интерсептор удаляются.
class DateQueryInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final keys = options.extra[kDateOnlyQueryKeysExtraKey];
    if (keys is Iterable<String>) {
      for (final key in keys) {
        if (!options.queryParameters.containsKey(key)) continue;
        final value = options.queryParameters[key];
        final dateOnly = _toDateOnly(value);
        if (dateOnly != null) {
          options.queryParameters[key] = dateOnly;
        }
      }
    }
    handler.next(options);
  }

  /// Возвращает date-only строку или `null`, если значение трогать не нужно.
  String? _toDateOnly(Object? value) {
    // Клиент уже вызвал toIso8601String() → строка с разделителем 'T'.
    if (value is String) {
      final tIndex = value.indexOf('T');
      return tIndex == -1 ? null : value.substring(0, tIndex);
    }
    // На случай, если кодген когда-то начнёт класть сырой DateTime: берём
    // компоненты как есть (без UTC-сдвига и зависимости от локали).
    if (value is DateTime) {
      final month = value.month.toString().padLeft(2, '0');
      final day = value.day.toString().padLeft(2, '0');
      return '${value.year.toString().padLeft(4, '0')}-$month-$day';
    }
    return null;
  }
}
