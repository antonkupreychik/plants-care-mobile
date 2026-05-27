import '../../l10n/app_localizations.dart';
import 'api_error.dart';

/// Маппинг доменной [ApiError] в локализованный текст для UI (MADR-011/012).
///
/// Берём текст по ТИПУ ошибки через [AppLocalizations], НЕ через
/// `error.toString()` / `displayMessage` (последний — лишь fallback для логов).
/// Если в `AsyncError` лежит не [ApiError] (непредвиденно) — общий текст.
extension ApiErrorL10n on AppLocalizations {
  String messageForError(Object? error) {
    if (error is! ApiError) return errorGeneric;
    return switch (error) {
      NetworkError() => errorNetwork,
      NotFoundError() => errorNotFound,
      AccessDeniedError() => errorAccessDenied,
      ValidationError() => errorValidation,
      ConflictError() => errorConflict,
      LocationNotEmptyError() => errorGeneric,
      BadRequestError() => errorGeneric,
      UnknownError() => errorGeneric,
    };
  }
}
