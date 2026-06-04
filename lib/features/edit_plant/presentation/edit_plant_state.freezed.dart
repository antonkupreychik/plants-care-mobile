// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_plant_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditPlantState {

 EditPlantDraft get initial; EditPlantDraft get draft; SubmitStatus get submitStatus; ApiError? get submitError;
/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditPlantStateCopyWith<EditPlantState> get copyWith => _$EditPlantStateCopyWithImpl<EditPlantState>(this as EditPlantState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditPlantState&&(identical(other.initial, initial) || other.initial == initial)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.submitStatus, submitStatus) || other.submitStatus == submitStatus)&&(identical(other.submitError, submitError) || other.submitError == submitError));
}


@override
int get hashCode => Object.hash(runtimeType,initial,draft,submitStatus,submitError);

@override
String toString() {
  return 'EditPlantState(initial: $initial, draft: $draft, submitStatus: $submitStatus, submitError: $submitError)';
}


}

/// @nodoc
abstract mixin class $EditPlantStateCopyWith<$Res>  {
  factory $EditPlantStateCopyWith(EditPlantState value, $Res Function(EditPlantState) _then) = _$EditPlantStateCopyWithImpl;
@useResult
$Res call({
 EditPlantDraft initial, EditPlantDraft draft, SubmitStatus submitStatus, ApiError? submitError
});


$EditPlantDraftCopyWith<$Res> get initial;$EditPlantDraftCopyWith<$Res> get draft;$ApiErrorCopyWith<$Res>? get submitError;

}
/// @nodoc
class _$EditPlantStateCopyWithImpl<$Res>
    implements $EditPlantStateCopyWith<$Res> {
  _$EditPlantStateCopyWithImpl(this._self, this._then);

  final EditPlantState _self;
  final $Res Function(EditPlantState) _then;

/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initial = null,Object? draft = null,Object? submitStatus = null,Object? submitError = freezed,}) {
  return _then(_self.copyWith(
initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as EditPlantDraft,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as EditPlantDraft,submitStatus: null == submitStatus ? _self.submitStatus : submitStatus // ignore: cast_nullable_to_non_nullable
as SubmitStatus,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditPlantDraftCopyWith<$Res> get initial {
  
  return $EditPlantDraftCopyWith<$Res>(_self.initial, (value) {
    return _then(_self.copyWith(initial: value));
  });
}/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditPlantDraftCopyWith<$Res> get draft {
  
  return $EditPlantDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get submitError {
    if (_self.submitError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.submitError!, (value) {
    return _then(_self.copyWith(submitError: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditPlantState].
extension EditPlantStatePatterns on EditPlantState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditPlantState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditPlantState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditPlantState value)  $default,){
final _that = this;
switch (_that) {
case _EditPlantState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditPlantState value)?  $default,){
final _that = this;
switch (_that) {
case _EditPlantState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EditPlantDraft initial,  EditPlantDraft draft,  SubmitStatus submitStatus,  ApiError? submitError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditPlantState() when $default != null:
return $default(_that.initial,_that.draft,_that.submitStatus,_that.submitError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EditPlantDraft initial,  EditPlantDraft draft,  SubmitStatus submitStatus,  ApiError? submitError)  $default,) {final _that = this;
switch (_that) {
case _EditPlantState():
return $default(_that.initial,_that.draft,_that.submitStatus,_that.submitError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EditPlantDraft initial,  EditPlantDraft draft,  SubmitStatus submitStatus,  ApiError? submitError)?  $default,) {final _that = this;
switch (_that) {
case _EditPlantState() when $default != null:
return $default(_that.initial,_that.draft,_that.submitStatus,_that.submitError);case _:
  return null;

}
}

}

/// @nodoc


class _EditPlantState extends EditPlantState {
  const _EditPlantState({required this.initial, required this.draft, this.submitStatus = SubmitStatus.idle, this.submitError}): super._();
  

@override final  EditPlantDraft initial;
@override final  EditPlantDraft draft;
@override@JsonKey() final  SubmitStatus submitStatus;
@override final  ApiError? submitError;

/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditPlantStateCopyWith<_EditPlantState> get copyWith => __$EditPlantStateCopyWithImpl<_EditPlantState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditPlantState&&(identical(other.initial, initial) || other.initial == initial)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.submitStatus, submitStatus) || other.submitStatus == submitStatus)&&(identical(other.submitError, submitError) || other.submitError == submitError));
}


@override
int get hashCode => Object.hash(runtimeType,initial,draft,submitStatus,submitError);

@override
String toString() {
  return 'EditPlantState(initial: $initial, draft: $draft, submitStatus: $submitStatus, submitError: $submitError)';
}


}

/// @nodoc
abstract mixin class _$EditPlantStateCopyWith<$Res> implements $EditPlantStateCopyWith<$Res> {
  factory _$EditPlantStateCopyWith(_EditPlantState value, $Res Function(_EditPlantState) _then) = __$EditPlantStateCopyWithImpl;
@override @useResult
$Res call({
 EditPlantDraft initial, EditPlantDraft draft, SubmitStatus submitStatus, ApiError? submitError
});


@override $EditPlantDraftCopyWith<$Res> get initial;@override $EditPlantDraftCopyWith<$Res> get draft;@override $ApiErrorCopyWith<$Res>? get submitError;

}
/// @nodoc
class __$EditPlantStateCopyWithImpl<$Res>
    implements _$EditPlantStateCopyWith<$Res> {
  __$EditPlantStateCopyWithImpl(this._self, this._then);

  final _EditPlantState _self;
  final $Res Function(_EditPlantState) _then;

/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initial = null,Object? draft = null,Object? submitStatus = null,Object? submitError = freezed,}) {
  return _then(_EditPlantState(
initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as EditPlantDraft,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as EditPlantDraft,submitStatus: null == submitStatus ? _self.submitStatus : submitStatus // ignore: cast_nullable_to_non_nullable
as SubmitStatus,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditPlantDraftCopyWith<$Res> get initial {
  
  return $EditPlantDraftCopyWith<$Res>(_self.initial, (value) {
    return _then(_self.copyWith(initial: value));
  });
}/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditPlantDraftCopyWith<$Res> get draft {
  
  return $EditPlantDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of EditPlantState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get submitError {
    if (_self.submitError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.submitError!, (value) {
    return _then(_self.copyWith(submitError: value));
  });
}
}

// dart format on
