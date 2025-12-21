import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/production_token_service.dart';

/// Production monitoring utility for FCM token registration
/// Tracks success rates, failure patterns, and system health in production
class ProductionTokenMonitoring {
  static final ProductionTokenMonitoring _instance = ProductionTokenMonitoring._internal();
  factory ProductionTokenMonitoring() => _instance;
  ProductionTokenMonitoring._internal();
  
  final ProductionTokenService _tokenService = ProductionTokenService();
  
  // Monitoring data
  final List<Map<String, dynamic>> _registrationEvents = [];
  final Map<String, int> _errorCounts = {};
  final Map<String, dynamic> _sessionMetrics = {};
  
  static const String _metricsStorageKey = 'production_token_metrics';
  static const int _maxStoredEvents = 500;
  
  /// Initialize monitoring system
  Future<void> initialize() async {
    await _loadStoredMetrics();
    _startPeriodicHealthChecks();
  }
  
  /// Log a token registration event
  void logRegistrationEvent({
    required String event,
    required bool success,
    String? error,
    int? durationMs,
    Map<String, dynamic>? additionalData,
  }) {
    final eventData = {
      'timestamp': DateTime.now().toIso8601String(),
      'event': event,
      'success': success,
      'error': error,
      'duration_ms': durationMs,
      'additional_data': additionalData,
    };
    
    _registrationEvents.add(eventData);
    
    // Track error counts
    if (!success && error != null) {
      _errorCounts[error] = (_errorCounts[error] ?? 0) + 1;
    }
    
    // Limit stored events
    if (_registrationEvents.length > _maxStoredEvents) {
      _registrationEvents.removeAt(0);
    }
    
    // Persist metrics periodically
    _persistMetrics();
  }
  
  /// Get production metrics summary
  Map<String, dynamic> getMetricsSummary() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    final last7Days = now.subtract(const Duration(days: 7));
    
    final recent24h = _registrationEvents.where((e) {
      final timestamp = DateTime.parse(e['timestamp']);
      return timestamp.isAfter(last24Hours);
    }).toList();
    
    final recent7d = _registrationEvents.where((e) {
      final timestamp = DateTime.parse(e['timestamp']);
      return timestamp.isAfter(last7Days);
    }).toList();
    
    return {
      'total_events': _registrationEvents.length,
      'last_24h': {
        'total': recent24h.length,
        'successful': recent24h.where((e) => e['success'] == true).length,
        'failed': recent24h.where((e) => e['success'] == false).length,
        'success_rate': recent24h.isNotEmpty 
            ? recent24h.where((e) => e['success'] == true).length / recent24h.length
            : 0.0,
      },
      'last_7d': {
        'total': recent7d.length,
        'successful': recent7d.where((e) => e['success'] == true).length,
        'failed': recent7d.where((e) => e['success'] == false).length,
        'success_rate': recent7d.isNotEmpty 
            ? recent7d.where((e) => e['success'] == true).length / recent7d.length
            : 0.0,
      },
      'top_errors': _getTopErrors(),
      'session_metrics': Map<String, dynamic>.from(_sessionMetrics),
      'generated_at': now.toIso8601String(),
    };
  }
  
  /// Get top errors by frequency
  List<Map<String, dynamic>> _getTopErrors() {
    final sorted = _errorCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(5).map((e) => {
      'error': e.key,
      'count': e.value,
    },).toList();
  }
  
  /// Start periodic health checks for production monitoring
  void _startPeriodicHealthChecks() {
    Timer.periodic(const Duration(minutes: 15), (timer) async {
      await _performHealthCheck();
    });
  }
  
  /// Perform health check and update session metrics
  Future<void> _performHealthCheck() async {
    try {
      final healthData = await _tokenService.performHealthCheck();
      
      // Update session metrics
      _sessionMetrics['last_health_check'] = DateTime.now().toIso8601String();
      _sessionMetrics['health_status'] = healthData['health_status'];
      
      // Track health trends
      final isHealthy = healthData['health_status'] == 'healthy';
      _sessionMetrics['health_checks_performed'] = (_sessionMetrics['health_checks_performed'] ?? 0) + 1;
      _sessionMetrics['healthy_checks'] = (_sessionMetrics['healthy_checks'] ?? 0) + (isHealthy ? 1 : 0);
      
      // Log health check result
      logRegistrationEvent(
        event: 'health_check',
        success: isHealthy,
        error: isHealthy ? null : healthData['error']?.toString(),
        additionalData: {
          'token_available': healthData['fcm_token_available'],
          'tokens_in_db': healthData['tokens_in_database'],
          'current_token_saved': healthData['current_token_saved'],
        },
      );
      
    } catch (e) {
      logRegistrationEvent(
        event: 'health_check',
        success: false,
        error: e.toString(),
      );
    }
  }
  
  /// Generate production report for debugging
  String generateProductionReport() {
    final summary = getMetricsSummary();
    final serviceStats = _tokenService.getProductionStats();
    
    final report = StringBuffer();
    report.writeln('=== PRODUCTION TOKEN MONITORING REPORT ===');
    report.writeln('Generated: ${DateTime.now().toIso8601String()}');
    report.writeln();
    
    report.writeln('📊 REGISTRATION METRICS:');
    report.writeln('• Total Events: ${summary['total_events']}');
    report.writeln('• Last 24h Success Rate: ${(summary['last_24h']['success_rate'] * 100).toStringAsFixed(1)}%');
    report.writeln('• Last 7d Success Rate: ${(summary['last_7d']['success_rate'] * 100).toStringAsFixed(1)}%');
    report.writeln();
    
    report.writeln('❌ TOP ERRORS:');
    final topErrors = summary['top_errors'] as List;
    for (final error in topErrors) {
      report.writeln('• ${error['error']}: ${error['count']} times');
    }
    report.writeln();
    
    report.writeln('🔧 SERVICE STATUS:');
    serviceStats.forEach((key, value) {
      report.writeln('• $key: $value');
    });
    report.writeln();
    
    report.writeln('💡 HEALTH TRENDS:');
    final sessionMetrics = summary['session_metrics'];
    if (sessionMetrics['health_checks_performed'] != null) {
      final healthRate = sessionMetrics['healthy_checks'] / sessionMetrics['health_checks_performed'];
      report.writeln('• Health Check Success Rate: ${(healthRate * 100).toStringAsFixed(1)}%');
      report.writeln('• Last Health Check: ${sessionMetrics['last_health_check']}');
      report.writeln('• Current Health Status: ${sessionMetrics['health_status']}');
    }
    
    return report.toString();
  }
  
  /// Load stored metrics from previous sessions
  Future<void> _loadStoredMetrics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getString(_metricsStorageKey);
      
      if (storedData != null) {
        final data = jsonDecode(storedData);
        
        // Load events
        final events = data['events'] as List?;
        if (events != null) {
          _registrationEvents.addAll(
            events.cast<Map<String, dynamic>>(),
          );
        }
        
        // Load error counts
        final errors = data['error_counts'] as Map?;
        if (errors != null) {
          _errorCounts.addAll(
            errors.cast<String, int>(),
          );
        }
        
        // Load session metrics
        final session = data['session_metrics'] as Map?;
        if (session != null) {
          _sessionMetrics.addAll(
            session.cast<String, dynamic>(),
          );
        }
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load stored metrics: $e');
      }
    }
  }
  
  /// Persist metrics to storage
  Future<void> _persistMetrics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final data = {
        'events': _registrationEvents.length > 100 
            ? _registrationEvents.sublist(_registrationEvents.length - 100)
            : _registrationEvents, // Keep last 100 events
        'error_counts': _errorCounts,
        'session_metrics': _sessionMetrics,
        'saved_at': DateTime.now().toIso8601String(),
      };
      
      await prefs.setString(_metricsStorageKey, jsonEncode(data));
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to persist metrics: $e');
      }
    }
  }
  
  /// Clear all metrics data
  Future<void> clearMetrics() async {
    _registrationEvents.clear();
    _errorCounts.clear();
    _sessionMetrics.clear();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_metricsStorageKey);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to clear stored metrics: $e');
      }
    }
  }
}