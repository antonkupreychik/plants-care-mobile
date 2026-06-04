// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_health_bucket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeeklyHealthBucket {

/// ISO-неделя `YYYY-Www` (например, `2026-W19`).
 String get week;/// Выполнено задач за неделю.
 int get done;/// Доля выполненных вовремя [0, 1].
 double get onTimePct;
/// Create a copy of WeeklyHealthBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyHealthBucketCopyWith<WeeklyHealthBucket> get copyWith => _$WeeklyHealthBucketCopyWithImpl<WeeklyHealthBucket>(this as WeeklyHealthBucket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyHealthBucket&&(identical(other.week, week) || other.week == week)&&(identical(other.done, done) || other.done == done)&&(identical(other.onTimePct, onTimePct) || other.onTimePct == onTimePct));
}


@override
int get hashCode => Object.hash(runtimeType,week,done,onTimePct);

@override
String toString() {
  return 'WeeklyHealthBucket(week: $week, done: $done, onTimePct: $onTimePct)';
}


}

/// @nodoc
abstract mixin class $WeeklyHealthBucketCopyWith<$Res>  {
  factory $WeeklyHealthBucketCopyWith(WeeklyHealthBucket value, $Res Function(WeeklyHealthBucket) _then) = _$WeeklyHealthBucketCopyWithImpl;
@useResult
$Res call({
 String week, int done, double onTimePct
});




}
/// @nodoc
class _$WeeklyHealthBucketCopyWithImpl<$Res>
    implements $WeeklyHealthBucketCopyWith<$Res> {
  _$WeeklyHealthBucketCopyWithImpl(this._self, this._then);

  final WeeklyHealthBucket _self;
  final $Res Function(WeeklyHealthBucket) _then;

/// Create a copy of WeeklyHealthBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? week = null,Object? done = null,Object? onTimePct = null,}) {
  return _then(_self.copyWith(
week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,onTimePct: null == onTimePct ? _self.onTimePct : onTimePct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyHealthBucket].
extension WeeklyHealthBucketPatterns on WeeklyHealthBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyHealthBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyHealthBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyHealthBucket value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyHealthBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyHealthBucket value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyHealthBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String week,  int done,  double onTimePct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyHealthBucket() when $default != null:
return $default(_that.week,_that.done,_that.onTimePct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String week,  int done,  double onTimePct)  $default,) {final _that = this;
switch (_that) {
case _WeeklyHealthBucket():
return $default(_that.week,_that.done,_that.onTimePct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String week,  int done,  double onTimePct)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyHealthBucket() when $default != null:
return $default(_that.week,_that.done,_that.onTimePct);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklyHealthBucket implements WeeklyHealthBucket {
  const _WeeklyHealthBucket({required this.week, required this.done, required this.onTimePct});
  

/// ISO-неделя `YYYY-Www` (например, `2026-W19`).
@override final  String week;
/// Выполнено задач за неделю.
@override final  int done;
/// Доля выполненных вовремя [0, 1].
@override final  double onTimePct;

/// Create a copy of WeeklyHealthBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyHealthBucketCopyWith<_WeeklyHealthBucket> get copyWith => __$WeeklyHealthBucketCopyWithImpl<_WeeklyHealthBucket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyHealthBucket&&(identical(other.week, week) || other.week == week)&&(identical(other.done, done) || other.done == done)&&(identical(other.onTimePct, onTimePct) || other.onTimePct == onTimePct));
}


@override
int get hashCode => Object.hash(runtimeType,week,done,onTimePct);

@override
String toString() {
  return 'WeeklyHealthBucket(week: $week, done: $done, onTimePct: $onTimePct)';
}


}

/// @nodoc
abstract mixin class _$WeeklyHealthBucketCopyWith<$Res> implements $WeeklyHealthBucketCopyWith<$Res> {
  factory _$WeeklyHealthBucketCopyWith(_WeeklyHealthBucket value, $Res Function(_WeeklyHealthBucket) _then) = __$WeeklyHealthBucketCopyWithImpl;
@override @useResult
$Res call({
 String week, int done, double onTimePct
});




}
/// @nodoc
class __$WeeklyHealthBucketCopyWithImpl<$Res>
    implements _$WeeklyHealthBucketCopyWith<$Res> {
  __$WeeklyHealthBucketCopyWithImpl(this._self, this._then);

  final _WeeklyHealthBucket _self;
  final $Res Function(_WeeklyHealthBucket) _then;

/// Create a copy of WeeklyHealthBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? week = null,Object? done = null,Object? onTimePct = null,}) {
  return _then(_WeeklyHealthBucket(
week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,onTimePct: null == onTimePct ? _self.onTimePct : onTimePct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
