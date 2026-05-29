// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_care_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantCareSchedule {

/// Тип ухода (`WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`).
 CareTaskType get type;/// Исходная backend-строка типа (`WATERING`…) для path-параметра `PUT`
/// и round-trip нераспознанного типа ([CareTaskType.unknown]) без потери.
 String get rawType;/// Интервал повторения в единицах [unit]. Всегда `>= 1`.
 int get every;/// Единица интервала (нормализована из [rawUnit]).
 CareScheduleUnit get unit;/// Исходная backend-строка единицы (`DAY`) для round-trip при `PUT`.
 String get rawUnit;/// Объём воды в мл (для полива). `null` — не задан / не применим.
 int? get amountMl;/// Активно ли расписание (генерирует задачи).
 bool get enabled;/// Момент следующей задачи (UTC), посчитан backend. `null` — неактивно /
/// срок не определён.
 DateTime? get nextDueAt;
/// Create a copy of PlantCareSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantCareScheduleCopyWith<PlantCareSchedule> get copyWith => _$PlantCareScheduleCopyWithImpl<PlantCareSchedule>(this as PlantCareSchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantCareSchedule&&(identical(other.type, type) || other.type == type)&&(identical(other.rawType, rawType) || other.rawType == rawType)&&(identical(other.every, every) || other.every == every)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.rawUnit, rawUnit) || other.rawUnit == rawUnit)&&(identical(other.amountMl, amountMl) || other.amountMl == amountMl)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.nextDueAt, nextDueAt) || other.nextDueAt == nextDueAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,rawType,every,unit,rawUnit,amountMl,enabled,nextDueAt);

@override
String toString() {
  return 'PlantCareSchedule(type: $type, rawType: $rawType, every: $every, unit: $unit, rawUnit: $rawUnit, amountMl: $amountMl, enabled: $enabled, nextDueAt: $nextDueAt)';
}


}

/// @nodoc
abstract mixin class $PlantCareScheduleCopyWith<$Res>  {
  factory $PlantCareScheduleCopyWith(PlantCareSchedule value, $Res Function(PlantCareSchedule) _then) = _$PlantCareScheduleCopyWithImpl;
@useResult
$Res call({
 CareTaskType type, String rawType, int every, CareScheduleUnit unit, String rawUnit, int? amountMl, bool enabled, DateTime? nextDueAt
});




}
/// @nodoc
class _$PlantCareScheduleCopyWithImpl<$Res>
    implements $PlantCareScheduleCopyWith<$Res> {
  _$PlantCareScheduleCopyWithImpl(this._self, this._then);

  final PlantCareSchedule _self;
  final $Res Function(PlantCareSchedule) _then;

/// Create a copy of PlantCareSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? rawType = null,Object? every = null,Object? unit = null,Object? rawUnit = null,Object? amountMl = freezed,Object? enabled = null,Object? nextDueAt = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareTaskType,rawType: null == rawType ? _self.rawType : rawType // ignore: cast_nullable_to_non_nullable
as String,every: null == every ? _self.every : every // ignore: cast_nullable_to_non_nullable
as int,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as CareScheduleUnit,rawUnit: null == rawUnit ? _self.rawUnit : rawUnit // ignore: cast_nullable_to_non_nullable
as String,amountMl: freezed == amountMl ? _self.amountMl : amountMl // ignore: cast_nullable_to_non_nullable
as int?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,nextDueAt: freezed == nextDueAt ? _self.nextDueAt : nextDueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantCareSchedule].
extension PlantCareSchedulePatterns on PlantCareSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantCareSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantCareSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantCareSchedule value)  $default,){
final _that = this;
switch (_that) {
case _PlantCareSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantCareSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _PlantCareSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CareTaskType type,  String rawType,  int every,  CareScheduleUnit unit,  String rawUnit,  int? amountMl,  bool enabled,  DateTime? nextDueAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantCareSchedule() when $default != null:
return $default(_that.type,_that.rawType,_that.every,_that.unit,_that.rawUnit,_that.amountMl,_that.enabled,_that.nextDueAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CareTaskType type,  String rawType,  int every,  CareScheduleUnit unit,  String rawUnit,  int? amountMl,  bool enabled,  DateTime? nextDueAt)  $default,) {final _that = this;
switch (_that) {
case _PlantCareSchedule():
return $default(_that.type,_that.rawType,_that.every,_that.unit,_that.rawUnit,_that.amountMl,_that.enabled,_that.nextDueAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CareTaskType type,  String rawType,  int every,  CareScheduleUnit unit,  String rawUnit,  int? amountMl,  bool enabled,  DateTime? nextDueAt)?  $default,) {final _that = this;
switch (_that) {
case _PlantCareSchedule() when $default != null:
return $default(_that.type,_that.rawType,_that.every,_that.unit,_that.rawUnit,_that.amountMl,_that.enabled,_that.nextDueAt);case _:
  return null;

}
}

}

/// @nodoc


class _PlantCareSchedule extends PlantCareSchedule {
  const _PlantCareSchedule({required this.type, required this.rawType, required this.every, required this.unit, required this.rawUnit, this.amountMl, required this.enabled, this.nextDueAt}): super._();
  

/// Тип ухода (`WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`).
@override final  CareTaskType type;
/// Исходная backend-строка типа (`WATERING`…) для path-параметра `PUT`
/// и round-trip нераспознанного типа ([CareTaskType.unknown]) без потери.
@override final  String rawType;
/// Интервал повторения в единицах [unit]. Всегда `>= 1`.
@override final  int every;
/// Единица интервала (нормализована из [rawUnit]).
@override final  CareScheduleUnit unit;
/// Исходная backend-строка единицы (`DAY`) для round-trip при `PUT`.
@override final  String rawUnit;
/// Объём воды в мл (для полива). `null` — не задан / не применим.
@override final  int? amountMl;
/// Активно ли расписание (генерирует задачи).
@override final  bool enabled;
/// Момент следующей задачи (UTC), посчитан backend. `null` — неактивно /
/// срок не определён.
@override final  DateTime? nextDueAt;

/// Create a copy of PlantCareSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantCareScheduleCopyWith<_PlantCareSchedule> get copyWith => __$PlantCareScheduleCopyWithImpl<_PlantCareSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantCareSchedule&&(identical(other.type, type) || other.type == type)&&(identical(other.rawType, rawType) || other.rawType == rawType)&&(identical(other.every, every) || other.every == every)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.rawUnit, rawUnit) || other.rawUnit == rawUnit)&&(identical(other.amountMl, amountMl) || other.amountMl == amountMl)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.nextDueAt, nextDueAt) || other.nextDueAt == nextDueAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,rawType,every,unit,rawUnit,amountMl,enabled,nextDueAt);

@override
String toString() {
  return 'PlantCareSchedule(type: $type, rawType: $rawType, every: $every, unit: $unit, rawUnit: $rawUnit, amountMl: $amountMl, enabled: $enabled, nextDueAt: $nextDueAt)';
}


}

/// @nodoc
abstract mixin class _$PlantCareScheduleCopyWith<$Res> implements $PlantCareScheduleCopyWith<$Res> {
  factory _$PlantCareScheduleCopyWith(_PlantCareSchedule value, $Res Function(_PlantCareSchedule) _then) = __$PlantCareScheduleCopyWithImpl;
@override @useResult
$Res call({
 CareTaskType type, String rawType, int every, CareScheduleUnit unit, String rawUnit, int? amountMl, bool enabled, DateTime? nextDueAt
});




}
/// @nodoc
class __$PlantCareScheduleCopyWithImpl<$Res>
    implements _$PlantCareScheduleCopyWith<$Res> {
  __$PlantCareScheduleCopyWithImpl(this._self, this._then);

  final _PlantCareSchedule _self;
  final $Res Function(_PlantCareSchedule) _then;

/// Create a copy of PlantCareSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? rawType = null,Object? every = null,Object? unit = null,Object? rawUnit = null,Object? amountMl = freezed,Object? enabled = null,Object? nextDueAt = freezed,}) {
  return _then(_PlantCareSchedule(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareTaskType,rawType: null == rawType ? _self.rawType : rawType // ignore: cast_nullable_to_non_nullable
as String,every: null == every ? _self.every : every // ignore: cast_nullable_to_non_nullable
as int,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as CareScheduleUnit,rawUnit: null == rawUnit ? _self.rawUnit : rawUnit // ignore: cast_nullable_to_non_nullable
as String,amountMl: freezed == amountMl ? _self.amountMl : amountMl // ignore: cast_nullable_to_non_nullable
as int?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,nextDueAt: freezed == nextDueAt ? _self.nextDueAt : nextDueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
