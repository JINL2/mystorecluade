import '../entities/shift_card.dart';
import '../value_objects/shift_status.dart';

/// Use Case for determining shift work status based on approval and time data
///
/// Business Rules:
/// - Not approved → pending (waiting for approval)
/// - Approved + started but not ended → working (currently working)
/// - Approved + both started and ended → completed (shift finished)
/// - Approved but not started → scheduled (approved but not yet started)
class GetShiftWorkStatus {
  /// Determine work status for a shift card
  ///
  /// Returns: [ShiftStatus] representing the current work status
  ShiftStatus call(ShiftCard card) {
    // Business Rule 1: Not approved → pending
    if (!card.isApproved) {
      return ShiftStatus.scheduled; // Using 'scheduled' for pending approval
    }

    // Business Rule 2: Approved + started but not ended → working
    if (card.confirmStartTime != null && card.confirmEndTime == null) {
      return ShiftStatus.working;
    }

    // Business Rule 3: Approved + both started and ended → completed
    if (card.confirmStartTime != null && card.confirmEndTime != null) {
      return ShiftStatus.finished;
    }

    // Business Rule 4: Approved but not started → scheduled
    return ShiftStatus.scheduled;
  }

  /// Determine work status from card data map (for backward compatibility)
  ///
  /// This method exists for gradual migration from Map to Entity usage.
  /// Prefer using the main call() method with ShiftCard entity.
  ShiftStatus fromMap(Map<String, dynamic> card) {
    final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
    final actualStart = card['confirm_start_time'] ?? card['actual_start_time'];
    final actualEnd = card['confirm_end_time'] ?? card['actual_end_time'];

    // Business Rule 1: Not approved → pending
    if (isApproved != true) {
      return ShiftStatus.scheduled;
    }

    // Business Rule 2: Approved + started but not ended → working
    if (actualStart != null && actualEnd == null) {
      return ShiftStatus.working;
    }

    // Business Rule 3: Approved + both started and ended → completed
    if (actualStart != null && actualEnd != null) {
      return ShiftStatus.finished;
    }

    // Business Rule 4: Approved but not started → scheduled
    return ShiftStatus.scheduled;
  }
}
