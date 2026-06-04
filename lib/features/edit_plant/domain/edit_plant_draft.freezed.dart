// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_plant_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditPlantDraft {

 String get name; String? get notes; int? get locationId;/// speciesId будет поддержан после plants-care#228;
/// до этого поле задизейблено.
 int? get speciesId;
/// Create a copy of EditPlantDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditPlantDraftCopyWith<EditPlantDraft> get copyWith => _$EditPlantDraftCopyWithImpl<EditPlantDraft>(this as EditPlantDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditPlantDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.speciesId, speciesId) || other.speciesId == speciesId));
}


@override
int get hashCode => Object.hash(runtimeType,name,notes,locationId,speciesId);

@override
String toString() {
  return 'EditPlantDraft(name: $name, notes: $notes, locationId: $locationId, speciesId: $speciesId)';
}


}

/// @nodoc
abstract mixin class $EditPlantDraftCopyWith<$Res>  {
  factory $EditPlantDraftCopyWith(EditPlantDraft value, $Res Function(EditPlantDraft) _then) = _$EditPlantDraftCopyWithImpl;
@useResult
$Res call({
 String name, String? notes, int? locationId, int? speciesId
});




}
/// @nodoc
class _$EditPlantDraftCopyWithImpl<$Res>
    implements $EditPlantDraftCopyWith<$Res> {
  _$EditPlantDraftCopyWithImpl(this._self, this._then);

  final EditPlantDraft _self;
  final $Res Function(EditPlantDraft) _then;

/// Create a copy of EditPlantDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? notes = freezed,Object? locationId = freezed,Object? speciesId = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,speciesId: freezed == speciesId ? _self.speciesId : speciesId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditPlantDraft].
extension EditPlantDraftPatterns on EditPlantDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditPlantDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditPlantDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditPlantDraft value)  $default,){
final _that = this;
switch (_that) {
case _EditPlantDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditPlantDraft value)?  $default,){
final _that = this;
switch (_that) {
case _EditPlantDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? notes,  int? locationId,  int? speciesId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditPlantDraft() when $default != null:
return $default(_that.name,_that.notes,_that.locationId,_that.speciesId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? notes,  int? locationId,  int? speciesId)  $default,) {final _that = this;
switch (_that) {
case _EditPlantDraft():
return $default(_that.name,_that.notes,_that.locationId,_that.speciesId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? notes,  int? locationId,  int? speciesId)?  $default,) {final _that = this;
switch (_that) {
case _EditPlantDraft() when $default != null:
return $default(_that.name,_that.notes,_that.locationId,_that.speciesId);case _:
  return null;

}
}

}

/// @nodoc


class _EditPlantDraft implements EditPlantDraft {
  const _EditPlantDraft({required this.name, this.notes, this.locationId, this.speciesId});
  

@override final  String name;
@override final  String? notes;
@override final  int? locationId;
/// speciesId будет поддержан после plants-care#228;
/// до этого поле задизейблено.
@override final  int? speciesId;

/// Create a copy of EditPlantDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditPlantDraftCopyWith<_EditPlantDraft> get copyWith => __$EditPlantDraftCopyWithImpl<_EditPlantDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditPlantDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.speciesId, speciesId) || other.speciesId == speciesId));
}


@override
int get hashCode => Object.hash(runtimeType,name,notes,locationId,speciesId);

@override
String toString() {
  return 'EditPlantDraft(name: $name, notes: $notes, locationId: $locationId, speciesId: $speciesId)';
}


}

/// @nodoc
abstract mixin class _$EditPlantDraftCopyWith<$Res> implements $EditPlantDraftCopyWith<$Res> {
  factory _$EditPlantDraftCopyWith(_EditPlantDraft value, $Res Function(_EditPlantDraft) _then) = __$EditPlantDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, String? notes, int? locationId, int? speciesId
});




}
/// @nodoc
class __$EditPlantDraftCopyWithImpl<$Res>
    implements _$EditPlantDraftCopyWith<$Res> {
  __$EditPlantDraftCopyWithImpl(this._self, this._then);

  final _EditPlantDraft _self;
  final $Res Function(_EditPlantDraft) _then;

/// Create a copy of EditPlantDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? notes = freezed,Object? locationId = freezed,Object? speciesId = freezed,}) {
  return _then(_EditPlantDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,speciesId: freezed == speciesId ? _self.speciesId : speciesId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
