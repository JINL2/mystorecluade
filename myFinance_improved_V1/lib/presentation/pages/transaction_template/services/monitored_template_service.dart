/// Monitored Template Service
/// Performance-aware wrapper for template operations that provides seamless monitoring
/// integration while maintaining backward compatibility with existing code
/// 
/// Features:
/// - Non-intrusive performance monitoring
/// - Automatic optimization suggestions
/// - Real-time performance metrics
/// - Seamless integration with existing providers
/// - Progressive enhancement approach

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';
import 'template_performance_service.dart';

/// Monitored Template Service - Wrapper for performance-aware operations
class MonitoredTemplateService {
  static final MonitoredTemplateService _instance = MonitoredTemplateService._internal();
  factory MonitoredTemplateService() => _instance;
  MonitoredTemplateService._internal();

  final TemplatePerformanceService _performanceService = TemplatePerformanceService();
  bool _monitoringEnabled = true;

  /// Enable or disable performance monitoring
  void setMonitoringEnabled(bool enabled) {
    _monitoringEnabled = enabled;
    if (enabled) {
      _performanceService.startContinuousMonitoring();
    } else {
      _performanceService.stopContinuousMonitoring();
    }
  }

  /// Load templates with performance monitoring
  Future<List<Map<String, dynamic>>> loadTemplatesMonitored({
    required String companyId,
    required String storeId,
    required String userId,
    bool enableWarmup = true,
    bool useEnhancedProvider = true,
  }) async {
    if (!_monitoringEnabled) {
      // Fallback to direct loading without monitoring
      return await _loadTemplatesDirect(companyId, storeId, userId);
    }

    return await _performanceService.monitoredTemplateLoad(
      companyId: companyId,
      storeId: storeId,
      warmupRelatedData: enableWarmup,
      loader: () => _loadTemplatesDirect(companyId, storeId, userId),
    );
  }

  /// Load cash locations with monitoring
  Future<List<Map<String, dynamic>>> loadCashLocationsMonitored({
    required String companyId,
    required String storeId,
  }) async {
    if (!_monitoringEnabled) {
      return await _loadCashLocationsDirect(companyId, storeId);
    }

    return await _performanceService.monitoredTemplateOperation<List<Map<String, dynamic>>>(
      operation: TemplateOperation.loadCashLocations,
      executor: () => _loadCashLocationsDirect(companyId, storeId),
      context: {
        'company_id': companyId,
        'store_id': storeId,
      },
    );
  }

  /// Load counterparties with monitoring
  Future<List<Map<String, dynamic>>> loadCounterpartiesMonitored({
    required String companyId,
  }) async {
    if (!_monitoringEnabled) {
      return await _loadCounterpartiesDirect(companyId);
    }

    return await _performanceService.monitoredTemplateOperation<List<Map<String, dynamic>>>(
      operation: TemplateOperation.loadCounterparties,
      executor: () => _loadCounterpartiesDirect(companyId),
      context: {
        'company_id': companyId,
      },
    );
  }

  /// Execute template with monitoring and optimization
  Future<Map<String, dynamic>> executeTemplateMonitored({
    required String templateId,
    required Map<String, dynamic> templateData,
    required Map<String, dynamic> executionContext,
  }) async {
    if (!_monitoringEnabled) {
      return await _executeTemplateDirect(templateId, templateData, executionContext);
    }

    return await _performanceService.monitoredTemplateOperation<Map<String, dynamic>>(
      operation: TemplateOperation.executeTemplate,
      executor: () => _executeTemplateDirect(templateId, templateData, executionContext),
      context: {
        'template_id': templateId,
        'execution_context': executionContext,
        'has_optimistic_data': templateData.isNotEmpty,
      },
      enableMemoization: false, // Template execution shouldn't be memoized
    );
  }

  /// Direct template loading without monitoring (fallback)
  Future<List<Map<String, dynamic>>> _loadTemplatesDirect(
    String companyId, 
    String storeId, 
    String userId,
  ) async {
    final supabase = Supabase.instance.client;
    
    List<dynamic> response;
    if (storeId.isNotEmpty) {
      response = await supabase
          .from('transaction_templates')
          .select('''
            template_id, 
            name, 
            template_description,
            data, 
            permission, 
            tags, 
            visibility_level, 
            is_active, 
            updated_by, 
            company_id, 
            store_id, 
            counterparty_id, 
            counterparty_cash_location_id,
            created_at
          ''')
          .eq('company_id', companyId)
          .eq('is_active', true)
          .or('store_id.eq.$storeId,store_id.is.null')
          .order('created_at', ascending: false)
          .limit(50);
    } else {
      response = await supabase
          .from('transaction_templates')
          .select('''
            template_id, 
            name, 
            template_description,
            data, 
            permission, 
            tags, 
            visibility_level, 
            is_active, 
            updated_by, 
            company_id, 
            store_id, 
            counterparty_id, 
            counterparty_cash_location_id,
            created_at
          ''')
          .eq('company_id', companyId)
          .eq('is_active', true)
          .isFilter('store_id', null)
          .order('created_at', ascending: false)
          .limit(50);
    }

    // Apply visibility filtering
    final filteredTemplates = response.where((template) {
      final visibilityLevel = template['visibility_level']?.toString() ?? 'public';
      final updatedBy = template['updated_by']?.toString() ?? '';
      
      if (visibilityLevel == 'public') return true;
      if (visibilityLevel == 'private') return updatedBy == userId;
      return false;
    }).toList();

    return List<Map<String, dynamic>>.from(filteredTemplates);
  }

  Future<List<Map<String, dynamic>>> _loadCashLocationsDirect(
    String companyId, 
    String storeId,
  ) async {
    final supabase = Supabase.instance.client;
    
    var query = supabase
        .from('cash_locations')
        .select('cash_location_id, location_name, location_type')
        .eq('company_id', companyId);
    
    if (storeId.isNotEmpty) {
      query = query.eq('store_id', storeId);
    } else {
      query = query.isFilter('store_id', null);
    }
    
    final response = await query.order('location_name');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> _loadCounterpartiesDirect(String companyId) async {
    final supabase = Supabase.instance.client;
    
    final response = await supabase
        .from('counterparties')
        .select('counterparty_id, name, is_internal, linked_company_id')
        .eq('company_id', companyId)
        .order('name');
    
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> _executeTemplateDirect(
    String templateId,
    Map<String, dynamic> templateData,
    Map<String, dynamic> executionContext,
  ) async {
    // This would implement the actual template execution logic
    // For now, return simulated result
    await Future.delayed(Duration(milliseconds: 150)); // Simulate processing time
    
    return {
      'success': true,
      'template_id': templateId,
      'executed_at': DateTime.now().toIso8601String(),
      'execution_time': 150,
      'context': executionContext,
    };
  }

  /// Get memoized loader for frequently accessed data
  Future<T> Function() getMemoizedLoader<T>({
    required TemplateOperation operation,
    required Future<T> Function() loader,
    required Map<String, dynamic> context,
  }) {
    if (!_monitoringEnabled) {
      return loader;
    }

    return _performanceService.getMemoizedLoader<T>(operation, loader, context);
  }

  /// Get current performance statistics
  Map<String, TemplatePerformanceStats> getPerformanceStats() {
    final stats = <String, TemplatePerformanceStats>{};
    
    for (final operation in TemplateOperation.values) {
      stats[operation.operationName] = _performanceService.getTemplatePerformanceStats(operation);
    }
    
    return stats;
  }

  /// Get system performance summary
  Map<String, dynamic> getSystemSummary() {
    return _performanceService.getSystemPerformanceSummary();
  }

  /// Initialize performance monitoring for a user session
  void initializeForSession({
    required String companyId,
    required String storeId,
    required String userId,
    bool enableBackgroundWarmup = true,
  }) {
    if (!_monitoringEnabled) return;

    // Start continuous monitoring
    _performanceService.startContinuousMonitoring();

    // Trigger background warmup if enabled
    if (enableBackgroundWarmup) {
      _performBackgroundWarmup(companyId, storeId);
    }

    if (kDebugMode) {
      print('🎯 Template performance monitoring initialized for user session');
    }
  }

  void _performBackgroundWarmup(String companyId, String storeId) {
    // Perform warmup in background without blocking
    Future.wait([
      _warmupIfNeeded('templates', () => _loadTemplatesDirect(companyId, storeId, '')),
      _warmupIfNeeded('cash_locations', () => _loadCashLocationsDirect(companyId, storeId)),
      _warmupIfNeeded('counterparties', () => _loadCounterpartiesDirect(companyId)),
    ]).catchError((e) {
      if (kDebugMode) {
        print('Background warmup completed with some errors: $e');
      }
    });
  }

  Future<void> _warmupIfNeeded<T>(String dataType, Future<T> Function() loader) async {
    try {
      await loader();
      if (kDebugMode) {
        print('✅ Warmed up $dataType');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Warmup failed for $dataType: $e');
      }
    }
  }

  /// Cleanup and stop monitoring
  void dispose() {
    _performanceService.stopContinuousMonitoring();
    if (kDebugMode) {
      print('🛑 Template performance monitoring stopped');
    }
  }
}

/// Enhanced Template Service Provider
final monitoredTemplateServiceProvider = Provider<MonitoredTemplateService>((ref) {
  final service = MonitoredTemplateService();
  
  // Initialize with current app state
  final appState = ref.watch(appStateProvider);
  final currentUser = ref.watch(authStateProvider);
  
  if (appState.companyChoosen.isNotEmpty && currentUser != null) {
    service.initializeForSession(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen,
      userId: currentUser.id,
      enableBackgroundWarmup: true,
    );
  }
  
  return service;
});

/// Monitored Templates Provider - Drop-in replacement for existing provider
final monitoredTemplatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(monitoredTemplateServiceProvider);
  final appState = ref.watch(appStateProvider);
  final currentUser = ref.watch(authStateProvider);
  
  if (appState.companyChoosen.isEmpty || currentUser == null) return [];
  
  return await service.loadTemplatesMonitored(
    companyId: appState.companyChoosen,
    storeId: appState.storeChoosen,
    userId: currentUser.id,
    enableWarmup: true,
    useEnhancedProvider: true,
  );
});

/// Monitored Cash Locations Provider
final monitoredCashLocationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(monitoredTemplateServiceProvider);
  final appState = ref.watch(appStateProvider);
  
  if (appState.companyChoosen.isEmpty) return [];
  
  return await service.loadCashLocationsMonitored(
    companyId: appState.companyChoosen,
    storeId: appState.storeChoosen,
  );
});

/// Monitored Counterparties Provider
final monitoredCounterpartiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(monitoredTemplateServiceProvider);
  final appState = ref.watch(appStateProvider);
  
  if (appState.companyChoosen.isEmpty) return [];
  
  return await service.loadCounterpartiesMonitored(
    companyId: appState.companyChoosen,
  );
});

/// Performance Reporting Service
class TemplatePerformanceReporter {
  static void logPerformanceReport(MonitoredTemplateService service) {
    if (!kDebugMode) return;

    final summary = service.getSystemSummary();
    final stats = service.getPerformanceStats();
    
    print('📊 Template Performance Report');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('System Health: ${summary['systemHealth']}');
    print('Critical Issues: ${(summary['criticalIssues'] as List).length}');
    print('Total Recommendations: ${summary['totalRecommendations']}');
    
    // Log top performing operations
    final sortedStats = stats.entries.toList()
      ..sort((a, b) => a.value.averageLoadTime.compareTo(b.value.averageLoadTime));
    
    print('\nTop Performing Operations:');
    for (var i = 0; i < 3 && i < sortedStats.length; i++) {
      final stat = sortedStats[i].value;
      print('  ${stat.operationName}: ${stat.averageLoadTime.inMilliseconds}ms (Grade: ${stat.performanceGrade})');
    }
    
    // Log operations needing attention
    final needsAttention = stats.values.where((s) => s.needsOptimization).toList();
    if (needsAttention.isNotEmpty) {
      print('\nOperations Needing Attention:');
      for (final stat in needsAttention) {
        print('  ${stat.operationName}: ${stat.averageLoadTime.inMilliseconds}ms (Score: ${stat.userImpactScore})');
      }
    }
    
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }
}

/// Extension for easy monitoring integration
extension MonitoredTemplateProviders on WidgetRef {
  /// Get monitored service
  MonitoredTemplateService get templateMonitoring => watch(monitoredTemplateServiceProvider);
  
  /// Get performance stats
  Map<String, TemplatePerformanceStats> get templatePerformanceStats => templateMonitoring.getPerformanceStats();
  
  /// Log performance report
  void logTemplatePerformanceReport() {
    TemplatePerformanceReporter.logPerformanceReport(templateMonitoring);
  }
}