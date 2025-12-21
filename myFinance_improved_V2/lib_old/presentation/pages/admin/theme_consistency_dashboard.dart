import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/themes/progressive_rollout.dart';
import '../../../core/themes/theme_health_monitor.dart';
import '../../../core/themes/automated_rollback.dart';
import '../../../core/themes/canary_deployment.dart';
import '../../../core/themes/theme_validator.dart';
import '../../widgets/toss/toss_scaffold.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/toss/toss_button.dart';
import '../../widgets/common/toss_dialog.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
/// Comprehensive theme consistency dashboard for monitoring and management
/// 
/// Features:
/// - Real-time health monitoring and metrics display
/// - Progressive rollout status and control
/// - Canary deployment management
/// - Theme validation results and insights  
/// - Rollback system status and history
/// - Visual regression testing integration
/// - Emergency controls and safety overrides
class ThemeConsistencyDashboard extends StatefulWidget {
  const ThemeConsistencyDashboard({Key? key}) : super(key: key);

  @override
  State<ThemeConsistencyDashboard> createState() => _ThemeConsistencyDashboardState();
}

class _ThemeConsistencyDashboardState extends State<ThemeConsistencyDashboard> 
    with TickerProviderStateMixin {
  
  late TabController _tabController;
  Timer? _refreshTimer;
  
  // System status
  HealthStatus? _healthStatus;
  RolloutStatus? _rolloutStatus;
  CanaryDeploymentStatus? _canaryStatus;
  RollbackStats? _rollbackStats;
  ThemeValidationReport? _validationReport;
  
  // Streams
  StreamSubscription? _healthAlertSubscription;
  StreamSubscription? _canaryEventSubscription;
  StreamSubscription? _rollbackEventSubscription;
  
  bool _isLoading = true;
  String? _error;
  DateTime _lastRefresh = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    
    _initializeDashboard();
    _setupStreamListeners();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    _healthAlertSubscription?.cancel();
    _canaryEventSubscription?.cancel();
    _rollbackEventSubscription?.cancel();
    super.dispose();
  }

  /// Initialize dashboard data
  Future<void> _initializeDashboard() async {
    await _refreshAllData();
  }

  /// Set up stream listeners for real-time updates
  void _setupStreamListeners() {
    // Health alerts
    _healthAlertSubscription = ThemeHealthMonitor.instance.alertStream.listen(
      (alert) {
        if (mounted) {
          _showHealthAlert(alert);
          _refreshHealthData();
        }
      },
    );

    // Canary events
    _canaryEventSubscription = CanaryDeployment.instance.eventStream.listen(
      (event) {
        if (mounted) {
          _showCanaryEvent(event);
          _refreshCanaryData();
        }
      },
    );

    // Rollback events
    _rollbackEventSubscription = AutomatedRollback.instance.eventStream.listen(
      (event) {
        if (mounted) {
          _showRollbackEvent(event);
          _refreshRollbackData();
        }
      },
    );
  }

  /// Start automatic refresh timer
  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds: 30), (_) {
      if (mounted) {
        _refreshAllData();
      }
    });
  }

  /// Refresh all dashboard data
  Future<void> _refreshAllData() async {
    if (!mounted) return;
    
    try {
      await Future.wait([
        _refreshHealthData(),
        _refreshRolloutData(),
        _refreshCanaryData(),
        _refreshRollbackData(),
        _refreshValidationData(),
      ]);

      setState(() {
        _isLoading = false;
        _error = null;
        _lastRefresh = DateTime.now();
      });

    } catch (e) {
      setState(() {
        _error = 'Failed to refresh dashboard: $e';
        _isLoading = false;
      });
    }
  }

  /// Refresh health monitoring data
  Future<void> _refreshHealthData() async {
    try {
      _healthStatus = await ThemeHealthMonitor.instance.getCurrentHealthStatus();
    } catch (e) {
      if (kDebugMode) print('Failed to refresh health data: $e');
    }
  }

  /// Refresh rollout status data
  Future<void> _refreshRolloutData() async {
    try {
      _rolloutStatus = ProgressiveRollout.instance.getCurrentStatus();
    } catch (e) {
      if (kDebugMode) print('Failed to refresh rollout data: $e');
    }
  }

  /// Refresh canary deployment data
  Future<void> _refreshCanaryData() async {
    try {
      _canaryStatus = CanaryDeployment.instance.getCurrentStatus();
    } catch (e) {
      if (kDebugMode) print('Failed to refresh canary data: $e');
    }
  }

  /// Refresh rollback system data
  Future<void> _refreshRollbackData() async {
    try {
      _rollbackStats = await AutomatedRollback.instance.getRollbackStats();
    } catch (e) {
      if (kDebugMode) print('Failed to refresh rollback data: $e');
    }
  }

  /// Refresh validation data
  Future<void> _refreshValidationData() async {
    try {
      final validator = ThemeValidator();
      _validationReport = validator.generateReport();
    } catch (e) {
      if (kDebugMode) print('Failed to refresh validation data: $e');
    }
  }

  /// Show health alert notification
  void _showHealthAlert(HealthAlert alert) {
    final color = _getSeverityColor(alert.severity);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          '${alert.severity.name.toUpperCase()} ALERT: ${alert.message}',
          style: TossTextStyles.body.copyWith(color: TossColors.white, fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: alert.severity == AlertSeverity.critical ? 10 : 5),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: TossColors.white,
          onPressed: () => _tabController.animateTo(0), // Switch to health tab
        ),
      ),
    );
  }

  /// Show canary event notification
  void _showCanaryEvent(CanaryEvent event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _getEventTypeColor(event.type),
        content: Text(
          'CANARY: ${event.message}',
          style: TossTextStyles.body.copyWith(color: TossColors.white),
        ),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: TossColors.white,
          onPressed: () => _tabController.animateTo(2), // Switch to canary tab
        ),
      ),
    );
  }

  /// Show rollback event notification
  void _showRollbackEvent(RollbackEvent event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: TossColors.error.shade700,
        content: Text(
          'ROLLBACK: ${event.reason}',
          style: TossTextStyles.body.copyWith(color: TossColors.white, fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: 8),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: TossColors.white,
          onPressed: () => _tabController.animateTo(3), // Switch to rollback tab
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: AppBar(
        title: Text('Theme Consistency Dashboard'),
        backgroundColor: _getOverallSystemColor(),
        foregroundColor: TossColors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshAllData,
          ),
          if (kDebugMode)
            PopupMenuButton<String>(
              onSelected: _handleDebugAction,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'emergency_rollback',
                  child: Text('🚨 Emergency Rollback'),
                ),
                PopupMenuItem(
                  value: 'start_canary',
                  child: Text('🐦 Start Test Canary'),
                ),
                PopupMenuItem(
                  value: 'simulate_alert',
                  child: Text('⚠️ Simulate Health Alert'),
                ),
              ],
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(icon: Icon(Icons.health_and_safety), text: 'Health'),
            Tab(icon: Icon(Icons.tune), text: 'Rollout'),
            Tab(icon: Icon(Icons.science), text: 'Canary'),
            Tab(icon: Icon(Icons.undo), text: 'Rollback'),
            Tab(icon: Icon(Icons.check_circle), text: 'Validation'),
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
          ],
        ),
      ),
      body: _isLoading ? _buildLoadingIndicator() : _buildDashboardContent(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: TossSpacing.space4),
          Text('Loading dashboard data...'),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    if (_error != null) {
      return _buildErrorState();
    }

    return Column(
      children: [
        _buildStatusBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildHealthTab(),
              _buildRolloutTab(),
              _buildCanaryTab(),
              _buildRollbackTab(),
              _buildValidationTab(),
              _buildOverviewTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: TossColors.error),
          SizedBox(height: TossSpacing.space4),
          Text('Error loading dashboard', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: TossSpacing.space2),
          Text(_error!, textAlign: TextAlign.center),
          SizedBox(height: TossSpacing.space4),
          TossButton.primary(
            text: 'Retry',
            onPressed: _refreshAllData,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      color: TossColors.gray500.shade100,
      child: Row(
        children: [
          _buildStatusIndicator(
            'System Health',
            _healthStatus?.isHealthy ?? false,
            TossColors.success,
            TossColors.error,
          ),
          SizedBox(width: TossSpacing.space4),
          _buildStatusIndicator(
            'Canary Active',
            _canaryStatus?.canPromote ?? false,
            TossColors.primary,
            TossColors.gray500,
          ),
          SizedBox(width: TossSpacing.space4),
          Expanded(
            child: Text(
              'Last updated: ${_formatTime(_lastRefresh)}',
              style: TossTextStyles.caption color: TossColors.gray500.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool isGood, Color goodColor, Color badColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isGood ? goodColor : badColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TossTextStyles.caption),
      ],
    );
  }

  /// Build health monitoring tab
  Widget _buildHealthTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthOverview(),
          SizedBox(height: TossSpacing.space4),
          _buildHealthMetrics(),
          SizedBox(height: TossSpacing.space4),
          _buildRecentAlerts(),
        ],
      ),
    );
  }

  Widget _buildHealthOverview() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.health_and_safety,
                  color: _healthStatus?.isHealthy == true ? TossColors.success : TossColors.error,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'System Health',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            Text(_healthStatus?.summary ?? 'No health data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetrics() {
    if (_healthStatus?.recentSnapshots.isEmpty ?? true) {
      return TossCard(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Text('No recent health metrics available'),
        ),
      );
    }

    final metrics = _healthStatus!.recentSnapshots.last.metrics;
    
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Metrics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            ...metrics.entries.map((entry) => _buildMetricRow(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String name, HealthMetric metric) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(name.replaceAll('_', ' ').toUpperCase()),
          ),
          Expanded(
            child: Text(
              '${metric.value.toStringAsFixed(2)} ${metric.unit}',
              style: TossTextStyles.body.copyWith(fontFamily: 'monospace'),
            ),
          ),
          Icon(
            _isMetricGood(name, metric.value) ? Icons.check_circle : Icons.warning,
            color: _isMetricGood(name, metric.value) ? TossColors.success : TossColors.warning,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAlerts() {
    final alerts = _healthStatus?.recentAlerts ?? [];
    
    if (alerts.isEmpty) {
      return TossCard(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Text('No recent alerts'),
        ),
      );
    }

    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Alerts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            ...alerts.take(5).map((alert) => _buildAlertRow(alert)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertRow(HealthAlert alert) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: _getSeverityColor(alert.severity).withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
        border: Border.all(color: _getSeverityColor(alert.severity)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getSeverityColor(alert.severity),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: Text(
                  alert.severity.name.toUpperCase(),
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                _formatTime(alert.timestamp),
                style: TossTextStyles.caption color: TossColors.gray500.shade600),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(alert.message),
        ],
      ),
    );
  }

  /// Build progressive rollout tab
  Widget _buildRolloutTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          _buildRolloutStatus(),
          SizedBox(height: TossSpacing.space4),
          _buildFeatureRollouts(),
          if (kDebugMode) ...[
            SizedBox(height: TossSpacing.space4),
            _buildRolloutControls(),
          ],
        ],
      ),
    );
  }

  Widget _buildRolloutStatus() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rollout Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: TossSpacing.space3),
            Text(_rolloutStatus?.summary ?? 'No rollout data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRollouts() {
    if (_rolloutStatus?.config == null) {
      return TossCard(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Text('No feature rollout data available'),
        ),
      );
    }

    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feature Rollout Percentages',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            ...ThemeFeature.values.map((feature) => _buildFeatureRolloutRow(feature)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRolloutRow(ThemeFeature feature) {
    final percentage = _rolloutStatus?.config?.getFeaturePercentage(feature) ?? 0;
    final isEnabled = _rolloutStatus?.enabledFeatures.contains(feature) ?? false;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(feature.displayName),
              ),
              Text('$percentage%'),
              SizedBox(width: TossSpacing.space2),
              Icon(
                isEnabled ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isEnabled ? TossColors.success : TossColors.gray500,
                size: 16,
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage / 100.0,
            backgroundColor: TossColors.gray500.shade200,
            valueColor: AlwaysStoppedAnimation(
              percentage > 0 ? TossColors.primary : TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolloutControls() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Debug Controls',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            Wrap(
              spacing: 8,
              children: [
                TossButton.secondary(
                  text: 'Enable All (Dev)',
                  onPressed: _enableAllFeatures,
                ),
                TossButton.secondary(
                  text: 'Disable All',
                  onPressed: _disableAllFeatures,
                ),
                TossButton.secondary(
                  text: 'Test Rollout',
                  onPressed: _testRollout,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build canary deployment tab
  Widget _buildCanaryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          _buildCanaryStatus(),
          SizedBox(height: TossSpacing.space4),
          if (_canaryStatus != null) ...[
            _buildCanaryMetrics(),
            SizedBox(height: TossSpacing.space4),
          ],
          if (kDebugMode) _buildCanaryControls(),
        ],
      ),
    );
  }

  Widget _buildCanaryStatus() {
    if (_canaryStatus == null) {
      return TossCard(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No Active Canary Deployment',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: TossSpacing.space2),
              Text('No canary deployment is currently running.'),
            ],
          ),
        ),
      );
    }

    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.science,
                  color: _getCanaryPhaseColor(_canaryStatus!.phase),
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Canary Deployment',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            _buildCanaryInfoRow('ID', _canaryStatus!.deployment.id),
            _buildCanaryInfoRow('Phase', _canaryStatus!.phase.displayName),
            _buildCanaryInfoRow('Features', _canaryStatus!.deployment.features.map((f) => f.displayName).join(', ')),
            _buildCanaryInfoRow('Started', _formatTime(_canaryStatus!.startedAt)),
            _buildCanaryInfoRow('Duration', _canaryStatus!.totalDuration.toString().split('.').first),
          ],
        ),
      ),
    );
  }

  Widget _buildCanaryInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildCanaryMetrics() {
    if (_canaryStatus?.healthMetrics.isEmpty ?? true) {
      return TossCard(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Text('No canary metrics available yet'),
        ),
      );
    }

    final metrics = _canaryStatus!.healthMetrics;
    final latest = metrics.last;

    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Canary Health Metrics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Health Score',
                    '${(latest.healthScore * 100).toStringAsFixed(1)}%',
                    latest.healthScore > 0.9 ? TossColors.success : TossColors.warning,
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: _buildMetricCard(
                    'Error Rate',
                    '${(latest.errorRate * 100).toStringAsFixed(2)}%',
                    latest.errorRate < 0.01 ? TossColors.success : TossColors.error,
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: _buildMetricCard(
                    'Performance',
                    '${(latest.performanceScore * 100).toStringAsFixed(1)}%',
                    latest.performanceScore > 0.8 ? TossColors.success : TossColors.warning,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TossTextStyles.h4
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TossTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCanaryControls() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Canary Controls (Debug)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            Wrap(
              spacing: 8,
              children: [
                TossButton.primary(
                  text: 'Start Test Canary',
                  onPressed: _startTestCanary,
                ),
                if (_canaryStatus?.canPromote ?? false) ...[
                  TossButton.secondary(
                    text: 'Manual Promote',
                    onPressed: _manualPromoteCanary,
                  ),
                  TossButton.text(
                    text: 'Trigger Rollback',
                    onPressed: _manualCanaryRollback,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build rollback tab
  Widget _buildRollbackTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          _buildRollbackOverview(),
          SizedBox(height: TossSpacing.space4),
          _buildRollbackHistory(),
        ],
      ),
    );
  }

  Widget _buildRollbackOverview() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rollback System',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: TossSpacing.space3),
            Text(_rollbackStats?.summary ?? 'No rollback data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildRollbackHistory() {
    if (_rollbackStats?.totalRollbacks == 0) {
      return TossCard(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Text('No rollbacks have occurred'),
        ),
      );
    }

    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Rollbacks',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            ..._rollbackStats!.events.take(5).map((event) => _buildRollbackEventRow(event)),
          ],
        ),
      ),
    );
  }

  Widget _buildRollbackEventRow(RollbackEvent event) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.error.shade50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
        border: Border.all(color: TossColors.error.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.undo, size: 16, color: TossColors.error),
              SizedBox(width: 4),
              Text(
                event.trigger.displayName,
                style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Text(
                _formatTime(event.timestamp),
                style: TossTextStyles.caption color: TossColors.gray500.shade600),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(event.reason, style: TossTextStyles.caption),
        ],
      ),
    );
  }

  /// Build validation tab
  Widget _buildValidationTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          _buildValidationOverview(),
          SizedBox(height: TossSpacing.space4),
          if (_validationReport != null) _buildValidationDetails(),
        ],
      ),
    );
  }

  Widget _buildValidationOverview() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: _getValidationColor(),
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Theme Validation',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            Text(_getValidationSummary()),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationDetails() {
    if (_validationReport!.issuesByType.isEmpty) {
      return TossCard(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Text('No validation issues found! 🎉'),
        ),
      );
    }

    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Validation Issues',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            ..._validationReport!.issuesByType.entries.map(
              (entry) => _buildValidationIssueRow(entry.key, entry.value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationIssueRow(String issueType, int count) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(issueType)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: count > 10 ? TossColors.error.shade100 : TossColors.warning.shade100,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Text(
              '$count',
              style: TossTextStyles.body.copyWith(
                color: count > 10 ? TossColors.error.shade800 : TossColors.warning.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build overview tab
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          _buildSystemOverview(),
          SizedBox(height: TossSpacing.space4),
          _buildQuickActions(),
          SizedBox(height: TossSpacing.space4),
          _buildSystemStatus(),
        ],
      ),
    );
  }

  Widget _buildSystemOverview() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme System Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: TossSpacing.space3),
            Text(_getSystemOverviewText()),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TossButton.primary(
                  text: 'Run Health Check',
                  onPressed: _runHealthCheck,
                ),
                TossButton.secondary(
                  text: 'Validate Themes',
                  onPressed: _validateThemes,
                ),
                TossButton.secondary(
                  text: 'Refresh Dashboard',
                  onPressed: _refreshAllData,
                ),
                if (kDebugMode)
                  TossButton.text(
                    text: '🚨 Emergency Stop',
                    onPressed: _emergencyStop,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatus() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: TossSpacing.space3),
            _buildStatusRow('Health Monitor', _healthStatus?.isMonitoring ?? false),
            _buildStatusRow('Progressive Rollout', _rolloutStatus != null),
            _buildStatusRow('Canary System', _canaryStatus != null),
            _buildStatusRow('Rollback System', true),
            _buildStatusRow('Theme Validation', _validationReport != null),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String system, bool isActive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.circle_outlined,
            color: isActive ? TossColors.success : TossColors.gray500,
            size: 16,
          ),
          SizedBox(width: TossSpacing.space2),
          Expanded(child: Text(system)),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TossTextStyles.body.copyWith(
              color: isActive ? TossColors.success : TossColors.gray500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.low:
        return TossColors.primary;
      case AlertSeverity.medium:
        return TossColors.warning;
      case AlertSeverity.high:
        return TossColors.error;
      case AlertSeverity.critical:
        return TossColors.error.shade900;
    }
  }

  Color _getEventTypeColor(CanaryEventType type) {
    switch (type) {
      case CanaryEventType.deploymentStarted:
        return TossColors.primary;
      case CanaryEventType.deploymentCompleted:
        return TossColors.success;
      case CanaryEventType.deploymentFailed:
      case CanaryEventType.rollbackTriggered:
        return TossColors.error;
      case CanaryEventType.phaseStarted:
        return TossColors.primary;
      case CanaryEventType.manualPromotion:
        return TossColors.warning;
    }
  }

  Color _getCanaryPhaseColor(CanaryPhase phase) {
    switch (phase) {
      case CanaryPhase.preparation:
        return TossColors.primary;
      case CanaryPhase.canary:
      case CanaryPhase.conservativeExpansion:
      case CanaryPhase.gradualExpansion:
        return TossColors.warning;
      case CanaryPhase.fullRollout:
      case CanaryPhase.completed:
        return TossColors.success;
      case CanaryPhase.failed:
      case CanaryPhase.rolledBack:
        return TossColors.error;
    }
  }

  Color _getOverallSystemColor() {
    final isHealthy = _healthStatus?.isHealthy ?? true;
    final hasCanary = _canaryStatus?.canPromote ?? false;
    
    if (!isHealthy) return TossColors.error.shade700;
    if (hasCanary) return TossColors.warning.shade700;
    return TossColors.primary.shade700;
  }

  Color _getValidationColor() {
    final issues = _validationReport?.totalIssues ?? 0;
    if (issues == 0) return TossColors.success;
    if (issues > 20) return TossColors.error;
    return TossColors.warning;
  }

  bool _isMetricGood(String metricName, double value) {
    switch (metricName) {
      case 'error_rate':
      case 'crash_rate':
        return value <= 0.01;
      case 'render_time':
      case 'build_time':
        return value <= 300;
      case 'memory_usage':
        return value <= 100;
      case 'user_satisfaction':
      case 'theme_validation_score':
        return value >= 0.8;
      default:
        return true;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  String _getValidationSummary() {
    if (_validationReport == null) return 'No validation data available';
    
    final issues = _validationReport!.totalIssues;
    if (issues == 0) return 'All theme validations passing! 🎉';
    return 'Found $issues validation issues across ${_validationReport!.issuesByType.length} categories';
  }

  String _getSystemOverviewText() {
    final health = _healthStatus?.isHealthy == true ? 'Healthy' : 'Issues Detected';
    final rollout = _rolloutStatus?.enabledFeatures.length ?? 0;
    final canary = _canaryStatus != null ? 'Active' : 'None';
    
    return 'System Health: $health\n'
           'Active Features: $rollout\n'
           'Canary Deployment: $canary\n'
           'Theme Validation: ${_getValidationSummary()}';
  }

  // Action handlers
  void _handleDebugAction(String action) {
    switch (action) {
      case 'emergency_rollback':
        _emergencyStop();
        break;
      case 'start_canary':
        _startTestCanary();
        break;
      case 'simulate_alert':
        _simulateHealthAlert();
        break;
    }
  }

  Future<void> _runHealthCheck() async {
    final result = await ProgressiveRollout.instance.performHealthCheck();
    
    showDialog(
      context: context,
      builder: (context) => TossDialog(
        title: 'Health Check Result',
        content: result.isHealthy
            ? 'System is healthy! ✅\nHealth Score: ${(result.healthScore * 100).toStringAsFixed(1)}%'
            : 'Issues detected:\n${result.issues.join('\n')}',
        actions: [
          TossButton.text(
            text: 'Close',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _validateThemes() async {
    await _refreshValidationData();
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Theme validation completed')),
    );
  }

  Future<void> _enableAllFeatures() async {
    if (!kDebugMode) return;
    
    final rolloutPercentages = <ThemeFeature, int>{};
    for (final feature in ThemeFeature.values) {
      rolloutPercentages[feature] = 100;
    }
    
    try {
      await ProgressiveRollout.instance.updateRolloutPercentages(
        rolloutPercentages,
        reason: 'Debug: Enable all features',
        requiresHealthCheck: false,
      );
      
      await _refreshRolloutData();
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All features enabled (development mode)')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to enable features: $e')),
      );
    }
  }

  Future<void> _disableAllFeatures() async {
    final rolloutPercentages = <ThemeFeature, int>{};
    for (final feature in ThemeFeature.values) {
      rolloutPercentages[feature] = 0;
    }
    
    try {
      await ProgressiveRollout.instance.updateRolloutPercentages(
        rolloutPercentages,
        reason: 'Debug: Disable all features',
        requiresHealthCheck: false,
      );
      
      await _refreshRolloutData();
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All features disabled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to disable features: $e')),
      );
    }
  }

  Future<void> _testRollout() async {
    try {
      await ProgressiveRollout.instance.updateRolloutPercentages(
        {ThemeFeature.colors: 5},
        reason: 'Debug: Test rollout',
        requiresHealthCheck: true,
      );
      
      await _refreshRolloutData();
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test rollout started: 5% color system')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test rollout failed: $e')),
      );
    }
  }

  Future<void> _startTestCanary() async {
    try {
      final result = await CanaryDeployment.instance.startCanaryDeployment(
        features: [ThemeFeature.colors, ThemeFeature.textStyles],
        deploymentReason: 'Debug test canary deployment',
      );
      
      if (result.success) {
        await _refreshCanaryData();
        setState(() {});
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test canary deployment started')),
        );
      } else {
        throw Exception(result.message);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start canary: $e')),
      );
    }
  }

  Future<void> _manualPromoteCanary() async {
    if (!kDebugMode) return;
    
    try {
      await CanaryDeployment.instance.manuallyPromotePhase(
        reason: 'Manual promotion from dashboard',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Canary phase manually promoted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to promote canary: $e')),
      );
    }
  }

  Future<void> _manualCanaryRollback() async {
    if (!kDebugMode) return;
    
    try {
      await CanaryDeployment.instance.manuallyTriggerRollback(
        reason: 'Manual rollback from dashboard',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Canary rollback triggered')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to trigger rollback: $e')),
      );
    }
  }

  Future<void> _simulateHealthAlert() async {
    if (!kDebugMode) return;
    
    await ThemeHealthMonitor.instance.recordHealthEvent(
      type: 'test_alert',
      description: 'Simulated health alert from dashboard',
      metadata: {'severity': 'high', 'source': 'dashboard'},
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Test health alert recorded')),
    );
  }

  Future<void> _emergencyStop() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => TossDialog(
        title: '🚨 Emergency Stop',
        content: 'This will immediately roll back all theme features to 0% and disable all deployments. This action cannot be undone.\n\nContinue?',
        actions: [
          TossButton.text(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TossButton.primary(
            text: 'Emergency Stop',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        await ProgressiveRollout.instance.emergencyRollback(
          reason: 'Emergency stop triggered from dashboard',
        );
        
        await _refreshAllData();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: TossColors.error,
            content: Text(
              '🚨 EMERGENCY STOP EXECUTED',
              style: TossTextStyles.body.copyWith(color: TossColors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Emergency stop failed: $e')),
        );
      }
    }
  }
}