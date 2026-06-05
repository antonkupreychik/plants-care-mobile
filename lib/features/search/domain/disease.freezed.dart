// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'disease.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Disease {

 int get id; String get name;/// Латинское/научное имя (`Tetranychus urticae`). Может отсутствовать.
 String? get latinName;
/// Create a copy of Disease
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCopyWith<Disease> get copyWith => _$DiseaseCopyWithImpl<Disease>(this as Disease, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Disease&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latinName, latinName) || other.latinName == latinName));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,latinName);

@override
String toString() {
  return 'Disease(id: $id, name: $name, latinName: $latinName)';
}


}

/// @nodoc
abstract mixin class $DiseaseCopyWith<$Res>  {
  factory $DiseaseCopyWith(Disease value, $Res Function(Disease) _then) = _$DiseaseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? latinName
});




}
/// @nodoc
class _$DiseaseCopyWithImpl<$Res>
    implements $DiseaseCopyWith<$Res> {
  _$DiseaseCopyWithImpl(this._self, this._then);

  final Disease _self;
  final $Res Function(Disease) _then;

/// Create a copy of Disease
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? latinName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latinName: freezed == latinName ? _self.latinName : latinName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Disease].
extension DiseasePatterns on Disease {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Disease value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Disease() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Disease value)  $default,){
final _that = this;
switch (_that) {
case _Disease():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Disease value)?  $default,){
final _that = this;
switch (_that) {
case _Disease() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? latinName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Disease() when $default != null:
return $default(_that.id,_that.name,_that.latinName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? latinName)  $default,) {final _that = this;
switch (_that) {
case _Disease():
return $default(_that.id,_that.name,_that.latinName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? latinName)?  $default,) {final _that = this;
switch (_that) {
case _Disease() when $default != null:
return $default(_that.id,_that.name,_that.latinName);case _:
  return null;

}
}

}

/// @nodoc


class _Disease implements Disease {
  const _Disease({required this.id, required this.name, this.latinName});
  

@override final  int id;
@override final  String name;
/// Латинское/научное имя (`Tetranychus urticae`). Может отсутствовать.
@override final  String? latinName;

/// Create a copy of Disease
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiseaseCopyWith<_Disease> get copyWith => __$DiseaseCopyWithImpl<_Disease>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Disease&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latinName, latinName) || other.latinName == latinName));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,latinName);

@override
String toString() {
  return 'Disease(id: $id, name: $name, latinName: $latinName)';
}


}

/// @nodoc
abstract mixin class _$DiseaseCopyWith<$Res> implements $DiseaseCopyWith<$Res> {
  factory _$DiseaseCopyWith(_Disease value, $Res Function(_Disease) _then) = __$DiseaseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? latinName
});




}
/// @nodoc
class __$DiseaseCopyWithImpl<$Res>
    implements _$DiseaseCopyWith<$Res> {
  __$DiseaseCopyWithImpl(this._self, this._then);

  final _Disease _self;
  final $Res Function(_Disease) _then;

/// Create a copy of Disease
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? latinName = freezed,}) {
  return _then(_Disease(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latinName: freezed == latinName ? _self.latinName : latinName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
