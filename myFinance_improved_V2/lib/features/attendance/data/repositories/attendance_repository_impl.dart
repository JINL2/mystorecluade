import '../../domain/entities/attendance_location.dart';
import '../../domain/entities/check_in_result.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/shift_card.dart';
import '../../domain/entities/shift_metadata.dart';
import '../../domain/entities/shift_overview.dart';
import '../../domain/entities/shift_request.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_datasource.dart';
import '../models/check_in_result_model.dart';
import '../models/monthly_shift_status_model.dart';
import '../models/shift_overview_model.dart';
import '../models/shift_request_model.dart';

/// Attendance Repository Implementation
///
/// Implements the AttendanceRepository interface using AttendanceDatasource.
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDatasource _datasource;

  AttendanceRepositoryImpl({required AttendanceDatasource datasource})
      : _datasource = datasource;

  @override
  Future<ShiftOverview> getUserShiftOverview({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    final json = await _datasource.getUserShiftOverview(
      requestTime: requestTime,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
      timezone: timezone,
    );

    return ShiftOverviewModel.fromJson(json).toEntity();
  }

  @override
  Future<CheckInResult> updateShiftRequest({
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
    required String timezone,
  }) async {
    final json = await _datasource.updateShiftRequest(
      userId: userId,
      storeId: storeId,
      timestamp: timestamp,
      location: location,
      timezone: timezone,
    );

    // ✅ Clean Architecture: Convert Map to Entity using Model
    return CheckInResultModel.fromJson(json ?? {}).toEntity();
  }

  @override
  Future<List<ShiftCard>> getUserShiftCards({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    final jsonList = await _datasource.getUserShiftCards(
      requestTime: requestTime,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
      timezone: timezone,
    );

    return jsonList.map((json) => ShiftCard.fromJson(json)).toList();
  }

  @override
  Future<bool> reportShiftIssue({
    required String shiftRequestId,
    String? reportReason,
  }) async {
    return await _datasource.reportShiftIssue(
      shiftRequestId: shiftRequestId,
      reportReason: reportReason,
    );
  }

  @override
  Future<List<ShiftMetadata>> getShiftMetadata({
    required String storeId,
    required String timezone,
  }) async {
    final jsonList = await _datasource.getShiftMetadata(
      storeId: storeId,
      timezone: timezone,
    );
    return jsonList.map((json) => ShiftMetadata.fromJson(json)).toList();
  }

  @override
  Future<List<MonthlyShiftStatus>> getMonthlyShiftStatusManager({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  }) async {
    final jsonList = await _datasource.getMonthlyShiftStatusManager(
      storeId: storeId,
      companyId: companyId,
      requestTime: requestTime,
      timezone: timezone,
    );
    return jsonList
        .map((json) => MonthlyShiftStatusModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<ShiftRequest?> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestTime,
    required String timezone,
  }) async {
    final json = await _datasource.insertShiftRequest(
      userId: userId,
      shiftId: shiftId,
      storeId: storeId,
      requestTime: requestTime,
      timezone: timezone,
    );
    return json != null ? ShiftRequestModel.fromJson(json).toEntity() : null;
  }

  @override
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String requestDate,
    required String timezone,
  }) async {
    return await _datasource.deleteShiftRequest(
      userId: userId,
      shiftId: shiftId,
      requestDate: requestDate,
      timezone: timezone,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getMonthlyShiftStatusRaw({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  }) async {
    // Return raw JSON without entity conversion to preserve nested structure
    return await _datasource.getMonthlyShiftStatusManager(
      storeId: storeId,
      companyId: companyId,
      requestTime: requestTime,
      timezone: timezone,
    );
  }
}
