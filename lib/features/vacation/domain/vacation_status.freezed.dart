// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vacation_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VacationStatus {

/// Включён ли режим отпуска сейчас.
 bool get active;/// Момент окончания паузы (UTC). `null`, если отпуск неактивен.
 DateTime? get pausedUntil;
/// Create a copy of VacationStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VacationStatusCopyWith<VacationStatus> get copyWith => _$VacationStatusCopyWithImpl<VacationStatus>(this as VacationStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VacationStatus&&(identical(other.active, active) || other.active == active)&&(identical(other.pausedUntil, pausedUntil) || other.pausedUntil == pausedUntil));
}


@override
int get hashCode => Object.hash(runtimeType,active,pausedUntil);

@override
String toString() {
  return 'VacationStatus(active: $active, pausedUntil: $pausedUntil)';
}


}

/// @nodoc
abstract mixin class $VacationStatusCopyWith<$Res>  {
  factory $VacationStatusCopyWith(VacationStatus value, $Res Function(VacationStatus) _then) = _$VacationStatusCopyWithImpl;
@useResult
$Res call({
 bool active, DateTime? pausedUntil
});




}
/// @nodoc
class _$VacationStatusCopyWithImpl<$Res>
    implements $VacationStatusCopyWith<$Res> {
  _$VacationStatusCopyWithImpl(this._self, this._then);

  final VacationStatus _self;
  final $Res Function(VacationStatus) _then;

/// Create a copy of VacationStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? active = null,Object? pausedUntil = freezed,}) {
  return _then(_self.copyWith(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,pausedUntil: freezed == pausedUntil ? _self.pausedUntil : pausedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [VacationStatus].
extension VacationStatusPatterns on VacationStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VacationStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VacationStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VacationStatus value)  $default,){
final _that = this;
switch (_that) {
case _VacationStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VacationStatus value)?  $default,){
final _that = this;
switch (_that) {
case _VacationStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool active,  DateTime? pausedUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VacationStatus() when $default != null:
return $default(_that.active,_that.pausedUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool active,  DateTime? pausedUntil)  $default,) {final _that = this;
switch (_that) {
case _VacationStatus():
return $default(_that.active,_that.pausedUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool active,  DateTime? pausedUntil)?  $default,) {final _that = this;
switch (_that) {
case _VacationStatus() when $default != null:
return $default(_that.active,_that.pausedUntil);case _:
  return null;

}
}

}

/// @nodoc


class _VacationStatus extends VacationStatus {
  const _VacationStatus({required this.active, this.pausedUntil}): super._();
  

/// Включён ли режим отпуска сейчас.
@override final  bool active;
/// Момент окончания паузы (UTC). `null`, если отпуск неактивен.
@override final  DateTime? pausedUntil;

/// Create a copy of VacationStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VacationStatusCopyWith<_VacationStatus> get copyWith => __$VacationStatusCopyWithImpl<_VacationStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VacationStatus&&(identical(other.active, active) || other.active == active)&&(identical(other.pausedUntil, pausedUntil) || other.pausedUntil == pausedUntil));
}


@override
int get hashCode => Object.hash(runtimeType,active,pausedUntil);

@override
String toString() {
  return 'VacationStatus(active: $active, pausedUntil: $pausedUntil)';
}


}

/// @nodoc
abstract mixin class _$VacationStatusCopyWith<$Res> implements $VacationStatusCopyWith<$Res> {
  factory _$VacationStatusCopyWith(_VacationStatus value, $Res Function(_VacationStatus) _then) = __$VacationStatusCopyWithImpl;
@override @useResult
$Res call({
 bool active, DateTime? pausedUntil
});




}
/// @nodoc
class __$VacationStatusCopyWithImpl<$Res>
    implements _$VacationStatusCopyWith<$Res> {
  __$VacationStatusCopyWithImpl(this._self, this._then);

  final _VacationStatus _self;
  final $Res Function(_VacationStatus) _then;

/// Create a copy of VacationStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? active = null,Object? pausedUntil = freezed,}) {
  return _then(_VacationStatus(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,pausedUntil: freezed == pausedUntil ? _self.pausedUntil : pausedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
