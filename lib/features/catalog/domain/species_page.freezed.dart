// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeciesPage {

 List<Species> get items;/// Общее количество видов под фильтром `q` (для пагинации).
 int get total; int get offset; int get limit;
/// Create a copy of SpeciesPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeciesPageCopyWith<SpeciesPage> get copyWith => _$SpeciesPageCopyWithImpl<SpeciesPage>(this as SpeciesPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeciesPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,offset,limit);

@override
String toString() {
  return 'SpeciesPage(items: $items, total: $total, offset: $offset, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $SpeciesPageCopyWith<$Res>  {
  factory $SpeciesPageCopyWith(SpeciesPage value, $Res Function(SpeciesPage) _then) = _$SpeciesPageCopyWithImpl;
@useResult
$Res call({
 List<Species> items, int total, int offset, int limit
});




}
/// @nodoc
class _$SpeciesPageCopyWithImpl<$Res>
    implements $SpeciesPageCopyWith<$Res> {
  _$SpeciesPageCopyWithImpl(this._self, this._then);

  final SpeciesPage _self;
  final $Res Function(SpeciesPage) _then;

/// Create a copy of SpeciesPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? offset = null,Object? limit = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Species>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeciesPage].
extension SpeciesPagePatterns on SpeciesPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeciesPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeciesPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeciesPage value)  $default,){
final _that = this;
switch (_that) {
case _SpeciesPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeciesPage value)?  $default,){
final _that = this;
switch (_that) {
case _SpeciesPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Species> items,  int total,  int offset,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeciesPage() when $default != null:
return $default(_that.items,_that.total,_that.offset,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Species> items,  int total,  int offset,  int limit)  $default,) {final _that = this;
switch (_that) {
case _SpeciesPage():
return $default(_that.items,_that.total,_that.offset,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Species> items,  int total,  int offset,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _SpeciesPage() when $default != null:
return $default(_that.items,_that.total,_that.offset,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _SpeciesPage implements SpeciesPage {
  const _SpeciesPage({required final  List<Species> items, required this.total, required this.offset, required this.limit}): _items = items;
  

 final  List<Species> _items;
@override List<Species> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Общее количество видов под фильтром `q` (для пагинации).
@override final  int total;
@override final  int offset;
@override final  int limit;

/// Create a copy of SpeciesPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeciesPageCopyWith<_SpeciesPage> get copyWith => __$SpeciesPageCopyWithImpl<_SpeciesPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeciesPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,offset,limit);

@override
String toString() {
  return 'SpeciesPage(items: $items, total: $total, offset: $offset, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$SpeciesPageCopyWith<$Res> implements $SpeciesPageCopyWith<$Res> {
  factory _$SpeciesPageCopyWith(_SpeciesPage value, $Res Function(_SpeciesPage) _then) = __$SpeciesPageCopyWithImpl;
@override @useResult
$Res call({
 List<Species> items, int total, int offset, int limit
});




}
/// @nodoc
class __$SpeciesPageCopyWithImpl<$Res>
    implements _$SpeciesPageCopyWith<$Res> {
  __$SpeciesPageCopyWithImpl(this._self, this._then);

  final _SpeciesPage _self;
  final $Res Function(_SpeciesPage) _then;

/// Create a copy of SpeciesPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? offset = null,Object? limit = null,}) {
  return _then(_SpeciesPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Species>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
