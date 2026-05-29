// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_schedule_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditScheduleState {

/// Последнее подтверждённое backend состояние (база для dirty/отката).
 List<PlantCareSchedule> get loaded;/// Текущий редактируемый драфт (то, что показывает UI).
 List<PlantCareSchedule> get draft;/// Идёт ли сохранение (`save()` в полёте) — UI блокирует «Готово».
 bool get saving;/// Ошибка последнего сохранения (общий статус частичной/полной неудачи).
/// `null` — ошибки нет. Успешно сохранённые типы НЕ откатываются: см.
/// `save()`.
 ApiError? get saveError;
/// Create a copy of EditScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditScheduleStateCopyWith<EditScheduleState> get copyWith => _$EditScheduleStateCopyWithImpl<EditScheduleState>(this as EditScheduleState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditScheduleState&&const DeepCollectionEquality().equals(other.loaded, loaded)&&const DeepCollectionEquality().equals(other.draft, draft)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(loaded),const DeepCollectionEquality().hash(draft),saving,saveError);

@override
String toString() {
  return 'EditScheduleState(loaded: $loaded, draft: $draft, saving: $saving, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class $EditScheduleStateCopyWith<$Res>  {
  factory $EditScheduleStateCopyWith(EditScheduleState value, $Res Function(EditScheduleState) _then) = _$EditScheduleStateCopyWithImpl;
@useResult
$Res call({
 List<PlantCareSchedule> loaded, List<PlantCareSchedule> draft, bool saving, ApiError? saveError
});


$ApiErrorCopyWith<$Res>? get saveError;

}
/// @nodoc
class _$EditScheduleStateCopyWithImpl<$Res>
    implements $EditScheduleStateCopyWith<$Res> {
  _$EditScheduleStateCopyWithImpl(this._self, this._then);

  final EditScheduleState _self;
  final $Res Function(EditScheduleState) _then;

/// Create a copy of EditScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loaded = null,Object? draft = null,Object? saving = null,Object? saveError = freezed,}) {
  return _then(_self.copyWith(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as List<PlantCareSchedule>,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as List<PlantCareSchedule>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of EditScheduleState
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


/// Adds pattern-matching-related methods to [EditScheduleState].
extension EditScheduleStatePatterns on EditScheduleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditScheduleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditScheduleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditScheduleState value)  $default,){
final _that = this;
switch (_that) {
case _EditScheduleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditScheduleState value)?  $default,){
final _that = this;
switch (_that) {
case _EditScheduleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PlantCareSchedule> loaded,  List<PlantCareSchedule> draft,  bool saving,  ApiError? saveError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditScheduleState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PlantCareSchedule> loaded,  List<PlantCareSchedule> draft,  bool saving,  ApiError? saveError)  $default,) {final _that = this;
switch (_that) {
case _EditScheduleState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PlantCareSchedule> loaded,  List<PlantCareSchedule> draft,  bool saving,  ApiError? saveError)?  $default,) {final _that = this;
switch (_that) {
case _EditScheduleState() when $default != null:
return $default(_that.loaded,_that.draft,_that.saving,_that.saveError);case _:
  return null;

}
}

}

/// @nodoc


class _EditScheduleState extends EditScheduleState {
  const _EditScheduleState({required final  List<PlantCareSchedule> loaded, required final  List<PlantCareSchedule> draft, this.saving = false, this.saveError}): _loaded = loaded,_draft = draft,super._();
  

/// Последнее подтверждённое backend состояние (база для dirty/отката).
 final  List<PlantCareSchedule> _loaded;
/// Последнее подтверждённое backend состояние (база для dirty/отката).
@override List<PlantCareSchedule> get loaded {
  if (_loaded is EqualUnmodifiableListView) return _loaded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_loaded);
}

/// Текущий редактируемый драфт (то, что показывает UI).
 final  List<PlantCareSchedule> _draft;
/// Текущий редактируемый драфт (то, что показывает UI).
@override List<PlantCareSchedule> get draft {
  if (_draft is EqualUnmodifiableListView) return _draft;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_draft);
}

/// Идёт ли сохранение (`save()` в полёте) — UI блокирует «Готово».
@override@JsonKey() final  bool saving;
/// Ошибка последнего сохранения (общий статус частичной/полной неудачи).
/// `null` — ошибки нет. Успешно сохранённые типы НЕ откатываются: см.
/// `save()`.
@override final  ApiError? saveError;

/// Create a copy of EditScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditScheduleStateCopyWith<_EditScheduleState> get copyWith => __$EditScheduleStateCopyWithImpl<_EditScheduleState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditScheduleState&&const DeepCollectionEquality().equals(other._loaded, _loaded)&&const DeepCollectionEquality().equals(other._draft, _draft)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_loaded),const DeepCollectionEquality().hash(_draft),saving,saveError);

@override
String toString() {
  return 'EditScheduleState(loaded: $loaded, draft: $draft, saving: $saving, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class _$EditScheduleStateCopyWith<$Res> implements $EditScheduleStateCopyWith<$Res> {
  factory _$EditScheduleStateCopyWith(_EditScheduleState value, $Res Function(_EditScheduleState) _then) = __$EditScheduleStateCopyWithImpl;
@override @useResult
$Res call({
 List<PlantCareSchedule> loaded, List<PlantCareSchedule> draft, bool saving, ApiError? saveError
});


@override $ApiErrorCopyWith<$Res>? get saveError;

}
/// @nodoc
class __$EditScheduleStateCopyWithImpl<$Res>
    implements _$EditScheduleStateCopyWith<$Res> {
  __$EditScheduleStateCopyWithImpl(this._self, this._then);

  final _EditScheduleState _self;
  final $Res Function(_EditScheduleState) _then;

/// Create a copy of EditScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loaded = null,Object? draft = null,Object? saving = null,Object? saveError = freezed,}) {
  return _then(_EditScheduleState(
loaded: null == loaded ? _self._loaded : loaded // ignore: cast_nullable_to_non_nullable
as List<PlantCareSchedule>,draft: null == draft ? _self._draft : draft // ignore: cast_nullable_to_non_nullable
as List<PlantCareSchedule>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of EditScheduleState
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
