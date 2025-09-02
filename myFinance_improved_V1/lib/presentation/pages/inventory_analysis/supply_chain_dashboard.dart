import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../helpers/navigation_helper.dart';
import 'widgets/health_score_widget.dart';
import 'widgets/priority_problems_widget.dart';
import 'widgets/integral_value_chart_widget.dart';
import 'widgets/stage_bottleneck_widget.dart';
import 'widgets/kpi_summary_widget.dart';
import 'widgets/persona_selector_widget.dart';
import 'widgets/smart_filter_widget.dart';
import 'widgets/analysis_config_panel.dart';
import 'widgets/product_analysis_results.dart';
import 'models/supply_chain_models.dart';
import 'providers/persona_provider.dart';

class SupplyChainDashboard extends ConsumerStatefulWidget {
  const SupplyChainDashboard({super.key});

  @override
  ConsumerState<SupplyChainDashboard> createState() => _SupplyChainDashboardState();
}

class _SupplyChainDashboardState extends ConsumerState<SupplyChainDashboard> {
  bool showVerticalAnalysis = false;
  
  @override
  Widget build(BuildContext context) {
    final dashboardConfig = ref.watch(dashboardConfigProvider);
    
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: Text(
          'Supply Chain Analytics',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          
          if (isMobile) {
            return _buildMobileLayout(context);
          } else {
            return _buildDesktopLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Top row: Health Score + Quick Filters
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildHealthScoreSection(context, false),
              ),
              SizedBox(width: TossSpacing.space4),
              Expanded(
                flex: 1,
                child: SmartFilterWidget(
                  isMobile: false,
                  onFiltersChanged: () => setState(() {}),
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Second row: KPI Summary Cards
          _buildKPISummarySection(context, false),
          
          SizedBox(height: TossSpacing.space4),
          
          // Third row: Priority Problems + Integral Chart
          LayoutBuilder(
            builder: (context, constraints) {
              // For very wide screens, show side by side
              if (constraints.maxWidth > 1200) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildPriorityProblemsSection(context, false),
                    ),
                    SizedBox(width: TossSpacing.space4),
                    Expanded(
                      flex: 2,
                      child: _buildIntegralChartSection(context, false),
                    ),
                  ],
                );
              } else {
                // For medium screens, stack vertically
                return Column(
                  children: [
                    _buildPriorityProblemsSection(context, false),
                    SizedBox(height: TossSpacing.space4),
                    _buildIntegralChartSection(context, false),
                  ],
                );
              }
            },
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Bottom row: Stage Analysis
          _buildStageAnalysisSection(context, false),
          
          SizedBox(height: TossSpacing.space4),
          
          // Vertical Analysis Section
          _buildVerticalAnalysisSection(context, false),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space3),
      child: Column(
        children: [
          // Health Score
          _buildHealthScoreSection(context, true),
          
          SizedBox(height: TossSpacing.space3),
          
          // Quick Filters
          SmartFilterWidget(
            isMobile: true,
            onFiltersChanged: () => setState(() {}),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // KPI Summary
          _buildKPISummarySection(context, true),
          
          SizedBox(height: TossSpacing.space3),
          
          // Priority Problems
          _buildPriorityProblemsSection(context, true),
          
          SizedBox(height: TossSpacing.space3),
          
          // Integral Chart
          _buildIntegralChartSection(context, true),
          
          SizedBox(height: TossSpacing.space3),
          
          // Stage Analysis
          _buildStageAnalysisSection(context, true),
          
          SizedBox(height: TossSpacing.space3),
          
          // Vertical Analysis Section
          _buildVerticalAnalysisSection(context, true),
          
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildHealthScoreSection(BuildContext context, bool isMobile) {
    // TODO: Replace with actual health data from API
    final healthData = ref.watch(supplyChainHealthProvider);
    
    return HealthScoreWidget(
      health: healthData,
      isMobile: isMobile,
      onTap: () => _showHealthDetails(context),
    );
  }

  Widget _buildKPISummarySection(BuildContext context, bool isMobile) {
    final personaKPIs = ref.watch(personaKPIsProvider);
    
    return KPISummaryWidget(
      kpis: personaKPIs,
      isMobile: isMobile,
      onKPITap: (kpi) => _showKPIDetails(context, kpi),
    );
  }

  Widget _buildPriorityProblemsSection(BuildContext context, bool isMobile) {
    final personaProblems = ref.watch(personaProblemsProvider);
    
    return PriorityProblemsWidget(
      problems: personaProblems,
      isMobile: isMobile,
      onProblemTap: (problem) => _showProblemDetails(context, problem),
      onActionTap: (problem, action) => _executeAction(context, problem, action),
      onSeeAll: () => _showAllProblems(context),
    );
  }

  Widget _buildIntegralChartSection(BuildContext context, bool isMobile) {
    final chartData = ref.watch(integralChartDataProvider);
    
    return IntegralValueChartWidget(
      data: chartData,
      isMobile: isMobile,
      onFullScreen: () => _showChartFullScreen(context),
    );
  }

  Widget _buildStageAnalysisSection(BuildContext context, bool isMobile) {
    final stageData = ref.watch(stagePerformanceProvider);
    
    return StageBottleneckWidget(
      stagePerformance: stageData,
      isMobile: isMobile,
      onStageTap: (stage) => _showStageDetails(context, stage),
      onViewProblems: (stage) => _showStageProblems(context, stage),
    );
  }

  Widget _buildVerticalAnalysisSection(BuildContext context, bool isMobile) {
    final analysisResults = ref.watch(productAnalysisResultsProvider);
    final isAnalysisLoading = ref.watch(isAnalysisLoadingProvider);
    
    return Column(
      children: [
        // Analysis Configuration Panel
        AnalysisConfigPanel(
          isMobile: isMobile,
          onAnalysisRequested: (config) => _runVerticalAnalysis(context, config),
        ),
        
        // Analysis Results (show only if we have results or are loading)
        if (isAnalysisLoading || analysisResults.isNotEmpty) ...[
          SizedBox(height: TossSpacing.space4),
          ProductAnalysisResults(
            isMobile: isMobile,
            onProductTap: (result) => _showProductDetails(context, result),
            onActionTap: (result, action) => _executeProductAction(context, result, action),
          ),
        ],
      ],
    );
  }

  void _runVerticalAnalysis(BuildContext context, AnalysisConfig config) async {
    // Set loading state
    ref.read(isAnalysisLoadingProvider.notifier).state = true;
    
    try {
      // TODO: Replace with actual API call to backend analysis service
      // final results = await AnalyticsService.runVerticalAnalysis(config);
      
      // For now, return empty results until backend is implemented
      ref.read(productAnalysisResultsProvider.notifier).state = [];
      ref.read(isAnalysisLoadingProvider.notifier).state = false;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Analysis service not yet implemented'),
          backgroundColor: TossColors.warning,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ref.read(isAnalysisLoadingProvider.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Analysis failed: $e'),
          backgroundColor: TossColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }



  void _showProductDetails(BuildContext context, ProductAnalysisResult result) {
    _showDetailDialog(
      context, 
      '${result.product.name} Analysis', 
      'Detailed analysis for ${result.product.name}\n\n'
      'Risk Score: ${result.riskScore.toInt()}/100\n'
      'Financial Impact: \$${result.totalFinancialImpact.toStringAsFixed(0)}\n'
      'Days Accumulated: ${result.totalDaysAccumulated}\n'
      'Critical Stage: ${result.mostCriticalStage.englishLabel}\n'
      'Problems Found: ${result.problems.length}'
    );
  }

  void _executeProductAction(BuildContext context, ProductAnalysisResult result, SmartAction action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Executing ${action.englishLabel} for ${result.product.name}'),
        backgroundColor: action.color,
        duration: const Duration(seconds: 3),
      ),
    );
  }


  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                height: 4,
                width: 40,
                margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Text(
                  'Dashboard Options',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              
              const Divider(height: 1),
              
              // Options
              ListTile(
                leading: Icon(TossIcons.person, color: TossColors.primary),
                title: Text('Switch Role', style: TossTextStyles.bodyLarge),
                subtitle: Text(
                  'Change to ${_getNextPersonaName()}',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showPersonaSelector(context);
                },
              ),
              
              ListTile(
                leading: Icon(TossIcons.refresh, color: TossColors.success),
                title: Text('Refresh Data', style: TossTextStyles.bodyLarge),
                subtitle: Text(
                  'Update all analytics',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _refreshDashboard();
                },
              ),
              
              ListTile(
                leading: Icon(TossIcons.download, color: TossColors.info),
                title: Text('Export Report', style: TossTextStyles.bodyLarge),
                subtitle: Text(
                  'Download supply chain analysis',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showExportOptions(context);
                },
              ),
              
              SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }

  void _showPersonaSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 400,
          child: PersonaSelectorWidget(isCompact: false),
        ),
      ),
    );
  }

  void _showHealthDetails(BuildContext context) {
    // Show detailed health breakdown
    _showDetailDialog(context, 'Supply Chain Health Details', 'Detailed health metrics and trends');
  }

  void _showKPIDetails(BuildContext context, SupplyChainKPI kpi) {
    // Show detailed KPI information
    _showDetailDialog(context, kpi.englishLabel, kpi.description ?? 'KPI details and history');
  }

  void _showProblemDetails(BuildContext context, SupplyChainProblem problem) {
    // Show detailed problem analysis
    _showDetailDialog(context, 'Problem Analysis', 'Detailed problem breakdown and recommendations');
  }

  void _executeAction(BuildContext context, SupplyChainProblem problem, SmartAction action) {
    // Execute the selected action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Executing: ${action.englishLabel}'),
        backgroundColor: TossColors.primary,
      ),
    );
  }

  void _showAllProblems(BuildContext context) {
    // Navigate to full problems list
    _showDetailDialog(context, 'All Supply Chain Problems', 'Complete list of all identified issues');
  }

  void _showChartFullScreen(BuildContext context) {
    // Show chart in full screen mode
    _showDetailDialog(context, 'Integral Value Analysis', 'Full-screen chart with detailed controls');
  }

  void _showStageDetails(BuildContext context, SupplyChainStage stage) {
    // Show detailed stage analysis
    final stageLabel = _getStageEnglishLabel(stage);
    _showDetailDialog(context, '$stageLabel Analysis', 'Detailed analysis of $stageLabel stage performance');
  }

  void _showStageProblems(BuildContext context, SupplyChainStage stage) {
    // Show problems specific to this stage
    final stageLabel = _getStageEnglishLabel(stage);
    _showDetailDialog(context, '$stageLabel Problems', 'All problems in the $stageLabel stage');
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Options',
              style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: TossSpacing.space3),
            ListTile(
              leading: Icon(TossIcons.download, color: TossColors.error),
              title: Text('PDF Report', style: TossTextStyles.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _exportReport('PDF');
              },
            ),
            ListTile(
              leading: Icon(TossIcons.download, color: TossColors.success),
              title: Text('Excel Data', style: TossTextStyles.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _exportReport('Excel');
              },
            ),
            SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  void _refreshDashboard() {
    // Refresh all dashboard data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Dashboard refreshed'),
        backgroundColor: TossColors.success,
      ),
    );
  }

  void _exportReport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting $format report...'),
        backgroundColor: TossColors.info,
      ),
    );
  }

  void _showDetailDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          content,
          style: TossTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextPersonaName() {
    final availablePersonas = ref.read(availablePersonasProvider);
    final currentPersona = ref.read(currentPersonaProvider);
    final currentIndex = availablePersonas.indexWhere((p) => p.role == currentPersona.role);
    final nextIndex = (currentIndex + 1) % availablePersonas.length;
    return _getPersonaEnglishLabel(availablePersonas[nextIndex].role);
  }

  String _getPersonaEnglishLabel(UserRole role) {
    switch (role) {
      case UserRole.ceo:
        return 'CEO';
      case UserRole.purchasingManager:
        return 'Purchasing Manager';
      case UserRole.storeManager:
        return 'Store Manager';
      case UserRole.analyst:
        return 'Analyst';
    }
  }

  String _getStageEnglishLabel(SupplyChainStage stage) {
    switch (stage) {
      case SupplyChainStage.order:
        return 'Order';
      case SupplyChainStage.send:
        return 'Send';
      case SupplyChainStage.receive:
        return 'Receive';
      case SupplyChainStage.sell:
        return 'Sell';
    }
  }
}