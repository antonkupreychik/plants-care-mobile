// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'convert_guest_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConvertGuestState {

/// Провайдер, по которому сейчас идёт запрос (`null` — простой).
 ConvertProvider? get inProgress;/// Статус конвертации.
 ConvertStatus get status;/// Email, введённый пользователем (для отображения «письмо отправлено на…»).
 String get email;/// Ошибка последней попытки (`null` — ошибки нет).
 ApiError? get error;
/// Create a copy of ConvertGuestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConvertGuestStateCopyWith<ConvertGuestState> get copyWith => _$ConvertGuestStateCopyWithImpl<ConvertGuestState>(this as ConvertGuestState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConvertGuestState&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.status, status) || other.status == status)&&(identical(other.email, email) || other.email == email)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,inProgress,status,email,error);

@override
String toString() {
  return 'ConvertGuestState(inProgress: $inProgress, status: $status, email: $email, error: $error)';
}


}

/// @nodoc
abstract mixin class $ConvertGuestStateCopyWith<$Res>  {
  factory $ConvertGuestStateCopyWith(ConvertGuestState value, $Res Function(ConvertGuestState) _then) = _$ConvertGuestStateCopyWithImpl;
@useResult
$Res call({
 ConvertProvider? inProgress, ConvertStatus status, String email, ApiError? error
});


$ApiErrorCopyWith<$Res>? get error;

}
/// @nodoc
class _$ConvertGuestStateCopyWithImpl<$Res>
    implements $ConvertGuestStateCopyWith<$Res> {
  _$ConvertGuestStateCopyWithImpl(this._self, this._then);

  final ConvertGuestState _self;
  final $Res Function(ConvertGuestState) _then;

/// Create a copy of ConvertGuestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inProgress = freezed,Object? status = null,Object? email = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
inProgress: freezed == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as ConvertProvider?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConvertStatus,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of ConvertGuestState
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


/// Adds pattern-matching-related methods to [ConvertGuestState].
extension ConvertGuestStatePatterns on ConvertGuestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConvertGuestState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConvertGuestState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConvertGuestState value)  $default,){
final _that = this;
switch (_that) {
case _ConvertGuestState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConvertGuestState value)?  $default,){
final _that = this;
switch (_that) {
case _ConvertGuestState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConvertProvider? inProgress,  ConvertStatus status,  String email,  ApiError? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConvertGuestState() when $default != null:
return $default(_that.inProgress,_that.status,_that.email,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConvertProvider? inProgress,  ConvertStatus status,  String email,  ApiError? error)  $default,) {final _that = this;
switch (_that) {
case _ConvertGuestState():
return $default(_that.inProgress,_that.status,_that.email,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConvertProvider? inProgress,  ConvertStatus status,  String email,  ApiError? error)?  $default,) {final _that = this;
switch (_that) {
case _ConvertGuestState() when $default != null:
return $default(_that.inProgress,_that.status,_that.email,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ConvertGuestState extends ConvertGuestState {
  const _ConvertGuestState({this.inProgress, this.status = ConvertStatus.idle, this.email = '', this.error}): super._();
  

/// Провайдер, по которому сейчас идёт запрос (`null` — простой).
@override final  ConvertProvider? inProgress;
/// Статус конвертации.
@override@JsonKey() final  ConvertStatus status;
/// Email, введённый пользователем (для отображения «письмо отправлено на…»).
@override@JsonKey() final  String email;
/// Ошибка последней попытки (`null` — ошибки нет).
@override final  ApiError? error;

/// Create a copy of ConvertGuestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConvertGuestStateCopyWith<_ConvertGuestState> get copyWith => __$ConvertGuestStateCopyWithImpl<_ConvertGuestState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConvertGuestState&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.status, status) || other.status == status)&&(identical(other.email, email) || other.email == email)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,inProgress,status,email,error);

@override
String toString() {
  return 'ConvertGuestState(inProgress: $inProgress, status: $status, email: $email, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ConvertGuestStateCopyWith<$Res> implements $ConvertGuestStateCopyWith<$Res> {
  factory _$ConvertGuestStateCopyWith(_ConvertGuestState value, $Res Function(_ConvertGuestState) _then) = __$ConvertGuestStateCopyWithImpl;
@override @useResult
$Res call({
 ConvertProvider? inProgress, ConvertStatus status, String email, ApiError? error
});


@override $ApiErrorCopyWith<$Res>? get error;

}
/// @nodoc
class __$ConvertGuestStateCopyWithImpl<$Res>
    implements _$ConvertGuestStateCopyWith<$Res> {
  __$ConvertGuestStateCopyWithImpl(this._self, this._then);

  final _ConvertGuestState _self;
  final $Res Function(_ConvertGuestState) _then;

/// Create a copy of ConvertGuestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inProgress = freezed,Object? status = null,Object? email = null,Object? error = freezed,}) {
  return _then(_ConvertGuestState(
inProgress: freezed == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as ConvertProvider?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConvertStatus,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of ConvertGuestState
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
