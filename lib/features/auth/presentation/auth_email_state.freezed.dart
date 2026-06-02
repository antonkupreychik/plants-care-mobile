// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_email_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEmailState {

 String get email;/// Идёт ли запрос magic link (UI блокирует кнопку/поле).
 bool get submitting;/// Ошибка последней отправки (`null` — ошибки нет).
 ApiError? get error;/// Письмо отправлено — UI переключается на «проверьте почту».
 bool get linkSent;
/// Create a copy of AuthEmailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthEmailStateCopyWith<AuthEmailState> get copyWith => _$AuthEmailStateCopyWithImpl<AuthEmailState>(this as AuthEmailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEmailState&&(identical(other.email, email) || other.email == email)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.error, error) || other.error == error)&&(identical(other.linkSent, linkSent) || other.linkSent == linkSent));
}


@override
int get hashCode => Object.hash(runtimeType,email,submitting,error,linkSent);

@override
String toString() {
  return 'AuthEmailState(email: $email, submitting: $submitting, error: $error, linkSent: $linkSent)';
}


}

/// @nodoc
abstract mixin class $AuthEmailStateCopyWith<$Res>  {
  factory $AuthEmailStateCopyWith(AuthEmailState value, $Res Function(AuthEmailState) _then) = _$AuthEmailStateCopyWithImpl;
@useResult
$Res call({
 String email, bool submitting, ApiError? error, bool linkSent
});


$ApiErrorCopyWith<$Res>? get error;

}
/// @nodoc
class _$AuthEmailStateCopyWithImpl<$Res>
    implements $AuthEmailStateCopyWith<$Res> {
  _$AuthEmailStateCopyWithImpl(this._self, this._then);

  final AuthEmailState _self;
  final $Res Function(AuthEmailState) _then;

/// Create a copy of AuthEmailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? submitting = null,Object? error = freezed,Object? linkSent = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError?,linkSent: null == linkSent ? _self.linkSent : linkSent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AuthEmailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthEmailState].
extension AuthEmailStatePatterns on AuthEmailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthEmailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthEmailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthEmailState value)  $default,){
final _that = this;
switch (_that) {
case _AuthEmailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthEmailState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthEmailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  bool submitting,  ApiError? error,  bool linkSent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthEmailState() when $default != null:
return $default(_that.email,_that.submitting,_that.error,_that.linkSent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  bool submitting,  ApiError? error,  bool linkSent)  $default,) {final _that = this;
switch (_that) {
case _AuthEmailState():
return $default(_that.email,_that.submitting,_that.error,_that.linkSent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  bool submitting,  ApiError? error,  bool linkSent)?  $default,) {final _that = this;
switch (_that) {
case _AuthEmailState() when $default != null:
return $default(_that.email,_that.submitting,_that.error,_that.linkSent);case _:
  return null;

}
}

}

/// @nodoc


class _AuthEmailState extends AuthEmailState {
  const _AuthEmailState({this.email = '', this.submitting = false, this.error, this.linkSent = false}): super._();
  

@override@JsonKey() final  String email;
/// Идёт ли запрос magic link (UI блокирует кнопку/поле).
@override@JsonKey() final  bool submitting;
/// Ошибка последней отправки (`null` — ошибки нет).
@override final  ApiError? error;
/// Письмо отправлено — UI переключается на «проверьте почту».
@override@JsonKey() final  bool linkSent;

/// Create a copy of AuthEmailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthEmailStateCopyWith<_AuthEmailState> get copyWith => __$AuthEmailStateCopyWithImpl<_AuthEmailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthEmailState&&(identical(other.email, email) || other.email == email)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.error, error) || other.error == error)&&(identical(other.linkSent, linkSent) || other.linkSent == linkSent));
}


@override
int get hashCode => Object.hash(runtimeType,email,submitting,error,linkSent);

@override
String toString() {
  return 'AuthEmailState(email: $email, submitting: $submitting, error: $error, linkSent: $linkSent)';
}


}

/// @nodoc
abstract mixin class _$AuthEmailStateCopyWith<$Res> implements $AuthEmailStateCopyWith<$Res> {
  factory _$AuthEmailStateCopyWith(_AuthEmailState value, $Res Function(_AuthEmailState) _then) = __$AuthEmailStateCopyWithImpl;
@override @useResult
$Res call({
 String email, bool submitting, ApiError? error, bool linkSent
});


@override $ApiErrorCopyWith<$Res>? get error;

}
/// @nodoc
class __$AuthEmailStateCopyWithImpl<$Res>
    implements _$AuthEmailStateCopyWith<$Res> {
  __$AuthEmailStateCopyWithImpl(this._self, this._then);

  final _AuthEmailState _self;
  final $Res Function(_AuthEmailState) _then;

/// Create a copy of AuthEmailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? submitting = null,Object? error = freezed,Object? linkSent = null,}) {
  return _then(_AuthEmailState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError?,linkSent: null == linkSent ? _self.linkSent : linkSent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AuthEmailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
