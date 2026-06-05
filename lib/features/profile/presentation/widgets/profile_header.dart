import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/profile_summary.dart';
import 'profile_avatar.dart';

/// Шапка экрана «Я» (экран 13): аватар + имя + email (если есть) + «С нами с …».
///
/// Имя: [ProfileSummary.name] или «Пользователь» (анонимный). Дата регистрации
/// форматируется как `MMM yyyy` в локали приложения.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.summary});

  final ProfileSummary summary;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final memberSince = DateFormat.yMMM(l10n.localeName)
        .format(summary.createdAt.toLocal());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileAvatar(initial: summary.initial, url: summary.avatar),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                summary.name ?? l10n.profileAnonymous,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: c.ink,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (summary.email != null) ...[
                const SizedBox(height: 2),
                Text(
                  summary.email!,
                  style: TextStyle(fontSize: 13, color: c.inkSoft),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 2),
              Text(
                l10n.profileMemberSince(memberSince),
                style: TextStyle(fontSize: 13, color: c.inkMute),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
