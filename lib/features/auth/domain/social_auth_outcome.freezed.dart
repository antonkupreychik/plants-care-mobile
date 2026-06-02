// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_auth_outcome.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SocialAuthOutcome {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialAuthOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SocialAuthOutcome()';
}


}

/// @nodoc
class $SocialAuthOutcomeCopyWith<$Res>  {
$SocialAuthOutcomeCopyWith(SocialAuthOutcome _, $Res Function(SocialAuthOutcome) __);
}


/// Adds pattern-matching-related methods to [SocialAuthOutcome].
extension SocialAuthOutcomePatterns on SocialAuthOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SocialAuthSuccess value)?  success,TResult Function( SocialAuthCancelled value)?  cancelled,TResult Function( SocialAuthFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SocialAuthSuccess() when success != null:
return success(_that);case SocialAuthCancelled() when cancelled != null:
return cancelled(_that);case SocialAuthFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SocialAuthSuccess value)  success,required TResult Function( SocialAuthCancelled value)  cancelled,required TResult Function( SocialAuthFailure value)  failure,}){
final _that = this;
switch (_that) {
case SocialAuthSuccess():
return success(_that);case SocialAuthCancelled():
return cancelled(_that);case SocialAuthFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SocialAuthSuccess value)?  success,TResult? Function( SocialAuthCancelled value)?  cancelled,TResult? Function( SocialAuthFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SocialAuthSuccess() when success != null:
return success(_that);case SocialAuthCancelled() when cancelled != null:
return cancelled(_that);case SocialAuthFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  success,TResult Function()?  cancelled,TResult Function( ApiError error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SocialAuthSuccess() when success != null:
return success();case SocialAuthCancelled() when cancelled != null:
return cancelled();case SocialAuthFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  success,required TResult Function()  cancelled,required TResult Function( ApiError error)  failure,}) {final _that = this;
switch (_that) {
case SocialAuthSuccess():
return success();case SocialAuthCancelled():
return cancelled();case SocialAuthFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  success,TResult? Function()?  cancelled,TResult? Function( ApiError error)?  failure,}) {final _that = this;
switch (_that) {
case SocialAuthSuccess() when success != null:
return success();case SocialAuthCancelled() when cancelled != null:
return cancelled();case SocialAuthFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class SocialAuthSuccess extends SocialAuthOutcome {
  const SocialAuthSuccess(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialAuthSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SocialAuthOutcome.success()';
}


}




/// @nodoc


class SocialAuthCancelled extends SocialAuthOutcome {
  const SocialAuthCancelled(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialAuthCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SocialAuthOutcome.cancelled()';
}


}




/// @nodoc


class SocialAuthFailure extends SocialAuthOutcome {
  const SocialAuthFailure(this.error): super._();
  

 final  ApiError error;

/// Create a copy of SocialAuthOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocialAuthFailureCopyWith<SocialAuthFailure> get copyWith => _$SocialAuthFailureCopyWithImpl<SocialAuthFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialAuthFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'SocialAuthOutcome.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $SocialAuthFailureCopyWith<$Res> implements $SocialAuthOutcomeCopyWith<$Res> {
  factory $SocialAuthFailureCopyWith(SocialAuthFailure value, $Res Function(SocialAuthFailure) _then) = _$SocialAuthFailureCopyWithImpl;
@useResult
$Res call({
 ApiError error
});


$ApiErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$SocialAuthFailureCopyWithImpl<$Res>
    implements $SocialAuthFailureCopyWith<$Res> {
  _$SocialAuthFailureCopyWithImpl(this._self, this._then);

  final SocialAuthFailure _self;
  final $Res Function(SocialAuthFailure) _then;

/// Create a copy of SocialAuthOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(SocialAuthFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiError,
  ));
}

/// Create a copy of SocialAuthOutcome
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
