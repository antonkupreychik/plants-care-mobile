import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Заголовок группы ленты по дням (Сегодня / Вчера / дата) — экран 24.
///
/// Текст уже локализован вызывающим (день/дата считаются на экране из
/// `createdAt.toLocal()`).
class NotificationsGroupHeader extends StatelessWidget {
  const NotificationsGroupHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
          color: c.inkSoft,
        ),
      ),
    );
  }
}
