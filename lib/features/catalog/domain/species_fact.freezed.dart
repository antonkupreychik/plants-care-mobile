// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_fact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeciesFact {

 SpeciesFactCategory get category; String get title; String get body;/// Источник факта (напр. `ASPCA`), если указан.
 String? get source;
/// Create a copy of SpeciesFact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeciesFactCopyWith<SpeciesFact> get copyWith => _$SpeciesFactCopyWithImpl<SpeciesFact>(this as SpeciesFact, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeciesFact&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,category,title,body,source);

@override
String toString() {
  return 'SpeciesFact(category: $category, title: $title, body: $body, source: $source)';
}


}

/// @nodoc
abstract mixin class $SpeciesFactCopyWith<$Res>  {
  factory $SpeciesFactCopyWith(SpeciesFact value, $Res Function(SpeciesFact) _then) = _$SpeciesFactCopyWithImpl;
@useResult
$Res call({
 SpeciesFactCategory category, String title, String body, String? source
});




}
/// @nodoc
class _$SpeciesFactCopyWithImpl<$Res>
    implements $SpeciesFactCopyWith<$Res> {
  _$SpeciesFactCopyWithImpl(this._self, this._then);

  final SpeciesFact _self;
  final $Res Function(SpeciesFact) _then;

/// Create a copy of SpeciesFact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? title = null,Object? body = null,Object? source = freezed,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SpeciesFactCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeciesFact].
extension SpeciesFactPatterns on SpeciesFact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeciesFact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeciesFact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeciesFact value)  $default,){
final _that = this;
switch (_that) {
case _SpeciesFact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeciesFact value)?  $default,){
final _that = this;
switch (_that) {
case _SpeciesFact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SpeciesFactCategory category,  String title,  String body,  String? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeciesFact() when $default != null:
return $default(_that.category,_that.title,_that.body,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SpeciesFactCategory category,  String title,  String body,  String? source)  $default,) {final _that = this;
switch (_that) {
case _SpeciesFact():
return $default(_that.category,_that.title,_that.body,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SpeciesFactCategory category,  String title,  String body,  String? source)?  $default,) {final _that = this;
switch (_that) {
case _SpeciesFact() when $default != null:
return $default(_that.category,_that.title,_that.body,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _SpeciesFact implements SpeciesFact {
  const _SpeciesFact({required this.category, required this.title, required this.body, this.source});
  

@override final  SpeciesFactCategory category;
@override final  String title;
@override final  String body;
/// Источник факта (напр. `ASPCA`), если указан.
@override final  String? source;

/// Create a copy of SpeciesFact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeciesFactCopyWith<_SpeciesFact> get copyWith => __$SpeciesFactCopyWithImpl<_SpeciesFact>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeciesFact&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,category,title,body,source);

@override
String toString() {
  return 'SpeciesFact(category: $category, title: $title, body: $body, source: $source)';
}


}

/// @nodoc
abstract mixin class _$SpeciesFactCopyWith<$Res> implements $SpeciesFactCopyWith<$Res> {
  factory _$SpeciesFactCopyWith(_SpeciesFact value, $Res Function(_SpeciesFact) _then) = __$SpeciesFactCopyWithImpl;
@override @useResult
$Res call({
 SpeciesFactCategory category, String title, String body, String? source
});




}
/// @nodoc
class __$SpeciesFactCopyWithImpl<$Res>
    implements _$SpeciesFactCopyWith<$Res> {
  __$SpeciesFactCopyWithImpl(this._self, this._then);

  final _SpeciesFact _self;
  final $Res Function(_SpeciesFact) _then;

/// Create a copy of SpeciesFact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? title = null,Object? body = null,Object? source = freezed,}) {
  return _then(_SpeciesFact(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SpeciesFactCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
