import '../repositories/attendance_repository.dart';

/// Report an issue with a shift
///
/// Updates shift_requests table with report details
class ReportShiftIssue {
  final AttendanceRepository _repository;

  ReportShiftIssue(this._repository);

  Future<bool> call({
    required String shiftRequestId,
    String? reportReason,
  }) {
    return _repository.reportShiftIssue(
      shiftRequestId: shiftRequestId,
      reportReason: reportReason,
    );
  }
}
