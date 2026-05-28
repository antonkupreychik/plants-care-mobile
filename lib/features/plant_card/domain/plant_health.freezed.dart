// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_health.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantHealth {

/// Индекс здоровья в диапазоне [0, 100].
 int get score;/// Зона здоровья (цвет), производная от [score].
 HealthZone get zone;/// `true`, если данных для достоверной оценки недостаточно. Тогда UI рисует
/// нейтральное состояние («—»), а не подаёт [score] как точную метрику.
 bool get insufficientData;
/// Create a copy of PlantHealth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantHealthCopyWith<PlantHealth> get copyWith => _$PlantHealthCopyWithImpl<PlantHealth>(this as PlantHealth, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantHealth&&(identical(other.score, score) || other.score == score)&&(identical(other.zone, zone) || other.zone == zone)&&(identical(other.insufficientData, insufficientData) || other.insufficientData == insufficientData));
}


@override
int get hashCode => Object.hash(runtimeType,score,zone,insufficientData);

@override
String toString() {
  return 'PlantHealth(score: $score, zone: $zone, insufficientData: $insufficientData)';
}


}

/// @nodoc
abstract mixin class $PlantHealthCopyWith<$Res>  {
  factory $PlantHealthCopyWith(PlantHealth value, $Res Function(PlantHealth) _then) = _$PlantHealthCopyWithImpl;
@useResult
$Res call({
 int score, HealthZone zone, bool insufficientData
});




}
/// @nodoc
class _$PlantHealthCopyWithImpl<$Res>
    implements $PlantHealthCopyWith<$Res> {
  _$PlantHealthCopyWithImpl(this._self, this._then);

  final PlantHealth _self;
  final $Res Function(PlantHealth) _then;

/// Create a copy of PlantHealth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? zone = null,Object? insufficientData = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,zone: null == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as HealthZone,insufficientData: null == insufficientData ? _self.insufficientData : insufficientData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantHealth].
extension PlantHealthPatterns on PlantHealth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantHealth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantHealth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantHealth value)  $default,){
final _that = this;
switch (_that) {
case _PlantHealth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantHealth value)?  $default,){
final _that = this;
switch (_that) {
case _PlantHealth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  HealthZone zone,  bool insufficientData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantHealth() when $default != null:
return $default(_that.score,_that.zone,_that.insufficientData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  HealthZone zone,  bool insufficientData)  $default,) {final _that = this;
switch (_that) {
case _PlantHealth():
return $default(_that.score,_that.zone,_that.insufficientData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  HealthZone zone,  bool insufficientData)?  $default,) {final _that = this;
switch (_that) {
case _PlantHealth() when $default != null:
return $default(_that.score,_that.zone,_that.insufficientData);case _:
  return null;

}
}

}

/// @nodoc


class _PlantHealth extends PlantHealth {
  const _PlantHealth({required this.score, required this.zone, required this.insufficientData}): super._();
  

/// Индекс здоровья в диапазоне [0, 100].
@override final  int score;
/// Зона здоровья (цвет), производная от [score].
@override final  HealthZone zone;
/// `true`, если данных для достоверной оценки недостаточно. Тогда UI рисует
/// нейтральное состояние («—»), а не подаёт [score] как точную метрику.
@override final  bool insufficientData;

/// Create a copy of PlantHealth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantHealthCopyWith<_PlantHealth> get copyWith => __$PlantHealthCopyWithImpl<_PlantHealth>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantHealth&&(identical(other.score, score) || other.score == score)&&(identical(other.zone, zone) || other.zone == zone)&&(identical(other.insufficientData, insufficientData) || other.insufficientData == insufficientData));
}


@override
int get hashCode => Object.hash(runtimeType,score,zone,insufficientData);

@override
String toString() {
  return 'PlantHealth(score: $score, zone: $zone, insufficientData: $insufficientData)';
}


}

/// @nodoc
abstract mixin class _$PlantHealthCopyWith<$Res> implements $PlantHealthCopyWith<$Res> {
  factory _$PlantHealthCopyWith(_PlantHealth value, $Res Function(_PlantHealth) _then) = __$PlantHealthCopyWithImpl;
@override @useResult
$Res call({
 int score, HealthZone zone, bool insufficientData
});




}
/// @nodoc
class __$PlantHealthCopyWithImpl<$Res>
    implements _$PlantHealthCopyWith<$Res> {
  __$PlantHealthCopyWithImpl(this._self, this._then);

  final _PlantHealth _self;
  final $Res Function(_PlantHealth) _then;

/// Create a copy of PlantHealth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? zone = null,Object? insufficientData = null,}) {
  return _then(_PlantHealth(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,zone: null == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as HealthZone,insufficientData: null == insufficientData ? _self.insufficientData : insufficientData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
