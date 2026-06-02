// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSettings {

/// Начало тихих часов (локальное время, экран 36).
 QuietTime get quietHoursStart;/// Конец тихих часов (локальное время, экран 36).
 QuietTime get quietHoursEnd;/// IANA-идентификатор таймзоны пользователя (`Europe/Moscow`). Backend
/// валидирует при записи: невалидный → `400`.
 String get timezone;/// Язык интерфейса (read-only в этой фиче).
 UserLocale get locale;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.locale, locale) || other.locale == locale));
}


@override
int get hashCode => Object.hash(runtimeType,quietHoursStart,quietHoursEnd,timezone,locale);

@override
String toString() {
  return 'UserSettings(quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, timezone: $timezone, locale: $locale)';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 QuietTime quietHoursStart, QuietTime quietHoursEnd, String timezone, UserLocale locale
});


$QuietTimeCopyWith<$Res> get quietHoursStart;$QuietTimeCopyWith<$Res> get quietHoursEnd;

}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? timezone = null,Object? locale = null,}) {
  return _then(_self.copyWith(
quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as QuietTime,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as QuietTime,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as UserLocale,
  ));
}
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietTimeCopyWith<$Res> get quietHoursStart {
  
  return $QuietTimeCopyWith<$Res>(_self.quietHoursStart, (value) {
    return _then(_self.copyWith(quietHoursStart: value));
  });
}/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietTimeCopyWith<$Res> get quietHoursEnd {
  
  return $QuietTimeCopyWith<$Res>(_self.quietHoursEnd, (value) {
    return _then(_self.copyWith(quietHoursEnd: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserSettings].
extension UserSettingsPatterns on UserSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettings value)  $default,){
final _that = this;
switch (_that) {
case _UserSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QuietTime quietHoursStart,  QuietTime quietHoursEnd,  String timezone,  UserLocale locale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.quietHoursStart,_that.quietHoursEnd,_that.timezone,_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QuietTime quietHoursStart,  QuietTime quietHoursEnd,  String timezone,  UserLocale locale)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.quietHoursStart,_that.quietHoursEnd,_that.timezone,_that.locale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QuietTime quietHoursStart,  QuietTime quietHoursEnd,  String timezone,  UserLocale locale)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.quietHoursStart,_that.quietHoursEnd,_that.timezone,_that.locale);case _:
  return null;

}
}

}

/// @nodoc


class _UserSettings extends UserSettings {
  const _UserSettings({required this.quietHoursStart, required this.quietHoursEnd, required this.timezone, required this.locale}): super._();
  

/// Начало тихих часов (локальное время, экран 36).
@override final  QuietTime quietHoursStart;
/// Конец тихих часов (локальное время, экран 36).
@override final  QuietTime quietHoursEnd;
/// IANA-идентификатор таймзоны пользователя (`Europe/Moscow`). Backend
/// валидирует при записи: невалидный → `400`.
@override final  String timezone;
/// Язык интерфейса (read-only в этой фиче).
@override final  UserLocale locale;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsCopyWith<_UserSettings> get copyWith => __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.locale, locale) || other.locale == locale));
}


@override
int get hashCode => Object.hash(runtimeType,quietHoursStart,quietHoursEnd,timezone,locale);

@override
String toString() {
  return 'UserSettings(quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, timezone: $timezone, locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 QuietTime quietHoursStart, QuietTime quietHoursEnd, String timezone, UserLocale locale
});


@override $QuietTimeCopyWith<$Res> get quietHoursStart;@override $QuietTimeCopyWith<$Res> get quietHoursEnd;

}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? timezone = null,Object? locale = null,}) {
  return _then(_UserSettings(
quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as QuietTime,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as QuietTime,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as UserLocale,
  ));
}

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietTimeCopyWith<$Res> get quietHoursStart {
  
  return $QuietTimeCopyWith<$Res>(_self.quietHoursStart, (value) {
    return _then(_self.copyWith(quietHoursStart: value));
  });
}/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietTimeCopyWith<$Res> get quietHoursEnd {
  
  return $QuietTimeCopyWith<$Res>(_self.quietHoursEnd, (value) {
    return _then(_self.copyWith(quietHoursEnd: value));
  });
}
}

// dart format on
