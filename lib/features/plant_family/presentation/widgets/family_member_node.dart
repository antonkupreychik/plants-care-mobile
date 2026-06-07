import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';

/// Один узел родословной: квадратная плашка-аватар с инициалом + имя + подпись
/// роли. Тап (если [onTap] задан) ведёт в карточку этого растения — так
/// делается многоуровневый обход семьи. Текущее растение ([isCurrent]) и
/// «пустой» плейсхолдер ([isPlaceholder]) рисуются иначе и не кликабельны.
class FamilyMemberNode extends StatelessWidget {
  const FamilyMemberNode({
    super.key,
    required this.name,
    required this.roleLabel,
    this.onTap,
    this.isCurrent = false,
    this.isPlaceholder = false,
  });

  /// Имя растения (для плейсхолдера — «?»).
  final String name;

  /// Подпись роли под именем (родитель / росток / это растение).
  final String roleLabel;

  /// Навигация в карточку узла. `null` — узел не кликабелен (текущее растение
  /// или плейсхолдер).
  final VoidCallback? onTap;

  /// Текущее (открытое) растение — выделяется акцентом, без навигации.
  final bool isCurrent;

  /// Пустой узел («?») — будущий отводок, без навигации.
  final bool isPlaceholder;

  static const double _avatarSize = 76;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;

    final avatar = Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        color: isCurrent ? c.primarySoft : c.surfaceWarm,
        borderRadius: BorderRadius.circular(20),
        border: isPlaceholder
            ? Border.all(color: c.primary, width: 2, style: BorderStyle.solid)
            : (isCurrent ? Border.all(color: c.primary, width: 2) : null),
      ),
      alignment: Alignment.center,
      child: Text(
        isPlaceholder ? '?' : _initial(name),
        style: AppTheme.serif(
          fontSize: 30,
          color: isPlaceholder ? c.inkSoft : c.ink,
        ),
      ),
    );

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        const SizedBox(height: 6),
        SizedBox(
          width: 96,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.serif(
              fontSize: 16,
              color: isPlaceholder ? c.primary : c.ink,
              fontStyle:
                  isPlaceholder ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          roleLabel,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: c.inkSoft),
        ),
      ],
    );

    if (onTap == null) return column;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Semantics(
          button: true,
          label: '$name, $roleLabel',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: column,
          ),
        ),
      ),
    );
  }

  /// Первая буква имени (заглавная) для аватара; пусто → нейтральный знак.
  static String _initial(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '·';
    return trimmed.characters.first.toUpperCase();
  }
}
