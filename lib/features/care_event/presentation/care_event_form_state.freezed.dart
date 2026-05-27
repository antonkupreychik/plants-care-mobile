// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_event_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareEventFormState {

/// Растение, для которого отмечается уход.
 int get plantId;/// Выбранный тип ухода. `unknown` UI не предлагает (невалиден для отправки).
 CareEventKind get type;/// Момент выполнения в UTC. Дефолт — «сейчас», допускается прошлое.
 DateTime get performedAtUtc;/// Статус отправки (idle/submitting/success/failure).
 CareEventSubmitStatus get status;/// Необязательная заметка.
 String? get note;
/// Create a copy of CareEventFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareEventFormStateCopyWith<CareEventFormState> get copyWith => _$CareEventFormStateCopyWithImpl<CareEventFormState>(this as CareEventFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareEventFormState&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.type, type) || other.type == type)&&(identical(other.performedAtUtc, performedAtUtc) || other.performedAtUtc == performedAtUtc)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,plantId,type,performedAtUtc,status,note);

@override
String toString() {
  return 'CareEventFormState(plantId: $plantId, type: $type, performedAtUtc: $performedAtUtc, status: $status, note: $note)';
}


}

/// @nodoc
abstract mixin class $CareEventFormStateCopyWith<$Res>  {
  factory $CareEventFormStateCopyWith(CareEventFormState value, $Res Function(CareEventFormState) _then) = _$CareEventFormStateCopyWithImpl;
@useResult
$Res call({
 int plantId, CareEventKind type, DateTime performedAtUtc, CareEventSubmitStatus status, String? note
});


$CareEventSubmitStatusCopyWith<$Res> get status;

}
/// @nodoc
class _$CareEventFormStateCopyWithImpl<$Res>
    implements $CareEventFormStateCopyWith<$Res> {
  _$CareEventFormStateCopyWithImpl(this._self, this._then);

  final CareEventFormState _self;
  final $Res Function(CareEventFormState) _then;

/// Create a copy of CareEventFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plantId = null,Object? type = null,Object? performedAtUtc = null,Object? status = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareEventKind,performedAtUtc: null == performedAtUtc ? _self.performedAtUtc : performedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CareEventSubmitStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CareEventFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareEventSubmitStatusCopyWith<$Res> get status {
  
  return $CareEventSubmitStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [CareEventFormState].
extension CareEventFormStatePatterns on CareEventFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareEventFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareEventFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareEventFormState value)  $default,){
final _that = this;
switch (_that) {
case _CareEventFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareEventFormState value)?  $default,){
final _that = this;
switch (_that) {
case _CareEventFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int plantId,  CareEventKind type,  DateTime performedAtUtc,  CareEventSubmitStatus status,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareEventFormState() when $default != null:
return $default(_that.plantId,_that.type,_that.performedAtUtc,_that.status,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int plantId,  CareEventKind type,  DateTime performedAtUtc,  CareEventSubmitStatus status,  String? note)  $default,) {final _that = this;
switch (_that) {
case _CareEventFormState():
return $default(_that.plantId,_that.type,_that.performedAtUtc,_that.status,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int plantId,  CareEventKind type,  DateTime performedAtUtc,  CareEventSubmitStatus status,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _CareEventFormState() when $default != null:
return $default(_that.plantId,_that.type,_that.performedAtUtc,_that.status,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _CareEventFormState extends CareEventFormState {
  const _CareEventFormState({required this.plantId, required this.type, required this.performedAtUtc, this.status = const CareEventSubmitStatus.idle(), this.note}): super._();
  

/// Растение, для которого отмечается уход.
@override final  int plantId;
/// Выбранный тип ухода. `unknown` UI не предлагает (невалиден для отправки).
@override final  CareEventKind type;
/// Момент выполнения в UTC. Дефолт — «сейчас», допускается прошлое.
@override final  DateTime performedAtUtc;
/// Статус отправки (idle/submitting/success/failure).
@override@JsonKey() final  CareEventSubmitStatus status;
/// Необязательная заметка.
@override final  String? note;

/// Create a copy of CareEventFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareEventFormStateCopyWith<_CareEventFormState> get copyWith => __$CareEventFormStateCopyWithImpl<_CareEventFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareEventFormState&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.type, type) || other.type == type)&&(identical(other.performedAtUtc, performedAtUtc) || other.performedAtUtc == performedAtUtc)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,plantId,type,performedAtUtc,status,note);

@override
String toString() {
  return 'CareEventFormState(plantId: $plantId, type: $type, performedAtUtc: $performedAtUtc, status: $status, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CareEventFormStateCopyWith<$Res> implements $CareEventFormStateCopyWith<$Res> {
  factory _$CareEventFormStateCopyWith(_CareEventFormState value, $Res Function(_CareEventFormState) _then) = __$CareEventFormStateCopyWithImpl;
@override @useResult
$Res call({
 int plantId, CareEventKind type, DateTime performedAtUtc, CareEventSubmitStatus status, String? note
});


@override $CareEventSubmitStatusCopyWith<$Res> get status;

}
/// @nodoc
class __$CareEventFormStateCopyWithImpl<$Res>
    implements _$CareEventFormStateCopyWith<$Res> {
  __$CareEventFormStateCopyWithImpl(this._self, this._then);

  final _CareEventFormState _self;
  final $Res Function(_CareEventFormState) _then;

/// Create a copy of CareEventFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plantId = null,Object? type = null,Object? performedAtUtc = null,Object? status = null,Object? note = freezed,}) {
  return _then(_CareEventFormState(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareEventKind,performedAtUtc: null == performedAtUtc ? _self.performedAtUtc : performedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CareEventSubmitStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CareEventFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareEventSubmitStatusCopyWith<$Res> get status {
  
  return $CareEventSubmitStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

/// @nodoc
mixin _$CareEventSubmitStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareEventSubmitStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CareEventSubmitStatus()';
}


}

/// @nodoc
class $CareEventSubmitStatusCopyWith<$Res>  {
$CareEventSubmitStatusCopyWith(CareEventSubmitStatus _, $Res Function(CareEventSubmitStatus) __);
}


/// Adds pattern-matching-related methods to [CareEventSubmitStatus].
extension CareEventSubmitStatusPatterns on CareEventSubmitStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Idle value)?  idle,TResult Function( Submitting value)?  submitting,TResult Function( SubmitSuccess value)?  success,TResult Function( SubmitFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Idle() when idle != null:
return idle(_that);case Submitting() when submitting != null:
return submitting(_that);case SubmitSuccess() when success != null:
return success(_that);case SubmitFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Idle value)  idle,required TResult Function( Submitting value)  submitting,required TResult Function( SubmitSuccess value)  success,required TResult Function( SubmitFailure value)  failure,}){
final _that = this;
switch (_that) {
case Idle():
return idle(_that);case Submitting():
return submitting(_that);case SubmitSuccess():
return success(_that);case SubmitFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Idle value)?  idle,TResult? Function( Submitting value)?  submitting,TResult? Function( SubmitSuccess value)?  success,TResult? Function( SubmitFailure value)?  failure,}){
final _that = this;
switch (_that) {
case Idle() when idle != null:
return idle(_that);case Submitting() when submitting != null:
return submitting(_that);case SubmitSuccess() when success != null:
return success(_that);case SubmitFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function()?  success,TResult Function( ApiError error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Idle() when idle != null:
return idle();case Submitting() when submitting != null:
return submitting();case SubmitSuccess() when success != null:
return success();case SubmitFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function()  success,required TResult Function( ApiError error)  failure,}) {final _that = this;
switch (_that) {
case Idle():
return idle();case Submitting():
return submitting();case SubmitSuccess():
return success();case SubmitFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function()?  success,TResult? Function( ApiError error)?  failure,}) {final _that = this;
switch (_that) {
case Idle() when idle != null:
return idle();case Submitting() when submitting != null:
return submitting();case SubmitSuccess() when success != null:
return success();case SubmitFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class Idle implements CareEventSubmitStatus {
  const Idle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CareEventSubmitStatus.idle()';
}


}




/// @nodoc


class Submitting implements CareEventSubmitStatus {
  const Submitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Submitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CareEventSubmitStatus.submitting()';
}


}




/// @nodoc


class SubmitSuccess implements CareEventSubmitStatus {
  const SubmitSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CareEventSubmitStatus.success()';
}


}




/// @nodoc


class SubmitFailure implements CareEventSubmitStatus {
  const SubmitFailure(this.error);
  

 final  ApiError error;

/// Create a copy of CareEventSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitFailureCopyWith<SubmitFailure> get copyWith => _$SubmitFailureCopyWithImpl<SubmitFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'CareEventSubmitStatus.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $SubmitFailureCopyWith<$Res> implements $CareEventSubmitStatusCopyWith<$Res> {
  factory $SubmitFailureCopyWith(SubmitFailure value, $Res Function(SubmitFailure) _then) = _$SubmitFailureCopyWithImpl;
@useResult
$Res call({
 ApiError error
});


$ApiErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$SubmitFailureCopyWithImpl<$Res>
    implements $SubmitFailureCopyWith<$Res> {
  _$SubmitFailureCopyWithImpl(this._self, this._then);

  final SubmitFailure _self;
  final $Res Function(SubmitFailure) _then;

/// Create a copy of CareEventSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(SubmitFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError,
  ));
}

/// Create a copy of CareEventSubmitStatus
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
