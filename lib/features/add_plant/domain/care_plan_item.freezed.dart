// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_plan_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CarePlanItem {

 CareTaskType get type; int get everyDays;
/// Create a copy of CarePlanItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarePlanItemCopyWith<CarePlanItem> get copyWith => _$CarePlanItemCopyWithImpl<CarePlanItem>(this as CarePlanItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarePlanItem&&(identical(other.type, type) || other.type == type)&&(identical(other.everyDays, everyDays) || other.everyDays == everyDays));
}


@override
int get hashCode => Object.hash(runtimeType,type,everyDays);

@override
String toString() {
  return 'CarePlanItem(type: $type, everyDays: $everyDays)';
}


}

/// @nodoc
abstract mixin class $CarePlanItemCopyWith<$Res>  {
  factory $CarePlanItemCopyWith(CarePlanItem value, $Res Function(CarePlanItem) _then) = _$CarePlanItemCopyWithImpl;
@useResult
$Res call({
 CareTaskType type, int everyDays
});




}
/// @nodoc
class _$CarePlanItemCopyWithImpl<$Res>
    implements $CarePlanItemCopyWith<$Res> {
  _$CarePlanItemCopyWithImpl(this._self, this._then);

  final CarePlanItem _self;
  final $Res Function(CarePlanItem) _then;

/// Create a copy of CarePlanItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? everyDays = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareTaskType,everyDays: null == everyDays ? _self.everyDays : everyDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CarePlanItem].
extension CarePlanItemPatterns on CarePlanItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CarePlanItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CarePlanItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CarePlanItem value)  $default,){
final _that = this;
switch (_that) {
case _CarePlanItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CarePlanItem value)?  $default,){
final _that = this;
switch (_that) {
case _CarePlanItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CareTaskType type,  int everyDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CarePlanItem() when $default != null:
return $default(_that.type,_that.everyDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CareTaskType type,  int everyDays)  $default,) {final _that = this;
switch (_that) {
case _CarePlanItem():
return $default(_that.type,_that.everyDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CareTaskType type,  int everyDays)?  $default,) {final _that = this;
switch (_that) {
case _CarePlanItem() when $default != null:
return $default(_that.type,_that.everyDays);case _:
  return null;

}
}

}

/// @nodoc


class _CarePlanItem implements CarePlanItem {
  const _CarePlanItem({required this.type, required this.everyDays});
  

@override final  CareTaskType type;
@override final  int everyDays;

/// Create a copy of CarePlanItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CarePlanItemCopyWith<_CarePlanItem> get copyWith => __$CarePlanItemCopyWithImpl<_CarePlanItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CarePlanItem&&(identical(other.type, type) || other.type == type)&&(identical(other.everyDays, everyDays) || other.everyDays == everyDays));
}


@override
int get hashCode => Object.hash(runtimeType,type,everyDays);

@override
String toString() {
  return 'CarePlanItem(type: $type, everyDays: $everyDays)';
}


}

/// @nodoc
abstract mixin class _$CarePlanItemCopyWith<$Res> implements $CarePlanItemCopyWith<$Res> {
  factory _$CarePlanItemCopyWith(_CarePlanItem value, $Res Function(_CarePlanItem) _then) = __$CarePlanItemCopyWithImpl;
@override @useResult
$Res call({
 CareTaskType type, int everyDays
});




}
/// @nodoc
class __$CarePlanItemCopyWithImpl<$Res>
    implements _$CarePlanItemCopyWith<$Res> {
  __$CarePlanItemCopyWithImpl(this._self, this._then);

  final _CarePlanItem _self;
  final $Res Function(_CarePlanItem) _then;

/// Create a copy of CarePlanItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? everyDays = null,}) {
  return _then(_CarePlanItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareTaskType,everyDays: null == everyDays ? _self.everyDays : everyDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
