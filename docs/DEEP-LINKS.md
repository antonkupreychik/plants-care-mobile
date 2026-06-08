# Deep Links — настройка и верификация (issue #127)

Приложение поддерживает два вида входящих ссылок:

| Тип | Формат | Статус |
|---|---|---|
| Custom scheme | `plantcare://auth/verify?token=…` | Работает без хост-файлов |
| Universal Links | `https://plants-care.up.railway.app/…` | Требует хост-файлы на сервере |

---

## 1. Custom scheme (уже работает)

`plantcare://auth/verify?token=<opaque>` — захватывается `app_links`, роутится
на `/auth/verify`. Настроено в `android/app/src/main/AndroidManifest.xml`
(intent-filter `scheme=plantcare`) и `ios/Runner/Info.plist` (`CFBundleURLTypes`).
Не требует верификации домена.

---

## 2. Universal Links (требуют деплоя на сервер)

Поддерживаемые пути:
- `https://plants-care.up.railway.app/auth/verify?token=…` — magic-link вход
- `https://plants-care.up.railway.app/plants/:id` — открыть карточку растения

### 2.1 Клиентская часть (уже в PR #127)

**Android** (`android:autoVerify="true"` в `AndroidManifest.xml`):
- Добавлены intent-filter'ы для `scheme=https`, `host=plants-care.up.railway.app`,
  путей `/auth/verify` и `/plants/.*`.
- Android при установке APK автоматически проверяет `assetlinks.json` на хосте.
  Если файл не найден — ссылки всё равно откроются в браузере (не крашатся).

**iOS** (`applinks:` в `Runner.entitlements`):
- Добавлен `com.apple.developer.associated-domains` с
  `applinks:plants-care.up.railway.app`.
- iOS при установке проверяет AASA на хосте.
- Capability должна быть активирована в Apple Developer Console
  (Identifiers → App ID → Associated Domains).

### 2.2 Серверная часть (деплой на backend — не в этом PR)

#### Android: `assetlinks.json`

Разместить по адресу:
```
GET https://plants-care.up.railway.app/.well-known/assetlinks.json
```

Содержимое:
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.plantcare.plantcare_mobile",
    "sha256_cert_fingerprints": ["<RELEASE_SHA256_FINGERPRINT>"]
  }
}]
```

Получить SHA-256 release-ключа:
```bash
keytool -list -v -keystore <release.jks> -alias <alias>
# или из Google Play Console: App signing → App signing key certificate
```

MIME-тип ответа: `application/json`.

#### iOS: Apple App Site Association (AASA)

Разместить по адресу (без расширения, `Content-Type: application/json`):
```
GET https://plants-care.up.railway.app/.well-known/apple-app-site-association
```

Содержимое:
```json
{
  "applinks": {
    "details": [{
      "appIDs": ["<TEAM_ID>.com.plantcare.plantcareMobile"],
      "components": [
        { "/": "/auth/verify*" },
        { "/": "/plants/*" }
      ]
    }]
  }
}
```

`TEAM_ID` — 10-символьный Apple Developer Team ID
(Apple Developer Console → Membership → Team ID).

---

## 3. Роутинг входящих ссылок (`lib/app.dart`)

Обработчик `_PlantCareAppState._handleDeepLink` уже маршрутизирует:

| URI | Роутинг в приложении |
|---|---|
| `plantcare://auth/verify?token=X` | `/auth/verify?token=X` |
| `https://<host>/auth/verify?token=X` | `/auth/verify?token=X` |
| `https://<host>/plants/:id` | `/home/plants/:id` |

---

## 4. Smoke-тест (холодный и тёплый старт)

### Android (после деплоя assetlinks.json)

```bash
# Сброс верификации (эмулятор):
adb shell pm set-app-links --package com.plantcare.plantcare_mobile 0 all

# Переустановить APK:
flutter build apk && adb install -r build/app/outputs/flutter-apk/app-release.apk

# Холодный старт по magic-link (https):
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://plants-care.up.railway.app/auth/verify?token=test_token" \
  com.plantcare.plantcare_mobile

# Открыть карточку растения:
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://plants-care.up.railway.app/plants/7" \
  com.plantcare.plantcare_mobile

# Тёплый старт (приложение свёрнуто):
# (запустить приложение, свернуть, выполнить adb-команду выше)
```

Проверить статус верификации:
```bash
adb shell pm get-app-links com.plantcare.plantcare_mobile
# STATUS_VERIFIED — всё работает
```

### iOS (после деплоя AASA)

Открыть Safari на реальном устройстве (не симуляторе):
```
https://plants-care.up.railway.app/auth/verify?token=test_token
https://plants-care.up.railway.app/plants/7
```

Smart Banner или системный диалог должен предложить открыть PlantCare.

На симуляторе:
```bash
xcrun simctl openurl booted \
  "https://plants-care.up.railway.app/auth/verify?token=test_token"
```

---

## 5. Статус

- [x] Android: `autoVerify="true"` + HTTPS intent-filter (PR #127)
- [x] iOS: `applinks:` в entitlements (PR #127)
- [x] Роутинг universal links в `app.dart` (PR #127)
- [ ] `assetlinks.json` на хосте (backend-задача, согласовать с владельцем домена)
- [ ] AASA на хосте (backend-задача, согласовать с владельцем домена)
- [ ] Apple Developer Console: Associated Domains capability для app ID
- [ ] SHA-256 release-ключа в `assetlinks.json` (после финализации signing)
