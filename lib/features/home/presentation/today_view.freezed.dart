// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodayTaskItem {

 CareTask get task;/// `dueAt.toLocal() < nowLocal` на момент деривации.
 bool get overdue;
/// Create a copy of TodayTaskItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayTaskItemCopyWith<TodayTaskItem> get copyWith => _$TodayTaskItemCopyWithImpl<TodayTaskItem>(this as TodayTaskItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayTaskItem&&(identical(other.task, task) || other.task == task)&&(identical(other.overdue, overdue) || other.overdue == overdue));
}


@override
int get hashCode => Object.hash(runtimeType,task,overdue);

@override
String toString() {
  return 'TodayTaskItem(task: $task, overdue: $overdue)';
}


}

/// @nodoc
abstract mixin class $TodayTaskItemCopyWith<$Res>  {
  factory $TodayTaskItemCopyWith(TodayTaskItem value, $Res Function(TodayTaskItem) _then) = _$TodayTaskItemCopyWithImpl;
@useResult
$Res call({
 CareTask task, bool overdue
});


$CareTaskCopyWith<$Res> get task;

}
/// @nodoc
class _$TodayTaskItemCopyWithImpl<$Res>
    implements $TodayTaskItemCopyWith<$Res> {
  _$TodayTaskItemCopyWithImpl(this._self, this._then);

  final TodayTaskItem _self;
  final $Res Function(TodayTaskItem) _then;

/// Create a copy of TodayTaskItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? overdue = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as CareTask,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TodayTaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareTaskCopyWith<$Res> get task {
  
  return $CareTaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodayTaskItem].
extension TodayTaskItemPatterns on TodayTaskItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayTaskItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayTaskItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayTaskItem value)  $default,){
final _that = this;
switch (_that) {
case _TodayTaskItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayTaskItem value)?  $default,){
final _that = this;
switch (_that) {
case _TodayTaskItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CareTask task,  bool overdue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayTaskItem() when $default != null:
return $default(_that.task,_that.overdue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CareTask task,  bool overdue)  $default,) {final _that = this;
switch (_that) {
case _TodayTaskItem():
return $default(_that.task,_that.overdue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CareTask task,  bool overdue)?  $default,) {final _that = this;
switch (_that) {
case _TodayTaskItem() when $default != null:
return $default(_that.task,_that.overdue);case _:
  return null;

}
}

}

/// @nodoc


class _TodayTaskItem implements TodayTaskItem {
  const _TodayTaskItem({required this.task, required this.overdue});
  

@override final  CareTask task;
/// `dueAt.toLocal() < nowLocal` на момент деривации.
@override final  bool overdue;

/// Create a copy of TodayTaskItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayTaskItemCopyWith<_TodayTaskItem> get copyWith => __$TodayTaskItemCopyWithImpl<_TodayTaskItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayTaskItem&&(identical(other.task, task) || other.task == task)&&(identical(other.overdue, overdue) || other.overdue == overdue));
}


@override
int get hashCode => Object.hash(runtimeType,task,overdue);

@override
String toString() {
  return 'TodayTaskItem(task: $task, overdue: $overdue)';
}


}

/// @nodoc
abstract mixin class _$TodayTaskItemCopyWith<$Res> implements $TodayTaskItemCopyWith<$Res> {
  factory _$TodayTaskItemCopyWith(_TodayTaskItem value, $Res Function(_TodayTaskItem) _then) = __$TodayTaskItemCopyWithImpl;
@override @useResult
$Res call({
 CareTask task, bool overdue
});


@override $CareTaskCopyWith<$Res> get task;

}
/// @nodoc
class __$TodayTaskItemCopyWithImpl<$Res>
    implements _$TodayTaskItemCopyWith<$Res> {
  __$TodayTaskItemCopyWithImpl(this._self, this._then);

  final _TodayTaskItem _self;
  final $Res Function(_TodayTaskItem) _then;

/// Create a copy of TodayTaskItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? overdue = null,}) {
  return _then(_TodayTaskItem(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as CareTask,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TodayTaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareTaskCopyWith<$Res> get task {
  
  return $CareTaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

/// @nodoc
mixin _$TodayGroup {

 TodayPhase get phase;/// Задачи фазы, отсортированы по `dueAt` возрастанию.
 List<TodayTaskItem> get items;
/// Create a copy of TodayGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayGroupCopyWith<TodayGroup> get copyWith => _$TodayGroupCopyWithImpl<TodayGroup>(this as TodayGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayGroup&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,phase,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'TodayGroup(phase: $phase, items: $items)';
}


}

/// @nodoc
abstract mixin class $TodayGroupCopyWith<$Res>  {
  factory $TodayGroupCopyWith(TodayGroup value, $Res Function(TodayGroup) _then) = _$TodayGroupCopyWithImpl;
@useResult
$Res call({
 TodayPhase phase, List<TodayTaskItem> items
});




}
/// @nodoc
class _$TodayGroupCopyWithImpl<$Res>
    implements $TodayGroupCopyWith<$Res> {
  _$TodayGroupCopyWithImpl(this._self, this._then);

  final TodayGroup _self;
  final $Res Function(TodayGroup) _then;

/// Create a copy of TodayGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? items = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TodayPhase,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TodayTaskItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TodayGroup].
extension TodayGroupPatterns on TodayGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayGroup value)  $default,){
final _that = this;
switch (_that) {
case _TodayGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayGroup value)?  $default,){
final _that = this;
switch (_that) {
case _TodayGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TodayPhase phase,  List<TodayTaskItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayGroup() when $default != null:
return $default(_that.phase,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TodayPhase phase,  List<TodayTaskItem> items)  $default,) {final _that = this;
switch (_that) {
case _TodayGroup():
return $default(_that.phase,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TodayPhase phase,  List<TodayTaskItem> items)?  $default,) {final _that = this;
switch (_that) {
case _TodayGroup() when $default != null:
return $default(_that.phase,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _TodayGroup implements TodayGroup {
  const _TodayGroup({required this.phase, required final  List<TodayTaskItem> items}): _items = items;
  

@override final  TodayPhase phase;
/// Задачи фазы, отсортированы по `dueAt` возрастанию.
 final  List<TodayTaskItem> _items;
/// Задачи фазы, отсортированы по `dueAt` возрастанию.
@override List<TodayTaskItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TodayGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayGroupCopyWith<_TodayGroup> get copyWith => __$TodayGroupCopyWithImpl<_TodayGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayGroup&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,phase,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TodayGroup(phase: $phase, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TodayGroupCopyWith<$Res> implements $TodayGroupCopyWith<$Res> {
  factory _$TodayGroupCopyWith(_TodayGroup value, $Res Function(_TodayGroup) _then) = __$TodayGroupCopyWithImpl;
@override @useResult
$Res call({
 TodayPhase phase, List<TodayTaskItem> items
});




}
/// @nodoc
class __$TodayGroupCopyWithImpl<$Res>
    implements _$TodayGroupCopyWith<$Res> {
  __$TodayGroupCopyWithImpl(this._self, this._then);

  final _TodayGroup _self;
  final $Res Function(_TodayGroup) _then;

/// Create a copy of TodayGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? items = null,}) {
  return _then(_TodayGroup(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TodayPhase,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TodayTaskItem>,
  ));
}


}

/// @nodoc
mixin _$TodayView {

/// Активный фильтр, под который построены [groups].
 TodayFilter get filter;/// Секции (утро/вечер) под текущим фильтром. Пустые фазы опущены.
 List<TodayGroup> get groups;/// Всего задач в исходном списке (пилюля «Всё»).
 int get totalCount;/// Кол-во задач `watering` (пилюля «Полив»).
 int get wateringCount;/// Кол-во задач `misting` (пилюля «Опрыскивание»).
 int get mistingCount;/// Кол-во задач `fertilizing` (пилюля «Подкормка»).
 int get fertilizingCount;/// Кол-во просроченных любого типа (пилюля «Просрочено» + summary).
 int get overdueCount;
/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayViewCopyWith<TodayView> get copyWith => _$TodayViewCopyWithImpl<TodayView>(this as TodayView, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayView&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other.groups, groups)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.wateringCount, wateringCount) || other.wateringCount == wateringCount)&&(identical(other.mistingCount, mistingCount) || other.mistingCount == mistingCount)&&(identical(other.fertilizingCount, fertilizingCount) || other.fertilizingCount == fertilizingCount)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount));
}


@override
int get hashCode => Object.hash(runtimeType,filter,const DeepCollectionEquality().hash(groups),totalCount,wateringCount,mistingCount,fertilizingCount,overdueCount);

@override
String toString() {
  return 'TodayView(filter: $filter, groups: $groups, totalCount: $totalCount, wateringCount: $wateringCount, mistingCount: $mistingCount, fertilizingCount: $fertilizingCount, overdueCount: $overdueCount)';
}


}

/// @nodoc
abstract mixin class $TodayViewCopyWith<$Res>  {
  factory $TodayViewCopyWith(TodayView value, $Res Function(TodayView) _then) = _$TodayViewCopyWithImpl;
@useResult
$Res call({
 TodayFilter filter, List<TodayGroup> groups, int totalCount, int wateringCount, int mistingCount, int fertilizingCount, int overdueCount
});




}
/// @nodoc
class _$TodayViewCopyWithImpl<$Res>
    implements $TodayViewCopyWith<$Res> {
  _$TodayViewCopyWithImpl(this._self, this._then);

  final TodayView _self;
  final $Res Function(TodayView) _then;

/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filter = null,Object? groups = null,Object? totalCount = null,Object? wateringCount = null,Object? mistingCount = null,Object? fertilizingCount = null,Object? overdueCount = null,}) {
  return _then(_self.copyWith(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TodayFilter,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<TodayGroup>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,wateringCount: null == wateringCount ? _self.wateringCount : wateringCount // ignore: cast_nullable_to_non_nullable
as int,mistingCount: null == mistingCount ? _self.mistingCount : mistingCount // ignore: cast_nullable_to_non_nullable
as int,fertilizingCount: null == fertilizingCount ? _self.fertilizingCount : fertilizingCount // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TodayView].
extension TodayViewPatterns on TodayView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayView value)  $default,){
final _that = this;
switch (_that) {
case _TodayView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayView value)?  $default,){
final _that = this;
switch (_that) {
case _TodayView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TodayFilter filter,  List<TodayGroup> groups,  int totalCount,  int wateringCount,  int mistingCount,  int fertilizingCount,  int overdueCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayView() when $default != null:
return $default(_that.filter,_that.groups,_that.totalCount,_that.wateringCount,_that.mistingCount,_that.fertilizingCount,_that.overdueCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TodayFilter filter,  List<TodayGroup> groups,  int totalCount,  int wateringCount,  int mistingCount,  int fertilizingCount,  int overdueCount)  $default,) {final _that = this;
switch (_that) {
case _TodayView():
return $default(_that.filter,_that.groups,_that.totalCount,_that.wateringCount,_that.mistingCount,_that.fertilizingCount,_that.overdueCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TodayFilter filter,  List<TodayGroup> groups,  int totalCount,  int wateringCount,  int mistingCount,  int fertilizingCount,  int overdueCount)?  $default,) {final _that = this;
switch (_that) {
case _TodayView() when $default != null:
return $default(_that.filter,_that.groups,_that.totalCount,_that.wateringCount,_that.mistingCount,_that.fertilizingCount,_that.overdueCount);case _:
  return null;

}
}

}

/// @nodoc


class _TodayView extends TodayView {
  const _TodayView({required this.filter, required final  List<TodayGroup> groups, required this.totalCount, required this.wateringCount, required this.mistingCount, required this.fertilizingCount, required this.overdueCount}): _groups = groups,super._();
  

/// Активный фильтр, под который построены [groups].
@override final  TodayFilter filter;
/// Секции (утро/вечер) под текущим фильтром. Пустые фазы опущены.
 final  List<TodayGroup> _groups;
/// Секции (утро/вечер) под текущим фильтром. Пустые фазы опущены.
@override List<TodayGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

/// Всего задач в исходном списке (пилюля «Всё»).
@override final  int totalCount;
/// Кол-во задач `watering` (пилюля «Полив»).
@override final  int wateringCount;
/// Кол-во задач `misting` (пилюля «Опрыскивание»).
@override final  int mistingCount;
/// Кол-во задач `fertilizing` (пилюля «Подкормка»).
@override final  int fertilizingCount;
/// Кол-во просроченных любого типа (пилюля «Просрочено» + summary).
@override final  int overdueCount;

/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayViewCopyWith<_TodayView> get copyWith => __$TodayViewCopyWithImpl<_TodayView>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayView&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other._groups, _groups)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.wateringCount, wateringCount) || other.wateringCount == wateringCount)&&(identical(other.mistingCount, mistingCount) || other.mistingCount == mistingCount)&&(identical(other.fertilizingCount, fertilizingCount) || other.fertilizingCount == fertilizingCount)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount));
}


@override
int get hashCode => Object.hash(runtimeType,filter,const DeepCollectionEquality().hash(_groups),totalCount,wateringCount,mistingCount,fertilizingCount,overdueCount);

@override
String toString() {
  return 'TodayView(filter: $filter, groups: $groups, totalCount: $totalCount, wateringCount: $wateringCount, mistingCount: $mistingCount, fertilizingCount: $fertilizingCount, overdueCount: $overdueCount)';
}


}

/// @nodoc
abstract mixin class _$TodayViewCopyWith<$Res> implements $TodayViewCopyWith<$Res> {
  factory _$TodayViewCopyWith(_TodayView value, $Res Function(_TodayView) _then) = __$TodayViewCopyWithImpl;
@override @useResult
$Res call({
 TodayFilter filter, List<TodayGroup> groups, int totalCount, int wateringCount, int mistingCount, int fertilizingCount, int overdueCount
});




}
/// @nodoc
class __$TodayViewCopyWithImpl<$Res>
    implements _$TodayViewCopyWith<$Res> {
  __$TodayViewCopyWithImpl(this._self, this._then);

  final _TodayView _self;
  final $Res Function(_TodayView) _then;

/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filter = null,Object? groups = null,Object? totalCount = null,Object? wateringCount = null,Object? mistingCount = null,Object? fertilizingCount = null,Object? overdueCount = null,}) {
  return _then(_TodayView(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TodayFilter,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<TodayGroup>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,wateringCount: null == wateringCount ? _self.wateringCount : wateringCount // ignore: cast_nullable_to_non_nullable
as int,mistingCount: null == mistingCount ? _self.mistingCount : mistingCount // ignore: cast_nullable_to_non_nullable
as int,fertilizingCount: null == fertilizingCount ? _self.fertilizingCount : fertilizingCount // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
