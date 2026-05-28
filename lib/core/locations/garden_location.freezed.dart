// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'garden_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GardenLocation {

 int get id; String get name;/// Является ли локация дефолтной у пользователя.
 bool get isDefault;/// Эмодзи-иконка локации (если задана).
 String? get emoji; DateTime? get createdAt;
/// Create a copy of GardenLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GardenLocationCopyWith<GardenLocation> get copyWith => _$GardenLocationCopyWithImpl<GardenLocation>(this as GardenLocation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GardenLocation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isDefault,emoji,createdAt);

@override
String toString() {
  return 'GardenLocation(id: $id, name: $name, isDefault: $isDefault, emoji: $emoji, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GardenLocationCopyWith<$Res>  {
  factory $GardenLocationCopyWith(GardenLocation value, $Res Function(GardenLocation) _then) = _$GardenLocationCopyWithImpl;
@useResult
$Res call({
 int id, String name, bool isDefault, String? emoji, DateTime? createdAt
});




}
/// @nodoc
class _$GardenLocationCopyWithImpl<$Res>
    implements $GardenLocationCopyWith<$Res> {
  _$GardenLocationCopyWithImpl(this._self, this._then);

  final GardenLocation _self;
  final $Res Function(GardenLocation) _then;

/// Create a copy of GardenLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isDefault = null,Object? emoji = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GardenLocation].
extension GardenLocationPatterns on GardenLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GardenLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GardenLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GardenLocation value)  $default,){
final _that = this;
switch (_that) {
case _GardenLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GardenLocation value)?  $default,){
final _that = this;
switch (_that) {
case _GardenLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  bool isDefault,  String? emoji,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GardenLocation() when $default != null:
return $default(_that.id,_that.name,_that.isDefault,_that.emoji,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  bool isDefault,  String? emoji,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _GardenLocation():
return $default(_that.id,_that.name,_that.isDefault,_that.emoji,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  bool isDefault,  String? emoji,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GardenLocation() when $default != null:
return $default(_that.id,_that.name,_that.isDefault,_that.emoji,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _GardenLocation implements GardenLocation {
  const _GardenLocation({required this.id, required this.name, required this.isDefault, this.emoji, this.createdAt});
  

@override final  int id;
@override final  String name;
/// Является ли локация дефолтной у пользователя.
@override final  bool isDefault;
/// Эмодзи-иконка локации (если задана).
@override final  String? emoji;
@override final  DateTime? createdAt;

/// Create a copy of GardenLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GardenLocationCopyWith<_GardenLocation> get copyWith => __$GardenLocationCopyWithImpl<_GardenLocation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GardenLocation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isDefault,emoji,createdAt);

@override
String toString() {
  return 'GardenLocation(id: $id, name: $name, isDefault: $isDefault, emoji: $emoji, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GardenLocationCopyWith<$Res> implements $GardenLocationCopyWith<$Res> {
  factory _$GardenLocationCopyWith(_GardenLocation value, $Res Function(_GardenLocation) _then) = __$GardenLocationCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, bool isDefault, String? emoji, DateTime? createdAt
});




}
/// @nodoc
class __$GardenLocationCopyWithImpl<$Res>
    implements _$GardenLocationCopyWith<$Res> {
  __$GardenLocationCopyWithImpl(this._self, this._then);

  final _GardenLocation _self;
  final $Res Function(_GardenLocation) _then;

/// Create a copy of GardenLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isDefault = null,Object? emoji = freezed,Object? createdAt = freezed,}) {
  return _then(_GardenLocation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
