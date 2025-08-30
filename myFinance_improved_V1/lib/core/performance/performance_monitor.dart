/// Performance Monitoring and Memoization System
/// Provides comprehensive performance tracking, optimization insights, and memoization
/// for expensive operations
/// 
/// Features:
/// - Real-time performance metrics collection
/// - Expensive operation memoization with intelligent cache management
/// - Performance bottleneck identification
/// - User experience impact analysis
/// - Automated performance optimization suggestions
/// - Memory usage monitoring and optimization

import 'dart:async';
import 'dart:math';

/// Performance metrics for individual operations
class PerformanceMetric {
  final String operationName;
  final Duration executionTime;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final int memoryUsed; // in bytes
  final double cpuUsage; // percentage
  
  const PerformanceMetric({
    required this.operationName,
    required this.executionTime,
    required this.timestamp,
    this.metadata = const {},
    this.memoryUsed = 0,
    this.cpuUsage = 0.0,
  });
  
  /// Check if operation is slow
  bool get isSlow => executionTime.inMilliseconds > 1000; // >1 second
  bool get isVerySlow => executionTime.inMilliseconds > 5000; // >5 seconds
  
  /// Get performance score (0-100, higher is better)
  double get performanceScore {
    final timeScore = (1000 / (executionTime.inMilliseconds + 1)) * 100;
    final memoryScore = memoryUsed > 0 ? max(0, 100 - (memoryUsed / (1024 * 1024))) : 100;
    final cpuScore = max(0, 100 - cpuUsage);
    
    return (timeScore * 0.5 + memoryScore * 0.25 + cpuScore * 0.25).clamp(0, 100);
  }
}

/// Aggregated performance statistics
class PerformanceStats {
  final String operationName;
  final int totalExecutions;
  final Duration averageExecutionTime;
  final Duration minExecutionTime;
  final Duration maxExecutionTime;
  final double averagePerformanceScore;
  final int slowExecutions;
  final double errorRate;
  final DateTime firstSeen;
  final DateTime lastSeen;
  
  const PerformanceStats({
    required this.operationName,
    required this.totalExecutions,
    required this.averageExecutionTime,
    required this.minExecutionTime,
    required this.maxExecutionTime,
    required this.averagePerformanceScore,
    required this.slowExecutions,
    required this.errorRate,
    required this.firstSeen,
    required this.lastSeen,
  });
  
  /// Get trend analysis
  String get performanceTrend {
    if (averagePerformanceScore > 80) return 'excellent';
    if (averagePerformanceScore > 60) return 'good';
    if (averagePerformanceScore > 40) return 'fair';
    if (averagePerformanceScore > 20) return 'poor';
    return 'critical';
  }
  
  /// Get optimization priority (0-10, higher needs more attention)
  int get optimizationPriority {
    var priority = 0;
    
    // High execution frequency
    if (totalExecutions > 100) priority += 3;
    if (totalExecutions > 1000) priority += 2;
    
    // Poor performance
    if (averagePerformanceScore < 40) priority += 3;
    if (averagePerformanceScore < 20) priority += 2;
    
    // High error rate
    if (errorRate > 0.1) priority += 2; // >10% error rate
    
    return priority.clamp(0, 10);
  }
}

/// Memoization cache entry
class MemoizedEntry<T> {
  final T result;
  final DateTime createdAt;
  final Duration computationTime;
  final int accessCount;
  final DateTime lastAccessed;
  
  MemoizedEntry({
    required this.result,
    required this.createdAt,
    required this.computationTime,
    this.accessCount = 1,
    DateTime? lastAccessed,
  }) : lastAccessed = lastAccessed ?? DateTime.now();
  
  MemoizedEntry<T> withAccess() {
    return MemoizedEntry<T>(
      result: result,
      createdAt: createdAt,
      computationTime: computationTime,
      accessCount: accessCount + 1,
      lastAccessed: DateTime.now(),
    );
  }
  
  bool isExpired(Duration ttl) => DateTime.now().difference(createdAt) > ttl;
  Duration get age => DateTime.now().difference(createdAt);
  double get efficiency => computationTime.inMilliseconds / accessCount;
}

/// Performance Monitor with Memoization
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();
  
  final List<PerformanceMetric> _metrics = [];
  final Map<String, List<PerformanceMetric>> _metricsByOperation = {};
  final Map<String, MemoizedEntry<dynamic>> _memoizationCache = {};
  final StreamController<PerformanceMetric> _metricsController = 
      StreamController<PerformanceMetric>.broadcast();
  
  // Configuration
  static const int maxMetricsHistory = 10000;
  static const int maxMemoizationEntries = 500;
  static const Duration defaultMemoizationTTL = Duration(minutes: 15);
  
  /// Stream of performance metrics
  Stream<PerformanceMetric> get metricsStream => _metricsController.stream;
  
  /// Execute and measure operation performance
  Future<T> measure<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic> metadata = const {},
    bool enableMemoization = false,
    Duration memoizationTTL = defaultMemoizationTTL,
  }) async {
    final stopwatch = Stopwatch()..start();
    final startTime = DateTime.now();
    
    // Check memoization cache first
    if (enableMemoization) {
      final cacheKey = _generateCacheKey(operationName, metadata);
      final cached = _getMemoizedResult<T>(cacheKey);
      if (cached != null) {
        stopwatch.stop();
        
        // Record cache hit metric
        final metric = PerformanceMetric(
          operationName: '${operationName}_cache_hit',
          executionTime: stopwatch.elapsed,
          timestamp: startTime,
          metadata: {...metadata, 'cached': true},
        );
        _recordMetric(metric);
        
        return cached;
      }
    }
    
    try {
      final result = await operation();
      stopwatch.stop();
      
      // Record successful execution
      final metric = PerformanceMetric(
        operationName: operationName,
        executionTime: stopwatch.elapsed,
        timestamp: startTime,
        metadata: metadata,
      );
      _recordMetric(metric);
      
      // Store in memoization cache
      if (enableMemoization) {
        final cacheKey = _generateCacheKey(operationName, metadata);
        _storeMemoizedResult(cacheKey, result, stopwatch.elapsed, memoizationTTL);
      }
      
      return result;
    } catch (error) {
      stopwatch.stop();
      
      // Record failed execution
      final metric = PerformanceMetric(
        operationName: operationName,
        executionTime: stopwatch.elapsed,
        timestamp: startTime,
        metadata: {...metadata, 'error': error.toString()},
      );
      _recordMetric(metric);
      
      rethrow;
    }
  }
  
  /// Synchronous version for CPU-intensive operations
  T measureSync<T>(
    String operationName,
    T Function() operation, {
    Map<String, dynamic> metadata = const {},
    bool enableMemoization = false,
    Duration memoizationTTL = defaultMemoizationTTL,
  }) {
    final stopwatch = Stopwatch()..start();
    final startTime = DateTime.now();
    
    // Check memoization cache first
    if (enableMemoization) {
      final cacheKey = _generateCacheKey(operationName, metadata);
      final cached = _getMemoizedResult<T>(cacheKey);
      if (cached != null) {
        stopwatch.stop();
        
        // Record cache hit metric
        final metric = PerformanceMetric(
          operationName: '${operationName}_cache_hit',
          executionTime: stopwatch.elapsed,
          timestamp: startTime,
          metadata: {...metadata, 'cached': true},
        );
        _recordMetric(metric);
        
        return cached;
      }
    }
    
    try {
      final result = operation();
      stopwatch.stop();
      
      // Record successful execution
      final metric = PerformanceMetric(
        operationName: operationName,
        executionTime: stopwatch.elapsed,
        timestamp: startTime,
        metadata: metadata,
      );
      _recordMetric(metric);
      
      // Store in memoization cache
      if (enableMemoization) {
        final cacheKey = _generateCacheKey(operationName, metadata);
        _storeMemoizedResult(cacheKey, result, stopwatch.elapsed, memoizationTTL);
      }
      
      return result;
    } catch (error) {
      stopwatch.stop();
      
      // Record failed execution
      final metric = PerformanceMetric(
        operationName: operationName,
        executionTime: stopwatch.elapsed,
        timestamp: startTime,
        metadata: {...metadata, 'error': error.toString()},
      );
      _recordMetric(metric);
      
      rethrow;
    }
  }
  
  /// Create memoized function
  T Function() memoize<T>(
    String operationName,
    T Function() operation, {
    Duration ttl = defaultMemoizationTTL,
    Map<String, dynamic> metadata = const {},
  }) {
    return () => measureSync<T>(
      operationName,
      operation,
      metadata: metadata,
      enableMemoization: true,
      memoizationTTL: ttl,
    );
  }
  
  /// Create memoized async function
  Future<T> Function() memoizeAsync<T>(
    String operationName,
    Future<T> Function() operation, {
    Duration ttl = defaultMemoizationTTL,
    Map<String, dynamic> metadata = const {},
  }) {
    return () => measure<T>(
      operationName,
      operation,
      metadata: metadata,
      enableMemoization: true,
      memoizationTTL: ttl,
    );
  }
  
  /// Record performance metric
  void _recordMetric(PerformanceMetric metric) {
    _metrics.add(metric);
    _metricsController.add(metric);
    
    // Group by operation
    _metricsByOperation
        .putIfAbsent(metric.operationName, () => [])
        .add(metric);
    
    // Cleanup old metrics
    if (_metrics.length > maxMetricsHistory) {
      final excess = _metrics.length - maxMetricsHistory;
      _metrics.removeRange(0, excess);
      
      // Clean up operation-specific metrics too
      for (final operationMetrics in _metricsByOperation.values) {
        if (operationMetrics.length > 1000) {
          operationMetrics.removeRange(0, 500);
        }
      }
    }
  }
  
  /// Generate cache key for memoization
  String _generateCacheKey(String operationName, Map<String, dynamic> metadata) {
    final metadataString = metadata.entries
        .map((e) => '${e.key}:${e.value}')
        .join('|');
    return '${operationName}#${metadataString.hashCode}';
  }
  
  /// Get memoized result
  T? _getMemoizedResult<T>(String cacheKey) {
    final entry = _memoizationCache[cacheKey] as MemoizedEntry<T>?;
    if (entry != null && !entry.isExpired(defaultMemoizationTTL)) {
      _memoizationCache[cacheKey] = entry.withAccess();
      return entry.result;
    }
    return null;
  }
  
  /// Store result in memoization cache
  void _storeMemoizedResult<T>(String cacheKey, T result, Duration computationTime, Duration ttl) {
    // Cleanup cache if it's getting too large
    if (_memoizationCache.length >= maxMemoizationEntries) {
      _evictLeastEfficientEntries();
    }
    
    _memoizationCache[cacheKey] = MemoizedEntry<T>(
      result: result,
      createdAt: DateTime.now(),
      computationTime: computationTime,
    );
  }
  
  /// Evict least efficient cache entries
  void _evictLeastEfficientEntries() {
    final entries = _memoizationCache.entries.toList();
    
    // Sort by efficiency (computation time / access count)
    entries.sort((a, b) {
      final aEfficiency = a.value.efficiency;
      final bEfficiency = b.value.efficiency;
      return bEfficiency.compareTo(aEfficiency); // Higher efficiency first
    });
    
    // Remove least efficient 20% of entries
    final evictionCount = (maxMemoizationEntries * 0.2).ceil();
    for (int i = entries.length - evictionCount; i < entries.length; i++) {
      _memoizationCache.remove(entries[i].key);
    }
  }
  
  /// Get performance statistics for an operation
  PerformanceStats? getStats(String operationName, {Duration? timeWindow}) {
    final operationMetrics = _metricsByOperation[operationName];
    if (operationMetrics == null || operationMetrics.isEmpty) {
      return null;
    }
    
    // Filter by time window if specified
    final relevantMetrics = timeWindow != null
        ? operationMetrics.where((m) => 
            DateTime.now().difference(m.timestamp) <= timeWindow).toList()
        : operationMetrics;
    
    if (relevantMetrics.isEmpty) return null;
    
    final totalExecutions = relevantMetrics.length;
    final executionTimes = relevantMetrics.map((m) => m.executionTime).toList();
    final performanceScores = relevantMetrics.map((m) => m.performanceScore).toList();
    
    final averageExecutionTime = Duration(
      microseconds: (executionTimes
          .map((t) => t.inMicroseconds)
          .reduce((a, b) => a + b) / totalExecutions).round(),
    );
    
    final minExecutionTime = executionTimes.reduce((a, b) => 
        a.inMicroseconds < b.inMicroseconds ? a : b);
    final maxExecutionTime = executionTimes.reduce((a, b) => 
        a.inMicroseconds > b.inMicroseconds ? a : b);
    
    final averagePerformanceScore = performanceScores
        .reduce((a, b) => a + b) / totalExecutions;
    
    final slowExecutions = relevantMetrics.where((m) => m.isSlow).length;
    
    final errorExecutions = relevantMetrics
        .where((m) => m.metadata.containsKey('error')).length;
    final errorRate = errorExecutions / totalExecutions;
    
    relevantMetrics.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return PerformanceStats(
      operationName: operationName,
      totalExecutions: totalExecutions,
      averageExecutionTime: averageExecutionTime,
      minExecutionTime: minExecutionTime,
      maxExecutionTime: maxExecutionTime,
      averagePerformanceScore: averagePerformanceScore,
      slowExecutions: slowExecutions,
      errorRate: errorRate,
      firstSeen: relevantMetrics.first.timestamp,
      lastSeen: relevantMetrics.last.timestamp,
    );
  }
  
  /// Get all operation names
  List<String> getOperationNames() {
    return _metricsByOperation.keys.toList();
  }
  
  /// Get performance summary
  Map<String, dynamic> getPerformanceSummary({Duration? timeWindow}) {
    final operationStats = <String, PerformanceStats>{};
    final criticalOperations = <String>[];
    final slowOperations = <String>[];
    
    for (final operationName in getOperationNames()) {
      final stats = getStats(operationName, timeWindow: timeWindow);
      if (stats != null) {
        operationStats[operationName] = stats;
        
        if (stats.optimizationPriority >= 8) {
          criticalOperations.add(operationName);
        } else if (stats.averagePerformanceScore < 50) {
          slowOperations.add(operationName);
        }
      }
    }
    
    // Overall metrics
    final allMetrics = timeWindow != null
        ? _metrics.where((m) => 
            DateTime.now().difference(m.timestamp) <= timeWindow).toList()
        : _metrics;
    
    final averageScore = allMetrics.isNotEmpty
        ? allMetrics.map((m) => m.performanceScore).reduce((a, b) => a + b) / allMetrics.length
        : 0.0;
    
    return {
      'totalOperations': operationStats.length,
      'totalExecutions': allMetrics.length,
      'averagePerformanceScore': averageScore,
      'criticalOperations': criticalOperations,
      'slowOperations': slowOperations,
      'memoizationStats': {
        'cacheSize': _memoizationCache.length,
        'maxCacheSize': maxMemoizationEntries,
        'cacheUtilization': (_memoizationCache.length / maxMemoizationEntries * 100).toStringAsFixed(1),
      },
      'operationStats': operationStats,
    };
  }
  
  /// Get optimization recommendations
  List<String> getOptimizationRecommendations({Duration? timeWindow}) {
    final recommendations = <String>[];
    final summary = getPerformanceSummary(timeWindow: timeWindow);
    final operationStats = summary['operationStats'] as Map<String, PerformanceStats>;
    
    // Check for critical operations
    final criticalOps = summary['criticalOperations'] as List<String>;
    for (final op in criticalOps) {
      final stats = operationStats[op]!;
      recommendations.add(
        'CRITICAL: Optimize "$op" - Average: ${stats.averageExecutionTime.inMilliseconds}ms, '
        'Score: ${stats.averagePerformanceScore.toStringAsFixed(1)}'
      );
    }
    
    // Check for operations that would benefit from memoization
    for (final entry in operationStats.entries) {
      final stats = entry.value;
      if (stats.totalExecutions > 10 && 
          stats.averageExecutionTime.inMilliseconds > 500 &&
          !entry.key.contains('cache_hit')) {
        recommendations.add(
          'Consider memoization for "${entry.key}" - ${stats.totalExecutions} executions, '
          'avg: ${stats.averageExecutionTime.inMilliseconds}ms'
        );
      }
    }
    
    // Check cache efficiency
    final cacheUtilization = double.parse(
        summary['memoizationStats']['cacheUtilization'].toString().replaceAll('%', '')
    );
    if (cacheUtilization > 80) {
      recommendations.add('Consider increasing memoization cache size - current utilization: ${cacheUtilization.toStringAsFixed(1)}%');
    }
    
    return recommendations;
  }
  
  /// Clear all performance data
  void clear() {
    _metrics.clear();
    _metricsByOperation.clear();
    _memoizationCache.clear();
  }
  
  /// Clear memoization cache only
  void clearMemoizationCache() {
    _memoizationCache.clear();
  }
}

/// Performance monitoring extensions for common operations
extension PerformanceMonitoring<T> on Future<T> {
  /// Add performance monitoring to any Future
  Future<T> withPerformanceMonitoring<T>(
    String operationName, {
    Map<String, dynamic> metadata = const {},
    bool enableMemoization = false,
  }) {
    return PerformanceMonitor().measure(
      operationName,
      () => this as Future<T>,
      metadata: metadata,
      enableMemoization: enableMemoization,
    );
  }
}

/// Memoization decorators for common use cases
class MemoizedFunctions {
  static final PerformanceMonitor _monitor = PerformanceMonitor();
  
  /// Memoize expensive computation
  static T Function() computeOnce<T>(
    String operationName,
    T Function() computation, {
    Duration ttl = const Duration(hours: 1),
  }) {
    return _monitor.memoize(operationName, computation, ttl: ttl);
  }
  
  /// Memoize async operation
  static Future<T> Function() computeOnceAsync<T>(
    String operationName,
    Future<T> Function() computation, {
    Duration ttl = const Duration(hours: 1),
  }) {
    return _monitor.memoizeAsync(operationName, computation, ttl: ttl);
  }
}

/// Performance benchmark utilities
class PerformanceBenchmark {
  /// Compare performance of different implementations
  static Future<Map<String, PerformanceStats>> benchmark<T>(
    Map<String, Future<T> Function()> implementations, {
    int iterations = 10,
    Duration warmupTime = const Duration(seconds: 1),
  }) async {
    final monitor = PerformanceMonitor();
    final results = <String, PerformanceStats>{};
    
    // Warmup
    await Future.delayed(warmupTime);
    
    // Run benchmarks
    for (final entry in implementations.entries) {
      final name = entry.key;
      final implementation = entry.value;
      
      for (int i = 0; i < iterations; i++) {
        await monitor.measure('benchmark_$name', implementation);
      }
      
      final stats = monitor.getStats('benchmark_$name');
      if (stats != null) {
        results[name] = stats;
      }
    }
    
    return results;
  }
}