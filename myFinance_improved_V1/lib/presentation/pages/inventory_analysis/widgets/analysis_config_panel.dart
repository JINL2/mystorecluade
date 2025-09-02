import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../models/supply_chain_models.dart';

// Analysis Configuration State
class AnalysisConfig {
  final SupplyChainStage fromStage;
  final SupplyChainStage toStage;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> selectedProductIds;
  final bool includeAllProducts;

  const AnalysisConfig({
    required this.fromStage,
    required this.toStage,
    required this.startDate,
    required this.endDate,
    required this.selectedProductIds,
    required this.includeAllProducts,
  });

  AnalysisConfig copyWith({
    SupplyChainStage? fromStage,
    SupplyChainStage? toStage,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? selectedProductIds,
    bool? includeAllProducts,
  }) {
    return AnalysisConfig(
      fromStage: fromStage ?? this.fromStage,
      toStage: toStage ?? this.toStage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
      includeAllProducts: includeAllProducts ?? this.includeAllProducts,
    );
  }
}

// Analysis Configuration Provider
final analysisConfigProvider = StateProvider<AnalysisConfig>((ref) {
  final now = DateTime.now();
  return AnalysisConfig(
    fromStage: SupplyChainStage.order,
    toStage: SupplyChainStage.sell,
    startDate: now.subtract(const Duration(days: 30)),
    endDate: now,
    selectedProductIds: [],
    includeAllProducts: true,
  );
});

class AnalysisConfigPanel extends ConsumerStatefulWidget {
  final bool isMobile;
  final Function(AnalysisConfig)? onAnalysisRequested;

  const AnalysisConfigPanel({
    super.key,
    this.isMobile = false,
    this.onAnalysisRequested,
  });

  @override
  ConsumerState<AnalysisConfigPanel> createState() => _AnalysisConfigPanelState();
}

class _AnalysisConfigPanelState extends ConsumerState<AnalysisConfigPanel> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(analysisConfigProvider);
    
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
          _buildHeader(context),
          _buildConfigForm(context, config),
          _buildAnalysisButton(context, config),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              color: TossColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              TossIcons.business,
              color: TossColors.primary,
              size: 20,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vertical Analysis',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Configure detailed product-level analysis',
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

  Widget _buildConfigForm(BuildContext context, AnalysisConfig config) {
    return Padding(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stage Range Selector
          _buildStageRangeSelector(context, config),
          
          SizedBox(height: TossSpacing.space4),
          
          // Date Range Selector
          _buildDateRangeSelector(context, config),
          
          SizedBox(height: TossSpacing.space4),
          
          // Product Selection
          _buildProductSelector(context, config),
        ],
      ),
    );
  }

  Widget _buildStageRangeSelector(BuildContext context, AnalysisConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stage Range',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        
        Row(
          children: [
            // From Stage
            Expanded(
              child: _buildStageDropdown(
                context,
                'From Stage',
                config.fromStage,
                (stage) {
                  if (stage != null) {
                    ref.read(analysisConfigProvider.notifier).state = 
                        config.copyWith(fromStage: stage);
                  }
                },
              ),
            ),
            
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
              child: Icon(
                TossIcons.forward,
                color: TossColors.gray600,
                size: 20,
              ),
            ),
            
            // To Stage
            Expanded(
              child: _buildStageDropdown(
                context,
                'To Stage',
                config.toStage,
                (stage) {
                  if (stage != null) {
                    ref.read(analysisConfigProvider.notifier).state = 
                        config.copyWith(toStage: stage);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStageDropdown(
    BuildContext context,
    String label,
    SupplyChainStage selectedStage,
    Function(SupplyChainStage?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space1),
        
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray300),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<SupplyChainStage>(
              value: selectedStage,
              isExpanded: true,
              onChanged: onChanged,
              items: SupplyChainStage.values.map((stage) {
                return DropdownMenuItem<SupplyChainStage>(
                  value: stage,
                  child: Text(
                    stage.englishLabel,
                    style: TossTextStyles.body,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector(BuildContext context, AnalysisConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Period',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                'From Date',
                config.startDate,
                (date) {
                  if (date != null) {
                    ref.read(analysisConfigProvider.notifier).state = 
                        config.copyWith(startDate: date);
                  }
                },
              ),
            ),
            
            SizedBox(width: TossSpacing.space2),
            
            Expanded(
              child: _buildDateField(
                context,
                'To Date',
                config.endDate,
                (date) {
                  if (date != null) {
                    ref.read(analysisConfigProvider.notifier).state = 
                        config.copyWith(endDate: date);
                  }
                },
              ),
            ),
          ],
        ),
        
        SizedBox(height: TossSpacing.space2),
        
        // Quick date presets
        Wrap(
          spacing: TossSpacing.space2,
          children: [
            _buildDatePreset(context, 'Last 7 Days', 7, config),
            _buildDatePreset(context, 'Last 30 Days', 30, config),
            _buildDatePreset(context, 'Last 90 Days', 90, config),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime selectedDate,
    Function(DateTime?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space1),
        
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            );
            onChanged(picked);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space3,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: TossColors.gray300),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  TossIcons.calendar,
                  color: TossColors.gray600,
                  size: 16,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
                  style: TossTextStyles.body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePreset(BuildContext context, String label, int days, AnalysisConfig config) {
    return GestureDetector(
      onTap: () {
        final now = DateTime.now();
        ref.read(analysisConfigProvider.notifier).state = config.copyWith(
          startDate: now.subtract(Duration(days: days)),
          endDate: now,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProductSelector(BuildContext context, AnalysisConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Selection',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        
        // All Products vs Specific Products Toggle
        Row(
          children: [
            Expanded(
              child: _buildSelectionOption(
                context,
                'All Products',
                'Analyze entire inventory',
                TossIcons.checkCircle,
                config.includeAllProducts,
                () {
                  ref.read(analysisConfigProvider.notifier).state = 
                      config.copyWith(includeAllProducts: true, selectedProductIds: []);
                },
              ),
            ),
            
            SizedBox(width: TossSpacing.space2),
            
            Expanded(
              child: _buildSelectionOption(
                context,
                'Specific Products',
                '${config.selectedProductIds.length} selected',
                TossIcons.check,
                !config.includeAllProducts,
                () {
                  ref.read(analysisConfigProvider.notifier).state = 
                      config.copyWith(includeAllProducts: false);
                  _showProductPicker(context, config);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: isSelected 
              ? TossColors.primary.withValues(alpha: 0.1)
              : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? TossColors.primary : TossColors.gray600,
                  size: 20,
                ),
                Spacer(),
                if (isSelected)
                  Icon(
                    TossIcons.checkCircle,
                    color: TossColors.primary,
                    size: 16,
                  ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? TossColors.primary : TossColors.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: TossSpacing.space1),
            
            Text(
              subtitle,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAnalysisButton(BuildContext context, AnalysisConfig config) {
    final isValid = _validateConfig(config);
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Analysis Summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analysis Summary',
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
          
          SizedBox(height: TossSpacing.space3),
          
          // Execute Analysis Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isValid ? () => _executeAnalysis(context, config) : null,
              icon: Icon(
                TossIcons.forward,
                color: TossColors.white,
                size: TossSpacing.iconSM,
              ),
              label: Text(
                'Run Vertical Analysis',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid ? TossColors.primary : TossColors.gray400,
                padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                elevation: 0,
              ),
            ),
          ),
          
          if (!isValid)
            Padding(
              padding: EdgeInsets.only(top: TossSpacing.space2),
              child: Text(
                _getValidationError(config),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  void _showProductPicker(BuildContext context, AnalysisConfig config) {
    // TODO: Replace with actual product loading from inventory service
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Title header
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Select Products',
                style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            // Search bar
            Container(
              margin: EdgeInsets.all(TossSpacing.space4),
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                children: [
                  Icon(TossIcons.search, color: TossColors.gray600, size: TossSpacing.iconSM),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        border: InputBorder.none,
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      style: TossTextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
            
            // Product list - TODO: Replace with actual product data
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      TossIcons.business,
                      size: 64,
                      color: TossColors.gray400,
                    ),
                    SizedBox(height: TossSpacing.space3),
                    Text(
                      'Product selection not implemented',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    Text(
                      'Connect to inventory service to load products',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Done button
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: TossTextStyles.button.copyWith(
                      color: TossColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _executeAnalysis(BuildContext context, AnalysisConfig config) {
    widget.onAnalysisRequested?.call(config);
    
    // Show analysis started feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Text('Running vertical analysis...'),
          ],
        ),
        backgroundColor: TossColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _validateConfig(AnalysisConfig config) {
    // Check if end date is after start date
    if (config.endDate.isBefore(config.startDate)) return false;
    
    // Check if specific products selected when needed
    if (!config.includeAllProducts && config.selectedProductIds.isEmpty) return false;
    
    return true;
  }

  String _getValidationError(AnalysisConfig config) {
    if (config.endDate.isBefore(config.startDate)) {
      return 'End date must be after start date';
    }
    
    if (!config.includeAllProducts && config.selectedProductIds.isEmpty) {
      return 'Please select at least one product';
    }
    
    return '';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

}