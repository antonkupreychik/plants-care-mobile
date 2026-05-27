// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeciesListState {

 List<Species> get items;/// Всего видов под текущим фильтром `q` (для расчёта [hasMore]).
 int get total;/// Идёт дозагрузка следующей страницы (показанный список остаётся).
 bool get isLoadingMore;/// Ошибка последней попытки `loadMore` (первичная загрузка — в `AsyncError`).
 ApiError? get loadMoreError;
/// Create a copy of SpeciesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeciesListStateCopyWith<SpeciesListState> get copyWith => _$SpeciesListStateCopyWithImpl<SpeciesListState>(this as SpeciesListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeciesListState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,isLoadingMore,loadMoreError);

@override
String toString() {
  return 'SpeciesListState(items: $items, total: $total, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $SpeciesListStateCopyWith<$Res>  {
  factory $SpeciesListStateCopyWith(SpeciesListState value, $Res Function(SpeciesListState) _then) = _$SpeciesListStateCopyWithImpl;
@useResult
$Res call({
 List<Species> items, int total, bool isLoadingMore, ApiError? loadMoreError
});


$ApiErrorCopyWith<$Res>? get loadMoreError;

}
/// @nodoc
class _$SpeciesListStateCopyWithImpl<$Res>
    implements $SpeciesListStateCopyWith<$Res> {
  _$SpeciesListStateCopyWithImpl(this._self, this._then);

  final SpeciesListState _self;
  final $Res Function(SpeciesListState) _then;

/// Create a copy of SpeciesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Species>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of SpeciesListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get loadMoreError {
    if (_self.loadMoreError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.loadMoreError!, (value) {
    return _then(_self.copyWith(loadMoreError: value));
  });
}
}


/// Adds pattern-matching-related methods to [SpeciesListState].
extension SpeciesListStatePatterns on SpeciesListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeciesListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeciesListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeciesListState value)  $default,){
final _that = this;
switch (_that) {
case _SpeciesListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeciesListState value)?  $default,){
final _that = this;
switch (_that) {
case _SpeciesListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Species> items,  int total,  bool isLoadingMore,  ApiError? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeciesListState() when $default != null:
return $default(_that.items,_that.total,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Species> items,  int total,  bool isLoadingMore,  ApiError? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _SpeciesListState():
return $default(_that.items,_that.total,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Species> items,  int total,  bool isLoadingMore,  ApiError? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _SpeciesListState() when $default != null:
return $default(_that.items,_that.total,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _SpeciesListState extends SpeciesListState {
  const _SpeciesListState({required final  List<Species> items, required this.total, this.isLoadingMore = false, this.loadMoreError}): _items = items,super._();
  

 final  List<Species> _items;
@override List<Species> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Всего видов под текущим фильтром `q` (для расчёта [hasMore]).
@override final  int total;
/// Идёт дозагрузка следующей страницы (показанный список остаётся).
@override@JsonKey() final  bool isLoadingMore;
/// Ошибка последней попытки `loadMore` (первичная загрузка — в `AsyncError`).
@override final  ApiError? loadMoreError;

/// Create a copy of SpeciesListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeciesListStateCopyWith<_SpeciesListState> get copyWith => __$SpeciesListStateCopyWithImpl<_SpeciesListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeciesListState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,isLoadingMore,loadMoreError);

@override
String toString() {
  return 'SpeciesListState(items: $items, total: $total, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$SpeciesListStateCopyWith<$Res> implements $SpeciesListStateCopyWith<$Res> {
  factory _$SpeciesListStateCopyWith(_SpeciesListState value, $Res Function(_SpeciesListState) _then) = __$SpeciesListStateCopyWithImpl;
@override @useResult
$Res call({
 List<Species> items, int total, bool isLoadingMore, ApiError? loadMoreError
});


@override $ApiErrorCopyWith<$Res>? get loadMoreError;

}
/// @nodoc
class __$SpeciesListStateCopyWithImpl<$Res>
    implements _$SpeciesListStateCopyWith<$Res> {
  __$SpeciesListStateCopyWithImpl(this._self, this._then);

  final _SpeciesListState _self;
  final $Res Function(_SpeciesListState) _then;

/// Create a copy of SpeciesListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_SpeciesListState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Species>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of SpeciesListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<$Res>? get loadMoreError {
    if (_self.loadMoreError == null) {
    return null;
  }

  return $ApiErrorCopyWith<$Res>(_self.loadMoreError!, (value) {
    return _then(_self.copyWith(loadMoreError: value));
  });
}
}

// dart format on
