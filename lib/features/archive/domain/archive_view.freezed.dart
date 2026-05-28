// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArchiveView {

/// Архивные растения в порядке показа (как пришли с backend).
 List<ArchivedPlant> get plants;/// Сводка «Ретроспектива». `null`, если архив пуст (нечего обобщать).
 ArchiveRetrospective? get retrospective;
/// Create a copy of ArchiveView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveViewCopyWith<ArchiveView> get copyWith => _$ArchiveViewCopyWithImpl<ArchiveView>(this as ArchiveView, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveView&&const DeepCollectionEquality().equals(other.plants, plants)&&(identical(other.retrospective, retrospective) || other.retrospective == retrospective));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(plants),retrospective);

@override
String toString() {
  return 'ArchiveView(plants: $plants, retrospective: $retrospective)';
}


}

/// @nodoc
abstract mixin class $ArchiveViewCopyWith<$Res>  {
  factory $ArchiveViewCopyWith(ArchiveView value, $Res Function(ArchiveView) _then) = _$ArchiveViewCopyWithImpl;
@useResult
$Res call({
 List<ArchivedPlant> plants, ArchiveRetrospective? retrospective
});


$ArchiveRetrospectiveCopyWith<$Res>? get retrospective;

}
/// @nodoc
class _$ArchiveViewCopyWithImpl<$Res>
    implements $ArchiveViewCopyWith<$Res> {
  _$ArchiveViewCopyWithImpl(this._self, this._then);

  final ArchiveView _self;
  final $Res Function(ArchiveView) _then;

/// Create a copy of ArchiveView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plants = null,Object? retrospective = freezed,}) {
  return _then(_self.copyWith(
plants: null == plants ? _self.plants : plants // ignore: cast_nullable_to_non_nullable
as List<ArchivedPlant>,retrospective: freezed == retrospective ? _self.retrospective : retrospective // ignore: cast_nullable_to_non_nullable
as ArchiveRetrospective?,
  ));
}
/// Create a copy of ArchiveView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArchiveRetrospectiveCopyWith<$Res>? get retrospective {
    if (_self.retrospective == null) {
    return null;
  }

  return $ArchiveRetrospectiveCopyWith<$Res>(_self.retrospective!, (value) {
    return _then(_self.copyWith(retrospective: value));
  });
}
}


/// Adds pattern-matching-related methods to [ArchiveView].
extension ArchiveViewPatterns on ArchiveView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveView value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveView value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ArchivedPlant> plants,  ArchiveRetrospective? retrospective)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveView() when $default != null:
return $default(_that.plants,_that.retrospective);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ArchivedPlant> plants,  ArchiveRetrospective? retrospective)  $default,) {final _that = this;
switch (_that) {
case _ArchiveView():
return $default(_that.plants,_that.retrospective);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ArchivedPlant> plants,  ArchiveRetrospective? retrospective)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveView() when $default != null:
return $default(_that.plants,_that.retrospective);case _:
  return null;

}
}

}

/// @nodoc


class _ArchiveView implements ArchiveView {
  const _ArchiveView({required final  List<ArchivedPlant> plants, this.retrospective}): _plants = plants;
  

/// Архивные растения в порядке показа (как пришли с backend).
 final  List<ArchivedPlant> _plants;
/// Архивные растения в порядке показа (как пришли с backend).
@override List<ArchivedPlant> get plants {
  if (_plants is EqualUnmodifiableListView) return _plants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plants);
}

/// Сводка «Ретроспектива». `null`, если архив пуст (нечего обобщать).
@override final  ArchiveRetrospective? retrospective;

/// Create a copy of ArchiveView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveViewCopyWith<_ArchiveView> get copyWith => __$ArchiveViewCopyWithImpl<_ArchiveView>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveView&&const DeepCollectionEquality().equals(other._plants, _plants)&&(identical(other.retrospective, retrospective) || other.retrospective == retrospective));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_plants),retrospective);

@override
String toString() {
  return 'ArchiveView(plants: $plants, retrospective: $retrospective)';
}


}

/// @nodoc
abstract mixin class _$ArchiveViewCopyWith<$Res> implements $ArchiveViewCopyWith<$Res> {
  factory _$ArchiveViewCopyWith(_ArchiveView value, $Res Function(_ArchiveView) _then) = __$ArchiveViewCopyWithImpl;
@override @useResult
$Res call({
 List<ArchivedPlant> plants, ArchiveRetrospective? retrospective
});


@override $ArchiveRetrospectiveCopyWith<$Res>? get retrospective;

}
/// @nodoc
class __$ArchiveViewCopyWithImpl<$Res>
    implements _$ArchiveViewCopyWith<$Res> {
  __$ArchiveViewCopyWithImpl(this._self, this._then);

  final _ArchiveView _self;
  final $Res Function(_ArchiveView) _then;

/// Create a copy of ArchiveView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plants = null,Object? retrospective = freezed,}) {
  return _then(_ArchiveView(
plants: null == plants ? _self._plants : plants // ignore: cast_nullable_to_non_nullable
as List<ArchivedPlant>,retrospective: freezed == retrospective ? _self.retrospective : retrospective // ignore: cast_nullable_to_non_nullable
as ArchiveRetrospective?,
  ));
}

/// Create a copy of ArchiveView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArchiveRetrospectiveCopyWith<$Res>? get retrospective {
    if (_self.retrospective == null) {
    return null;
  }

  return $ArchiveRetrospectiveCopyWith<$Res>(_self.retrospective!, (value) {
    return _then(_self.copyWith(retrospective: value));
  });
}
}

/// @nodoc
mixin _$ArchiveRetrospective {

 String get averageLivedLabel;
/// Create a copy of ArchiveRetrospective
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveRetrospectiveCopyWith<ArchiveRetrospective> get copyWith => _$ArchiveRetrospectiveCopyWithImpl<ArchiveRetrospective>(this as ArchiveRetrospective, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveRetrospective&&(identical(other.averageLivedLabel, averageLivedLabel) || other.averageLivedLabel == averageLivedLabel));
}


@override
int get hashCode => Object.hash(runtimeType,averageLivedLabel);

@override
String toString() {
  return 'ArchiveRetrospective(averageLivedLabel: $averageLivedLabel)';
}


}

/// @nodoc
abstract mixin class $ArchiveRetrospectiveCopyWith<$Res>  {
  factory $ArchiveRetrospectiveCopyWith(ArchiveRetrospective value, $Res Function(ArchiveRetrospective) _then) = _$ArchiveRetrospectiveCopyWithImpl;
@useResult
$Res call({
 String averageLivedLabel
});




}
/// @nodoc
class _$ArchiveRetrospectiveCopyWithImpl<$Res>
    implements $ArchiveRetrospectiveCopyWith<$Res> {
  _$ArchiveRetrospectiveCopyWithImpl(this._self, this._then);

  final ArchiveRetrospective _self;
  final $Res Function(ArchiveRetrospective) _then;

/// Create a copy of ArchiveRetrospective
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? averageLivedLabel = null,}) {
  return _then(_self.copyWith(
averageLivedLabel: null == averageLivedLabel ? _self.averageLivedLabel : averageLivedLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveRetrospective].
extension ArchiveRetrospectivePatterns on ArchiveRetrospective {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveRetrospective value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveRetrospective() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveRetrospective value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveRetrospective():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveRetrospective value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveRetrospective() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String averageLivedLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveRetrospective() when $default != null:
return $default(_that.averageLivedLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String averageLivedLabel)  $default,) {final _that = this;
switch (_that) {
case _ArchiveRetrospective():
return $default(_that.averageLivedLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String averageLivedLabel)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveRetrospective() when $default != null:
return $default(_that.averageLivedLabel);case _:
  return null;

}
}

}

/// @nodoc


class _ArchiveRetrospective implements ArchiveRetrospective {
  const _ArchiveRetrospective({required this.averageLivedLabel});
  

@override final  String averageLivedLabel;

/// Create a copy of ArchiveRetrospective
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveRetrospectiveCopyWith<_ArchiveRetrospective> get copyWith => __$ArchiveRetrospectiveCopyWithImpl<_ArchiveRetrospective>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveRetrospective&&(identical(other.averageLivedLabel, averageLivedLabel) || other.averageLivedLabel == averageLivedLabel));
}


@override
int get hashCode => Object.hash(runtimeType,averageLivedLabel);

@override
String toString() {
  return 'ArchiveRetrospective(averageLivedLabel: $averageLivedLabel)';
}


}

/// @nodoc
abstract mixin class _$ArchiveRetrospectiveCopyWith<$Res> implements $ArchiveRetrospectiveCopyWith<$Res> {
  factory _$ArchiveRetrospectiveCopyWith(_ArchiveRetrospective value, $Res Function(_ArchiveRetrospective) _then) = __$ArchiveRetrospectiveCopyWithImpl;
@override @useResult
$Res call({
 String averageLivedLabel
});




}
/// @nodoc
class __$ArchiveRetrospectiveCopyWithImpl<$Res>
    implements _$ArchiveRetrospectiveCopyWith<$Res> {
  __$ArchiveRetrospectiveCopyWithImpl(this._self, this._then);

  final _ArchiveRetrospective _self;
  final $Res Function(_ArchiveRetrospective) _then;

/// Create a copy of ArchiveRetrospective
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? averageLivedLabel = null,}) {
  return _then(_ArchiveRetrospective(
averageLivedLabel: null == averageLivedLabel ? _self.averageLivedLabel : averageLivedLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
