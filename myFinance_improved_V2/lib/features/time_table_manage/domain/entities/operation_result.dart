/// Operation Result Entity
///
/// Generic result entity for CRUD operations (Create, Update, Delete).
/// Provides a consistent way to handle operation outcomes across the domain.
class OperationResult {
  /// Whether the operation was successful
  final bool success;

  /// Optional message describing the result
  final String? message;

  /// Optional error code if operation failed
  final String? errorCode;

  /// Additional metadata about the operation
  final Map<String, dynamic> metadata;

  const OperationResult({
    required this.success,
    this.message,
    this.errorCode,
    this.metadata = const {},
  });

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

  /// Copy with method for immutability
  OperationResult copyWith({
    bool? success,
    String? message,
    String? errorCode,
    Map<String, dynamic>? metadata,
  }) {
    return OperationResult(
      success: success ?? this.success,
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OperationResult &&
        other.success == success &&
        other.message == message &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode {
    return success.hashCode ^ message.hashCode ^ errorCode.hashCode;
  }

  @override
  String toString() {
    return 'OperationResult(success: $success, message: $message, errorCode: $errorCode)';
  }
}
