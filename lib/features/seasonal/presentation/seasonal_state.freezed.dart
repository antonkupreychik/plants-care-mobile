// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seasonal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeasonalState {

 SeasonalSettings get settings; bool get saving; ApiError? get saveError;
/// Create a copy of SeasonalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonalStateCopyWith<SeasonalState> get copyWith => _$SeasonalStateCopyWithImpl<SeasonalState>(this as SeasonalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonalState&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode => Object.hash(runtimeType,settings,saving,saveError);

@override
String toString() {
  return 'SeasonalState(settings: $settings, saving: $saving, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class $SeasonalStateCopyWith<$Res>  {
  factory $SeasonalStateCopyWith(SeasonalState value, $Res Function(SeasonalState) _then) = _$SeasonalStateCopyWithImpl;
@useResult
$Res call({
 SeasonalSettings settings, bool saving, ApiError? saveError
});


$SeasonalSettingsCopyWith<$Res> get settings;$ApiErrorCopyWith<$Res>? get saveError;

}
/// @nodoc
class _$SeasonalStateCopyWithImpl<$Res>
    implements $SeasonalStateCopyWith<$Res> {
  _$SeasonalStateCopyWithImpl(this._self, this._then);

  final SeasonalState _self;
  final $Res Function(SeasonalState) _then;

/// Create a copy of SeasonalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? settings = null,Object? saving = null,Object? saveError = freezed,}) {
  return _then(_self.copyWith(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as SeasonalSettings,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of SeasonalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonalSettingsCopyWith<$Res> get settings {
  
  return $SeasonalSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of SeasonalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get saveError {
    if (_self.saveError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.saveError!, (value) {
    return _then(_self.copyWith(saveError: value));
  });
}
}


/// Adds pattern-matching-related methods to [SeasonalState].
extension SeasonalStatePatterns on SeasonalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonalState value)  $default,){
final _that = this;
switch (_that) {
case _SeasonalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonalState value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SeasonalSettings settings,  bool saving,  ApiError? saveError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonalState() when $default != null:
return $default(_that.settings,_that.saving,_that.saveError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SeasonalSettings settings,  bool saving,  ApiError? saveError)  $default,) {final _that = this;
switch (_that) {
case _SeasonalState():
return $default(_that.settings,_that.saving,_that.saveError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SeasonalSettings settings,  bool saving,  ApiError? saveError)?  $default,) {final _that = this;
switch (_that) {
case _SeasonalState() when $default != null:
return $default(_that.settings,_that.saving,_that.saveError);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonalState extends SeasonalState {
  const _SeasonalState({required this.settings, this.saving = false, this.saveError}): super._();
  

@override final  SeasonalSettings settings;
@override@JsonKey() final  bool saving;
@override final  ApiError? saveError;

/// Create a copy of SeasonalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonalStateCopyWith<_SeasonalState> get copyWith => __$SeasonalStateCopyWithImpl<_SeasonalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonalState&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode => Object.hash(runtimeType,settings,saving,saveError);

@override
String toString() {
  return 'SeasonalState(settings: $settings, saving: $saving, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class _$SeasonalStateCopyWith<$Res> implements $SeasonalStateCopyWith<$Res> {
  factory _$SeasonalStateCopyWith(_SeasonalState value, $Res Function(_SeasonalState) _then) = __$SeasonalStateCopyWithImpl;
@override @useResult
$Res call({
 SeasonalSettings settings, bool saving, ApiError? saveError
});


@override $SeasonalSettingsCopyWith<$Res> get settings;@override $ApiErrorCopyWith<$Res>? get saveError;

}
/// @nodoc
class __$SeasonalStateCopyWithImpl<$Res>
    implements _$SeasonalStateCopyWith<$Res> {
  __$SeasonalStateCopyWithImpl(this._self, this._then);

  final _SeasonalState _self;
  final $Res Function(_SeasonalState) _then;

/// Create a copy of SeasonalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settings = null,Object? saving = null,Object? saveError = freezed,}) {
  return _then(_SeasonalState(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as SeasonalSettings,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of SeasonalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonalSettingsCopyWith<$Res> get settings {
  
  return $SeasonalSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of SeasonalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get saveError {
    if (_self.saveError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.saveError!, (value) {
    return _then(_self.copyWith(saveError: value));
  });
}
}

// dart format on
