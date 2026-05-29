// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareHistoryState {

/// Все загруженные записи (накоплены по страницам), порядок backend.
 List<CareHistoryEntry> get entries;/// Всего активных записей истории (из `PlantHistoryResponse.total`).
 int get total;/// Сдвиг для СЛЕДУЮЩЕЙ страницы (= числу уже загруженных записей).
 int get offset;/// Идёт подзагрузка следующей страницы ([loadMore]). Первичная загрузка
/// выражается через `AsyncLoading` снаружи, а не этим флагом.
 bool get isLoadingMore;/// Ошибка последней подзагрузки страницы. Показанный список при этом
/// сохраняется (не уходим в `AsyncError` всего провайдера) — UI рисует
/// строку «не удалось дозагрузить» + retry. `null` — ошибки нет.
 ApiError? get loadMoreError;/// Активный фильтр по типу ухода (клиентский). `null` — без фильтра.
 CareEventKind? get filter;
/// Create a copy of CareHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareHistoryStateCopyWith<CareHistoryState> get copyWith => _$CareHistoryStateCopyWithImpl<CareHistoryState>(this as CareHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareHistoryState&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.total, total) || other.total == total)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError)&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entries),total,offset,isLoadingMore,loadMoreError,filter);

@override
String toString() {
  return 'CareHistoryState(entries: $entries, total: $total, offset: $offset, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError, filter: $filter)';
}


}

/// @nodoc
abstract mixin class $CareHistoryStateCopyWith<$Res>  {
  factory $CareHistoryStateCopyWith(CareHistoryState value, $Res Function(CareHistoryState) _then) = _$CareHistoryStateCopyWithImpl;
@useResult
$Res call({
 List<CareHistoryEntry> entries, int total, int offset, bool isLoadingMore, ApiError? loadMoreError, CareEventKind? filter
});


$ApiErrorCopyWith<$Res>? get loadMoreError;

}
/// @nodoc
class _$CareHistoryStateCopyWithImpl<$Res>
    implements $CareHistoryStateCopyWith<$Res> {
  _$CareHistoryStateCopyWithImpl(this._self, this._then);

  final CareHistoryState _self;
  final $Res Function(CareHistoryState) _then;

/// Create a copy of CareHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? total = null,Object? offset = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,Object? filter = freezed,}) {
  return _then(_self.copyWith(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<CareHistoryEntry>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as ApiError?,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as CareEventKind?,
  ));
}
/// Create a copy of CareHistoryState
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


/// Adds pattern-matching-related methods to [CareHistoryState].
extension CareHistoryStatePatterns on CareHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _CareHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _CareHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CareHistoryEntry> entries,  int total,  int offset,  bool isLoadingMore,  ApiError? loadMoreError,  CareEventKind? filter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareHistoryState() when $default != null:
return $default(_that.entries,_that.total,_that.offset,_that.isLoadingMore,_that.loadMoreError,_that.filter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CareHistoryEntry> entries,  int total,  int offset,  bool isLoadingMore,  ApiError? loadMoreError,  CareEventKind? filter)  $default,) {final _that = this;
switch (_that) {
case _CareHistoryState():
return $default(_that.entries,_that.total,_that.offset,_that.isLoadingMore,_that.loadMoreError,_that.filter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CareHistoryEntry> entries,  int total,  int offset,  bool isLoadingMore,  ApiError? loadMoreError,  CareEventKind? filter)?  $default,) {final _that = this;
switch (_that) {
case _CareHistoryState() when $default != null:
return $default(_that.entries,_that.total,_that.offset,_that.isLoadingMore,_that.loadMoreError,_that.filter);case _:
  return null;

}
}

}

/// @nodoc


class _CareHistoryState extends CareHistoryState {
  const _CareHistoryState({required final  List<CareHistoryEntry> entries, required this.total, required this.offset, this.isLoadingMore = false, this.loadMoreError, this.filter}): _entries = entries,super._();
  

/// Все загруженные записи (накоплены по страницам), порядок backend.
 final  List<CareHistoryEntry> _entries;
/// Все загруженные записи (накоплены по страницам), порядок backend.
@override List<CareHistoryEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
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
/// Активный фильтр по типу ухода (клиентский). `null` — без фильтра.
@override final  CareEventKind? filter;

/// Create a copy of CareHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareHistoryStateCopyWith<_CareHistoryState> get copyWith => __$CareHistoryStateCopyWithImpl<_CareHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareHistoryState&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.total, total) || other.total == total)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError)&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),total,offset,isLoadingMore,loadMoreError,filter);

@override
String toString() {
  return 'CareHistoryState(entries: $entries, total: $total, offset: $offset, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError, filter: $filter)';
}


}

/// @nodoc
abstract mixin class _$CareHistoryStateCopyWith<$Res> implements $CareHistoryStateCopyWith<$Res> {
  factory _$CareHistoryStateCopyWith(_CareHistoryState value, $Res Function(_CareHistoryState) _then) = __$CareHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<CareHistoryEntry> entries, int total, int offset, bool isLoadingMore, ApiError? loadMoreError, CareEventKind? filter
});


@override $ApiErrorCopyWith<$Res>? get loadMoreError;

}
/// @nodoc
class __$CareHistoryStateCopyWithImpl<$Res>
    implements _$CareHistoryStateCopyWith<$Res> {
  __$CareHistoryStateCopyWithImpl(this._self, this._then);

  final _CareHistoryState _self;
  final $Res Function(_CareHistoryState) _then;

/// Create a copy of CareHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? total = null,Object? offset = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,Object? filter = freezed,}) {
  return _then(_CareHistoryState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<CareHistoryEntry>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as ApiError?,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as CareEventKind?,
  ));
}

/// Create a copy of CareHistoryState
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
