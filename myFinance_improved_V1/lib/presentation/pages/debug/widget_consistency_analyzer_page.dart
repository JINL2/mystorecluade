import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/toss/toss_card.dart';

// Widget analysis models
class WidgetUsageData {
  final String widgetName;
  final int usageCount;
  final int duplicateCount;
  final RiskLevel riskLevel;
  final double similarityScore;
  final List<String> breakingChanges;
  final List<String> affectedFiles;
  
  WidgetUsageData({
    required this.widgetName,
    required this.usageCount,
    required this.duplicateCount,
    required this.riskLevel,
    required this.similarityScore,
    required this.breakingChanges,
    required this.affectedFiles,
  });
}

class MigrationIssue {
  final String title;
  final String description;
  final IssueCategory category;
  final RiskLevel riskLevel;
  final String example;
  final String mitigation;
  
  MigrationIssue({
    required this.title,
    required this.description,
    required this.category,
    required this.riskLevel,
    required this.example,
    required this.mitigation,
  });
}

enum RiskLevel { low, medium, high, critical }
enum IssueCategory { 
  propertyIncompatibility,
  stateManagement,
  eventHandlers,
  layoutRendering,
  animation,
  businessLogic,
  testing
}

// Provider for widget analysis state
final widgetAnalysisProvider = StateNotifierProvider<WidgetAnalysisNotifier, WidgetAnalysisState>(
  (ref) => WidgetAnalysisNotifier(),
);

class WidgetAnalysisState {
  final bool isAnalyzing;
  final Map<String, WidgetUsageData> widgetData;
  final List<MigrationIssue> issues;
  final Map<String, double> compatibilityMatrix;
  final int totalWidgets;
  final int totalDuplicates;
  final int hardcodedStyles;
  
  WidgetAnalysisState({
    this.isAnalyzing = false,
    this.widgetData = const {},
    this.issues = const [],
    this.compatibilityMatrix = const {},
    this.totalWidgets = 0,
    this.totalDuplicates = 0,
    this.hardcodedStyles = 0,
  });
  
  WidgetAnalysisState copyWith({
    bool? isAnalyzing,
    Map<String, WidgetUsageData>? widgetData,
    List<MigrationIssue>? issues,
    Map<String, double>? compatibilityMatrix,
    int? totalWidgets,
    int? totalDuplicates,
    int? hardcodedStyles,
  }) {
    return WidgetAnalysisState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      widgetData: widgetData ?? this.widgetData,
      issues: issues ?? this.issues,
      compatibilityMatrix: compatibilityMatrix ?? this.compatibilityMatrix,
      totalWidgets: totalWidgets ?? this.totalWidgets,
      totalDuplicates: totalDuplicates ?? this.totalDuplicates,
      hardcodedStyles: hardcodedStyles ?? this.hardcodedStyles,
    );
  }
}

class WidgetAnalysisNotifier extends StateNotifier<WidgetAnalysisState> {
  WidgetAnalysisNotifier() : super(WidgetAnalysisState());
  
  Future<void> analyzeWidgets() async {
    state = state.copyWith(isAnalyzing: true);
    
    // Simulate analysis (in real implementation, this would call the analyzer)
    await Future<void>.delayed(const Duration(seconds: 2));
    
    // Generate sample data based on actual findings
    final widgetData = <String, WidgetUsageData>{
      'Container+BoxDecoration': WidgetUsageData(
        widgetName: 'Container+BoxDecoration',
        usageCount: 372,
        duplicateCount: 372,
        riskLevel: RiskLevel.medium,
        similarityScore: 0.633,
        breakingChanges: [
          'Missing constraints property',
          'BorderRadius type mismatch',
          'Transform property not supported',
          'ClipBehavior not available',
        ],
        affectedFiles: [
          'auth/login_page.dart',
          'sales/sale_product_page.dart',
          'inventory/inventory_management_page.dart',
        ],
      ),
      'Card': WidgetUsageData(
        widgetName: 'Card',
        usageCount: 326,
        duplicateCount: 326,
        riskLevel: RiskLevel.medium,
        similarityScore: 0.688,
        breakingChanges: [
          'Shape property not supported',
          'BorderOnForeground missing',
          'Different elevation behavior',
        ],
        affectedFiles: [
          'homepage/homepage_redesigned.dart',
          'inventory/product_card.dart',
          'cash_location/cash_location_page.dart',
        ],
      ),
      'IconButton': WidgetUsageData(
        widgetName: 'IconButton',
        usageCount: 163,
        duplicateCount: 163,
        riskLevel: RiskLevel.low,
        similarityScore: 0.90,
        breakingChanges: [
          'Minor tooltip behavior difference',
        ],
        affectedFiles: [
          'Various pages across application',
        ],
      ),
      'showModalBottomSheet': WidgetUsageData(
        widgetName: 'showModalBottomSheet',
        usageCount: 101,
        duplicateCount: 101,
        riskLevel: RiskLevel.critical,
        similarityScore: 0.45,
        breakingChanges: [
          'Builder pattern completely different',
          'Context not provided in content',
          'Constraints parameter missing',
          'Background color handling different',
          'Animation controller conflicts',
        ],
        affectedFiles: [
          'auth/forgot_password_page.dart',
          'sale_product/sale_payment_page.dart',
          'Critical payment flows',
        ],
      ),
    };
    
    // Generate migration issues
    final issues = [
      MigrationIssue(
        title: 'State Loss in Form Widgets',
        description: 'Replacing StatefulWidget with StatelessWidget loses form validation state',
        category: IssueCategory.stateManagement,
        riskLevel: RiskLevel.critical,
        example: 'TextEditingController disposal not handled in TossModal',
        mitigation: 'Create StatefulWrapper for form-containing modals',
      ),
      MigrationIssue(
        title: 'Animation Controller Memory Leaks',
        description: 'Every TossCard creates animation controller, causing performance issues in lists',
        category: IssueCategory.animation,
        riskLevel: RiskLevel.high,
        example: '100 cards = 100 animation controllers = 60fps → 30fps',
        mitigation: 'Use shared animation controller for list items',
      ),
      MigrationIssue(
        title: 'Builder Context Missing',
        description: 'TossBottomSheet content has no BuildContext, breaking Navigator calls',
        category: IssueCategory.eventHandlers,
        riskLevel: RiskLevel.critical,
        example: 'Navigator.of(context).pop() fails in TossBottomSheet content',
        mitigation: 'Pass context as parameter or use Builder widget',
      ),
      MigrationIssue(
        title: 'Layout Constraint Violations',
        description: 'TossCard lacks constraints property, causing overflow in lists',
        category: IssueCategory.layoutRendering,
        riskLevel: RiskLevel.high,
        example: 'Container(constraints: BoxConstraints(maxHeight: 200)) → TossCard overflow',
        mitigation: 'Wrap TossCard in ConstrainedBox when needed',
      ),
      MigrationIssue(
        title: 'Provider Context Loss',
        description: 'Static content in TossBottomSheet breaks Riverpod provider access',
        category: IssueCategory.businessLogic,
        riskLevel: RiskLevel.critical,
        example: 'ref.watch(provider) not available in TossBottomSheet content',
        mitigation: 'Use ConsumerStatefulWidget wrapper pattern',
      ),
      MigrationIssue(
        title: 'Test Selector Breakage',
        description: 'Widget tree structure changes break all existing widget tests',
        category: IssueCategory.testing,
        riskLevel: RiskLevel.high,
        example: 'find.byKey(Key("submit-button")) no longer works',
        mitigation: 'Update test selectors or add compatibility keys',
      ),
    ];
    
    state = state.copyWith(
      isAnalyzing: false,
      widgetData: widgetData,
      issues: issues,
      totalWidgets: 302,
      totalDuplicates: 1327,
      hardcodedStyles: 14803,
      compatibilityMatrix: {
        'Container+BoxDecoration→TossCard': 0.633,
        'Card→TossCard': 0.688,
        'IconButton→TossIconButton': 0.90,
        'TextButton→TossSecondaryButton': 0.90,
        'showModalBottomSheet→TossBottomSheet': 0.45,
      },
    );
  }
}

class WidgetConsistencyAnalyzerPage extends ConsumerStatefulWidget {
  const WidgetConsistencyAnalyzerPage({super.key});

  @override
  ConsumerState<WidgetConsistencyAnalyzerPage> createState() => 
      _WidgetConsistencyAnalyzerPageState();
}

class _WidgetConsistencyAnalyzerPageState 
    extends ConsumerState<WidgetConsistencyAnalyzerPage> 
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Auto-run analysis on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(widgetAnalysisProvider.notifier).analyzeWidgets();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(widgetAnalysisProvider);
    
    return Scaffold(
      backgroundColor: TossColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            TossAppBar(
              title: '🔬 Widget Consistency Analyzer',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                if (analysisState.isAnalyzing)
                  const Padding(
                    padding: EdgeInsets.only(right: TossSpacing.space4),
                    child: SizedBox(
                      width: TossSpacing.iconSM,
                      height: TossSpacing.iconSM,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: TossColors.primary,
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      ref.read(widgetAnalysisProvider.notifier).analyzeWidgets();
                    },
                  ),
              ],
            ),
            
            // Summary Cards
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Widgets',
                      value: analysisState.totalWidgets.toString(),
                      subtitle: 'Toss widgets in use',
                      color: TossColors.primary,
                      icon: Icons.widgets,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Duplicates',
                      value: analysisState.totalDuplicates.toString(),
                      subtitle: 'Can be replaced',
                      color: TossColors.warning,
                      icon: Icons.copy_all,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Hardcoded',
                      value: '${(analysisState.hardcodedStyles / 1000).toStringAsFixed(1)}k',
                      subtitle: 'Styles to fix',
                      color: TossColors.error,
                      icon: Icons.warning_amber,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            Container(
              color: TossColors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: TossColors.primary,
                unselectedLabelColor: TossColors.gray600,
                indicatorColor: TossColors.primary,
                tabs: const [
                  Tab(text: 'Usage'),
                  Tab(text: 'Issues'),
                  Tab(text: 'Compatibility'),
                  Tab(text: 'Impact'),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUsageTab(analysisState),
                  _buildIssuesTab(analysisState),
                  _buildCompatibilityTab(analysisState),
                  _buildImpactTab(analysisState),
                ],
              ),
            ),
          ],
        ),
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
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: TossSpacing.iconXS, color: color),
              SizedBox(width: TossSpacing.space2),
              Text(
                title,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            value,
            style: TossTextStyles.h1.copyWith(
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
  
  Widget _buildUsageTab(WidgetAnalysisState state) {
    return ListView(
      padding: EdgeInsets.all(TossSpacing.space4),
      children: [
        Text(
          'Widget Usage Analysis',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: TossSpacing.space4),
        ...state.widgetData.values.map((data) => _buildWidgetUsageCard(data)),
      ],
    );
  }
  
  Widget _buildWidgetUsageCard(WidgetUsageData data) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data.widgetName,
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildRiskBadge(data.riskLevel),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Usage', data.usageCount.toString()),
              _buildMetric('Duplicates', data.duplicateCount.toString()),
              _buildMetric('Similarity', '${(data.similarityScore * 100).toStringAsFixed(0)}%'),
            ],
          ),
          if (data.breakingChanges.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space3),
            Text(
              '⚠️ Breaking Changes:',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: TossColors.warning,
              ),
            ),
            SizedBox(height: TossSpacing.space1),
            ...data.breakingChanges.map((change) => Padding(
              padding: EdgeInsets.only(left: TossSpacing.space4, top: TossSpacing.space1),
              child: Text(
                '• $change',
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ),),
          ],
        ],
        ),
      ),
    );
  }
  
  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
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
        label = 'Medium Risk';
        icon = Icons.warning;
        break;
      case RiskLevel.high:
        color = TossColors.error;
        label = 'High Risk';
        icon = Icons.error;
        break;
      case RiskLevel.critical:
        color = TossColors.error;
        label = 'Critical';
        icon = Icons.dangerous;
        break;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: TossSpacing.space1),
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIssuesTab(WidgetAnalysisState state) {
    return ListView(
      padding: EdgeInsets.all(TossSpacing.space4),
      children: [
        Text(
          'Potential Migration Issues',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Text(
          'Critical issues that could break the application when replacing widgets',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
        SizedBox(height: TossSpacing.space4),
        ...state.issues.map((issue) => _buildIssueCard(issue)),
      ],
    );
  }
  
  Widget _buildIssueCard(MigrationIssue issue) {
    late IconData categoryIcon;
    late Color categoryColor;
    
    switch (issue.category) {
      case IssueCategory.propertyIncompatibility:
        categoryIcon = Icons.settings;
        categoryColor = TossColors.primary;
        break;
      case IssueCategory.stateManagement:
        categoryIcon = Icons.storage;
        categoryColor = TossColors.primary;
        break;
      case IssueCategory.eventHandlers:
        categoryIcon = Icons.touch_app;
        categoryColor = TossColors.success;
        break;
      case IssueCategory.layoutRendering:
        categoryIcon = Icons.dashboard;
        categoryColor = TossColors.warning;
        break;
      case IssueCategory.animation:
        categoryIcon = Icons.animation;
        categoryColor = TossColors.error;
        break;
      case IssueCategory.businessLogic:
        categoryIcon = Icons.business_center;
        categoryColor = TossColors.error;
        break;
      case IssueCategory.testing:
        categoryIcon = Icons.bug_report;
        categoryColor = TossColors.gray700;
        break;
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(categoryIcon, size: TossSpacing.iconSM, color: categoryColor),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  issue.title,
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildRiskBadge(issue.riskLevel),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            issue.description,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          Container(
            padding: EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Example:',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.gray600,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  issue.example,
                  style: TossTextStyles.caption.copyWith(
                    fontFamily: TossTextStyles.fontFamilyMono,
                    color: TossColors.gray800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 14,
                color: TossColors.primary,
              ),
              SizedBox(width: TossSpacing.space1),
              Expanded(
                child: Text(
                  'Mitigation: ${issue.mitigation}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
  
  Widget _buildCompatibilityTab(WidgetAnalysisState state) {
    return ListView(
      padding: EdgeInsets.all(TossSpacing.space4),
      children: [
        Text(
          'Widget Compatibility Matrix',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: TossSpacing.space4),
        ...state.compatibilityMatrix.entries.map((entry) {
          final parts = entry.key.split('→');
          return _buildCompatibilityCard(
            from: parts[0],
            to: parts[1],
            score: entry.value,
          );
        }),
      ],
    );
  }
  
  Widget _buildCompatibilityCard({
    required String from,
    required String to,
    required double score,
  }) {
    late Color scoreColor;
    late String recommendation;
    late IconData icon;
    
    if (score >= 0.8) {
      scoreColor = TossColors.success;
      recommendation = 'Safe to replace with minimal testing';
      icon = Icons.check_circle;
    } else if (score >= 0.6) {
      scoreColor = TossColors.warning;
      recommendation = 'Requires careful testing and validation';
      icon = Icons.warning;
    } else {
      scoreColor = TossColors.error;
      recommendation = 'High risk - consider alternatives';
      icon = Icons.dangerous;
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Text(
                    from,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                child: Icon(
                  Icons.arrow_forward,
                  size: TossSpacing.iconSM,
                  color: TossColors.gray400,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.primarySurface,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Text(
                    to,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: TossSpacing.iconSM, color: scoreColor),
              SizedBox(width: TossSpacing.space2),
              Text(
                '${(score * 100).toStringAsFixed(0)}% Compatible',
                style: TossTextStyles.caption.copyWith(
                  
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            recommendation,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
        ),
      ),
    );
  }
  
  Widget _buildImpactTab(WidgetAnalysisState state) {
    final totalPotentialReduction = state.totalDuplicates;
    final reductionPercentage = (totalPotentialReduction / 
        (state.totalWidgets + totalPotentialReduction) * 100);
    
    return ListView(
      padding: EdgeInsets.all(TossSpacing.space4),
      children: [
        Text(
          'Migration Impact Analysis',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: TossSpacing.space4),
        
        // Impact Summary
        TossCard(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📈 Potential Impact',
                style: TossTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              _buildImpactRow(
                'Code Reduction',
                '${reductionPercentage.toStringAsFixed(1)}%',
                '~$totalPotentialReduction widgets',
                TossColors.success,
              ),
              SizedBox(height: TossSpacing.space3),
              _buildImpactRow(
                'Consistency Improvement',
                'High',
                'Visual uniformity',
                TossColors.primary,
              ),
              SizedBox(height: TossSpacing.space3),
              _buildImpactRow(
                'Maintenance Benefit',
                'Significant',
                '50% time reduction',
                TossColors.primary,
              ),
              SizedBox(height: TossSpacing.space3),
              _buildImpactRow(
                'Risk Level',
                'Manageable',
                'With proper testing',
                TossColors.warning,
              ),
            ],
          ),
        ),
        SizedBox(height: TossSpacing.space4),
        
        // Implementation Timeline
        TossCard(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📅 Implementation Timeline',
                style: TossTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              _buildTimelineItem(
                'Week 1',
                'Quick Wins',
                '150+ safe replacements',
                TossColors.success,
              ),
              _buildTimelineItem(
                'Week 2-3',
                'Systematic Migration',
                '200+ with testing',
                TossColors.primary,
              ),
              _buildTimelineItem(
                'Week 4+',
                'Complex Refactoring',
                'Architecture improvements',
                TossColors.primary,
              ),
            ],
          ),
        ),
        SizedBox(height: TossSpacing.space4),
        
        // Critical Warnings
        TossCard(
          backgroundColor: TossColors.errorLight,
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.warning,
                    color: TossColors.error,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Critical Warnings',
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space3),
              _buildWarningItem('Never replace widgets in authentication flows without extensive testing'),
              _buildWarningItem('Payment processing widgets require special handling'),
              _buildWarningItem('Animation-dependent widgets may break with replacements'),
              _buildWarningItem('Form validation state must be preserved during migration'),
              _buildWarningItem('Provider/Riverpod context must remain accessible'),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildImpactRow(String label, String value, String subtitle, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TossTextStyles.caption.copyWith(
            
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTimelineItem(String phase, String title, String description, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(top: TossSpacing.space2),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      phase,
                      style: TossTextStyles.caption.copyWith(
                        
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  description,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWarningItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.error,
            ),
          ),
          SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              text,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}