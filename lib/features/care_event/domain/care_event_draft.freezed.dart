// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_event_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareEventDraft {

/// Растение, для которого отмечается уход.
 int get plantId;/// Выбранный тип ухода. `unknown` невалиден для отправки.
 CareEventKind get type;/// Момент выполнения в UTC. По умолчанию — «сейчас» (ставит presentation),
/// допускается прошлое (backdating).
 DateTime get performedAtUtc;/// Необязательная заметка.
 String? get note;/// UUID идемпотентности; null до момента отправки.
 String? get clientId;
/// Create a copy of CareEventDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareEventDraftCopyWith<CareEventDraft> get copyWith => _$CareEventDraftCopyWithImpl<CareEventDraft>(this as CareEventDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareEventDraft&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.type, type) || other.type == type)&&(identical(other.performedAtUtc, performedAtUtc) || other.performedAtUtc == performedAtUtc)&&(identical(other.note, note) || other.note == note)&&(identical(other.clientId, clientId) || other.clientId == clientId));
}


@override
int get hashCode => Object.hash(runtimeType,plantId,type,performedAtUtc,note,clientId);

@override
String toString() {
  return 'CareEventDraft(plantId: $plantId, type: $type, performedAtUtc: $performedAtUtc, note: $note, clientId: $clientId)';
}


}

/// @nodoc
abstract mixin class $CareEventDraftCopyWith<$Res>  {
  factory $CareEventDraftCopyWith(CareEventDraft value, $Res Function(CareEventDraft) _then) = _$CareEventDraftCopyWithImpl;
@useResult
$Res call({
 int plantId, CareEventKind type, DateTime performedAtUtc, String? note, String? clientId
});




}
/// @nodoc
class _$CareEventDraftCopyWithImpl<$Res>
    implements $CareEventDraftCopyWith<$Res> {
  _$CareEventDraftCopyWithImpl(this._self, this._then);

  final CareEventDraft _self;
  final $Res Function(CareEventDraft) _then;

/// Create a copy of CareEventDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plantId = null,Object? type = null,Object? performedAtUtc = null,Object? note = freezed,Object? clientId = freezed,}) {
  return _then(_self.copyWith(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareEventKind,performedAtUtc: null == performedAtUtc ? _self.performedAtUtc : performedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CareEventDraft].
extension CareEventDraftPatterns on CareEventDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareEventDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareEventDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareEventDraft value)  $default,){
final _that = this;
switch (_that) {
case _CareEventDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareEventDraft value)?  $default,){
final _that = this;
switch (_that) {
case _CareEventDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int plantId,  CareEventKind type,  DateTime performedAtUtc,  String? note,  String? clientId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareEventDraft() when $default != null:
return $default(_that.plantId,_that.type,_that.performedAtUtc,_that.note,_that.clientId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int plantId,  CareEventKind type,  DateTime performedAtUtc,  String? note,  String? clientId)  $default,) {final _that = this;
switch (_that) {
case _CareEventDraft():
return $default(_that.plantId,_that.type,_that.performedAtUtc,_that.note,_that.clientId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int plantId,  CareEventKind type,  DateTime performedAtUtc,  String? note,  String? clientId)?  $default,) {final _that = this;
switch (_that) {
case _CareEventDraft() when $default != null:
return $default(_that.plantId,_that.type,_that.performedAtUtc,_that.note,_that.clientId);case _:
  return null;

}
}

}

/// @nodoc


class _CareEventDraft implements CareEventDraft {
  const _CareEventDraft({required this.plantId, required this.type, required this.performedAtUtc, this.note, this.clientId});
  

/// Растение, для которого отмечается уход.
@override final  int plantId;
/// Выбранный тип ухода. `unknown` невалиден для отправки.
@override final  CareEventKind type;
/// Момент выполнения в UTC. По умолчанию — «сейчас» (ставит presentation),
/// допускается прошлое (backdating).
@override final  DateTime performedAtUtc;
/// Необязательная заметка.
@override final  String? note;
/// UUID идемпотентности; null до момента отправки.
@override final  String? clientId;

/// Create a copy of CareEventDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareEventDraftCopyWith<_CareEventDraft> get copyWith => __$CareEventDraftCopyWithImpl<_CareEventDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareEventDraft&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.type, type) || other.type == type)&&(identical(other.performedAtUtc, performedAtUtc) || other.performedAtUtc == performedAtUtc)&&(identical(other.note, note) || other.note == note)&&(identical(other.clientId, clientId) || other.clientId == clientId));
}


@override
int get hashCode => Object.hash(runtimeType,plantId,type,performedAtUtc,note,clientId);

@override
String toString() {
  return 'CareEventDraft(plantId: $plantId, type: $type, performedAtUtc: $performedAtUtc, note: $note, clientId: $clientId)';
}


}

/// @nodoc
abstract mixin class _$CareEventDraftCopyWith<$Res> implements $CareEventDraftCopyWith<$Res> {
  factory _$CareEventDraftCopyWith(_CareEventDraft value, $Res Function(_CareEventDraft) _then) = __$CareEventDraftCopyWithImpl;
@override @useResult
$Res call({
 int plantId, CareEventKind type, DateTime performedAtUtc, String? note, String? clientId
});




}
/// @nodoc
class __$CareEventDraftCopyWithImpl<$Res>
    implements _$CareEventDraftCopyWith<$Res> {
  __$CareEventDraftCopyWithImpl(this._self, this._then);

  final _CareEventDraft _self;
  final $Res Function(_CareEventDraft) _then;

/// Create a copy of CareEventDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plantId = null,Object? type = null,Object? performedAtUtc = null,Object? note = freezed,Object? clientId = freezed,}) {
  return _then(_CareEventDraft(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareEventKind,performedAtUtc: null == performedAtUtc ? _self.performedAtUtc : performedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
