// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherSnapshot {

/// `true`, если данные погоды доступны (источник настроен и ответил).
/// При `false` остальные поля — `null`.
 bool get available;/// Относительная влажность воздуха [0, 100]. `null`, если не [available].
 int? get humidityPercent;/// Рекомендация backend по поливу. `null`, если не [available].
 WateringRecommendation? get recommendation;/// Момент получения данных от источника (UTC). `null`, если не [available].
 DateTime? get fetchedAt;/// `true`, если снапшот отдан из серверного кеша (~60 мин). `null`, если
/// не [available].
 bool? get fromCache;
/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherSnapshotCopyWith<WeatherSnapshot> get copyWith => _$WeatherSnapshotCopyWithImpl<WeatherSnapshot>(this as WeatherSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherSnapshot&&(identical(other.available, available) || other.available == available)&&(identical(other.humidityPercent, humidityPercent) || other.humidityPercent == humidityPercent)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache));
}


@override
int get hashCode => Object.hash(runtimeType,available,humidityPercent,recommendation,fetchedAt,fromCache);

@override
String toString() {
  return 'WeatherSnapshot(available: $available, humidityPercent: $humidityPercent, recommendation: $recommendation, fetchedAt: $fetchedAt, fromCache: $fromCache)';
}


}

/// @nodoc
abstract mixin class $WeatherSnapshotCopyWith<$Res>  {
  factory $WeatherSnapshotCopyWith(WeatherSnapshot value, $Res Function(WeatherSnapshot) _then) = _$WeatherSnapshotCopyWithImpl;
@useResult
$Res call({
 bool available, int? humidityPercent, WateringRecommendation? recommendation, DateTime? fetchedAt, bool? fromCache
});




}
/// @nodoc
class _$WeatherSnapshotCopyWithImpl<$Res>
    implements $WeatherSnapshotCopyWith<$Res> {
  _$WeatherSnapshotCopyWithImpl(this._self, this._then);

  final WeatherSnapshot _self;
  final $Res Function(WeatherSnapshot) _then;

/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? humidityPercent = freezed,Object? recommendation = freezed,Object? fetchedAt = freezed,Object? fromCache = freezed,}) {
  return _then(_self.copyWith(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,humidityPercent: freezed == humidityPercent ? _self.humidityPercent : humidityPercent // ignore: cast_nullable_to_non_nullable
as int?,recommendation: freezed == recommendation ? _self.recommendation : recommendation // ignore: cast_nullable_to_non_nullable
as WateringRecommendation?,fetchedAt: freezed == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fromCache: freezed == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherSnapshot].
extension WeatherSnapshotPatterns on WeatherSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _WeatherSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool available,  int? humidityPercent,  WateringRecommendation? recommendation,  DateTime? fetchedAt,  bool? fromCache)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherSnapshot() when $default != null:
return $default(_that.available,_that.humidityPercent,_that.recommendation,_that.fetchedAt,_that.fromCache);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool available,  int? humidityPercent,  WateringRecommendation? recommendation,  DateTime? fetchedAt,  bool? fromCache)  $default,) {final _that = this;
switch (_that) {
case _WeatherSnapshot():
return $default(_that.available,_that.humidityPercent,_that.recommendation,_that.fetchedAt,_that.fromCache);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool available,  int? humidityPercent,  WateringRecommendation? recommendation,  DateTime? fetchedAt,  bool? fromCache)?  $default,) {final _that = this;
switch (_that) {
case _WeatherSnapshot() when $default != null:
return $default(_that.available,_that.humidityPercent,_that.recommendation,_that.fetchedAt,_that.fromCache);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherSnapshot extends WeatherSnapshot {
  const _WeatherSnapshot({required this.available, this.humidityPercent, this.recommendation, this.fetchedAt, this.fromCache}): super._();
  

/// `true`, если данные погоды доступны (источник настроен и ответил).
/// При `false` остальные поля — `null`.
@override final  bool available;
/// Относительная влажность воздуха [0, 100]. `null`, если не [available].
@override final  int? humidityPercent;
/// Рекомендация backend по поливу. `null`, если не [available].
@override final  WateringRecommendation? recommendation;
/// Момент получения данных от источника (UTC). `null`, если не [available].
@override final  DateTime? fetchedAt;
/// `true`, если снапшот отдан из серверного кеша (~60 мин). `null`, если
/// не [available].
@override final  bool? fromCache;

/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherSnapshotCopyWith<_WeatherSnapshot> get copyWith => __$WeatherSnapshotCopyWithImpl<_WeatherSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherSnapshot&&(identical(other.available, available) || other.available == available)&&(identical(other.humidityPercent, humidityPercent) || other.humidityPercent == humidityPercent)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache));
}


@override
int get hashCode => Object.hash(runtimeType,available,humidityPercent,recommendation,fetchedAt,fromCache);

@override
String toString() {
  return 'WeatherSnapshot(available: $available, humidityPercent: $humidityPercent, recommendation: $recommendation, fetchedAt: $fetchedAt, fromCache: $fromCache)';
}


}

/// @nodoc
abstract mixin class _$WeatherSnapshotCopyWith<$Res> implements $WeatherSnapshotCopyWith<$Res> {
  factory _$WeatherSnapshotCopyWith(_WeatherSnapshot value, $Res Function(_WeatherSnapshot) _then) = __$WeatherSnapshotCopyWithImpl;
@override @useResult
$Res call({
 bool available, int? humidityPercent, WateringRecommendation? recommendation, DateTime? fetchedAt, bool? fromCache
});




}
/// @nodoc
class __$WeatherSnapshotCopyWithImpl<$Res>
    implements _$WeatherSnapshotCopyWith<$Res> {
  __$WeatherSnapshotCopyWithImpl(this._self, this._then);

  final _WeatherSnapshot _self;
  final $Res Function(_WeatherSnapshot) _then;

/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? available = null,Object? humidityPercent = freezed,Object? recommendation = freezed,Object? fetchedAt = freezed,Object? fromCache = freezed,}) {
  return _then(_WeatherSnapshot(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,humidityPercent: freezed == humidityPercent ? _self.humidityPercent : humidityPercent // ignore: cast_nullable_to_non_nullable
as int?,recommendation: freezed == recommendation ? _self.recommendation : recommendation // ignore: cast_nullable_to_non_nullable
as WateringRecommendation?,fetchedAt: freezed == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fromCache: freezed == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
