// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_code_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthCodeState {

/// Введённые цифры, длина 0..[kAuthCodeLength]. Только символы '0'..'9'.
 String get code;/// Секунд до возможности нажать «Отправить снова». 0 → можно ресендить.
 int get resendSeconds;
/// Create a copy of AuthCodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthCodeStateCopyWith<AuthCodeState> get copyWith => _$AuthCodeStateCopyWithImpl<AuthCodeState>(this as AuthCodeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCodeState&&(identical(other.code, code) || other.code == code)&&(identical(other.resendSeconds, resendSeconds) || other.resendSeconds == resendSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,code,resendSeconds);

@override
String toString() {
  return 'AuthCodeState(code: $code, resendSeconds: $resendSeconds)';
}


}

/// @nodoc
abstract mixin class $AuthCodeStateCopyWith<$Res>  {
  factory $AuthCodeStateCopyWith(AuthCodeState value, $Res Function(AuthCodeState) _then) = _$AuthCodeStateCopyWithImpl;
@useResult
$Res call({
 String code, int resendSeconds
});




}
/// @nodoc
class _$AuthCodeStateCopyWithImpl<$Res>
    implements $AuthCodeStateCopyWith<$Res> {
  _$AuthCodeStateCopyWithImpl(this._self, this._then);

  final AuthCodeState _self;
  final $Res Function(AuthCodeState) _then;

/// Create a copy of AuthCodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? resendSeconds = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,resendSeconds: null == resendSeconds ? _self.resendSeconds : resendSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthCodeState].
extension AuthCodeStatePatterns on AuthCodeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthCodeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthCodeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthCodeState value)  $default,){
final _that = this;
switch (_that) {
case _AuthCodeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthCodeState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthCodeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int resendSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthCodeState() when $default != null:
return $default(_that.code,_that.resendSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int resendSeconds)  $default,) {final _that = this;
switch (_that) {
case _AuthCodeState():
return $default(_that.code,_that.resendSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int resendSeconds)?  $default,) {final _that = this;
switch (_that) {
case _AuthCodeState() when $default != null:
return $default(_that.code,_that.resendSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _AuthCodeState extends AuthCodeState {
  const _AuthCodeState({this.code = '', this.resendSeconds = kAuthResendSeconds}): super._();
  

/// Введённые цифры, длина 0..[kAuthCodeLength]. Только символы '0'..'9'.
@override@JsonKey() final  String code;
/// Секунд до возможности нажать «Отправить снова». 0 → можно ресендить.
@override@JsonKey() final  int resendSeconds;

/// Create a copy of AuthCodeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthCodeStateCopyWith<_AuthCodeState> get copyWith => __$AuthCodeStateCopyWithImpl<_AuthCodeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthCodeState&&(identical(other.code, code) || other.code == code)&&(identical(other.resendSeconds, resendSeconds) || other.resendSeconds == resendSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,code,resendSeconds);

@override
String toString() {
  return 'AuthCodeState(code: $code, resendSeconds: $resendSeconds)';
}


}

/// @nodoc
abstract mixin class _$AuthCodeStateCopyWith<$Res> implements $AuthCodeStateCopyWith<$Res> {
  factory _$AuthCodeStateCopyWith(_AuthCodeState value, $Res Function(_AuthCodeState) _then) = __$AuthCodeStateCopyWithImpl;
@override @useResult
$Res call({
 String code, int resendSeconds
});




}
/// @nodoc
class __$AuthCodeStateCopyWithImpl<$Res>
    implements _$AuthCodeStateCopyWith<$Res> {
  __$AuthCodeStateCopyWithImpl(this._self, this._then);

  final _AuthCodeState _self;
  final $Res Function(_AuthCodeState) _then;

/// Create a copy of AuthCodeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? resendSeconds = null,}) {
  return _then(_AuthCodeState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,resendSeconds: null == resendSeconds ? _self.resendSeconds : resendSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
