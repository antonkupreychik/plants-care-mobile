import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/sdui_screen_layout.dart';
import 'block_registry.dart';

/// Рендерер серверного лейаута (MADR-015): проходит [SduiScreenLayout.blocks]
/// по порядку и для каждого зовёт [BlockRegistry]. Нераспознанные блоки сюда не
/// доходят (репозиторий их отфильтровал) — но даже если дойдёт, registry
/// отрисует его в [SizedBox.shrink] (graceful degradation).
///
/// Сам по себе невидим как состояние (loading/error/offline даёт обёртка
/// экрана) — это «тело» контента.
class ScreenLayoutView extends ConsumerWidget {
  const ScreenLayoutView({super.key, required this.layout});

  final SduiScreenLayout layout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final block in layout.blocks)
          BlockRegistry.build(context, ref, block),
      ],
    );
  }
}
