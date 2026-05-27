// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Species {

 int get id; String get name;/// Латинское имя (`Monstera deliciosa`). У части видов может отсутствовать.
 String? get latinName;/// Рекомендуемый интервал полива в днях.
 int? get wateringDays;/// Рекомендуемый интервал опрыскивания в днях.
 int? get mistingDays;/// Рекомендуемый интервал подкормки в днях.
 int? get fertilizingDays;/// Рекомендуемый интервал проверки грунта в днях.
 int? get soilCheckDays;/// Сложность ухода (domain-enum, замаплен из строки backend).
 CareDifficulty get careDifficulty;/// Предпочтение освещённости (domain-enum, замаплен из строки backend).
 LightPreference get lightPreference;
/// Create a copy of Species
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeciesCopyWith<Species> get copyWith => _$SpeciesCopyWithImpl<Species>(this as Species, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Species&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latinName, latinName) || other.latinName == latinName)&&(identical(other.wateringDays, wateringDays) || other.wateringDays == wateringDays)&&(identical(other.mistingDays, mistingDays) || other.mistingDays == mistingDays)&&(identical(other.fertilizingDays, fertilizingDays) || other.fertilizingDays == fertilizingDays)&&(identical(other.soilCheckDays, soilCheckDays) || other.soilCheckDays == soilCheckDays)&&(identical(other.careDifficulty, careDifficulty) || other.careDifficulty == careDifficulty)&&(identical(other.lightPreference, lightPreference) || other.lightPreference == lightPreference));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,latinName,wateringDays,mistingDays,fertilizingDays,soilCheckDays,careDifficulty,lightPreference);

@override
String toString() {
  return 'Species(id: $id, name: $name, latinName: $latinName, wateringDays: $wateringDays, mistingDays: $mistingDays, fertilizingDays: $fertilizingDays, soilCheckDays: $soilCheckDays, careDifficulty: $careDifficulty, lightPreference: $lightPreference)';
}


}

/// @nodoc
abstract mixin class $SpeciesCopyWith<$Res>  {
  factory $SpeciesCopyWith(Species value, $Res Function(Species) _then) = _$SpeciesCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? latinName, int? wateringDays, int? mistingDays, int? fertilizingDays, int? soilCheckDays, CareDifficulty careDifficulty, LightPreference lightPreference
});




}
/// @nodoc
class _$SpeciesCopyWithImpl<$Res>
    implements $SpeciesCopyWith<$Res> {
  _$SpeciesCopyWithImpl(this._self, this._then);

  final Species _self;
  final $Res Function(Species) _then;

/// Create a copy of Species
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? latinName = freezed,Object? wateringDays = freezed,Object? mistingDays = freezed,Object? fertilizingDays = freezed,Object? soilCheckDays = freezed,Object? careDifficulty = null,Object? lightPreference = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latinName: freezed == latinName ? _self.latinName : latinName // ignore: cast_nullable_to_non_nullable
as String?,wateringDays: freezed == wateringDays ? _self.wateringDays : wateringDays // ignore: cast_nullable_to_non_nullable
as int?,mistingDays: freezed == mistingDays ? _self.mistingDays : mistingDays // ignore: cast_nullable_to_non_nullable
as int?,fertilizingDays: freezed == fertilizingDays ? _self.fertilizingDays : fertilizingDays // ignore: cast_nullable_to_non_nullable
as int?,soilCheckDays: freezed == soilCheckDays ? _self.soilCheckDays : soilCheckDays // ignore: cast_nullable_to_non_nullable
as int?,careDifficulty: null == careDifficulty ? _self.careDifficulty : careDifficulty // ignore: cast_nullable_to_non_nullable
as CareDifficulty,lightPreference: null == lightPreference ? _self.lightPreference : lightPreference // ignore: cast_nullable_to_non_nullable
as LightPreference,
  ));
}

}


/// Adds pattern-matching-related methods to [Species].
extension SpeciesPatterns on Species {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Species value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Species() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Species value)  $default,){
final _that = this;
switch (_that) {
case _Species():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Species value)?  $default,){
final _that = this;
switch (_that) {
case _Species() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? latinName,  int? wateringDays,  int? mistingDays,  int? fertilizingDays,  int? soilCheckDays,  CareDifficulty careDifficulty,  LightPreference lightPreference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Species() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? latinName,  int? wateringDays,  int? mistingDays,  int? fertilizingDays,  int? soilCheckDays,  CareDifficulty careDifficulty,  LightPreference lightPreference)  $default,) {final _that = this;
switch (_that) {
case _Species():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? latinName,  int? wateringDays,  int? mistingDays,  int? fertilizingDays,  int? soilCheckDays,  CareDifficulty careDifficulty,  LightPreference lightPreference)?  $default,) {final _that = this;
switch (_that) {
case _Species() when $default != null:
return $default(_that.id,_that.name,_that.latinName,_that.wateringDays,_that.mistingDays,_that.fertilizingDays,_that.soilCheckDays,_that.careDifficulty,_that.lightPreference);case _:
  return null;

}
}

}

/// @nodoc


class _Species implements Species {
  const _Species({required this.id, required this.name, this.latinName, this.wateringDays, this.mistingDays, this.fertilizingDays, this.soilCheckDays, this.careDifficulty = CareDifficulty.unknown, this.lightPreference = LightPreference.unknown});
  

@override final  int id;
@override final  String name;
/// Латинское имя (`Monstera deliciosa`). У части видов может отсутствовать.
@override final  String? latinName;
/// Рекомендуемый интервал полива в днях.
@override final  int? wateringDays;
/// Рекомендуемый интервал опрыскивания в днях.
@override final  int? mistingDays;
/// Рекомендуемый интервал подкормки в днях.
@override final  int? fertilizingDays;
/// Рекомендуемый интервал проверки грунта в днях.
@override final  int? soilCheckDays;
/// Сложность ухода (domain-enum, замаплен из строки backend).
@override@JsonKey() final  CareDifficulty careDifficulty;
/// Предпочтение освещённости (domain-enum, замаплен из строки backend).
@override@JsonKey() final  LightPreference lightPreference;

/// Create a copy of Species
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeciesCopyWith<_Species> get copyWith => __$SpeciesCopyWithImpl<_Species>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Species&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latinName, latinName) || other.latinName == latinName)&&(identical(other.wateringDays, wateringDays) || other.wateringDays == wateringDays)&&(identical(other.mistingDays, mistingDays) || other.mistingDays == mistingDays)&&(identical(other.fertilizingDays, fertilizingDays) || other.fertilizingDays == fertilizingDays)&&(identical(other.soilCheckDays, soilCheckDays) || other.soilCheckDays == soilCheckDays)&&(identical(other.careDifficulty, careDifficulty) || other.careDifficulty == careDifficulty)&&(identical(other.lightPreference, lightPreference) || other.lightPreference == lightPreference));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,latinName,wateringDays,mistingDays,fertilizingDays,soilCheckDays,careDifficulty,lightPreference);

@override
String toString() {
  return 'Species(id: $id, name: $name, latinName: $latinName, wateringDays: $wateringDays, mistingDays: $mistingDays, fertilizingDays: $fertilizingDays, soilCheckDays: $soilCheckDays, careDifficulty: $careDifficulty, lightPreference: $lightPreference)';
}


}

/// @nodoc
abstract mixin class _$SpeciesCopyWith<$Res> implements $SpeciesCopyWith<$Res> {
  factory _$SpeciesCopyWith(_Species value, $Res Function(_Species) _then) = __$SpeciesCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? latinName, int? wateringDays, int? mistingDays, int? fertilizingDays, int? soilCheckDays, CareDifficulty careDifficulty, LightPreference lightPreference
});




}
/// @nodoc
class __$SpeciesCopyWithImpl<$Res>
    implements _$SpeciesCopyWith<$Res> {
  __$SpeciesCopyWithImpl(this._self, this._then);

  final _Species _self;
  final $Res Function(_Species) _then;

/// Create a copy of Species
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? latinName = freezed,Object? wateringDays = freezed,Object? mistingDays = freezed,Object? fertilizingDays = freezed,Object? soilCheckDays = freezed,Object? careDifficulty = null,Object? lightPreference = null,}) {
  return _then(_Species(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latinName: freezed == latinName ? _self.latinName : latinName // ignore: cast_nullable_to_non_nullable
as String?,wateringDays: freezed == wateringDays ? _self.wateringDays : wateringDays // ignore: cast_nullable_to_non_nullable
as int?,mistingDays: freezed == mistingDays ? _self.mistingDays : mistingDays // ignore: cast_nullable_to_non_nullable
as int?,fertilizingDays: freezed == fertilizingDays ? _self.fertilizingDays : fertilizingDays // ignore: cast_nullable_to_non_nullable
as int?,soilCheckDays: freezed == soilCheckDays ? _self.soilCheckDays : soilCheckDays // ignore: cast_nullable_to_non_nullable
as int?,careDifficulty: null == careDifficulty ? _self.careDifficulty : careDifficulty // ignore: cast_nullable_to_non_nullable
as CareDifficulty,lightPreference: null == lightPreference ? _self.lightPreference : lightPreference // ignore: cast_nullable_to_non_nullable
as LightPreference,
  ));
}


}

// dart format on
