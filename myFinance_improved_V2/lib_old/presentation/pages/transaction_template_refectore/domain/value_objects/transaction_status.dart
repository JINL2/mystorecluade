import 'package:equatable/equatable.dart';

/// Value object representing transaction status
/// 
/// Encapsulates transaction lifecycle state with transition rules.
/// This is an immutable value object that ensures valid state transitions.
class TransactionStatus extends Equatable {
  final TransactionStatusType type;

  const TransactionStatus._(this.type);

  /// Factory constructors for each status type
  const TransactionStatus.pending() : type = TransactionStatusType.pending;
  const TransactionStatus.completed() : type = TransactionStatusType.completed;
  const TransactionStatus.cancelled() : type = TransactionStatusType.cancelled;
  const TransactionStatus.failed() : type = TransactionStatusType.failed;
  const TransactionStatus.scheduled() : type = TransactionStatusType.scheduled;

  /// Creates status from string value
  factory TransactionStatus.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return const TransactionStatus.pending();
      case 'completed':
        return const TransactionStatus.completed();
      case 'cancelled':
        return const TransactionStatus.cancelled();
      case 'failed':
        return const TransactionStatus.failed();
      case 'scheduled':
        return const TransactionStatus.scheduled();
      default:
        throw ArgumentError('Invalid transaction status: $value');
    }
  }

  /// Convenience getters
  bool get isPending => type == TransactionStatusType.pending;
  bool get isCompleted => type == TransactionStatusType.completed;
  bool get isCancelled => type == TransactionStatusType.cancelled;
  bool get isFailed => type == TransactionStatusType.failed;
  bool get isScheduled => type == TransactionStatusType.scheduled;

  /// Check if status represents a final state
  bool get isFinalState => isCompleted || isCancelled || isFailed;

  /// Check if status allows modifications
  bool get allowsModification => isPending || isScheduled;

  /// Check if status can be cancelled
  bool get canBeCancelled => isPending || isScheduled;

  /// Check if status can be completed
  bool get canBeCompleted => isPending;

  /// Check if status can be rescheduled
  bool get canBeRescheduled => isPending || isFailed;

  /// Validates if transition to new status is allowed
  bool canTransitionTo(TransactionStatus newStatus) {
    // Self-transition is always allowed (for idempotency)
    if (type == newStatus.type) return true;

    switch (type) {
      case TransactionStatusType.pending:
        return newStatus.isCompleted || 
               newStatus.isCancelled || 
               newStatus.isFailed ||
               newStatus.isScheduled;
      
      case TransactionStatusType.scheduled:
        return newStatus.isPending || 
               newStatus.isCancelled || 
               newStatus.isFailed;
      
      case TransactionStatusType.completed:
        // Completed transactions can only be cancelled in special cases
        return newStatus.isCancelled;
      
      case TransactionStatusType.cancelled:
      case TransactionStatusType.failed:
        // Final states - no transitions allowed
        return false;
    }
  }

  /// Gets valid next states from current status
  List<TransactionStatus> getValidNextStates() {
    switch (type) {
      case TransactionStatusType.pending:
        return [
          const TransactionStatus.completed(),
          const TransactionStatus.cancelled(),
          const TransactionStatus.failed(),
          const TransactionStatus.scheduled(),
        ];
      
      case TransactionStatusType.scheduled:
        return [
          const TransactionStatus.pending(),
          const TransactionStatus.cancelled(),
          const TransactionStatus.failed(),
        ];
      
      case TransactionStatusType.completed:
        return [
          const TransactionStatus.cancelled(),
        ];
      
      case TransactionStatusType.cancelled:
      case TransactionStatusType.failed:
        return []; // Final states
    }
  }

  /// Transitions to new status if valid
  TransactionStatus transitionTo(TransactionStatus newStatus) {
    if (!canTransitionTo(newStatus)) {
      throw StateError(
        'Invalid transition from ${toString()} to ${newStatus.toString()}'
      );
    }
    return newStatus;
  }

  /// Display name for UI
  String get displayName {
    switch (type) {
      case TransactionStatusType.pending:
        return 'Pending';
      case TransactionStatusType.completed:
        return 'Completed';
      case TransactionStatusType.cancelled:
        return 'Cancelled';
      case TransactionStatusType.failed:
        return 'Failed';
      case TransactionStatusType.scheduled:
        return 'Scheduled';
    }
  }

  /// Color indicator for UI (returns color name as string)
  String get colorIndicator {
    switch (type) {
      case TransactionStatusType.pending:
        return 'orange';
      case TransactionStatusType.completed:
        return 'green';
      case TransactionStatusType.cancelled:
        return 'red';
      case TransactionStatusType.failed:
        return 'red';
      case TransactionStatusType.scheduled:
        return 'blue';
    }
  }

  /// Icon name for UI
  String get iconName {
    switch (type) {
      case TransactionStatusType.pending:
        return 'clock';
      case TransactionStatusType.completed:
        return 'check_circle';
      case TransactionStatusType.cancelled:
        return 'cancel';
      case TransactionStatusType.failed:
        return 'error';
      case TransactionStatusType.scheduled:
        return 'schedule';
    }
  }

  /// String representation for storage/API
  String toStorageString() {
    switch (type) {
      case TransactionStatusType.pending:
        return 'pending';
      case TransactionStatusType.completed:
        return 'completed';
      case TransactionStatusType.cancelled:
        return 'cancelled';
      case TransactionStatusType.failed:
        return 'failed';
      case TransactionStatusType.scheduled:
        return 'scheduled';
    }
  }

  @override
  List<Object> get props => [type];

  @override
  String toString() => displayName;
}

/// Enumeration of transaction status types
enum TransactionStatusType {
  pending,    // Awaiting approval or processing
  completed,  // Successfully processed
  cancelled,  // Cancelled by user or system
  failed,     // Processing failed
  scheduled,  // Scheduled for future processing
}