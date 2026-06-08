// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telegram_login.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TelegramStartSession {

 String get sessionId; String get deepLink; int get codeLength; int get resendAfterSec;
/// Create a copy of TelegramStartSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelegramStartSessionCopyWith<TelegramStartSession> get copyWith => _$TelegramStartSessionCopyWithImpl<TelegramStartSession>(this as TelegramStartSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelegramStartSession&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.codeLength, codeLength) || other.codeLength == codeLength)&&(identical(other.resendAfterSec, resendAfterSec) || other.resendAfterSec == resendAfterSec));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,deepLink,codeLength,resendAfterSec);

@override
String toString() {
  return 'TelegramStartSession(sessionId: $sessionId, deepLink: $deepLink, codeLength: $codeLength, resendAfterSec: $resendAfterSec)';
}


}

/// @nodoc
abstract mixin class $TelegramStartSessionCopyWith<$Res>  {
  factory $TelegramStartSessionCopyWith(TelegramStartSession value, $Res Function(TelegramStartSession) _then) = _$TelegramStartSessionCopyWithImpl;
@useResult
$Res call({
 String sessionId, String deepLink, int codeLength, int resendAfterSec
});




}
/// @nodoc
class _$TelegramStartSessionCopyWithImpl<$Res>
    implements $TelegramStartSessionCopyWith<$Res> {
  _$TelegramStartSessionCopyWithImpl(this._self, this._then);

  final TelegramStartSession _self;
  final $Res Function(TelegramStartSession) _then;

/// Create a copy of TelegramStartSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? deepLink = null,Object? codeLength = null,Object? resendAfterSec = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,codeLength: null == codeLength ? _self.codeLength : codeLength // ignore: cast_nullable_to_non_nullable
as int,resendAfterSec: null == resendAfterSec ? _self.resendAfterSec : resendAfterSec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TelegramStartSession].
extension TelegramStartSessionPatterns on TelegramStartSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelegramStartSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelegramStartSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelegramStartSession value)  $default,){
final _that = this;
switch (_that) {
case _TelegramStartSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelegramStartSession value)?  $default,){
final _that = this;
switch (_that) {
case _TelegramStartSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String deepLink,  int codeLength,  int resendAfterSec)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelegramStartSession() when $default != null:
return $default(_that.sessionId,_that.deepLink,_that.codeLength,_that.resendAfterSec);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String deepLink,  int codeLength,  int resendAfterSec)  $default,) {final _that = this;
switch (_that) {
case _TelegramStartSession():
return $default(_that.sessionId,_that.deepLink,_that.codeLength,_that.resendAfterSec);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String deepLink,  int codeLength,  int resendAfterSec)?  $default,) {final _that = this;
switch (_that) {
case _TelegramStartSession() when $default != null:
return $default(_that.sessionId,_that.deepLink,_that.codeLength,_that.resendAfterSec);case _:
  return null;

}
}

}

/// @nodoc


class _TelegramStartSession implements TelegramStartSession {
  const _TelegramStartSession({required this.sessionId, required this.deepLink, required this.codeLength, required this.resendAfterSec});
  

@override final  String sessionId;
@override final  String deepLink;
@override final  int codeLength;
@override final  int resendAfterSec;

/// Create a copy of TelegramStartSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelegramStartSessionCopyWith<_TelegramStartSession> get copyWith => __$TelegramStartSessionCopyWithImpl<_TelegramStartSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TelegramStartSession&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.codeLength, codeLength) || other.codeLength == codeLength)&&(identical(other.resendAfterSec, resendAfterSec) || other.resendAfterSec == resendAfterSec));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,deepLink,codeLength,resendAfterSec);

@override
String toString() {
  return 'TelegramStartSession(sessionId: $sessionId, deepLink: $deepLink, codeLength: $codeLength, resendAfterSec: $resendAfterSec)';
}


}

/// @nodoc
abstract mixin class _$TelegramStartSessionCopyWith<$Res> implements $TelegramStartSessionCopyWith<$Res> {
  factory _$TelegramStartSessionCopyWith(_TelegramStartSession value, $Res Function(_TelegramStartSession) _then) = __$TelegramStartSessionCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String deepLink, int codeLength, int resendAfterSec
});




}
/// @nodoc
class __$TelegramStartSessionCopyWithImpl<$Res>
    implements _$TelegramStartSessionCopyWith<$Res> {
  __$TelegramStartSessionCopyWithImpl(this._self, this._then);

  final _TelegramStartSession _self;
  final $Res Function(_TelegramStartSession) _then;

/// Create a copy of TelegramStartSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? deepLink = null,Object? codeLength = null,Object? resendAfterSec = null,}) {
  return _then(_TelegramStartSession(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,codeLength: null == codeLength ? _self.codeLength : codeLength // ignore: cast_nullable_to_non_nullable
as int,resendAfterSec: null == resendAfterSec ? _self.resendAfterSec : resendAfterSec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TelegramVerifyOutcome {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelegramVerifyOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelegramVerifyOutcome()';
}


}

/// @nodoc
class $TelegramVerifyOutcomeCopyWith<$Res>  {
$TelegramVerifyOutcomeCopyWith(TelegramVerifyOutcome _, $Res Function(TelegramVerifyOutcome) __);
}


/// Adds pattern-matching-related methods to [TelegramVerifyOutcome].
extension TelegramVerifyOutcomePatterns on TelegramVerifyOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TelegramVerifySuccess value)?  success,TResult Function( TelegramInvalidCode value)?  invalidCode,TResult Function( TelegramSessionExpired value)?  sessionExpired,TResult Function( TelegramTooManyAttempts value)?  tooManyAttempts,TResult Function( TelegramUserNotFound value)?  userNotFound,TResult Function( TelegramVerifyFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TelegramVerifySuccess() when success != null:
return success(_that);case TelegramInvalidCode() when invalidCode != null:
return invalidCode(_that);case TelegramSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case TelegramTooManyAttempts() when tooManyAttempts != null:
return tooManyAttempts(_that);case TelegramUserNotFound() when userNotFound != null:
return userNotFound(_that);case TelegramVerifyFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TelegramVerifySuccess value)  success,required TResult Function( TelegramInvalidCode value)  invalidCode,required TResult Function( TelegramSessionExpired value)  sessionExpired,required TResult Function( TelegramTooManyAttempts value)  tooManyAttempts,required TResult Function( TelegramUserNotFound value)  userNotFound,required TResult Function( TelegramVerifyFailure value)  failure,}){
final _that = this;
switch (_that) {
case TelegramVerifySuccess():
return success(_that);case TelegramInvalidCode():
return invalidCode(_that);case TelegramSessionExpired():
return sessionExpired(_that);case TelegramTooManyAttempts():
return tooManyAttempts(_that);case TelegramUserNotFound():
return userNotFound(_that);case TelegramVerifyFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TelegramVerifySuccess value)?  success,TResult? Function( TelegramInvalidCode value)?  invalidCode,TResult? Function( TelegramSessionExpired value)?  sessionExpired,TResult? Function( TelegramTooManyAttempts value)?  tooManyAttempts,TResult? Function( TelegramUserNotFound value)?  userNotFound,TResult? Function( TelegramVerifyFailure value)?  failure,}){
final _that = this;
switch (_that) {
case TelegramVerifySuccess() when success != null:
return success(_that);case TelegramInvalidCode() when invalidCode != null:
return invalidCode(_that);case TelegramSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case TelegramTooManyAttempts() when tooManyAttempts != null:
return tooManyAttempts(_that);case TelegramUserNotFound() when userNotFound != null:
return userNotFound(_that);case TelegramVerifyFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  success,TResult Function()?  invalidCode,TResult Function()?  sessionExpired,TResult Function()?  tooManyAttempts,TResult Function()?  userNotFound,TResult Function( ApiError error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TelegramVerifySuccess() when success != null:
return success();case TelegramInvalidCode() when invalidCode != null:
return invalidCode();case TelegramSessionExpired() when sessionExpired != null:
return sessionExpired();case TelegramTooManyAttempts() when tooManyAttempts != null:
return tooManyAttempts();case TelegramUserNotFound() when userNotFound != null:
return userNotFound();case TelegramVerifyFailure() when failure != null:
return failure(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  success,required TResult Function()  invalidCode,required TResult Function()  sessionExpired,required TResult Function()  tooManyAttempts,required TResult Function()  userNotFound,required TResult Function( ApiError error)  failure,}) {final _that = this;
switch (_that) {
case TelegramVerifySuccess():
return success();case TelegramInvalidCode():
return invalidCode();case TelegramSessionExpired():
return sessionExpired();case TelegramTooManyAttempts():
return tooManyAttempts();case TelegramUserNotFound():
return userNotFound();case TelegramVerifyFailure():
return failure(_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  success,TResult? Function()?  invalidCode,TResult? Function()?  sessionExpired,TResult? Function()?  tooManyAttempts,TResult? Function()?  userNotFound,TResult? Function( ApiError error)?  failure,}) {final _that = this;
switch (_that) {
case TelegramVerifySuccess() when success != null:
return success();case TelegramInvalidCode() when invalidCode != null:
return invalidCode();case TelegramSessionExpired() when sessionExpired != null:
return sessionExpired();case TelegramTooManyAttempts() when tooManyAttempts != null:
return tooManyAttempts();case TelegramUserNotFound() when userNotFound != null:
return userNotFound();case TelegramVerifyFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class TelegramVerifySuccess extends TelegramVerifyOutcome {
  const TelegramVerifySuccess(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelegramVerifySuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelegramVerifyOutcome.success()';
}


}




/// @nodoc


class TelegramInvalidCode extends TelegramVerifyOutcome {
  const TelegramInvalidCode(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelegramInvalidCode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelegramVerifyOutcome.invalidCode()';
}


}




/// @nodoc


class TelegramSessionExpired extends TelegramVerifyOutcome {
  const TelegramSessionExpired(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelegramSessionExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelegramVerifyOutcome.sessionExpired()';
}


}




/// @nodoc


class TelegramTooManyAttempts extends TelegramVerifyOutcome {
  const TelegramTooManyAttempts(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelegramTooManyAttempts);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelegramVerifyOutcome.tooManyAttempts()';
}


}




/// @nodoc


class TelegramUserNotFound extends TelegramVerifyOutcome {
  const TelegramUserNotFound(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelegramUserNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelegramVerifyOutcome.userNotFound()';
}


}




/// @nodoc


class TelegramVerifyFailure extends TelegramVerifyOutcome {
  const TelegramVerifyFailure(this.error): super._();
  

 final  ApiError error;

/// Create a copy of TelegramVerifyOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelegramVerifyFailureCopyWith<TelegramVerifyFailure> get copyWith => _$TelegramVerifyFailureCopyWithImpl<TelegramVerifyFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelegramVerifyFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'TelegramVerifyOutcome.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $TelegramVerifyFailureCopyWith<$Res> implements $TelegramVerifyOutcomeCopyWith<$Res> {
  factory $TelegramVerifyFailureCopyWith(TelegramVerifyFailure value, $Res Function(TelegramVerifyFailure) _then) = _$TelegramVerifyFailureCopyWithImpl;
@useResult
$Res call({
 ApiError error
});


$ApiErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$TelegramVerifyFailureCopyWithImpl<$Res>
    implements $TelegramVerifyFailureCopyWith<$Res> {
  _$TelegramVerifyFailureCopyWithImpl(this._self, this._then);

  final TelegramVerifyFailure _self;
  final $Res Function(TelegramVerifyFailure) _then;

/// Create a copy of TelegramVerifyOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(TelegramVerifyFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError,
  ));
}

/// Create a copy of TelegramVerifyOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res> get error {
  
  return $ApiErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
