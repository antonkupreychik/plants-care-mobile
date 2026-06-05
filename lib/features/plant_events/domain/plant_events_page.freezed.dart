// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_events_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantEventsPage {

/// События этой страницы, в порядке backend (новые сверху).
 List<PlantEvent> get items;/// Общее количество событий журнала (по всем страницам).
 int get total;/// Размер запрошенной страницы (echo из ответа).
 int get limit;/// Сдвиг этой страницы от начала журнала (echo из ответа).
 int get offset;
/// Create a copy of PlantEventsPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantEventsPageCopyWith<PlantEventsPage> get copyWith => _$PlantEventsPageCopyWithImpl<PlantEventsPage>(this as PlantEventsPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantEventsPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,limit,offset);

@override
String toString() {
  return 'PlantEventsPage(items: $items, total: $total, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $PlantEventsPageCopyWith<$Res>  {
  factory $PlantEventsPageCopyWith(PlantEventsPage value, $Res Function(PlantEventsPage) _then) = _$PlantEventsPageCopyWithImpl;
@useResult
$Res call({
 List<PlantEvent> items, int total, int limit, int offset
});




}
/// @nodoc
class _$PlantEventsPageCopyWithImpl<$Res>
    implements $PlantEventsPageCopyWith<$Res> {
  _$PlantEventsPageCopyWithImpl(this._self, this._then);

  final PlantEventsPage _self;
  final $Res Function(PlantEventsPage) _then;

/// Create a copy of PlantEventsPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? limit = null,Object? offset = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PlantEvent>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantEventsPage].
extension PlantEventsPagePatterns on PlantEventsPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantEventsPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantEventsPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantEventsPage value)  $default,){
final _that = this;
switch (_that) {
case _PlantEventsPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantEventsPage value)?  $default,){
final _that = this;
switch (_that) {
case _PlantEventsPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PlantEvent> items,  int total,  int limit,  int offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantEventsPage() when $default != null:
return $default(_that.items,_that.total,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PlantEvent> items,  int total,  int limit,  int offset)  $default,) {final _that = this;
switch (_that) {
case _PlantEventsPage():
return $default(_that.items,_that.total,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PlantEvent> items,  int total,  int limit,  int offset)?  $default,) {final _that = this;
switch (_that) {
case _PlantEventsPage() when $default != null:
return $default(_that.items,_that.total,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc


class _PlantEventsPage extends PlantEventsPage {
  const _PlantEventsPage({required final  List<PlantEvent> items, required this.total, required this.limit, required this.offset}): _items = items,super._();
  

/// События этой страницы, в порядке backend (новые сверху).
 final  List<PlantEvent> _items;
/// События этой страницы, в порядке backend (новые сверху).
@override List<PlantEvent> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Общее количество событий журнала (по всем страницам).
@override final  int total;
/// Размер запрошенной страницы (echo из ответа).
@override final  int limit;
/// Сдвиг этой страницы от начала журнала (echo из ответа).
@override final  int offset;

/// Create a copy of PlantEventsPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantEventsPageCopyWith<_PlantEventsPage> get copyWith => __$PlantEventsPageCopyWithImpl<_PlantEventsPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantEventsPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,limit,offset);

@override
String toString() {
  return 'PlantEventsPage(items: $items, total: $total, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$PlantEventsPageCopyWith<$Res> implements $PlantEventsPageCopyWith<$Res> {
  factory _$PlantEventsPageCopyWith(_PlantEventsPage value, $Res Function(_PlantEventsPage) _then) = __$PlantEventsPageCopyWithImpl;
@override @useResult
$Res call({
 List<PlantEvent> items, int total, int limit, int offset
});




}
/// @nodoc
class __$PlantEventsPageCopyWithImpl<$Res>
    implements _$PlantEventsPageCopyWith<$Res> {
  __$PlantEventsPageCopyWithImpl(this._self, this._then);

  final _PlantEventsPage _self;
  final $Res Function(_PlantEventsPage) _then;

/// Create a copy of PlantEventsPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? limit = null,Object? offset = null,}) {
  return _then(_PlantEventsPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PlantEvent>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
