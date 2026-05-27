import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcate_mobile/app.dart';
import 'package:plantcate_mobile/core/env/app_config.dart';

void main() {
  testWidgets('Первый экран рендерится с проброшенным конфигом', (tester) async {
    const config = AppConfig(
      flavor: Flavor.dev,
      apiUrl: 'https://example.test',
      chatId: '9000001',
      userId: '1',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(config)],
        child: const PlantCateApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('PlantCate'), findsOneWidget);
    expect(find.text('Сборка работает'), findsOneWidget);
    expect(find.text('dev'), findsOneWidget);
  });
}
