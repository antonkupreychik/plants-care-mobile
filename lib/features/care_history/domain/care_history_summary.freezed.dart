// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_history_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareHistorySummary {

/// Всего записей истории (из `PlantHistoryResponse.total`).
 int get total;/// Сколько из ЗАГРУЖЕННЫХ записей выполнено «вовремя» (`onTime == true`).
 int get onTimeCount;/// Сколько записей реально загружено (база для [onTimePercent]).
 int get loadedCount;/// Текущий стрик on-time-уходов подряд (посчитан backend, `Streak.count`).
 int get streakCount;
/// Create a copy of CareHistorySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareHistorySummaryCopyWith<CareHistorySummary> get copyWith => _$CareHistorySummaryCopyWithImpl<CareHistorySummary>(this as CareHistorySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareHistorySummary&&(identical(other.total, total) || other.total == total)&&(identical(other.onTimeCount, onTimeCount) || other.onTimeCount == onTimeCount)&&(identical(other.loadedCount, loadedCount) || other.loadedCount == loadedCount)&&(identical(other.streakCount, streakCount) || other.streakCount == streakCount));
}


@override
int get hashCode => Object.hash(runtimeType,total,onTimeCount,loadedCount,streakCount);

@override
String toString() {
  return 'CareHistorySummary(total: $total, onTimeCount: $onTimeCount, loadedCount: $loadedCount, streakCount: $streakCount)';
}


}

/// @nodoc
abstract mixin class $CareHistorySummaryCopyWith<$Res>  {
  factory $CareHistorySummaryCopyWith(CareHistorySummary value, $Res Function(CareHistorySummary) _then) = _$CareHistorySummaryCopyWithImpl;
@useResult
$Res call({
 int total, int onTimeCount, int loadedCount, int streakCount
});




}
/// @nodoc
class _$CareHistorySummaryCopyWithImpl<$Res>
    implements $CareHistorySummaryCopyWith<$Res> {
  _$CareHistorySummaryCopyWithImpl(this._self, this._then);

  final CareHistorySummary _self;
  final $Res Function(CareHistorySummary) _then;

/// Create a copy of CareHistorySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? onTimeCount = null,Object? loadedCount = null,Object? streakCount = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,onTimeCount: null == onTimeCount ? _self.onTimeCount : onTimeCount // ignore: cast_nullable_to_non_nullable
as int,loadedCount: null == loadedCount ? _self.loadedCount : loadedCount // ignore: cast_nullable_to_non_nullable
as int,streakCount: null == streakCount ? _self.streakCount : streakCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CareHistorySummary].
extension CareHistorySummaryPatterns on CareHistorySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareHistorySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareHistorySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareHistorySummary value)  $default,){
final _that = this;
switch (_that) {
case _CareHistorySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareHistorySummary value)?  $default,){
final _that = this;
switch (_that) {
case _CareHistorySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int onTimeCount,  int loadedCount,  int streakCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareHistorySummary() when $default != null:
return $default(_that.total,_that.onTimeCount,_that.loadedCount,_that.streakCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int onTimeCount,  int loadedCount,  int streakCount)  $default,) {final _that = this;
switch (_that) {
case _CareHistorySummary():
return $default(_that.total,_that.onTimeCount,_that.loadedCount,_that.streakCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int onTimeCount,  int loadedCount,  int streakCount)?  $default,) {final _that = this;
switch (_that) {
case _CareHistorySummary() when $default != null:
return $default(_that.total,_that.onTimeCount,_that.loadedCount,_that.streakCount);case _:
  return null;

}
}

}

/// @nodoc


class _CareHistorySummary extends CareHistorySummary {
  const _CareHistorySummary({required this.total, required this.onTimeCount, required this.loadedCount, required this.streakCount}): super._();
  

/// Всего записей истории (из `PlantHistoryResponse.total`).
@override final  int total;
/// Сколько из ЗАГРУЖЕННЫХ записей выполнено «вовремя» (`onTime == true`).
@override final  int onTimeCount;
/// Сколько записей реально загружено (база для [onTimePercent]).
@override final  int loadedCount;
/// Текущий стрик on-time-уходов подряд (посчитан backend, `Streak.count`).
@override final  int streakCount;

/// Create a copy of CareHistorySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareHistorySummaryCopyWith<_CareHistorySummary> get copyWith => __$CareHistorySummaryCopyWithImpl<_CareHistorySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareHistorySummary&&(identical(other.total, total) || other.total == total)&&(identical(other.onTimeCount, onTimeCount) || other.onTimeCount == onTimeCount)&&(identical(other.loadedCount, loadedCount) || other.loadedCount == loadedCount)&&(identical(other.streakCount, streakCount) || other.streakCount == streakCount));
}


@override
int get hashCode => Object.hash(runtimeType,total,onTimeCount,loadedCount,streakCount);

@override
String toString() {
  return 'CareHistorySummary(total: $total, onTimeCount: $onTimeCount, loadedCount: $loadedCount, streakCount: $streakCount)';
}


}

/// @nodoc
abstract mixin class _$CareHistorySummaryCopyWith<$Res> implements $CareHistorySummaryCopyWith<$Res> {
  factory _$CareHistorySummaryCopyWith(_CareHistorySummary value, $Res Function(_CareHistorySummary) _then) = __$CareHistorySummaryCopyWithImpl;
@override @useResult
$Res call({
 int total, int onTimeCount, int loadedCount, int streakCount
});




}
/// @nodoc
class __$CareHistorySummaryCopyWithImpl<$Res>
    implements _$CareHistorySummaryCopyWith<$Res> {
  __$CareHistorySummaryCopyWithImpl(this._self, this._then);

  final _CareHistorySummary _self;
  final $Res Function(_CareHistorySummary) _then;

/// Create a copy of CareHistorySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? onTimeCount = null,Object? loadedCount = null,Object? streakCount = null,}) {
  return _then(_CareHistorySummary(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,onTimeCount: null == onTimeCount ? _self.onTimeCount : onTimeCount // ignore: cast_nullable_to_non_nullable
as int,loadedCount: null == loadedCount ? _self.loadedCount : loadedCount // ignore: cast_nullable_to_non_nullable
as int,streakCount: null == streakCount ? _self.streakCount : streakCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
