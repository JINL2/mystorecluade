import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_communication.freezed.dart';

/// Debt communication record
@freezed
class DebtCommunication with _$DebtCommunication {
  const factory DebtCommunication({
    required String id,
    required String debtId,
    required String type,
    required DateTime communicationDate,
    required String createdBy,
    String? notes,
    DateTime? followUpDate,
    @Default(false) bool isFollowUpCompleted,
    Map<String, dynamic>? metadata,
  }) = _DebtCommunication;

  const DebtCommunication._();

  /// Check if follow-up is needed
  bool get needsFollowUp => followUpDate != null && !isFollowUpCompleted;

  /// Check if follow-up is overdue
  bool get isFollowUpOverdue {
    if (followUpDate == null || isFollowUpCompleted) return false;
    return DateTime.now().isAfter(followUpDate!);
  }
}
