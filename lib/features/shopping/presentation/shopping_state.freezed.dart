// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShoppingState {

/// Все позиции списка, порядок backend (некупленные сверху).
 List<ShoppingItem> get items;/// Идёт мутация (add/toggle/delete). UI может блокировать повторные тапы
/// или показывать индикатор. Оптимистичные изменения уже отражены в
/// [items], этот флаг — про «летит» ли запрос.
 bool get isMutating;
/// Create a copy of ShoppingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingStateCopyWith<ShoppingState> get copyWith => _$ShoppingStateCopyWithImpl<ShoppingState>(this as ShoppingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.isMutating, isMutating) || other.isMutating == isMutating));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),isMutating);

@override
String toString() {
  return 'ShoppingState(items: $items, isMutating: $isMutating)';
}


}

/// @nodoc
abstract mixin class $ShoppingStateCopyWith<$Res>  {
  factory $ShoppingStateCopyWith(ShoppingState value, $Res Function(ShoppingState) _then) = _$ShoppingStateCopyWithImpl;
@useResult
$Res call({
 List<ShoppingItem> items, bool isMutating
});




}
/// @nodoc
class _$ShoppingStateCopyWithImpl<$Res>
    implements $ShoppingStateCopyWith<$Res> {
  _$ShoppingStateCopyWithImpl(this._self, this._then);

  final ShoppingState _self;
  final $Res Function(ShoppingState) _then;

/// Create a copy of ShoppingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? isMutating = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ShoppingItem>,isMutating: null == isMutating ? _self.isMutating : isMutating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShoppingState].
extension ShoppingStatePatterns on ShoppingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingState value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingState value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ShoppingItem> items,  bool isMutating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingState() when $default != null:
return $default(_that.items,_that.isMutating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ShoppingItem> items,  bool isMutating)  $default,) {final _that = this;
switch (_that) {
case _ShoppingState():
return $default(_that.items,_that.isMutating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ShoppingItem> items,  bool isMutating)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingState() when $default != null:
return $default(_that.items,_that.isMutating);case _:
  return null;

}
}

}

/// @nodoc


class _ShoppingState extends ShoppingState {
  const _ShoppingState({required final  List<ShoppingItem> items, this.isMutating = false}): _items = items,super._();
  

/// Все позиции списка, порядок backend (некупленные сверху).
 final  List<ShoppingItem> _items;
/// Все позиции списка, порядок backend (некупленные сверху).
@override List<ShoppingItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Идёт мутация (add/toggle/delete). UI может блокировать повторные тапы
/// или показывать индикатор. Оптимистичные изменения уже отражены в
/// [items], этот флаг — про «летит» ли запрос.
@override@JsonKey() final  bool isMutating;

/// Create a copy of ShoppingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingStateCopyWith<_ShoppingState> get copyWith => __$ShoppingStateCopyWithImpl<_ShoppingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isMutating, isMutating) || other.isMutating == isMutating));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isMutating);

@override
String toString() {
  return 'ShoppingState(items: $items, isMutating: $isMutating)';
}


}

/// @nodoc
abstract mixin class _$ShoppingStateCopyWith<$Res> implements $ShoppingStateCopyWith<$Res> {
  factory _$ShoppingStateCopyWith(_ShoppingState value, $Res Function(_ShoppingState) _then) = __$ShoppingStateCopyWithImpl;
@override @useResult
$Res call({
 List<ShoppingItem> items, bool isMutating
});




}
/// @nodoc
class __$ShoppingStateCopyWithImpl<$Res>
    implements _$ShoppingStateCopyWith<$Res> {
  __$ShoppingStateCopyWithImpl(this._self, this._then);

  final _ShoppingState _self;
  final $Res Function(_ShoppingState) _then;

/// Create a copy of ShoppingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isMutating = null,}) {
  return _then(_ShoppingState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ShoppingItem>,isMutating: null == isMutating ? _self.isMutating : isMutating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
