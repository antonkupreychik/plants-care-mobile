import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/notification_type.dart';

/// Визуальная проекция [NotificationType] → иконка, акцентный цвет и
/// локализованная метка категории. Цвета берутся из дизайн-токенов
/// ([PcColors]) по месту использования — этот объект только маршрутизирует
/// выбор, не хранит цвета (чтобы не зависеть от темы здесь).
///
/// Соответствие дизайну экрана 24 (`screens-v6.jsx`):
/// - care   → лист, бренд-зелёный;
/// - alert  → восклицание, terracotta (жажда/просрочка);
/// - award  → галочка-награда, бренд-зелёный (стрик/достижение);
/// - report → диаграмма, soft-зелёный;
/// - system → инфо, нейтральный inkSoft.
@immutable
class NotificationTypeVisual {
  const NotificationTypeVisual._(this.icon, this._accent, this._softBg);

  final IconData icon;
  final Color Function(PcColors c) _accent;
  final Color Function(PcColors c) _softBg;

  /// Акцентный цвет иконки/индикатора непрочитанного для данного типа.
  Color accent(PcColors c) => _accent(c);

  /// Мягкий фон под иконкой-аватаром уведомления.
  Color softBackground(PcColors c) => _softBg(c);

  static NotificationTypeVisual of(NotificationType type) => switch (type) {
        NotificationType.care => NotificationTypeVisual._(
            Icons.eco_rounded,
            (c) => c.primary,
            (c) => c.primarySoft,
          ),
        NotificationType.alert => NotificationTypeVisual._(
            Icons.priority_high_rounded,
            (c) => c.terracotta,
            (c) => c.terracotta.withValues(alpha: 0.16),
          ),
        NotificationType.award => NotificationTypeVisual._(
            Icons.emoji_events_rounded,
            (c) => c.primary,
            (c) => c.primarySoft,
          ),
        NotificationType.report => NotificationTypeVisual._(
            Icons.insights_rounded,
            (c) => c.leaf,
            (c) => c.surfaceWarm,
          ),
        NotificationType.system => NotificationTypeVisual._(
            Icons.info_outline_rounded,
            (c) => c.inkSoft,
            (c) => c.surfaceWarm,
          ),
      };

  /// Локализованная метка категории (overline в карточке + семантика).
  static String label(AppLocalizations l10n, NotificationType type) =>
      switch (type) {
        NotificationType.care => l10n.notificationsTypeCare,
        NotificationType.alert => l10n.notificationsTypeAlert,
        NotificationType.award => l10n.notificationsTypeAward,
        NotificationType.report => l10n.notificationsTypeReport,
        NotificationType.system => l10n.notificationsTypeSystem,
      };
}
