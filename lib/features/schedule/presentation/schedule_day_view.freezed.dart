// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_day_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleTaskItem {

 CareTask get task;/// `task.dueAt.toLocal() < startOfToday` (просрочка относительно сегодня).
 bool get overdue;/// Задача отмечена выполненной в текущей сессии (оптимистично).
 bool get done;
/// Create a copy of ScheduleTaskItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleTaskItemCopyWith<ScheduleTaskItem> get copyWith => _$ScheduleTaskItemCopyWithImpl<ScheduleTaskItem>(this as ScheduleTaskItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleTaskItem&&(identical(other.task, task) || other.task == task)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.done, done) || other.done == done));
}


@override
int get hashCode => Object.hash(runtimeType,task,overdue,done);

@override
String toString() {
  return 'ScheduleTaskItem(task: $task, overdue: $overdue, done: $done)';
}


}

/// @nodoc
abstract mixin class $ScheduleTaskItemCopyWith<$Res>  {
  factory $ScheduleTaskItemCopyWith(ScheduleTaskItem value, $Res Function(ScheduleTaskItem) _then) = _$ScheduleTaskItemCopyWithImpl;
@useResult
$Res call({
 CareTask task, bool overdue, bool done
});


$CareTaskCopyWith<$Res> get task;

}
/// @nodoc
class _$ScheduleTaskItemCopyWithImpl<$Res>
    implements $ScheduleTaskItemCopyWith<$Res> {
  _$ScheduleTaskItemCopyWithImpl(this._self, this._then);

  final ScheduleTaskItem _self;
  final $Res Function(ScheduleTaskItem) _then;

/// Create a copy of ScheduleTaskItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? overdue = null,Object? done = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as CareTask,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as bool,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ScheduleTaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareTaskCopyWith<$Res> get task {
  
  return $CareTaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleTaskItem].
extension ScheduleTaskItemPatterns on ScheduleTaskItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleTaskItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleTaskItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleTaskItem value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleTaskItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleTaskItem value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleTaskItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CareTask task,  bool overdue,  bool done)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleTaskItem() when $default != null:
return $default(_that.task,_that.overdue,_that.done);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CareTask task,  bool overdue,  bool done)  $default,) {final _that = this;
switch (_that) {
case _ScheduleTaskItem():
return $default(_that.task,_that.overdue,_that.done);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CareTask task,  bool overdue,  bool done)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleTaskItem() when $default != null:
return $default(_that.task,_that.overdue,_that.done);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleTaskItem implements ScheduleTaskItem {
  const _ScheduleTaskItem({required this.task, required this.overdue, required this.done});
  

@override final  CareTask task;
/// `task.dueAt.toLocal() < startOfToday` (просрочка относительно сегодня).
@override final  bool overdue;
/// Задача отмечена выполненной в текущей сессии (оптимистично).
@override final  bool done;

/// Create a copy of ScheduleTaskItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleTaskItemCopyWith<_ScheduleTaskItem> get copyWith => __$ScheduleTaskItemCopyWithImpl<_ScheduleTaskItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleTaskItem&&(identical(other.task, task) || other.task == task)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.done, done) || other.done == done));
}


@override
int get hashCode => Object.hash(runtimeType,task,overdue,done);

@override
String toString() {
  return 'ScheduleTaskItem(task: $task, overdue: $overdue, done: $done)';
}


}

/// @nodoc
abstract mixin class _$ScheduleTaskItemCopyWith<$Res> implements $ScheduleTaskItemCopyWith<$Res> {
  factory _$ScheduleTaskItemCopyWith(_ScheduleTaskItem value, $Res Function(_ScheduleTaskItem) _then) = __$ScheduleTaskItemCopyWithImpl;
@override @useResult
$Res call({
 CareTask task, bool overdue, bool done
});


@override $CareTaskCopyWith<$Res> get task;

}
/// @nodoc
class __$ScheduleTaskItemCopyWithImpl<$Res>
    implements _$ScheduleTaskItemCopyWith<$Res> {
  __$ScheduleTaskItemCopyWithImpl(this._self, this._then);

  final _ScheduleTaskItem _self;
  final $Res Function(_ScheduleTaskItem) _then;

/// Create a copy of ScheduleTaskItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? overdue = null,Object? done = null,}) {
  return _then(_ScheduleTaskItem(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as CareTask,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as bool,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ScheduleTaskItem
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
mixin _$ScheduleAgendaGroup {

 ScheduleAgendaPhase get phase;/// Задачи фазы. Для morning/evening — по `dueAt` возрастанию.
 List<ScheduleTaskItem> get items;
/// Create a copy of ScheduleAgendaGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleAgendaGroupCopyWith<ScheduleAgendaGroup> get copyWith => _$ScheduleAgendaGroupCopyWithImpl<ScheduleAgendaGroup>(this as ScheduleAgendaGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleAgendaGroup&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,phase,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ScheduleAgendaGroup(phase: $phase, items: $items)';
}


}

/// @nodoc
abstract mixin class $ScheduleAgendaGroupCopyWith<$Res>  {
  factory $ScheduleAgendaGroupCopyWith(ScheduleAgendaGroup value, $Res Function(ScheduleAgendaGroup) _then) = _$ScheduleAgendaGroupCopyWithImpl;
@useResult
$Res call({
 ScheduleAgendaPhase phase, List<ScheduleTaskItem> items
});




}
/// @nodoc
class _$ScheduleAgendaGroupCopyWithImpl<$Res>
    implements $ScheduleAgendaGroupCopyWith<$Res> {
  _$ScheduleAgendaGroupCopyWithImpl(this._self, this._then);

  final ScheduleAgendaGroup _self;
  final $Res Function(ScheduleAgendaGroup) _then;

/// Create a copy of ScheduleAgendaGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? items = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ScheduleAgendaPhase,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ScheduleTaskItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleAgendaGroup].
extension ScheduleAgendaGroupPatterns on ScheduleAgendaGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleAgendaGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleAgendaGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleAgendaGroup value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleAgendaGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleAgendaGroup value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleAgendaGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScheduleAgendaPhase phase,  List<ScheduleTaskItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleAgendaGroup() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScheduleAgendaPhase phase,  List<ScheduleTaskItem> items)  $default,) {final _that = this;
switch (_that) {
case _ScheduleAgendaGroup():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScheduleAgendaPhase phase,  List<ScheduleTaskItem> items)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleAgendaGroup() when $default != null:
return $default(_that.phase,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleAgendaGroup implements ScheduleAgendaGroup {
  const _ScheduleAgendaGroup({required this.phase, required final  List<ScheduleTaskItem> items}): _items = items;
  

@override final  ScheduleAgendaPhase phase;
/// Задачи фазы. Для morning/evening — по `dueAt` возрастанию.
 final  List<ScheduleTaskItem> _items;
/// Задачи фазы. Для morning/evening — по `dueAt` возрастанию.
@override List<ScheduleTaskItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ScheduleAgendaGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleAgendaGroupCopyWith<_ScheduleAgendaGroup> get copyWith => __$ScheduleAgendaGroupCopyWithImpl<_ScheduleAgendaGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleAgendaGroup&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,phase,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ScheduleAgendaGroup(phase: $phase, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ScheduleAgendaGroupCopyWith<$Res> implements $ScheduleAgendaGroupCopyWith<$Res> {
  factory _$ScheduleAgendaGroupCopyWith(_ScheduleAgendaGroup value, $Res Function(_ScheduleAgendaGroup) _then) = __$ScheduleAgendaGroupCopyWithImpl;
@override @useResult
$Res call({
 ScheduleAgendaPhase phase, List<ScheduleTaskItem> items
});




}
/// @nodoc
class __$ScheduleAgendaGroupCopyWithImpl<$Res>
    implements _$ScheduleAgendaGroupCopyWith<$Res> {
  __$ScheduleAgendaGroupCopyWithImpl(this._self, this._then);

  final _ScheduleAgendaGroup _self;
  final $Res Function(_ScheduleAgendaGroup) _then;

/// Create a copy of ScheduleAgendaGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? items = null,}) {
  return _then(_ScheduleAgendaGroup(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ScheduleAgendaPhase,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ScheduleTaskItem>,
  ));
}


}

/// @nodoc
mixin _$ScheduleDayView {

/// Секции (утро/вечер/сделано) в порядке отрисовки. Пустые опущены.
 List<ScheduleAgendaGroup> get groups;/// Всего задач дня (для подзаголовка «X из N готово»).
 int get totalCount;/// Сколько из них отмечено выполненными в текущей сессии.
 int get doneCount;
/// Create a copy of ScheduleDayView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDayViewCopyWith<ScheduleDayView> get copyWith => _$ScheduleDayViewCopyWithImpl<ScheduleDayView>(this as ScheduleDayView, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDayView&&const DeepCollectionEquality().equals(other.groups, groups)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.doneCount, doneCount) || other.doneCount == doneCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(groups),totalCount,doneCount);

@override
String toString() {
  return 'ScheduleDayView(groups: $groups, totalCount: $totalCount, doneCount: $doneCount)';
}


}

/// @nodoc
abstract mixin class $ScheduleDayViewCopyWith<$Res>  {
  factory $ScheduleDayViewCopyWith(ScheduleDayView value, $Res Function(ScheduleDayView) _then) = _$ScheduleDayViewCopyWithImpl;
@useResult
$Res call({
 List<ScheduleAgendaGroup> groups, int totalCount, int doneCount
});




}
/// @nodoc
class _$ScheduleDayViewCopyWithImpl<$Res>
    implements $ScheduleDayViewCopyWith<$Res> {
  _$ScheduleDayViewCopyWithImpl(this._self, this._then);

  final ScheduleDayView _self;
  final $Res Function(ScheduleDayView) _then;

/// Create a copy of ScheduleDayView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,Object? totalCount = null,Object? doneCount = null,}) {
  return _then(_self.copyWith(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<ScheduleAgendaGroup>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,doneCount: null == doneCount ? _self.doneCount : doneCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDayView].
extension ScheduleDayViewPatterns on ScheduleDayView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDayView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDayView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDayView value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDayView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDayView value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDayView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ScheduleAgendaGroup> groups,  int totalCount,  int doneCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDayView() when $default != null:
return $default(_that.groups,_that.totalCount,_that.doneCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ScheduleAgendaGroup> groups,  int totalCount,  int doneCount)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDayView():
return $default(_that.groups,_that.totalCount,_that.doneCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ScheduleAgendaGroup> groups,  int totalCount,  int doneCount)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDayView() when $default != null:
return $default(_that.groups,_that.totalCount,_that.doneCount);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleDayView extends ScheduleDayView {
  const _ScheduleDayView({required final  List<ScheduleAgendaGroup> groups, required this.totalCount, required this.doneCount}): _groups = groups,super._();
  

/// Секции (утро/вечер/сделано) в порядке отрисовки. Пустые опущены.
 final  List<ScheduleAgendaGroup> _groups;
/// Секции (утро/вечер/сделано) в порядке отрисовки. Пустые опущены.
@override List<ScheduleAgendaGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

/// Всего задач дня (для подзаголовка «X из N готово»).
@override final  int totalCount;
/// Сколько из них отмечено выполненными в текущей сессии.
@override final  int doneCount;

/// Create a copy of ScheduleDayView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDayViewCopyWith<_ScheduleDayView> get copyWith => __$ScheduleDayViewCopyWithImpl<_ScheduleDayView>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDayView&&const DeepCollectionEquality().equals(other._groups, _groups)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.doneCount, doneCount) || other.doneCount == doneCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups),totalCount,doneCount);

@override
String toString() {
  return 'ScheduleDayView(groups: $groups, totalCount: $totalCount, doneCount: $doneCount)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDayViewCopyWith<$Res> implements $ScheduleDayViewCopyWith<$Res> {
  factory _$ScheduleDayViewCopyWith(_ScheduleDayView value, $Res Function(_ScheduleDayView) _then) = __$ScheduleDayViewCopyWithImpl;
@override @useResult
$Res call({
 List<ScheduleAgendaGroup> groups, int totalCount, int doneCount
});




}
/// @nodoc
class __$ScheduleDayViewCopyWithImpl<$Res>
    implements _$ScheduleDayViewCopyWith<$Res> {
  __$ScheduleDayViewCopyWithImpl(this._self, this._then);

  final _ScheduleDayView _self;
  final $Res Function(_ScheduleDayView) _then;

/// Create a copy of ScheduleDayView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? totalCount = null,Object? doneCount = null,}) {
  return _then(_ScheduleDayView(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<ScheduleAgendaGroup>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,doneCount: null == doneCount ? _self.doneCount : doneCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
