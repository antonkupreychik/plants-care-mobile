// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_card_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantCardHistoryState {

/// Все загруженные записи (накоплены по страницам), порядок backend.
 List<CareHistoryEntry> get items;/// Всего активных записей истории (из `PlantHistoryResponse.total`).
 int get total;/// Сдвиг для СЛЕДУЮЩЕЙ страницы (= числу уже загруженных записей).
 int get offset;/// Идёт подзагрузка следующей страницы ([loadMore]). Первичная загрузка
/// выражается через `AsyncLoading` снаружи, а не этим флагом.
 bool get isLoadingMore;/// Ошибка последней подзагрузки страницы. Показанный список при этом
/// сохраняется (не уходим в `AsyncError` всего провайдера) — UI рисует
/// строку «не удалось дозагрузить» + retry. `null` — ошибки нет.
 ApiError? get loadMoreError;
/// Create a copy of PlantCardHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantCardHistoryStateCopyWith<PlantCardHistoryState> get copyWith => _$PlantCardHistoryStateCopyWithImpl<PlantCardHistoryState>(this as PlantCardHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantCardHistoryState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,offset,isLoadingMore,loadMoreError);

@override
String toString() {
  return 'PlantCardHistoryState(items: $items, total: $total, offset: $offset, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $PlantCardHistoryStateCopyWith<$Res>  {
  factory $PlantCardHistoryStateCopyWith(PlantCardHistoryState value, $Res Function(PlantCardHistoryState) _then) = _$PlantCardHistoryStateCopyWithImpl;
@useResult
$Res call({
 List<CareHistoryEntry> items, int total, int offset, bool isLoadingMore, ApiError? loadMoreError
});


$ApiErrorCopyWith<$Res>? get loadMoreError;

}
/// @nodoc
class _$PlantCardHistoryStateCopyWithImpl<$Res>
    implements $PlantCardHistoryStateCopyWith<$Res> {
  _$PlantCardHistoryStateCopyWithImpl(this._self, this._then);

  final PlantCardHistoryState _self;
  final $Res Function(PlantCardHistoryState) _then;

/// Create a copy of PlantCardHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? offset = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CareHistoryEntry>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of PlantCardHistoryState
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


/// Adds pattern-matching-related methods to [PlantCardHistoryState].
extension PlantCardHistoryStatePatterns on PlantCardHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantCardHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantCardHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantCardHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _PlantCardHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantCardHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _PlantCardHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CareHistoryEntry> items,  int total,  int offset,  bool isLoadingMore,  ApiError? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantCardHistoryState() when $default != null:
return $default(_that.items,_that.total,_that.offset,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CareHistoryEntry> items,  int total,  int offset,  bool isLoadingMore,  ApiError? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _PlantCardHistoryState():
return $default(_that.items,_that.total,_that.offset,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CareHistoryEntry> items,  int total,  int offset,  bool isLoadingMore,  ApiError? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _PlantCardHistoryState() when $default != null:
return $default(_that.items,_that.total,_that.offset,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _PlantCardHistoryState extends PlantCardHistoryState {
  const _PlantCardHistoryState({required final  List<CareHistoryEntry> items, required this.total, required this.offset, this.isLoadingMore = false, this.loadMoreError}): _items = items,super._();
  

/// Все загруженные записи (накоплены по страницам), порядок backend.
 final  List<CareHistoryEntry> _items;
/// Все загруженные записи (накоплены по страницам), порядок backend.
@override List<CareHistoryEntry> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Всего активных записей истории (из `PlantHistoryResponse.total`).
@override final  int total;
/// Сдвиг для СЛЕДУЮЩЕЙ страницы (= числу уже загруженных записей).
@override final  int offset;
/// Идёт подзагрузка следующей страницы ([loadMore]). Первичная загрузка
/// выражается через `AsyncLoading` снаружи, а не этим флагом.
@override@JsonKey() final  bool isLoadingMore;
/// Ошибка последней подзагрузки страницы. Показанный список при этом
/// сохраняется (не уходим в `AsyncError` всего провайдера) — UI рисует
/// строку «не удалось дозагрузить» + retry. `null` — ошибки нет.
@override final  ApiError? loadMoreError;

/// Create a copy of PlantCardHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantCardHistoryStateCopyWith<_PlantCardHistoryState> get copyWith => __$PlantCardHistoryStateCopyWithImpl<_PlantCardHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantCardHistoryState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,offset,isLoadingMore,loadMoreError);

@override
String toString() {
  return 'PlantCardHistoryState(items: $items, total: $total, offset: $offset, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$PlantCardHistoryStateCopyWith<$Res> implements $PlantCardHistoryStateCopyWith<$Res> {
  factory _$PlantCardHistoryStateCopyWith(_PlantCardHistoryState value, $Res Function(_PlantCardHistoryState) _then) = __$PlantCardHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<CareHistoryEntry> items, int total, int offset, bool isLoadingMore, ApiError? loadMoreError
});


@override $ApiErrorCopyWith<$Res>? get loadMoreError;

}
/// @nodoc
class __$PlantCardHistoryStateCopyWithImpl<$Res>
    implements _$PlantCardHistoryStateCopyWith<$Res> {
  __$PlantCardHistoryStateCopyWithImpl(this._self, this._then);

  final _PlantCardHistoryState _self;
  final $Res Function(_PlantCardHistoryState) _then;

/// Create a copy of PlantCardHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? offset = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_PlantCardHistoryState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CareHistoryEntry>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of PlantCardHistoryState
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
