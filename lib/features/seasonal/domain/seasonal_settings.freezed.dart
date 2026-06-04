// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seasonal_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeasonalSettings {

/// Включена ли авто-подстройка частоты ухода по сезонам (глобально для
/// пользователя). Тумблер экрана 35.
 bool get enabled;/// Режим сезонности (read-only в этой фиче): множитель к интервалу или
/// фиксированные интервалы на сезон.
 SeasonalMode get mode;
/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonalSettingsCopyWith<SeasonalSettings> get copyWith => _$SeasonalSettingsCopyWithImpl<SeasonalSettings>(this as SeasonalSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonalSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,mode);

@override
String toString() {
  return 'SeasonalSettings(enabled: $enabled, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $SeasonalSettingsCopyWith<$Res>  {
  factory $SeasonalSettingsCopyWith(SeasonalSettings value, $Res Function(SeasonalSettings) _then) = _$SeasonalSettingsCopyWithImpl;
@useResult
$Res call({
 bool enabled, SeasonalMode mode
});




}
/// @nodoc
class _$SeasonalSettingsCopyWithImpl<$Res>
    implements $SeasonalSettingsCopyWith<$Res> {
  _$SeasonalSettingsCopyWithImpl(this._self, this._then);

  final SeasonalSettings _self;
  final $Res Function(SeasonalSettings) _then;

/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? mode = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SeasonalMode,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonalSettings].
extension SeasonalSettingsPatterns on SeasonalSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonalSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonalSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonalSettings value)  $default,){
final _that = this;
switch (_that) {
case _SeasonalSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonalSettings value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonalSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  SeasonalMode mode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonalSettings() when $default != null:
return $default(_that.enabled,_that.mode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  SeasonalMode mode)  $default,) {final _that = this;
switch (_that) {
case _SeasonalSettings():
return $default(_that.enabled,_that.mode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  SeasonalMode mode)?  $default,) {final _that = this;
switch (_that) {
case _SeasonalSettings() when $default != null:
return $default(_that.enabled,_that.mode);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonalSettings extends SeasonalSettings {
  const _SeasonalSettings({required this.enabled, required this.mode}): super._();
  

/// Включена ли авто-подстройка частоты ухода по сезонам (глобально для
/// пользователя). Тумблер экрана 35.
@override final  bool enabled;
/// Режим сезонности (read-only в этой фиче): множитель к интервалу или
/// фиксированные интервалы на сезон.
@override final  SeasonalMode mode;

/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonalSettingsCopyWith<_SeasonalSettings> get copyWith => __$SeasonalSettingsCopyWithImpl<_SeasonalSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonalSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,mode);

@override
String toString() {
  return 'SeasonalSettings(enabled: $enabled, mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$SeasonalSettingsCopyWith<$Res> implements $SeasonalSettingsCopyWith<$Res> {
  factory _$SeasonalSettingsCopyWith(_SeasonalSettings value, $Res Function(_SeasonalSettings) _then) = __$SeasonalSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, SeasonalMode mode
});




}
/// @nodoc
class __$SeasonalSettingsCopyWithImpl<$Res>
    implements _$SeasonalSettingsCopyWith<$Res> {
  __$SeasonalSettingsCopyWithImpl(this._self, this._then);

  final _SeasonalSettings _self;
  final $Res Function(_SeasonalSettings) _then;

/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? mode = null,}) {
  return _then(_SeasonalSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SeasonalMode,
  ));
}


}

// dart format on
