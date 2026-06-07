// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileDraft {

/// Имя — только для отображения (read-only на форме, PATCH /me не меняет имя).
 String? get displayName;/// Начало тихих часов в формате `HH:mm`.
 String get quietHoursStart;/// Конец тихих часов в формате `HH:mm`.
 String get quietHoursEnd;/// IANA-идентификатор таймзоны пользователя (например, `Europe/Moscow`).
 String get timezone;
/// Create a copy of EditProfileDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileDraftCopyWith<EditProfileDraft> get copyWith => _$EditProfileDraftCopyWithImpl<EditProfileDraft>(this as EditProfileDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileDraft&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}


@override
int get hashCode => Object.hash(runtimeType,displayName,quietHoursStart,quietHoursEnd,timezone);

@override
String toString() {
  return 'EditProfileDraft(displayName: $displayName, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $EditProfileDraftCopyWith<$Res>  {
  factory $EditProfileDraftCopyWith(EditProfileDraft value, $Res Function(EditProfileDraft) _then) = _$EditProfileDraftCopyWithImpl;
@useResult
$Res call({
 String? displayName, String quietHoursStart, String quietHoursEnd, String timezone
});




}
/// @nodoc
class _$EditProfileDraftCopyWithImpl<$Res>
    implements $EditProfileDraftCopyWith<$Res> {
  _$EditProfileDraftCopyWithImpl(this._self, this._then);

  final EditProfileDraft _self;
  final $Res Function(EditProfileDraft) _then;

/// Create a copy of EditProfileDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = freezed,Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? timezone = null,}) {
  return _then(_self.copyWith(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EditProfileDraft].
extension EditProfileDraftPatterns on EditProfileDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditProfileDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditProfileDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditProfileDraft value)  $default,){
final _that = this;
switch (_that) {
case _EditProfileDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditProfileDraft value)?  $default,){
final _that = this;
switch (_that) {
case _EditProfileDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? displayName,  String quietHoursStart,  String quietHoursEnd,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditProfileDraft() when $default != null:
return $default(_that.displayName,_that.quietHoursStart,_that.quietHoursEnd,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? displayName,  String quietHoursStart,  String quietHoursEnd,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _EditProfileDraft():
return $default(_that.displayName,_that.quietHoursStart,_that.quietHoursEnd,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? displayName,  String quietHoursStart,  String quietHoursEnd,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _EditProfileDraft() when $default != null:
return $default(_that.displayName,_that.quietHoursStart,_that.quietHoursEnd,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc


class _EditProfileDraft implements EditProfileDraft {
  const _EditProfileDraft({this.displayName, required this.quietHoursStart, required this.quietHoursEnd, required this.timezone});
  

/// Имя — только для отображения (read-only на форме, PATCH /me не меняет имя).
@override final  String? displayName;
/// Начало тихих часов в формате `HH:mm`.
@override final  String quietHoursStart;
/// Конец тихих часов в формате `HH:mm`.
@override final  String quietHoursEnd;
/// IANA-идентификатор таймзоны пользователя (например, `Europe/Moscow`).
@override final  String timezone;

/// Create a copy of EditProfileDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileDraftCopyWith<_EditProfileDraft> get copyWith => __$EditProfileDraftCopyWithImpl<_EditProfileDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileDraft&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}


@override
int get hashCode => Object.hash(runtimeType,displayName,quietHoursStart,quietHoursEnd,timezone);

@override
String toString() {
  return 'EditProfileDraft(displayName: $displayName, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$EditProfileDraftCopyWith<$Res> implements $EditProfileDraftCopyWith<$Res> {
  factory _$EditProfileDraftCopyWith(_EditProfileDraft value, $Res Function(_EditProfileDraft) _then) = __$EditProfileDraftCopyWithImpl;
@override @useResult
$Res call({
 String? displayName, String quietHoursStart, String quietHoursEnd, String timezone
});




}
/// @nodoc
class __$EditProfileDraftCopyWithImpl<$Res>
    implements _$EditProfileDraftCopyWith<$Res> {
  __$EditProfileDraftCopyWithImpl(this._self, this._then);

  final _EditProfileDraft _self;
  final $Res Function(_EditProfileDraft) _then;

/// Create a copy of EditProfileDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = freezed,Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? timezone = null,}) {
  return _then(_EditProfileDraft(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
