import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/sharing_member.dart';

/// Строка соухаживающего в секции «Помогают сейчас» (экран 26).
///
/// Аватар-инициал, контакт, число растений + статус, бейдж статуса
/// (PENDING/ACCEPTED). Неизвестный статус (forward-compat) бейдж не рисует.
class SharingMemberTile extends StatelessWidget {
  const SharingMemberTile({super.key, required this.member});

  final SharingMember member;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final statusText = switch (member.status) {
      SharingMemberStatus.pending => l10n.sharingStatusPending,
      SharingMemberStatus.accepted => l10n.sharingStatusAccepted,
      SharingMemberStatus.unknown => null,
    };
    final plantsText = l10n.sharingMemberPlants(member.plantIds.length);
    final subtitle =
        statusText == null ? plantsText : '$plantsText · $statusText';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          _Avatar(contact: member.contact),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.contact,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: c.inkSoft),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _StatusBadge(status: member.status),
        ],
      ),
    );
  }
}

/// Кружок-аватар с первой буквой контакта.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.contact});

  final String contact;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    // Первый «значимый» символ контакта (пропускаем ведущий @).
    final trimmed = contact.replaceFirst('@', '').trim();
    final initial = trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase();
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: c.leaf,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTheme.serif(fontSize: 18, color: c.surface),
      ),
    );
  }
}

/// Бейдж статуса приглашения. Для [SharingMemberStatus.unknown] — пусто.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SharingMemberStatus status;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final (label, fg, bg) = switch (status) {
      SharingMemberStatus.pending => (
          l10n.sharingBadgePending,
          c.terracotta,
          c.surfaceWarm,
        ),
      SharingMemberStatus.accepted => (
          l10n.sharingBadgeAccepted,
          c.leafDark,
          c.primarySoft,
        ),
      SharingMemberStatus.unknown => (null, c.inkSoft, c.surfaceWarm),
    };
    if (label == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: fg,
        ),
      ),
    );
  }
}
