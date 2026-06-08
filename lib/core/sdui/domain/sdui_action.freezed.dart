// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sdui_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SduiAction {

/// Вид действия (по нему выбирается обработчик).
 SduiActionKind get kind;/// HTTP-метод из дескриптора (метаданные; нативный флоу знает свой путь).
/// Для [SduiActionKind.navigate] не используется — пустая строка.
 String get method;/// Относительный путь из дескриптора (метаданные).
/// Для [SduiActionKind.navigate] не используется — пустая строка.
 String get path;/// Маршрут навигации для [SduiActionKind.navigate] (`target`, напр.
/// `/plants/10` или `/home/register`). `null` для не-навигационных действий.
 String? get target;/// Шаблон тела запроса (свободная форма). Для `log_care` — `plantId`/`type`.
 Map<String, dynamic>? get payload;/// Логические ключи чтений, которые надо инвалидировать после успеха
/// (декларативная инвалидация, MADR-017): `home`/`today`/`plant`.
/// `ActionRunner` маппит каждый ключ в провайдер. Отсутствует → пустой.
 List<String> get invalidates;
/// Create a copy of SduiAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SduiActionCopyWith<SduiAction> get copyWith => _$SduiActionCopyWithImpl<SduiAction>(this as SduiAction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SduiAction&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path)&&(identical(other.target, target) || other.target == target)&&const DeepCollectionEquality().equals(other.payload, payload)&&const DeepCollectionEquality().equals(other.invalidates, invalidates));
}


@override
int get hashCode => Object.hash(runtimeType,kind,method,path,target,const DeepCollectionEquality().hash(payload),const DeepCollectionEquality().hash(invalidates));

@override
String toString() {
  return 'SduiAction(kind: $kind, method: $method, path: $path, target: $target, payload: $payload, invalidates: $invalidates)';
}


}

/// @nodoc
abstract mixin class $SduiActionCopyWith<$Res>  {
  factory $SduiActionCopyWith(SduiAction value, $Res Function(SduiAction) _then) = _$SduiActionCopyWithImpl;
@useResult
$Res call({
 SduiActionKind kind, String method, String path, String? target, Map<String, dynamic>? payload, List<String> invalidates
});




}
/// @nodoc
class _$SduiActionCopyWithImpl<$Res>
    implements $SduiActionCopyWith<$Res> {
  _$SduiActionCopyWithImpl(this._self, this._then);

  final SduiAction _self;
  final $Res Function(SduiAction) _then;

/// Create a copy of SduiAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? method = null,Object? path = null,Object? target = freezed,Object? payload = freezed,Object? invalidates = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SduiActionKind,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,invalidates: null == invalidates ? _self.invalidates : invalidates // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SduiAction].
extension SduiActionPatterns on SduiAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SduiAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SduiAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SduiAction value)  $default,){
final _that = this;
switch (_that) {
case _SduiAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SduiAction value)?  $default,){
final _that = this;
switch (_that) {
case _SduiAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SduiActionKind kind,  String method,  String path,  String? target,  Map<String, dynamic>? payload,  List<String> invalidates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SduiAction() when $default != null:
return $default(_that.kind,_that.method,_that.path,_that.target,_that.payload,_that.invalidates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SduiActionKind kind,  String method,  String path,  String? target,  Map<String, dynamic>? payload,  List<String> invalidates)  $default,) {final _that = this;
switch (_that) {
case _SduiAction():
return $default(_that.kind,_that.method,_that.path,_that.target,_that.payload,_that.invalidates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SduiActionKind kind,  String method,  String path,  String? target,  Map<String, dynamic>? payload,  List<String> invalidates)?  $default,) {final _that = this;
switch (_that) {
case _SduiAction() when $default != null:
return $default(_that.kind,_that.method,_that.path,_that.target,_that.payload,_that.invalidates);case _:
  return null;

}
}

}

/// @nodoc


class _SduiAction implements SduiAction {
  const _SduiAction({required this.kind, this.method = '', this.path = '', this.target, final  Map<String, dynamic>? payload, final  List<String> invalidates = const <String>[]}): _payload = payload,_invalidates = invalidates;
  

/// Вид действия (по нему выбирается обработчик).
@override final  SduiActionKind kind;
/// HTTP-метод из дескриптора (метаданные; нативный флоу знает свой путь).
/// Для [SduiActionKind.navigate] не используется — пустая строка.
@override@JsonKey() final  String method;
/// Относительный путь из дескриптора (метаданные).
/// Для [SduiActionKind.navigate] не используется — пустая строка.
@override@JsonKey() final  String path;
/// Маршрут навигации для [SduiActionKind.navigate] (`target`, напр.
/// `/plants/10` или `/home/register`). `null` для не-навигационных действий.
@override final  String? target;
/// Шаблон тела запроса (свободная форма). Для `log_care` — `plantId`/`type`.
 final  Map<String, dynamic>? _payload;
/// Шаблон тела запроса (свободная форма). Для `log_care` — `plantId`/`type`.
@override Map<String, dynamic>? get payload {
  final value = _payload;
  if (value == null) return null;
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Логические ключи чтений, которые надо инвалидировать после успеха
/// (декларативная инвалидация, MADR-017): `home`/`today`/`plant`.
/// `ActionRunner` маппит каждый ключ в провайдер. Отсутствует → пустой.
 final  List<String> _invalidates;
/// Логические ключи чтений, которые надо инвалидировать после успеха
/// (декларативная инвалидация, MADR-017): `home`/`today`/`plant`.
/// `ActionRunner` маппит каждый ключ в провайдер. Отсутствует → пустой.
@override@JsonKey() List<String> get invalidates {
  if (_invalidates is EqualUnmodifiableListView) return _invalidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invalidates);
}


/// Create a copy of SduiAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SduiActionCopyWith<_SduiAction> get copyWith => __$SduiActionCopyWithImpl<_SduiAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SduiAction&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path)&&(identical(other.target, target) || other.target == target)&&const DeepCollectionEquality().equals(other._payload, _payload)&&const DeepCollectionEquality().equals(other._invalidates, _invalidates));
}


@override
int get hashCode => Object.hash(runtimeType,kind,method,path,target,const DeepCollectionEquality().hash(_payload),const DeepCollectionEquality().hash(_invalidates));

@override
String toString() {
  return 'SduiAction(kind: $kind, method: $method, path: $path, target: $target, payload: $payload, invalidates: $invalidates)';
}


}

/// @nodoc
abstract mixin class _$SduiActionCopyWith<$Res> implements $SduiActionCopyWith<$Res> {
  factory _$SduiActionCopyWith(_SduiAction value, $Res Function(_SduiAction) _then) = __$SduiActionCopyWithImpl;
@override @useResult
$Res call({
 SduiActionKind kind, String method, String path, String? target, Map<String, dynamic>? payload, List<String> invalidates
});




}
/// @nodoc
class __$SduiActionCopyWithImpl<$Res>
    implements _$SduiActionCopyWith<$Res> {
  __$SduiActionCopyWithImpl(this._self, this._then);

  final _SduiAction _self;
  final $Res Function(_SduiAction) _then;

/// Create a copy of SduiAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? method = null,Object? path = null,Object? target = freezed,Object? payload = freezed,Object? invalidates = null,}) {
  return _then(_SduiAction(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SduiActionKind,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,invalidates: null == invalidates ? _self._invalidates : invalidates // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
