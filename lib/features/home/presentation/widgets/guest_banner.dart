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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: _GuestBannerCard(),
    );
  }
}

class _GuestBannerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.push('/profile/convert-guest'),
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
                      l10n.guestBannerTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.guestBannerSubtitle,
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
              Icon(Icons.arrow_forward_ios_rounded, size: 12, color: c.primary),
            ],
          ),
        ),
      ),
    );
  }
}
