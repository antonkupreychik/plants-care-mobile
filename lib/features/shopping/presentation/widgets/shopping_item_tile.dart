import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/shopping_item.dart';

/// Строка списка покупок (экран 19): круглый чекбокс «куплено» + заголовок
/// (зачёркнут, если `checked`) + иконка удаления. Свайп влево — также удаляет.
///
/// Логики нет — только колбэки в контроллер ([onToggle]/[onDelete]).
///
/// [onDelete] возвращает `Future<bool>`: `true` — удаление реально прошло
/// (позиция ушла из state), `false` — ошибка/no-op. Свайп использует это в
/// [Dismissible.confirmDismiss], чтобы при неуспехе **откатить** анимацию и
/// оставить виджет в дереве — иначе оптимистичный откат контроллера приводит к
/// ассерту «dismissed Dismissible is still part of the tree» и рассинхрону.
class ShoppingItemTile extends StatelessWidget {
  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  final ShoppingItem item;
  final VoidCallback onToggle;
  final Future<bool> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      // Удаляем «вручную»: дожидаемся исхода и завершаем свайп только при
      // реальном успехе. При неуспехе возвращаем false → Dismissible откатит
      // анимацию, виджет останется в дереве (синхронно с state контроллера).
      confirmDismiss: (_) => onDelete(),
      background: _DismissBackground(label: l10n.shoppingItemDelete),
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
              child: Row(
                children: [
                  _Checkbox(
                    checked: item.checked,
                    semanticLabel: l10n.shoppingItemToggle,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: item.checked ? c.inkMute : c.ink,
                        decoration: item.checked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: c.inkMute,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  _DeleteButton(
                    tooltip: l10n.shoppingItemDelete,
                    // Иконка идёт тем же путём; исход (снэкбар) обрабатывает
                    // колбэк, результат тут не нужен.
                    onPressed: () => onDelete(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.checked, required this.semanticLabel});

  final bool checked;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      label: semanticLabel,
      checked: checked,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: checked ? c.primary : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: checked ? c.primary : c.inkMute,
            width: 2,
          ),
        ),
        child: checked
            ? Icon(Icons.check_rounded, size: 16, color: c.fabInk)
            : null,
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: c.inkMute,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.terracotta.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 22),
      child: Icon(Icons.delete_outline_rounded, color: c.terracotta, size: 22),
    );
  }
}
