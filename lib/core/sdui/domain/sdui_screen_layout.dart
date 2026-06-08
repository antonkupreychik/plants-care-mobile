import 'package:freezed_annotation/freezed_annotation.dart';

import 'sdui_block.dart';

part 'sdui_screen_layout.freezed.dart';

/// Доменный лейаут экрана (`ScreenLayout` → domain, MADR-015).
///
/// Чистый Dart. [blocks] упорядочены — рендерер рисует их сверху вниз.
/// Нераспознанные типы блоков сюда НЕ попадают (репозиторий их отфильтровал),
/// поэтому presentation может рендерить список без проверок на «неизвестный».
@freezed
abstract class SduiScreenLayout with _$SduiScreenLayout {
  const factory SduiScreenLayout({
    required String screenId,
    required int version,
    required List<SduiBlock> blocks,
  }) = _SduiScreenLayout;
}
