import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/notification_item.dart';
import 'notification_type_visual.dart';

/// Карточка одного уведомления ленты (экран 24).
///
/// Слева — иконка-аватар с акцентом по [NotificationType]. Заголовок «голосом
/// растения», тело, overline-категория и время (час:минута в локальной TZ из
/// `createdAt.toLocal()` — приведение делает UI). Непрочитанное визуально
/// выделено: заливка surface + акцентная точка слева от заголовка.
///
/// Тап по непрочитанному вызывает [onTap] (контроллер делает `markRead`).
/// Прочитанные не интерактивны (deep-link на растение в этой итерации не
/// делаем — роута на карточку из ленты нет в контракте).
class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.item, required this.onTap});

  final NotificationItem item;

  /// Колбэк тапа по непрочитанному уведомлению (`markRead`). Не вызывается для
  /// уже прочитанных (карточка для них не интерактивна).
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final visual = NotificationTypeVisual.of(item.type);
    final unread = !item.isRead;

    final timeLabel = DateFormat.Hm(l10n.localeName).format(
      item.createdAt.toLocal(),
    );
    final categoryLabel = NotificationTypeVisual.label(l10n, item.type);

    final semanticLabel = unread
        ? '${l10n.notificationsUnreadSemantic}. $categoryLabel. '
            '${item.title}. ${item.body}'
        : '$categoryLabel. ${item.title}. ${item.body}';

    final card = Container(
      decoration: BoxDecoration(
        // Непрочитанные — на surface с акцентной рамкой; прочитанные тише
        // (тёплый фон без рамки), как на дизайне.
        color: unread ? c.surface : c.surfaceWarm.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unread
              ? visual.accent(c).withValues(alpha: 0.35)
              : c.line,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(visual: visual),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleRow(
                  title: item.title,
                  timeLabel: l10n.notificationsTimeAt(timeLabel),
                  unread: unread,
                  accent: visual.accent(c),
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.4,
                    color: unread ? c.inkSoft : c.inkMute,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categoryLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: c.inkMute,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!unread) {
      return Semantics(label: semanticLabel, child: card);
    }

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: card),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.visual});

  final NotificationTypeVisual visual;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: visual.softBackground(c),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(visual.icon, size: 22, color: visual.accent(c)),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({
    required this.title,
    required this.timeLabel,
    required this.unread,
    required this.accent,
  });

  final String title;
  final String timeLabel;
  final bool unread;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (unread) ...[
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
              height: 1.25,
              color: c.ink,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Text(
            timeLabel,
            style: TextStyle(fontSize: 11.5, color: c.inkMute),
          ),
        ),
      ],
    );
  }
}
