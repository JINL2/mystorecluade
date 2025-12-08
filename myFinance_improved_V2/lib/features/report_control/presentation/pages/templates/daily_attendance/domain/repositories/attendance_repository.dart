// lib/features/report_control/presentation/pages/templates/daily_attendance/domain/repositories/attendance_repository.dart

import '../../../../../../../domain/entities/templates/daily_attendance/attendance_report.dart';

/// Attendance Repository Interface
///
/// Domain layer - Pure business logic
/// No dependencies on external frameworks
abstract class AttendanceRepository {
  /// Get daily attendance report
  ///
  /// Returns attendance data for a specific date
  /// Throws [Exception] if data fetch fails
  Future<AttendanceReport> getDailyAttendanceReport({
    required String companyId,
    String? storeId,
    required DateTime targetDate,
  });
}
