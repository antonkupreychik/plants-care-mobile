# Окружение разработки (PlantCate Mobile)

> Заметки про локальную настройку этой машины. Не про архитектуру (это MADR),
> а про то, что нужно, чтобы проект собрался здесь.

## Flutter SDK

Flutter **3.44.0 / Dart 3.12.0** (MADR-001) установлен вне PATH:

```
~/development/flutter
```

Добавить в PATH (постоянно — в `~/.zshrc`):

```bash
export PATH="$HOME/development/flutter/bin:$PATH"
```

Скрипт `run-dev.sh` подхватывает этот путь сам.

## Сборка / запуск

```bash
./run-dev.sh run       # flutter run (dev-flavor) на устройстве/эмуляторе
./run-dev.sh apk       # release APK → build/app/outputs/flutter-apk/app-release.apk
./run-dev.sh install   # собрать + adb install -r
```

Точки входа: `lib/main_dev.dart` / `lib/main_prod.dart` (MADR-010). Конфиг —
через `--dart-define` (API_URL / CHAT_ID / USER_ID). Android productFlavors
(`--flavor`) пока не настроены — сборка идёт через `-t` + `--dart-define`.

## ⚠️ Сетевой обходной путь: Maven Central недоступен

На этой машине/сети **`repo.maven.apache.org` (Maven Central) недоступен** —
TLS-хендшейк обрывается (`SSL_ERROR_SYSCALL` / `Remote host terminated the
handshake`). Доступны github, pub.dev, dl.google.com, plugins.gradle.org и
**полное Google-зеркало Central** на `storage.googleapis.com`.

Без обхода `flutter build apk` падает на резолве Kotlin-плагинов. Настроены
**два** фикса (оба окруженческие, не в репозитории проекта):

1. **`~/.gradle/init.d/plantcate-maven-central-mirror.init.gradle.kts`** —
   переотображает Maven Central → зеркало во всех билдах (`beforeSettings` +
   `allprojects`).
2. **`~/development/flutter/packages/flutter_tools/gradle/settings.gradle.kts`** —
   в included-билд `:gradle` добавлено зеркало **первым** в `pluginManagement`
   (init-скрипт там не помогает: `gradlePluginPortal` хард-фейлит на редиректе
   к Central, а remap по URL редирект не ловит).

Зеркало: `https://maven-central.storage-download.googleapis.com/maven2/`

Если Maven Central снова станет доступен — оба фикса можно удалить без
последствий. ⚠️ Правка #2 в SDK потеряется при `flutter upgrade` / переустановке
SDK — тогда повторить.
