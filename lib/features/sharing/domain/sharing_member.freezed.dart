// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sharing_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SharingMember {

/// Идентификатор приглашения (membership).
 int get id;/// Контакт приглашённого (@username или телефон).
 String get contact;/// Статус приглашения.
 SharingMemberStatus get status;/// Может ли приглашённый отмечать уход за растениями набора.
 bool get canLogCare;/// Растения, на которые распространяется приглашение.
 List<int> get plantIds;
/// Create a copy of SharingMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharingMemberCopyWith<SharingMember> get copyWith => _$SharingMemberCopyWithImpl<SharingMember>(this as SharingMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharingMember&&(identical(other.id, id) || other.id == id)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.status, status) || other.status == status)&&(identical(other.canLogCare, canLogCare) || other.canLogCare == canLogCare)&&const DeepCollectionEquality().equals(other.plantIds, plantIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,contact,status,canLogCare,const DeepCollectionEquality().hash(plantIds));

@override
String toString() {
  return 'SharingMember(id: $id, contact: $contact, status: $status, canLogCare: $canLogCare, plantIds: $plantIds)';
}


}

/// @nodoc
abstract mixin class $SharingMemberCopyWith<$Res>  {
  factory $SharingMemberCopyWith(SharingMember value, $Res Function(SharingMember) _then) = _$SharingMemberCopyWithImpl;
@useResult
$Res call({
 int id, String contact, SharingMemberStatus status, bool canLogCare, List<int> plantIds
});




}
/// @nodoc
class _$SharingMemberCopyWithImpl<$Res>
    implements $SharingMemberCopyWith<$Res> {
  _$SharingMemberCopyWithImpl(this._self, this._then);

  final SharingMember _self;
  final $Res Function(SharingMember) _then;

/// Create a copy of SharingMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contact = null,Object? status = null,Object? canLogCare = null,Object? plantIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SharingMemberStatus,canLogCare: null == canLogCare ? _self.canLogCare : canLogCare // ignore: cast_nullable_to_non_nullable
as bool,plantIds: null == plantIds ? _self.plantIds : plantIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [SharingMember].
extension SharingMemberPatterns on SharingMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharingMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharingMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharingMember value)  $default,){
final _that = this;
switch (_that) {
case _SharingMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharingMember value)?  $default,){
final _that = this;
switch (_that) {
case _SharingMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String contact,  SharingMemberStatus status,  bool canLogCare,  List<int> plantIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharingMember() when $default != null:
return $default(_that.id,_that.contact,_that.status,_that.canLogCare,_that.plantIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String contact,  SharingMemberStatus status,  bool canLogCare,  List<int> plantIds)  $default,) {final _that = this;
switch (_that) {
case _SharingMember():
return $default(_that.id,_that.contact,_that.status,_that.canLogCare,_that.plantIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String contact,  SharingMemberStatus status,  bool canLogCare,  List<int> plantIds)?  $default,) {final _that = this;
switch (_that) {
case _SharingMember() when $default != null:
return $default(_that.id,_that.contact,_that.status,_that.canLogCare,_that.plantIds);case _:
  return null;

}
}

}

/// @nodoc


class _SharingMember implements SharingMember {
  const _SharingMember({required this.id, required this.contact, required this.status, required this.canLogCare, required final  List<int> plantIds}): _plantIds = plantIds;
  

/// Идентификатор приглашения (membership).
@override final  int id;
/// Контакт приглашённого (@username или телефон).
@override final  String contact;
/// Статус приглашения.
@override final  SharingMemberStatus status;
/// Может ли приглашённый отмечать уход за растениями набора.
@override final  bool canLogCare;
/// Растения, на которые распространяется приглашение.
 final  List<int> _plantIds;
/// Растения, на которые распространяется приглашение.
@override List<int> get plantIds {
  if (_plantIds is EqualUnmodifiableListView) return _plantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plantIds);
}


/// Create a copy of SharingMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharingMemberCopyWith<_SharingMember> get copyWith => __$SharingMemberCopyWithImpl<_SharingMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharingMember&&(identical(other.id, id) || other.id == id)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.status, status) || other.status == status)&&(identical(other.canLogCare, canLogCare) || other.canLogCare == canLogCare)&&const DeepCollectionEquality().equals(other._plantIds, _plantIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,contact,status,canLogCare,const DeepCollectionEquality().hash(_plantIds));

@override
String toString() {
  return 'SharingMember(id: $id, contact: $contact, status: $status, canLogCare: $canLogCare, plantIds: $plantIds)';
}


}

/// @nodoc
abstract mixin class _$SharingMemberCopyWith<$Res> implements $SharingMemberCopyWith<$Res> {
  factory _$SharingMemberCopyWith(_SharingMember value, $Res Function(_SharingMember) _then) = __$SharingMemberCopyWithImpl;
@override @useResult
$Res call({
 int id, String contact, SharingMemberStatus status, bool canLogCare, List<int> plantIds
});




}
/// @nodoc
class __$SharingMemberCopyWithImpl<$Res>
    implements _$SharingMemberCopyWith<$Res> {
  __$SharingMemberCopyWithImpl(this._self, this._then);

  final _SharingMember _self;
  final $Res Function(_SharingMember) _then;

/// Create a copy of SharingMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contact = null,Object? status = null,Object? canLogCare = null,Object? plantIds = null,}) {
  return _then(_SharingMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SharingMemberStatus,canLogCare: null == canLogCare ? _self.canLogCare : canLogCare // ignore: cast_nullable_to_non_nullable
as bool,plantIds: null == plantIds ? _self._plantIds : plantIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
