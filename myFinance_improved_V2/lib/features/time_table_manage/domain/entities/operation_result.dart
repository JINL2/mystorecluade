import 'package:freezed_annotation/freezed_annotation.dart';

part 'operation_result.freezed.dart';
part 'operation_result.g.dart';

/// Operation Result Entity
///
/// Generic result entity for CRUD operations (Create, Update, Delete).
/// Provides a consistent way to handle operation outcomes across the domain.
@freezed
class OperationResult with _$OperationResult {
  const OperationResult._();

  const factory OperationResult({
    /// Whether the operation was successful
    required bool success,

    /// Optional message describing the result
    String? message,

    /// Optional error code if operation failed
    @JsonKey(name: 'error_code') String? errorCode,

    /// Additional metadata about the operation
    @JsonKey(defaultValue: <String, dynamic>{})
        required Map<String, dynamic> metadata,
  }) = _OperationResult;

  /// Create from JSON
  factory OperationResult.fromJson(Map<String, dynamic> json) =>
      _$OperationResultFromJson(json);

  /// Factory for successful operation
  factory OperationResult.success({
    String? message,
    Map<String, dynamic> metadata = const {},
  }) {
    return OperationResult(
      success: true,
      message: message,
      metadata: metadata,
    );
  }

  /// Factory for failed operation
  factory OperationResult.failure({
    required String message,
    String? errorCode,
    Map<String, dynamic> metadata = const {},
  }) {
    return OperationResult(
      success: false,
      message: message,
      errorCode: errorCode,
      metadata: metadata,
    );
  }

  /// Check if operation was successful
  bool get isSuccess => success;

  /// Check if operation failed
  bool get isFailure => !success;

  /// Get metadata value by key
  T? getMetadata<T>(String key) {
    return metadata[key] as T?;
  }

  /// Check if metadata contains key
  bool hasMetadata(String key) {
    return metadata.containsKey(key);
  }
}
