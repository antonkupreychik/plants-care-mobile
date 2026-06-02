# Social Sign-In setup (Google / Apple)

Скаффолд социального входа собран с **placeholder-credentials**. Реальных
OAuth-ключей в репозитории нет. Этот документ — точный список внешних шагов и
мест замены placeholder'ов, чтобы вход заработал.

Архитектура (Dart): нативные SDK скрыты за `SocialSignIn`
(`lib/features/auth/domain/social_sign_in.dart`), реализация —
`SocialSignInImpl` (`lib/features/auth/data/social_sign_in_impl.dart`).
`AuthRepository.signInWithGoogle()/signInWithApple()` обменивают токен провайдера
на пару JWT через `POST /auth/google` и `POST /auth/apple`. client ID приходят
через `--dart-define` → `AppConfig.googleServerClientId` / `googleIosClientId`.

---

## 1. Google Cloud Console — OAuth client ID

Нужны **три** OAuth client ID в одном проекте Google Cloud
(APIs & Services → Credentials):

1. **Web application** client → его ID = `serverClientId`.
   Именно под него Google выпускает `id_token`, который проверяет backend
   (audience). Используется на **обеих** платформах (на Android — единственный
   нужный).
2. **iOS** client (Bundle ID = `PRODUCT_BUNDLE_IDENTIFIER` приложения) → его ID =
   iOS client ID.
3. **Android** client (package name + SHA-1 отпечаток подписи debug/release).
   google-services.json для google_sign_in 7.x (Credential Manager) **не
   обязателен** — Android использует `serverClientId`. Android client ID нужен,
   чтобы Google связал ваш APK с проектом по SHA-1.

SHA-1 для Android client:
```
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```
(для релиза — отпечаток вашего release-keystore).

### Куда подставить значения Google

| Значение | Куда |
| --- | --- |
| Web client ID (serverClientId) | `--dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>.apps.googleusercontent.com` |
| iOS client ID | `--dart-define=GOOGLE_IOS_CLIENT_ID=<ios-client-id>.apps.googleusercontent.com` **и** `ios/Runner/Info.plist` → ключ `GIDClientID` |
| iOS client ID (reversed) | `ios/Runner/Info.plist` → `CFBundleURLTypes` → схема `com.googleusercontent.apps.<ios-client-id>` |
| Android SHA-1 + package | Android OAuth client в Google Cloud |

### Placeholder'ы в репозитории (заменить)

- `ios/Runner/Info.plist`:
  - `GIDClientID` = `TODO_REPLACE_IOS_CLIENT_ID.apps.googleusercontent.com`
  - URL-схема `com.googleusercontent.apps.TODO_REPLACE` (второй dict в
    `CFBundleURLTypes`; **не трогать** первую схему `plantcare` — это deep link
    magic-link входа).

Пример запуска с реальными значениями:
```
flutter run \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=123-web.apps.googleusercontent.com \
  --dart-define=GOOGLE_IOS_CLIENT_ID=123-ios.apps.googleusercontent.com
```

---

## 2. Apple — Sign in with Apple (iOS-only)

1. В Apple Developer аккаунте: для App ID приложения включить capability
   **Sign in with Apple** (Certificates, Identifiers & Profiles → Identifiers →
   ваш App ID → Capabilities).
2. Файл прав уже создан: `ios/Runner/Runner.entitlements` с
   `com.apple.developer.applesignin = [Default]`.
3. **Подключить entitlements к target Runner** (в репозитории НЕ прописано в
   `project.pbxproj`, чтобы не сломать сборку — сделать вручную):
   - в Xcode открыть `ios/Runner.xcworkspace`, target **Runner** →
     **Signing & Capabilities** → **+ Capability** → **Sign in with Apple**.
     Xcode сам пропишет `CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements`.
   - либо вручную выставить `CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements`
     для debug- и release-конфигураций target Runner.

Для iOS этого достаточно (без Service ID / возврата на web). Android Apple-вход
не поддерживается — кнопка Apple показывается только на `Platform.isIOS`.

---

## 3. Android — minSdk

google_sign_in 7.x использует Credential Manager (требует **minSdk ≥ 23**).
Проект на `flutter.minSdkVersion = 24` (Flutter 3.44) — порог соблюдён, менять
`android/app/build.gradle.kts` не нужно. Если в будущем minSdk понизят ниже 23 —
Google-вход на Android перестанет работать.

---

## Чек-лист замены placeholder'ов

- [ ] `--dart-define=GOOGLE_SERVER_CLIENT_ID=…` (web client)
- [ ] `--dart-define=GOOGLE_IOS_CLIENT_ID=…` (iOS client)
- [ ] `ios/Runner/Info.plist` → `GIDClientID` (iOS client)
- [ ] `ios/Runner/Info.plist` → URL-схема `com.googleusercontent.apps.…`
      (reversed iOS client)
- [ ] Android OAuth client с SHA-1 в Google Cloud
- [ ] Apple App ID: capability «Sign in with Apple»
- [ ] Xcode: подключить `Runner.entitlements` к target Runner
