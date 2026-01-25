import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/attendance_location.dart';
import 'attendance_read_datasource.dart';
import 'attendance_write_datasource.dart';

// Re-export for backward compatibility
export 'attendance_read_datasource.dart';
export 'attendance_write_datasource.dart';

/// Attendance Data Source (Facade)
///
/// Facade pattern that delegates to specialized datasources:
/// - AttendanceReadDatasource: All READ operations (getUserShiftCards, getShiftMetadata, etc.)
/// - AttendanceWriteDatasource: All WRITE operations (updateShiftRequest, insertShiftRequest, etc.)
///
/// This maintains backward compatibility while enabling cleaner separation of concerns.
class AttendanceDatasource {
  final AttendanceReadDatasource _readDatasource;
  final AttendanceWriteDatasource _writeDatasource;

  AttendanceDatasource(SupabaseClient supabase)
      : _readDatasource = AttendanceReadDatasource(supabase),
        _writeDatasource = AttendanceWriteDatasource(supabase);

  // ============================================
  // READ Operations (delegated to AttendanceReadDatasource)
  // ============================================

  /// Fetch user shift cards for the month
  Future<List<Map<String, dynamic>>> getUserShiftCards({
    required String requestTime,
    required String userId,
    required String companyId,
    String? storeId,
    required String timezone,
  }) {
    return _readDatasource.getUserShiftCards(
      requestTime: requestTime,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
      timezone: timezone,
    );
  }

  /// Get shift metadata for a store
  Future<List<Map<String, dynamic>>> getShiftMetadata({
    required String storeId,
    required String timezone,
  }) {
    return _readDatasource.getShiftMetadata(
      storeId: storeId,
      timezone: timezone,
    );
  }

  /// Get monthly shift status for manager view
  Future<List<Map<String, dynamic>>> getMonthlyShiftStatusManager({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  }) {
    return _readDatasource.getMonthlyShiftStatusManager(
      storeId: storeId,
      companyId: companyId,
      requestTime: requestTime,
      timezone: timezone,
    );
  }

  /// Get base currency for a company
  Future<Map<String, dynamic>> getBaseCurrency({
    required String companyId,
  }) {
    return _readDatasource.getBaseCurrency(companyId: companyId);
  }

  /// Get user shift stats
  Future<Map<String, dynamic>> getUserShiftStats({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  }) {
    return _readDatasource.getUserShiftStats(
      requestTime: requestTime,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
      timezone: timezone,
    );
  }

  // ============================================
  // WRITE Operations (delegated to AttendanceWriteDatasource)
  // ============================================

  /// Update shift request (check-in or check-out) via QR scan
  Future<Map<String, dynamic>?> updateShiftRequest({
    required String shiftRequestId,
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
    required String timezone,
  }) {
    return _writeDatasource.updateShiftRequest(
      shiftRequestId: shiftRequestId,
      userId: userId,
      storeId: storeId,
      timestamp: timestamp,
      location: location,
      timezone: timezone,
    );
  }

  /// Report an issue with a shift
  Future<bool> reportShiftIssue({
    required String shiftRequestId,
    required String reportReason,
    required String time,
    required String timezone,
  }) {
    return _writeDatasource.reportShiftIssue(
      shiftRequestId: shiftRequestId,
      reportReason: reportReason,
      time: time,
      timezone: timezone,
    );
  }

  /// Insert shift request
  Future<Map<String, dynamic>?> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String startTime,
    required String endTime,
    required String timezone,
  }) {
    return _writeDatasource.insertShiftRequest(
      userId: userId,
      shiftId: shiftId,
      storeId: storeId,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
    );
  }

  /// Delete shift request
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String startTime,
    required String endTime,
    required String timezone,
  }) {
    return _writeDatasource.deleteShiftRequest(
      userId: userId,
      shiftId: shiftId,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
    );
  }
}
