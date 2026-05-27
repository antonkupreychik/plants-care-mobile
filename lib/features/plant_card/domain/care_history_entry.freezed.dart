// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareHistoryEntry {

 int get id; int get plantId; String get plantName;/// Тип события ухода (нормализован из `CareEventResponse.type`).
 CareEventKind get kind;/// Момент выполнения ухода (UTC). UI показывает в TZ пользователя.
 DateTime get performedAt;/// Выполнено «в срок» — до дедлайна расписания (база для стрика).
 bool get onTime;/// Заметка пользователя к событию, если была.
 String? get note;
/// Create a copy of CareHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareHistoryEntryCopyWith<CareHistoryEntry> get copyWith => _$CareHistoryEntryCopyWithImpl<CareHistoryEntry>(this as CareHistoryEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.plantName, plantName) || other.plantName == plantName)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.performedAt, performedAt) || other.performedAt == performedAt)&&(identical(other.onTime, onTime) || other.onTime == onTime)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,plantId,plantName,kind,performedAt,onTime,note);

@override
String toString() {
  return 'CareHistoryEntry(id: $id, plantId: $plantId, plantName: $plantName, kind: $kind, performedAt: $performedAt, onTime: $onTime, note: $note)';
}


}

/// @nodoc
abstract mixin class $CareHistoryEntryCopyWith<$Res>  {
  factory $CareHistoryEntryCopyWith(CareHistoryEntry value, $Res Function(CareHistoryEntry) _then) = _$CareHistoryEntryCopyWithImpl;
@useResult
$Res call({
 int id, int plantId, String plantName, CareEventKind kind, DateTime performedAt, bool onTime, String? note
});




}
/// @nodoc
class _$CareHistoryEntryCopyWithImpl<$Res>
    implements $CareHistoryEntryCopyWith<$Res> {
  _$CareHistoryEntryCopyWithImpl(this._self, this._then);

  final CareHistoryEntry _self;
  final $Res Function(CareHistoryEntry) _then;

/// Create a copy of CareHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? plantId = null,Object? plantName = null,Object? kind = null,Object? performedAt = null,Object? onTime = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,plantName: null == plantName ? _self.plantName : plantName // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CareEventKind,performedAt: null == performedAt ? _self.performedAt : performedAt // ignore: cast_nullable_to_non_nullable
as DateTime,onTime: null == onTime ? _self.onTime : onTime // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CareHistoryEntry].
extension CareHistoryEntryPatterns on CareHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _CareHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CareHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int plantId,  String plantName,  CareEventKind kind,  DateTime performedAt,  bool onTime,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareHistoryEntry() when $default != null:
return $default(_that.id,_that.plantId,_that.plantName,_that.kind,_that.performedAt,_that.onTime,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int plantId,  String plantName,  CareEventKind kind,  DateTime performedAt,  bool onTime,  String? note)  $default,) {final _that = this;
switch (_that) {
case _CareHistoryEntry():
return $default(_that.id,_that.plantId,_that.plantName,_that.kind,_that.performedAt,_that.onTime,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int plantId,  String plantName,  CareEventKind kind,  DateTime performedAt,  bool onTime,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _CareHistoryEntry() when $default != null:
return $default(_that.id,_that.plantId,_that.plantName,_that.kind,_that.performedAt,_that.onTime,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _CareHistoryEntry implements CareHistoryEntry {
  const _CareHistoryEntry({required this.id, required this.plantId, required this.plantName, required this.kind, required this.performedAt, required this.onTime, this.note});
  

@override final  int id;
@override final  int plantId;
@override final  String plantName;
/// Тип события ухода (нормализован из `CareEventResponse.type`).
@override final  CareEventKind kind;
/// Момент выполнения ухода (UTC). UI показывает в TZ пользователя.
@override final  DateTime performedAt;
/// Выполнено «в срок» — до дедлайна расписания (база для стрика).
@override final  bool onTime;
/// Заметка пользователя к событию, если была.
@override final  String? note;

/// Create a copy of CareHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareHistoryEntryCopyWith<_CareHistoryEntry> get copyWith => __$CareHistoryEntryCopyWithImpl<_CareHistoryEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.plantName, plantName) || other.plantName == plantName)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.performedAt, performedAt) || other.performedAt == performedAt)&&(identical(other.onTime, onTime) || other.onTime == onTime)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,plantId,plantName,kind,performedAt,onTime,note);

@override
String toString() {
  return 'CareHistoryEntry(id: $id, plantId: $plantId, plantName: $plantName, kind: $kind, performedAt: $performedAt, onTime: $onTime, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CareHistoryEntryCopyWith<$Res> implements $CareHistoryEntryCopyWith<$Res> {
  factory _$CareHistoryEntryCopyWith(_CareHistoryEntry value, $Res Function(_CareHistoryEntry) _then) = __$CareHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, int plantId, String plantName, CareEventKind kind, DateTime performedAt, bool onTime, String? note
});




}
/// @nodoc
class __$CareHistoryEntryCopyWithImpl<$Res>
    implements _$CareHistoryEntryCopyWith<$Res> {
  __$CareHistoryEntryCopyWithImpl(this._self, this._then);

  final _CareHistoryEntry _self;
  final $Res Function(_CareHistoryEntry) _then;

/// Create a copy of CareHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? plantId = null,Object? plantName = null,Object? kind = null,Object? performedAt = null,Object? onTime = null,Object? note = freezed,}) {
  return _then(_CareHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,plantName: null == plantName ? _self.plantName : plantName // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CareEventKind,performedAt: null == performedAt ? _self.performedAt : performedAt // ignore: cast_nullable_to_non_nullable
as DateTime,onTime: null == onTime ? _self.onTime : onTime // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
