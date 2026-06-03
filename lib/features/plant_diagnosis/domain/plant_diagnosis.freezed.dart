// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_diagnosis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantDiagnosis {

/// Выявленные проблемы, отсортированы по severity (HIGH → LOW).
 List<DiagnosisIssue> get issues;/// Рекомендации, собранные по проблемам с дедупликацией.
 List<String> get recommendations;
/// Create a copy of PlantDiagnosis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantDiagnosisCopyWith<PlantDiagnosis> get copyWith => _$PlantDiagnosisCopyWithImpl<PlantDiagnosis>(this as PlantDiagnosis, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantDiagnosis&&const DeepCollectionEquality().equals(other.issues, issues)&&const DeepCollectionEquality().equals(other.recommendations, recommendations));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(issues),const DeepCollectionEquality().hash(recommendations));

@override
String toString() {
  return 'PlantDiagnosis(issues: $issues, recommendations: $recommendations)';
}


}

/// @nodoc
abstract mixin class $PlantDiagnosisCopyWith<$Res>  {
  factory $PlantDiagnosisCopyWith(PlantDiagnosis value, $Res Function(PlantDiagnosis) _then) = _$PlantDiagnosisCopyWithImpl;
@useResult
$Res call({
 List<DiagnosisIssue> issues, List<String> recommendations
});




}
/// @nodoc
class _$PlantDiagnosisCopyWithImpl<$Res>
    implements $PlantDiagnosisCopyWith<$Res> {
  _$PlantDiagnosisCopyWithImpl(this._self, this._then);

  final PlantDiagnosis _self;
  final $Res Function(PlantDiagnosis) _then;

/// Create a copy of PlantDiagnosis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? issues = null,Object? recommendations = null,}) {
  return _then(_self.copyWith(
issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as List<DiagnosisIssue>,recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantDiagnosis].
extension PlantDiagnosisPatterns on PlantDiagnosis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantDiagnosis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantDiagnosis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantDiagnosis value)  $default,){
final _that = this;
switch (_that) {
case _PlantDiagnosis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantDiagnosis value)?  $default,){
final _that = this;
switch (_that) {
case _PlantDiagnosis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DiagnosisIssue> issues,  List<String> recommendations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantDiagnosis() when $default != null:
return $default(_that.issues,_that.recommendations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DiagnosisIssue> issues,  List<String> recommendations)  $default,) {final _that = this;
switch (_that) {
case _PlantDiagnosis():
return $default(_that.issues,_that.recommendations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DiagnosisIssue> issues,  List<String> recommendations)?  $default,) {final _that = this;
switch (_that) {
case _PlantDiagnosis() when $default != null:
return $default(_that.issues,_that.recommendations);case _:
  return null;

}
}

}

/// @nodoc


class _PlantDiagnosis extends PlantDiagnosis {
  const _PlantDiagnosis({required final  List<DiagnosisIssue> issues, required final  List<String> recommendations}): _issues = issues,_recommendations = recommendations,super._();
  

/// Выявленные проблемы, отсортированы по severity (HIGH → LOW).
 final  List<DiagnosisIssue> _issues;
/// Выявленные проблемы, отсортированы по severity (HIGH → LOW).
@override List<DiagnosisIssue> get issues {
  if (_issues is EqualUnmodifiableListView) return _issues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_issues);
}

/// Рекомендации, собранные по проблемам с дедупликацией.
 final  List<String> _recommendations;
/// Рекомендации, собранные по проблемам с дедупликацией.
@override List<String> get recommendations {
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendations);
}


/// Create a copy of PlantDiagnosis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantDiagnosisCopyWith<_PlantDiagnosis> get copyWith => __$PlantDiagnosisCopyWithImpl<_PlantDiagnosis>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantDiagnosis&&const DeepCollectionEquality().equals(other._issues, _issues)&&const DeepCollectionEquality().equals(other._recommendations, _recommendations));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_issues),const DeepCollectionEquality().hash(_recommendations));

@override
String toString() {
  return 'PlantDiagnosis(issues: $issues, recommendations: $recommendations)';
}


}

/// @nodoc
abstract mixin class _$PlantDiagnosisCopyWith<$Res> implements $PlantDiagnosisCopyWith<$Res> {
  factory _$PlantDiagnosisCopyWith(_PlantDiagnosis value, $Res Function(_PlantDiagnosis) _then) = __$PlantDiagnosisCopyWithImpl;
@override @useResult
$Res call({
 List<DiagnosisIssue> issues, List<String> recommendations
});




}
/// @nodoc
class __$PlantDiagnosisCopyWithImpl<$Res>
    implements _$PlantDiagnosisCopyWith<$Res> {
  __$PlantDiagnosisCopyWithImpl(this._self, this._then);

  final _PlantDiagnosis _self;
  final $Res Function(_PlantDiagnosis) _then;

/// Create a copy of PlantDiagnosis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? issues = null,Object? recommendations = null,}) {
  return _then(_PlantDiagnosis(
issues: null == issues ? _self._issues : issues // ignore: cast_nullable_to_non_nullable
as List<DiagnosisIssue>,recommendations: null == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
