import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../profile/presentation/me_provider.dart';

/// Баннер конвертации гостевого аккаунта.
///
/// Показывается на Home-экране если `isGuest == true` в `GET /api/v1/me`.
/// Тап → `/profile/convert-guest`.
///
/// Тихо скрывается при загрузке, ошибке или `isGuest == false`.
class GuestBanner extends ConsumerWidget {
  const GuestBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuestAsync = ref.watch(meIsGuestProvider);

    // Показываем баннер только если явно isGuest == true.
    final isGuest = isGuestAsync.value == true;
    if (!isGuest) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return GuestBannerCard(
      title: l10n.guestBannerTitle,
      subtitle: l10n.guestBannerSubtitle,
      onTap: () => context.push('/profile/convert-guest'),
    );
  }
}

/// Визуал гостевого баннера, переиспользуемый и нативным [GuestBanner], и
/// SDUI-рендерером блока `guest_banner` (MADR-017): тексты приходят
/// параметрами (нативно — из l10n, SDUI — резолвер по ключам), CTA — [onTap].
class GuestBannerCard extends StatelessWidget {
  const GuestBannerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: c.surfaceWarm,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.primary.withValues(alpha: 0.2)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.save_outlined, size: 22, color: c.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: c.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.guestBannerAction,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: c.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
