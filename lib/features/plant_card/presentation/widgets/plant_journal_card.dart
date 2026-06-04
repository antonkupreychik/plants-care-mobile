import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/care_history_entry.dart';
import '../care_event_kind_l10n.dart';

/// Секция «Дневник ухода»: лента истории ([CareHistoryEntry]).
///
/// Записи приходят отсортированными backend — порядок не меняем. Время
/// `performedAt` приходит в UTC, показываем в локальной TZ (`.toLocal()`).
///
/// Пустой список → экран 31 «Пустой дневник»: speech-bubble от растения
/// («Жду первого ухода…») + CTA «Полить сейчас». [onWaterNow] вызывается при
/// тапе на CTA — открывает sheet (экран 06) с предвыбором [CareEventKind.water].
/// Если [onWaterNow] равен `null` — CTA не отображается (безопасный дефолт).
class PlantJournalCard extends StatelessWidget {
  const PlantJournalCard({
    super.key,
    required this.entries,
    this.onWaterNow,
  });

  final List<CareHistoryEntry> entries;

  /// Колбэк CTA «Полить сейчас» (экран 31). Если `null` — кнопка скрыта.
  final VoidCallback? onWaterNow;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    if (entries.isEmpty) {
      return _JournalShell(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
          child: Column(
            children: [
              // Speech bubble: голос растения от первого лица (экран 31).
              _SpeechBubble(text: l10n.plantCardJournalEmptyBubble),
              const SizedBox(height: 16),
              Text(
                l10n.plantCardJournalEmptyHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
              ),
              if (onWaterNow != null) ...[
                const SizedBox(height: 20),
                _WaterNowButton(
                  label: l10n.plantCardJournalWaterNow,
                  onPressed: onWaterNow!,
                ),
              ],
            ],
          ),
        ),
      );
    }

    return _JournalShell(
      child: Column(
        children: List.generate(entries.length, (i) {
          return _JournalRow(entry: entries[i], showDivider: i > 0);
        }),
      ),
    );
  }
}

/// Skeleton секции дневника (loading).
class PlantJournalCardSkeleton extends StatelessWidget {
  const PlantJournalCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _JournalShell(
      child: Column(
        children: [
          _JournalRowSkeleton(),
          SizedBox(height: 16),
          _JournalRowSkeleton(),
          SizedBox(height: 16),
          _JournalRowSkeleton(),
        ],
      ),
    );
  }
}

class _JournalShell extends StatelessWidget {
  const _JournalShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: child,
    );
  }
}

class _JournalRow extends StatelessWidget {
  const _JournalRow({required this.entry, required this.showDivider});

  final CareHistoryEntry entry;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final local = entry.performedAt.toLocal();
    final dateLabel = l10n.plantCardHistoryDate(
      DateFormat.MMMd(l10n.localeName).format(local),
      DateFormat.Hm(l10n.localeName).format(local),
    );

    return Column(
      children: [
        if (showDivider) Divider(height: 1, color: c.line),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(entry.kind.icon, size: 16, color: c.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            entry.kind.doneLabel(l10n),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: c.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateLabel,
                          style: TextStyle(fontSize: 11, color: c.inkSoft),
                        ),
                      ],
                    ),
                    if (entry.onTime) ...[
                      const SizedBox(height: 4),
                      _OnTimeBadge(label: l10n.plantCardJournalOnTime),
                    ],
                    if (entry.note != null && entry.note!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        entry.note!,
                        style: TextStyle(
                          fontSize: 12,
                          color: c.inkSoft,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnTimeBadge extends StatelessWidget {
  const _OnTimeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 12, color: c.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalRowSkeleton extends StatelessWidget {
  const _JournalRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(width: 32, height: 32, radius: 16),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 120, height: 13),
              SizedBox(height: 6),
              SkeletonBox(width: 80, height: 11),
            ],
          ),
        ),
      ],
    );
  }
}

/// Speech-bubble от растения (экран 31 «Пустой дневник»).
///
/// Голос от первого лица, серифный акцент (Instrument Serif italic) — как в
/// экране 33 «Успех первого ухода» (дизайн-конвенция voice line).
/// Хвост bubble нарисован через [CustomPainter] снизу по центру.
class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: c.primarySoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTheme.serif(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              color: c.ink,
            ),
          ),
        ),
        // Хвост bubble — указатель вниз.
        CustomPaint(
          size: const Size(20, 10),
          painter: _BubbleTailPainter(color: c.primarySoft),
        ),
      ],
    );
  }
}

/// Рисует треугольный хвост speech-bubble вниз по центру.
class _BubbleTailPainter extends CustomPainter {
  const _BubbleTailPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BubbleTailPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// CTA «Полить сейчас» для пустого дневника (экран 31).
class _WaterNowButton extends StatelessWidget {
  const _WaterNowButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.primary,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.water_drop_outlined, size: 18, color: c.fabInk),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.fabInk,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
