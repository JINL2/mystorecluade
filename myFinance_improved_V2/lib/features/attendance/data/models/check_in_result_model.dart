import '../../domain/entities/check_in_result.dart';

/// Check-In Result Model (DTO + Mapper)
///
/// Handles JSON serialization/deserialization for CheckInResult entity.
class CheckInResultModel {
  final CheckInResult _entity;

  CheckInResultModel(this._entity);

  /// Create from Entity
  factory CheckInResultModel.fromEntity(CheckInResult entity) {
    return CheckInResultModel(entity);
  }

  /// Convert to Entity
  CheckInResult toEntity() => _entity;

  /// Create from JSON (from RPC response)
  factory CheckInResultModel.fromJson(Map<String, dynamic> json) {
    return CheckInResultModel(
      CheckInResult(
        action: json['action'] as String? ?? 'check_in',
        requestDate: json['request_date'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
        shiftRequestId: json['shift_request_id'] as String?,
        message: json['message'] as String?,
        success: json['success'] as bool? ?? true,
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'action': _entity.action,
      'request_date': _entity.requestDate,
      'timestamp': _entity.timestamp,
      'shift_request_id': _entity.shiftRequestId,
      'message': _entity.message,
      'success': _entity.success,
    };
  }
}
