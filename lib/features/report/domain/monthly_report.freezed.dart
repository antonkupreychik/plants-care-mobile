// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyReport {

/// Месяц отчёта `YYYY-MM` (например, `2026-05`).
 String get month;/// Всего выполненных задач ухода за месяц.
 int get done;/// Всего просроченных (невыполненных в срок) задач за месяц.
 int get overdue;/// Разбивка выполненных задач по типу ухода. Ключ — доменный
/// [CareTaskType] (нераспознанные backend-коды отброшены маппером).
 Map<CareTaskType, int> get byType;/// Текущий стрик (выполнений вовремя подряд).
 int get streak;/// Понедельный тренд за месяц (выполнено + доля вовремя).
 List<WeeklyHealthBucket> get healthTrend;
/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<MonthlyReport> get copyWith => _$MonthlyReportCopyWithImpl<MonthlyReport>(this as MonthlyReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyReport&&(identical(other.month, month) || other.month == month)&&(identical(other.done, done) || other.done == done)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&const DeepCollectionEquality().equals(other.byType, byType)&&(identical(other.streak, streak) || other.streak == streak)&&const DeepCollectionEquality().equals(other.healthTrend, healthTrend));
}


@override
int get hashCode => Object.hash(runtimeType,month,done,overdue,const DeepCollectionEquality().hash(byType),streak,const DeepCollectionEquality().hash(healthTrend));

@override
String toString() {
  return 'MonthlyReport(month: $month, done: $done, overdue: $overdue, byType: $byType, streak: $streak, healthTrend: $healthTrend)';
}


}

/// @nodoc
abstract mixin class $MonthlyReportCopyWith<$Res>  {
  factory $MonthlyReportCopyWith(MonthlyReport value, $Res Function(MonthlyReport) _then) = _$MonthlyReportCopyWithImpl;
@useResult
$Res call({
 String month, int done, int overdue, Map<CareTaskType, int> byType, int streak, List<WeeklyHealthBucket> healthTrend
});




}
/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._self, this._then);

  final MonthlyReport _self;
  final $Res Function(MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? done = null,Object? overdue = null,Object? byType = null,Object? streak = null,Object? healthTrend = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,byType: null == byType ? _self.byType : byType // ignore: cast_nullable_to_non_nullable
as Map<CareTaskType, int>,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,healthTrend: null == healthTrend ? _self.healthTrend : healthTrend // ignore: cast_nullable_to_non_nullable
as List<WeeklyHealthBucket>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyReport].
extension MonthlyReportPatterns on MonthlyReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyReport value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyReport value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month,  int done,  int overdue,  Map<CareTaskType, int> byType,  int streak,  List<WeeklyHealthBucket> healthTrend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.month,_that.done,_that.overdue,_that.byType,_that.streak,_that.healthTrend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month,  int done,  int overdue,  Map<CareTaskType, int> byType,  int streak,  List<WeeklyHealthBucket> healthTrend)  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport():
return $default(_that.month,_that.done,_that.overdue,_that.byType,_that.streak,_that.healthTrend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month,  int done,  int overdue,  Map<CareTaskType, int> byType,  int streak,  List<WeeklyHealthBucket> healthTrend)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.month,_that.done,_that.overdue,_that.byType,_that.streak,_that.healthTrend);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyReport extends MonthlyReport {
  const _MonthlyReport({required this.month, required this.done, required this.overdue, required final  Map<CareTaskType, int> byType, required this.streak, required final  List<WeeklyHealthBucket> healthTrend}): _byType = byType,_healthTrend = healthTrend,super._();
  

/// Месяц отчёта `YYYY-MM` (например, `2026-05`).
@override final  String month;
/// Всего выполненных задач ухода за месяц.
@override final  int done;
/// Всего просроченных (невыполненных в срок) задач за месяц.
@override final  int overdue;
/// Разбивка выполненных задач по типу ухода. Ключ — доменный
/// [CareTaskType] (нераспознанные backend-коды отброшены маппером).
 final  Map<CareTaskType, int> _byType;
/// Разбивка выполненных задач по типу ухода. Ключ — доменный
/// [CareTaskType] (нераспознанные backend-коды отброшены маппером).
@override Map<CareTaskType, int> get byType {
  if (_byType is EqualUnmodifiableMapView) return _byType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byType);
}

/// Текущий стрик (выполнений вовремя подряд).
@override final  int streak;
/// Понедельный тренд за месяц (выполнено + доля вовремя).
 final  List<WeeklyHealthBucket> _healthTrend;
/// Понедельный тренд за месяц (выполнено + доля вовремя).
@override List<WeeklyHealthBucket> get healthTrend {
  if (_healthTrend is EqualUnmodifiableListView) return _healthTrend;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_healthTrend);
}


/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyReportCopyWith<_MonthlyReport> get copyWith => __$MonthlyReportCopyWithImpl<_MonthlyReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyReport&&(identical(other.month, month) || other.month == month)&&(identical(other.done, done) || other.done == done)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&const DeepCollectionEquality().equals(other._byType, _byType)&&(identical(other.streak, streak) || other.streak == streak)&&const DeepCollectionEquality().equals(other._healthTrend, _healthTrend));
}


@override
int get hashCode => Object.hash(runtimeType,month,done,overdue,const DeepCollectionEquality().hash(_byType),streak,const DeepCollectionEquality().hash(_healthTrend));

@override
String toString() {
  return 'MonthlyReport(month: $month, done: $done, overdue: $overdue, byType: $byType, streak: $streak, healthTrend: $healthTrend)';
}


}

/// @nodoc
abstract mixin class _$MonthlyReportCopyWith<$Res> implements $MonthlyReportCopyWith<$Res> {
  factory _$MonthlyReportCopyWith(_MonthlyReport value, $Res Function(_MonthlyReport) _then) = __$MonthlyReportCopyWithImpl;
@override @useResult
$Res call({
 String month, int done, int overdue, Map<CareTaskType, int> byType, int streak, List<WeeklyHealthBucket> healthTrend
});




}
/// @nodoc
class __$MonthlyReportCopyWithImpl<$Res>
    implements _$MonthlyReportCopyWith<$Res> {
  __$MonthlyReportCopyWithImpl(this._self, this._then);

  final _MonthlyReport _self;
  final $Res Function(_MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? done = null,Object? overdue = null,Object? byType = null,Object? streak = null,Object? healthTrend = null,}) {
  return _then(_MonthlyReport(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,byType: null == byType ? _self._byType : byType // ignore: cast_nullable_to_non_nullable
as Map<CareTaskType, int>,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,healthTrend: null == healthTrend ? _self._healthTrend : healthTrend // ignore: cast_nullable_to_non_nullable
as List<WeeklyHealthBucket>,
  ));
}


}

// dart format on
