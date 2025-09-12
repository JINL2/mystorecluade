/// Optimistic UI Operations Manager
/// Provides immediate user feedback while ensuring data consistency and error recovery
/// 
/// Features:
/// - Immediate UI updates for better UX
/// - Automatic rollback on operation failure
/// - Conflict resolution strategies
/// - Progress tracking and status reporting
/// - Graceful error handling with user-friendly recovery options

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../cache/smart_cache_manager.dart';

/// Optimistic operation states
enum OptimisticOperationState {
  pending,    // Operation is being processed
  success,    // Operation completed successfully
  failed,     // Operation failed and was rolled back
  conflicted, // Operation conflicted with server state
}

/// Optimistic operation result
class OptimisticOperationResult<T> {
  final String operationId;
  final OptimisticOperationState state;
  final T? data;
  final String? errorMessage;
  final DateTime timestamp;
  final Duration executionTime;
  
  const OptimisticOperationResult({
    required this.operationId,
    required this.state,
    this.data,
    this.errorMessage,
    required this.timestamp,
    this.executionTime = Duration.zero,
  });
  
  bool get isSuccess => state == OptimisticOperationState.success;
  bool get isFailed => state == OptimisticOperationState.failed;
  bool get isPending => state == OptimisticOperationState.pending;
  bool get isConflicted => state == OptimisticOperationState.conflicted;
}

/// Optimistic operation configuration
class OptimisticOperationConfig {
  final Duration timeout;
  final bool enableRollback;
  final bool enableConflictResolution;
  final int maxRetries;
  final Duration retryDelay;
  
  const OptimisticOperationConfig({
    this.timeout = const Duration(seconds: 10),
    this.enableRollback = true,
    this.enableConflictResolution = true,
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 1),
  });
}

/// Optimistic operation
class OptimisticOperation<T> {
  final String id;
  final String name;
  final T optimisticData;
  final Future<T> Function() operation;
  final Future<void> Function()? rollbackOperation;
  final bool Function(T current, T incoming)? conflictResolver;
  final OptimisticOperationConfig config;
  final List<String> cacheKeysToInvalidate;
  
  OptimisticOperation({
    required this.id,
    required this.name,
    required this.optimisticData,
    required this.operation,
    this.rollbackOperation,
    this.conflictResolver,
    this.config = const OptimisticOperationConfig(),
    this.cacheKeysToInvalidate = const [],
  });
}

/// Optimistic Operations Manager
class OptimisticOperationsManager {
  static final OptimisticOperationsManager _instance = OptimisticOperationsManager._internal();
  factory OptimisticOperationsManager() => _instance;
  OptimisticOperationsManager._internal();
  
  final Map<String, OptimisticOperation> _activeOperations = {};
  final Map<String, OptimisticOperationResult> _operationResults = {};
  final StreamController<OptimisticOperationResult> _resultController = 
      StreamController<OptimisticOperationResult>.broadcast();
  final Map<String, StreamController<OptimisticOperationProgress>> _progressControllers = {};
  
  /// Stream of operation results
  Stream<OptimisticOperationResult> get operationResults => _resultController.stream;
  
  /// Execute an optimistic operation
  Future<OptimisticOperationResult<T>> execute<T>(OptimisticOperation<T> operation) async {
    final stopwatch = Stopwatch()..start();
    
    // Store the operation
    _activeOperations[operation.id] = operation;
    
    // Emit pending state
    final pendingResult = OptimisticOperationResult<T>(
      operationId: operation.id,
      state: OptimisticOperationState.pending,
      data: operation.optimisticData,
      timestamp: DateTime.now(),
    );
    _operationResults[operation.id] = pendingResult;
    _resultController.add(pendingResult);
    
    try {
      // Execute the actual operation
      final actualData = await operation.operation()
          .timeout(operation.config.timeout);
      
      stopwatch.stop();
      
      // Check for conflicts if resolver is provided
      if (operation.conflictResolver != null) {
        final hasConflict = !operation.conflictResolver!(operation.optimisticData, actualData);
        
        if (hasConflict) {
          return await _handleConflict(operation, actualData, stopwatch.elapsed);
        }
      }
      
      // Success - invalidate related cache
      await _invalidateCache(operation.cacheKeysToInvalidate);
      
      final successResult = OptimisticOperationResult<T>(
        operationId: operation.id,
        state: OptimisticOperationState.success,
        data: actualData,
        timestamp: DateTime.now(),
        executionTime: stopwatch.elapsed,
      );
      
      _operationResults[operation.id] = successResult;
      _resultController.add(successResult);
      _activeOperations.remove(operation.id);
      
      return successResult;
      
    } catch (error) {
      stopwatch.stop();
      
      // Handle failure with rollback
      return await _handleFailure(operation, error, stopwatch.elapsed);
    }
  }
  
  /// Handle operation conflict
  Future<OptimisticOperationResult<T>> _handleConflict<T>(
    OptimisticOperation<T> operation,
    T actualData,
    Duration executionTime,
  ) async {
    if (operation.config.enableConflictResolution) {
      // Try to resolve conflict automatically
      // For now, we'll use server data as truth
      final result = OptimisticOperationResult<T>(
        operationId: operation.id,
        state: OptimisticOperationState.success,
        data: actualData,
        timestamp: DateTime.now(),
        executionTime: executionTime,
      );
      
      _operationResults[operation.id] = result;
      _resultController.add(result);
      _activeOperations.remove(operation.id);
      
      return result;
    } else {
      final result = OptimisticOperationResult<T>(
        operationId: operation.id,
        state: OptimisticOperationState.conflicted,
        data: actualData,
        errorMessage: 'Data conflict detected',
        timestamp: DateTime.now(),
        executionTime: executionTime,
      );
      
      _operationResults[operation.id] = result;
      _resultController.add(result);
      _activeOperations.remove(operation.id);
      
      return result;
    }
  }
  
  /// Handle operation failure
  Future<OptimisticOperationResult<T>> _handleFailure<T>(
    OptimisticOperation<T> operation,
    dynamic error,
    Duration executionTime,
  ) async {
    // Perform rollback if enabled and available
    if (operation.config.enableRollback && operation.rollbackOperation != null) {
      try {
        await operation.rollbackOperation!();
      } catch (rollbackError) {
        if (kDebugMode) {
          print('Rollback failed for operation ${operation.id}: $rollbackError');
        }
      }
    }
    
    final failureResult = OptimisticOperationResult<T>(
      operationId: operation.id,
      state: OptimisticOperationState.failed,
      errorMessage: error.toString(),
      timestamp: DateTime.now(),
      executionTime: executionTime,
    );
    
    _operationResults[operation.id] = failureResult;
    _resultController.add(failureResult);
    _activeOperations.remove(operation.id);
    
    return failureResult;
  }
  
  /// Invalidate related cache entries
  Future<void> _invalidateCache(List<String> cacheKeys) async {
    if (cacheKeys.isEmpty) return;
    
    final cache = SmartCacheManager();
    for (final key in cacheKeys) {
      await cache.invalidate(key);
    }
  }
  
  /// Get operation result by ID
  OptimisticOperationResult? getOperationResult(String operationId) {
    return _operationResults[operationId];
  }
  
  /// Check if operation is active
  bool isOperationActive(String operationId) {
    return _activeOperations.containsKey(operationId);
  }
  
  /// Cancel an active operation
  Future<void> cancelOperation(String operationId) async {
    final operation = _activeOperations[operationId];
    if (operation != null) {
      _activeOperations.remove(operationId);
      
      // Perform rollback if available
      if (operation.rollbackOperation != null) {
        try {
          await operation.rollbackOperation!();
        } catch (e) {
          if (kDebugMode) {
            print('Rollback failed for cancelled operation $operationId: $e');
          }
        }
      }
      
      final cancelledResult = OptimisticOperationResult(
        operationId: operationId,
        state: OptimisticOperationState.failed,
        errorMessage: 'Operation cancelled',
        timestamp: DateTime.now(),
      );
      
      _operationResults[operationId] = cancelledResult;
      _resultController.add(cancelledResult);
    }
  }
  
  /// Clear old operation results
  void cleanupOldResults({Duration maxAge = const Duration(hours: 1)}) {
    final cutoff = DateTime.now().subtract(maxAge);
    final keysToRemove = <String>[];
    
    for (final entry in _operationResults.entries) {
      if (entry.value.timestamp.isBefore(cutoff)) {
        keysToRemove.add(entry.key);
      }
    }
    
    for (final key in keysToRemove) {
      _operationResults.remove(key);
    }
  }
  
  /// Get all active operations
  List<OptimisticOperation> getActiveOperations() {
    return _activeOperations.values.toList();
  }
  
  /// Get recent operation results
  List<OptimisticOperationResult> getRecentResults({int limit = 50}) {
    final results = _operationResults.values.toList();
    results.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return results.take(limit).toList();
  }
  
  /// Get progress stream for an operation
  Stream<OptimisticOperationProgress>? getProgressStream(String operationId) {
    return _progressControllers[operationId]?.stream;
  }
  
  /// Update operation progress
  void updateProgress(String operationId, String message, double progress) {
    final controller = _progressControllers[operationId];
    if (controller != null) {
      controller.add(OptimisticOperationProgress(
        operationId: operationId,
        message: message,
        progress: progress.clamp(0.0, 1.0),
        timestamp: DateTime.now(),
      ));
    }
  }
  
  /// Start tracking progress for an operation
  void startProgressTracking(String operationId) {
    _progressControllers[operationId] = StreamController<OptimisticOperationProgress>.broadcast();
  }
  
  /// Stop tracking progress for an operation
  void stopProgressTracking(String operationId) {
    _progressControllers[operationId]?.close();
    _progressControllers.remove(operationId);
  }
}

/// Optimistic operation builders for common use cases
class OptimisticOperationBuilders {
  /// Create template operation
  static OptimisticOperation<Map<String, dynamic>> createTemplate({
    required String name,
    required Map<String, dynamic> templateData,
    required Future<Map<String, dynamic>> Function() createOperation,
    required String companyId,
    required String storeId,
  }) {
    return OptimisticOperation<Map<String, dynamic>>(
      id: 'create_template_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Create Template: $name',
      optimisticData: templateData,
      operation: createOperation,
      cacheKeysToInvalidate: [
        CacheKeys.templates(companyId, storeId),
      ],
    );
  }
  
  /// Delete template operation
  static OptimisticOperation<bool> deleteTemplate({
    required String templateId,
    required String templateName,
    required Future<bool> Function() deleteOperation,
    required String companyId,
    required String storeId,
  }) {
    return OptimisticOperation<bool>(
      id: 'delete_template_$templateId',
      name: 'Delete Template: $templateName',
      optimisticData: true,
      operation: deleteOperation,
      cacheKeysToInvalidate: [
        CacheKeys.templates(companyId, storeId),
      ],
    );
  }
  
  /// Execute template operation
  static OptimisticOperation<Map<String, dynamic>> executeTemplate({
    required String templateId,
    required String templateName,
    required Map<String, dynamic> transactionData,
    required Future<Map<String, dynamic>> Function() executeOperation,
    required String companyId,
    required String storeId,
  }) {
    return OptimisticOperation<Map<String, dynamic>>(
      id: 'execute_template_${templateId}_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Execute Template: $templateName',
      optimisticData: transactionData,
      operation: executeOperation,
      config: const OptimisticOperationConfig(
        timeout: Duration(seconds: 15), // Template execution might take longer
      ),
      cacheKeysToInvalidate: [
        // Invalidate transaction-related caches
        CacheKeys.templates(companyId, storeId),
      ],
    );
  }
}

/// Progress tracking for long-running optimistic operations
class OptimisticOperationProgress {
  final String operationId;
  final String message;
  final double progress; // 0.0 to 1.0
  final DateTime timestamp;
  
  const OptimisticOperationProgress({
    required this.operationId,
    required this.message,
    required this.progress,
    required this.timestamp,
  });
  
  bool get isComplete => progress >= 1.0;
}

