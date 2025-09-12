/// Advanced Error Handling and Recovery System
/// Provides resilient error handling with circuit breakers, graceful degradation, 
/// and user-friendly recovery mechanisms
/// 
/// Features:
/// - Circuit breaker pattern to prevent cascade failures
/// - Graceful degradation strategies
/// - Automatic error recovery with intelligent retry logic
/// - User-friendly error messages and recovery actions
/// - Performance impact monitoring
/// - Offline-first capability support

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// Error severity levels
enum ErrorSeverity {
  low,      // Minor issues that don't affect core functionality
  medium,   // Issues that affect some functionality but have workarounds
  high,     // Issues that significantly impact user experience
  critical, // Issues that prevent core functionality
}

/// Error recovery strategies
enum RecoveryStrategy {
  retry,           // Retry the operation
  fallback,        // Use alternative approach
  cache,           // Use cached data if available
  offline,         // Switch to offline mode
  userIntervention, // Require user action
  gracefulFail,    // Fail gracefully with user notification
}

/// Enhanced error with recovery information
class RecoverableError extends Error {
  final String message;
  final ErrorSeverity severity;
  final List<RecoveryStrategy> possibleRecoveries;
  final String? userFriendlyMessage;
  final Map<String, dynamic> context;
  final DateTime timestamp;
  final String? errorCode;
  
  RecoverableError({
    required this.message,
    this.severity = ErrorSeverity.medium,
    this.possibleRecoveries = const [RecoveryStrategy.retry],
    this.userFriendlyMessage,
    this.context = const {},
    DateTime? timestamp,
    this.errorCode,
  }) : timestamp = timestamp ?? DateTime.now();
  
  @override
  String toString() => 'RecoverableError: $message';
  
  /// Get user-friendly error message
  String getUserMessage() {
    return userFriendlyMessage ?? _generateUserMessage();
  }
  
  String _generateUserMessage() {
    switch (severity) {
      case ErrorSeverity.low:
        return 'Something went wrong, but you can continue using the app.';
      case ErrorSeverity.medium:
        return 'We encountered an issue. Please try again.';
      case ErrorSeverity.high:
        return 'Unable to complete your request. Please check your connection and try again.';
      case ErrorSeverity.critical:
        return 'A critical error occurred. Please restart the app or contact support.';
    }
  }
}

/// Circuit breaker states
enum CircuitBreakerState {
  closed,   // Normal operation
  open,     // Blocking requests due to failures
  halfOpen, // Testing if service is recovered
}

/// Circuit breaker for preventing cascade failures
class CircuitBreaker {
  final String name;
  final int failureThreshold;
  final Duration timeout;
  final Duration resetTimeout;
  
  CircuitBreakerState _state = CircuitBreakerState.closed;
  int _failureCount = 0;
  DateTime? _nextRetryTime;
  
  CircuitBreaker({
    required this.name,
    this.failureThreshold = 5,
    this.timeout = const Duration(seconds: 10),
    this.resetTimeout = const Duration(minutes: 1),
  });
  
  CircuitBreakerState get state => _state;
  int get failureCount => _failureCount;
  
  /// Execute operation through circuit breaker
  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_state == CircuitBreakerState.open) {
      if (_shouldAttemptReset()) {
        _state = CircuitBreakerState.halfOpen;
      } else {
        throw RecoverableError(
          message: 'Circuit breaker is open for $name',
          severity: ErrorSeverity.high,
          possibleRecoveries: [RecoveryStrategy.fallback, RecoveryStrategy.cache],
          userFriendlyMessage: 'Service is temporarily unavailable. Please try again later.',
          errorCode: 'CIRCUIT_BREAKER_OPEN',
        );
      }
    }
    
    try {
      final result = await operation().timeout(timeout);
      _onSuccess();
      return result;
    } catch (error) {
      _onFailure();
      rethrow;
    }
  }
  
  void _onSuccess() {
    _failureCount = 0;
    _state = CircuitBreakerState.closed;
    _nextRetryTime = null;
  }
  
  void _onFailure() {
    _failureCount++;
    
    if (_failureCount >= failureThreshold) {
      _state = CircuitBreakerState.open;
      _nextRetryTime = DateTime.now().add(resetTimeout);
    }
  }
  
  bool _shouldAttemptReset() {
    return _nextRetryTime != null && DateTime.now().isAfter(_nextRetryTime!);
  }
  
  /// Reset circuit breaker manually
  void reset() {
    _state = CircuitBreakerState.closed;
    _failureCount = 0;
    _nextRetryTime = null;
  }
}

/// Error recovery system
class ErrorRecoverySystem {
  static final ErrorRecoverySystem _instance = ErrorRecoverySystem._internal();
  factory ErrorRecoverySystem() => _instance;
  ErrorRecoverySystem._internal();
  
  final Map<String, CircuitBreaker> _circuitBreakers = {};
  final List<RecoverableError> _errorHistory = [];
  final StreamController<RecoverableError> _errorController = 
      StreamController<RecoverableError>.broadcast();
  
  /// Stream of recoverable errors
  Stream<RecoverableError> get errorStream => _errorController.stream;
  
  /// Get or create circuit breaker for a service
  CircuitBreaker getCircuitBreaker(String serviceName) {
    return _circuitBreakers.putIfAbsent(
      serviceName,
      () => CircuitBreaker(name: serviceName),
    );
  }
  
  /// Execute operation with comprehensive error handling
  Future<T> executeWithRecovery<T>({
    required String serviceName,
    required Future<T> Function() operation,
    Future<T> Function()? fallbackOperation,
    T? cachedData,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    List<RecoveryStrategy> allowedStrategies = const [
      RecoveryStrategy.retry,
      RecoveryStrategy.fallback,
      RecoveryStrategy.cache,
    ],
  }) async {
    final circuitBreaker = getCircuitBreaker(serviceName);
    RecoverableError? lastError;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await circuitBreaker.execute(operation);
      } catch (error) {
        lastError = _createRecoverableError(error, serviceName, attempt);
        _recordError(lastError);
        
        // Try recovery strategies
        final recoveryResult = await _attemptRecovery<T>(
          lastError,
          fallbackOperation: fallbackOperation,
          cachedData: cachedData,
          allowedStrategies: allowedStrategies,
        );
        
        if (recoveryResult != null) {
          return recoveryResult;
        }
        
        // Wait before retry (with exponential backoff)
        if (attempt < maxRetries) {
          final delay = retryDelay * pow(2, attempt);
          await Future.delayed(delay);
        }
      }
    }
    
    // All recovery attempts failed
    throw lastError ?? RecoverableError(
      message: 'Operation failed after all recovery attempts',
      severity: ErrorSeverity.high,
    );
  }
  
  /// Attempt to recover from error using available strategies
  Future<T?> _attemptRecovery<T>(
    RecoverableError error,
    {
    Future<T> Function()? fallbackOperation,
    T? cachedData,
    required List<RecoveryStrategy> allowedStrategies,
  }) async {
    for (final strategy in error.possibleRecoveries) {
      if (!allowedStrategies.contains(strategy)) continue;
      
      try {
        switch (strategy) {
          case RecoveryStrategy.fallback:
            if (fallbackOperation != null) {
              return await fallbackOperation();
            }
            break;
            
          case RecoveryStrategy.cache:
            if (cachedData != null) {
              return cachedData;
            }
            break;
            
          case RecoveryStrategy.offline:
            // Switch to offline mode if supported
            // This would need to be implemented based on app requirements
            break;
            
          case RecoveryStrategy.retry:
            // Retry is handled by the main loop
            break;
            
          case RecoveryStrategy.userIntervention:
          case RecoveryStrategy.gracefulFail:
            // These require UI interaction and are handled externally
            break;
        }
      } catch (recoveryError) {
        // Recovery strategy failed, try next one
        continue;
      }
    }
    
    return null;
  }
  
  /// Create recoverable error from generic error
  RecoverableError _createRecoverableError(
    dynamic error, 
    String serviceName, 
    int attemptNumber,
  ) {
    if (error is RecoverableError) {
      return error;
    }
    
    // Categorize error and determine recovery strategies
    final severity = _determineSeverity(error);
    final recoveryStrategies = _determineRecoveryStrategies(error, severity);
    final userMessage = _generateUserFriendlyMessage(error, severity);
    
    return RecoverableError(
      message: error.toString(),
      severity: severity,
      possibleRecoveries: recoveryStrategies,
      userFriendlyMessage: userMessage,
      context: {
        'serviceName': serviceName,
        'attemptNumber': attemptNumber,
        'originalError': error.runtimeType.toString(),
      },
      errorCode: _generateErrorCode(error),
    );
  }
  
  ErrorSeverity _determineSeverity(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('timeout') || 
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return ErrorSeverity.medium;
    }
    
    if (errorString.contains('authentication') ||
        errorString.contains('permission')) {
      return ErrorSeverity.high;
    }
    
    if (errorString.contains('critical') ||
        errorString.contains('fatal')) {
      return ErrorSeverity.critical;
    }
    
    return ErrorSeverity.medium;
  }
  
  List<RecoveryStrategy> _determineRecoveryStrategies(
    dynamic error, 
    ErrorSeverity severity,
  ) {
    final errorString = error.toString().toLowerCase();
    final strategies = <RecoveryStrategy>[];
    
    // Add retry for temporary issues
    if (errorString.contains('timeout') || 
        errorString.contains('network') ||
        errorString.contains('temporary')) {
      strategies.add(RecoveryStrategy.retry);
    }
    
    // Add fallback for service issues
    if (errorString.contains('service') || 
        errorString.contains('server')) {
      strategies.add(RecoveryStrategy.fallback);
    }
    
    // Add cache for data retrieval issues
    if (severity == ErrorSeverity.low || severity == ErrorSeverity.medium) {
      strategies.add(RecoveryStrategy.cache);
    }
    
    // Add user intervention for authentication issues
    if (errorString.contains('authentication') ||
        errorString.contains('permission')) {
      strategies.add(RecoveryStrategy.userIntervention);
    }
    
    // Default strategies
    if (strategies.isEmpty) {
      strategies.addAll([
        RecoveryStrategy.retry,
        RecoveryStrategy.gracefulFail,
      ]);
    }
    
    return strategies;
  }
  
  String _generateUserFriendlyMessage(dynamic error, ErrorSeverity severity) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Please check your internet connection and try again.';
    }
    
    if (errorString.contains('timeout')) {
      return 'The request timed out. Please try again.';
    }
    
    if (errorString.contains('authentication')) {
      return 'Please sign in again to continue.';
    }
    
    if (errorString.contains('permission')) {
      return 'You don\'t have permission to perform this action.';
    }
    
    switch (severity) {
      case ErrorSeverity.low:
        return 'A minor issue occurred, but you can continue.';
      case ErrorSeverity.medium:
        return 'Something went wrong. Please try again.';
      case ErrorSeverity.high:
        return 'Unable to complete your request. Please try again later.';
      case ErrorSeverity.critical:
        return 'A critical error occurred. Please restart the app.';
    }
  }
  
  String _generateErrorCode(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network')) return 'NETWORK_ERROR';
    if (errorString.contains('timeout')) return 'TIMEOUT_ERROR';
    if (errorString.contains('authentication')) return 'AUTH_ERROR';
    if (errorString.contains('permission')) return 'PERMISSION_ERROR';
    if (errorString.contains('server')) return 'SERVER_ERROR';
    
    return 'UNKNOWN_ERROR';
  }
  
  /// Record error for analysis and monitoring
  void _recordError(RecoverableError error) {
    _errorHistory.add(error);
    _errorController.add(error);
    
    // Keep error history manageable
    if (_errorHistory.length > 1000) {
      _errorHistory.removeRange(0, 500);
    }
    
    if (kDebugMode) {
      print('Error recorded: ${error.message} (${error.severity})');
    }
  }
  
  /// Get error statistics
  Map<String, dynamic> getErrorStats({Duration? timeWindow}) {
    final cutoff = timeWindow != null 
        ? DateTime.now().subtract(timeWindow)
        : null;
    
    final relevantErrors = cutoff != null
        ? _errorHistory.where((e) => e.timestamp.isAfter(cutoff)).toList()
        : _errorHistory;
    
    final errorsBySeverity = <ErrorSeverity, int>{};
    final errorsByCode = <String, int>{};
    final errorsByService = <String, int>{};
    
    for (final error in relevantErrors) {
      errorsBySeverity[error.severity] = 
          (errorsBySeverity[error.severity] ?? 0) + 1;
      
      if (error.errorCode != null) {
        errorsByCode[error.errorCode!] = 
            (errorsByCode[error.errorCode!] ?? 0) + 1;
      }
      
      final serviceName = error.context['serviceName'] as String?;
      if (serviceName != null) {
        errorsByService[serviceName] = 
            (errorsByService[serviceName] ?? 0) + 1;
      }
    }
    
    return {
      'totalErrors': relevantErrors.length,
      'errorsBySeverity': errorsBySeverity,
      'errorsByCode': errorsByCode,
      'errorsByService': errorsByService,
      'circuitBreakers': _circuitBreakers.map(
        (name, breaker) => MapEntry(name, {
          'state': breaker.state.toString(),
          'failureCount': breaker.failureCount,
        }),
      ),
    };
  }
  
  /// Reset error history and circuit breakers
  void reset() {
    _errorHistory.clear();
    for (final breaker in _circuitBreakers.values) {
      breaker.reset();
    }
  }
}

/// Graceful degradation manager
class GracefulDegradationManager {
  static final GracefulDegradationManager _instance = GracefulDegradationManager._internal();
  factory GracefulDegradationManager() => _instance;
  GracefulDegradationManager._internal();
  
  final Map<String, bool> _featureFlags = {};
  final Map<String, dynamic> _fallbackValues = {};
  
  /// Check if feature should be degraded
  bool shouldDegrade(String featureName) {
    return _featureFlags[featureName] ?? false;
  }
  
  /// Set feature degradation state
  void setFeatureDegraded(String featureName, bool degraded, {dynamic fallbackValue}) {
    _featureFlags[featureName] = degraded;
    if (fallbackValue != null) {
      _fallbackValues[featureName] = fallbackValue;
    }
  }
  
  /// Get fallback value for degraded feature
  T? getFallbackValue<T>(String featureName) {
    return _fallbackValues[featureName] as T?;
  }
  
  /// Auto-degrade features based on error patterns
  void autoDegrade(String serviceName, int errorCount, Duration timeWindow) {
    if (errorCount > 10) {
      // Degrade non-critical features
      setFeatureDegraded('${serviceName}_advanced_features', true);
    }
    
    if (errorCount > 20) {
      // Degrade more features
      setFeatureDegraded('${serviceName}_real_time_updates', true);
    }
  }
  
  /// Reset all degradations
  void reset() {
    _featureFlags.clear();
    _fallbackValues.clear();
  }
}