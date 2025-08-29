/// Template Performance Integration Service
/// Provides comprehensive performance monitoring and optimization for template operations
/// 
/// Features:
/// - Real-time performance metrics collection
/// - Automated memoization for expensive operations
/// - Template loading optimization with caching coordination
/// - User experience impact analysis
/// - Performance bottleneck identification
/// - Automatic optimization recommendations

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/performance/performance_monitor.dart';
import '../../../../core/cache/smart_cache_manager.dart';
import '../../../../core/error_handling/error_recovery_system.dart';
import '../../../../core/optimistic/optimistic_operations_manager.dart';

/// Template operation types for performance tracking
enum TemplateOperation {
  loadTemplates,
  loadCashLocations,
  loadCounterparties,
  executeTemplate,
  createTemplate,
  deleteTemplate,
  cacheWarmup,
  backgroundSync,
}

extension TemplateOperationExtension on TemplateOperation {
  String get operationName {
    switch (this) {
      case TemplateOperation.loadTemplates:
        return 'load_templates';
      case TemplateOperation.loadCashLocations:
        return 'load_cash_locations';
      case TemplateOperation.loadCounterparties:
        return 'load_counterparties';
      case TemplateOperation.executeTemplate:
        return 'execute_template';
      case TemplateOperation.createTemplate:
        return 'create_template';
      case TemplateOperation.deleteTemplate:
        return 'delete_template';
      case TemplateOperation.cacheWarmup:
        return 'cache_warmup';
      case TemplateOperation.backgroundSync:
        return 'background_sync';
    }
  }
}

/// Performance statistics for template operations
class TemplatePerformanceStats {
  final String operationName;
  final int totalExecutions;
  final Duration averageLoadTime;
  final Duration minLoadTime;
  final Duration maxLoadTime;
  final double cacheHitRate;
  final double errorRate;
  final double userImpactScore; // 0-10, higher means more user-facing impact
  final List<String> optimizationRecommendations;
  final DateTime lastUpdated;

  const TemplatePerformanceStats({
    required this.operationName,
    required this.totalExecutions,
    required this.averageLoadTime,
    required this.minLoadTime,
    required this.maxLoadTime,
    required this.cacheHitRate,
    required this.errorRate,
    required this.userImpactScore,
    required this.optimizationRecommendations,
    required this.lastUpdated,
  });

  String get performanceGrade {
    if (averageLoadTime.inMilliseconds < 100 && cacheHitRate > 0.8) return 'A+';
    if (averageLoadTime.inMilliseconds < 300 && cacheHitRate > 0.6) return 'A';
    if (averageLoadTime.inMilliseconds < 500 && errorRate < 0.05) return 'B';
    if (averageLoadTime.inMilliseconds < 1000 && errorRate < 0.1) return 'C';
    return 'D';
  }

  bool get needsOptimization => userImpactScore > 7 || averageLoadTime.inMilliseconds > 1000;
}

/// Template Performance Service
class TemplatePerformanceService {
  static final TemplatePerformanceService _instance = TemplatePerformanceService._internal();
  factory TemplatePerformanceService() => _instance;
  TemplatePerformanceService._internal();

  final PerformanceMonitor _performanceMonitor = PerformanceMonitor();
  final SmartCacheManager _cacheManager = SmartCacheManager();
  final ErrorRecoverySystem _errorRecovery = ErrorRecoverySystem();
  final OptimisticOperationsManager _optimisticOps = OptimisticOperationsManager();
  
  // Memoized operation cache
  final Map<String, dynamic> _memoizedOperations = {};

  /// Execute template operation with comprehensive monitoring
  Future<T> monitoredTemplateOperation<T>({
    required TemplateOperation operation,
    required Future<T> Function() executor,
    Map<String, dynamic> context = const {},
    bool enableMemoization = true,
    Duration memoizationTTL = const Duration(minutes: 10),
  }) async {
    final operationName = operation.operationName;
    final metadata = {
      ...context,
      'operation_type': operation.name,
      'user_facing': _isUserFacingOperation(operation),
      'cache_enabled': enableMemoization,
    };

    return await _performanceMonitor.measure<T>(
      operationName,
      () async {
        // Try optimistic operation for user-facing operations
        if (_isUserFacingOperation(operation) && operation == TemplateOperation.executeTemplate) {
          return await _handleOptimisticOperation<T>(operationName, executor, context);
        }

        // Execute with error recovery
        return await _errorRecovery.executeWithRecovery<T>(
          serviceName: operationName,
          operation: executor,
          maxRetries: _getRetryCountForOperation(operation),
          allowedStrategies: [
            RecoveryStrategy.retry,
            RecoveryStrategy.cache,
            RecoveryStrategy.fallback,
          ],
        );
      },
      metadata: metadata,
      enableMemoization: enableMemoization,
      memoizationTTL: memoizationTTL,
    );
  }

  /// Handle optimistic operations for better UX
  Future<T> _handleOptimisticOperation<T>(
    String operationName,
    Future<T> Function() executor,
    Map<String, dynamic> context,
  ) async {
    // For now, execute directly - optimistic operations require specific UI integration
    return await executor();
  }

  /// Get memoized template data loader
  Future<T> Function() getMemoizedLoader<T>(
    TemplateOperation operation,
    Future<T> Function() loader,
    Map<String, dynamic> context,
  ) {
    return _performanceMonitor.memoizeAsync<T>(
      '${operation.operationName}_memoized',
      loader,
      ttl: _getMemoizationTTLForOperation(operation),
      metadata: context,
    );
  }

  /// Monitor template loading performance with cache coordination
  Future<List<Map<String, dynamic>>> monitoredTemplateLoad({
    required String companyId,
    required String storeId,
    required Future<List<Map<String, dynamic>>> Function() loader,
    bool warmupRelatedData = true,
  }) async {
    final context = {
      'company_id': companyId,
      'store_id': storeId,
      'warmup_enabled': warmupRelatedData,
    };

    // Start warmup in background if enabled
    if (warmupRelatedData) {
      _backgroundWarmup(companyId, storeId);
    }

    return await monitoredTemplateOperation<List<Map<String, dynamic>>>(
      operation: TemplateOperation.loadTemplates,
      executor: loader,
      context: context,
      enableMemoization: true,
    );
  }

  /// Background warmup for related data
  void _backgroundWarmup(String companyId, String storeId) {
    // Start warmup operations in background without blocking
    Future.wait([
      _warmupCashLocations(companyId, storeId),
      _warmupCounterparties(companyId),
    ]).catchError((e) {
      // Silent fail for background operations
      if (kDebugMode) {
        print('Background warmup failed: $e');
      }
    });
  }

  Future<void> _warmupCashLocations(String companyId, String storeId) async {
    await _performanceMonitor.measure(
      TemplateOperation.cacheWarmup.operationName,
      () async {
        final cacheKey = CacheKeys.cashLocations(companyId, storeId);
        // Check if already cached
        final cached = await _cacheManager.get(cacheKey);
        if (cached == null) {
          // Trigger provider to load and cache
          // This would need integration with the actual provider
        }
      },
      metadata: {'warmup_type': 'cash_locations', 'company_id': companyId, 'store_id': storeId},
    );
  }

  Future<void> _warmupCounterparties(String companyId) async {
    await _performanceMonitor.measure(
      TemplateOperation.cacheWarmup.operationName,
      () async {
        final cacheKey = CacheKeys.counterparties(companyId);
        final cached = await _cacheManager.get(cacheKey);
        if (cached == null) {
          // Trigger provider to load and cache
        }
      },
      metadata: {'warmup_type': 'counterparties', 'company_id': companyId},
    );
  }

  /// Get comprehensive performance statistics
  TemplatePerformanceStats getTemplatePerformanceStats(TemplateOperation operation) {
    final stats = _performanceMonitor.getStats(operation.operationName);
    final cacheStats = _cacheManager.getStats();
    
    if (stats == null) {
      return TemplatePerformanceStats(
        operationName: operation.operationName,
        totalExecutions: 0,
        averageLoadTime: Duration.zero,
        minLoadTime: Duration.zero,
        maxLoadTime: Duration.zero,
        cacheHitRate: 0.0,
        errorRate: 0.0,
        userImpactScore: 0.0,
        optimizationRecommendations: [],
        lastUpdated: DateTime.now(),
      );
    }

    // Calculate cache hit rate from metrics
    final cacheHitRate = _calculateCacheHitRate(operation.operationName);
    final userImpactScore = _calculateUserImpactScore(operation, stats);
    final recommendations = _generateOptimizationRecommendations(operation, stats, cacheHitRate);

    return TemplatePerformanceStats(
      operationName: operation.operationName,
      totalExecutions: stats.totalExecutions,
      averageLoadTime: stats.averageExecutionTime,
      minLoadTime: stats.minExecutionTime,
      maxLoadTime: stats.maxExecutionTime,
      cacheHitRate: cacheHitRate,
      errorRate: stats.errorRate,
      userImpactScore: userImpactScore,
      optimizationRecommendations: recommendations,
      lastUpdated: DateTime.now(),
    );
  }

  /// Calculate cache hit rate for operation
  double _calculateCacheHitRate(String operationName) {
    final hitStats = _performanceMonitor.getStats('${operationName}_cache_hit');
    final totalStats = _performanceMonitor.getStats(operationName);
    
    if (hitStats == null || totalStats == null) return 0.0;
    
    final totalRequests = totalStats.totalExecutions;
    final cacheHits = hitStats.totalExecutions;
    
    return totalRequests > 0 ? cacheHits / totalRequests : 0.0;
  }

  /// Calculate user impact score (0-10)
  double _calculateUserImpactScore(TemplateOperation operation, PerformanceStats stats) {
    var score = 0.0;
    
    // Base score from execution frequency (higher = more important)
    if (stats.totalExecutions > 100) score += 3.0;
    if (stats.totalExecutions > 1000) score += 2.0;
    
    // User-facing operations have higher impact
    if (_isUserFacingOperation(operation)) score += 3.0;
    
    // Poor performance increases impact score
    if (stats.averageExecutionTime.inMilliseconds > 1000) score += 2.0;
    if (stats.errorRate > 0.05) score += 1.0; // >5% error rate
    
    return score.clamp(0.0, 10.0);
  }

  /// Generate optimization recommendations
  List<String> _generateOptimizationRecommendations(
    TemplateOperation operation,
    PerformanceStats stats,
    double cacheHitRate,
  ) {
    final recommendations = <String>[];
    
    // Slow operations
    if (stats.averageExecutionTime.inMilliseconds > 500) {
      recommendations.add('Consider implementing preloading for ${operation.operationName}');
    }
    
    if (stats.averageExecutionTime.inMilliseconds > 1000) {
      recommendations.add('URGENT: Optimize ${operation.operationName} - average ${stats.averageExecutionTime.inMilliseconds}ms');
    }
    
    // Poor cache performance
    if (cacheHitRate < 0.5 && stats.totalExecutions > 10) {
      recommendations.add('Improve caching strategy for ${operation.operationName} (${(cacheHitRate * 100).toStringAsFixed(1)}% hit rate)');
    }
    
    // High error rate
    if (stats.errorRate > 0.1) {
      recommendations.add('Investigate error rate for ${operation.operationName} (${(stats.errorRate * 100).toStringAsFixed(1)}%)');
    }
    
    // High frequency operations that could benefit from memoization
    if (stats.totalExecutions > 50 && 
        stats.averageExecutionTime.inMilliseconds > 200 &&
        cacheHitRate < 0.8) {
      recommendations.add('Enable memoization for ${operation.operationName}');
    }
    
    return recommendations;
  }

  /// Check if operation is user-facing
  bool _isUserFacingOperation(TemplateOperation operation) {
    switch (operation) {
      case TemplateOperation.loadTemplates:
      case TemplateOperation.loadCashLocations:
      case TemplateOperation.loadCounterparties:
      case TemplateOperation.executeTemplate:
        return true;
      case TemplateOperation.createTemplate:
      case TemplateOperation.deleteTemplate:
      case TemplateOperation.cacheWarmup:
      case TemplateOperation.backgroundSync:
        return false;
    }
  }

  /// Get retry count based on operation importance
  int _getRetryCountForOperation(TemplateOperation operation) {
    if (_isUserFacingOperation(operation)) return 2;
    return 1; // Background operations retry less
  }

  /// Get memoization TTL based on operation type
  Duration _getMemoizationTTLForOperation(TemplateOperation operation) {
    switch (operation) {
      case TemplateOperation.loadTemplates:
        return const Duration(minutes: 5); // Templates change more frequently
      case TemplateOperation.loadCashLocations:
        return const Duration(minutes: 15); // More stable data
      case TemplateOperation.loadCounterparties:
        return const Duration(minutes: 20); // Most stable data
      case TemplateOperation.executeTemplate:
        return const Duration(minutes: 1); // Short cache for execution results
      default:
        return const Duration(minutes: 10);
    }
  }

  /// Get overall system performance summary
  Map<String, dynamic> getSystemPerformanceSummary() {
    final allOperations = TemplateOperation.values;
    final operationStats = <String, TemplatePerformanceStats>{};
    final criticalIssues = <String>[];
    final recommendations = <String>[];

    for (final operation in allOperations) {
      final stats = getTemplatePerformanceStats(operation);
      operationStats[operation.operationName] = stats;

      if (stats.needsOptimization) {
        criticalIssues.add(operation.operationName);
      }

      recommendations.addAll(stats.optimizationRecommendations);
    }

    // Overall system metrics
    final overallStats = _performanceMonitor.getPerformanceSummary();
    final cacheStats = _cacheManager.getStats();

    return {
      'timestamp': DateTime.now().toIso8601String(),
      'systemHealth': criticalIssues.isEmpty ? 'healthy' : 'needs_attention',
      'criticalIssues': criticalIssues,
      'totalRecommendations': recommendations.length,
      'uniqueRecommendations': recommendations.toSet().toList(),
      'operationStats': operationStats,
      'overallPerformance': overallStats,
      'cachePerformance': cacheStats,
      'memoizationEfficiency': _getMemoizationEfficiency(),
    };
  }

  /// Calculate memoization efficiency
  Map<String, dynamic> _getMemoizationEfficiency() {
    final allStats = _performanceMonitor.getPerformanceSummary();
    final memoizationStats = allStats['memoizationStats'] as Map<String, dynamic>? ?? {};
    
    return {
      'cacheUtilization': memoizationStats['cacheUtilization'] ?? '0%',
      'effectiveOperations': _memoizedOperations.length,
      'memoryEfficient': memoizationStats['cacheSize'] ?? 0 < 400,
    };
  }

  /// Start continuous performance monitoring
  StreamSubscription<PerformanceMetric>? _monitoringSubscription;

  void startContinuousMonitoring() {
    _monitoringSubscription = _performanceMonitor.metricsStream.listen((metric) {
      // Log critical performance issues
      if (metric.isVerySlow || metric.performanceScore < 30) {
        if (kDebugMode) {
          print('⚠️ Performance Alert: ${metric.operationName} took ${metric.executionTime.inMilliseconds}ms');
        }
      }

      // Auto-optimization triggers
      if (metric.performanceScore < 20) {
        _triggerAutoOptimization(metric.operationName);
      }
    });
  }

  void stopContinuousMonitoring() {
    _monitoringSubscription?.cancel();
    _monitoringSubscription = null;
  }

  /// Trigger automatic optimization for poor performing operations
  void _triggerAutoOptimization(String operationName) {
    // Could implement automatic cache warming, preloading, etc.
    if (kDebugMode) {
      print('🔧 Auto-optimization triggered for $operationName');
    }
  }

  /// Clear all performance data and restart monitoring
  void reset() {
    _performanceMonitor.clear();
    _memoizedOperations.clear();
    stopContinuousMonitoring();
  }
}

/// Provider for template performance service
final templatePerformanceServiceProvider = Provider<TemplatePerformanceService>((ref) {
  return TemplatePerformanceService();
});

/// Provider for template performance statistics
final templatePerformanceStatsProvider = Provider<Map<String, TemplatePerformanceStats>>((ref) {
  final service = ref.watch(templatePerformanceServiceProvider);
  
  final stats = <String, TemplatePerformanceStats>{};
  for (final operation in TemplateOperation.values) {
    stats[operation.operationName] = service.getTemplatePerformanceStats(operation);
  }
  
  return stats;
});

/// Provider for system performance summary
final systemPerformanceSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final service = ref.watch(templatePerformanceServiceProvider);
  return service.getSystemPerformanceSummary();
});