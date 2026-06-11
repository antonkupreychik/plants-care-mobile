// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telegram_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TelegramAuthState {

 TelegramAuthPhase get phase;/// Идентификатор сессии входа из `telegram/start` (`null` до старта).
 String? get sessionId;/// Deep link бота из `telegram/start` (`null` до старта). Хранится, чтобы по
/// кнопке «Открыть Telegram» можно было повторить открытие без ре-старта
/// сессии (deep link приходит с backend — клиент его не конструирует).
 String? get deepLink;/// Длина ожидаемого кода (из `codeLength`).
 int get codeLength;/// Введённые цифры, 0..[codeLength], только '0'..'9'.
 String get code;/// Секунд до возможности повторно запросить код. 0 → можно ресендить.
 int get resendSeconds;/// Идёт `POST /auth/telegram/verify` (UI блокирует ввод/клавиатуру).
 bool get verifying;/// Доменная ошибка ввода кода (инлайн на экране), `null` — нет.
 TelegramCodeError? get codeError;/// Ошибка старта (фаза [TelegramAuthPhase.startFailed]) — для текста ретрая.
 ApiError? get startError;/// Старт прошёл (сессия есть, фаза `entering`), но открыть Telegram по deep
/// link не удалось (`LinkLauncher.open` вернул `false`: нет приложения /
/// система не пустила). UI показывает заметный блок «не удалось открыть
/// Telegram» с кнопкой повтора открытия — вместо молчаливого экрана ввода.
/// Сбрасывается при повторной попытке открытия и при старте новой сессии.
 bool get launchFailed;/// `telegram_user_not_found` (404) — к Telegram-аккаунту не привязан юзер.
/// Экран по этому флагу уводит на Welcome с поясняющим текстом про бота
/// (`ref.listen` на переход в `true`). Регистрации/создания юзера в этом
/// флоу нет — это вход существующих.
 bool get userNotFound;/// Код подтверждён, сессия поднята. Экран по переходу флага в `true` уводит
/// на экран 09 «С возвращением» (`/auth/welcome-back`) — guard-исключение,
/// иначе авторизованного увело бы сразу на `/home`.
 bool get succeeded;
/// Create a copy of TelegramAuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelegramAuthStateCopyWith<TelegramAuthState> get copyWith => _$TelegramAuthStateCopyWithImpl<TelegramAuthState>(this as TelegramAuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelegramAuthState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.codeLength, codeLength) || other.codeLength == codeLength)&&(identical(other.code, code) || other.code == code)&&(identical(other.resendSeconds, resendSeconds) || other.resendSeconds == resendSeconds)&&(identical(other.verifying, verifying) || other.verifying == verifying)&&(identical(other.codeError, codeError) || other.codeError == codeError)&&(identical(other.startError, startError) || other.startError == startError)&&(identical(other.launchFailed, launchFailed) || other.launchFailed == launchFailed)&&(identical(other.userNotFound, userNotFound) || other.userNotFound == userNotFound)&&(identical(other.succeeded, succeeded) || other.succeeded == succeeded));
}


@override
int get hashCode => Object.hash(runtimeType,phase,sessionId,deepLink,codeLength,code,resendSeconds,verifying,codeError,startError,launchFailed,userNotFound,succeeded);

@override
String toString() {
  return 'TelegramAuthState(phase: $phase, sessionId: $sessionId, deepLink: $deepLink, codeLength: $codeLength, code: $code, resendSeconds: $resendSeconds, verifying: $verifying, codeError: $codeError, startError: $startError, launchFailed: $launchFailed, userNotFound: $userNotFound, succeeded: $succeeded)';
}


}

/// @nodoc
abstract mixin class $TelegramAuthStateCopyWith<$Res>  {
  factory $TelegramAuthStateCopyWith(TelegramAuthState value, $Res Function(TelegramAuthState) _then) = _$TelegramAuthStateCopyWithImpl;
@useResult
$Res call({
 TelegramAuthPhase phase, String? sessionId, String? deepLink, int codeLength, String code, int resendSeconds, bool verifying, TelegramCodeError? codeError, ApiError? startError, bool launchFailed, bool userNotFound, bool succeeded
});


$ApiErrorCopyWith<$Res>? get startError;

}
/// @nodoc
class _$TelegramAuthStateCopyWithImpl<$Res>
    implements $TelegramAuthStateCopyWith<$Res> {
  _$TelegramAuthStateCopyWithImpl(this._self, this._then);

  final TelegramAuthState _self;
  final $Res Function(TelegramAuthState) _then;

/// Create a copy of TelegramAuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? sessionId = freezed,Object? deepLink = freezed,Object? codeLength = null,Object? code = null,Object? resendSeconds = null,Object? verifying = null,Object? codeError = freezed,Object? startError = freezed,Object? launchFailed = null,Object? userNotFound = null,Object? succeeded = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TelegramAuthPhase,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,codeLength: null == codeLength ? _self.codeLength : codeLength // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,resendSeconds: null == resendSeconds ? _self.resendSeconds : resendSeconds // ignore: cast_nullable_to_non_nullable
as int,verifying: null == verifying ? _self.verifying : verifying // ignore: cast_nullable_to_non_nullable
as bool,codeError: freezed == codeError ? _self.codeError : codeError // ignore: cast_nullable_to_non_nullable
as TelegramCodeError?,startError: freezed == startError ? _self.startError : startError // ignore: cast_nullable_to_non_nullable
as ApiError?,launchFailed: null == launchFailed ? _self.launchFailed : launchFailed // ignore: cast_nullable_to_non_nullable
as bool,userNotFound: null == userNotFound ? _self.userNotFound : userNotFound // ignore: cast_nullable_to_non_nullable
as bool,succeeded: null == succeeded ? _self.succeeded : succeeded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TelegramAuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get startError {
    if (_self.startError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.startError!, (value) {
    return _then(_self.copyWith(startError: value));
  });
}
}


/// Adds pattern-matching-related methods to [TelegramAuthState].
extension TelegramAuthStatePatterns on TelegramAuthState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelegramAuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelegramAuthState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelegramAuthState value)  $default,){
final _that = this;
switch (_that) {
case _TelegramAuthState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelegramAuthState value)?  $default,){
final _that = this;
switch (_that) {
case _TelegramAuthState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TelegramAuthPhase phase,  String? sessionId,  String? deepLink,  int codeLength,  String code,  int resendSeconds,  bool verifying,  TelegramCodeError? codeError,  ApiError? startError,  bool launchFailed,  bool userNotFound,  bool succeeded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelegramAuthState() when $default != null:
return $default(_that.phase,_that.sessionId,_that.deepLink,_that.codeLength,_that.code,_that.resendSeconds,_that.verifying,_that.codeError,_that.startError,_that.launchFailed,_that.userNotFound,_that.succeeded);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TelegramAuthPhase phase,  String? sessionId,  String? deepLink,  int codeLength,  String code,  int resendSeconds,  bool verifying,  TelegramCodeError? codeError,  ApiError? startError,  bool launchFailed,  bool userNotFound,  bool succeeded)  $default,) {final _that = this;
switch (_that) {
case _TelegramAuthState():
return $default(_that.phase,_that.sessionId,_that.deepLink,_that.codeLength,_that.code,_that.resendSeconds,_that.verifying,_that.codeError,_that.startError,_that.launchFailed,_that.userNotFound,_that.succeeded);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TelegramAuthPhase phase,  String? sessionId,  String? deepLink,  int codeLength,  String code,  int resendSeconds,  bool verifying,  TelegramCodeError? codeError,  ApiError? startError,  bool launchFailed,  bool userNotFound,  bool succeeded)?  $default,) {final _that = this;
switch (_that) {
case _TelegramAuthState() when $default != null:
return $default(_that.phase,_that.sessionId,_that.deepLink,_that.codeLength,_that.code,_that.resendSeconds,_that.verifying,_that.codeError,_that.startError,_that.launchFailed,_that.userNotFound,_that.succeeded);case _:
  return null;

}
}

}

/// @nodoc


class _TelegramAuthState extends TelegramAuthState {
  const _TelegramAuthState({this.phase = TelegramAuthPhase.starting, this.sessionId, this.deepLink, this.codeLength = kTelegramCodeLength, this.code = '', this.resendSeconds = 0, this.verifying = false, this.codeError, this.startError, this.launchFailed = false, this.userNotFound = false, this.succeeded = false}): super._();
  

@override@JsonKey() final  TelegramAuthPhase phase;
/// Идентификатор сессии входа из `telegram/start` (`null` до старта).
@override final  String? sessionId;
/// Deep link бота из `telegram/start` (`null` до старта). Хранится, чтобы по
/// кнопке «Открыть Telegram» можно было повторить открытие без ре-старта
/// сессии (deep link приходит с backend — клиент его не конструирует).
@override final  String? deepLink;
/// Длина ожидаемого кода (из `codeLength`).
@override@JsonKey() final  int codeLength;
/// Введённые цифры, 0..[codeLength], только '0'..'9'.
@override@JsonKey() final  String code;
/// Секунд до возможности повторно запросить код. 0 → можно ресендить.
@override@JsonKey() final  int resendSeconds;
/// Идёт `POST /auth/telegram/verify` (UI блокирует ввод/клавиатуру).
@override@JsonKey() final  bool verifying;
/// Доменная ошибка ввода кода (инлайн на экране), `null` — нет.
@override final  TelegramCodeError? codeError;
/// Ошибка старта (фаза [TelegramAuthPhase.startFailed]) — для текста ретрая.
@override final  ApiError? startError;
/// Старт прошёл (сессия есть, фаза `entering`), но открыть Telegram по deep
/// link не удалось (`LinkLauncher.open` вернул `false`: нет приложения /
/// система не пустила). UI показывает заметный блок «не удалось открыть
/// Telegram» с кнопкой повтора открытия — вместо молчаливого экрана ввода.
/// Сбрасывается при повторной попытке открытия и при старте новой сессии.
@override@JsonKey() final  bool launchFailed;
/// `telegram_user_not_found` (404) — к Telegram-аккаунту не привязан юзер.
/// Экран по этому флагу уводит на Welcome с поясняющим текстом про бота
/// (`ref.listen` на переход в `true`). Регистрации/создания юзера в этом
/// флоу нет — это вход существующих.
@override@JsonKey() final  bool userNotFound;
/// Код подтверждён, сессия поднята. Экран по переходу флага в `true` уводит
/// на экран 09 «С возвращением» (`/auth/welcome-back`) — guard-исключение,
/// иначе авторизованного увело бы сразу на `/home`.
@override@JsonKey() final  bool succeeded;

/// Create a copy of TelegramAuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelegramAuthStateCopyWith<_TelegramAuthState> get copyWith => __$TelegramAuthStateCopyWithImpl<_TelegramAuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TelegramAuthState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.codeLength, codeLength) || other.codeLength == codeLength)&&(identical(other.code, code) || other.code == code)&&(identical(other.resendSeconds, resendSeconds) || other.resendSeconds == resendSeconds)&&(identical(other.verifying, verifying) || other.verifying == verifying)&&(identical(other.codeError, codeError) || other.codeError == codeError)&&(identical(other.startError, startError) || other.startError == startError)&&(identical(other.launchFailed, launchFailed) || other.launchFailed == launchFailed)&&(identical(other.userNotFound, userNotFound) || other.userNotFound == userNotFound)&&(identical(other.succeeded, succeeded) || other.succeeded == succeeded));
}


@override
int get hashCode => Object.hash(runtimeType,phase,sessionId,deepLink,codeLength,code,resendSeconds,verifying,codeError,startError,launchFailed,userNotFound,succeeded);

@override
String toString() {
  return 'TelegramAuthState(phase: $phase, sessionId: $sessionId, deepLink: $deepLink, codeLength: $codeLength, code: $code, resendSeconds: $resendSeconds, verifying: $verifying, codeError: $codeError, startError: $startError, launchFailed: $launchFailed, userNotFound: $userNotFound, succeeded: $succeeded)';
}


}

/// @nodoc
abstract mixin class _$TelegramAuthStateCopyWith<$Res> implements $TelegramAuthStateCopyWith<$Res> {
  factory _$TelegramAuthStateCopyWith(_TelegramAuthState value, $Res Function(_TelegramAuthState) _then) = __$TelegramAuthStateCopyWithImpl;
@override @useResult
$Res call({
 TelegramAuthPhase phase, String? sessionId, String? deepLink, int codeLength, String code, int resendSeconds, bool verifying, TelegramCodeError? codeError, ApiError? startError, bool launchFailed, bool userNotFound, bool succeeded
});


@override $ApiErrorCopyWith<$Res>? get startError;

}
/// @nodoc
class __$TelegramAuthStateCopyWithImpl<$Res>
    implements _$TelegramAuthStateCopyWith<$Res> {
  __$TelegramAuthStateCopyWithImpl(this._self, this._then);

  final _TelegramAuthState _self;
  final $Res Function(_TelegramAuthState) _then;

/// Create a copy of TelegramAuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? sessionId = freezed,Object? deepLink = freezed,Object? codeLength = null,Object? code = null,Object? resendSeconds = null,Object? verifying = null,Object? codeError = freezed,Object? startError = freezed,Object? launchFailed = null,Object? userNotFound = null,Object? succeeded = null,}) {
  return _then(_TelegramAuthState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TelegramAuthPhase,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,codeLength: null == codeLength ? _self.codeLength : codeLength // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,resendSeconds: null == resendSeconds ? _self.resendSeconds : resendSeconds // ignore: cast_nullable_to_non_nullable
as int,verifying: null == verifying ? _self.verifying : verifying // ignore: cast_nullable_to_non_nullable
as bool,codeError: freezed == codeError ? _self.codeError : codeError // ignore: cast_nullable_to_non_nullable
as TelegramCodeError?,startError: freezed == startError ? _self.startError : startError // ignore: cast_nullable_to_non_nullable
as ApiError?,launchFailed: null == launchFailed ? _self.launchFailed : launchFailed // ignore: cast_nullable_to_non_nullable
as bool,userNotFound: null == userNotFound ? _self.userNotFound : userNotFound // ignore: cast_nullable_to_non_nullable
as bool,succeeded: null == succeeded ? _self.succeeded : succeeded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TelegramAuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get startError {
    if (_self.startError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.startError!, (value) {
    return _then(_self.copyWith(startError: value));
  });
}
}

// dart format on
