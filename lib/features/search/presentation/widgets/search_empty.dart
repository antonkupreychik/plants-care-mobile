import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Пустое состояние экрана поиска (issue #69): иконка + текст-подсказка по
/// центру. Используется и для «введите 2+ символа», и для «ничего не найдено» —
/// различается только [icon] и [message].
class SearchEmpty extends StatelessWidget {
  const SearchEmpty({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: c.inkMute),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: c.inkSoft, height: 1.4),
          ),
        ],
      ),
    );
  }
}
