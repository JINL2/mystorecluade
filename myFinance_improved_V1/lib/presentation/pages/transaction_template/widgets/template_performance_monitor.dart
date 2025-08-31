/// Template Performance Monitoring Widget
/// Optional performance dashboard for monitoring template operations in real-time
/// 
/// Features:
/// - Real-time performance metrics display
/// - Visual performance indicators
/// - Optimization recommendations
/// - Debug-friendly interface
/// - Non-intrusive overlay design

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../services/template_performance_service.dart';
import '../services/monitored_template_service.dart';

/// Performance Monitor Widget - Shows in debug mode only
class TemplatePerformanceMonitor extends ConsumerWidget {
  final bool showInProduction;
  final bool expandedByDefault;
  
  const TemplatePerformanceMonitor({
    super.key,
    this.showInProduction = false,
    this.expandedByDefault = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only show in debug mode unless explicitly enabled for production
    if (!kDebugMode && !showInProduction) {
      return const SizedBox.shrink();
    }

    return _PerformanceMonitorPanel(
      expandedByDefault: expandedByDefault,
    );
  }
}

class _PerformanceMonitorPanel extends ConsumerStatefulWidget {
  final bool expandedByDefault;

  const _PerformanceMonitorPanel({
    required this.expandedByDefault,
  });

  @override
  ConsumerState<_PerformanceMonitorPanel> createState() => _PerformanceMonitorPanelState();
}

class _PerformanceMonitorPanelState extends ConsumerState<_PerformanceMonitorPanel> {
  bool _isExpanded = false;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.expandedByDefault;
  }

  @override
  Widget build(BuildContext context) {
    final performanceStats = ref.watch(templatePerformanceStatsProvider);
    final systemSummary = ref.watch(systemPerformanceSummaryProvider);
    
    return Positioned(
      bottom: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Colors.black87,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isExpanded ? 320 : 48,
          height: _isExpanded ? (_showDetails ? 400 : 200) : 48,
          child: _isExpanded ? _buildExpandedPanel(performanceStats, systemSummary) : _buildCollapsedPanel(),
        ),
      ),
    );
  }

  Widget _buildCollapsedPanel() {
    return InkWell(
      onTap: () => setState(() => _isExpanded = true),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [TossColors.primary[600]!, TossColors.primary[800]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.speed,
          color: TossColors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildExpandedPanel(
    Map<String, TemplatePerformanceStats> performanceStats,
    Map<String, dynamic> systemSummary,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(systemSummary),
          const SizedBox(height: 12),
          Expanded(
            child: _showDetails 
              ? _buildDetailedView(performanceStats, systemSummary)
              : _buildSummaryView(performanceStats, systemSummary),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> systemSummary) {
    final systemHealth = systemSummary['systemHealth'] ?? 'unknown';
    final criticalIssues = (systemSummary['criticalIssues'] as List? ?? []).length;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Monitor',
              style: TextStyle(
                color: TossColors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Health: ${systemHealth.toUpperCase()}',
              style: TextStyle(
                color: _getHealthColor(systemHealth),
                fontSize: 10,
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (criticalIssues > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TossColors.error[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$criticalIssues',
                  style: const TextStyle(
                    color: TossColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => setState(() => _showDetails = !_showDetails),
              child: Icon(
                _showDetails ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => setState(() => _isExpanded = false),
              child: const Icon(
                Icons.close,
                color: Colors.white70,
                size: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryView(
    Map<String, TemplatePerformanceStats> performanceStats,
    Map<String, dynamic> systemSummary,
  ) {
    final userFacingOps = performanceStats.entries
        .where((entry) => _isUserFacingOperation(entry.key))
        .toList()
      ..sort((a, b) => b.value.userImpactScore.compareTo(a.value.userImpactScore));

    return Column(
      children: [
        // Quick metrics
        Row(
          children: [
            _buildMetricCard('Avg Load', _getAverageLoadTime(performanceStats), TossColors.primary),
            const SizedBox(width: 8),
            _buildMetricCard('Cache Hit', _getAverageCacheHit(performanceStats), TossColors.success),
          ],
        ),
        const SizedBox(height: 12),
        
        // Top operations
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Key Operations',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: userFacingOps.length,
                  itemBuilder: (context, index) {
                    final entry = userFacingOps[index];
                    return _buildOperationSummary(entry.key, entry.value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedView(
    Map<String, TemplatePerformanceStats> performanceStats,
    Map<String, dynamic> systemSummary,
  ) {
    final recommendations = systemSummary['uniqueRecommendations'] as List? ?? [];
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System overview
          _buildSystemOverview(systemSummary),
          const SizedBox(height: 16),
          
          // Recommendations
          if (recommendations.isNotEmpty) ...[
            const Text(
              'Optimization Recommendations',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...recommendations.take(3).map((rec) => _buildRecommendation(rec.toString())),
            const SizedBox(height: 16),
          ],
          
          // Detailed operations
          const Text(
            'Operation Details',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...performanceStats.entries.map((entry) => _buildOperationDetail(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationSummary(String operationName, TemplatePerformanceStats stats) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: TossColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _getDisplayName(operationName),
              style: const TextStyle(
                color: TossColors.white,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            '${stats.averageLoadTime.inMilliseconds}ms',
            style: TextStyle(
              color: _getPerformanceColor(stats.averageLoadTime.inMilliseconds),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: _getGradeColor(stats.performanceGrade),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              stats.performanceGrade,
              style: const TextStyle(
                color: TossColors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemOverview(Map<String, dynamic> systemSummary) {
    final overallPerformance = systemSummary['overallPerformance'] as Map<String, dynamic>? ?? {};
    final avgScore = overallPerformance['averagePerformanceScore'] ?? 0.0;
    final totalExecutions = overallPerformance['totalExecutions'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: TossColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'System Score: ${avgScore.toStringAsFixed(1)}',
                style: const TextStyle(color: TossColors.white, fontSize: 11),
              ),
              Text(
                'Total Ops: $totalExecutions',
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(String recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: TossColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: TossColors.warning.withValues(alpha: 0.3)),
      ),
      child: Text(
        recommendation,
        style: const TextStyle(
          color: TossColors.warning,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildOperationDetail(String operationName, TemplatePerformanceStats stats) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: TossColors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getDisplayName(operationName),
                style: const TextStyle(
                  color: TossColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                stats.performanceGrade,
                style: TextStyle(
                  color: _getGradeColor(stats.performanceGrade),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avg: ${stats.averageLoadTime.inMilliseconds}ms',
                style: const TextStyle(color: Colors.white70, fontSize: 9),
              ),
              Text(
                'Cache: ${(stats.cacheHitRate * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70, fontSize: 9),
              ),
              Text(
                'Exec: ${stats.totalExecutions}',
                style: const TextStyle(color: Colors.white70, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(String health) {
    switch (health) {
      case 'healthy':
        return TossColors.success;
      case 'needs_attention':
        return TossColors.warning;
      default:
        return TossColors.error;
    }
  }

  Color _getPerformanceColor(int milliseconds) {
    if (milliseconds < 200) return TossColors.success;
    if (milliseconds < 500) return TossColors.warning;
    return TossColors.error;
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return TossColors.success;
      case 'B':
        return TossColors.primary;
      case 'C':
        return TossColors.warning;
      default:
        return TossColors.error;
    }
  }

  String _getDisplayName(String operationName) {
    return operationName.replaceAll('_', ' ').split(' ').map((word) => 
        word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ');
  }

  String _getAverageLoadTime(Map<String, TemplatePerformanceStats> stats) {
    if (stats.isEmpty) return '0ms';
    
    final userFacingStats = stats.entries
        .where((entry) => _isUserFacingOperation(entry.key))
        .map((entry) => entry.value.averageLoadTime.inMilliseconds)
        .toList();
    
    if (userFacingStats.isEmpty) return '0ms';
    
    final avgMs = userFacingStats.reduce((a, b) => a + b) / userFacingStats.length;
    return '${avgMs.toStringAsFixed(0)}ms';
  }

  String _getAverageCacheHit(Map<String, TemplatePerformanceStats> stats) {
    if (stats.isEmpty) return '0%';
    
    final userFacingStats = stats.entries
        .where((entry) => _isUserFacingOperation(entry.key))
        .map((entry) => entry.value.cacheHitRate)
        .toList();
    
    if (userFacingStats.isEmpty) return '0%';
    
    final avgRate = userFacingStats.reduce((a, b) => a + b) / userFacingStats.length;
    return '${(avgRate * 100).toStringAsFixed(0)}%';
  }

  bool _isUserFacingOperation(String operationName) {
    return ['load_templates', 'load_cash_locations', 'load_counterparties', 'execute_template']
        .contains(operationName);
  }
}

/// Performance Alert Widget - Shows critical performance issues
class PerformanceAlert extends ConsumerWidget {
  const PerformanceAlert({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    final systemSummary = ref.watch(systemPerformanceSummaryProvider);
    final criticalIssues = systemSummary['criticalIssues'] as List? ?? [];
    
    if (criticalIssues.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TossColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TossColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: TossColors.error[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${criticalIssues.length} performance issue(s) detected',
              style: TextStyle(
                color: TossColors.error[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Performance Testing Widget - For development use
class PerformanceTestWidget extends ConsumerWidget {
  const PerformanceTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    return FloatingActionButton.small(
      onPressed: () => _runPerformanceTest(ref),
      backgroundColor: Colors.purple,
      child: const Icon(Icons.speed, color: TossColors.white),
    );
  }

  void _runPerformanceTest(WidgetRef ref) async {
    final service = ref.read(monitoredTemplateServiceProvider);
    
    // Simulate multiple operations
    final futures = List.generate(10, (i) => 
      service.loadTemplatesMonitored(
        companyId: 'test_company',
        storeId: 'test_store',
        userId: 'test_user',
      )
    );
    
    final stopwatch = Stopwatch()..start();
    await Future.wait(futures);
    stopwatch.stop();
    
    // Log performance report
    ref.logTemplatePerformanceReport();
  }
}