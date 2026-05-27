// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_week.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleWeek {

/// Понедельник недели (локальная полночь) — совпадает с `days.first.date`.
 DateTime get weekStart;/// Ровно 7 дней, Пн→Вс. Дни без задач = `ScheduleDay` с пустым `tasks`.
 List<ScheduleDay> get days;
/// Create a copy of ScheduleWeek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleWeekCopyWith<ScheduleWeek> get copyWith => _$ScheduleWeekCopyWithImpl<ScheduleWeek>(this as ScheduleWeek, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleWeek&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&const DeepCollectionEquality().equals(other.days, days));
}


@override
int get hashCode => Object.hash(runtimeType,weekStart,const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'ScheduleWeek(weekStart: $weekStart, days: $days)';
}


}

/// @nodoc
abstract mixin class $ScheduleWeekCopyWith<$Res>  {
  factory $ScheduleWeekCopyWith(ScheduleWeek value, $Res Function(ScheduleWeek) _then) = _$ScheduleWeekCopyWithImpl;
@useResult
$Res call({
 DateTime weekStart, List<ScheduleDay> days
});




}
/// @nodoc
class _$ScheduleWeekCopyWithImpl<$Res>
    implements $ScheduleWeekCopyWith<$Res> {
  _$ScheduleWeekCopyWithImpl(this._self, this._then);

  final ScheduleWeek _self;
  final $Res Function(ScheduleWeek) _then;

/// Create a copy of ScheduleWeek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStart = null,Object? days = null,}) {
  return _then(_self.copyWith(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<ScheduleDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleWeek].
extension ScheduleWeekPatterns on ScheduleWeek {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleWeek value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleWeek() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleWeek value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleWeek():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleWeek value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleWeek() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime weekStart,  List<ScheduleDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleWeek() when $default != null:
return $default(_that.weekStart,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime weekStart,  List<ScheduleDay> days)  $default,) {final _that = this;
switch (_that) {
case _ScheduleWeek():
return $default(_that.weekStart,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime weekStart,  List<ScheduleDay> days)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleWeek() when $default != null:
return $default(_that.weekStart,_that.days);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleWeek implements ScheduleWeek {
  const _ScheduleWeek({required this.weekStart, required final  List<ScheduleDay> days}): _days = days;
  

/// Понедельник недели (локальная полночь) — совпадает с `days.first.date`.
@override final  DateTime weekStart;
/// Ровно 7 дней, Пн→Вс. Дни без задач = `ScheduleDay` с пустым `tasks`.
 final  List<ScheduleDay> _days;
/// Ровно 7 дней, Пн→Вс. Дни без задач = `ScheduleDay` с пустым `tasks`.
@override List<ScheduleDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of ScheduleWeek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleWeekCopyWith<_ScheduleWeek> get copyWith => __$ScheduleWeekCopyWithImpl<_ScheduleWeek>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleWeek&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&const DeepCollectionEquality().equals(other._days, _days));
}


@override
int get hashCode => Object.hash(runtimeType,weekStart,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'ScheduleWeek(weekStart: $weekStart, days: $days)';
}


}

/// @nodoc
abstract mixin class _$ScheduleWeekCopyWith<$Res> implements $ScheduleWeekCopyWith<$Res> {
  factory _$ScheduleWeekCopyWith(_ScheduleWeek value, $Res Function(_ScheduleWeek) _then) = __$ScheduleWeekCopyWithImpl;
@override @useResult
$Res call({
 DateTime weekStart, List<ScheduleDay> days
});




}
/// @nodoc
class __$ScheduleWeekCopyWithImpl<$Res>
    implements _$ScheduleWeekCopyWith<$Res> {
  __$ScheduleWeekCopyWithImpl(this._self, this._then);

  final _ScheduleWeek _self;
  final $Res Function(_ScheduleWeek) _then;

/// Create a copy of ScheduleWeek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStart = null,Object? days = null,}) {
  return _then(_ScheduleWeek(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<ScheduleDay>,
  ));
}


}

// dart format on
