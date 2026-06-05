// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileSummary {

/// Отображаемое имя пользователя. `null` → UI показывает
/// «Пользователь» (анонимный).
 String? get name;/// Email пользователя. `null` для чисто Telegram-юзеров — UI не показывает
/// строку email.
 String? get email;/// URL аватара. `null` → initials-плейсхолдер. На текущей схеме backend
/// всегда отдаёт `null` (нет хранилища аватаров).
 String? get avatar;/// Момент регистрации (UTC). Шапка форматирует как «С нами с {MMM yyyy}».
 DateTime get createdAt;/// Число неархивированных растений пользователя.
 int get plantsTotal;/// Число уходов за всё время. `null` пока backend не отдаёт поле
/// (plants-care#226) — блок «Уходов» скрыт.
 int? get totalCareEvents;
/// Create a copy of ProfileSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSummaryCopyWith<ProfileSummary> get copyWith => _$ProfileSummaryCopyWithImpl<ProfileSummary>(this as ProfileSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSummary&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.plantsTotal, plantsTotal) || other.plantsTotal == plantsTotal)&&(identical(other.totalCareEvents, totalCareEvents) || other.totalCareEvents == totalCareEvents));
}


@override
int get hashCode => Object.hash(runtimeType,name,email,avatar,createdAt,plantsTotal,totalCareEvents);

@override
String toString() {
  return 'ProfileSummary(name: $name, email: $email, avatar: $avatar, createdAt: $createdAt, plantsTotal: $plantsTotal, totalCareEvents: $totalCareEvents)';
}


}

/// @nodoc
abstract mixin class $ProfileSummaryCopyWith<$Res>  {
  factory $ProfileSummaryCopyWith(ProfileSummary value, $Res Function(ProfileSummary) _then) = _$ProfileSummaryCopyWithImpl;
@useResult
$Res call({
 String? name, String? email, String? avatar, DateTime createdAt, int plantsTotal, int? totalCareEvents
});




}
/// @nodoc
class _$ProfileSummaryCopyWithImpl<$Res>
    implements $ProfileSummaryCopyWith<$Res> {
  _$ProfileSummaryCopyWithImpl(this._self, this._then);

  final ProfileSummary _self;
  final $Res Function(ProfileSummary) _then;

/// Create a copy of ProfileSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? email = freezed,Object? avatar = freezed,Object? createdAt = null,Object? plantsTotal = null,Object? totalCareEvents = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,plantsTotal: null == plantsTotal ? _self.plantsTotal : plantsTotal // ignore: cast_nullable_to_non_nullable
as int,totalCareEvents: freezed == totalCareEvents ? _self.totalCareEvents : totalCareEvents // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileSummary].
extension ProfileSummaryPatterns on ProfileSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSummary value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? email,  String? avatar,  DateTime createdAt,  int plantsTotal,  int? totalCareEvents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSummary() when $default != null:
return $default(_that.name,_that.email,_that.avatar,_that.createdAt,_that.plantsTotal,_that.totalCareEvents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? email,  String? avatar,  DateTime createdAt,  int plantsTotal,  int? totalCareEvents)  $default,) {final _that = this;
switch (_that) {
case _ProfileSummary():
return $default(_that.name,_that.email,_that.avatar,_that.createdAt,_that.plantsTotal,_that.totalCareEvents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? email,  String? avatar,  DateTime createdAt,  int plantsTotal,  int? totalCareEvents)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSummary() when $default != null:
return $default(_that.name,_that.email,_that.avatar,_that.createdAt,_that.plantsTotal,_that.totalCareEvents);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileSummary extends ProfileSummary {
  const _ProfileSummary({this.name, this.email, this.avatar, required this.createdAt, required this.plantsTotal, this.totalCareEvents}): super._();
  

/// Отображаемое имя пользователя. `null` → UI показывает
/// «Пользователь» (анонимный).
@override final  String? name;
/// Email пользователя. `null` для чисто Telegram-юзеров — UI не показывает
/// строку email.
@override final  String? email;
/// URL аватара. `null` → initials-плейсхолдер. На текущей схеме backend
/// всегда отдаёт `null` (нет хранилища аватаров).
@override final  String? avatar;
/// Момент регистрации (UTC). Шапка форматирует как «С нами с {MMM yyyy}».
@override final  DateTime createdAt;
/// Число неархивированных растений пользователя.
@override final  int plantsTotal;
/// Число уходов за всё время. `null` пока backend не отдаёт поле
/// (plants-care#226) — блок «Уходов» скрыт.
@override final  int? totalCareEvents;

/// Create a copy of ProfileSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSummaryCopyWith<_ProfileSummary> get copyWith => __$ProfileSummaryCopyWithImpl<_ProfileSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSummary&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.plantsTotal, plantsTotal) || other.plantsTotal == plantsTotal)&&(identical(other.totalCareEvents, totalCareEvents) || other.totalCareEvents == totalCareEvents));
}


@override
int get hashCode => Object.hash(runtimeType,name,email,avatar,createdAt,plantsTotal,totalCareEvents);

@override
String toString() {
  return 'ProfileSummary(name: $name, email: $email, avatar: $avatar, createdAt: $createdAt, plantsTotal: $plantsTotal, totalCareEvents: $totalCareEvents)';
}


}

/// @nodoc
abstract mixin class _$ProfileSummaryCopyWith<$Res> implements $ProfileSummaryCopyWith<$Res> {
  factory _$ProfileSummaryCopyWith(_ProfileSummary value, $Res Function(_ProfileSummary) _then) = __$ProfileSummaryCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? email, String? avatar, DateTime createdAt, int plantsTotal, int? totalCareEvents
});




}
/// @nodoc
class __$ProfileSummaryCopyWithImpl<$Res>
    implements _$ProfileSummaryCopyWith<$Res> {
  __$ProfileSummaryCopyWithImpl(this._self, this._then);

  final _ProfileSummary _self;
  final $Res Function(_ProfileSummary) _then;

/// Create a copy of ProfileSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? email = freezed,Object? avatar = freezed,Object? createdAt = null,Object? plantsTotal = null,Object? totalCareEvents = freezed,}) {
  return _then(_ProfileSummary(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,plantsTotal: null == plantsTotal ? _self.plantsTotal : plantsTotal // ignore: cast_nullable_to_non_nullable
as int,totalCareEvents: freezed == totalCareEvents ? _self.totalCareEvents : totalCareEvents // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
