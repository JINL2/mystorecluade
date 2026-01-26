// lib/features/cash_ending/data/services/system_time_provider.dart

import '../../domain/services/time_provider.dart';

/// System Time Provider implementation (Data Layer)
///
/// Uses Dart's DateTime.now() for actual system time
/// This is the only place where DateTime.now() should be called
class SystemTimeProvider implements TimeProvider {
  const SystemTimeProvider();

  @override
  DateTime now() {
    return DateTime.now().toUtc();
  }
}
