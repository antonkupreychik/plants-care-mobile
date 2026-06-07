// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_family.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantFamilyMember {

/// Идентификатор растения-узла (навигация в карточку `plants/:id`).
 int get id;/// Отображаемое имя растения.
 String get name;
/// Create a copy of PlantFamilyMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantFamilyMemberCopyWith<PlantFamilyMember> get copyWith => _$PlantFamilyMemberCopyWithImpl<PlantFamilyMember>(this as PlantFamilyMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantFamilyMember&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'PlantFamilyMember(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $PlantFamilyMemberCopyWith<$Res>  {
  factory $PlantFamilyMemberCopyWith(PlantFamilyMember value, $Res Function(PlantFamilyMember) _then) = _$PlantFamilyMemberCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$PlantFamilyMemberCopyWithImpl<$Res>
    implements $PlantFamilyMemberCopyWith<$Res> {
  _$PlantFamilyMemberCopyWithImpl(this._self, this._then);

  final PlantFamilyMember _self;
  final $Res Function(PlantFamilyMember) _then;

/// Create a copy of PlantFamilyMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantFamilyMember].
extension PlantFamilyMemberPatterns on PlantFamilyMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantFamilyMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantFamilyMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantFamilyMember value)  $default,){
final _that = this;
switch (_that) {
case _PlantFamilyMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantFamilyMember value)?  $default,){
final _that = this;
switch (_that) {
case _PlantFamilyMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantFamilyMember() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _PlantFamilyMember():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _PlantFamilyMember() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _PlantFamilyMember implements PlantFamilyMember {
  const _PlantFamilyMember({required this.id, required this.name});
  

/// Идентификатор растения-узла (навигация в карточку `plants/:id`).
@override final  int id;
/// Отображаемое имя растения.
@override final  String name;

/// Create a copy of PlantFamilyMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantFamilyMemberCopyWith<_PlantFamilyMember> get copyWith => __$PlantFamilyMemberCopyWithImpl<_PlantFamilyMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantFamilyMember&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'PlantFamilyMember(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PlantFamilyMemberCopyWith<$Res> implements $PlantFamilyMemberCopyWith<$Res> {
  factory _$PlantFamilyMemberCopyWith(_PlantFamilyMember value, $Res Function(_PlantFamilyMember) _then) = __$PlantFamilyMemberCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$PlantFamilyMemberCopyWithImpl<$Res>
    implements _$PlantFamilyMemberCopyWith<$Res> {
  __$PlantFamilyMemberCopyWithImpl(this._self, this._then);

  final _PlantFamilyMember _self;
  final $Res Function(_PlantFamilyMember) _then;

/// Create a copy of PlantFamilyMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_PlantFamilyMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PlantFamily {

/// Материнское растение, от которого получен текущий отводок. `null` —
/// текущее растение не является чьим-то потомком (корень семьи).
 PlantFamilyMember? get parent;/// Прямые потомки/отводки текущего растения, в порядке backend.
 List<PlantFamilyMember> get children;
/// Create a copy of PlantFamily
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantFamilyCopyWith<PlantFamily> get copyWith => _$PlantFamilyCopyWithImpl<PlantFamily>(this as PlantFamily, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantFamily&&(identical(other.parent, parent) || other.parent == parent)&&const DeepCollectionEquality().equals(other.children, children));
}


@override
int get hashCode => Object.hash(runtimeType,parent,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'PlantFamily(parent: $parent, children: $children)';
}


}

/// @nodoc
abstract mixin class $PlantFamilyCopyWith<$Res>  {
  factory $PlantFamilyCopyWith(PlantFamily value, $Res Function(PlantFamily) _then) = _$PlantFamilyCopyWithImpl;
@useResult
$Res call({
 PlantFamilyMember? parent, List<PlantFamilyMember> children
});


$PlantFamilyMemberCopyWith<$Res>? get parent;

}
/// @nodoc
class _$PlantFamilyCopyWithImpl<$Res>
    implements $PlantFamilyCopyWith<$Res> {
  _$PlantFamilyCopyWithImpl(this._self, this._then);

  final PlantFamily _self;
  final $Res Function(PlantFamily) _then;

/// Create a copy of PlantFamily
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parent = freezed,Object? children = null,}) {
  return _then(_self.copyWith(
parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as PlantFamilyMember?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<PlantFamilyMember>,
  ));
}
/// Create a copy of PlantFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlantFamilyMemberCopyWith<$Res>? get parent {
    if (_self.parent == null) {
    return null;
  }

  return $PlantFamilyMemberCopyWith<$Res>(_self.parent!, (value) {
    return _then(_self.copyWith(parent: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlantFamily].
extension PlantFamilyPatterns on PlantFamily {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantFamily value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantFamily() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantFamily value)  $default,){
final _that = this;
switch (_that) {
case _PlantFamily():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantFamily value)?  $default,){
final _that = this;
switch (_that) {
case _PlantFamily() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlantFamilyMember? parent,  List<PlantFamilyMember> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantFamily() when $default != null:
return $default(_that.parent,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlantFamilyMember? parent,  List<PlantFamilyMember> children)  $default,) {final _that = this;
switch (_that) {
case _PlantFamily():
return $default(_that.parent,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlantFamilyMember? parent,  List<PlantFamilyMember> children)?  $default,) {final _that = this;
switch (_that) {
case _PlantFamily() when $default != null:
return $default(_that.parent,_that.children);case _:
  return null;

}
}

}

/// @nodoc


class _PlantFamily extends PlantFamily {
  const _PlantFamily({this.parent, required final  List<PlantFamilyMember> children}): _children = children,super._();
  

/// Материнское растение, от которого получен текущий отводок. `null` —
/// текущее растение не является чьим-то потомком (корень семьи).
@override final  PlantFamilyMember? parent;
/// Прямые потомки/отводки текущего растения, в порядке backend.
 final  List<PlantFamilyMember> _children;
/// Прямые потомки/отводки текущего растения, в порядке backend.
@override List<PlantFamilyMember> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of PlantFamily
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantFamilyCopyWith<_PlantFamily> get copyWith => __$PlantFamilyCopyWithImpl<_PlantFamily>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantFamily&&(identical(other.parent, parent) || other.parent == parent)&&const DeepCollectionEquality().equals(other._children, _children));
}


@override
int get hashCode => Object.hash(runtimeType,parent,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'PlantFamily(parent: $parent, children: $children)';
}


}

/// @nodoc
abstract mixin class _$PlantFamilyCopyWith<$Res> implements $PlantFamilyCopyWith<$Res> {
  factory _$PlantFamilyCopyWith(_PlantFamily value, $Res Function(_PlantFamily) _then) = __$PlantFamilyCopyWithImpl;
@override @useResult
$Res call({
 PlantFamilyMember? parent, List<PlantFamilyMember> children
});


@override $PlantFamilyMemberCopyWith<$Res>? get parent;

}
/// @nodoc
class __$PlantFamilyCopyWithImpl<$Res>
    implements _$PlantFamilyCopyWith<$Res> {
  __$PlantFamilyCopyWithImpl(this._self, this._then);

  final _PlantFamily _self;
  final $Res Function(_PlantFamily) _then;

/// Create a copy of PlantFamily
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parent = freezed,Object? children = null,}) {
  return _then(_PlantFamily(
parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as PlantFamilyMember?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<PlantFamilyMember>,
  ));
}

/// Create a copy of PlantFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlantFamilyMemberCopyWith<$Res>? get parent {
    if (_self.parent == null) {
    return null;
  }

  return $PlantFamilyMemberCopyWith<$Res>(_self.parent!, (value) {
    return _then(_self.copyWith(parent: value));
  });
}
}

// dart format on
