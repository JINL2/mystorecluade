import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/attendance_repository.dart';

/// Attendance Repository Provider Interface
///
/// This provider is defined at Domain level to maintain Clean Architecture.
/// The actual implementation is provided by the Data layer through override.
///
/// Benefits:
/// - Presentation layer doesn't directly depend on Data layer
/// - Repository implementation can be easily swapped for testing
/// - Clear separation of concerns across layers
///
/// Usage in Data layer:
/// ```dart
/// final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
///   final datasource = ref.watch(attendanceDatasourceProvider);
///   return AttendanceRepositoryImpl(datasource: datasource);
/// });
/// ```
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  throw UnimplementedError(
    'attendanceRepositoryProvider must be overridden by Data layer.\n'
    'Import attendance_data_providers.dart to provide the implementation.',
  );
});
