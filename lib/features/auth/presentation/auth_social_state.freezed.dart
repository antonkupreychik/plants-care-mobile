// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_social_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthSocialState {

/// Провайдер, по которому идёт запрос (`null` — ничего не выполняется).
 SocialProvider? get inProgress;/// Ошибка последней попытки входа (`null` — ошибки нет).
 ApiError? get error;
/// Create a copy of AuthSocialState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSocialStateCopyWith<AuthSocialState> get copyWith => _$AuthSocialStateCopyWithImpl<AuthSocialState>(this as AuthSocialState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSocialState&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,inProgress,error);

@override
String toString() {
  return 'AuthSocialState(inProgress: $inProgress, error: $error)';
}


}

/// @nodoc
abstract mixin class $AuthSocialStateCopyWith<$Res>  {
  factory $AuthSocialStateCopyWith(AuthSocialState value, $Res Function(AuthSocialState) _then) = _$AuthSocialStateCopyWithImpl;
@useResult
$Res call({
 SocialProvider? inProgress, ApiError? error
});


$ApiErrorCopyWith<$Res>? get error;

}
/// @nodoc
class _$AuthSocialStateCopyWithImpl<$Res>
    implements $AuthSocialStateCopyWith<$Res> {
  _$AuthSocialStateCopyWithImpl(this._self, this._then);

  final AuthSocialState _self;
  final $Res Function(AuthSocialState) _then;

/// Create a copy of AuthSocialState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inProgress = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
inProgress: freezed == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as SocialProvider?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of AuthSocialState
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


/// Adds pattern-matching-related methods to [AuthSocialState].
extension AuthSocialStatePatterns on AuthSocialState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthSocialState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSocialState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthSocialState value)  $default,){
final _that = this;
switch (_that) {
case _AuthSocialState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthSocialState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthSocialState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SocialProvider? inProgress,  ApiError? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthSocialState() when $default != null:
return $default(_that.inProgress,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SocialProvider? inProgress,  ApiError? error)  $default,) {final _that = this;
switch (_that) {
case _AuthSocialState():
return $default(_that.inProgress,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SocialProvider? inProgress,  ApiError? error)?  $default,) {final _that = this;
switch (_that) {
case _AuthSocialState() when $default != null:
return $default(_that.inProgress,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AuthSocialState extends AuthSocialState {
  const _AuthSocialState({this.inProgress, this.error}): super._();
  

/// Провайдер, по которому идёт запрос (`null` — ничего не выполняется).
@override final  SocialProvider? inProgress;
/// Ошибка последней попытки входа (`null` — ошибки нет).
@override final  ApiError? error;

/// Create a copy of AuthSocialState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSocialStateCopyWith<_AuthSocialState> get copyWith => __$AuthSocialStateCopyWithImpl<_AuthSocialState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSocialState&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,inProgress,error);

@override
String toString() {
  return 'AuthSocialState(inProgress: $inProgress, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AuthSocialStateCopyWith<$Res> implements $AuthSocialStateCopyWith<$Res> {
  factory _$AuthSocialStateCopyWith(_AuthSocialState value, $Res Function(_AuthSocialState) _then) = __$AuthSocialStateCopyWithImpl;
@override @useResult
$Res call({
 SocialProvider? inProgress, ApiError? error
});


@override $ApiErrorCopyWith<$Res>? get error;

}
/// @nodoc
class __$AuthSocialStateCopyWithImpl<$Res>
    implements _$AuthSocialStateCopyWith<$Res> {
  __$AuthSocialStateCopyWithImpl(this._self, this._then);

  final _AuthSocialState _self;
  final $Res Function(_AuthSocialState) _then;

/// Create a copy of AuthSocialState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inProgress = freezed,Object? error = freezed,}) {
  return _then(_AuthSocialState(
inProgress: freezed == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as SocialProvider?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of AuthSocialState
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
