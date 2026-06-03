// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnosis_issue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiagnosisIssue {

/// Семантический код проблемы (строка, не enum — forward-совместимость).
 String get code;/// Серьёзность проблемы.
 DiagnosisSeverity get severity;/// Человекочитаемый заголовок (локализован на стороне backend).
 String get title;
/// Create a copy of DiagnosisIssue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosisIssueCopyWith<DiagnosisIssue> get copyWith => _$DiagnosisIssueCopyWithImpl<DiagnosisIssue>(this as DiagnosisIssue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosisIssue&&(identical(other.code, code) || other.code == code)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,code,severity,title);

@override
String toString() {
  return 'DiagnosisIssue(code: $code, severity: $severity, title: $title)';
}


}

/// @nodoc
abstract mixin class $DiagnosisIssueCopyWith<$Res>  {
  factory $DiagnosisIssueCopyWith(DiagnosisIssue value, $Res Function(DiagnosisIssue) _then) = _$DiagnosisIssueCopyWithImpl;
@useResult
$Res call({
 String code, DiagnosisSeverity severity, String title
});




}
/// @nodoc
class _$DiagnosisIssueCopyWithImpl<$Res>
    implements $DiagnosisIssueCopyWith<$Res> {
  _$DiagnosisIssueCopyWithImpl(this._self, this._then);

  final DiagnosisIssue _self;
  final $Res Function(DiagnosisIssue) _then;

/// Create a copy of DiagnosisIssue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? severity = null,Object? title = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as DiagnosisSeverity,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagnosisIssue].
extension DiagnosisIssuePatterns on DiagnosisIssue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosisIssue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosisIssue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosisIssue value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosisIssue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosisIssue value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosisIssue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  DiagnosisSeverity severity,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosisIssue() when $default != null:
return $default(_that.code,_that.severity,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  DiagnosisSeverity severity,  String title)  $default,) {final _that = this;
switch (_that) {
case _DiagnosisIssue():
return $default(_that.code,_that.severity,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  DiagnosisSeverity severity,  String title)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosisIssue() when $default != null:
return $default(_that.code,_that.severity,_that.title);case _:
  return null;

}
}

}

/// @nodoc


class _DiagnosisIssue implements DiagnosisIssue {
  const _DiagnosisIssue({required this.code, required this.severity, required this.title});
  

/// Семантический код проблемы (строка, не enum — forward-совместимость).
@override final  String code;
/// Серьёзность проблемы.
@override final  DiagnosisSeverity severity;
/// Человекочитаемый заголовок (локализован на стороне backend).
@override final  String title;

/// Create a copy of DiagnosisIssue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosisIssueCopyWith<_DiagnosisIssue> get copyWith => __$DiagnosisIssueCopyWithImpl<_DiagnosisIssue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosisIssue&&(identical(other.code, code) || other.code == code)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,code,severity,title);

@override
String toString() {
  return 'DiagnosisIssue(code: $code, severity: $severity, title: $title)';
}


}

/// @nodoc
abstract mixin class _$DiagnosisIssueCopyWith<$Res> implements $DiagnosisIssueCopyWith<$Res> {
  factory _$DiagnosisIssueCopyWith(_DiagnosisIssue value, $Res Function(_DiagnosisIssue) _then) = __$DiagnosisIssueCopyWithImpl;
@override @useResult
$Res call({
 String code, DiagnosisSeverity severity, String title
});




}
/// @nodoc
class __$DiagnosisIssueCopyWithImpl<$Res>
    implements _$DiagnosisIssueCopyWith<$Res> {
  __$DiagnosisIssueCopyWithImpl(this._self, this._then);

  final _DiagnosisIssue _self;
  final $Res Function(_DiagnosisIssue) _then;

/// Create a copy of DiagnosisIssue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? severity = null,Object? title = null,}) {
  return _then(_DiagnosisIssue(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as DiagnosisSeverity,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
