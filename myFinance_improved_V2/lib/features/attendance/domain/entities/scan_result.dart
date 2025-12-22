import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_result.freezed.dart';

/// QR Scan Result Entity
///
/// Represents data received from QR code scanning.
/// This is a Domain entity that encapsulates QR scan data structure.
///
/// Note: If JSON serialization is needed, create ScanResultModel in data layer
@freezed
class ScanResult with _$ScanResult {
  const ScanResult._();

  const factory ScanResult({
    /// Date of the shift (yyyy-MM-dd format)
    required String requestDate,

    /// ID of the shift request
    required String shiftRequestId,

    /// Shift start time (HH:mm:ss format)
    required String shiftStartTime,

    /// Shift end time (HH:mm:ss format)
    required String shiftEndTime,

    /// Store name
    required String storeName,

    /// Action to perform: 'check_in' or 'check_out'
    required String action,

    /// Timestamp of the scan (ISO 8601 UTC format)
    required String timestamp,

    /// Store ID
    String? storeId,

    /// User ID
    String? userId,
  }) = _ScanResult;

  /// Get formatted shift time range
  String get shiftTimeRange => '$shiftStartTime ~ $shiftEndTime';

  /// Check if this is a check-in scan
  bool get isCheckIn => action == 'check_in';

  /// Check if this is a check-out scan
  bool get isCheckOut => action == 'check_out';
}
