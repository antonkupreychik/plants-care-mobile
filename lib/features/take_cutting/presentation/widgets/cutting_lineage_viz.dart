import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
// Переиспользуем общую иллюстрацию вида из home/presentation — тот же осознанный
// precedent зависимости на опубликованный виджет другой фичи, что и в
// контроллерах (зависим от объявления, не от внутренней верстки экрана).
import '../../../home/presentation/plant_illustration.dart';

/// Визуализация связи родитель → росток (экран 18).
///
/// Слева — карточка родителя (иллюстрация вида + имя + «Родитель»), по центру —
/// пунктирная стрелка с эмодзи 🌱, справа — карточка ростка (пунктирная рамка,
/// `?` serif + имя/«Имя?» italic primary + «Росток»).
class CuttingLineageViz extends StatelessWidget {
  const CuttingLineageViz({
    super.key,
    required this.parentName,
    required this.parentSpeciesName,
    required this.childName,
  });

  /// Имя родителя (null → деталь грузится, показываем плейсхолдер).
  final String? parentName;

  /// Вид родителя — для выбора SVG-иллюстрации.
  final String? parentSpeciesName;

  /// Введённое имя ростка (null/пусто → «Имя?»).
  final String? childName;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Родитель.
          _LineageNode(
            label: l10n.takeCuttingParentLabel,
            name: parentName ?? '…',
            nameItalic: false,
            nameColor: c.ink,
            avatar: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: c.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: PlantIllustration(speciesName: parentSpeciesName, size: 64),
            ),
          ),

          // Стрелка-связь с эмодзи.
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: _LineageArrow(),
          ),

          // Росток.
          _LineageNode(
            label: l10n.takeCuttingChildLabel,
            name: (childName != null && childName!.trim().isNotEmpty)
                ? childName!.trim()
                : l10n.takeCuttingChildNamePlaceholder,
            nameItalic: true,
            nameColor: c.primary,
            avatar: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: c.surfaceWarm,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: c.primary,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '?',
                style: AppTheme.serif(fontSize: 32, color: c.inkSoft),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineageNode extends StatelessWidget {
  const _LineageNode({
    required this.avatar,
    required this.name,
    required this.label,
    required this.nameItalic,
    required this.nameColor,
  });

  final Widget avatar;
  final String name;
  final String label;
  final bool nameItalic;
  final Color nameColor;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          avatar,
          const SizedBox(height: 6),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTheme.serif(fontSize: 16, color: nameColor).copyWith(
              fontStyle: nameItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: c.inkSoft),
          ),
        ],
      ),
    );
  }
}

/// Пунктирная дугообразная стрелка с эмодзи 🌱 над ней.
class _LineageArrow extends StatelessWidget {
  const _LineageArrow();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return SizedBox(
      width: 50,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(50, 80),
            painter: _ArrowPainter(color: c.primary),
          ),
          Positioned(
            top: 4,
            child: const Text('🌱', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Дуга: M 5 40 Q 25 20 45 40 (как в дизайн-исходнике), масштаб по высоте.
    final midY = size.height / 2;
    final arc = Path()
      ..moveTo(5, midY)
      ..quadraticBezierTo(size.width / 2, midY - 20, size.width - 5, midY);
    _drawDashed(canvas, arc, paint);

    // Наконечник стрелки справа.
    final head = Path()
      ..moveTo(size.width - 12, midY - 5)
      ..lineTo(size.width - 5, midY)
      ..lineTo(size.width - 12, midY + 5);
    canvas.drawPath(head, paint);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    const dash = 3.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) => oldDelegate.color != color;
}
