// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_plant_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewPlantDraft {

/// Выбранный на шаге 1 вид. Его id уходит в `POST /plants` как `speciesId`
/// (null → растение без вида). Также используется для префилла имени и
/// превью плана ухода.
 SpeciesSummary? get species;/// Имя растения (шаг 2). Валидируется [isNameValid].
 String get name;/// Выбранная локация (шаг 2). null → backend положит в дефолтную локацию.
 int? get locationId;/// Заметки пользователя (шаг 4).
 String? get notes;
/// Create a copy of NewPlantDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewPlantDraftCopyWith<NewPlantDraft> get copyWith => _$NewPlantDraftCopyWithImpl<NewPlantDraft>(this as NewPlantDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewPlantDraft&&(identical(other.species, species) || other.species == species)&&(identical(other.name, name) || other.name == name)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,species,name,locationId,notes);

@override
String toString() {
  return 'NewPlantDraft(species: $species, name: $name, locationId: $locationId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $NewPlantDraftCopyWith<$Res>  {
  factory $NewPlantDraftCopyWith(NewPlantDraft value, $Res Function(NewPlantDraft) _then) = _$NewPlantDraftCopyWithImpl;
@useResult
$Res call({
 SpeciesSummary? species, String name, int? locationId, String? notes
});


$SpeciesSummaryCopyWith<$Res>? get species;

}
/// @nodoc
class _$NewPlantDraftCopyWithImpl<$Res>
    implements $NewPlantDraftCopyWith<$Res> {
  _$NewPlantDraftCopyWithImpl(this._self, this._then);

  final NewPlantDraft _self;
  final $Res Function(NewPlantDraft) _then;

/// Create a copy of NewPlantDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? species = freezed,Object? name = null,Object? locationId = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
species: freezed == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as SpeciesSummary?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of NewPlantDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeciesSummaryCopyWith<$Res>? get species {
    if (_self.species == null) {
    return null;
  }

  return $SpeciesSummaryCopyWith<$Res>(_self.species!, (value) {
    return _then(_self.copyWith(species: value));
  });
}
}


/// Adds pattern-matching-related methods to [NewPlantDraft].
extension NewPlantDraftPatterns on NewPlantDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewPlantDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewPlantDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewPlantDraft value)  $default,){
final _that = this;
switch (_that) {
case _NewPlantDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewPlantDraft value)?  $default,){
final _that = this;
switch (_that) {
case _NewPlantDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SpeciesSummary? species,  String name,  int? locationId,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewPlantDraft() when $default != null:
return $default(_that.species,_that.name,_that.locationId,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SpeciesSummary? species,  String name,  int? locationId,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _NewPlantDraft():
return $default(_that.species,_that.name,_that.locationId,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SpeciesSummary? species,  String name,  int? locationId,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _NewPlantDraft() when $default != null:
return $default(_that.species,_that.name,_that.locationId,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _NewPlantDraft extends NewPlantDraft {
  const _NewPlantDraft({this.species, this.name = '', this.locationId, this.notes}): super._();
  

/// Выбранный на шаге 1 вид. Его id уходит в `POST /plants` как `speciesId`
/// (null → растение без вида). Также используется для префилла имени и
/// превью плана ухода.
@override final  SpeciesSummary? species;
/// Имя растения (шаг 2). Валидируется [isNameValid].
@override@JsonKey() final  String name;
/// Выбранная локация (шаг 2). null → backend положит в дефолтную локацию.
@override final  int? locationId;
/// Заметки пользователя (шаг 4).
@override final  String? notes;

/// Create a copy of NewPlantDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewPlantDraftCopyWith<_NewPlantDraft> get copyWith => __$NewPlantDraftCopyWithImpl<_NewPlantDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewPlantDraft&&(identical(other.species, species) || other.species == species)&&(identical(other.name, name) || other.name == name)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,species,name,locationId,notes);

@override
String toString() {
  return 'NewPlantDraft(species: $species, name: $name, locationId: $locationId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$NewPlantDraftCopyWith<$Res> implements $NewPlantDraftCopyWith<$Res> {
  factory _$NewPlantDraftCopyWith(_NewPlantDraft value, $Res Function(_NewPlantDraft) _then) = __$NewPlantDraftCopyWithImpl;
@override @useResult
$Res call({
 SpeciesSummary? species, String name, int? locationId, String? notes
});


@override $SpeciesSummaryCopyWith<$Res>? get species;

}
/// @nodoc
class __$NewPlantDraftCopyWithImpl<$Res>
    implements _$NewPlantDraftCopyWith<$Res> {
  __$NewPlantDraftCopyWithImpl(this._self, this._then);

  final _NewPlantDraft _self;
  final $Res Function(_NewPlantDraft) _then;

/// Create a copy of NewPlantDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? species = freezed,Object? name = null,Object? locationId = freezed,Object? notes = freezed,}) {
  return _then(_NewPlantDraft(
species: freezed == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as SpeciesSummary?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of NewPlantDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeciesSummaryCopyWith<$Res>? get species {
    if (_self.species == null) {
    return null;
  }

  return $SpeciesSummaryCopyWith<$Res>(_self.species!, (value) {
    return _then(_self.copyWith(species: value));
  });
}
}

// dart format on
