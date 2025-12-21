import 'dart:async';
import 'package:flutter/foundation.dart';

/// StateSynchronizer - Prevents race conditions in state updates
/// Ensures state operations complete in order without conflicts
/// 
/// Features:
/// - Synchronizes concurrent state updates
/// - Prevents race conditions during auth flows
/// - Maintains operation order
/// - Provides operation status tracking
class StateSynchronizer {
  // Singleton pattern
  StateSynchronizer._privateConstructor();
  static final StateSynchronizer _instance = StateSynchronizer._privateConstructor();
  static StateSynchronizer get instance => _instance;
  
  // Operation tracking
  final Map<String, Completer<void>> _pendingOperations = {};
  final Map<String, DateTime> _operationTimestamps = {};
  final Map<String, int> _operationCounts = {};
  
  // Configuration
  static const Duration _operationTimeout = Duration(seconds: 10);
  static const int _maxConcurrentOperations = 5;
  
  /// Execute an operation with synchronization
  /// Ensures operations with the same ID complete sequentially
  Future<T> synchronized<T>(
    String operationId,
    Future<T> Function() operation, {
    Duration? timeout,
    bool allowConcurrent = false,
  }) async {
    // If concurrent operations are not allowed, wait for existing operation
    if (!allowConcurrent && _pendingOperations.containsKey(operationId)) {
      try {
        // Wait for the pending operation to complete
        await _pendingOperations[operationId]!.future
            .timeout(timeout ?? _operationTimeout);
      } catch (e) {
        // If timeout or error, continue with new operation
        _pendingOperations.remove(operationId);
      }
    }
    
    // Check concurrent operation limit
    if (_pendingOperations.length >= _maxConcurrentOperations) {
      // Wait for the oldest operation to complete
      final oldestKey = _findOldestOperation();
      if (oldestKey != null) {
        try {
          await _pendingOperations[oldestKey]!.future
              .timeout(const Duration(seconds: 2));
        } catch (_) {
          _pendingOperations.remove(oldestKey);
        }
      }
    }
    
    // Create new operation
    final completer = Completer<void>();
    _pendingOperations[operationId] = completer;
    _operationTimestamps[operationId] = DateTime.now();
    _operationCounts[operationId] = (_operationCounts[operationId] ?? 0) + 1;
    
    try {
      // Execute the operation
      final result = await operation();
      
      // Mark as complete
      if (!completer.isCompleted) {
        completer.complete();
      }
      
      return result;
    } catch (error) {
      // Mark as failed
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
      
      rethrow;
    } finally {
      // Clean up
      _pendingOperations.remove(operationId);
    }
  }
  
  /// Execute multiple operations in sequence
  Future<List<T>> sequential<T>(
    List<(String, Future<T> Function())> operations,
  ) async {
    final results = <T>[];
    
    for (final (id, operation) in operations) {
      final result = await synchronized(id, operation);
      results.add(result);
    }
    
    return results;
  }
  
  /// Execute multiple operations in parallel with synchronization
  Future<List<T>> parallel<T>(
    List<(String, Future<T> Function())> operations,
  ) async {
    final futures = operations.map((op) {
      final (id, operation) = op;
      return synchronized(id, operation, allowConcurrent: true);
    }).toList();
    
    return Future.wait(futures);
  }
  
  /// Wait for a specific operation to complete
  Future<void> waitFor(String operationId, {Duration? timeout}) async {
    if (_pendingOperations.containsKey(operationId)) {
      await _pendingOperations[operationId]!.future
          .timeout(timeout ?? _operationTimeout);
    }
  }
  
  /// Check if an operation is pending
  bool isPending(String operationId) {
    return _pendingOperations.containsKey(operationId);
  }
  
  /// Get pending operation count
  int get pendingCount => _pendingOperations.length;
  
  /// Cancel a pending operation (marks it as completed)
  void cancel(String operationId) {
    if (_pendingOperations.containsKey(operationId)) {
      final completer = _pendingOperations[operationId]!;
      if (!completer.isCompleted) {
        completer.completeError(StateError('Operation cancelled'));
      }
      _pendingOperations.remove(operationId);
    }
  }
  
  /// Cancel all pending operations
  void cancelAll() {
    for (final completer in _pendingOperations.values) {
      if (!completer.isCompleted) {
        completer.completeError(StateError('All operations cancelled'));
      }
    }
    _pendingOperations.clear();
  }
  
  /// Get operation statistics
  Map<String, dynamic> getStats() {
    return {
      'pending_operations': _pendingOperations.length,
      'total_operations': _operationCounts.values.fold(0, (a, b) => a + b),
      'unique_operations': _operationCounts.length,
      'operation_counts': Map.from(_operationCounts),
    };
  }
  
  /// Find the oldest pending operation
  String? _findOldestOperation() {
    if (_operationTimestamps.isEmpty) return null;
    
    String? oldestKey;
    DateTime? oldestTime;
    
    for (final entry in _operationTimestamps.entries) {
      if (_pendingOperations.containsKey(entry.key)) {
        if (oldestTime == null || entry.value.isBefore(oldestTime)) {
          oldestKey = entry.key;
          oldestTime = entry.value;
        }
      }
    }
    
    return oldestKey;
  }
  
  /// Clear all tracking data
  void reset() {
    cancelAll();
    _operationTimestamps.clear();
    _operationCounts.clear();
  }
}

/// Extension for easy access
extension StateSynchronizerExtension on Object {
  StateSynchronizer get stateSynchronizer => StateSynchronizer.instance;
}