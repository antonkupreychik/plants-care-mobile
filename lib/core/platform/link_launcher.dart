import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'link_launcher.g.dart';

/// Тонкая обёртка над открытием внешних ссылок (`url_launcher`).
///
/// Вынесена за интерфейс, чтобы presentation/data зависели от абстракции, а
/// не от плагина напрямую: в unit-тестах подменяется fake-реализацией
/// (`url_launcher` бьётся в платформенный канал, в тестовой среде падает).
/// Текущее применение — открытие deep link Telegram-бота на экране 08 входа.
abstract interface class LinkLauncher {
  /// Открыть [url] во внешнем приложении (браузер/Telegram). Возвращает `false`,
  /// если ссылку не удалось открыть (нет приложения-обработчика / некорректный
  /// URL) — наружу не бросает.
  Future<bool> open(String url);
}

/// Реализация поверх `url_launcher`, открывает ссылку в режиме
/// `externalApplication` (системный обработчик: Telegram для `t.me`/`tg:`).
class UrlLauncherLinkLauncher implements LinkLauncher {
  const UrlLauncherLinkLauncher();

  @override
  Future<bool> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Платформенный сбой/нет обработчика — не падаем, сообщаем неуспехом.
      return false;
    }
  }
}

/// DI-точка для [LinkLauncher] (MADR-004). В тестах подменяется override'ом.
@riverpod
LinkLauncher linkLauncher(Ref ref) => const UrlLauncherLinkLauncher();
