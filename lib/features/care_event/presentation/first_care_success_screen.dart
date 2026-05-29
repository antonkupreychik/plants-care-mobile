import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/plant_illustration.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../../plant_card/presentation/plant_card_providers.dart';

/// Экран 33 «Успех первого ухода» (First Care Success) — клиентское
/// празднование, показывается ОДИН раз сразу после записи ПЕРВОГО события
/// ухода растения (детекция в `LogCareEventController.submit`).
///
/// Полноэкранно поверх shell (push на root navigator, без таб-бара) — как
/// PlantCard. Маршрут: `/home/care-success/:plantId?kind=&onTime=`
/// (`name: 'careSuccess'`).
///
/// Данные:
/// - [plantId] / [careKind] / [onTime] приходят из роута (конструктор);
/// - имя растения и `speciesName` (для иллюстрации) экран берёт из
///   `plantDetailProvider(plantId)` (НЕ дублируем провайдер).
///
/// Состояния `plantDetailProvider`:
/// - loading — спокойный лоадер на фоне `primarySoft` (фон/листья уже видны);
/// - error  — деградируем мягко: то же празднование с нейтральным именем
///   («Растение»), уход УЖЕ записан, не показываем как ошибку;
/// - data   — полное празднование.
class FirstCareSuccessScreen extends ConsumerWidget {
  const FirstCareSuccessScreen({
    required this.plantId,
    required this.careKind,
    required this.onTime,
    super.key,
  });

  /// Растение, для которого записан первый уход (ключ `plantDetailProvider`).
  final int plantId;

  /// Тип записанного ухода (water/spray/fertilize; unknown — fallback роута).
  final CareEventKind careKind;

  /// Выполнено ли в срок (как вернул backend). Стрик начинается только в срок.
  final bool onTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final detail = ref.watch(plantDetailProvider(plantId));

    // Празднование рисуем во всех состояниях: уход уже записан успешно, поэтому
    // ошибка детали — не повод показывать стену ошибки. На loading — лоадер
    // вместо центральной колонки, фон/листья остаются.
    return Scaffold(
      backgroundColor: c.primarySoft,
      body: Stack(
        children: [
          const _DecorativeLeaves(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: detail.when(
                    loading: () => Center(
                      child: CircularProgressIndicator(color: c.primary),
                    ),
                    error: (_, _) => _Celebration(
                      plantName:
                          AppLocalizations.of(context).firstCareSuccessFallbackPlantName,
                      speciesName: null,
                      careKind: careKind,
                      onTime: onTime,
                    ),
                    data: (plant) => _Celebration(
                      plantName: plant.name,
                      speciesName: plant.speciesName,
                      careKind: careKind,
                      onTime: onTime,
                    ),
                  ),
                ),
                _Footer(onReturn: () => context.go('/home')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Центральная колонка празднования: иллюстрация с чек-бейджем, eyebrow,
/// серифный hero-заголовок, speech-bubble и (опционально) чип старта стрика.
class _Celebration extends StatelessWidget {
  const _Celebration({
    required this.plantName,
    required this.speciesName,
    required this.careKind,
    required this.onTime,
  });

  final String plantName;
  final String? speciesName;
  final CareEventKind careKind;
  final bool onTime;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PlantWithBadge(speciesName: speciesName),
            const SizedBox(height: 22),
            Text(
              l10n.firstCareSuccessEyebrow.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.96, // 0.08em @ 12px
                color: c.primary,
              ),
            ),
            const SizedBox(height: 6),
            _HeroTitle(plantName: plantName, careKind: careKind),
            const SizedBox(height: 14),
            _SpeechBubble(text: l10n.firstCareSuccessBubble),
            if (onTime) ...[
              const SizedBox(height: 22),
              _StreakChip(label: l10n.firstCareSuccessStreakDayOne),
            ],
          ],
        ),
      ),
    );
  }
}

/// Иллюстрация вида с круглым чек-бейджем (primary, белый чек) в нижне-правом
/// углу — кольцо `primarySoft` + мягкая тень, как в дизайне.
class _PlantWithBadge extends StatelessWidget {
  const _PlantWithBadge({required this.speciesName});

  final String? speciesName;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;

    return SizedBox(
      width: 176,
      height: 176,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          PlantIllustration(speciesName: speciesName, size: 160),
          Positioned(
            right: -2,
            bottom: 0,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: c.primary,
                shape: BoxShape.circle,
                border: Border.all(color: c.primarySoft, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.20),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.check_rounded,
                size: 28,
                color: c.surface,
                semanticLabel: AppLocalizations.of(context)
                    .firstCareSuccessEyebrow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Серифный hero-заголовок: имя растения + акцентный глагол ухода (курсив,
/// цвет primary). Род глагола зафиксирован формой дизайна по типу ухода
/// (грамматический род клички недоступен на клиенте — косметика).
class _HeroTitle extends StatelessWidget {
  const _HeroTitle({required this.plantName, required this.careKind});

  final String plantName;
  final CareEventKind careKind;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    // Для распознанных типов разбиваем «{имя} {глагол}» на rich-text, чтобы
    // выделить глагол курсивом/цветом. Для unknown — единая строка целиком
    // (структура «{имя} — уход отмечен» не делится естественно).
    final base = AppTheme.serif(fontSize: 40, color: c.ink);

    final String? verb = switch (careKind) {
      CareEventKind.water => l10n.firstCareSuccessVerbWater,
      CareEventKind.spray => l10n.firstCareSuccessVerbSpray,
      CareEventKind.fertilize => l10n.firstCareSuccessVerbFertilize,
      CareEventKind.unknown => null,
    };

    if (verb == null) {
      return Text(
        l10n.firstCareSuccessTitleGeneric(plantName),
        textAlign: TextAlign.center,
        style: base,
      );
    }

    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: '$plantName '),
          TextSpan(
            text: verb,
            style: AppTheme.serif(
              fontSize: 40,
              fontStyle: FontStyle.italic,
              color: c.primary,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Speech-bubble: полупрозрачная белая «таблетка» с курсивной серифной
/// репликой растения.
class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: DecoratedBox(
        decoration: BoxDecoration(
          // Полупрозрачный белый поверх primarySoft (в тёмной теме оттенок
          // другой, но прозрачность даёт корректный визуальный слой).
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTheme.serif(
              fontSize: 19,
              fontStyle: FontStyle.italic,
              color: c.ink,
            ).copyWith(height: 1.4),
          ),
        ),
      ),
    );
  }
}

/// Чип старта стрика: тёмная (`ink`) «таблетка» со светлым текстом. Рисуется
/// только при `onTime == true` (поздний первый уход стрик не начинает).
class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.ink,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: c.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Низ экрана: generic-строка ободрения (БЕЗ счётчика дней, G19) и
/// full-width CTA «Вернуться в сад».
class _Footer extends StatelessWidget {
  const _Footer({required this.onReturn});

  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.firstCareSuccessNextHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: onReturn,
            style: FilledButton.styleFrom(
              backgroundColor: c.ink,
              foregroundColor: c.surface,
              minimumSize: const Size.fromHeight(56),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(l10n.firstCareSuccessCta),
          ),
        ],
      ),
    );
  }
}

/// Декоративные листья на фоне (верхне-право + нижне-лево, opacity ~0.18,
/// `leafDark`). Чисто декоративный, не перехватывает тапы. Перенос мотива из
/// `screens-v9.jsx` `FirstWaterSuccessScreen`.
class _DecorativeLeaves extends StatelessWidget {
  const _DecorativeLeaves();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Positioned.fill(
      child: IgnorePointer(
        // Прозрачность запекаем в цвет пейнтера, а не через Opacity (тот форсит
        // offscreen-буфер) — как в DecorativeLeaves сада.
        child: CustomPaint(painter: _LeavesPainter(c.leafDark)),
      ),
    );
  }
}

class _LeavesPainter extends CustomPainter {
  const _LeavesPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: 0.18);

    // Верхне-правый лист.
    canvas.save();
    canvas.translate(size.width - 40, 60);
    canvas.rotate(30 * math.pi / 180);
    canvas.drawPath(_leaf(scale: 1.1), fill);
    canvas.restore();

    // Нижне-левый лист (зеркально повёрнут).
    canvas.save();
    canvas.translate(48, size.height - 60);
    canvas.rotate(-150 * math.pi / 180);
    canvas.drawPath(_leaf(scale: 1.1), fill);
    canvas.restore();
  }

  /// Силуэт листа (кривые Безье) из дизайна, масштабируемый.
  Path _leaf({required double scale}) {
    double v(double x) => x * scale;
    return Path()
      ..moveTo(v(0), v(0))
      ..cubicTo(v(-40), v(-20), v(-60), v(-80), v(-50), v(-140))
      ..cubicTo(v(-10), v(-150), v(40), v(-100), v(50), v(-40))
      ..cubicTo(v(50), v(-20), v(30), v(0), v(0), v(0))
      ..close();
  }

  @override
  bool shouldRepaint(covariant _LeavesPainter old) => old.color != color;
}
