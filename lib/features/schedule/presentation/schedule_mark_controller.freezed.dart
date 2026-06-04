// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_mark_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleMarkState {

 Set<ScheduleTaskKey> get doneKeys; Set<ScheduleTaskKey> get pendingKeys; ApiError? get lastError;
/// Create a copy of ScheduleMarkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleMarkStateCopyWith<ScheduleMarkState> get copyWith => _$ScheduleMarkStateCopyWithImpl<ScheduleMarkState>(this as ScheduleMarkState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleMarkState&&const DeepCollectionEquality().equals(other.doneKeys, doneKeys)&&const DeepCollectionEquality().equals(other.pendingKeys, pendingKeys)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(doneKeys),const DeepCollectionEquality().hash(pendingKeys),lastError);

@override
String toString() {
  return 'ScheduleMarkState(doneKeys: $doneKeys, pendingKeys: $pendingKeys, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class $ScheduleMarkStateCopyWith<$Res>  {
  factory $ScheduleMarkStateCopyWith(ScheduleMarkState value, $Res Function(ScheduleMarkState) _then) = _$ScheduleMarkStateCopyWithImpl;
@useResult
$Res call({
 Set<ScheduleTaskKey> doneKeys, Set<ScheduleTaskKey> pendingKeys, ApiError? lastError
});


$ApiErrorCopyWith<$Res>? get lastError;

}
/// @nodoc
class _$ScheduleMarkStateCopyWithImpl<$Res>
    implements $ScheduleMarkStateCopyWith<$Res> {
  _$ScheduleMarkStateCopyWithImpl(this._self, this._then);

  final ScheduleMarkState _self;
  final $Res Function(ScheduleMarkState) _then;

/// Create a copy of ScheduleMarkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? doneKeys = null,Object? pendingKeys = null,Object? lastError = freezed,}) {
  return _then(_self.copyWith(
doneKeys: null == doneKeys ? _self.doneKeys : doneKeys // ignore: cast_nullable_to_non_nullable
as Set<ScheduleTaskKey>,pendingKeys: null == pendingKeys ? _self.pendingKeys : pendingKeys // ignore: cast_nullable_to_non_nullable
as Set<ScheduleTaskKey>,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of ScheduleMarkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get lastError {
    if (_self.lastError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.lastError!, (value) {
    return _then(_self.copyWith(lastError: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleMarkState].
extension ScheduleMarkStatePatterns on ScheduleMarkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleMarkState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleMarkState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleMarkState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleMarkState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleMarkState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleMarkState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<ScheduleTaskKey> doneKeys,  Set<ScheduleTaskKey> pendingKeys,  ApiError? lastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleMarkState() when $default != null:
return $default(_that.doneKeys,_that.pendingKeys,_that.lastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<ScheduleTaskKey> doneKeys,  Set<ScheduleTaskKey> pendingKeys,  ApiError? lastError)  $default,) {final _that = this;
switch (_that) {
case _ScheduleMarkState():
return $default(_that.doneKeys,_that.pendingKeys,_that.lastError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<ScheduleTaskKey> doneKeys,  Set<ScheduleTaskKey> pendingKeys,  ApiError? lastError)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleMarkState() when $default != null:
return $default(_that.doneKeys,_that.pendingKeys,_that.lastError);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleMarkState implements ScheduleMarkState {
  const _ScheduleMarkState({final  Set<ScheduleTaskKey> doneKeys = const <ScheduleTaskKey>{}, final  Set<ScheduleTaskKey> pendingKeys = const <ScheduleTaskKey>{}, this.lastError}): _doneKeys = doneKeys,_pendingKeys = pendingKeys;
  

 final  Set<ScheduleTaskKey> _doneKeys;
@override@JsonKey() Set<ScheduleTaskKey> get doneKeys {
  if (_doneKeys is EqualUnmodifiableSetView) return _doneKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_doneKeys);
}

 final  Set<ScheduleTaskKey> _pendingKeys;
@override@JsonKey() Set<ScheduleTaskKey> get pendingKeys {
  if (_pendingKeys is EqualUnmodifiableSetView) return _pendingKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingKeys);
}

@override final  ApiError? lastError;

/// Create a copy of ScheduleMarkState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleMarkStateCopyWith<_ScheduleMarkState> get copyWith => __$ScheduleMarkStateCopyWithImpl<_ScheduleMarkState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleMarkState&&const DeepCollectionEquality().equals(other._doneKeys, _doneKeys)&&const DeepCollectionEquality().equals(other._pendingKeys, _pendingKeys)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_doneKeys),const DeepCollectionEquality().hash(_pendingKeys),lastError);

@override
String toString() {
  return 'ScheduleMarkState(doneKeys: $doneKeys, pendingKeys: $pendingKeys, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$ScheduleMarkStateCopyWith<$Res> implements $ScheduleMarkStateCopyWith<$Res> {
  factory _$ScheduleMarkStateCopyWith(_ScheduleMarkState value, $Res Function(_ScheduleMarkState) _then) = __$ScheduleMarkStateCopyWithImpl;
@override @useResult
$Res call({
 Set<ScheduleTaskKey> doneKeys, Set<ScheduleTaskKey> pendingKeys, ApiError? lastError
});


@override $ApiErrorCopyWith<$Res>? get lastError;

}
/// @nodoc
class __$ScheduleMarkStateCopyWithImpl<$Res>
    implements _$ScheduleMarkStateCopyWith<$Res> {
  __$ScheduleMarkStateCopyWithImpl(this._self, this._then);

  final _ScheduleMarkState _self;
  final $Res Function(_ScheduleMarkState) _then;

/// Create a copy of ScheduleMarkState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? doneKeys = null,Object? pendingKeys = null,Object? lastError = freezed,}) {
  return _then(_ScheduleMarkState(
doneKeys: null == doneKeys ? _self._doneKeys : doneKeys // ignore: cast_nullable_to_non_nullable
as Set<ScheduleTaskKey>,pendingKeys: null == pendingKeys ? _self._pendingKeys : pendingKeys // ignore: cast_nullable_to_non_nullable
as Set<ScheduleTaskKey>,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of ScheduleMarkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get lastError {
    if (_self.lastError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.lastError!, (value) {
    return _then(_self.copyWith(lastError: value));
  });
}
}

// dart format on
