// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantTemplateCareRule {

 PlantTemplateCareType get careType; int get intervalDays;
/// Create a copy of PlantTemplateCareRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantTemplateCareRuleCopyWith<PlantTemplateCareRule> get copyWith => _$PlantTemplateCareRuleCopyWithImpl<PlantTemplateCareRule>(this as PlantTemplateCareRule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantTemplateCareRule&&(identical(other.careType, careType) || other.careType == careType)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays));
}


@override
int get hashCode => Object.hash(runtimeType,careType,intervalDays);

@override
String toString() {
  return 'PlantTemplateCareRule(careType: $careType, intervalDays: $intervalDays)';
}


}

/// @nodoc
abstract mixin class $PlantTemplateCareRuleCopyWith<$Res>  {
  factory $PlantTemplateCareRuleCopyWith(PlantTemplateCareRule value, $Res Function(PlantTemplateCareRule) _then) = _$PlantTemplateCareRuleCopyWithImpl;
@useResult
$Res call({
 PlantTemplateCareType careType, int intervalDays
});




}
/// @nodoc
class _$PlantTemplateCareRuleCopyWithImpl<$Res>
    implements $PlantTemplateCareRuleCopyWith<$Res> {
  _$PlantTemplateCareRuleCopyWithImpl(this._self, this._then);

  final PlantTemplateCareRule _self;
  final $Res Function(PlantTemplateCareRule) _then;

/// Create a copy of PlantTemplateCareRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? careType = null,Object? intervalDays = null,}) {
  return _then(_self.copyWith(
careType: null == careType ? _self.careType : careType // ignore: cast_nullable_to_non_nullable
as PlantTemplateCareType,intervalDays: null == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantTemplateCareRule].
extension PlantTemplateCareRulePatterns on PlantTemplateCareRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantTemplateCareRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantTemplateCareRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantTemplateCareRule value)  $default,){
final _that = this;
switch (_that) {
case _PlantTemplateCareRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantTemplateCareRule value)?  $default,){
final _that = this;
switch (_that) {
case _PlantTemplateCareRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlantTemplateCareType careType,  int intervalDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantTemplateCareRule() when $default != null:
return $default(_that.careType,_that.intervalDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlantTemplateCareType careType,  int intervalDays)  $default,) {final _that = this;
switch (_that) {
case _PlantTemplateCareRule():
return $default(_that.careType,_that.intervalDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlantTemplateCareType careType,  int intervalDays)?  $default,) {final _that = this;
switch (_that) {
case _PlantTemplateCareRule() when $default != null:
return $default(_that.careType,_that.intervalDays);case _:
  return null;

}
}

}

/// @nodoc


class _PlantTemplateCareRule implements PlantTemplateCareRule {
  const _PlantTemplateCareRule({required this.careType, required this.intervalDays});
  

@override final  PlantTemplateCareType careType;
@override final  int intervalDays;

/// Create a copy of PlantTemplateCareRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantTemplateCareRuleCopyWith<_PlantTemplateCareRule> get copyWith => __$PlantTemplateCareRuleCopyWithImpl<_PlantTemplateCareRule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantTemplateCareRule&&(identical(other.careType, careType) || other.careType == careType)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays));
}


@override
int get hashCode => Object.hash(runtimeType,careType,intervalDays);

@override
String toString() {
  return 'PlantTemplateCareRule(careType: $careType, intervalDays: $intervalDays)';
}


}

/// @nodoc
abstract mixin class _$PlantTemplateCareRuleCopyWith<$Res> implements $PlantTemplateCareRuleCopyWith<$Res> {
  factory _$PlantTemplateCareRuleCopyWith(_PlantTemplateCareRule value, $Res Function(_PlantTemplateCareRule) _then) = __$PlantTemplateCareRuleCopyWithImpl;
@override @useResult
$Res call({
 PlantTemplateCareType careType, int intervalDays
});




}
/// @nodoc
class __$PlantTemplateCareRuleCopyWithImpl<$Res>
    implements _$PlantTemplateCareRuleCopyWith<$Res> {
  __$PlantTemplateCareRuleCopyWithImpl(this._self, this._then);

  final _PlantTemplateCareRule _self;
  final $Res Function(_PlantTemplateCareRule) _then;

/// Create a copy of PlantTemplateCareRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? careType = null,Object? intervalDays = null,}) {
  return _then(_PlantTemplateCareRule(
careType: null == careType ? _self.careType : careType // ignore: cast_nullable_to_non_nullable
as PlantTemplateCareType,intervalDays: null == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PlantTemplate {

 int get id; String get name; List<PlantTemplateCareRule> get careRules; DateTime get createdAt;
/// Create a copy of PlantTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantTemplateCopyWith<PlantTemplate> get copyWith => _$PlantTemplateCopyWithImpl<PlantTemplate>(this as PlantTemplate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.careRules, careRules)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(careRules),createdAt);

@override
String toString() {
  return 'PlantTemplate(id: $id, name: $name, careRules: $careRules, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PlantTemplateCopyWith<$Res>  {
  factory $PlantTemplateCopyWith(PlantTemplate value, $Res Function(PlantTemplate) _then) = _$PlantTemplateCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<PlantTemplateCareRule> careRules, DateTime createdAt
});




}
/// @nodoc
class _$PlantTemplateCopyWithImpl<$Res>
    implements $PlantTemplateCopyWith<$Res> {
  _$PlantTemplateCopyWithImpl(this._self, this._then);

  final PlantTemplate _self;
  final $Res Function(PlantTemplate) _then;

/// Create a copy of PlantTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? careRules = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,careRules: null == careRules ? _self.careRules : careRules // ignore: cast_nullable_to_non_nullable
as List<PlantTemplateCareRule>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantTemplate].
extension PlantTemplatePatterns on PlantTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantTemplate value)  $default,){
final _that = this;
switch (_that) {
case _PlantTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _PlantTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<PlantTemplateCareRule> careRules,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantTemplate() when $default != null:
return $default(_that.id,_that.name,_that.careRules,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<PlantTemplateCareRule> careRules,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PlantTemplate():
return $default(_that.id,_that.name,_that.careRules,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<PlantTemplateCareRule> careRules,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PlantTemplate() when $default != null:
return $default(_that.id,_that.name,_that.careRules,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _PlantTemplate implements PlantTemplate {
  const _PlantTemplate({required this.id, required this.name, required final  List<PlantTemplateCareRule> careRules, required this.createdAt}): _careRules = careRules;
  

@override final  int id;
@override final  String name;
 final  List<PlantTemplateCareRule> _careRules;
@override List<PlantTemplateCareRule> get careRules {
  if (_careRules is EqualUnmodifiableListView) return _careRules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_careRules);
}

@override final  DateTime createdAt;

/// Create a copy of PlantTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantTemplateCopyWith<_PlantTemplate> get copyWith => __$PlantTemplateCopyWithImpl<_PlantTemplate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._careRules, _careRules)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_careRules),createdAt);

@override
String toString() {
  return 'PlantTemplate(id: $id, name: $name, careRules: $careRules, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PlantTemplateCopyWith<$Res> implements $PlantTemplateCopyWith<$Res> {
  factory _$PlantTemplateCopyWith(_PlantTemplate value, $Res Function(_PlantTemplate) _then) = __$PlantTemplateCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<PlantTemplateCareRule> careRules, DateTime createdAt
});




}
/// @nodoc
class __$PlantTemplateCopyWithImpl<$Res>
    implements _$PlantTemplateCopyWith<$Res> {
  __$PlantTemplateCopyWithImpl(this._self, this._then);

  final _PlantTemplate _self;
  final $Res Function(_PlantTemplate) _then;

/// Create a copy of PlantTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? careRules = null,Object? createdAt = null,}) {
  return _then(_PlantTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,careRules: null == careRules ? _self._careRules : careRules // ignore: cast_nullable_to_non_nullable
as List<PlantTemplateCareRule>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
