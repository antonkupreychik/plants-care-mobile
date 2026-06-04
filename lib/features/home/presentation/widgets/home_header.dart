import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../notifications/presentation/notifications_providers.dart';

/// Шапка главного: логотип-лист + название слева, иконки поиск/уведомления
/// справа, ниже — дата и серифное приветствие (без имени пользователя —
/// провайдера профиля пока нет, см. отчёт).
///
/// Когда [isEmptyGarden] == true (новый пользователь без растений) рисуется
/// **упрощённая шапка**: только логотип + иконка профиля. Поиск и колокольчик
/// отсутствуют — пустому саду они незачем (экран 10).
///
/// Колокольчик уведомлений несёт badge с числом непрочитанных
/// ([unreadCountProvider]); скрыт при `0`. Тап → экран 24 ([onNotifications]).
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.now,
    required this.onComingSoon,
    required this.onNotifications,
    required this.onProfile,
    this.isEmptyGarden = false,
  });

  final DateTime now;
  final VoidCallback onComingSoon;

  /// Переход на экран 24 «Лента уведомлений» (тап по колокольчику).
  final VoidCallback onNotifications;

  /// Переход на экран профиля (тап по иконке профиля в упрощённой шапке).
  final VoidCallback onProfile;

  /// Если `true` — шапка упрощённая: только логотип + иконка профиля
  /// (без поиска и колокольчика). Соответствует экрану 10 «Пустой сад».
  final bool isEmptyGarden;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final dateLabel = DateFormat.MMMMEEEEd(l10n.localeName).format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.eco_rounded, size: 20, color: c.surface),
            ),
            const SizedBox(width: 10),
            Text(
              l10n.appTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                color: c.ink,
              ),
            ),
            const Spacer(),
            if (isEmptyGarden)
              _HeaderIconButton(
                icon: Icons.person_outline_rounded,
                tooltip: l10n.homeProfileTooltip,
                onPressed: onProfile,
              )
            else ...[
              _HeaderIconButton(
                icon: Icons.search_rounded,
                tooltip: l10n.homeSearchTooltip,
                onPressed: onComingSoon,
              ),
              const SizedBox(width: 6),
              _NotificationsButton(onPressed: onNotifications),
            ],
          ],
        ),
        const SizedBox(height: 18),
        Text(
          dateLabel.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.homeGreeting,
          style: AppTheme.serif(
            fontSize: 38,
            fontStyle: FontStyle.italic,
            color: c.primary,
          ),
        ),
      ],
    );
  }
}

/// Колокольчик уведомлений с badge числа непрочитанных
/// ([unreadCountProvider]). Badge скрыт при `0`; число «9+» при переполнении.
class _NotificationsButton extends ConsumerWidget {
  const _NotificationsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final unread = ref.watch(unreadCountProvider);
    final tooltip = l10n.notificationsBadgeTooltip(unread);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: c.ink,
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _Badge(count: unread),
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

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final text = count > 9 ? '9+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: c.terracotta,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.surface, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.5,
          height: 1,
          fontWeight: FontWeight.w700,
          color: c.fabInk,
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Icon(icon, size: 20, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}
