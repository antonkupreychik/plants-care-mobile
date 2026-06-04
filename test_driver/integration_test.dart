import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

/// Driver для design-check integration test.
/// Сохраняет каждый скриншот в `screenshots/captured/<name>.png` на хосте.
Future<void> main() => integrationDriver(
      onScreenshot: (
        String name,
        List<int> bytes, [
        Map<String, Object?>? args,
      ]) async {
        final dir = Directory('screenshots/captured');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        final file = File('screenshots/captured/$name.png');
        file.writeAsBytesSync(bytes);
        stdout.writeln('[screenshot] saved → ${file.path}');
        return true;
      },
    );
