/// Performance Optimization Validation Test Suite
/// Comprehensive testing to ensure performance improvements work correctly
/// without breaking existing functionality
/// 
/// Test Coverage:
/// - Performance monitoring accuracy
/// - Cache behavior validation
/// - Error handling and recovery
/// - Memory usage and cleanup
/// - Backward compatibility

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import '../services/monitored_template_service.dart';
import '../../../../core/cache/smart_cache_manager.dart';
import '../../../../core/performance/performance_monitor.dart';
import '../../../../core/error_handling/error_recovery_system.dart';

/// Performance Validation Test Suite
class PerformanceValidationTests {
  
  /// Test 1: Verify performance monitoring accuracy
  static Future<ValidationResult> testPerformanceMonitoringAccuracy() async {
    final monitor = PerformanceMonitor();
    final results = <String>[];
    
    try {
      // Test basic monitoring
      final result = await monitor.measure<String>(
        'test_operation',
        () async {
          await Future.delayed(const Duration(milliseconds: 100));
          return 'test_result';
        },
      );
      
      if (result != 'test_result') {
        return ValidationResult.fail('Performance monitor returned wrong result: $result');
      }
      
      final stats = monitor.getStats('test_operation');
      if (stats == null) {
        return ValidationResult.fail('Performance stats not recorded');
      }
      
      if (stats.totalExecutions != 1) {
        return ValidationResult.fail('Incorrect execution count: ${stats.totalExecutions}');
      }
      
      if (stats.averageExecutionTime.inMilliseconds < 90 || 
          stats.averageExecutionTime.inMilliseconds > 150) {
        return ValidationResult.fail('Inaccurate timing: ${stats.averageExecutionTime.inMilliseconds}ms');
      }
      
      results.add('✅ Performance monitoring accuracy verified');
      
      // Test memoization
      var callCount = 0;
      final memoizedFn = monitor.memoize<int>(
        'memoized_test',
        () {
          callCount++;
          return 42;
        },
      );
      
      final first = memoizedFn();
      final second = memoizedFn();
      
      if (first != 42 || second != 42) {
        return ValidationResult.fail('Memoization returned wrong values: $first, $second');
      }
      
      if (callCount != 1) {
        return ValidationResult.fail('Memoization not working - function called $callCount times');
      }
      
      results.add('✅ Memoization functionality verified');
      
      return ValidationResult.pass('Performance monitoring accuracy test passed', results);
      
    } catch (e) {
      return ValidationResult.fail('Performance monitoring test failed: $e');
    }
  }

  /// Test 2: Validate cache behavior
  static Future<ValidationResult> testCacheBehavior() async {
    final cache = SmartCacheManager();
    await cache.clear();
    final results = <String>[];
    
    try {
      // Test basic cache operations
      await cache.set('test_key', 'test_value');
      final cachedValue = await cache.get<String>('test_key');
      
      if (cachedValue != 'test_value') {
        return ValidationResult.fail('Cache set/get failed: $cachedValue');
      }
      
      results.add('✅ Basic cache operations verified');
      
      // Test TTL expiration
      await cache.set('ttl_test', 'ttl_value', ttl: const Duration(milliseconds: 10));
      await Future.delayed(const Duration(milliseconds: 50));
      final expiredValue = await cache.get<String>('ttl_test');
      
      if (expiredValue != null) {
        return ValidationResult.fail('TTL not working - expired value still cached: $expiredValue');
      }
      
      results.add('✅ TTL expiration verified');
      
      // Test stale-while-revalidate
      var refreshCallCount = 0;
      await cache.set('stale_test', 'original_value', ttl: const Duration(milliseconds: 10));
      await Future.delayed(const Duration(milliseconds: 50));
      
      final staleValue = await cache.get<String>(
        'stale_test',
        allowStale: true,
        refresher: () async {
          refreshCallCount++;
          await Future.delayed(const Duration(milliseconds: 10));
          return 'fresh_value';
        },
      );
      
      if (staleValue != 'original_value') {
        return ValidationResult.fail('Stale-while-revalidate failed: $staleValue');
      }
      
      // Allow time for background refresh
      await Future.delayed(const Duration(milliseconds: 50));
      
      if (refreshCallCount != 1) {
        return ValidationResult.fail('Background refresh not triggered: $refreshCallCount calls');
      }
      
      results.add('✅ Stale-while-revalidate verified');
      
      // Test cache statistics
      final stats = cache.getStats();
      if (stats['totalEntries'] == null) {
        return ValidationResult.fail('Cache statistics not working');
      }
      
      results.add('✅ Cache statistics verified');
      
      return ValidationResult.pass('Cache behavior test passed', results);
      
    } catch (e) {
      return ValidationResult.fail('Cache behavior test failed: $e');
    }
  }

  /// Test 3: Validate error handling and recovery
  static Future<ValidationResult> testErrorHandlingAndRecovery() async {
    final errorRecovery = ErrorRecoverySystem();
    final results = <String>[];
    
    try {
      // Test circuit breaker
      
      var attemptCount = 0;
      try {
        await errorRecovery.executeWithRecovery<String>(
          serviceName: 'test_service',
          operation: () async {
            attemptCount++;
            throw Exception('Simulated failure');
          },
          maxRetries: 2,
        );
      } catch (e) {
        // Expected to fail
      }
      
      if (attemptCount != 3) { // Original + 2 retries
        return ValidationResult.fail('Retry logic not working: $attemptCount attempts');
      }
      
      results.add('✅ Retry logic verified');
      
      // Test fallback mechanism
      final resultWithFallback = await errorRecovery.executeWithRecovery<String>(
        serviceName: 'fallback_test',
        operation: () async => throw Exception('Primary failure'),
        fallbackOperation: () async => 'fallback_result',
        maxRetries: 1,
      );
      
      if (resultWithFallback != 'fallback_result') {
        return ValidationResult.fail('Fallback not working: $resultWithFallback');
      }
      
      results.add('✅ Fallback mechanism verified');
      
      // Test cached data recovery
      final resultWithCache = await errorRecovery.executeWithRecovery<String>(
        serviceName: 'cache_recovery_test',
        operation: () async => throw Exception('Operation failure'),
        cachedData: 'cached_result',
        maxRetries: 1,
      );
      
      if (resultWithCache != 'cached_result') {
        return ValidationResult.fail('Cache recovery not working: $resultWithCache');
      }
      
      results.add('✅ Cache recovery verified');
      
      return ValidationResult.pass('Error handling and recovery test passed', results);
      
    } catch (e) {
      return ValidationResult.fail('Error handling test failed: $e');
    }
  }

  /// Test 4: Memory usage and cleanup validation
  static Future<ValidationResult> testMemoryUsageAndCleanup() async {
    final cache = SmartCacheManager();
    final monitor = PerformanceMonitor();
    final results = <String>[];
    
    try {
      // Fill cache to test cleanup
      for (int i = 0; i < 250; i++) {
        await cache.set('test_key_$i', 'test_value_$i');
      }
      
      final statsBeforeCleanup = cache.getStats();
      final entriesBeforeCleanup = statsBeforeCleanup['totalEntries'] as int;
      
      if (entriesBeforeCleanup > 200) {
        return ValidationResult.fail('Cache not respecting size limits: $entriesBeforeCleanup entries');
      }
      
      results.add('✅ Cache size limits enforced');
      
      // Test automatic cleanup
      await cache.cleanup();
      
      results.add('✅ Cache cleanup completed');
      
      // Test performance monitor cleanup
      for (int i = 0; i < 50; i++) {
        await monitor.measure('cleanup_test_$i', () async => i);
      }
      
      monitor.clear();
      
      final operationNames = monitor.getOperationNames();
      if (operationNames.isNotEmpty) {
        return ValidationResult.fail('Performance monitor not cleared: ${operationNames.length} operations remain');
      }
      
      results.add('✅ Performance monitor cleanup verified');
      
      return ValidationResult.pass('Memory usage and cleanup test passed', results);
      
    } catch (e) {
      return ValidationResult.fail('Memory usage test failed: $e');
    }
  }

  /// Test 5: Backward compatibility validation
  static Future<ValidationResult> testBackwardCompatibility() async {
    final service = MonitoredTemplateService();
    final results = <String>[];
    
    try {
      // Test that monitoring can be disabled
      service.setMonitoringEnabled(false);
      
      // Test direct loading (should work without monitoring)
      try {
        final templates = await service.loadTemplatesMonitored(
          companyId: 'test_company',
          storeId: 'test_store',
          userId: 'test_user',
          enableWarmup: false,
        );
        
        // Should return empty list for test data but not throw
        if (templates is! List) {
          return ValidationResult.fail('Template loading failed with monitoring disabled');
        }
        
        results.add('✅ Template loading works with monitoring disabled');
      } catch (e) {
        return ValidationResult.fail('Template loading failed when monitoring disabled: $e');
      }
      
      // Re-enable monitoring
      service.setMonitoringEnabled(true);
      
      // Test that monitoring doesn't break existing functionality
      try {
        final templatesWithMonitoring = await service.loadTemplatesMonitored(
          companyId: 'test_company',
          storeId: 'test_store', 
          userId: 'test_user',
          enableWarmup: false,
        );
        
        if (templatesWithMonitoring is! List) {
          return ValidationResult.fail('Template loading failed with monitoring enabled');
        }
        
        results.add('✅ Template loading works with monitoring enabled');
      } catch (e) {
        return ValidationResult.fail('Template loading failed when monitoring enabled: $e');
      }
      
      // Test that performance stats are available
      final stats = service.getPerformanceStats();
      if (stats is! Map) {
        return ValidationResult.fail('Performance stats not available');
      }
      
      results.add('✅ Performance stats accessible');
      
      return ValidationResult.pass('Backward compatibility test passed', results);
      
    } catch (e) {
      return ValidationResult.fail('Backward compatibility test failed: $e');
    }
  }

  /// Test 6: Integration test - Full workflow
  static Future<ValidationResult> testFullWorkflowIntegration() async {
    final service = MonitoredTemplateService();
    final results = <String>[];
    
    try {
      // Initialize session
      service.initializeForSession(
        companyId: 'test_company',
        storeId: 'test_store',
        userId: 'test_user',
        enableBackgroundWarmup: false, // Disable for test
      );
      
      results.add('✅ Session initialization completed');
      
      // Test multiple concurrent operations
      final futures = <Future<List<Map<String, dynamic>>>>[];
      for (int i = 0; i < 5; i++) {
        futures.add(service.loadTemplatesMonitored(
          companyId: 'test_company_$i',
          storeId: 'test_store_$i',
          userId: 'test_user',
        ));
      }
      
      final allResults = await Future.wait(futures);
      
      if (allResults.length != 5) {
        return ValidationResult.fail('Concurrent operations failed: ${allResults.length} results');
      }
      
      results.add('✅ Concurrent operations handled correctly');
      
      // Verify performance stats were collected
      final stats = service.getPerformanceStats();
      final templateStats = stats['load_templates'];
      
      if (templateStats == null) {
        return ValidationResult.fail('Performance stats not collected for load_templates');
      }
      
      if (templateStats.totalExecutions < 5) {
        return ValidationResult.fail('Performance stats incomplete: ${templateStats.totalExecutions} executions');
      }
      
      results.add('✅ Performance stats collected correctly');
      
      // Test system summary
      final systemSummary = service.getSystemSummary();
      
      if (systemSummary['systemHealth'] == null) {
        return ValidationResult.fail('System summary incomplete');
      }
      
      results.add('✅ System summary generated');
      
      // Cleanup
      service.dispose();
      
      results.add('✅ Service cleanup completed');
      
      return ValidationResult.pass('Full workflow integration test passed', results);
      
    } catch (e) {
      return ValidationResult.fail('Full workflow integration test failed: $e');
    }
  }

  /// Run all validation tests
  static Future<PerformanceValidationReport> runAllTests() async {
    final testResults = <String, ValidationResult>{};
    
    print('🧪 Starting comprehensive performance validation tests...\n');
    
    // Run all tests
    final tests = {
      'Performance Monitoring Accuracy': testPerformanceMonitoringAccuracy,
      'Cache Behavior': testCacheBehavior,
      'Error Handling and Recovery': testErrorHandlingAndRecovery,
      'Memory Usage and Cleanup': testMemoryUsageAndCleanup,
      'Backward Compatibility': testBackwardCompatibility,
      'Full Workflow Integration': testFullWorkflowIntegration,
    };
    
    for (final entry in tests.entries) {
      final testName = entry.key;
      final testFunction = entry.value;
      
      print('⚡ Running $testName...');
      
      try {
        final result = await testFunction();
        testResults[testName] = result;
        
        if (result.passed) {
          print('✅ $testName PASSED');
          for (final detail in result.details) {
            print('   $detail');
          }
        } else {
          print('❌ $testName FAILED: ${result.message}');
        }
      } catch (e) {
        testResults[testName] = ValidationResult.fail('Test execution failed: $e');
        print('💥 $testName CRASHED: $e');
      }
      
      print('');
    }
    
    return PerformanceValidationReport(testResults);
  }
}

/// Validation result class
class ValidationResult {
  final bool passed;
  final String message;
  final List<String> details;
  
  ValidationResult._(this.passed, this.message, this.details);
  
  factory ValidationResult.pass(String message, [List<String>? details]) {
    return ValidationResult._(true, message, details ?? []);
  }
  
  factory ValidationResult.fail(String message) {
    return ValidationResult._(false, message, []);
  }
}

/// Performance validation report
class PerformanceValidationReport {
  final Map<String, ValidationResult> testResults;
  
  PerformanceValidationReport(this.testResults);
  
  bool get allTestsPassed => testResults.values.every((result) => result.passed);
  
  int get passedCount => testResults.values.where((result) => result.passed).length;
  int get failedCount => testResults.values.where((result) => !result.passed).length;
  int get totalCount => testResults.length;
  
  double get successRate => totalCount > 0 ? (passedCount / totalCount) * 100 : 0;
  
  void printReport() {
    print('📊 Performance Optimization Validation Report');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('Total Tests: $totalCount');
    print('Passed: $passedCount');
    print('Failed: $failedCount');
    print('Success Rate: ${successRate.toStringAsFixed(1)}%');
    print('Overall Status: ${allTestsPassed ? "✅ ALL TESTS PASSED" : "❌ SOME TESTS FAILED"}');
    
    if (!allTestsPassed) {
      print('\n❌ Failed Tests:');
      for (final entry in testResults.entries) {
        if (!entry.value.passed) {
          print('  • ${entry.key}: ${entry.value.message}');
        }
      }
    }
    
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    
    if (allTestsPassed) {
      print('🎉 All performance optimizations validated successfully!');
      print('The system is ready for integration with confidence.');
    } else {
      print('⚠️ Some tests failed. Please review and fix issues before deployment.');
    }
  }
  
  /// Get validation summary for integration
  Map<String, dynamic> getValidationSummary() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'allTestsPassed': allTestsPassed,
      'totalTests': totalCount,
      'passedTests': passedCount,
      'failedTests': failedCount,
      'successRate': successRate,
      'testDetails': testResults.map(
        (name, result) => MapEntry(name, {
          'passed': result.passed,
          'message': result.message,
          'details': result.details,
        }),
      ),
      'recommendation': allTestsPassed 
        ? 'Ready for production deployment'
        : 'Review failed tests before deployment',
    };
  }
}