// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sdui_screen_layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SduiScreenLayout {

 String get screenId; int get version; List<SduiBlock> get blocks;
/// Create a copy of SduiScreenLayout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SduiScreenLayoutCopyWith<SduiScreenLayout> get copyWith => _$SduiScreenLayoutCopyWithImpl<SduiScreenLayout>(this as SduiScreenLayout, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SduiScreenLayout&&(identical(other.screenId, screenId) || other.screenId == screenId)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.blocks, blocks));
}


@override
int get hashCode => Object.hash(runtimeType,screenId,version,const DeepCollectionEquality().hash(blocks));

@override
String toString() {
  return 'SduiScreenLayout(screenId: $screenId, version: $version, blocks: $blocks)';
}


}

/// @nodoc
abstract mixin class $SduiScreenLayoutCopyWith<$Res>  {
  factory $SduiScreenLayoutCopyWith(SduiScreenLayout value, $Res Function(SduiScreenLayout) _then) = _$SduiScreenLayoutCopyWithImpl;
@useResult
$Res call({
 String screenId, int version, List<SduiBlock> blocks
});




}
/// @nodoc
class _$SduiScreenLayoutCopyWithImpl<$Res>
    implements $SduiScreenLayoutCopyWith<$Res> {
  _$SduiScreenLayoutCopyWithImpl(this._self, this._then);

  final SduiScreenLayout _self;
  final $Res Function(SduiScreenLayout) _then;

/// Create a copy of SduiScreenLayout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? screenId = null,Object? version = null,Object? blocks = null,}) {
  return _then(_self.copyWith(
screenId: null == screenId ? _self.screenId : screenId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,blocks: null == blocks ? _self.blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<SduiBlock>,
  ));
}

}


/// Adds pattern-matching-related methods to [SduiScreenLayout].
extension SduiScreenLayoutPatterns on SduiScreenLayout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SduiScreenLayout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SduiScreenLayout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SduiScreenLayout value)  $default,){
final _that = this;
switch (_that) {
case _SduiScreenLayout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SduiScreenLayout value)?  $default,){
final _that = this;
switch (_that) {
case _SduiScreenLayout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String screenId,  int version,  List<SduiBlock> blocks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SduiScreenLayout() when $default != null:
return $default(_that.screenId,_that.version,_that.blocks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String screenId,  int version,  List<SduiBlock> blocks)  $default,) {final _that = this;
switch (_that) {
case _SduiScreenLayout():
return $default(_that.screenId,_that.version,_that.blocks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String screenId,  int version,  List<SduiBlock> blocks)?  $default,) {final _that = this;
switch (_that) {
case _SduiScreenLayout() when $default != null:
return $default(_that.screenId,_that.version,_that.blocks);case _:
  return null;

}
}

}

/// @nodoc


class _SduiScreenLayout implements SduiScreenLayout {
  const _SduiScreenLayout({required this.screenId, required this.version, required final  List<SduiBlock> blocks}): _blocks = blocks;
  

@override final  String screenId;
@override final  int version;
 final  List<SduiBlock> _blocks;
@override List<SduiBlock> get blocks {
  if (_blocks is EqualUnmodifiableListView) return _blocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blocks);
}


/// Create a copy of SduiScreenLayout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SduiScreenLayoutCopyWith<_SduiScreenLayout> get copyWith => __$SduiScreenLayoutCopyWithImpl<_SduiScreenLayout>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SduiScreenLayout&&(identical(other.screenId, screenId) || other.screenId == screenId)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._blocks, _blocks));
}


@override
int get hashCode => Object.hash(runtimeType,screenId,version,const DeepCollectionEquality().hash(_blocks));

@override
String toString() {
  return 'SduiScreenLayout(screenId: $screenId, version: $version, blocks: $blocks)';
}


}

/// @nodoc
abstract mixin class _$SduiScreenLayoutCopyWith<$Res> implements $SduiScreenLayoutCopyWith<$Res> {
  factory _$SduiScreenLayoutCopyWith(_SduiScreenLayout value, $Res Function(_SduiScreenLayout) _then) = __$SduiScreenLayoutCopyWithImpl;
@override @useResult
$Res call({
 String screenId, int version, List<SduiBlock> blocks
});




}
/// @nodoc
class __$SduiScreenLayoutCopyWithImpl<$Res>
    implements _$SduiScreenLayoutCopyWith<$Res> {
  __$SduiScreenLayoutCopyWithImpl(this._self, this._then);

  final _SduiScreenLayout _self;
  final $Res Function(_SduiScreenLayout) _then;

/// Create a copy of SduiScreenLayout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? screenId = null,Object? version = null,Object? blocks = null,}) {
  return _then(_SduiScreenLayout(
screenId: null == screenId ? _self.screenId : screenId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,blocks: null == blocks ? _self._blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<SduiBlock>,
  ));
}


}

// dart format on
