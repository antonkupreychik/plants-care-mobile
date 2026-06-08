import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/router/deep_link_resolver.dart';
import 'core/theme/app_theme.dart';
import 'features/language/presentation/language_providers.dart';
import 'l10n/app_localizations.dart';

/// Корневой виджет. Тема переключается по системной (light/dark), навигация —
/// через go_router (MADR-005), роутер берётся из `appRouterProvider` (keepAlive,
/// с router-guard по auth-статусу — MADR-008). Локализация — один локаль `ru`
/// (MADR-012), все UI-строки через `AppLocalizations`.
///
/// Deep links (MADR-008, issue #127): слушаем два вида входящих ссылок через
/// [AppLinks] (и cold-start, и warm):
///   1. Custom scheme: `plantcare://auth/verify?token=…` — magic-link вход
///      из письма, роутинг на `/auth/verify`.
///   2. Universal links (HTTPS): `https://plants-care.up.railway.app/auth/verify?token=…`
///      и `https://plants-care.up.railway.app/plants/:id` — открытие приложения
///      напрямую (без браузера) при правильно настроенном хост-файле (issue #127).
///
/// Формат ссылок задаёт backend. Хост-файлы (assetlinks.json, AASA) — на стороне
/// сервера, см. docs/DEEP-LINKS.md.
class PlantCareApp extends ConsumerStatefulWidget {
  const PlantCareApp({super.key});

  @override
  ConsumerState<PlantCareApp> createState() => _PlantCareAppState();
}

class _PlantCareAppState extends ConsumerState<PlantCareApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;
  final _resolver = const DeepLinkResolver();

  @override
  void initState() {
    super.initState();
    // uriLinkStream отдаёт и стартовую ссылку (cold start), и последующие.
    _linkSub = _appLinks.uriLinkStream.listen(_handleDeepLink);
  }

  /// Обрабатывает входящие deep-link / universal-link URI.
  ///
  /// Логика разрешения URI в app-путь — в [DeepLinkResolver] (unit-тестируется).
  /// Неизвестные ссылки игнорируются (resolver возвращает null).
  void _handleDeepLink(Uri uri) {
    final appPath = _resolver.resolve(uri);
    if (appPath != null) {
      ref.read(appRouterProvider).go(appPath);
    }
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // localeProvider хранит выбранный пользователем язык (keepAlive, persisted).
    // .value: в состоянии loading/error возвращает null → fallback к ru.
    final localeAsync = ref.watch(localeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeAsync.value ?? const Locale('ru'),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
