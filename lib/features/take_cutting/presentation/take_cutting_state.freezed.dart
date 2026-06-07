// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'take_cutting_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TakeCuttingState {

/// Имя ростка. Валидируется [isNameValid].
 String get name;/// Выбранный способ размножения (по умолчанию — «в воду»).
 PropagationMethod get method;/// Дата среза черенка (по умолчанию — сегодня, ставится контроллером).
 DateTime? get cutAt; TakeCuttingSubmitStatus get status;
/// Create a copy of TakeCuttingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TakeCuttingStateCopyWith<TakeCuttingState> get copyWith => _$TakeCuttingStateCopyWithImpl<TakeCuttingState>(this as TakeCuttingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakeCuttingState&&(identical(other.name, name) || other.name == name)&&(identical(other.method, method) || other.method == method)&&(identical(other.cutAt, cutAt) || other.cutAt == cutAt)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,name,method,cutAt,status);

@override
String toString() {
  return 'TakeCuttingState(name: $name, method: $method, cutAt: $cutAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $TakeCuttingStateCopyWith<$Res>  {
  factory $TakeCuttingStateCopyWith(TakeCuttingState value, $Res Function(TakeCuttingState) _then) = _$TakeCuttingStateCopyWithImpl;
@useResult
$Res call({
 String name, PropagationMethod method, DateTime? cutAt, TakeCuttingSubmitStatus status
});


$TakeCuttingSubmitStatusCopyWith<$Res> get status;

}
/// @nodoc
class _$TakeCuttingStateCopyWithImpl<$Res>
    implements $TakeCuttingStateCopyWith<$Res> {
  _$TakeCuttingStateCopyWithImpl(this._self, this._then);

  final TakeCuttingState _self;
  final $Res Function(TakeCuttingState) _then;

/// Create a copy of TakeCuttingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? method = null,Object? cutAt = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PropagationMethod,cutAt: freezed == cutAt ? _self.cutAt : cutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TakeCuttingSubmitStatus,
  ));
}
/// Create a copy of TakeCuttingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TakeCuttingSubmitStatusCopyWith<$Res> get status {
  
  return $TakeCuttingSubmitStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [TakeCuttingState].
extension TakeCuttingStatePatterns on TakeCuttingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TakeCuttingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TakeCuttingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TakeCuttingState value)  $default,){
final _that = this;
switch (_that) {
case _TakeCuttingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TakeCuttingState value)?  $default,){
final _that = this;
switch (_that) {
case _TakeCuttingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  PropagationMethod method,  DateTime? cutAt,  TakeCuttingSubmitStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TakeCuttingState() when $default != null:
return $default(_that.name,_that.method,_that.cutAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  PropagationMethod method,  DateTime? cutAt,  TakeCuttingSubmitStatus status)  $default,) {final _that = this;
switch (_that) {
case _TakeCuttingState():
return $default(_that.name,_that.method,_that.cutAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  PropagationMethod method,  DateTime? cutAt,  TakeCuttingSubmitStatus status)?  $default,) {final _that = this;
switch (_that) {
case _TakeCuttingState() when $default != null:
return $default(_that.name,_that.method,_that.cutAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _TakeCuttingState extends TakeCuttingState {
  const _TakeCuttingState({this.name = '', this.method = PropagationMethod.water, this.cutAt, this.status = const TakeCuttingSubmitStatus.idle()}): super._();
  

/// Имя ростка. Валидируется [isNameValid].
@override@JsonKey() final  String name;
/// Выбранный способ размножения (по умолчанию — «в воду»).
@override@JsonKey() final  PropagationMethod method;
/// Дата среза черенка (по умолчанию — сегодня, ставится контроллером).
@override final  DateTime? cutAt;
@override@JsonKey() final  TakeCuttingSubmitStatus status;

/// Create a copy of TakeCuttingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TakeCuttingStateCopyWith<_TakeCuttingState> get copyWith => __$TakeCuttingStateCopyWithImpl<_TakeCuttingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TakeCuttingState&&(identical(other.name, name) || other.name == name)&&(identical(other.method, method) || other.method == method)&&(identical(other.cutAt, cutAt) || other.cutAt == cutAt)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,name,method,cutAt,status);

@override
String toString() {
  return 'TakeCuttingState(name: $name, method: $method, cutAt: $cutAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TakeCuttingStateCopyWith<$Res> implements $TakeCuttingStateCopyWith<$Res> {
  factory _$TakeCuttingStateCopyWith(_TakeCuttingState value, $Res Function(_TakeCuttingState) _then) = __$TakeCuttingStateCopyWithImpl;
@override @useResult
$Res call({
 String name, PropagationMethod method, DateTime? cutAt, TakeCuttingSubmitStatus status
});


@override $TakeCuttingSubmitStatusCopyWith<$Res> get status;

}
/// @nodoc
class __$TakeCuttingStateCopyWithImpl<$Res>
    implements _$TakeCuttingStateCopyWith<$Res> {
  __$TakeCuttingStateCopyWithImpl(this._self, this._then);

  final _TakeCuttingState _self;
  final $Res Function(_TakeCuttingState) _then;

/// Create a copy of TakeCuttingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? method = null,Object? cutAt = freezed,Object? status = null,}) {
  return _then(_TakeCuttingState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PropagationMethod,cutAt: freezed == cutAt ? _self.cutAt : cutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TakeCuttingSubmitStatus,
  ));
}

/// Create a copy of TakeCuttingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TakeCuttingSubmitStatusCopyWith<$Res> get status {
  
  return $TakeCuttingSubmitStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

/// @nodoc
mixin _$TakeCuttingSubmitStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakeCuttingSubmitStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TakeCuttingSubmitStatus()';
}


}

/// @nodoc
class $TakeCuttingSubmitStatusCopyWith<$Res>  {
$TakeCuttingSubmitStatusCopyWith(TakeCuttingSubmitStatus _, $Res Function(TakeCuttingSubmitStatus) __);
}


/// Adds pattern-matching-related methods to [TakeCuttingSubmitStatus].
extension TakeCuttingSubmitStatusPatterns on TakeCuttingSubmitStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TakeCuttingIdle value)?  idle,TResult Function( TakeCuttingSubmitting value)?  submitting,TResult Function( TakeCuttingSuccess value)?  success,TResult Function( TakeCuttingFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TakeCuttingIdle() when idle != null:
return idle(_that);case TakeCuttingSubmitting() when submitting != null:
return submitting(_that);case TakeCuttingSuccess() when success != null:
return success(_that);case TakeCuttingFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TakeCuttingIdle value)  idle,required TResult Function( TakeCuttingSubmitting value)  submitting,required TResult Function( TakeCuttingSuccess value)  success,required TResult Function( TakeCuttingFailure value)  failure,}){
final _that = this;
switch (_that) {
case TakeCuttingIdle():
return idle(_that);case TakeCuttingSubmitting():
return submitting(_that);case TakeCuttingSuccess():
return success(_that);case TakeCuttingFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TakeCuttingIdle value)?  idle,TResult? Function( TakeCuttingSubmitting value)?  submitting,TResult? Function( TakeCuttingSuccess value)?  success,TResult? Function( TakeCuttingFailure value)?  failure,}){
final _that = this;
switch (_that) {
case TakeCuttingIdle() when idle != null:
return idle(_that);case TakeCuttingSubmitting() when submitting != null:
return submitting(_that);case TakeCuttingSuccess() when success != null:
return success(_that);case TakeCuttingFailure() when failure != null:
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
case TakeCuttingIdle() when idle != null:
return idle();case TakeCuttingSubmitting() when submitting != null:
return submitting();case TakeCuttingSuccess() when success != null:
return success(_that.plantId);case TakeCuttingFailure() when failure != null:
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
case TakeCuttingIdle():
return idle();case TakeCuttingSubmitting():
return submitting();case TakeCuttingSuccess():
return success(_that.plantId);case TakeCuttingFailure():
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
case TakeCuttingIdle() when idle != null:
return idle();case TakeCuttingSubmitting() when submitting != null:
return submitting();case TakeCuttingSuccess() when success != null:
return success(_that.plantId);case TakeCuttingFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class TakeCuttingIdle implements TakeCuttingSubmitStatus {
  const TakeCuttingIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakeCuttingIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TakeCuttingSubmitStatus.idle()';
}


}




/// @nodoc


class TakeCuttingSubmitting implements TakeCuttingSubmitStatus {
  const TakeCuttingSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakeCuttingSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TakeCuttingSubmitStatus.submitting()';
}


}




/// @nodoc


class TakeCuttingSuccess implements TakeCuttingSubmitStatus {
  const TakeCuttingSuccess(this.plantId);
  

 final  int plantId;

/// Create a copy of TakeCuttingSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TakeCuttingSuccessCopyWith<TakeCuttingSuccess> get copyWith => _$TakeCuttingSuccessCopyWithImpl<TakeCuttingSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakeCuttingSuccess&&(identical(other.plantId, plantId) || other.plantId == plantId));
}


@override
int get hashCode => Object.hash(runtimeType,plantId);

@override
String toString() {
  return 'TakeCuttingSubmitStatus.success(plantId: $plantId)';
}


}

/// @nodoc
abstract mixin class $TakeCuttingSuccessCopyWith<$Res> implements $TakeCuttingSubmitStatusCopyWith<$Res> {
  factory $TakeCuttingSuccessCopyWith(TakeCuttingSuccess value, $Res Function(TakeCuttingSuccess) _then) = _$TakeCuttingSuccessCopyWithImpl;
@useResult
$Res call({
 int plantId
});




}
/// @nodoc
class _$TakeCuttingSuccessCopyWithImpl<$Res>
    implements $TakeCuttingSuccessCopyWith<$Res> {
  _$TakeCuttingSuccessCopyWithImpl(this._self, this._then);

  final TakeCuttingSuccess _self;
  final $Res Function(TakeCuttingSuccess) _then;

/// Create a copy of TakeCuttingSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plantId = null,}) {
  return _then(TakeCuttingSuccess(
null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TakeCuttingFailure implements TakeCuttingSubmitStatus {
  const TakeCuttingFailure(this.error);
  

 final  ApiError error;

/// Create a copy of TakeCuttingSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TakeCuttingFailureCopyWith<TakeCuttingFailure> get copyWith => _$TakeCuttingFailureCopyWithImpl<TakeCuttingFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakeCuttingFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'TakeCuttingSubmitStatus.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $TakeCuttingFailureCopyWith<$Res> implements $TakeCuttingSubmitStatusCopyWith<$Res> {
  factory $TakeCuttingFailureCopyWith(TakeCuttingFailure value, $Res Function(TakeCuttingFailure) _then) = _$TakeCuttingFailureCopyWithImpl;
@useResult
$Res call({
 ApiError error
});


$ApiErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$TakeCuttingFailureCopyWithImpl<$Res>
    implements $TakeCuttingFailureCopyWith<$Res> {
  _$TakeCuttingFailureCopyWithImpl(this._self, this._then);

  final TakeCuttingFailure _self;
  final $Res Function(TakeCuttingFailure) _then;

/// Create a copy of TakeCuttingSubmitStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(TakeCuttingFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError,
  ));
}

/// Create a copy of TakeCuttingSubmitStatus
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
