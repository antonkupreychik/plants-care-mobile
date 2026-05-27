// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeciesSummary {

 int get id; String get name; String? get latinName;/// Рекомендуемые интервалы ухода в днях (null/0 — рекомендации нет).
 int? get wateringDays; int? get mistingDays; int? get fertilizingDays; int? get soilCheckDays; CareDifficulty get careDifficulty;/// Предпочтение по свету как пришло с backend (`LightPreference.name()`).
 String? get lightPreference;
/// Create a copy of SpeciesSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeciesSummaryCopyWith<SpeciesSummary> get copyWith => _$SpeciesSummaryCopyWithImpl<SpeciesSummary>(this as SpeciesSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeciesSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latinName, latinName) || other.latinName == latinName)&&(identical(other.wateringDays, wateringDays) || other.wateringDays == wateringDays)&&(identical(other.mistingDays, mistingDays) || other.mistingDays == mistingDays)&&(identical(other.fertilizingDays, fertilizingDays) || other.fertilizingDays == fertilizingDays)&&(identical(other.soilCheckDays, soilCheckDays) || other.soilCheckDays == soilCheckDays)&&(identical(other.careDifficulty, careDifficulty) || other.careDifficulty == careDifficulty)&&(identical(other.lightPreference, lightPreference) || other.lightPreference == lightPreference));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,latinName,wateringDays,mistingDays,fertilizingDays,soilCheckDays,careDifficulty,lightPreference);

@override
String toString() {
  return 'SpeciesSummary(id: $id, name: $name, latinName: $latinName, wateringDays: $wateringDays, mistingDays: $mistingDays, fertilizingDays: $fertilizingDays, soilCheckDays: $soilCheckDays, careDifficulty: $careDifficulty, lightPreference: $lightPreference)';
}


}

/// @nodoc
abstract mixin class $SpeciesSummaryCopyWith<$Res>  {
  factory $SpeciesSummaryCopyWith(SpeciesSummary value, $Res Function(SpeciesSummary) _then) = _$SpeciesSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? latinName, int? wateringDays, int? mistingDays, int? fertilizingDays, int? soilCheckDays, CareDifficulty careDifficulty, String? lightPreference
});




}
/// @nodoc
class _$SpeciesSummaryCopyWithImpl<$Res>
    implements $SpeciesSummaryCopyWith<$Res> {
  _$SpeciesSummaryCopyWithImpl(this._self, this._then);

  final SpeciesSummary _self;
  final $Res Function(SpeciesSummary) _then;

/// Create a copy of SpeciesSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? latinName = freezed,Object? wateringDays = freezed,Object? mistingDays = freezed,Object? fertilizingDays = freezed,Object? soilCheckDays = freezed,Object? careDifficulty = null,Object? lightPreference = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latinName: freezed == latinName ? _self.latinName : latinName // ignore: cast_nullable_to_non_nullable
as String?,wateringDays: freezed == wateringDays ? _self.wateringDays : wateringDays // ignore: cast_nullable_to_non_nullable
as int?,mistingDays: freezed == mistingDays ? _self.mistingDays : mistingDays // ignore: cast_nullable_to_non_nullable
as int?,fertilizingDays: freezed == fertilizingDays ? _self.fertilizingDays : fertilizingDays // ignore: cast_nullable_to_non_nullable
as int?,soilCheckDays: freezed == soilCheckDays ? _self.soilCheckDays : soilCheckDays // ignore: cast_nullable_to_non_nullable
as int?,careDifficulty: null == careDifficulty ? _self.careDifficulty : careDifficulty // ignore: cast_nullable_to_non_nullable
as CareDifficulty,lightPreference: freezed == lightPreference ? _self.lightPreference : lightPreference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeciesSummary].
extension SpeciesSummaryPatterns on SpeciesSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeciesSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeciesSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeciesSummary value)  $default,){
final _that = this;
switch (_that) {
case _SpeciesSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeciesSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SpeciesSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? latinName,  int? wateringDays,  int? mistingDays,  int? fertilizingDays,  int? soilCheckDays,  CareDifficulty careDifficulty,  String? lightPreference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeciesSummary() when $default != null:
return $default(_that.id,_that.name,_that.latinName,_that.wateringDays,_that.mistingDays,_that.fertilizingDays,_that.soilCheckDays,_that.careDifficulty,_that.lightPreference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? latinName,  int? wateringDays,  int? mistingDays,  int? fertilizingDays,  int? soilCheckDays,  CareDifficulty careDifficulty,  String? lightPreference)  $default,) {final _that = this;
switch (_that) {
case _SpeciesSummary():
return $default(_that.id,_that.name,_that.latinName,_that.wateringDays,_that.mistingDays,_that.fertilizingDays,_that.soilCheckDays,_that.careDifficulty,_that.lightPreference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? latinName,  int? wateringDays,  int? mistingDays,  int? fertilizingDays,  int? soilCheckDays,  CareDifficulty careDifficulty,  String? lightPreference)?  $default,) {final _that = this;
switch (_that) {
case _SpeciesSummary() when $default != null:
return $default(_that.id,_that.name,_that.latinName,_that.wateringDays,_that.mistingDays,_that.fertilizingDays,_that.soilCheckDays,_that.careDifficulty,_that.lightPreference);case _:
  return null;

}
}

}

/// @nodoc


class _SpeciesSummary extends SpeciesSummary {
  const _SpeciesSummary({required this.id, required this.name, this.latinName, this.wateringDays, this.mistingDays, this.fertilizingDays, this.soilCheckDays, this.careDifficulty = CareDifficulty.unknown, this.lightPreference}): super._();
  

@override final  int id;
@override final  String name;
@override final  String? latinName;
/// Рекомендуемые интервалы ухода в днях (null/0 — рекомендации нет).
@override final  int? wateringDays;
@override final  int? mistingDays;
@override final  int? fertilizingDays;
@override final  int? soilCheckDays;
@override@JsonKey() final  CareDifficulty careDifficulty;
/// Предпочтение по свету как пришло с backend (`LightPreference.name()`).
@override final  String? lightPreference;

/// Create a copy of SpeciesSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeciesSummaryCopyWith<_SpeciesSummary> get copyWith => __$SpeciesSummaryCopyWithImpl<_SpeciesSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeciesSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latinName, latinName) || other.latinName == latinName)&&(identical(other.wateringDays, wateringDays) || other.wateringDays == wateringDays)&&(identical(other.mistingDays, mistingDays) || other.mistingDays == mistingDays)&&(identical(other.fertilizingDays, fertilizingDays) || other.fertilizingDays == fertilizingDays)&&(identical(other.soilCheckDays, soilCheckDays) || other.soilCheckDays == soilCheckDays)&&(identical(other.careDifficulty, careDifficulty) || other.careDifficulty == careDifficulty)&&(identical(other.lightPreference, lightPreference) || other.lightPreference == lightPreference));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,latinName,wateringDays,mistingDays,fertilizingDays,soilCheckDays,careDifficulty,lightPreference);

@override
String toString() {
  return 'SpeciesSummary(id: $id, name: $name, latinName: $latinName, wateringDays: $wateringDays, mistingDays: $mistingDays, fertilizingDays: $fertilizingDays, soilCheckDays: $soilCheckDays, careDifficulty: $careDifficulty, lightPreference: $lightPreference)';
}


}

/// @nodoc
abstract mixin class _$SpeciesSummaryCopyWith<$Res> implements $SpeciesSummaryCopyWith<$Res> {
  factory _$SpeciesSummaryCopyWith(_SpeciesSummary value, $Res Function(_SpeciesSummary) _then) = __$SpeciesSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? latinName, int? wateringDays, int? mistingDays, int? fertilizingDays, int? soilCheckDays, CareDifficulty careDifficulty, String? lightPreference
});




}
/// @nodoc
class __$SpeciesSummaryCopyWithImpl<$Res>
    implements _$SpeciesSummaryCopyWith<$Res> {
  __$SpeciesSummaryCopyWithImpl(this._self, this._then);

  final _SpeciesSummary _self;
  final $Res Function(_SpeciesSummary) _then;

/// Create a copy of SpeciesSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? latinName = freezed,Object? wateringDays = freezed,Object? mistingDays = freezed,Object? fertilizingDays = freezed,Object? soilCheckDays = freezed,Object? careDifficulty = null,Object? lightPreference = freezed,}) {
  return _then(_SpeciesSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latinName: freezed == latinName ? _self.latinName : latinName // ignore: cast_nullable_to_non_nullable
as String?,wateringDays: freezed == wateringDays ? _self.wateringDays : wateringDays // ignore: cast_nullable_to_non_nullable
as int?,mistingDays: freezed == mistingDays ? _self.mistingDays : mistingDays // ignore: cast_nullable_to_non_nullable
as int?,fertilizingDays: freezed == fertilizingDays ? _self.fertilizingDays : fertilizingDays // ignore: cast_nullable_to_non_nullable
as int?,soilCheckDays: freezed == soilCheckDays ? _self.soilCheckDays : soilCheckDays // ignore: cast_nullable_to_non_nullable
as int?,careDifficulty: null == careDifficulty ? _self.careDifficulty : careDifficulty // ignore: cast_nullable_to_non_nullable
as CareDifficulty,lightPreference: freezed == lightPreference ? _self.lightPreference : lightPreference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
