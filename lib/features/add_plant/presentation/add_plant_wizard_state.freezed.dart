// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_plant_wizard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddPlantWizardState {

 NewPlantDraft get draft; AddPlantSubmitStatus get status;
/// Create a copy of AddPlantWizardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddPlantWizardStateCopyWith<AddPlantWizardState> get copyWith => _$AddPlantWizardStateCopyWithImpl<AddPlantWizardState>(this as AddPlantWizardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddPlantWizardState&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,draft,status);

@override
String toString() {
  return 'AddPlantWizardState(draft: $draft, status: $status)';
}


}

/// @nodoc
abstract mixin class $AddPlantWizardStateCopyWith<$Res>  {
  factory $AddPlantWizardStateCopyWith(AddPlantWizardState value, $Res Function(AddPlantWizardState) _then) = _$AddPlantWizardStateCopyWithImpl;
@useResult
$Res call({
 NewPlantDraft draft, AddPlantSubmitStatus status
});


$NewPlantDraftCopyWith<$Res> get draft;$AddPlantSubmitStatusCopyWith<$Res> get status;

}
/// @nodoc
class _$AddPlantWizardStateCopyWithImpl<$Res>
    implements $AddPlantWizardStateCopyWith<$Res> {
  _$AddPlantWizardStateCopyWithImpl(this._self, this._then);

  final AddPlantWizardState _self;
  final $Res Function(AddPlantWizardState) _then;

/// Create a copy of AddPlantWizardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draft = null,Object? status = null,}) {
  return _then(_self.copyWith(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as NewPlantDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AddPlantSubmitStatus,
  ));
}
/// Create a copy of AddPlantWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewPlantDraftCopyWith<$Res> get draft {
  
  return $NewPlantDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of AddPlantWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddPlantSubmitStatusCopyWith<$Res> get status {
  
  return $AddPlantSubmitStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddPlantWizardState].
extension AddPlantWizardStatePatterns on AddPlantWizardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddPlantWizardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddPlantWizardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddPlantWizardState value)  $default,){
final _that = this;
switch (_that) {
case _AddPlantWizardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddPlantWizardState value)?  $default,){
final _that = this;
switch (_that) {
case _AddPlantWizardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NewPlantDraft draft,  AddPlantSubmitStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddPlantWizardState() when $default != null:
return $default(_that.draft,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NewPlantDraft draft,  AddPlantSubmitStatus status)  $default,) {final _that = this;
switch (_that) {
case _AddPlantWizardState():
return $default(_that.draft,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NewPlantDraft draft,  AddPlantSubmitStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AddPlantWizardState() when $default != null:
return $default(_that.draft,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _AddPlantWizardState extends AddPlantWizardState {
  const _AddPlantWizardState({this.draft = const NewPlantDraft(), this.status = const AddPlantSubmitStatus.idle()}): super._();
  

@override@JsonKey() final  NewPlantDraft draft;
@override@JsonKey() final  AddPlantSubmitStatus status;

/// Create a copy of AddPlantWizardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddPlantWizardStateCopyWith<_AddPlantWizardState> get copyWith => __$AddPlantWizardStateCopyWithImpl<_AddPlantWizardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddPlantWizardState&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,draft,status);

@override
String toString() {
  return 'AddPlantWizardState(draft: $draft, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AddPlantWizardStateCopyWith<$Res> implements $AddPlantWizardStateCopyWith<$Res> {
  factory _$AddPlantWizardStateCopyWith(_AddPlantWizardState value, $Res Function(_AddPlantWizardState) _then) = __$AddPlantWizardStateCopyWithImpl;
@override @useResult
$Res call({
 NewPlantDraft draft, AddPlantSubmitStatus status
});


@override $NewPlantDraftCopyWith<$Res> get draft;@override $AddPlantSubmitStatusCopyWith<$Res> get status;

}
/// @nodoc
class __$AddPlantWizardStateCopyWithImpl<$Res>
    implements _$AddPlantWizardStateCopyWith<$Res> {
  __$AddPlantWizardStateCopyWithImpl(this._self, this._then);

  final _AddPlantWizardState _self;
  final $Res Function(_AddPlantWizardState) _then;

/// Create a copy of AddPlantWizardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draft = null,Object? status = null,}) {
  return _then(_AddPlantWizardState(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as NewPlantDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AddPlantSubmitStatus,
  ));
}

/// Create a copy of AddPlantWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewPlantDraftCopyWith<$Res> get draft {
  
  return $NewPlantDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of AddPlantWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddPlantSubmitStatusCopyWith<$Res> get status {
  
  return $AddPlantSubmitStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

/// @nodoc
mixin _$AddPlantSubmitStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddPlantSubmitStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddPlantSubmitStatus()';
}


}

/// @nodoc
class $AddPlantSubmitStatusCopyWith<$Res>  {
$AddPlantSubmitStatusCopyWith(AddPlantSubmitStatus _, $Res Function(AddPlantSubmitStatus) __);
}


/// Adds pattern-matching-related methods to [AddPlantSubmitStatus].
extension AddPlantSubmitStatusPatterns on AddPlantSubmitStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddPlantIdle value)?  idle,TResult Function( AddPlantSubmitting value)?  submitting,TResult Function( AddPlantSuccess value)?  success,TResult Function( AddPlantFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddPlantIdle() when idle != null:
return idle(_that);case AddPlantSubmitting() when submitting != null:
return submitting(_that);case AddPlantSuccess() when success != null:
return success(_that);case AddPlantFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddPlantIdle value)  idle,required TResult Function( AddPlantSubmitting value)  submitting,required TResult Function( AddPlantSuccess value)  success,required TResult Function( AddPlantFailure value)  failure,}){
final _that = this;
switch (_that) {
case AddPlantIdle():
return idle(_that);case AddPlantSubmitting():
return submitting(_that);case AddPlantSuccess():
return success(_that);case AddPlantFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddPlantIdle value)?  idle,TResult? Function( AddPlantSubmitting value)?  submitting,TResult? Function( AddPlantSuccess value)?  success,TResult? Function( AddPlantFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AddPlantIdle() when idle != null:
return idle(_that);case AddPlantSubmitting() when submitting != null:
return submitting(_that);case AddPlantSuccess() when success != null:
return success(_that);case AddPlantFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function( int plantId)?  success,TResult Function( ApiError error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddPlantIdle() when idle != null:
return idle();case AddPlantSubmitting() when submitting != null:
return submitting();case AddPlantSuccess() when success != null:
return success(_that.plantId);case AddPlantFailure() when failure != null:
return failure(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function( int plantId)  success,required TResult Function( ApiError error)  failure,}) {final _that = this;
switch (_that) {
case AddPlantIdle():
return idle();case AddPlantSubmitting():
return submitting();case AddPlantSuccess():
return success(_that.plantId);case AddPlantFailure():
return failure(_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function( int plantId)?  success,TResult? Function( ApiError error)?  failure,}) {final _that = this;
switch (_that) {
case AddPlantIdle() when idle != null:
return idle();case AddPlantSubmitting() when submitting != null:
return submitting();case AddPlantSuccess() when success != null:
return success(_that.plantId);case AddPlantFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class AddPlantIdle implements AddPlantSubmitStatus {
  const AddPlantIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddPlantIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddPlantSubmitStatus.idle()';
}


}




/// @nodoc


class AddPlantSubmitting implements AddPlantSubmitStatus {
  const AddPlantSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddPlantSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddPlantSubmitStatus.submitting()';
}


}




/// @nodoc


class AddPlantSuccess implements AddPlantSubmitStatus {
  const AddPlantSuccess(this.plantId);
  

 final  int plantId;

/// Create a copy of AddPlantSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddPlantSuccessCopyWith<AddPlantSuccess> get copyWith => _$AddPlantSuccessCopyWithImpl<AddPlantSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddPlantSuccess&&(identical(other.plantId, plantId) || other.plantId == plantId));
}


@override
int get hashCode => Object.hash(runtimeType,plantId);

@override
String toString() {
  return 'AddPlantSubmitStatus.success(plantId: $plantId)';
}


}

/// @nodoc
abstract mixin class $AddPlantSuccessCopyWith<$Res> implements $AddPlantSubmitStatusCopyWith<$Res> {
  factory $AddPlantSuccessCopyWith(AddPlantSuccess value, $Res Function(AddPlantSuccess) _then) = _$AddPlantSuccessCopyWithImpl;
@useResult
$Res call({
 int plantId
});




}
/// @nodoc
class _$AddPlantSuccessCopyWithImpl<$Res>
    implements $AddPlantSuccessCopyWith<$Res> {
  _$AddPlantSuccessCopyWithImpl(this._self, this._then);

  final AddPlantSuccess _self;
  final $Res Function(AddPlantSuccess) _then;

/// Create a copy of AddPlantSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plantId = null,}) {
  return _then(AddPlantSuccess(
null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class AddPlantFailure implements AddPlantSubmitStatus {
  const AddPlantFailure(this.error);
  

 final  ApiError error;

/// Create a copy of AddPlantSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddPlantFailureCopyWith<AddPlantFailure> get copyWith => _$AddPlantFailureCopyWithImpl<AddPlantFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddPlantFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'AddPlantSubmitStatus.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $AddPlantFailureCopyWith<$Res> implements $AddPlantSubmitStatusCopyWith<$Res> {
  factory $AddPlantFailureCopyWith(AddPlantFailure value, $Res Function(AddPlantFailure) _then) = _$AddPlantFailureCopyWithImpl;
@useResult
$Res call({
 ApiError error
});


$ApiErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$AddPlantFailureCopyWithImpl<$Res>
    implements $AddPlantFailureCopyWith<$Res> {
  _$AddPlantFailureCopyWithImpl(this._self, this._then);

  final AddPlantFailure _self;
  final $Res Function(AddPlantFailure) _then;

/// Create a copy of AddPlantSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(AddPlantFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError,
  ));
}

/// Create a copy of AddPlantSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res> get error {
  
  return $ApiErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
