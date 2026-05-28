// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareTask {

/// Идентификатор расписания, породившего задачу (`TaskDto.scheduleId`).
 int get scheduleId;/// Растение, к которому относится задача.
 int get plantId; String get plantName;/// Нормализованный тип ухода (см. [CareTaskType]).
 CareTaskType get type;/// Дедлайн задачи в UTC.
 DateTime get dueAt;/// Денормализованное имя локации (если backend прислал).
 String? get locationName;/// Идентификатор вида растения (`Species.id`).
///
/// Нужен UI для выбора SVG-иллюстрации (BACKEND-GAPS G6). Nullable:
/// у растения может не быть привязанного вида.
 int? get speciesId;/// Имя вида растения (для иллюстрации/подписи в UI, G6). Nullable.
 String? get speciesName;
/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareTaskCopyWith<CareTask> get copyWith => _$CareTaskCopyWithImpl<CareTask>(this as CareTask, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareTask&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.plantName, plantName) || other.plantName == plantName)&&(identical(other.type, type) || other.type == type)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.speciesId, speciesId) || other.speciesId == speciesId)&&(identical(other.speciesName, speciesName) || other.speciesName == speciesName));
}


@override
int get hashCode => Object.hash(runtimeType,scheduleId,plantId,plantName,type,dueAt,locationName,speciesId,speciesName);

@override
String toString() {
  return 'CareTask(scheduleId: $scheduleId, plantId: $plantId, plantName: $plantName, type: $type, dueAt: $dueAt, locationName: $locationName, speciesId: $speciesId, speciesName: $speciesName)';
}


}

/// @nodoc
abstract mixin class $CareTaskCopyWith<$Res>  {
  factory $CareTaskCopyWith(CareTask value, $Res Function(CareTask) _then) = _$CareTaskCopyWithImpl;
@useResult
$Res call({
 int scheduleId, int plantId, String plantName, CareTaskType type, DateTime dueAt, String? locationName, int? speciesId, String? speciesName
});




}
/// @nodoc
class _$CareTaskCopyWithImpl<$Res>
    implements $CareTaskCopyWith<$Res> {
  _$CareTaskCopyWithImpl(this._self, this._then);

  final CareTask _self;
  final $Res Function(CareTask) _then;

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleId = null,Object? plantId = null,Object? plantName = null,Object? type = null,Object? dueAt = null,Object? locationName = freezed,Object? speciesId = freezed,Object? speciesName = freezed,}) {
  return _then(_self.copyWith(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,plantName: null == plantName ? _self.plantName : plantName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareTaskType,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,speciesId: freezed == speciesId ? _self.speciesId : speciesId // ignore: cast_nullable_to_non_nullable
as int?,speciesName: freezed == speciesName ? _self.speciesName : speciesName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CareTask].
extension CareTaskPatterns on CareTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareTask value)  $default,){
final _that = this;
switch (_that) {
case _CareTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareTask value)?  $default,){
final _that = this;
switch (_that) {
case _CareTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scheduleId,  int plantId,  String plantName,  CareTaskType type,  DateTime dueAt,  String? locationName,  int? speciesId,  String? speciesName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareTask() when $default != null:
return $default(_that.scheduleId,_that.plantId,_that.plantName,_that.type,_that.dueAt,_that.locationName,_that.speciesId,_that.speciesName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scheduleId,  int plantId,  String plantName,  CareTaskType type,  DateTime dueAt,  String? locationName,  int? speciesId,  String? speciesName)  $default,) {final _that = this;
switch (_that) {
case _CareTask():
return $default(_that.scheduleId,_that.plantId,_that.plantName,_that.type,_that.dueAt,_that.locationName,_that.speciesId,_that.speciesName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scheduleId,  int plantId,  String plantName,  CareTaskType type,  DateTime dueAt,  String? locationName,  int? speciesId,  String? speciesName)?  $default,) {final _that = this;
switch (_that) {
case _CareTask() when $default != null:
return $default(_that.scheduleId,_that.plantId,_that.plantName,_that.type,_that.dueAt,_that.locationName,_that.speciesId,_that.speciesName);case _:
  return null;

}
}

}

/// @nodoc


class _CareTask implements CareTask {
  const _CareTask({required this.scheduleId, required this.plantId, required this.plantName, required this.type, required this.dueAt, this.locationName, this.speciesId, this.speciesName});
  

/// Идентификатор расписания, породившего задачу (`TaskDto.scheduleId`).
@override final  int scheduleId;
/// Растение, к которому относится задача.
@override final  int plantId;
@override final  String plantName;
/// Нормализованный тип ухода (см. [CareTaskType]).
@override final  CareTaskType type;
/// Дедлайн задачи в UTC.
@override final  DateTime dueAt;
/// Денормализованное имя локации (если backend прислал).
@override final  String? locationName;
/// Идентификатор вида растения (`Species.id`).
///
/// Нужен UI для выбора SVG-иллюстрации (BACKEND-GAPS G6). Nullable:
/// у растения может не быть привязанного вида.
@override final  int? speciesId;
/// Имя вида растения (для иллюстрации/подписи в UI, G6). Nullable.
@override final  String? speciesName;

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareTaskCopyWith<_CareTask> get copyWith => __$CareTaskCopyWithImpl<_CareTask>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareTask&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.plantName, plantName) || other.plantName == plantName)&&(identical(other.type, type) || other.type == type)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.speciesId, speciesId) || other.speciesId == speciesId)&&(identical(other.speciesName, speciesName) || other.speciesName == speciesName));
}


@override
int get hashCode => Object.hash(runtimeType,scheduleId,plantId,plantName,type,dueAt,locationName,speciesId,speciesName);

@override
String toString() {
  return 'CareTask(scheduleId: $scheduleId, plantId: $plantId, plantName: $plantName, type: $type, dueAt: $dueAt, locationName: $locationName, speciesId: $speciesId, speciesName: $speciesName)';
}


}

/// @nodoc
abstract mixin class _$CareTaskCopyWith<$Res> implements $CareTaskCopyWith<$Res> {
  factory _$CareTaskCopyWith(_CareTask value, $Res Function(_CareTask) _then) = __$CareTaskCopyWithImpl;
@override @useResult
$Res call({
 int scheduleId, int plantId, String plantName, CareTaskType type, DateTime dueAt, String? locationName, int? speciesId, String? speciesName
});




}
/// @nodoc
class __$CareTaskCopyWithImpl<$Res>
    implements _$CareTaskCopyWith<$Res> {
  __$CareTaskCopyWithImpl(this._self, this._then);

  final _CareTask _self;
  final $Res Function(_CareTask) _then;

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleId = null,Object? plantId = null,Object? plantName = null,Object? type = null,Object? dueAt = null,Object? locationName = freezed,Object? speciesId = freezed,Object? speciesName = freezed,}) {
  return _then(_CareTask(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,plantName: null == plantName ? _self.plantName : plantName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareTaskType,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,speciesId: freezed == speciesId ? _self.speciesId : speciesId // ignore: cast_nullable_to_non_nullable
as int?,speciesName: freezed == speciesName ? _self.speciesName : speciesName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
