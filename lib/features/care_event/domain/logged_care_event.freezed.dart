// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logged_care_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoggedCareEvent {

/// Идентификатор записи `care_history`.
 int get id; int get plantId; String get plantName; CareEventKind get type;/// Момент выполнения в UTC (как вернул backend).
 DateTime get performedAtUtc;/// Выполнено до дедлайна расписания (влияет на стрик).
 bool get onTime; String? get note;/// Эхо clientId идемпотентности (если был передан).
 String? get clientId;
/// Create a copy of LoggedCareEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoggedCareEventCopyWith<LoggedCareEvent> get copyWith => _$LoggedCareEventCopyWithImpl<LoggedCareEvent>(this as LoggedCareEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoggedCareEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.plantName, plantName) || other.plantName == plantName)&&(identical(other.type, type) || other.type == type)&&(identical(other.performedAtUtc, performedAtUtc) || other.performedAtUtc == performedAtUtc)&&(identical(other.onTime, onTime) || other.onTime == onTime)&&(identical(other.note, note) || other.note == note)&&(identical(other.clientId, clientId) || other.clientId == clientId));
}


@override
int get hashCode => Object.hash(runtimeType,id,plantId,plantName,type,performedAtUtc,onTime,note,clientId);

@override
String toString() {
  return 'LoggedCareEvent(id: $id, plantId: $plantId, plantName: $plantName, type: $type, performedAtUtc: $performedAtUtc, onTime: $onTime, note: $note, clientId: $clientId)';
}


}

/// @nodoc
abstract mixin class $LoggedCareEventCopyWith<$Res>  {
  factory $LoggedCareEventCopyWith(LoggedCareEvent value, $Res Function(LoggedCareEvent) _then) = _$LoggedCareEventCopyWithImpl;
@useResult
$Res call({
 int id, int plantId, String plantName, CareEventKind type, DateTime performedAtUtc, bool onTime, String? note, String? clientId
});




}
/// @nodoc
class _$LoggedCareEventCopyWithImpl<$Res>
    implements $LoggedCareEventCopyWith<$Res> {
  _$LoggedCareEventCopyWithImpl(this._self, this._then);

  final LoggedCareEvent _self;
  final $Res Function(LoggedCareEvent) _then;

/// Create a copy of LoggedCareEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? plantId = null,Object? plantName = null,Object? type = null,Object? performedAtUtc = null,Object? onTime = null,Object? note = freezed,Object? clientId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,plantName: null == plantName ? _self.plantName : plantName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareEventKind,performedAtUtc: null == performedAtUtc ? _self.performedAtUtc : performedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,onTime: null == onTime ? _self.onTime : onTime // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoggedCareEvent].
extension LoggedCareEventPatterns on LoggedCareEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoggedCareEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoggedCareEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoggedCareEvent value)  $default,){
final _that = this;
switch (_that) {
case _LoggedCareEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoggedCareEvent value)?  $default,){
final _that = this;
switch (_that) {
case _LoggedCareEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int plantId,  String plantName,  CareEventKind type,  DateTime performedAtUtc,  bool onTime,  String? note,  String? clientId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoggedCareEvent() when $default != null:
return $default(_that.id,_that.plantId,_that.plantName,_that.type,_that.performedAtUtc,_that.onTime,_that.note,_that.clientId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int plantId,  String plantName,  CareEventKind type,  DateTime performedAtUtc,  bool onTime,  String? note,  String? clientId)  $default,) {final _that = this;
switch (_that) {
case _LoggedCareEvent():
return $default(_that.id,_that.plantId,_that.plantName,_that.type,_that.performedAtUtc,_that.onTime,_that.note,_that.clientId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int plantId,  String plantName,  CareEventKind type,  DateTime performedAtUtc,  bool onTime,  String? note,  String? clientId)?  $default,) {final _that = this;
switch (_that) {
case _LoggedCareEvent() when $default != null:
return $default(_that.id,_that.plantId,_that.plantName,_that.type,_that.performedAtUtc,_that.onTime,_that.note,_that.clientId);case _:
  return null;

}
}

}

/// @nodoc


class _LoggedCareEvent implements LoggedCareEvent {
  const _LoggedCareEvent({required this.id, required this.plantId, required this.plantName, required this.type, required this.performedAtUtc, required this.onTime, this.note, this.clientId});
  

/// Идентификатор записи `care_history`.
@override final  int id;
@override final  int plantId;
@override final  String plantName;
@override final  CareEventKind type;
/// Момент выполнения в UTC (как вернул backend).
@override final  DateTime performedAtUtc;
/// Выполнено до дедлайна расписания (влияет на стрик).
@override final  bool onTime;
@override final  String? note;
/// Эхо clientId идемпотентности (если был передан).
@override final  String? clientId;

/// Create a copy of LoggedCareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoggedCareEventCopyWith<_LoggedCareEvent> get copyWith => __$LoggedCareEventCopyWithImpl<_LoggedCareEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoggedCareEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.plantName, plantName) || other.plantName == plantName)&&(identical(other.type, type) || other.type == type)&&(identical(other.performedAtUtc, performedAtUtc) || other.performedAtUtc == performedAtUtc)&&(identical(other.onTime, onTime) || other.onTime == onTime)&&(identical(other.note, note) || other.note == note)&&(identical(other.clientId, clientId) || other.clientId == clientId));
}


@override
int get hashCode => Object.hash(runtimeType,id,plantId,plantName,type,performedAtUtc,onTime,note,clientId);

@override
String toString() {
  return 'LoggedCareEvent(id: $id, plantId: $plantId, plantName: $plantName, type: $type, performedAtUtc: $performedAtUtc, onTime: $onTime, note: $note, clientId: $clientId)';
}


}

/// @nodoc
abstract mixin class _$LoggedCareEventCopyWith<$Res> implements $LoggedCareEventCopyWith<$Res> {
  factory _$LoggedCareEventCopyWith(_LoggedCareEvent value, $Res Function(_LoggedCareEvent) _then) = __$LoggedCareEventCopyWithImpl;
@override @useResult
$Res call({
 int id, int plantId, String plantName, CareEventKind type, DateTime performedAtUtc, bool onTime, String? note, String? clientId
});




}
/// @nodoc
class __$LoggedCareEventCopyWithImpl<$Res>
    implements _$LoggedCareEventCopyWith<$Res> {
  __$LoggedCareEventCopyWithImpl(this._self, this._then);

  final _LoggedCareEvent _self;
  final $Res Function(_LoggedCareEvent) _then;

/// Create a copy of LoggedCareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? plantId = null,Object? plantName = null,Object? type = null,Object? performedAtUtc = null,Object? onTime = null,Object? note = freezed,Object? clientId = freezed,}) {
  return _then(_LoggedCareEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,plantName: null == plantName ? _self.plantName : plantName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareEventKind,performedAtUtc: null == performedAtUtc ? _self.performedAtUtc : performedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,onTime: null == onTime ? _self.onTime : onTime // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
