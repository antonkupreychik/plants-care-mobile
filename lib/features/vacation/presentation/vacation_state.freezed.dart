// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vacation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VacationState {

/// Подтверждённое backend состояние режима отпуска.
 VacationStatus get status;/// Редактируемый диапазон дат для включения отпуска.
 VacationRange get range;/// Идёт ли запись (POST/DELETE в полёте).
 bool get busy;/// Ошибка последнего действия, либо `null`.
 ApiError? get actionError;
/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VacationStateCopyWith<VacationState> get copyWith => _$VacationStateCopyWithImpl<VacationState>(this as VacationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VacationState&&(identical(other.status, status) || other.status == status)&&(identical(other.range, range) || other.range == range)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.actionError, actionError) || other.actionError == actionError));
}


@override
int get hashCode => Object.hash(runtimeType,status,range,busy,actionError);

@override
String toString() {
  return 'VacationState(status: $status, range: $range, busy: $busy, actionError: $actionError)';
}


}

/// @nodoc
abstract mixin class $VacationStateCopyWith<$Res>  {
  factory $VacationStateCopyWith(VacationState value, $Res Function(VacationState) _then) = _$VacationStateCopyWithImpl;
@useResult
$Res call({
 VacationStatus status, VacationRange range, bool busy, ApiError? actionError
});


$VacationStatusCopyWith<$Res> get status;$VacationRangeCopyWith<$Res> get range;$ApiErrorCopyWith<$Res>? get actionError;

}
/// @nodoc
class _$VacationStateCopyWithImpl<$Res>
    implements $VacationStateCopyWith<$Res> {
  _$VacationStateCopyWithImpl(this._self, this._then);

  final VacationState _self;
  final $Res Function(VacationState) _then;

/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? range = null,Object? busy = null,Object? actionError = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VacationStatus,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as VacationRange,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VacationStatusCopyWith<$Res> get status {
  
  return $VacationStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VacationRangeCopyWith<$Res> get range {
  
  return $VacationRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get actionError {
    if (_self.actionError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.actionError!, (value) {
    return _then(_self.copyWith(actionError: value));
  });
}
}


/// Adds pattern-matching-related methods to [VacationState].
extension VacationStatePatterns on VacationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VacationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VacationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VacationState value)  $default,){
final _that = this;
switch (_that) {
case _VacationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VacationState value)?  $default,){
final _that = this;
switch (_that) {
case _VacationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VacationStatus status,  VacationRange range,  bool busy,  ApiError? actionError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VacationState() when $default != null:
return $default(_that.status,_that.range,_that.busy,_that.actionError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VacationStatus status,  VacationRange range,  bool busy,  ApiError? actionError)  $default,) {final _that = this;
switch (_that) {
case _VacationState():
return $default(_that.status,_that.range,_that.busy,_that.actionError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VacationStatus status,  VacationRange range,  bool busy,  ApiError? actionError)?  $default,) {final _that = this;
switch (_that) {
case _VacationState() when $default != null:
return $default(_that.status,_that.range,_that.busy,_that.actionError);case _:
  return null;

}
}

}

/// @nodoc


class _VacationState extends VacationState {
  const _VacationState({required this.status, required this.range, this.busy = false, this.actionError}): super._();
  

/// Подтверждённое backend состояние режима отпуска.
@override final  VacationStatus status;
/// Редактируемый диапазон дат для включения отпуска.
@override final  VacationRange range;
/// Идёт ли запись (POST/DELETE в полёте).
@override@JsonKey() final  bool busy;
/// Ошибка последнего действия, либо `null`.
@override final  ApiError? actionError;

/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VacationStateCopyWith<_VacationState> get copyWith => __$VacationStateCopyWithImpl<_VacationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VacationState&&(identical(other.status, status) || other.status == status)&&(identical(other.range, range) || other.range == range)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.actionError, actionError) || other.actionError == actionError));
}


@override
int get hashCode => Object.hash(runtimeType,status,range,busy,actionError);

@override
String toString() {
  return 'VacationState(status: $status, range: $range, busy: $busy, actionError: $actionError)';
}


}

/// @nodoc
abstract mixin class _$VacationStateCopyWith<$Res> implements $VacationStateCopyWith<$Res> {
  factory _$VacationStateCopyWith(_VacationState value, $Res Function(_VacationState) _then) = __$VacationStateCopyWithImpl;
@override @useResult
$Res call({
 VacationStatus status, VacationRange range, bool busy, ApiError? actionError
});


@override $VacationStatusCopyWith<$Res> get status;@override $VacationRangeCopyWith<$Res> get range;@override $ApiErrorCopyWith<$Res>? get actionError;

}
/// @nodoc
class __$VacationStateCopyWithImpl<$Res>
    implements _$VacationStateCopyWith<$Res> {
  __$VacationStateCopyWithImpl(this._self, this._then);

  final _VacationState _self;
  final $Res Function(_VacationState) _then;

/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? range = null,Object? busy = null,Object? actionError = freezed,}) {
  return _then(_VacationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VacationStatus,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as VacationRange,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VacationStatusCopyWith<$Res> get status {
  
  return $VacationStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VacationRangeCopyWith<$Res> get range {
  
  return $VacationRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}/// Create a copy of VacationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get actionError {
    if (_self.actionError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.actionError!, (value) {
    return _then(_self.copyWith(actionError: value));
  });
}
}

// dart format on
