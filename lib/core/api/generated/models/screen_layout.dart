// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'block.dart';

part 'screen_layout.g.dart';

/// Декларативный лейаут одного экрана (Server-Driven UI, MADR-015).
/// Список `blocks` упорядочен — клиент рендерит блоки сверху вниз.
///
@JsonSerializable()
class ScreenLayout {
  const ScreenLayout({
    required this.screenId,
    required this.version,
    required this.blocks,
  });
  
  factory ScreenLayout.fromJson(Map<String, Object?> json) => _$ScreenLayoutFromJson(json);
  
  /// Идентификатор экрана (например, `home`).
  final String screenId;

  /// Версия структуры лейаута для данного экрана.
  final int version;

  /// Упорядоченный список блоков экрана.
  final List<Block> blocks;

  Map<String, Object?> toJson() => _$ScreenLayoutToJson(this);
}
