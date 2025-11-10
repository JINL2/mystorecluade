import '../../domain/entities/attendance_location.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/shift_card_data.dart';
import '../../domain/entities/shift_metadata.dart';
import '../../domain/entities/shift_overview.dart';
import '../../domain/entities/shift_request.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_datasource.dart';
import '../models/monthly_shift_status_model.dart';
import '../models/shift_metadata_model.dart';
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
    required String requestDate,
    required String userId,
    required String companyId,
    required String storeId,
  }) async {
    final json = await _datasource.getUserShiftOverview(
      requestDate: requestDate,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
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
        .map((json) => ShiftRequestModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<ShiftCardData> updateShiftRequest({
    required String userId,
    required String storeId,
    required String requestDate,
    required String timestamp,
    required AttendanceLocation location,
  }) async {
    final json = await _datasource.updateShiftRequest(
      userId: userId,
      storeId: storeId,
      requestDate: requestDate,
      timestamp: timestamp,
      location: location,
    );

    return ShiftCardData.fromJson(json ?? {});
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
  Future<List<ShiftCardData>> getUserShiftCards({
    required String requestDate,
    required String userId,
    required String companyId,
    required String storeId,
  }) async {
    final jsonList = await _datasource.getUserShiftCards(
      requestDate: requestDate,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
    );

    return jsonList
        .map((json) => ShiftCardData.fromJson(json))
        .toList();
  }

  @override
  Future<ShiftCardData?> getCurrentShift({
    required String userId,
    required String storeId,
  }) async {
    final json = await _datasource.getCurrentShift(
      userId: userId,
      storeId: storeId,
    );

    if (json == null) return null;
    return ShiftCardData.fromJson(json);
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
  }) async {
    final jsonList = await _datasource.getShiftMetadata(storeId: storeId);
    return jsonList
        .map((json) => ShiftMetadataModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<List<MonthlyShiftStatus>> getMonthlyShiftStatus({
    required String storeId,
    required String userId,
    required String requestDate,
  }) async {
    final jsonList = await _datasource.getMonthlyShiftStatus(
      storeId: storeId,
      userId: userId,
      requestDate: requestDate,
    );
    return jsonList
        .map((json) => MonthlyShiftStatusModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<ShiftCardData?> insertShiftRequest({
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
    if (json == null) return null;
    return ShiftCardData.fromJson(json);
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
