// lib/features/cash_ending/domain/services/time_provider.dart

/// Time Provider abstraction (Domain Layer)
///
/// This abstraction allows:
/// - Testing with fixed/mock time
/// - Time zone handling
/// - Consistent time across the application
///
/// NO dependencies on infrastructure (DateTime.now() is in Data layer)
abstract class TimeProvider {
  /// Get current DateTime
  ///
  /// Returns current time in UTC
  DateTime now();
}
