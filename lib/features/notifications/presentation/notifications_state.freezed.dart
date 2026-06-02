// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsState {

/// Все загруженные уведомления (накоплены по страницам), порядок backend.
 List<NotificationItem> get items;/// Непрочитанных у пользователя (из `NotificationsResponse.unreadCount`).
/// Источник badge на Home; при `markRead` уменьшается оптимистично.
 int get unreadCount;/// Размер последней полученной страницы — по нему [hasMore] решает, есть
/// ли смысл тянуть дальше (echo пагинации backend не отдаёт).
 int get lastPageSize;/// Идёт подзагрузка следующей страницы ([loadMore]). Первичная загрузка
/// выражается через `AsyncLoading` снаружи, а не этим флагом.
 bool get isLoadingMore;/// Ошибка последней подзагрузки. Показанный список сохраняется (не уходим в
/// `AsyncError` всего провайдера) — UI рисует строку «не удалось» + retry.
/// `null` — ошибки нет.
 ApiError? get loadMoreError;
/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsStateCopyWith<NotificationsState> get copyWith => _$NotificationsStateCopyWithImpl<NotificationsState>(this as NotificationsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastPageSize, lastPageSize) || other.lastPageSize == lastPageSize)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),unreadCount,lastPageSize,isLoadingMore,loadMoreError);

@override
String toString() {
  return 'NotificationsState(items: $items, unreadCount: $unreadCount, lastPageSize: $lastPageSize, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $NotificationsStateCopyWith<$Res>  {
  factory $NotificationsStateCopyWith(NotificationsState value, $Res Function(NotificationsState) _then) = _$NotificationsStateCopyWithImpl;
@useResult
$Res call({
 List<NotificationItem> items, int unreadCount, int lastPageSize, bool isLoadingMore, ApiError? loadMoreError
});


$ApiErrorCopyWith<$Res>? get loadMoreError;

}
/// @nodoc
class _$NotificationsStateCopyWithImpl<$Res>
    implements $NotificationsStateCopyWith<$Res> {
  _$NotificationsStateCopyWithImpl(this._self, this._then);

  final NotificationsState _self;
  final $Res Function(NotificationsState) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? unreadCount = null,Object? lastPageSize = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationItem>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastPageSize: null == lastPageSize ? _self.lastPageSize : lastPageSize // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}
/// Create a copy of NotificationsState
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


/// Adds pattern-matching-related methods to [NotificationsState].
extension NotificationsStatePatterns on NotificationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationsState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationsState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NotificationItem> items,  int unreadCount,  int lastPageSize,  bool isLoadingMore,  ApiError? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
return $default(_that.items,_that.unreadCount,_that.lastPageSize,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NotificationItem> items,  int unreadCount,  int lastPageSize,  bool isLoadingMore,  ApiError? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _NotificationsState():
return $default(_that.items,_that.unreadCount,_that.lastPageSize,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NotificationItem> items,  int unreadCount,  int lastPageSize,  bool isLoadingMore,  ApiError? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
return $default(_that.items,_that.unreadCount,_that.lastPageSize,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationsState extends NotificationsState {
  const _NotificationsState({required final  List<NotificationItem> items, required this.unreadCount, required this.lastPageSize, this.isLoadingMore = false, this.loadMoreError}): _items = items,super._();
  

/// Все загруженные уведомления (накоплены по страницам), порядок backend.
 final  List<NotificationItem> _items;
/// Все загруженные уведомления (накоплены по страницам), порядок backend.
@override List<NotificationItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Непрочитанных у пользователя (из `NotificationsResponse.unreadCount`).
/// Источник badge на Home; при `markRead` уменьшается оптимистично.
@override final  int unreadCount;
/// Размер последней полученной страницы — по нему [hasMore] решает, есть
/// ли смысл тянуть дальше (echo пагинации backend не отдаёт).
@override final  int lastPageSize;
/// Идёт подзагрузка следующей страницы ([loadMore]). Первичная загрузка
/// выражается через `AsyncLoading` снаружи, а не этим флагом.
@override@JsonKey() final  bool isLoadingMore;
/// Ошибка последней подзагрузки. Показанный список сохраняется (не уходим в
/// `AsyncError` всего провайдера) — UI рисует строку «не удалось» + retry.
/// `null` — ошибки нет.
@override final  ApiError? loadMoreError;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsStateCopyWith<_NotificationsState> get copyWith => __$NotificationsStateCopyWithImpl<_NotificationsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastPageSize, lastPageSize) || other.lastPageSize == lastPageSize)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),unreadCount,lastPageSize,isLoadingMore,loadMoreError);

@override
String toString() {
  return 'NotificationsState(items: $items, unreadCount: $unreadCount, lastPageSize: $lastPageSize, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$NotificationsStateCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory _$NotificationsStateCopyWith(_NotificationsState value, $Res Function(_NotificationsState) _then) = __$NotificationsStateCopyWithImpl;
@override @useResult
$Res call({
 List<NotificationItem> items, int unreadCount, int lastPageSize, bool isLoadingMore, ApiError? loadMoreError
});


@override $ApiErrorCopyWith<$Res>? get loadMoreError;

}
/// @nodoc
class __$NotificationsStateCopyWithImpl<$Res>
    implements _$NotificationsStateCopyWith<$Res> {
  __$NotificationsStateCopyWithImpl(this._self, this._then);

  final _NotificationsState _self;
  final $Res Function(_NotificationsState) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? unreadCount = null,Object? lastPageSize = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_NotificationsState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationItem>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastPageSize: null == lastPageSize ? _self.lastPageSize : lastPageSize // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

/// Create a copy of NotificationsState
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
