// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sdui_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SduiBlock {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SduiBlock);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SduiBlock()';
}


}

/// @nodoc
class $SduiBlockCopyWith<$Res>  {
$SduiBlockCopyWith(SduiBlock _, $Res Function(SduiBlock) __);
}


/// Adds pattern-matching-related methods to [SduiBlock].
extension SduiBlockPatterns on SduiBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SduiWeatherStripBlock value)?  weatherStrip,TResult Function( SduiTodaySummaryBlock value)?  todaySummary,TResult Function( SduiLocationChipsBlock value)?  locationChips,TResult Function( SduiPlantGridBlock value)?  plantGrid,TResult Function( SduiUnknownBlock value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SduiWeatherStripBlock() when weatherStrip != null:
return weatherStrip(_that);case SduiTodaySummaryBlock() when todaySummary != null:
return todaySummary(_that);case SduiLocationChipsBlock() when locationChips != null:
return locationChips(_that);case SduiPlantGridBlock() when plantGrid != null:
return plantGrid(_that);case SduiUnknownBlock() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SduiWeatherStripBlock value)  weatherStrip,required TResult Function( SduiTodaySummaryBlock value)  todaySummary,required TResult Function( SduiLocationChipsBlock value)  locationChips,required TResult Function( SduiPlantGridBlock value)  plantGrid,required TResult Function( SduiUnknownBlock value)  unknown,}){
final _that = this;
switch (_that) {
case SduiWeatherStripBlock():
return weatherStrip(_that);case SduiTodaySummaryBlock():
return todaySummary(_that);case SduiLocationChipsBlock():
return locationChips(_that);case SduiPlantGridBlock():
return plantGrid(_that);case SduiUnknownBlock():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SduiWeatherStripBlock value)?  weatherStrip,TResult? Function( SduiTodaySummaryBlock value)?  todaySummary,TResult? Function( SduiLocationChipsBlock value)?  locationChips,TResult? Function( SduiPlantGridBlock value)?  plantGrid,TResult? Function( SduiUnknownBlock value)?  unknown,}){
final _that = this;
switch (_that) {
case SduiWeatherStripBlock() when weatherStrip != null:
return weatherStrip(_that);case SduiTodaySummaryBlock() when todaySummary != null:
return todaySummary(_that);case SduiLocationChipsBlock() when locationChips != null:
return locationChips(_that);case SduiPlantGridBlock() when plantGrid != null:
return plantGrid(_that);case SduiUnknownBlock() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool available,  int? humidityPercent,  WateringRecommendation? recommendation)?  weatherStrip,TResult Function( int total,  int done,  int remaining,  int overdue)?  todaySummary,TResult Function( List<GardenLocation> locations)?  locationChips,TResult Function( List<SduiPlantGridItem> plants)?  plantGrid,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SduiWeatherStripBlock() when weatherStrip != null:
return weatherStrip(_that.available,_that.humidityPercent,_that.recommendation);case SduiTodaySummaryBlock() when todaySummary != null:
return todaySummary(_that.total,_that.done,_that.remaining,_that.overdue);case SduiLocationChipsBlock() when locationChips != null:
return locationChips(_that.locations);case SduiPlantGridBlock() when plantGrid != null:
return plantGrid(_that.plants);case SduiUnknownBlock() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool available,  int? humidityPercent,  WateringRecommendation? recommendation)  weatherStrip,required TResult Function( int total,  int done,  int remaining,  int overdue)  todaySummary,required TResult Function( List<GardenLocation> locations)  locationChips,required TResult Function( List<SduiPlantGridItem> plants)  plantGrid,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case SduiWeatherStripBlock():
return weatherStrip(_that.available,_that.humidityPercent,_that.recommendation);case SduiTodaySummaryBlock():
return todaySummary(_that.total,_that.done,_that.remaining,_that.overdue);case SduiLocationChipsBlock():
return locationChips(_that.locations);case SduiPlantGridBlock():
return plantGrid(_that.plants);case SduiUnknownBlock():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool available,  int? humidityPercent,  WateringRecommendation? recommendation)?  weatherStrip,TResult? Function( int total,  int done,  int remaining,  int overdue)?  todaySummary,TResult? Function( List<GardenLocation> locations)?  locationChips,TResult? Function( List<SduiPlantGridItem> plants)?  plantGrid,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case SduiWeatherStripBlock() when weatherStrip != null:
return weatherStrip(_that.available,_that.humidityPercent,_that.recommendation);case SduiTodaySummaryBlock() when todaySummary != null:
return todaySummary(_that.total,_that.done,_that.remaining,_that.overdue);case SduiLocationChipsBlock() when locationChips != null:
return locationChips(_that.locations);case SduiPlantGridBlock() when plantGrid != null:
return plantGrid(_that.plants);case SduiUnknownBlock() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc


class SduiWeatherStripBlock implements SduiBlock {
  const SduiWeatherStripBlock({required this.available, this.humidityPercent, this.recommendation});
  

 final  bool available;
 final  int? humidityPercent;
 final  WateringRecommendation? recommendation;

/// Create a copy of SduiBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SduiWeatherStripBlockCopyWith<SduiWeatherStripBlock> get copyWith => _$SduiWeatherStripBlockCopyWithImpl<SduiWeatherStripBlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SduiWeatherStripBlock&&(identical(other.available, available) || other.available == available)&&(identical(other.humidityPercent, humidityPercent) || other.humidityPercent == humidityPercent)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation));
}


@override
int get hashCode => Object.hash(runtimeType,available,humidityPercent,recommendation);

@override
String toString() {
  return 'SduiBlock.weatherStrip(available: $available, humidityPercent: $humidityPercent, recommendation: $recommendation)';
}


}

/// @nodoc
abstract mixin class $SduiWeatherStripBlockCopyWith<$Res> implements $SduiBlockCopyWith<$Res> {
  factory $SduiWeatherStripBlockCopyWith(SduiWeatherStripBlock value, $Res Function(SduiWeatherStripBlock) _then) = _$SduiWeatherStripBlockCopyWithImpl;
@useResult
$Res call({
 bool available, int? humidityPercent, WateringRecommendation? recommendation
});




}
/// @nodoc
class _$SduiWeatherStripBlockCopyWithImpl<$Res>
    implements $SduiWeatherStripBlockCopyWith<$Res> {
  _$SduiWeatherStripBlockCopyWithImpl(this._self, this._then);

  final SduiWeatherStripBlock _self;
  final $Res Function(SduiWeatherStripBlock) _then;

/// Create a copy of SduiBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? available = null,Object? humidityPercent = freezed,Object? recommendation = freezed,}) {
  return _then(SduiWeatherStripBlock(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,humidityPercent: freezed == humidityPercent ? _self.humidityPercent : humidityPercent // ignore: cast_nullable_to_non_nullable
as int?,recommendation: freezed == recommendation ? _self.recommendation : recommendation // ignore: cast_nullable_to_non_nullable
as WateringRecommendation?,
  ));
}


}

/// @nodoc


class SduiTodaySummaryBlock implements SduiBlock {
  const SduiTodaySummaryBlock({required this.total, required this.done, required this.remaining, required this.overdue});
  

 final  int total;
 final  int done;
 final  int remaining;
 final  int overdue;

/// Create a copy of SduiBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SduiTodaySummaryBlockCopyWith<SduiTodaySummaryBlock> get copyWith => _$SduiTodaySummaryBlockCopyWithImpl<SduiTodaySummaryBlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SduiTodaySummaryBlock&&(identical(other.total, total) || other.total == total)&&(identical(other.done, done) || other.done == done)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.overdue, overdue) || other.overdue == overdue));
}


@override
int get hashCode => Object.hash(runtimeType,total,done,remaining,overdue);

@override
String toString() {
  return 'SduiBlock.todaySummary(total: $total, done: $done, remaining: $remaining, overdue: $overdue)';
}


}

/// @nodoc
abstract mixin class $SduiTodaySummaryBlockCopyWith<$Res> implements $SduiBlockCopyWith<$Res> {
  factory $SduiTodaySummaryBlockCopyWith(SduiTodaySummaryBlock value, $Res Function(SduiTodaySummaryBlock) _then) = _$SduiTodaySummaryBlockCopyWithImpl;
@useResult
$Res call({
 int total, int done, int remaining, int overdue
});




}
/// @nodoc
class _$SduiTodaySummaryBlockCopyWithImpl<$Res>
    implements $SduiTodaySummaryBlockCopyWith<$Res> {
  _$SduiTodaySummaryBlockCopyWithImpl(this._self, this._then);

  final SduiTodaySummaryBlock _self;
  final $Res Function(SduiTodaySummaryBlock) _then;

/// Create a copy of SduiBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? total = null,Object? done = null,Object? remaining = null,Object? overdue = null,}) {
  return _then(SduiTodaySummaryBlock(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SduiLocationChipsBlock implements SduiBlock {
  const SduiLocationChipsBlock({required final  List<GardenLocation> locations}): _locations = locations;
  

 final  List<GardenLocation> _locations;
 List<GardenLocation> get locations {
  if (_locations is EqualUnmodifiableListView) return _locations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_locations);
}


/// Create a copy of SduiBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SduiLocationChipsBlockCopyWith<SduiLocationChipsBlock> get copyWith => _$SduiLocationChipsBlockCopyWithImpl<SduiLocationChipsBlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SduiLocationChipsBlock&&const DeepCollectionEquality().equals(other._locations, _locations));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_locations));

@override
String toString() {
  return 'SduiBlock.locationChips(locations: $locations)';
}


}

/// @nodoc
abstract mixin class $SduiLocationChipsBlockCopyWith<$Res> implements $SduiBlockCopyWith<$Res> {
  factory $SduiLocationChipsBlockCopyWith(SduiLocationChipsBlock value, $Res Function(SduiLocationChipsBlock) _then) = _$SduiLocationChipsBlockCopyWithImpl;
@useResult
$Res call({
 List<GardenLocation> locations
});




}
/// @nodoc
class _$SduiLocationChipsBlockCopyWithImpl<$Res>
    implements $SduiLocationChipsBlockCopyWith<$Res> {
  _$SduiLocationChipsBlockCopyWithImpl(this._self, this._then);

  final SduiLocationChipsBlock _self;
  final $Res Function(SduiLocationChipsBlock) _then;

/// Create a copy of SduiBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? locations = null,}) {
  return _then(SduiLocationChipsBlock(
locations: null == locations ? _self._locations : locations // ignore: cast_nullable_to_non_nullable
as List<GardenLocation>,
  ));
}


}

/// @nodoc


class SduiPlantGridBlock implements SduiBlock {
  const SduiPlantGridBlock({required final  List<SduiPlantGridItem> plants}): _plants = plants;
  

 final  List<SduiPlantGridItem> _plants;
 List<SduiPlantGridItem> get plants {
  if (_plants is EqualUnmodifiableListView) return _plants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plants);
}


/// Create a copy of SduiBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SduiPlantGridBlockCopyWith<SduiPlantGridBlock> get copyWith => _$SduiPlantGridBlockCopyWithImpl<SduiPlantGridBlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SduiPlantGridBlock&&const DeepCollectionEquality().equals(other._plants, _plants));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_plants));

@override
String toString() {
  return 'SduiBlock.plantGrid(plants: $plants)';
}


}

/// @nodoc
abstract mixin class $SduiPlantGridBlockCopyWith<$Res> implements $SduiBlockCopyWith<$Res> {
  factory $SduiPlantGridBlockCopyWith(SduiPlantGridBlock value, $Res Function(SduiPlantGridBlock) _then) = _$SduiPlantGridBlockCopyWithImpl;
@useResult
$Res call({
 List<SduiPlantGridItem> plants
});




}
/// @nodoc
class _$SduiPlantGridBlockCopyWithImpl<$Res>
    implements $SduiPlantGridBlockCopyWith<$Res> {
  _$SduiPlantGridBlockCopyWithImpl(this._self, this._then);

  final SduiPlantGridBlock _self;
  final $Res Function(SduiPlantGridBlock) _then;

/// Create a copy of SduiBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plants = null,}) {
  return _then(SduiPlantGridBlock(
plants: null == plants ? _self._plants : plants // ignore: cast_nullable_to_non_nullable
as List<SduiPlantGridItem>,
  ));
}


}

/// @nodoc


class SduiUnknownBlock implements SduiBlock {
  const SduiUnknownBlock();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SduiUnknownBlock);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SduiBlock.unknown()';
}


}




/// @nodoc
mixin _$SduiPlantGridItem {

 int get id; String get name; String? get locationName; SduiAction? get action;
/// Create a copy of SduiPlantGridItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SduiPlantGridItemCopyWith<SduiPlantGridItem> get copyWith => _$SduiPlantGridItemCopyWithImpl<SduiPlantGridItem>(this as SduiPlantGridItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SduiPlantGridItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,locationName,action);

@override
String toString() {
  return 'SduiPlantGridItem(id: $id, name: $name, locationName: $locationName, action: $action)';
}


}

/// @nodoc
abstract mixin class $SduiPlantGridItemCopyWith<$Res>  {
  factory $SduiPlantGridItemCopyWith(SduiPlantGridItem value, $Res Function(SduiPlantGridItem) _then) = _$SduiPlantGridItemCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? locationName, SduiAction? action
});


$SduiActionCopyWith<$Res>? get action;

}
/// @nodoc
class _$SduiPlantGridItemCopyWithImpl<$Res>
    implements $SduiPlantGridItemCopyWith<$Res> {
  _$SduiPlantGridItemCopyWithImpl(this._self, this._then);

  final SduiPlantGridItem _self;
  final $Res Function(SduiPlantGridItem) _then;

/// Create a copy of SduiPlantGridItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? locationName = freezed,Object? action = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as SduiAction?,
  ));
}
/// Create a copy of SduiPlantGridItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SduiActionCopyWith<$Res>? get action {
    if (_self.action == null) {
    return null;
  }

  return $SduiActionCopyWith<$Res>(_self.action!, (value) {
    return _then(_self.copyWith(action: value));
  });
}
}


/// Adds pattern-matching-related methods to [SduiPlantGridItem].
extension SduiPlantGridItemPatterns on SduiPlantGridItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SduiPlantGridItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SduiPlantGridItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SduiPlantGridItem value)  $default,){
final _that = this;
switch (_that) {
case _SduiPlantGridItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SduiPlantGridItem value)?  $default,){
final _that = this;
switch (_that) {
case _SduiPlantGridItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? locationName,  SduiAction? action)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SduiPlantGridItem() when $default != null:
return $default(_that.id,_that.name,_that.locationName,_that.action);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? locationName,  SduiAction? action)  $default,) {final _that = this;
switch (_that) {
case _SduiPlantGridItem():
return $default(_that.id,_that.name,_that.locationName,_that.action);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? locationName,  SduiAction? action)?  $default,) {final _that = this;
switch (_that) {
case _SduiPlantGridItem() when $default != null:
return $default(_that.id,_that.name,_that.locationName,_that.action);case _:
  return null;

}
}

}

/// @nodoc


class _SduiPlantGridItem implements SduiPlantGridItem {
  const _SduiPlantGridItem({required this.id, required this.name, this.locationName, this.action});
  

@override final  int id;
@override final  String name;
@override final  String? locationName;
@override final  SduiAction? action;

/// Create a copy of SduiPlantGridItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SduiPlantGridItemCopyWith<_SduiPlantGridItem> get copyWith => __$SduiPlantGridItemCopyWithImpl<_SduiPlantGridItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SduiPlantGridItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,locationName,action);

@override
String toString() {
  return 'SduiPlantGridItem(id: $id, name: $name, locationName: $locationName, action: $action)';
}


}

/// @nodoc
abstract mixin class _$SduiPlantGridItemCopyWith<$Res> implements $SduiPlantGridItemCopyWith<$Res> {
  factory _$SduiPlantGridItemCopyWith(_SduiPlantGridItem value, $Res Function(_SduiPlantGridItem) _then) = __$SduiPlantGridItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? locationName, SduiAction? action
});


@override $SduiActionCopyWith<$Res>? get action;

}
/// @nodoc
class __$SduiPlantGridItemCopyWithImpl<$Res>
    implements _$SduiPlantGridItemCopyWith<$Res> {
  __$SduiPlantGridItemCopyWithImpl(this._self, this._then);

  final _SduiPlantGridItem _self;
  final $Res Function(_SduiPlantGridItem) _then;

/// Create a copy of SduiPlantGridItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? locationName = freezed,Object? action = freezed,}) {
  return _then(_SduiPlantGridItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as SduiAction?,
  ));
}

/// Create a copy of SduiPlantGridItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SduiActionCopyWith<$Res>? get action {
    if (_self.action == null) {
    return null;
  }

  return $SduiActionCopyWith<$Res>(_self.action!, (value) {
    return _then(_self.copyWith(action: value));
  });
}
}

// dart format on
