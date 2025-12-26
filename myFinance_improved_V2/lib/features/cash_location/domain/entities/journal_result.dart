// Domain Entity - Journal Operation Result
// Provides type-safe result handling for journal operations
// Note: JSON serialization is handled by data/models layer

import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_result.freezed.dart';

/// Result of journal entry operations
///
/// This sealed class provides type-safe handling of journal operation results.
/// Use pattern matching to handle success and failure cases.
///
/// Example:
/// ```dart
/// final result = await createJournalUseCase(params);
/// result.when(
///   success: (journalId, message) => print('Created: $journalId'),
///   failure: (error) => print('Error: $error'),
/// );
/// ```
@freezed
sealed class JournalResult with _$JournalResult {
  const factory JournalResult.success({
    required String journalId,
    String? message,
    Map<String, dynamic>? additionalData,
  }) = JournalSuccess;

  const factory JournalResult.failure({
    required String error,
    String? errorCode,
    Map<String, dynamic>? errorDetails,
  }) = JournalFailure;

  /// Helper method to convert from Map<String, dynamic> response
  factory JournalResult.fromResponse(Map<String, dynamic> response) {
    if (response['success'] == true) {
      final data = response['data'];
      return JournalResult.success(
        journalId: data is Map && data.containsKey('journal_id')
            ? data['journal_id'] as String
            : response['journal_id'] as String? ?? 'unknown',
        message: response['message'] as String?,
        additionalData: data is Map ? Map<String, dynamic>.from(data) : null,
      );
    } else {
      return JournalResult.failure(
        error: response['error'] as String? ?? 'Unknown error',
        errorCode: response['error_code'] as String?,
        errorDetails: response['error_details'] as Map<String, dynamic>?,
      );
    }
  }
}
