import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Аватар профиля: круг 56×56. Если задан [url] — грузит изображение
/// ([Image.network] с initials-плейсхолдером на время загрузки и при ошибке),
/// иначе сразу показывает initials-плейсхолдер.
///
/// Используется `Image.network`, а не `cached_network_image`: на текущей схеме
/// backend всегда отдаёт `avatar = null` (нет хранилища аватаров), поэтому
/// тянуть пакет ради ещё-не-используемого пути нельзя (FLUTTER.md — пакеты
/// только отдельной задачей). Когда аватары появятся — замена на кеширующий
/// загрузчик будет точечной.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.initial,
    this.url,
    this.size = 56,
  });

  /// Initials-символ (первая буква имени или «?»).
  final String initial;

  /// URL изображения; `null` → только плейсхолдер.
  final String? url;

  final double size;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final placeholder = _Initials(initial: initial, size: size, colors: c);

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: url == null
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => placeholder,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : placeholder,
              ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({
    required this.initial,
    required this.size,
    required this.colors,
  });

  final String initial;
  final double size;
  final PcColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: colors.primarySoft,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
          color: colors.leafDark,
        ),
      ),
    );
  }
}
