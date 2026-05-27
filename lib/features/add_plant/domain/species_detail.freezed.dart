// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeciesDetail {

 SpeciesSummary get summary;/// Длинное текстовое описание вида (может отсутствовать).
 String? get description;
/// Create a copy of SpeciesDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeciesDetailCopyWith<SpeciesDetail> get copyWith => _$SpeciesDetailCopyWithImpl<SpeciesDetail>(this as SpeciesDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeciesDetail&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,summary,description);

@override
String toString() {
  return 'SpeciesDetail(summary: $summary, description: $description)';
}


}

/// @nodoc
abstract mixin class $SpeciesDetailCopyWith<$Res>  {
  factory $SpeciesDetailCopyWith(SpeciesDetail value, $Res Function(SpeciesDetail) _then) = _$SpeciesDetailCopyWithImpl;
@useResult
$Res call({
 SpeciesSummary summary, String? description
});


$SpeciesSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$SpeciesDetailCopyWithImpl<$Res>
    implements $SpeciesDetailCopyWith<$Res> {
  _$SpeciesDetailCopyWithImpl(this._self, this._then);

  final SpeciesDetail _self;
  final $Res Function(SpeciesDetail) _then;

/// Create a copy of SpeciesDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as SpeciesSummary,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SpeciesDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeciesSummaryCopyWith<$Res> get summary {
  
  return $SpeciesSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [SpeciesDetail].
extension SpeciesDetailPatterns on SpeciesDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeciesDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeciesDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeciesDetail value)  $default,){
final _that = this;
switch (_that) {
case _SpeciesDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeciesDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SpeciesDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SpeciesSummary summary,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeciesDetail() when $default != null:
return $default(_that.summary,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SpeciesSummary summary,  String? description)  $default,) {final _that = this;
switch (_that) {
case _SpeciesDetail():
return $default(_that.summary,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SpeciesSummary summary,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _SpeciesDetail() when $default != null:
return $default(_that.summary,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _SpeciesDetail extends SpeciesDetail {
  const _SpeciesDetail({required this.summary, this.description}): super._();
  

@override final  SpeciesSummary summary;
/// Длинное текстовое описание вида (может отсутствовать).
@override final  String? description;

/// Create a copy of SpeciesDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeciesDetailCopyWith<_SpeciesDetail> get copyWith => __$SpeciesDetailCopyWithImpl<_SpeciesDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeciesDetail&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,summary,description);

@override
String toString() {
  return 'SpeciesDetail(summary: $summary, description: $description)';
}


}

/// @nodoc
abstract mixin class _$SpeciesDetailCopyWith<$Res> implements $SpeciesDetailCopyWith<$Res> {
  factory _$SpeciesDetailCopyWith(_SpeciesDetail value, $Res Function(_SpeciesDetail) _then) = __$SpeciesDetailCopyWithImpl;
@override @useResult
$Res call({
 SpeciesSummary summary, String? description
});


@override $SpeciesSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$SpeciesDetailCopyWithImpl<$Res>
    implements _$SpeciesDetailCopyWith<$Res> {
  __$SpeciesDetailCopyWithImpl(this._self, this._then);

  final _SpeciesDetail _self;
  final $Res Function(_SpeciesDetail) _then;

/// Create a copy of SpeciesDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? description = freezed,}) {
  return _then(_SpeciesDetail(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as SpeciesSummary,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SpeciesDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeciesSummaryCopyWith<$Res> get summary {
  
  return $SpeciesSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
