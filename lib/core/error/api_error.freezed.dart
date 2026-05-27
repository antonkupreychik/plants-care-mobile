// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiError()';
}


}

/// @nodoc
class $ApiErrorCopyWith<$Res>  {
$ApiErrorCopyWith(ApiError _, $Res Function(ApiError) __);
}


/// Adds pattern-matching-related methods to [ApiError].
extension ApiErrorPatterns on ApiError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ValidationError value)?  validation,TResult Function( BadRequestError value)?  badRequest,TResult Function( LocationNotEmptyError value)?  locationNotEmpty,TResult Function( AccessDeniedError value)?  accessDenied,TResult Function( NotFoundError value)?  notFound,TResult Function( ConflictError value)?  conflict,TResult Function( NetworkError value)?  network,TResult Function( UnknownError value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ValidationError() when validation != null:
return validation(_that);case BadRequestError() when badRequest != null:
return badRequest(_that);case LocationNotEmptyError() when locationNotEmpty != null:
return locationNotEmpty(_that);case AccessDeniedError() when accessDenied != null:
return accessDenied(_that);case NotFoundError() when notFound != null:
return notFound(_that);case ConflictError() when conflict != null:
return conflict(_that);case NetworkError() when network != null:
return network(_that);case UnknownError() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ValidationError value)  validation,required TResult Function( BadRequestError value)  badRequest,required TResult Function( LocationNotEmptyError value)  locationNotEmpty,required TResult Function( AccessDeniedError value)  accessDenied,required TResult Function( NotFoundError value)  notFound,required TResult Function( ConflictError value)  conflict,required TResult Function( NetworkError value)  network,required TResult Function( UnknownError value)  unknown,}){
final _that = this;
switch (_that) {
case ValidationError():
return validation(_that);case BadRequestError():
return badRequest(_that);case LocationNotEmptyError():
return locationNotEmpty(_that);case AccessDeniedError():
return accessDenied(_that);case NotFoundError():
return notFound(_that);case ConflictError():
return conflict(_that);case NetworkError():
return network(_that);case UnknownError():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ValidationError value)?  validation,TResult? Function( BadRequestError value)?  badRequest,TResult? Function( LocationNotEmptyError value)?  locationNotEmpty,TResult? Function( AccessDeniedError value)?  accessDenied,TResult? Function( NotFoundError value)?  notFound,TResult? Function( ConflictError value)?  conflict,TResult? Function( NetworkError value)?  network,TResult? Function( UnknownError value)?  unknown,}){
final _that = this;
switch (_that) {
case ValidationError() when validation != null:
return validation(_that);case BadRequestError() when badRequest != null:
return badRequest(_that);case LocationNotEmptyError() when locationNotEmpty != null:
return locationNotEmpty(_that);case AccessDeniedError() when accessDenied != null:
return accessDenied(_that);case NotFoundError() when notFound != null:
return notFound(_that);case ConflictError() when conflict != null:
return conflict(_that);case NetworkError() when network != null:
return network(_that);case UnknownError() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<FieldError> details)?  validation,TResult Function( String? message)?  badRequest,TResult Function()?  locationNotEmpty,TResult Function()?  accessDenied,TResult Function()?  notFound,TResult Function()?  conflict,TResult Function()?  network,TResult Function( String? message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ValidationError() when validation != null:
return validation(_that.details);case BadRequestError() when badRequest != null:
return badRequest(_that.message);case LocationNotEmptyError() when locationNotEmpty != null:
return locationNotEmpty();case AccessDeniedError() when accessDenied != null:
return accessDenied();case NotFoundError() when notFound != null:
return notFound();case ConflictError() when conflict != null:
return conflict();case NetworkError() when network != null:
return network();case UnknownError() when unknown != null:
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<FieldError> details)  validation,required TResult Function( String? message)  badRequest,required TResult Function()  locationNotEmpty,required TResult Function()  accessDenied,required TResult Function()  notFound,required TResult Function()  conflict,required TResult Function()  network,required TResult Function( String? message)  unknown,}) {final _that = this;
switch (_that) {
case ValidationError():
return validation(_that.details);case BadRequestError():
return badRequest(_that.message);case LocationNotEmptyError():
return locationNotEmpty();case AccessDeniedError():
return accessDenied();case NotFoundError():
return notFound();case ConflictError():
return conflict();case NetworkError():
return network();case UnknownError():
return unknown(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<FieldError> details)?  validation,TResult? Function( String? message)?  badRequest,TResult? Function()?  locationNotEmpty,TResult? Function()?  accessDenied,TResult? Function()?  notFound,TResult? Function()?  conflict,TResult? Function()?  network,TResult? Function( String? message)?  unknown,}) {final _that = this;
switch (_that) {
case ValidationError() when validation != null:
return validation(_that.details);case BadRequestError() when badRequest != null:
return badRequest(_that.message);case LocationNotEmptyError() when locationNotEmpty != null:
return locationNotEmpty();case AccessDeniedError() when accessDenied != null:
return accessDenied();case NotFoundError() when notFound != null:
return notFound();case ConflictError() when conflict != null:
return conflict();case NetworkError() when network != null:
return network();case UnknownError() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ValidationError extends ApiError {
  const ValidationError({required final  List<FieldError> details}): _details = details,super._();
  

 final  List<FieldError> _details;
 List<FieldError> get details {
  if (_details is EqualUnmodifiableListView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_details);
}


/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationErrorCopyWith<ValidationError> get copyWith => _$ValidationErrorCopyWithImpl<ValidationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationError&&const DeepCollectionEquality().equals(other._details, _details));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_details));

@override
String toString() {
  return 'ApiError.validation(details: $details)';
}


}

/// @nodoc
abstract mixin class $ValidationErrorCopyWith<$Res> implements $ApiErrorCopyWith<$Res> {
  factory $ValidationErrorCopyWith(ValidationError value, $Res Function(ValidationError) _then) = _$ValidationErrorCopyWithImpl;
@useResult
$Res call({
 List<FieldError> details
});




}
/// @nodoc
class _$ValidationErrorCopyWithImpl<$Res>
    implements $ValidationErrorCopyWith<$Res> {
  _$ValidationErrorCopyWithImpl(this._self, this._then);

  final ValidationError _self;
  final $Res Function(ValidationError) _then;

/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? details = null,}) {
  return _then(ValidationError(
details: null == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as List<FieldError>,
  ));
}


}

/// @nodoc


class BadRequestError extends ApiError {
  const BadRequestError({this.message}): super._();
  

 final  String? message;

/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadRequestErrorCopyWith<BadRequestError> get copyWith => _$BadRequestErrorCopyWithImpl<BadRequestError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadRequestError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ApiError.badRequest(message: $message)';
}


}

/// @nodoc
abstract mixin class $BadRequestErrorCopyWith<$Res> implements $ApiErrorCopyWith<$Res> {
  factory $BadRequestErrorCopyWith(BadRequestError value, $Res Function(BadRequestError) _then) = _$BadRequestErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$BadRequestErrorCopyWithImpl<$Res>
    implements $BadRequestErrorCopyWith<$Res> {
  _$BadRequestErrorCopyWithImpl(this._self, this._then);

  final BadRequestError _self;
  final $Res Function(BadRequestError) _then;

/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(BadRequestError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class LocationNotEmptyError extends ApiError {
  const LocationNotEmptyError(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationNotEmptyError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiError.locationNotEmpty()';
}


}




/// @nodoc


class AccessDeniedError extends ApiError {
  const AccessDeniedError(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessDeniedError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiError.accessDenied()';
}


}




/// @nodoc


class NotFoundError extends ApiError {
  const NotFoundError(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiError.notFound()';
}


}




/// @nodoc


class ConflictError extends ApiError {
  const ConflictError(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiError.conflict()';
}


}




/// @nodoc


class NetworkError extends ApiError {
  const NetworkError(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiError.network()';
}


}




/// @nodoc


class UnknownError extends ApiError {
  const UnknownError({this.message}): super._();
  

 final  String? message;

/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownErrorCopyWith<UnknownError> get copyWith => _$UnknownErrorCopyWithImpl<UnknownError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ApiError.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnknownErrorCopyWith<$Res> implements $ApiErrorCopyWith<$Res> {
  factory $UnknownErrorCopyWith(UnknownError value, $Res Function(UnknownError) _then) = _$UnknownErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$UnknownErrorCopyWithImpl<$Res>
    implements $UnknownErrorCopyWith<$Res> {
  _$UnknownErrorCopyWithImpl(this._self, this._then);

  final UnknownError _self;
  final $Res Function(UnknownError) _then;

/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(UnknownError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FieldError {

 String get field; String get message;
/// Create a copy of FieldError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldErrorCopyWith<FieldError> get copyWith => _$FieldErrorCopyWithImpl<FieldError>(this as FieldError, _$identity);

  /// Serializes this FieldError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldError&&(identical(other.field, field) || other.field == field)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,message);

@override
String toString() {
  return 'FieldError(field: $field, message: $message)';
}


}

/// @nodoc
abstract mixin class $FieldErrorCopyWith<$Res>  {
  factory $FieldErrorCopyWith(FieldError value, $Res Function(FieldError) _then) = _$FieldErrorCopyWithImpl;
@useResult
$Res call({
 String field, String message
});




}
/// @nodoc
class _$FieldErrorCopyWithImpl<$Res>
    implements $FieldErrorCopyWith<$Res> {
  _$FieldErrorCopyWithImpl(this._self, this._then);

  final FieldError _self;
  final $Res Function(FieldError) _then;

/// Create a copy of FieldError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? message = null,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldError].
extension FieldErrorPatterns on FieldError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldError value)  $default,){
final _that = this;
switch (_that) {
case _FieldError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldError value)?  $default,){
final _that = this;
switch (_that) {
case _FieldError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldError() when $default != null:
return $default(_that.field,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  String message)  $default,) {final _that = this;
switch (_that) {
case _FieldError():
return $default(_that.field,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  String message)?  $default,) {final _that = this;
switch (_that) {
case _FieldError() when $default != null:
return $default(_that.field,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldError implements FieldError {
  const _FieldError({required this.field, required this.message});
  factory _FieldError.fromJson(Map<String, dynamic> json) => _$FieldErrorFromJson(json);

@override final  String field;
@override final  String message;

/// Create a copy of FieldError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldErrorCopyWith<_FieldError> get copyWith => __$FieldErrorCopyWithImpl<_FieldError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldError&&(identical(other.field, field) || other.field == field)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,message);

@override
String toString() {
  return 'FieldError(field: $field, message: $message)';
}


}

/// @nodoc
abstract mixin class _$FieldErrorCopyWith<$Res> implements $FieldErrorCopyWith<$Res> {
  factory _$FieldErrorCopyWith(_FieldError value, $Res Function(_FieldError) _then) = __$FieldErrorCopyWithImpl;
@override @useResult
$Res call({
 String field, String message
});




}
/// @nodoc
class __$FieldErrorCopyWithImpl<$Res>
    implements _$FieldErrorCopyWith<$Res> {
  __$FieldErrorCopyWithImpl(this._self, this._then);

  final _FieldError _self;
  final $Res Function(_FieldError) _then;

/// Create a copy of FieldError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? message = null,}) {
  return _then(_FieldError(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
