// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationFeed {

/// Записи этой страницы, новые сверху (порядок backend).
 List<NotificationItem> get items;/// Количество непрочитанных уведомлений пользователя (по всем страницам).
 int get unreadCount;
/// Create a copy of NotificationFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationFeedCopyWith<NotificationFeed> get copyWith => _$NotificationFeedCopyWithImpl<NotificationFeed>(this as NotificationFeed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationFeed&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),unreadCount);

@override
String toString() {
  return 'NotificationFeed(items: $items, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class $NotificationFeedCopyWith<$Res>  {
  factory $NotificationFeedCopyWith(NotificationFeed value, $Res Function(NotificationFeed) _then) = _$NotificationFeedCopyWithImpl;
@useResult
$Res call({
 List<NotificationItem> items, int unreadCount
});




}
/// @nodoc
class _$NotificationFeedCopyWithImpl<$Res>
    implements $NotificationFeedCopyWith<$Res> {
  _$NotificationFeedCopyWithImpl(this._self, this._then);

  final NotificationFeed _self;
  final $Res Function(NotificationFeed) _then;

/// Create a copy of NotificationFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? unreadCount = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationItem>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationFeed].
extension NotificationFeedPatterns on NotificationFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationFeed value)  $default,){
final _that = this;
switch (_that) {
case _NotificationFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationFeed value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NotificationItem> items,  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationFeed() when $default != null:
return $default(_that.items,_that.unreadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NotificationItem> items,  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _NotificationFeed():
return $default(_that.items,_that.unreadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NotificationItem> items,  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _NotificationFeed() when $default != null:
return $default(_that.items,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationFeed extends NotificationFeed {
  const _NotificationFeed({required final  List<NotificationItem> items, required this.unreadCount}): _items = items,super._();
  

/// Записи этой страницы, новые сверху (порядок backend).
 final  List<NotificationItem> _items;
/// Записи этой страницы, новые сверху (порядок backend).
@override List<NotificationItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Количество непрочитанных уведомлений пользователя (по всем страницам).
@override final  int unreadCount;

/// Create a copy of NotificationFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationFeedCopyWith<_NotificationFeed> get copyWith => __$NotificationFeedCopyWithImpl<_NotificationFeed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationFeed&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),unreadCount);

@override
String toString() {
  return 'NotificationFeed(items: $items, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$NotificationFeedCopyWith<$Res> implements $NotificationFeedCopyWith<$Res> {
  factory _$NotificationFeedCopyWith(_NotificationFeed value, $Res Function(_NotificationFeed) _then) = __$NotificationFeedCopyWithImpl;
@override @useResult
$Res call({
 List<NotificationItem> items, int unreadCount
});




}
/// @nodoc
class __$NotificationFeedCopyWithImpl<$Res>
    implements _$NotificationFeedCopyWith<$Res> {
  __$NotificationFeedCopyWithImpl(this._self, this._then);

  final _NotificationFeed _self;
  final $Res Function(_NotificationFeed) _then;

/// Create a copy of NotificationFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? unreadCount = null,}) {
  return _then(_NotificationFeed(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationItem>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
