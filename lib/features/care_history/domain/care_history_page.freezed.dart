// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_history_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareHistoryPage {

/// Записи этой страницы, в порядке backend (новые сверху). Клиент порядок
/// не меняет.
 List<CareHistoryEntry> get items;/// Общее количество активных записей истории (по всем страницам).
 int get total;/// Размер запрошенной страницы (echo из ответа).
 int get limit;/// Сдвиг этой страницы от начала истории (echo из ответа).
 int get offset;
/// Create a copy of CareHistoryPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareHistoryPageCopyWith<CareHistoryPage> get copyWith => _$CareHistoryPageCopyWithImpl<CareHistoryPage>(this as CareHistoryPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareHistoryPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,limit,offset);

@override
String toString() {
  return 'CareHistoryPage(items: $items, total: $total, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $CareHistoryPageCopyWith<$Res>  {
  factory $CareHistoryPageCopyWith(CareHistoryPage value, $Res Function(CareHistoryPage) _then) = _$CareHistoryPageCopyWithImpl;
@useResult
$Res call({
 List<CareHistoryEntry> items, int total, int limit, int offset
});




}
/// @nodoc
class _$CareHistoryPageCopyWithImpl<$Res>
    implements $CareHistoryPageCopyWith<$Res> {
  _$CareHistoryPageCopyWithImpl(this._self, this._then);

  final CareHistoryPage _self;
  final $Res Function(CareHistoryPage) _then;

/// Create a copy of CareHistoryPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? limit = null,Object? offset = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CareHistoryEntry>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CareHistoryPage].
extension CareHistoryPagePatterns on CareHistoryPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareHistoryPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareHistoryPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareHistoryPage value)  $default,){
final _that = this;
switch (_that) {
case _CareHistoryPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareHistoryPage value)?  $default,){
final _that = this;
switch (_that) {
case _CareHistoryPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CareHistoryEntry> items,  int total,  int limit,  int offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareHistoryPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CareHistoryEntry> items,  int total,  int limit,  int offset)  $default,) {final _that = this;
switch (_that) {
case _CareHistoryPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CareHistoryEntry> items,  int total,  int limit,  int offset)?  $default,) {final _that = this;
switch (_that) {
case _CareHistoryPage() when $default != null:
return $default(_that.items,_that.total,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc


class _CareHistoryPage extends CareHistoryPage {
  const _CareHistoryPage({required final  List<CareHistoryEntry> items, required this.total, required this.limit, required this.offset}): _items = items,super._();
  

/// Записи этой страницы, в порядке backend (новые сверху). Клиент порядок
/// не меняет.
 final  List<CareHistoryEntry> _items;
/// Записи этой страницы, в порядке backend (новые сверху). Клиент порядок
/// не меняет.
@override List<CareHistoryEntry> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Общее количество активных записей истории (по всем страницам).
@override final  int total;
/// Размер запрошенной страницы (echo из ответа).
@override final  int limit;
/// Сдвиг этой страницы от начала истории (echo из ответа).
@override final  int offset;

/// Create a copy of CareHistoryPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareHistoryPageCopyWith<_CareHistoryPage> get copyWith => __$CareHistoryPageCopyWithImpl<_CareHistoryPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareHistoryPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,limit,offset);

@override
String toString() {
  return 'CareHistoryPage(items: $items, total: $total, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$CareHistoryPageCopyWith<$Res> implements $CareHistoryPageCopyWith<$Res> {
  factory _$CareHistoryPageCopyWith(_CareHistoryPage value, $Res Function(_CareHistoryPage) _then) = __$CareHistoryPageCopyWithImpl;
@override @useResult
$Res call({
 List<CareHistoryEntry> items, int total, int limit, int offset
});




}
/// @nodoc
class __$CareHistoryPageCopyWithImpl<$Res>
    implements _$CareHistoryPageCopyWith<$Res> {
  __$CareHistoryPageCopyWithImpl(this._self, this._then);

  final _CareHistoryPage _self;
  final $Res Function(_CareHistoryPage) _then;

/// Create a copy of CareHistoryPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? limit = null,Object? offset = null,}) {
  return _then(_CareHistoryPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CareHistoryEntry>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
