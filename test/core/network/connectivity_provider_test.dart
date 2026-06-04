import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/network/connectivity_provider.dart';

void main() {
  group('connectivityProvider', () {
    test('should_emit_bool_values_from_override', () async {
      // Тест проверяет интеграцию override: стрим с фиксированным значением
      // корректно оборачивается в AsyncValue.
      final container = ProviderContainer(
        overrides: [
          connectivityProvider.overrideWith(
            (_) => Stream.fromIterable([true, false, true]),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Подписываемся через listen (keeps autoDispose alive).
      final received = <bool>[];
      final sub = container.listen(connectivityProvider, (_, next) {
        if (next.hasValue) received.add(next.value!);
      }, fireImmediately: true);
      addTearDown(sub.close);

      // Ожидаем, пока стрим завершится.
      await container.read(connectivityProvider.future).catchError((_) => false);
      await Future<void>.delayed(Duration.zero);

      expect(received, containsAllInOrder([true, false, true]));
    });

    test('should_be_loading_before_first_event', () async {
      // До первого yield стрим — AsyncLoading.
      final completer = Future<bool>.delayed(const Duration(milliseconds: 50), () => true);

      final container = ProviderContainer(
        overrides: [
          connectivityProvider.overrideWith((_) => Stream.fromFuture(completer)),
        ],
      );
      addTearDown(container.dispose);

      // Подписка удерживает провайдер.
      final sub = container.listen(connectivityProvider, (prev, next) {}, fireImmediately: true);
      addTearDown(sub.close);

      // Сразу после создания — loading (первое значение ещё не пришло).
      final initial = container.read(connectivityProvider);
      expect(initial.isLoading, isTrue);
    });
  });

  group('homeViewState connectivity watcher', () {
    // Поведение авто-рефетча при восстановлении сети проверяется в
    // home_view_state_test.dart через мок-стримы connectivityProvider.
    // Здесь убеждаемся только в контракте стрима провайдера.

    test('should_expose_bool_stream', () {
      // Убеждаемся что тип провайдера — AsyncValue<bool> (stream-based).
      final container = ProviderContainer(
        overrides: [
          connectivityProvider.overrideWith(
            (_) => const Stream<bool>.empty(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final sub = container.listen(connectivityProvider, (prev, next) {}, fireImmediately: true);
      addTearDown(sub.close);

      final value = container.read(connectivityProvider);
      // Stream<bool> → AsyncValue<bool>
      expect(value, isA<AsyncValue<bool>>());
    });
  });
}
