import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

/// Корневой виджет. Тема переключается по системной (light/dark), навигация —
/// через go_router (MADR-005). Локализация — один локаль `ru` (MADR-012),
/// все UI-строки через `AppLocalizations`.
class PlantCateApp extends StatelessWidget {
  const PlantCateApp({super.key});

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
      routerConfig: appRouter,
    );
  }
}
