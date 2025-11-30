import '../repositories/attendance_repository.dart';

/// Report an issue with a shift
///
/// Uses report_shift_request RPC to update shift_requests table
class ReportShiftIssue {
  final AttendanceRepository _repository;

  ReportShiftIssue(this._repository);

  Future<bool> call({
    required String shiftRequestId,
    required String reportReason,
    required String time,
    required String timezone,
  }) {
    return _repository.reportShiftIssue(
      shiftRequestId: shiftRequestId,
      reportReason: reportReason,
      time: time,
      timezone: timezone,
    );
  }
}
