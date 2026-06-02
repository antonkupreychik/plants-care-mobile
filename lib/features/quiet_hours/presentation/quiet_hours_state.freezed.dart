// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiet_hours_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuietHoursState {

/// Последнее подтверждённое backend состояние (база для dirty/отката).
 UserSettings get loaded;/// Текущий редактируемый драфт (то, что показывает UI).
 UserSettings get draft;/// Идёт ли сохранение (PATCH в полёте).
 bool get saving;/// Ошибка последнего сохранения, либо `null`.
 ApiError? get saveError;
/// Create a copy of QuietHoursState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuietHoursStateCopyWith<QuietHoursState> get copyWith => _$QuietHoursStateCopyWithImpl<QuietHoursState>(this as QuietHoursState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuietHoursState&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode => Object.hash(runtimeType,loaded,draft,saving,saveError);

@override
String toString() {
  return 'QuietHoursState(loaded: $loaded, draft: $draft, saving: $saving, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class $QuietHoursStateCopyWith<$Res>  {
  factory $QuietHoursStateCopyWith(QuietHoursState value, $Res Function(QuietHoursState) _then) = _$QuietHoursStateCopyWithImpl;
@useResult
$Res call({
 UserSettings loaded, UserSettings draft, bool saving, ApiError? saveError
});


$UserSettingsCopyWith<$Res> get loaded;$UserSettingsCopyWith<$Res> get draft;$ApiErrorCopyWith<$Res>? get saveError;

}
/// @nodoc
class _$QuietHoursStateCopyWithImpl<$Res>
    implements $QuietHoursStateCopyWith<$Res> {
  _$QuietHoursStateCopyWithImpl(this._self, this._then);

  final QuietHoursState _self;
  final $Res Function(QuietHoursState) _then;

/// Create a copy of QuietHoursState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loaded = null,Object? draft = null,Object? saving = null,Object? saveError = freezed,}) {
  return _then(_self.copyWith(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as UserSettings,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as UserSettings,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of QuietHoursState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get loaded {
  
  return $UserSettingsCopyWith<$Res>(_self.loaded, (value) {
    return _then(_self.copyWith(loaded: value));
  });
}/// Create a copy of QuietHoursState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get draft {
  
  return $UserSettingsCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of QuietHoursState
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


/// Adds pattern-matching-related methods to [QuietHoursState].
extension QuietHoursStatePatterns on QuietHoursState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuietHoursState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuietHoursState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuietHoursState value)  $default,){
final _that = this;
switch (_that) {
case _QuietHoursState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuietHoursState value)?  $default,){
final _that = this;
switch (_that) {
case _QuietHoursState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserSettings loaded,  UserSettings draft,  bool saving,  ApiError? saveError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuietHoursState() when $default != null:
return $default(_that.loaded,_that.draft,_that.saving,_that.saveError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserSettings loaded,  UserSettings draft,  bool saving,  ApiError? saveError)  $default,) {final _that = this;
switch (_that) {
case _QuietHoursState():
return $default(_that.loaded,_that.draft,_that.saving,_that.saveError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserSettings loaded,  UserSettings draft,  bool saving,  ApiError? saveError)?  $default,) {final _that = this;
switch (_that) {
case _QuietHoursState() when $default != null:
return $default(_that.loaded,_that.draft,_that.saving,_that.saveError);case _:
  return null;

}
}

}

/// @nodoc


class _QuietHoursState extends QuietHoursState {
  const _QuietHoursState({required this.loaded, required this.draft, this.saving = false, this.saveError}): super._();
  

/// Последнее подтверждённое backend состояние (база для dirty/отката).
@override final  UserSettings loaded;
/// Текущий редактируемый драфт (то, что показывает UI).
@override final  UserSettings draft;
/// Идёт ли сохранение (PATCH в полёте).
@override@JsonKey() final  bool saving;
/// Ошибка последнего сохранения, либо `null`.
@override final  ApiError? saveError;

/// Create a copy of QuietHoursState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuietHoursStateCopyWith<_QuietHoursState> get copyWith => __$QuietHoursStateCopyWithImpl<_QuietHoursState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuietHoursState&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode => Object.hash(runtimeType,loaded,draft,saving,saveError);

@override
String toString() {
  return 'QuietHoursState(loaded: $loaded, draft: $draft, saving: $saving, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class _$QuietHoursStateCopyWith<$Res> implements $QuietHoursStateCopyWith<$Res> {
  factory _$QuietHoursStateCopyWith(_QuietHoursState value, $Res Function(_QuietHoursState) _then) = __$QuietHoursStateCopyWithImpl;
@override @useResult
$Res call({
 UserSettings loaded, UserSettings draft, bool saving, ApiError? saveError
});


@override $UserSettingsCopyWith<$Res> get loaded;@override $UserSettingsCopyWith<$Res> get draft;@override $ApiErrorCopyWith<$Res>? get saveError;

}
/// @nodoc
class __$QuietHoursStateCopyWithImpl<$Res>
    implements _$QuietHoursStateCopyWith<$Res> {
  __$QuietHoursStateCopyWithImpl(this._self, this._then);

  final _QuietHoursState _self;
  final $Res Function(_QuietHoursState) _then;

/// Create a copy of QuietHoursState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loaded = null,Object? draft = null,Object? saving = null,Object? saveError = freezed,}) {
  return _then(_QuietHoursState(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as UserSettings,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as UserSettings,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of QuietHoursState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get loaded {
  
  return $UserSettingsCopyWith<$Res>(_self.loaded, (value) {
    return _then(_self.copyWith(loaded: value));
  });
}/// Create a copy of QuietHoursState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get draft {
  
  return $UserSettingsCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of QuietHoursState
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
