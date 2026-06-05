// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantEvent {

/// Идентификатор события (backend `id`).
 int get id;/// Тип события (пересадка / замена грунта / обрезка / обработка).
 PlantEventType get eventType;/// Момент события в UTC. Показывать в локальной TZ.
 DateTime get eventDate;/// Необязательный комментарий пользователя.
 String? get comment;
/// Create a copy of PlantEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantEventCopyWith<PlantEvent> get copyWith => _$PlantEventCopyWithImpl<PlantEvent>(this as PlantEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.comment, comment) || other.comment == comment));
}


@override
int get hashCode => Object.hash(runtimeType,id,eventType,eventDate,comment);

@override
String toString() {
  return 'PlantEvent(id: $id, eventType: $eventType, eventDate: $eventDate, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $PlantEventCopyWith<$Res>  {
  factory $PlantEventCopyWith(PlantEvent value, $Res Function(PlantEvent) _then) = _$PlantEventCopyWithImpl;
@useResult
$Res call({
 int id, PlantEventType eventType, DateTime eventDate, String? comment
});




}
/// @nodoc
class _$PlantEventCopyWithImpl<$Res>
    implements $PlantEventCopyWith<$Res> {
  _$PlantEventCopyWithImpl(this._self, this._then);

  final PlantEvent _self;
  final $Res Function(PlantEvent) _then;

/// Create a copy of PlantEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventType = null,Object? eventDate = null,Object? comment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as PlantEventType,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantEvent].
extension PlantEventPatterns on PlantEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantEvent value)  $default,){
final _that = this;
switch (_that) {
case _PlantEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantEvent value)?  $default,){
final _that = this;
switch (_that) {
case _PlantEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  PlantEventType eventType,  DateTime eventDate,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantEvent() when $default != null:
return $default(_that.id,_that.eventType,_that.eventDate,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  PlantEventType eventType,  DateTime eventDate,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _PlantEvent():
return $default(_that.id,_that.eventType,_that.eventDate,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  PlantEventType eventType,  DateTime eventDate,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _PlantEvent() when $default != null:
return $default(_that.id,_that.eventType,_that.eventDate,_that.comment);case _:
  return null;

}
}

}

/// @nodoc


class _PlantEvent implements PlantEvent {
  const _PlantEvent({required this.id, required this.eventType, required this.eventDate, this.comment});
  

/// Идентификатор события (backend `id`).
@override final  int id;
/// Тип события (пересадка / замена грунта / обрезка / обработка).
@override final  PlantEventType eventType;
/// Момент события в UTC. Показывать в локальной TZ.
@override final  DateTime eventDate;
/// Необязательный комментарий пользователя.
@override final  String? comment;

/// Create a copy of PlantEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantEventCopyWith<_PlantEvent> get copyWith => __$PlantEventCopyWithImpl<_PlantEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.comment, comment) || other.comment == comment));
}


@override
int get hashCode => Object.hash(runtimeType,id,eventType,eventDate,comment);

@override
String toString() {
  return 'PlantEvent(id: $id, eventType: $eventType, eventDate: $eventDate, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$PlantEventCopyWith<$Res> implements $PlantEventCopyWith<$Res> {
  factory _$PlantEventCopyWith(_PlantEvent value, $Res Function(_PlantEvent) _then) = __$PlantEventCopyWithImpl;
@override @useResult
$Res call({
 int id, PlantEventType eventType, DateTime eventDate, String? comment
});




}
/// @nodoc
class __$PlantEventCopyWithImpl<$Res>
    implements _$PlantEventCopyWith<$Res> {
  __$PlantEventCopyWithImpl(this._self, this._then);

  final _PlantEvent _self;
  final $Res Function(_PlantEvent) _then;

/// Create a copy of PlantEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventType = null,Object? eventDate = null,Object? comment = freezed,}) {
  return _then(_PlantEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as PlantEventType,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
