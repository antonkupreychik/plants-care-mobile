import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/offline_state.dart';

Widget _wrap(OfflineState child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  group('OfflineState', () {
    testWidgets('should_render_title_message_banner_and_retry_button',
        (tester) async {
      await tester.pumpWidget(_wrap(OfflineState(
        title: 'Сад на минутку ',
        titleAccent: 'вне зоны',
        message: 'Нет соединения с сервером.',
        retryLabel: 'Повторить',
        bannerTitle: 'Нет связи с садом',
        bannerStatus: 'офлайн',
        onRetry: () {},
      )));
      await tester.pump();

      // Заголовок собран через Text.rich (lead + accent) → ищем по richText.
      expect(
        find.byWidgetPredicate((w) =>
            w is RichText && w.text.toPlainText().contains('вне зоны')),
        findsWidgets,
      );
      expect(find.text('Нет соединения с сервером.'), findsOneWidget);
      expect(find.text('Нет связи с садом'), findsOneWidget);
      expect(find.text('офлайн'), findsOneWidget);
      expect(find.text('Повторить'), findsOneWidget);
    });

    testWidgets('should_invoke_onRetry_when_retry_tapped', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(_wrap(OfflineState(
        title: 'Офлайн',
        message: 'msg',
        retryLabel: 'Повторить',
        onRetry: () => tapped++,
      )));
      await tester.pump();

      await tester.tap(find.text('Повторить'));
      await tester.pump();

      expect(tapped, 1);
    });

    testWidgets('should_expose_retry_as_semantics_button', (tester) async {
      await tester.pumpWidget(_wrap(OfflineState(
        title: 'Офлайн',
        message: 'msg',
        retryLabel: 'Повторить',
        onRetry: () {},
      )));
      await tester.pump();

      // Кнопка retry обёрнута в Semantics(button) с лейблом — иначе
      // assistive-tech не распознает её как нажимаемую.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              (w.properties.button ?? false) &&
              w.properties.label == 'Повторить',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should_hide_last_saved_row_when_label_null', (tester) async {
      await tester.pumpWidget(_wrap(OfflineState(
        title: 'Офлайн',
        message: 'msg',
        retryLabel: 'Повторить',
        lastSavedLabel: null,
        onRetry: () {},
      )));
      await tester.pump();

      // Время не фабрикуется: значка check (строка last-saved) нет.
      expect(find.byIcon(Icons.check_rounded), findsNothing);
    });

    testWidgets('should_show_last_saved_row_when_label_present',
        (tester) async {
      await tester.pumpWidget(_wrap(OfflineState(
        title: 'Офлайн',
        message: 'msg',
        retryLabel: 'Повторить',
        lastSavedLabel: 'Сохранено · 12:30',
        onRetry: () {},
      )));
      await tester.pump();

      expect(find.text('Сохранено · 12:30'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('should_hide_banner_when_banner_fields_null', (tester) async {
      await tester.pumpWidget(_wrap(OfflineState(
        title: 'Офлайн',
        message: 'msg',
        retryLabel: 'Повторить',
        onRetry: () {},
      )));
      await tester.pump();

      // Баннер показывается только когда заданы И title, И status.
      expect(find.text('офлайн'), findsNothing);
    });

    testWidgets('should_hide_banner_when_only_title_set', (tester) async {
      await tester.pumpWidget(_wrap(OfflineState(
        title: 'Офлайн',
        message: 'msg',
        retryLabel: 'Повторить',
        bannerTitle: 'Нет связи с садом',
        onRetry: () {},
      )));
      await tester.pump();

      // Status null → баннер скрыт целиком (его заголовка тоже нет).
      expect(find.text('Нет связи с садом'), findsNothing);
    });
  });
}
