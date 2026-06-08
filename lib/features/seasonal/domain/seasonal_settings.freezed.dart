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
mixin _$SeasonSetting {

/// Коэффициент к базовому интервалу. Применяется в режиме multiplier.
 double get multiplier;/// Фиксированный интервал в днях. `null` — интервал не задан (дефолт).
 int? get intervalDays;
/// Create a copy of SeasonSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonSettingCopyWith<SeasonSetting> get copyWith => _$SeasonSettingCopyWithImpl<SeasonSetting>(this as SeasonSetting, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonSetting&&(identical(other.multiplier, multiplier) || other.multiplier == multiplier)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays));
}


@override
int get hashCode => Object.hash(runtimeType,multiplier,intervalDays);

@override
String toString() {
  return 'SeasonSetting(multiplier: $multiplier, intervalDays: $intervalDays)';
}


}

/// @nodoc
abstract mixin class $SeasonSettingCopyWith<$Res>  {
  factory $SeasonSettingCopyWith(SeasonSetting value, $Res Function(SeasonSetting) _then) = _$SeasonSettingCopyWithImpl;
@useResult
$Res call({
 double multiplier, int? intervalDays
});




}
/// @nodoc
class _$SeasonSettingCopyWithImpl<$Res>
    implements $SeasonSettingCopyWith<$Res> {
  _$SeasonSettingCopyWithImpl(this._self, this._then);

  final SeasonSetting _self;
  final $Res Function(SeasonSetting) _then;

/// Create a copy of SeasonSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? multiplier = null,Object? intervalDays = freezed,}) {
  return _then(_self.copyWith(
multiplier: null == multiplier ? _self.multiplier : multiplier // ignore: cast_nullable_to_non_nullable
as double,intervalDays: freezed == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonSetting].
extension SeasonSettingPatterns on SeasonSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonSetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonSetting value)  $default,){
final _that = this;
switch (_that) {
case _SeasonSetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonSetting value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonSetting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double multiplier,  int? intervalDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonSetting() when $default != null:
return $default(_that.multiplier,_that.intervalDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double multiplier,  int? intervalDays)  $default,) {final _that = this;
switch (_that) {
case _SeasonSetting():
return $default(_that.multiplier,_that.intervalDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double multiplier,  int? intervalDays)?  $default,) {final _that = this;
switch (_that) {
case _SeasonSetting() when $default != null:
return $default(_that.multiplier,_that.intervalDays);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonSetting extends SeasonSetting {
  const _SeasonSetting({required this.multiplier, this.intervalDays}): super._();
  

/// Коэффициент к базовому интервалу. Применяется в режиме multiplier.
@override final  double multiplier;
/// Фиксированный интервал в днях. `null` — интервал не задан (дефолт).
@override final  int? intervalDays;

/// Create a copy of SeasonSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonSettingCopyWith<_SeasonSetting> get copyWith => __$SeasonSettingCopyWithImpl<_SeasonSetting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonSetting&&(identical(other.multiplier, multiplier) || other.multiplier == multiplier)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays));
}


@override
int get hashCode => Object.hash(runtimeType,multiplier,intervalDays);

@override
String toString() {
  return 'SeasonSetting(multiplier: $multiplier, intervalDays: $intervalDays)';
}


}

/// @nodoc
abstract mixin class _$SeasonSettingCopyWith<$Res> implements $SeasonSettingCopyWith<$Res> {
  factory _$SeasonSettingCopyWith(_SeasonSetting value, $Res Function(_SeasonSetting) _then) = __$SeasonSettingCopyWithImpl;
@override @useResult
$Res call({
 double multiplier, int? intervalDays
});




}
/// @nodoc
class __$SeasonSettingCopyWithImpl<$Res>
    implements _$SeasonSettingCopyWith<$Res> {
  __$SeasonSettingCopyWithImpl(this._self, this._then);

  final _SeasonSetting _self;
  final $Res Function(_SeasonSetting) _then;

/// Create a copy of SeasonSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? multiplier = null,Object? intervalDays = freezed,}) {
  return _then(_SeasonSetting(
multiplier: null == multiplier ? _self.multiplier : multiplier // ignore: cast_nullable_to_non_nullable
as double,intervalDays: freezed == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$SeasonalSettings {

/// Включена ли авто-подстройка частоты ухода по сезонам (глобально для
/// пользователя). Тумблер экрана 35.
 bool get enabled;/// Режим сезонности (read-only в этой фиче): множитель к интервалу или
/// фиксированные интервалы на сезон.
 SeasonalMode get mode;/// Настройки летнего сезона. Если `null`, то backend не вернул данных для
/// этого сезона (неожиданный ответ).
 SeasonSetting? get summer;/// Настройки зимнего сезона. Если `null`, то backend не вернул данных для
/// этого сезона.
 SeasonSetting? get winter;
/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonalSettingsCopyWith<SeasonalSettings> get copyWith => _$SeasonalSettingsCopyWithImpl<SeasonalSettings>(this as SeasonalSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonalSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.summer, summer) || other.summer == summer)&&(identical(other.winter, winter) || other.winter == winter));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,mode,summer,winter);

@override
String toString() {
  return 'SeasonalSettings(enabled: $enabled, mode: $mode, summer: $summer, winter: $winter)';
}


}

/// @nodoc
abstract mixin class $SeasonalSettingsCopyWith<$Res>  {
  factory $SeasonalSettingsCopyWith(SeasonalSettings value, $Res Function(SeasonalSettings) _then) = _$SeasonalSettingsCopyWithImpl;
@useResult
$Res call({
 bool enabled, SeasonalMode mode, SeasonSetting? summer, SeasonSetting? winter
});


$SeasonSettingCopyWith<$Res>? get summer;$SeasonSettingCopyWith<$Res>? get winter;

}
/// @nodoc
class _$SeasonalSettingsCopyWithImpl<$Res>
    implements $SeasonalSettingsCopyWith<$Res> {
  _$SeasonalSettingsCopyWithImpl(this._self, this._then);

  final SeasonalSettings _self;
  final $Res Function(SeasonalSettings) _then;

/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? mode = null,Object? summer = freezed,Object? winter = freezed,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SeasonalMode,summer: freezed == summer ? _self.summer : summer // ignore: cast_nullable_to_non_nullable
as SeasonSetting?,winter: freezed == winter ? _self.winter : winter // ignore: cast_nullable_to_non_nullable
as SeasonSetting?,
  ));
}
/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonSettingCopyWith<$Res>? get summer {
    if (_self.summer == null) {
    return null;
  }

  return $SeasonSettingCopyWith<$Res>(_self.summer!, (value) {
    return _then(_self.copyWith(summer: value));
  });
}/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonSettingCopyWith<$Res>? get winter {
    if (_self.winter == null) {
    return null;
  }

  return $SeasonSettingCopyWith<$Res>(_self.winter!, (value) {
    return _then(_self.copyWith(winter: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  SeasonalMode mode,  SeasonSetting? summer,  SeasonSetting? winter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonalSettings() when $default != null:
return $default(_that.enabled,_that.mode,_that.summer,_that.winter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  SeasonalMode mode,  SeasonSetting? summer,  SeasonSetting? winter)  $default,) {final _that = this;
switch (_that) {
case _SeasonalSettings():
return $default(_that.enabled,_that.mode,_that.summer,_that.winter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  SeasonalMode mode,  SeasonSetting? summer,  SeasonSetting? winter)?  $default,) {final _that = this;
switch (_that) {
case _SeasonalSettings() when $default != null:
return $default(_that.enabled,_that.mode,_that.summer,_that.winter);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonalSettings extends SeasonalSettings {
  const _SeasonalSettings({required this.enabled, required this.mode, this.summer, this.winter}): super._();
  

/// Включена ли авто-подстройка частоты ухода по сезонам (глобально для
/// пользователя). Тумблер экрана 35.
@override final  bool enabled;
/// Режим сезонности (read-only в этой фиче): множитель к интервалу или
/// фиксированные интервалы на сезон.
@override final  SeasonalMode mode;
/// Настройки летнего сезона. Если `null`, то backend не вернул данных для
/// этого сезона (неожиданный ответ).
@override final  SeasonSetting? summer;
/// Настройки зимнего сезона. Если `null`, то backend не вернул данных для
/// этого сезона.
@override final  SeasonSetting? winter;

/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonalSettingsCopyWith<_SeasonalSettings> get copyWith => __$SeasonalSettingsCopyWithImpl<_SeasonalSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonalSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.summer, summer) || other.summer == summer)&&(identical(other.winter, winter) || other.winter == winter));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,mode,summer,winter);

@override
String toString() {
  return 'SeasonalSettings(enabled: $enabled, mode: $mode, summer: $summer, winter: $winter)';
}


}

/// @nodoc
abstract mixin class _$SeasonalSettingsCopyWith<$Res> implements $SeasonalSettingsCopyWith<$Res> {
  factory _$SeasonalSettingsCopyWith(_SeasonalSettings value, $Res Function(_SeasonalSettings) _then) = __$SeasonalSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, SeasonalMode mode, SeasonSetting? summer, SeasonSetting? winter
});


@override $SeasonSettingCopyWith<$Res>? get summer;@override $SeasonSettingCopyWith<$Res>? get winter;

}
/// @nodoc
class __$SeasonalSettingsCopyWithImpl<$Res>
    implements _$SeasonalSettingsCopyWith<$Res> {
  __$SeasonalSettingsCopyWithImpl(this._self, this._then);

  final _SeasonalSettings _self;
  final $Res Function(_SeasonalSettings) _then;

/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? mode = null,Object? summer = freezed,Object? winter = freezed,}) {
  return _then(_SeasonalSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SeasonalMode,summer: freezed == summer ? _self.summer : summer // ignore: cast_nullable_to_non_nullable
as SeasonSetting?,winter: freezed == winter ? _self.winter : winter // ignore: cast_nullable_to_non_nullable
as SeasonSetting?,
  ));
}

/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonSettingCopyWith<$Res>? get summer {
    if (_self.summer == null) {
    return null;
  }

  return $SeasonSettingCopyWith<$Res>(_self.summer!, (value) {
    return _then(_self.copyWith(summer: value));
  });
}/// Create a copy of SeasonalSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonSettingCopyWith<$Res>? get winter {
    if (_self.winter == null) {
    return null;
  }

  return $SeasonSettingCopyWith<$Res>(_self.winter!, (value) {
    return _then(_self.copyWith(winter: value));
  });
}
}

// dart format on
