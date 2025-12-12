import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/index.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/deep_widget_analyzer.dart';
import '../../../core/themes/toss_icons.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/toss/toss_tab_bar.dart';
import '../../widgets/toss/toss_chip.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_secondary_button.dart';
import '../../helpers/navigation_helper.dart';

/// Enhanced Widget Consistency Analyzer with detailed migration data
class WidgetConsistencyAnalyzerPageEnhanced extends ConsumerStatefulWidget {
  const WidgetConsistencyAnalyzerPageEnhanced({super.key});

  @override
  ConsumerState<WidgetConsistencyAnalyzerPageEnhanced> createState() => 
      _WidgetConsistencyAnalyzerPageEnhancedState();
}

class _WidgetConsistencyAnalyzerPageEnhancedState 
    extends ConsumerState<WidgetConsistencyAnalyzerPageEnhanced>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  late final DeepWidgetAnalyzer _analyzer;
  WidgetAnalysisState _analysisState = WidgetAnalysisState();
  bool _isAnalyzing = false;
  String? _selectedWidget;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _analyzer = DeepWidgetAnalyzer();
    _runAnalysis();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _runAnalysis() async {
    setState(() {
      _isAnalyzing = true;
    });
    
    try {
      // Simulate analysis
      await Future.delayed(Duration(milliseconds: 500));
      
      // Generate comprehensive migration data
      _analysisState = _generateEnhancedAnalysisData();
      
      setState(() {
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }
  
  WidgetAnalysisState _generateEnhancedAnalysisData() {
    return WidgetAnalysisState(
      totalWidgets: 302,
      duplicateCount: 1327,
      hardcodedStyleCount: 14800,
      widgetData: _generateMigrationData(),
      compatibilityMatrix: _generateCompatibilityMatrix(),
      issueCategories: _generateIssueCategories(),
      impactAnalysis: _generateImpactAnalysis(),
    );
  }
  
  Map<String, WidgetMigrationData> _generateMigrationData() {
    return {
      'IconButton': WidgetMigrationData(
        nativeWidget: 'IconButton',
        tossWidget: 'TossIconButton',
        usageCount: 156,
        filesAffected: 52,
        compatibility: 0.90,
        riskLevel: RiskLevel.low,
        migrationEffort: MigrationEffort(hours: 4, complexity: 'Simple'),
        performanceImpact: PerformanceImpact(
          renderTime: 0,
          memoryUsage: 0,
          bundleSize: -2,
        ),
        testingRequirements: [
          TestRequirement('Tap interactions', 'High', true),
          TestRequirement('Tooltip display', 'Medium', false),
          TestRequirement('Disabled state', 'Low', false),
        ],
        breakingChanges: [],
        codeExample: CodeExample(
          before: '''IconButton(
  icon: Icon(Icons.back),
  onPressed: () => Navigator.pop(context),
)''',
          after: '''TossIconButton(
  icon: Icons.back,
  onPressed: () => Navigator.pop(context),
)''',
        ),
        migrationSteps: [
          'Import TossIconButton widget',
          'Replace IconButton with TossIconButton',
          'Remove Icon wrapper from icon parameter',
          'Test tap interactions',
        ],
        rollbackComplexity: 'Very Low',
        successRate: 0.95,
      ),
      'Container+BoxDecoration': WidgetMigrationData(
        nativeWidget: 'Container+BoxDecoration',
        tossWidget: 'TossCard',
        usageCount: 342,
        filesAffected: 142,
        compatibility: 0.63,
        riskLevel: RiskLevel.medium,
        migrationEffort: MigrationEffort(hours: 8, complexity: 'Moderate'),
        performanceImpact: PerformanceImpact(
          renderTime: -5,
          memoryUsage: -8,
          bundleSize: -15,
        ),
        testingRequirements: [
          TestRequirement('Layout rendering', 'Critical', true),
          TestRequirement('Shadow effects', 'High', true),
          TestRequirement('Border radius', 'Medium', false),
          TestRequirement('Animations', 'High', true),
        ],
        breakingChanges: [
          'margin parameter must be moved to wrapper Container',
          'AnimationController removed for list items',
          'Custom shadows need adjustment',
        ],
        codeExample: CodeExample(
          before: '''Container(
  margin: EdgeInsets.all(16),
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [BoxShadow(...)],
  ),
  child: content,
)''',
          after: '''Container(
  margin: EdgeInsets.all(16),
  child: TossCard(
    padding: EdgeInsets.all(12),
    child: content,
  ),
)''',
        ),
        migrationSteps: [
          'Import TossCard widget',
          'Extract margin to wrapper Container',
          'Replace Container+BoxDecoration with TossCard',
          'Test shadow rendering',
          'Verify animations if present',
        ],
        rollbackComplexity: 'Low',
        successRate: 0.78,
      ),
      'ElevatedButton': WidgetMigrationData(
        nativeWidget: 'ElevatedButton',
        tossWidget: 'TossPrimaryButton',
        usageCount: 67,
        filesAffected: 35,
        compatibility: 0.92,
        riskLevel: RiskLevel.low,
        migrationEffort: MigrationEffort(hours: 3, complexity: 'Simple'),
        performanceImpact: PerformanceImpact(
          renderTime: -2,
          memoryUsage: 0,
          bundleSize: -5,
        ),
        testingRequirements: [
          TestRequirement('Form submissions', 'Critical', true),
          TestRequirement('Loading states', 'High', true),
          TestRequirement('Disabled state', 'Medium', false),
        ],
        breakingChanges: [],
        codeExample: CodeExample(
          before: '''ElevatedButton(
  onPressed: _handleSubmit,
  child: Text('Submit'),
)''',
          after: '''TossPrimaryButton(
  text: 'Submit',
  onPressed: _handleSubmit,
)''',
        ),
        migrationSteps: [
          'Import TossPrimaryButton',
          'Replace ElevatedButton',
          'Move text to text parameter',
          'Test form submissions',
        ],
        rollbackComplexity: 'Very Low',
        successRate: 0.96,
      ),
    };
  }
  
  Map<String, double> _generateCompatibilityMatrix() {
    return {
      'Container+BoxDecoration→TossCard': 0.63,
      'Card→TossCard': 0.69,
      'IconButton→TossIconButton': 0.90,
      'ElevatedButton→TossPrimaryButton': 0.92,
      'TextButton→TossSecondaryButton': 0.93,
      'AppBar→TossAppBar': 0.85,
      'TextField→TossTextField': 0.78,
      'showModalBottomSheet→TossModal': 0.45,
    };
  }
  
  Map<String, List<String>> _generateIssueCategories() {
    return {
      'State Management': [
        'StatefulWidget to StatelessWidget conversion risks',
        'Context dependencies in modals',
        'Form state preservation',
      ],
      'Animation': [
        'AnimationController memory leaks in TossCard',
        'Custom animation callbacks',
        'Transition timing differences',
      ],
      'Layout': [
        'Margin parameter positioning',
        'Padding inconsistencies',
        'Flex layout differences',
      ],
      'Theming': [
        'Color token mismatches',
        'Dark mode compatibility',
        'Custom theme overrides',
      ],
    };
  }
  
  Map<String, ImpactMetric> _generateImpactAnalysis() {
    return {
      'Performance': ImpactMetric(
        current: 16.0,
        projected: 14.5,
        unit: 'ms',
        change: -9.4,
        positive: true,
      ),
      'Bundle Size': ImpactMetric(
        current: 8.2,
        projected: 7.1,
        unit: 'MB',
        change: -13.4,
        positive: true,
      ),
      'Memory Usage': ImpactMetric(
        current: 145,
        projected: 132,
        unit: 'MB',
        change: -9.0,
        positive: true,
      ),
      'Code Lines': ImpactMetric(
        current: 45200,
        projected: 36160,
        unit: 'lines',
        change: -20.0,
        positive: true,
      ),
    };
  }
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(TossIcons.back),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: Text(
          '🔬 Widget Consistency Analyzer',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
      ),
      body: _isAnalyzing
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
                ),
                SizedBox(height: TossSpacing.space4),
                Text(
                  'Analyzing widget usage...',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              _buildSummarySection(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUsageTab(),
                    _buildIssuesTab(),
                    _buildCompatibilityTab(),
                    _buildImpactTab(),
                  ],
                ),
              ),
            ],
          ),
    );
  }
  
  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Widgets',
              value: '302',
              subtitle: 'Toss widgets in use',
              color: TossColors.primary,
              icon: Icons.widgets,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: _buildSummaryCard(
              title: 'Duplicates',
              value: '1327',
              subtitle: 'Can be replaced',
              color: TossColors.warning,
              icon: Icons.copy_all,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: _buildSummaryCard(
              title: 'Hardcoded',
              value: '14.8k',
              subtitle: 'Styles to fix',
              color: TossColors.error,
              icon: Icons.warning,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: TossSpacing.space1),
              Text(
                title,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            value,
            style: TossTextStyles.h2.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar() {
    return TossTabBar(
      tabs: const ['Usage', 'Issues', 'Compatibility', 'Impact'],
      controller: _tabController,
    );
  }
  
  Widget _buildUsageTab() {
    final widgets = _analysisState.widgetData.values.toList();
    
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.space4),
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        final widget = widgets[index];
        return _buildUsageCard(widget);
      },
    );
  }
  
  Widget _buildUsageCard(WidgetMigrationData data) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.nativeWidget,
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '→ ${data.tossWidget}',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildRiskBadge(data.riskLevel),
              ],
            ),
            
            SizedBox(height: TossSpacing.space3),
            
            // Metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric('Files', data.filesAffected.toString()),
                _buildMetric('Usage', data.usageCount.toString()),
                _buildMetric('Hours', data.migrationEffort.hours.toString()),
                _buildMetric('Success', '${(data.successRate * 100).toInt()}%'),
              ],
            ),
            
            // Expand button
            SizedBox(height: TossSpacing.space3),
            TossSecondaryButton(
              text: _selectedWidget == data.nativeWidget ? 'Hide Details' : 'View Details',
              onPressed: () {
                setState(() {
                  _selectedWidget = _selectedWidget == data.nativeWidget 
                    ? null 
                    : data.nativeWidget;
                });
              },
            ),
            
            // Expanded details
            if (_selectedWidget == data.nativeWidget) ...[
              SizedBox(height: TossSpacing.space3),
              _buildExpandedDetails(data),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildExpandedDetails(WidgetMigrationData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Performance Impact
        _buildSectionTitle('Performance Impact'),
        Container(
          padding: EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Column(
            children: [
              _buildImpactRow('Render Time', '${data.performanceImpact.renderTime}%'),
              _buildImpactRow('Memory', '${data.performanceImpact.memoryUsage}%'),
              _buildImpactRow('Bundle Size', '${data.performanceImpact.bundleSize}%'),
            ],
          ),
        ),
        
        // Breaking Changes
        if (data.breakingChanges.isNotEmpty) ...[
          SizedBox(height: TossSpacing.space3),
          _buildSectionTitle('⚠️ Breaking Changes'),
          ...data.breakingChanges.map((change) => Padding(
            padding: EdgeInsets.only(left: TossSpacing.space3, top: TossSpacing.space1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TossTextStyles.body.copyWith(color: TossColors.error)),
                Expanded(
                  child: Text(
                    change,
                    style: TossTextStyles.small.copyWith(color: TossColors.gray700),
                  ),
                ),
              ],
            ),
          )),
        ],
        
        // Code Example
        SizedBox(height: TossSpacing.space3),
        _buildSectionTitle('Code Example'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCodeBlock('Before', data.codeExample.before, TossColors.error),
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: _buildCodeBlock('After', data.codeExample.after, TossColors.success),
            ),
          ],
        ),
        
        // Migration Steps
        SizedBox(height: TossSpacing.space3),
        _buildSectionTitle('Migration Steps'),
        ...data.migrationSteps.asMap().entries.map((entry) => Padding(
          padding: EdgeInsets.only(top: TossSpacing.space2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  entry.value,
                  style: TossTextStyles.body,
                ),
              ),
            ],
          ),
        )),
        
        // Testing Requirements
        SizedBox(height: TossSpacing.space3),
        _buildSectionTitle('Testing Requirements'),
        ...data.testingRequirements.map((req) => Padding(
          padding: EdgeInsets.only(top: TossSpacing.space2),
          child: Row(
            children: [
              Icon(
                req.required ? Icons.check_box : Icons.check_box_outline_blank,
                size: 20,
                color: req.required ? TossColors.primary : TossColors.gray400,
              ),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(req.name, style: TossTextStyles.body),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: _getPriorityColor(req.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: Text(
                  req.priority,
                  style: TossTextStyles.caption.copyWith(
                    color: _getPriorityColor(req.priority),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
  
  Widget _buildIssuesTab() {
    return ListView(
      padding: EdgeInsets.all(TossSpacing.space4),
      children: _analysisState.issueCategories.entries.map((entry) {
        return Container(
          margin: EdgeInsets.only(bottom: TossSpacing.space3),
          child: TossCard(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                ...entry.value.map((issue) => Padding(
                  padding: EdgeInsets.only(top: TossSpacing.space1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.error_outline, size: 16, color: TossColors.warning),
                      SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          issue,
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.gray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildCompatibilityTab() {
    final widgets = _analysisState.widgetData.values.toList();
    
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.space4),
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        final widget = widgets[index];
        return _buildCompatibilityCard(widget);
      },
    );
  }
  
  Widget _buildCompatibilityCard(WidgetMigrationData data) {
    final compatibilityPercent = (data.compatibility * 100).toInt();
    final isGoodCompatibility = data.compatibility >= 0.8;
    final compatibilityColor = isGoodCompatibility ? TossColors.success : 
      data.compatibility >= 0.6 ? TossColors.warning : TossColors.error;
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Header with migration path
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Text(
                      data.nativeWidget,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: TossColors.gray400,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primarySurface,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Text(
                      data.tossWidget,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space3),
            
            // Compatibility Score
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isGoodCompatibility ? Icons.check_circle : Icons.warning,
                  color: compatibilityColor,
                  size: 24,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  '$compatibilityPercent% Compatible',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: compatibilityColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            // Recommendation
            Text(
              isGoodCompatibility 
                ? 'Safe to replace with minimal testing'
                : data.compatibility >= 0.6
                  ? 'Requires careful testing and validation'
                  : 'High risk - consider alternatives',
              style: TossTextStyles.small.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Additional metrics
            SizedBox(height: TossSpacing.space3),
            Container(
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSmallMetric('Effort', '${data.migrationEffort.hours}h'),
                  _buildSmallMetric('Files', data.filesAffected.toString()),
                  _buildSmallMetric('Risk', data.riskLevel.name),
                  _buildSmallMetric('Success', '${(data.successRate * 100).toInt()}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImpactTab() {
    return ListView(
      padding: EdgeInsets.all(TossSpacing.space4),
      children: [
        Text(
          'Projected Impact Analysis',
          style: TossTextStyles.h2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: TossSpacing.space4),
        ..._analysisState.impactAnalysis.entries.map((entry) {
          return _buildImpactCard(entry.key, entry.value);
        }),
      ],
    );
  }
  
  Widget _buildImpactCard(String title, ImpactMetric metric) {
    final changeColor = metric.positive ? TossColors.success : TossColors.error;
    final changeIcon = metric.positive ? Icons.trending_down : Icons.trending_up;
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: TossSpacing.space3),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      Text(
                        '${metric.current} ${metric.unit}',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: TossColors.gray400, size: 20),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Projected',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      Text(
                        '${metric.projected} ${metric.unit}',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: changeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Row(
                    children: [
                      Icon(changeIcon, size: 16, color: changeColor),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        '${metric.change.abs().toStringAsFixed(1)}%',
                        style: TossTextStyles.caption.copyWith(
                          color: changeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper widgets
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space2),
      child: Text(
        title,
        style: TossTextStyles.body.copyWith(
          fontWeight: FontWeight.bold,
          color: TossColors.gray800,
        ),
      ),
    );
  }
  
  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        SizedBox(height: TossSpacing.space1),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSmallMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildImpactRow(String label, String value) {
    final numValue = int.tryParse(value.replaceAll('%', '')) ?? 0;
    final color = numValue == 0 ? TossColors.gray600 :
      numValue < 0 ? TossColors.success : TossColors.error;
    
    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TossTextStyles.small),
          Text(
            value,
            style: TossTextStyles.small.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCodeBlock(String title, String code, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space1),
        Container(
          padding: EdgeInsets.all(TossSpacing.space2),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Text(
            code,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: TossColors.gray700,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildRiskBadge(RiskLevel risk) {
    Color color;
    String label;
    IconData icon;
    
    switch (risk) {
      case RiskLevel.low:
        color = TossColors.success;
        label = 'Low Risk';
        icon = Icons.check_circle;
        break;
      case RiskLevel.medium:
        color = TossColors.warning;
        label = 'Medium';
        icon = Icons.warning;
        break;
      case RiskLevel.high:
        color = TossColors.error;
        label = 'High Risk';
        icon = Icons.dangerous;
        break;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: TossSpacing.space1),
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return TossColors.error;
      case 'high':
        return TossColors.warning;
      case 'medium':
        return TossColors.info;
      case 'low':
        return TossColors.gray500;
      default:
        return TossColors.gray400;
    }
  }
}

// Data models
class WidgetAnalysisState {
  final int totalWidgets;
  final int duplicateCount;
  final int hardcodedStyleCount;
  final Map<String, WidgetMigrationData> widgetData;
  final Map<String, double> compatibilityMatrix;
  final Map<String, List<String>> issueCategories;
  final Map<String, ImpactMetric> impactAnalysis;
  
  WidgetAnalysisState({
    this.totalWidgets = 0,
    this.duplicateCount = 0,
    this.hardcodedStyleCount = 0,
    this.widgetData = const {},
    this.compatibilityMatrix = const {},
    this.issueCategories = const {},
    this.impactAnalysis = const {},
  });
}

class WidgetMigrationData {
  final String nativeWidget;
  final String tossWidget;
  final int usageCount;
  final int filesAffected;
  final double compatibility;
  final RiskLevel riskLevel;
  final MigrationEffort migrationEffort;
  final PerformanceImpact performanceImpact;
  final List<TestRequirement> testingRequirements;
  final List<String> breakingChanges;
  final CodeExample codeExample;
  final List<String> migrationSteps;
  final String rollbackComplexity;
  final double successRate;
  
  WidgetMigrationData({
    required this.nativeWidget,
    required this.tossWidget,
    required this.usageCount,
    required this.filesAffected,
    required this.compatibility,
    required this.riskLevel,
    required this.migrationEffort,
    required this.performanceImpact,
    required this.testingRequirements,
    required this.breakingChanges,
    required this.codeExample,
    required this.migrationSteps,
    required this.rollbackComplexity,
    required this.successRate,
  });
}

class MigrationEffort {
  final int hours;
  final String complexity;
  
  MigrationEffort({required this.hours, required this.complexity});
}

class PerformanceImpact {
  final int renderTime;
  final int memoryUsage;
  final int bundleSize;
  
  PerformanceImpact({
    required this.renderTime,
    required this.memoryUsage,
    required this.bundleSize,
  });
}

class TestRequirement {
  final String name;
  final String priority;
  final bool required;
  
  TestRequirement(this.name, this.priority, this.required);
}

class CodeExample {
  final String before;
  final String after;
  
  CodeExample({required this.before, required this.after});
}

class ImpactMetric {
  final double current;
  final double projected;
  final String unit;
  final double change;
  final bool positive;
  
  ImpactMetric({
    required this.current,
    required this.projected,
    required this.unit,
    required this.change,
    required this.positive,
  });
}

enum RiskLevel { low, medium, high }

// Widget usage data model (for compatibility with existing code)
class WidgetUsageData {
  final String widgetName;
  final int usageCount;
  final int duplicateCount;
  final double similarityScore;
  final List<String> breakingChanges;
  final RiskLevel riskLevel;
  
  WidgetUsageData({
    required this.widgetName,
    required this.usageCount,
    required this.duplicateCount,
    required this.similarityScore,
    required this.breakingChanges,
    required this.riskLevel,
  });
}