// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleDay {

/// Локальная дата (полночь). Совпадает с серверным ключом `YYYY-MM-DD`.
 DateTime get date;/// Задачи дня (пустой список = день без задач).
 List<CareTask> get tasks;
/// Create a copy of ScheduleDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDayCopyWith<ScheduleDay> get copyWith => _$ScheduleDayCopyWithImpl<ScheduleDay>(this as ScheduleDay, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDay&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.tasks, tasks));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(tasks));

@override
String toString() {
  return 'ScheduleDay(date: $date, tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class $ScheduleDayCopyWith<$Res>  {
  factory $ScheduleDayCopyWith(ScheduleDay value, $Res Function(ScheduleDay) _then) = _$ScheduleDayCopyWithImpl;
@useResult
$Res call({
 DateTime date, List<CareTask> tasks
});




}
/// @nodoc
class _$ScheduleDayCopyWithImpl<$Res>
    implements $ScheduleDayCopyWith<$Res> {
  _$ScheduleDayCopyWithImpl(this._self, this._then);

  final ScheduleDay _self;
  final $Res Function(ScheduleDay) _then;

/// Create a copy of ScheduleDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? tasks = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<CareTask>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDay].
extension ScheduleDayPatterns on ScheduleDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDay value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDay value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  List<CareTask> tasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDay() when $default != null:
return $default(_that.date,_that.tasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  List<CareTask> tasks)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDay():
return $default(_that.date,_that.tasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  List<CareTask> tasks)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDay() when $default != null:
return $default(_that.date,_that.tasks);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleDay implements ScheduleDay {
  const _ScheduleDay({required this.date, required final  List<CareTask> tasks}): _tasks = tasks;
  

/// Локальная дата (полночь). Совпадает с серверным ключом `YYYY-MM-DD`.
@override final  DateTime date;
/// Задачи дня (пустой список = день без задач).
 final  List<CareTask> _tasks;
/// Задачи дня (пустой список = день без задач).
@override List<CareTask> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}


/// Create a copy of ScheduleDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDayCopyWith<_ScheduleDay> get copyWith => __$ScheduleDayCopyWithImpl<_ScheduleDay>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDay&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._tasks, _tasks));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_tasks));

@override
String toString() {
  return 'ScheduleDay(date: $date, tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDayCopyWith<$Res> implements $ScheduleDayCopyWith<$Res> {
  factory _$ScheduleDayCopyWith(_ScheduleDay value, $Res Function(_ScheduleDay) _then) = __$ScheduleDayCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, List<CareTask> tasks
});




}
/// @nodoc
class __$ScheduleDayCopyWithImpl<$Res>
    implements _$ScheduleDayCopyWith<$Res> {
  __$ScheduleDayCopyWithImpl(this._self, this._then);

  final _ScheduleDay _self;
  final $Res Function(_ScheduleDay) _then;

/// Create a copy of ScheduleDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? tasks = null,}) {
  return _then(_ScheduleDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<CareTask>,
  ));
}


}

// dart format on
