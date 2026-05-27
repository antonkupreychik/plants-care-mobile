import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'clock.dart';

part 'clock_provider.g.dart';

/// Провайдер времени. В тестах: `clockProvider.overrideWithValue(FakeClock(...))`.
@riverpod
Clock clock(Ref ref) => const SystemClock();
