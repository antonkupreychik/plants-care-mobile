import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Резолвер l10n-КЛЮЧЕЙ SDUI-блоков (MADR-017) в локализованные строки.
///
/// Поля `titleKey`/`bodyKey`/`iconKey` опаковых блоков несут КЛЮЧИ, не готовый
/// текст (текст всё равно идёт через [AppLocalizations], MADR-012). Сервер
/// присылает стабильный логический ключ (`home.guest.title`, …), клиент сам
/// решает, какой строкой его отрисовать — так перевод остаётся на клиенте.
///
/// Неизвестный/пустой ключ → пустая строка (разумный фолбэк, не краш):
/// forward-compat, новый ключ от сервера не роняет рендер.
String resolveSduiTextKey(AppLocalizations l10n, String key) => switch (key) {
      'home.guest.title' => l10n.sduiHomeGuestTitle,
      'home.guest.body' => l10n.sduiHomeGuestBody,
      'home.empty.title' => l10n.sduiHomeEmptyTitle,
      'home.empty.body' => l10n.sduiHomeEmptyBody,
      'home.room.empty.title' => l10n.sduiHomeRoomEmptyTitle,
      'home.room.empty.body' => l10n.sduiHomeRoomEmptyBody,
      _ => '',
    };

/// Резолвер l10n-КЛЮЧЕЙ иконок SDUI-блоков (`iconKey`) в [IconData].
/// Неизвестный/пустой ключ → разумный дефолт (`eco`), не краш.
IconData resolveSduiIconKey(String key) => switch (key) {
      'home.empty.icon' => Icons.local_florist_outlined,
      _ => Icons.eco_outlined,
    };
