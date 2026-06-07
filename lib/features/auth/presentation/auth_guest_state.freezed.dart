// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_guest_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthGuestState {

/// Идёт ли запрос гостевого входа.
 bool get isLoading;/// Ошибка последней попытки (`null` — ошибки нет).
 ApiError? get error;
/// Create a copy of AuthGuestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthGuestStateCopyWith<AuthGuestState> get copyWith => _$AuthGuestStateCopyWithImpl<AuthGuestState>(this as AuthGuestState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthGuestState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,error);

@override
String toString() {
  return 'AuthGuestState(isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $AuthGuestStateCopyWith<$Res>  {
  factory $AuthGuestStateCopyWith(AuthGuestState value, $Res Function(AuthGuestState) _then) = _$AuthGuestStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, ApiError? error
});


$ApiErrorCopyWith<$Res>? get error;

}
/// @nodoc
class _$AuthGuestStateCopyWithImpl<$Res>
    implements $AuthGuestStateCopyWith<$Res> {
  _$AuthGuestStateCopyWithImpl(this._self, this._then);

  final AuthGuestState _self;
  final $Res Function(AuthGuestState) _then;

/// Create a copy of AuthGuestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of AuthGuestState
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


/// Adds pattern-matching-related methods to [AuthGuestState].
extension AuthGuestStatePatterns on AuthGuestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthGuestState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthGuestState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthGuestState value)  $default,){
final _that = this;
switch (_that) {
case _AuthGuestState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthGuestState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthGuestState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  ApiError? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthGuestState() when $default != null:
return $default(_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  ApiError? error)  $default,) {final _that = this;
switch (_that) {
case _AuthGuestState():
return $default(_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  ApiError? error)?  $default,) {final _that = this;
switch (_that) {
case _AuthGuestState() when $default != null:
return $default(_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AuthGuestState implements AuthGuestState {
  const _AuthGuestState({this.isLoading = false, this.error});
  

/// Идёт ли запрос гостевого входа.
@override@JsonKey() final  bool isLoading;
/// Ошибка последней попытки (`null` — ошибки нет).
@override final  ApiError? error;

/// Create a copy of AuthGuestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthGuestStateCopyWith<_AuthGuestState> get copyWith => __$AuthGuestStateCopyWithImpl<_AuthGuestState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthGuestState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,error);

@override
String toString() {
  return 'AuthGuestState(isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AuthGuestStateCopyWith<$Res> implements $AuthGuestStateCopyWith<$Res> {
  factory _$AuthGuestStateCopyWith(_AuthGuestState value, $Res Function(_AuthGuestState) _then) = __$AuthGuestStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, ApiError? error
});


@override $ApiErrorCopyWith<$Res>? get error;

}
/// @nodoc
class __$AuthGuestStateCopyWithImpl<$Res>
    implements _$AuthGuestStateCopyWith<$Res> {
  __$AuthGuestStateCopyWithImpl(this._self, this._then);

  final _AuthGuestState _self;
  final $Res Function(_AuthGuestState) _then;

/// Create a copy of AuthGuestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? error = freezed,}) {
  return _then(_AuthGuestState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of AuthGuestState
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
