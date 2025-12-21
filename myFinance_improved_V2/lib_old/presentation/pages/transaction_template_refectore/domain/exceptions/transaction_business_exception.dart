import 'domain_exception.dart';

/// Exception thrown when transaction business logic rules are violated
/// 
/// Used for transaction-specific business logic errors such as:
/// - Invalid transaction amounts
/// - Transaction status violations
/// - Account balance issues
/// - Transaction completion failures
class TransactionBusinessException extends DomainException {
  const TransactionBusinessException(
    String message, {
    String? errorCode,
    Map<String, dynamic>? context,
    Exception? innerException,
  }) : super(
          message,
          errorCode: errorCode,
          context: context,
          innerException: innerException,
        );

  /// Creates exception for transaction not found scenarios
  factory TransactionBusinessException.notFound({
    required String transactionId,
  }) {
    return TransactionBusinessException(
      'Transaction not found',
      errorCode: 'TRANSACTION_NOT_FOUND',
      context: {'transactionId': transactionId},
    );
  }

  /// Creates exception for invalid transaction amounts
  factory TransactionBusinessException.invalidAmount(double amount) {
    return TransactionBusinessException(
      'Invalid transaction amount',
      errorCode: 'TRANSACTION_INVALID_AMOUNT',
      context: {'amount': amount},
    );
  }

  /// Creates exception for transaction status violations
  factory TransactionBusinessException.invalidStatus(String currentStatus, String targetStatus) {
    return TransactionBusinessException(
      'Cannot change transaction status',
      errorCode: 'TRANSACTION_INVALID_STATUS_CHANGE',
      context: {
        'currentStatus': currentStatus,
        'targetStatus': targetStatus,
      },
    );
  }

  /// Creates exception for insufficient balance scenarios
  factory TransactionBusinessException.insufficientBalance(String accountId, double balance, double required) {
    return TransactionBusinessException(
      'Insufficient account balance',
      errorCode: 'TRANSACTION_INSUFFICIENT_BALANCE',
      context: {
        'accountId': accountId,
        'currentBalance': balance,
        'requiredAmount': required,
      },
    );
  }

  /// Creates exception for invalid state transitions
  factory TransactionBusinessException.invalidStateTransition({
    required String fromState,
    required String toState,
    required String transactionId,
  }) {
    return TransactionBusinessException(
      'Invalid transaction state transition',
      errorCode: 'TRANSACTION_INVALID_STATE_TRANSITION',
      context: {
        'fromState': fromState,
        'toState': toState,
        'transactionId': transactionId,
      },
    );
  }

  @override
  TransactionBusinessException copyWith({
    String? message,
    String? errorCode,
    Map<String, dynamic>? context,
    Exception? innerException,
  }) {
    return TransactionBusinessException(
      message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      context: context ?? this.context,
      innerException: innerException ?? this.innerException,
    );
  }
}