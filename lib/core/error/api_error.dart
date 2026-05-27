import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
part 'api_error.g.dart';

/// Доменная ошибка (MADR-011). Единый sealed-тип, в который data-слой
/// заворачивает ошибки backend (`{error:{code,message,details}}`) и сети.
/// UI берёт локализованный текст по типу ошибки; [displayMessage] — fallback.
@freezed
sealed class ApiError with _$ApiError implements Exception {
  const ApiError._();

  /// 400 VALIDATION_ERROR — невалидное тело/параметры (по полям).
  const factory ApiError.validation({required List<FieldError> details}) =
      ValidationError;

  /// 400 BAD_REQUEST — прочие плохие запросы.
  const factory ApiError.badRequest({String? message}) = BadRequestError;

  /// 400 LOCATION_NOT_EMPTY — удаление непустой локации без targetLocationId.
  const factory ApiError.locationNotEmpty() = LocationNotEmptyError;

  /// 403 ACCESS_DENIED — ресурс принадлежит другому пользователю.
  const factory ApiError.accessDenied() = AccessDeniedError;

  /// 404 NOT_FOUND.
  const factory ApiError.notFound() = NotFoundError;

  /// 409 CONFLICT — напр. повторная отмена care-event.
  const factory ApiError.conflict() = ConflictError;

  /// Сетевая ошибка (таймаут, нет соединения).
  const factory ApiError.network() = NetworkError;

  /// 500 INTERNAL_ERROR / нераспознанное.
  const factory ApiError.unknown({String? message}) = UnknownError;

  /// Fallback-текст (логи / когда нет локализованного по типу).
  String get displayMessage => switch (this) {
        ValidationError() => 'Проверьте введённые данные',
        BadRequestError(:final message) => message ?? 'Некорректный запрос',
        LocationNotEmptyError() => 'Локация не пуста',
        AccessDeniedError() => 'Нет доступа',
        NotFoundError() => 'Не найдено',
        ConflictError() => 'Конфликт данных',
        NetworkError() => 'Нет соединения',
        UnknownError(:final message) => message ?? 'Неизвестная ошибка',
      };
}

/// Ошибка по конкретному полю из `details[]` VALIDATION_ERROR.
@freezed
abstract class FieldError with _$FieldError {
  const factory FieldError({
    required String field,
    required String message,
  }) = _FieldError;

  factory FieldError.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorFromJson(json);
}
