// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archived_plant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArchivedPlant {

/// Идентификатор растения (backend `id`).
 int get id;/// Кличка растения (напр. «Алоэ Вера», «Босс»).
 String get name;/// Вид растения (напр. «Алоэ», «Бонсай», «Папоротник»). По нему UI
/// резолвит иллюстрацию через `PlantArt.fromSpecies`.
 String get speciesName;/// Готовый лейбл «сколько прожило рядом» (напр. «11 месяцев»,
/// «3 года 2 мес.»). Форматирует backend, клиент не считает.
 String get livedLabel;/// Причина/заметка расставания (напр. «Перелив», «Подарили родителям»,
/// «Сухой воздух»). Показывается в кавычках курсивом.
 String get cause;/// Готовый лейбл месяца архивации (напр. «апрель 2026»).
 String get archivedDateLabel;/// Растение подарено/отдано (а не погибло). Влияет на цвет точки (primary
/// вместо terracotta) и склонение «Прожил» / «Прожило» в UI.
 bool get gifted;
/// Create a copy of ArchivedPlant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchivedPlantCopyWith<ArchivedPlant> get copyWith => _$ArchivedPlantCopyWithImpl<ArchivedPlant>(this as ArchivedPlant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchivedPlant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.speciesName, speciesName) || other.speciesName == speciesName)&&(identical(other.livedLabel, livedLabel) || other.livedLabel == livedLabel)&&(identical(other.cause, cause) || other.cause == cause)&&(identical(other.archivedDateLabel, archivedDateLabel) || other.archivedDateLabel == archivedDateLabel)&&(identical(other.gifted, gifted) || other.gifted == gifted));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,speciesName,livedLabel,cause,archivedDateLabel,gifted);

@override
String toString() {
  return 'ArchivedPlant(id: $id, name: $name, speciesName: $speciesName, livedLabel: $livedLabel, cause: $cause, archivedDateLabel: $archivedDateLabel, gifted: $gifted)';
}


}

/// @nodoc
abstract mixin class $ArchivedPlantCopyWith<$Res>  {
  factory $ArchivedPlantCopyWith(ArchivedPlant value, $Res Function(ArchivedPlant) _then) = _$ArchivedPlantCopyWithImpl;
@useResult
$Res call({
 int id, String name, String speciesName, String livedLabel, String cause, String archivedDateLabel, bool gifted
});




}
/// @nodoc
class _$ArchivedPlantCopyWithImpl<$Res>
    implements $ArchivedPlantCopyWith<$Res> {
  _$ArchivedPlantCopyWithImpl(this._self, this._then);

  final ArchivedPlant _self;
  final $Res Function(ArchivedPlant) _then;

/// Create a copy of ArchivedPlant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? speciesName = null,Object? livedLabel = null,Object? cause = null,Object? archivedDateLabel = null,Object? gifted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,speciesName: null == speciesName ? _self.speciesName : speciesName // ignore: cast_nullable_to_non_nullable
as String,livedLabel: null == livedLabel ? _self.livedLabel : livedLabel // ignore: cast_nullable_to_non_nullable
as String,cause: null == cause ? _self.cause : cause // ignore: cast_nullable_to_non_nullable
as String,archivedDateLabel: null == archivedDateLabel ? _self.archivedDateLabel : archivedDateLabel // ignore: cast_nullable_to_non_nullable
as String,gifted: null == gifted ? _self.gifted : gifted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchivedPlant].
extension ArchivedPlantPatterns on ArchivedPlant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchivedPlant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchivedPlant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchivedPlant value)  $default,){
final _that = this;
switch (_that) {
case _ArchivedPlant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchivedPlant value)?  $default,){
final _that = this;
switch (_that) {
case _ArchivedPlant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String speciesName,  String livedLabel,  String cause,  String archivedDateLabel,  bool gifted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchivedPlant() when $default != null:
return $default(_that.id,_that.name,_that.speciesName,_that.livedLabel,_that.cause,_that.archivedDateLabel,_that.gifted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String speciesName,  String livedLabel,  String cause,  String archivedDateLabel,  bool gifted)  $default,) {final _that = this;
switch (_that) {
case _ArchivedPlant():
return $default(_that.id,_that.name,_that.speciesName,_that.livedLabel,_that.cause,_that.archivedDateLabel,_that.gifted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String speciesName,  String livedLabel,  String cause,  String archivedDateLabel,  bool gifted)?  $default,) {final _that = this;
switch (_that) {
case _ArchivedPlant() when $default != null:
return $default(_that.id,_that.name,_that.speciesName,_that.livedLabel,_that.cause,_that.archivedDateLabel,_that.gifted);case _:
  return null;

}
}

}

/// @nodoc


class _ArchivedPlant implements ArchivedPlant {
  const _ArchivedPlant({required this.id, required this.name, required this.speciesName, required this.livedLabel, required this.cause, required this.archivedDateLabel, this.gifted = false});
  

/// Идентификатор растения (backend `id`).
@override final  int id;
/// Кличка растения (напр. «Алоэ Вера», «Босс»).
@override final  String name;
/// Вид растения (напр. «Алоэ», «Бонсай», «Папоротник»). По нему UI
/// резолвит иллюстрацию через `PlantArt.fromSpecies`.
@override final  String speciesName;
/// Готовый лейбл «сколько прожило рядом» (напр. «11 месяцев»,
/// «3 года 2 мес.»). Форматирует backend, клиент не считает.
@override final  String livedLabel;
/// Причина/заметка расставания (напр. «Перелив», «Подарили родителям»,
/// «Сухой воздух»). Показывается в кавычках курсивом.
@override final  String cause;
/// Готовый лейбл месяца архивации (напр. «апрель 2026»).
@override final  String archivedDateLabel;
/// Растение подарено/отдано (а не погибло). Влияет на цвет точки (primary
/// вместо terracotta) и склонение «Прожил» / «Прожило» в UI.
@override@JsonKey() final  bool gifted;

/// Create a copy of ArchivedPlant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchivedPlantCopyWith<_ArchivedPlant> get copyWith => __$ArchivedPlantCopyWithImpl<_ArchivedPlant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchivedPlant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.speciesName, speciesName) || other.speciesName == speciesName)&&(identical(other.livedLabel, livedLabel) || other.livedLabel == livedLabel)&&(identical(other.cause, cause) || other.cause == cause)&&(identical(other.archivedDateLabel, archivedDateLabel) || other.archivedDateLabel == archivedDateLabel)&&(identical(other.gifted, gifted) || other.gifted == gifted));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,speciesName,livedLabel,cause,archivedDateLabel,gifted);

@override
String toString() {
  return 'ArchivedPlant(id: $id, name: $name, speciesName: $speciesName, livedLabel: $livedLabel, cause: $cause, archivedDateLabel: $archivedDateLabel, gifted: $gifted)';
}


}

/// @nodoc
abstract mixin class _$ArchivedPlantCopyWith<$Res> implements $ArchivedPlantCopyWith<$Res> {
  factory _$ArchivedPlantCopyWith(_ArchivedPlant value, $Res Function(_ArchivedPlant) _then) = __$ArchivedPlantCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String speciesName, String livedLabel, String cause, String archivedDateLabel, bool gifted
});




}
/// @nodoc
class __$ArchivedPlantCopyWithImpl<$Res>
    implements _$ArchivedPlantCopyWith<$Res> {
  __$ArchivedPlantCopyWithImpl(this._self, this._then);

  final _ArchivedPlant _self;
  final $Res Function(_ArchivedPlant) _then;

/// Create a copy of ArchivedPlant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? speciesName = null,Object? livedLabel = null,Object? cause = null,Object? archivedDateLabel = null,Object? gifted = null,}) {
  return _then(_ArchivedPlant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,speciesName: null == speciesName ? _self.speciesName : speciesName // ignore: cast_nullable_to_non_nullable
as String,livedLabel: null == livedLabel ? _self.livedLabel : livedLabel // ignore: cast_nullable_to_non_nullable
as String,cause: null == cause ? _self.cause : cause // ignore: cast_nullable_to_non_nullable
as String,archivedDateLabel: null == archivedDateLabel ? _self.archivedDateLabel : archivedDateLabel // ignore: cast_nullable_to_non_nullable
as String,gifted: null == gifted ? _self.gifted : gifted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
