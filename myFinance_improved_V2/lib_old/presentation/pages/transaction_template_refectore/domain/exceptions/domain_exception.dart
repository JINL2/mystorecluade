/// Base class for all domain-specific exceptions
/// 
/// Provides a common interface for all domain layer exceptions
/// with support for error codes, context, and localization.
abstract class DomainException implements Exception {
  /// Human-readable error message
  final String message;
  
  /// Error code for programmatic handling
  final String? errorCode;
  
  /// Additional context information
  final Map<String, dynamic>? context;
  
  /// Inner exception that caused this exception
  final Exception? innerException;
  
  const DomainException(
    this.message, {
    this.errorCode,
    this.context,
    this.innerException,
  });

  /// Gets a user-friendly error message
  String get userMessage => message;
  
  /// Checks if this exception has an error code
  bool get hasErrorCode => errorCode != null && errorCode!.isNotEmpty;
  
  /// Checks if this exception has context information
  bool get hasContext => context != null && context!.isNotEmpty;
  
  /// Gets a specific context value by key
  T? getContextValue<T>(String key) {
    return context?[key] as T?;
  }
  
  /// Creates a copy of this exception with additional context
  DomainException withContext(String key, dynamic value) {
    final newContext = Map<String, dynamic>.from(context ?? {});
    newContext[key] = value;
    return copyWith(context: newContext);
  }
  
  /// Creates a copy of this exception with modified properties
  DomainException copyWith({
    String? message,
    String? errorCode,
    Map<String, dynamic>? context,
    Exception? innerException,
  });
  
  /// Converts exception to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'type': runtimeType.toString(),
      'message': message,
      if (hasErrorCode) 'errorCode': errorCode,
      if (hasContext) 'context': context,
      if (innerException != null) 'innerException': innerException.toString(),
    };
  }
  
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('${runtimeType.toString()}: $message');
    
    if (hasErrorCode) {
      buffer.write(' (Code: $errorCode)');
    }
    
    if (hasContext) {
      buffer.write(' Context: $context');
    }
    
    if (innerException != null) {
      buffer.write('\nCaused by: $innerException');
    }
    
    return buffer.toString();
  }
}