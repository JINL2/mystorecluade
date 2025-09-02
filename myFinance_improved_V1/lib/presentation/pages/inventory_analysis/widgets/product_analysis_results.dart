import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/supply_chain_models.dart';
import 'analysis_config_panel.dart';

// Product Analysis Result Model
class ProductAnalysisResult {
  final ProductInfo product;
  final List<SupplyChainProblem> problems;
  final double totalFinancialImpact;
  final int totalDaysAccumulated;
  final SupplyChainStage mostCriticalStage;
  final double riskScore;
  final List<SmartAction> recommendedActions;

  const ProductAnalysisResult({
    required this.product,
    required this.problems,
    required this.totalFinancialImpact,
    required this.totalDaysAccumulated,
    required this.mostCriticalStage,
    required this.riskScore,
    required this.recommendedActions,
  });
}

// Product Analysis Results Provider
final productAnalysisResultsProvider = StateProvider<List<ProductAnalysisResult>>((ref) {
  return [];
});

final isAnalysisLoadingProvider = StateProvider<bool>((ref) => false);

class ProductAnalysisResults extends ConsumerStatefulWidget {
  final bool isMobile;
  final Function(ProductAnalysisResult)? onProductTap;
  final Function(ProductAnalysisResult, SmartAction)? onActionTap;

  const ProductAnalysisResults({
    super.key,
    this.isMobile = false,
    this.onProductTap,
    this.onActionTap,
  });

  @override
  ConsumerState<ProductAnalysisResults> createState() => _ProductAnalysisResultsState();
}

class _ProductAnalysisResultsState extends ConsumerState<ProductAnalysisResults> {
  String sortBy = 'risk'; // risk, impact, days
  bool sortAscending = false;

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(productAnalysisResultsProvider);
    final isLoading = ref.watch(isAnalysisLoadingProvider);
    final config = ref.watch(analysisConfigProvider);
    
    if (isLoading) {
      return _buildLoadingState(context);
    }
    
    if (results.isEmpty) {
      return _buildEmptyState(context, config);
    }
    
    final sortedResults = _sortResults(results);
    
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, results.length, config),
          _buildSortControls(context),
          _buildResultsList(context, sortedResults),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int resultCount, AnalysisConfig config) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TossColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              Icons.list_alt,
              color: TossColors.success,
              size: 20,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Analysis Results',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$resultCount products analyzed • ${config.fromStage.englishLabel} → ${config.toStage.englishLabel}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          // Export button
          IconButton(
            onPressed: () => _exportResults(context),
            icon: Icon(
              Icons.download,
              color: TossColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortControls(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Sort by:',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: TossSpacing.space2),
          
          Wrap(
            spacing: TossSpacing.space2,
            children: [
              _buildSortChip(context, 'Risk Score', 'risk'),
              _buildSortChip(context, 'Financial Impact', 'impact'),
              _buildSortChip(context, 'Days Accumulated', 'days'),
            ],
          ),
          
          Spacer(),
          
          // Sort direction toggle
          GestureDetector(
            onTap: () {
              setState(() {
                sortAscending = !sortAscending;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: TossColors.gray700,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    sortAscending ? 'Low to High' : 'High to Low',
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(BuildContext context, String label, String value) {
    final isSelected = sortBy == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          sortBy = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray200,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Text(
          label,
          style: TossTextStyles.small.copyWith(
            color: isSelected ? Colors.white : TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, List<ProductAnalysisResult> results) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return Column(
            children: [
              _buildProductResultCard(context, result),
              if (index < results.length - 1)
                Divider(
                  height: 1,
                  color: TossColors.gray100,
                  indent: TossSpacing.space4,
                  endIndent: TossSpacing.space4,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductResultCard(BuildContext context, ProductAnalysisResult result) {
    if (widget.isMobile) {
      return _buildMobileProductCard(context, result);
    }
    return _buildDesktopProductCard(context, result);
  }

  Widget _buildDesktopProductCard(BuildContext context, ProductAnalysisResult result) {
    return InkWell(
      onTap: () => widget.onProductTap?.call(result),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            // Product Info
            Expanded(
              flex: 3,
              child: _buildProductInfo(context, result),
            ),
            
            SizedBox(width: TossSpacing.space3),
            
            // Risk Assessment
            Expanded(
              flex: 2,
              child: _buildRiskAssessment(context, result),
            ),
            
            SizedBox(width: TossSpacing.space3),
            
            // Financial Impact
            Expanded(
              flex: 2,
              child: _buildFinancialImpact(context, result),
            ),
            
            SizedBox(width: TossSpacing.space3),
            
            // Quick Actions
            _buildQuickActions(context, result),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProductCard(BuildContext context, ProductAnalysisResult result) {
    return InkWell(
      onTap: () => widget.onProductTap?.call(result),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product + Risk Score
            Row(
              children: [
                Expanded(child: _buildProductInfo(context, result)),
                _buildRiskBadge(context, result.riskScore),
              ],
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            // Financial Impact + Days
            Row(
              children: [
                Expanded(child: _buildFinancialImpact(context, result)),
                SizedBox(width: TossSpacing.space2),
                Expanded(child: _buildDaysAccumulated(context, result)),
              ],
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            // Critical Stage + Actions
            Row(
              children: [
                Expanded(child: _buildCriticalStage(context, result)),
                _buildMobileActions(context, result),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, ProductAnalysisResult result) {
    return Row(
      children: [
        // Product Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getProductColor(result.product.name),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Center(
            child: Text(
              _getProductInitial(result.product.name),
              style: TossTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        SizedBox(width: TossSpacing.space3),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.product.name,
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${result.product.brand} • ${result.product.category}',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'SKU: ${result.product.sku}',
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRiskAssessment(BuildContext context, ProductAnalysisResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildRiskBadge(context, result.riskScore),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Score',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${result.riskScore.toInt()}/100',
                    style: TossTextStyles.body.copyWith(
                      color: _getRiskColor(result.riskScore),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        SizedBox(height: TossSpacing.space2),
        
        Text(
          'Problems: ${result.problems.length}',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
          ),
        ),
        Text(
          'Critical Stage: ${result.mostCriticalStage.englishLabel}',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialImpact(BuildContext context, ProductAnalysisResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Impact',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: TossSpacing.space1),
        
        Text(
          _formatCurrency(result.totalFinancialImpact),
          style: TossTextStyles.h4.copyWith(
            color: TossColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        SizedBox(height: TossSpacing.space1),
        
        Row(
          children: [
            Icon(
              Icons.schedule,
              color: TossColors.warning,
              size: 14,
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              '${result.totalDaysAccumulated} days',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysAccumulated(BuildContext context, ProductAnalysisResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Days Accumulated',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${result.totalDaysAccumulated}',
          style: TossTextStyles.h4.copyWith(
            color: TossColors.warning,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCriticalStage(BuildContext context, ProductAnalysisResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Critical Stage',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space2,
            vertical: TossSpacing.space1,
          ),
          decoration: BoxDecoration(
            color: _getStageColor(result.mostCriticalStage).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Text(
            result.mostCriticalStage.englishLabel,
            style: TossTextStyles.caption.copyWith(
              color: _getStageColor(result.mostCriticalStage),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskBadge(BuildContext context, double riskScore) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: _getRiskColor(riskScore).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: _getRiskColor(riskScore).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${riskScore.toInt()}',
            style: TossTextStyles.bodyLarge.copyWith(
              color: _getRiskColor(riskScore),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _getRiskEmoji(riskScore),
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ProductAnalysisResult result) {
    final topActions = result.recommendedActions.take(2).toList();
    
    return Column(
      children: topActions.map((action) {
        return Container(
          margin: EdgeInsets.only(bottom: TossSpacing.space1),
          child: SizedBox(
            width: 120,
            height: 32,
            child: ElevatedButton.icon(
              onPressed: () => widget.onActionTap?.call(result, action),
              icon: Icon(
                action.icon,
                size: 14,
                color: Colors.white,
              ),
              label: Text(
                action.englishLabel,
                style: TossTextStyles.small.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: action.color,
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                elevation: 0,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileActions(BuildContext context, ProductAnalysisResult result) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => widget.onProductTap?.call(result),
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.primary,
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            elevation: 0,
          ),
          child: Text(
            'View Details',
            style: TossTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        SizedBox(width: TossSpacing.space1),
        
        IconButton(
          onPressed: () => _showActionsMenu(context, result),
          icon: Icon(
            Icons.more_vert,
            color: TossColors.gray600,
            size: 20,
          ),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(TossSpacing.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
          ),
          SizedBox(height: TossSpacing.space3),
          Text(
            'Analyzing Products...',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Running supply chain analysis across selected parameters',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AnalysisConfig config) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(TossSpacing.space6),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: TossColors.info.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              color: TossColors.info,
              size: 32,
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          Text(
            'Ready for Analysis',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.info,
            ),
          ),
          
          SizedBox(height: TossSpacing.space1),
          
          Text(
            'Configure your analysis parameters and click "Run Vertical Analysis" to see detailed product-level results.',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Column(
              children: [
                Text(
                  'Current Configuration:',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  '${config.fromStage.englishLabel} → ${config.toStage.englishLabel}',
                  style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${_formatDate(config.startDate)} - ${_formatDate(config.endDate)}',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                Text(
                  config.includeAllProducts 
                      ? 'All products' 
                      : '${config.selectedProductIds.length} specific products',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ProductAnalysisResult> _sortResults(List<ProductAnalysisResult> results) {
    final sortedResults = List<ProductAnalysisResult>.from(results);
    
    sortedResults.sort((a, b) {
      int comparison;
      
      switch (sortBy) {
        case 'risk':
          comparison = a.riskScore.compareTo(b.riskScore);
          break;
        case 'impact':
          comparison = a.totalFinancialImpact.compareTo(b.totalFinancialImpact);
          break;
        case 'days':
          comparison = a.totalDaysAccumulated.compareTo(b.totalDaysAccumulated);
          break;
        default:
          comparison = a.riskScore.compareTo(b.riskScore);
      }
      
      return sortAscending ? comparison : -comparison;
    });
    
    return sortedResults;
  }

  void _showActionsMenu(BuildContext context, ProductAnalysisResult result) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Actions for ${result.product.name}',
              style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: TossSpacing.space3),
            
            ...result.recommendedActions.map((action) {
              return ListTile(
                leading: Icon(action.icon, color: action.color),
                title: Text(action.englishLabel, style: TossTextStyles.body),
                subtitle: Text(
                  'Est. ${action.estimatedTimeHours}h • ${(action.successProbability * 100).toInt()}% success rate',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onActionTap?.call(result, action);
                },
              );
            }).toList(),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _exportResults(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Analysis Results',
              style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: TossSpacing.space3),
            
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: Text('Excel Spreadsheet', style: TossTextStyles.body),
              subtitle: Text('Detailed data for further analysis', style: TossTextStyles.caption.copyWith(color: TossColors.gray600)),
              onTap: () {
                Navigator.pop(context);
                _performExport('Excel');
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text('PDF Report', style: TossTextStyles.body),
              subtitle: Text('Formatted executive summary', style: TossTextStyles.caption.copyWith(color: TossColors.gray600)),
              onTap: () {
                Navigator.pop(context);
                _performExport('PDF');
              },
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _performExport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting $format report...'),
        backgroundColor: TossColors.success,
      ),
    );
  }

  Color _getRiskColor(double riskScore) {
    if (riskScore >= 80) return TossColors.error;
    if (riskScore >= 60) return TossColors.warning;
    if (riskScore >= 40) return TossColors.info;
    return TossColors.success;
  }

  String _getRiskEmoji(double riskScore) {
    if (riskScore >= 80) return '🔴';
    if (riskScore >= 60) return '🟠';
    if (riskScore >= 40) return '🟡';
    return '🟢';
  }

  Color _getProductColor(String name) {
    final colors = [
      TossColors.primary,
      TossColors.success,
      TossColors.warning,
      TossColors.info,
      TossColors.error,
      TossColors.gray600,
    ];
    
    final index = name.hashCode % colors.length;
    return colors[index];
  }

  String _getProductInitial(String name) {
    if (name.isEmpty) return '?';
    
    if (RegExp(r'^\d').hasMatch(name)) {
      return '1';
    }
    
    return name[0].toUpperCase();
  }

  Color _getStageColor(SupplyChainStage stage) {
    switch (stage) {
      case SupplyChainStage.order:
        return TossColors.primary;
      case SupplyChainStage.send:
        return TossColors.warning;
      case SupplyChainStage.receive:
        return TossColors.success;
      case SupplyChainStage.sell:
        return TossColors.info;
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}