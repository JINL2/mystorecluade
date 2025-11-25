import '../../domain/entities/attendance_location.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/shift_card.dart';
import '../../domain/entities/shift_metadata.dart';
import '../../domain/entities/shift_overview.dart';
import '../../domain/entities/shift_request.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_datasource.dart';
import '../models/shift_overview_model.dart';

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
  Future<List<ShiftRequest>> getShiftRequests({
    required String userId,
    required String storeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final jsonList = await _datasource.getShiftRequests(
      userId: userId,
      storeId: storeId,
      startDate: startDate,
      endDate: endDate,
    );

    return jsonList
        .map((json) => ShiftRequest.fromJson(json))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> updateShiftRequest({
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
  }) async {
    final result = await _datasource.updateShiftRequest(
      userId: userId,
      storeId: storeId,
      timestamp: timestamp,
      location: location,
    );

    return result ?? {};
  }

  @override
  Future<void> checkIn({
    required String shiftRequestId,
    required AttendanceLocation location,
  }) async {
    await _datasource.checkIn(
      shiftRequestId: shiftRequestId,
      location: location,
    );
  }

  @override
  Future<void> checkOut({
    required String shiftRequestId,
    required AttendanceLocation location,
  }) async {
    await _datasource.checkOut(
      shiftRequestId: shiftRequestId,
      location: location,
    );
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
  Future<Map<String, dynamic>?> getCurrentShift({
    required String userId,
    required String storeId,
  }) async {
    return await _datasource.getCurrentShift(
      userId: userId,
      storeId: storeId,
    );
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
    return jsonList.map((json) => MonthlyShiftStatus.fromJson(json)).toList();
  }

  @override
  Future<ShiftRequest?> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,
  }) async {
    final json = await _datasource.insertShiftRequest(
      userId: userId,
      shiftId: shiftId,
      storeId: storeId,
      requestDate: requestDate,
    );
    return json != null ? ShiftRequest.fromJson(json) : null;
  }

  @override
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String requestDate,
  }) async {
    return await _datasource.deleteShiftRequest(
      userId: userId,
      shiftId: shiftId,
      requestDate: requestDate,
    );
  }
}
