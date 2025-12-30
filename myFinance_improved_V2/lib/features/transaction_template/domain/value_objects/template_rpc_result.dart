/// Template RPC Result - Result of RPC transaction creation
///
/// Purpose: Immutable result container for RPC call outcomes:
/// - Success case: Contains created journal_id
/// - Error case: Contains error code, message, and optional field-level errors
///
/// Used by template_rpc_service.dart to return structured results.
/// Clean Architecture: DOMAIN LAYER - Value Object
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_rpc_result.freezed.dart';
part 'template_rpc_result.g.dart';

/// Immutable result of template-based transaction creation
///
/// Uses Freezed for:
/// - Immutability guarantees
/// - copyWith support
/// - Union types for success/failure states
/// - JSON serialization
@freezed
class TemplateRpcResult with _$TemplateRpcResult {
  /// Successful transaction creation
  const factory TemplateRpcResult.success({
    /// Created journal entry ID
    required String journalId,

    /// Optional message from RPC
    String? message,

    /// Timestamp of creation (UTC)
    DateTime? createdAt,
  }) = TemplateRpcResultSuccess;

  /// Failed transaction creation
  const factory TemplateRpcResult.failure({
    /// Error code from RPC or application
    required String errorCode,

    /// Human-readable error message
    required String errorMessage,

    /// Optional field-level validation errors
    @Default([]) List<FieldError> fieldErrors,

    /// Whether this error is recoverable (user can fix and retry)
    @Default(true) bool isRecoverable,

    /// Original exception details (for logging)
    String? technicalDetails,
  }) = TemplateRpcResultFailure;

  /// Private constructor for Freezed
  const TemplateRpcResult._();

  /// Factory for JSON deserialization
  factory TemplateRpcResult.fromJson(Map<String, dynamic> json) =>
      _$TemplateRpcResultFromJson(json);

  // ═══════════════════════════════════════════════════════════════════════════
  // Convenience Getters
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if this result is successful
  bool get isSuccess => this is TemplateRpcResultSuccess;

  /// Check if this result is a failure
  bool get isFailure => this is TemplateRpcResultFailure;

  /// Get journal ID if successful, null otherwise
  String? get journalIdOrNull => maybeMap(
        success: (s) => s.journalId,
        orElse: () => null,
      );

  /// Get error message if failure, null otherwise
  String? get errorMessageOrNull => maybeMap(
        failure: (f) => f.errorMessage,
        orElse: () => null,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // Factory Constructors for Common Cases
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create from RPC response JSON
  ///
  /// Expected format:
  /// ```json
  /// {
  ///   "success": true,
  ///   "journal_id": "uuid",
  ///   "message": "optional"
  /// }
  /// ```
  /// or
  /// ```json
  /// {
  ///   "success": false,
  ///   "error": "ERROR_CODE",
  ///   "message": "Error description"
  /// }
  /// ```
  factory TemplateRpcResult.fromRpcResponse(Map<String, dynamic> response) {
    final success = response['success'] as bool? ?? false;

    if (success) {
      return TemplateRpcResult.success(
        journalId: response['journal_id']?.toString() ?? '',
        message: response['message']?.toString(),
        createdAt: DateTime.now().toUtc(),
      );
    } else {
      return TemplateRpcResult.failure(
        errorCode: response['error']?.toString() ?? 'UNKNOWN_ERROR',
        errorMessage:
            response['message']?.toString() ?? 'An unknown error occurred',
        isRecoverable: _isRecoverableError(response['error']?.toString()),
      );
    }
  }

  /// Create validation error result
  factory TemplateRpcResult.validationError({
    required String message,
    List<FieldError> fieldErrors = const [],
  }) {
    return TemplateRpcResult.failure(
      errorCode: 'VALIDATION_ERROR',
      errorMessage: message,
      fieldErrors: fieldErrors,
      isRecoverable: true,
    );
  }

  /// Create network error result
  factory TemplateRpcResult.networkError({String? details}) {
    return TemplateRpcResult.failure(
      errorCode: 'NETWORK_ERROR',
      errorMessage: 'Unable to connect to server. Please check your connection.',
      isRecoverable: true,
      technicalDetails: details,
    );
  }

  /// Create unknown error result
  factory TemplateRpcResult.unknownError({
    required String message,
    String? technicalDetails,
  }) {
    return TemplateRpcResult.failure(
      errorCode: 'UNKNOWN_ERROR',
      errorMessage: message,
      isRecoverable: false,
      technicalDetails: technicalDetails,
    );
  }

  /// Determine if error is recoverable based on error code
  static bool _isRecoverableError(String? errorCode) {
    if (errorCode == null) return true;

    const unrecoverableErrors = [
      'TEMPLATE_NOT_FOUND',
      'ACCOUNT_DELETED',
      'COMPANY_NOT_FOUND',
      'PERMISSION_DENIED',
    ];

    return !unrecoverableErrors.contains(errorCode);
  }
}

/// Field-level validation error
///
/// Used to provide specific feedback on which field failed validation.
@freezed
class FieldError with _$FieldError {
  const factory FieldError({
    /// Name of the field that failed validation
    required String fieldName,

    /// Error message for this field
    required String message,

    /// Optional: The invalid value that was provided
    String? invalidValue,

    /// Optional: Suggestion for valid value
    String? suggestion,
  }) = _FieldError;

  factory FieldError.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorFromJson(json);
}
