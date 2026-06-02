import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

/// Корневой виджет. Тема переключается по системной (light/dark), навигация —
/// через go_router (MADR-005), роутер берётся из `appRouterProvider` (keepAlive,
/// с router-guard по auth-статусу — MADR-008). Локализация — один локаль `ru`
/// (MADR-012), все UI-строки через `AppLocalizations`.
///
/// Deep links magic-link входа (MADR-008): слушаем custom-схему
/// `plantcare://auth/verify?token=…` через [AppLinks] (и cold-start, и warm)
/// и роутим на `/auth/verify`. Формат ссылки задаёт backend
/// (см. docs/BACKEND-GAPS.md); в dev флоу проверяется через ручной ввод токена
/// на verify-экране.
class PlantCareApp extends ConsumerStatefulWidget {
  const PlantCareApp({super.key});

  @override
  ConsumerState<PlantCareApp> createState() => _PlantCareAppState();
}

class _PlantCareAppState extends ConsumerState<PlantCareApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    // uriLinkStream отдаёт и стартовую ссылку (cold start), и последующие.
    _linkSub = _appLinks.uriLinkStream.listen(_handleDeepLink);
  }

  /// Magic-link из письма: `plantcare://auth/verify?token=<opaque>`. Толерантно
  /// к host/path (формат бэкенда уточняется) — реагируем на любую ссылку нашей
  /// схемы с непустым `token`, отдавая токен verify-экрану через роутер-гард.
  void _handleDeepLink(Uri uri) {
    if (uri.scheme != 'plantcare') return;
    final token = uri.queryParameters['token'];
    if (token == null || token.isEmpty) return;
    ref.read(appRouterProvider).go('/auth/verify?token=$token');
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
