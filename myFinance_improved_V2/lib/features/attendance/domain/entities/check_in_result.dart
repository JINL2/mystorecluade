import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_in_result.freezed.dart';
part 'check_in_result.g.dart';

/// Check-In/Check-Out Result Entity
///
/// Represents the result of a QR scan check-in or check-out operation.
/// This is a Domain entity that encapsulates the business concept of attendance action result.
@freezed
class CheckInResult with _$CheckInResult {
  const CheckInResult._();

  const factory CheckInResult({
    /// Action performed: 'check_in' or 'check_out'
    required String action,

    /// Date of the shift (yyyy-MM-dd format)
    required String requestDate,

    /// Timestamp when action was performed (ISO 8601 format)
    required String timestamp,

    /// ID of the shift request that was updated
    String? shiftRequestId,

    /// Success/error message from server
    String? message,

    /// Whether the action was successful
    @Default(true) bool success,
  }) = _CheckInResult;

  factory CheckInResult.fromJson(Map<String, dynamic> json) =>
      _$CheckInResultFromJson(json);

  /// Check if this was a check-in action
  bool get isCheckIn => action == 'check_in';

  /// Check if this was a check-out action
  bool get isCheckOut => action == 'check_out';
}
