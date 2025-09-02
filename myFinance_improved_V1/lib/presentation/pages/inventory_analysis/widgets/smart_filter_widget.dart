import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/supply_chain_models.dart';

// Filter state provider
final filtersProvider = StateProvider<SupplyChainFilters>((ref) {
  return SupplyChainFilters(
    timeRange: DateRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
      koreanLabel: 'Last 7 Days',
    ),
    storeIds: [],
    productCategories: [],
    supplierIds: [],
    severityLevels: ProblemSeverity.values,
    stages: SupplyChainStage.values,
  );
});

// Filter presets
class FilterPreset {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final SupplyChainFilters filters;

  const FilterPreset({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.filters,
  });
}

final filterPresetsProvider = Provider<List<FilterPreset>>((ref) {
  final now = DateTime.now();
  
  return [
    FilterPreset(
      name: 'Critical Issues',
      description: 'Show only urgent problems requiring immediate action',
      icon: Icons.error,
      color: TossColors.error,
      filters: SupplyChainFilters(
        timeRange: DateRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
          koreanLabel: 'Last 7 Days',
        ),
        storeIds: [],
        productCategories: [],
        supplierIds: [],
        severityLevels: [ProblemSeverity.critical],
        stages: SupplyChainStage.values,
      ),
    ),
    
    FilterPreset(
      name: 'Order Delays',
      description: 'Focus on Order→Ship stage bottlenecks',
      icon: Icons.local_shipping,
      color: TossColors.primary,
      filters: SupplyChainFilters(
        timeRange: DateRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
          koreanLabel: 'Last 30 Days',
        ),
        storeIds: [],
        productCategories: [],
        supplierIds: [],
        severityLevels: [ProblemSeverity.critical, ProblemSeverity.warning],
        stages: [SupplyChainStage.order],
      ),
    ),
    
    FilterPreset(
      name: 'Inventory Issues',
      description: 'Receive→Sale stage problems affecting sales',
      icon: Icons.inventory,
      color: TossColors.success,
      filters: SupplyChainFilters(
        timeRange: DateRange(
          start: now.subtract(const Duration(days: 14)),
          end: now,
          koreanLabel: 'Last 14 Days',
        ),
        storeIds: [],
        productCategories: [],
        supplierIds: [],
        severityLevels: [ProblemSeverity.critical, ProblemSeverity.warning],
        stages: [SupplyChainStage.sell],
      ),
    ),
    
    FilterPreset(
      name: 'High Value',
      description: 'Problems with significant financial impact',
      icon: Icons.attach_money,
      color: TossColors.warning,
      filters: SupplyChainFilters(
        timeRange: DateRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
          koreanLabel: 'Last 30 Days',
        ),
        storeIds: [],
        productCategories: [],
        supplierIds: [],
        severityLevels: ProblemSeverity.values,
        stages: SupplyChainStage.values,
      ),
    ),
    
    FilterPreset(
      name: 'All Active',
      description: 'Show all current problems across all stages',
      icon: Icons.view_list,
      color: TossColors.info,
      filters: SupplyChainFilters(
        timeRange: DateRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
          koreanLabel: 'Last 7 Days',
        ),
        storeIds: [],
        productCategories: [],
        supplierIds: [],
        severityLevels: ProblemSeverity.values,
        stages: SupplyChainStage.values,
      ),
    ),
  ];
});

class SmartFilterWidget extends ConsumerStatefulWidget {
  final bool isMobile;
  final VoidCallback? onFiltersChanged;

  const SmartFilterWidget({
    super.key,
    this.isMobile = false,
    this.onFiltersChanged,
  });

  @override
  ConsumerState<SmartFilterWidget> createState() => _SmartFilterWidgetState();
}

class _SmartFilterWidgetState extends ConsumerState<SmartFilterWidget> {
  @override
  Widget build(BuildContext context) {
    final currentFilters = ref.watch(filtersProvider);
    final presets = ref.watch(filterPresetsProvider);
    
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
          _buildHeader(context, currentFilters),
          _buildPresets(context, presets),
          if (currentFilters.hasActiveFilters)
            _buildActiveFilters(context, currentFilters),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SupplyChainFilters currentFilters) {
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
              color: TossColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              Icons.filter_list,
              color: TossColors.info,
              size: 20,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Filters',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentFilters.hasActiveFilters 
                      ? 'Custom filters applied'
                      : 'Quick filter presets',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          // Clear filters button
          if (currentFilters.hasActiveFilters)
            TextButton(
              onPressed: () {
                _clearAllFilters();
              },
              child: Text(
                'Clear All',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          // Advanced filters button
          IconButton(
            onPressed: () {
              _showAdvancedFilters(context);
            },
            icon: Icon(
              Icons.tune,
              color: TossColors.gray600,
              size: 20,
            ),
            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildPresets(BuildContext context, List<FilterPreset> presets) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: widget.isMobile 
          ? _buildMobilePresets(context, presets)
          : _buildDesktopPresets(context, presets),
    );
  }

  Widget _buildDesktopPresets(BuildContext context, List<FilterPreset> presets) {
    return Wrap(
      spacing: TossSpacing.space2,
      runSpacing: TossSpacing.space2,
      children: presets.map((preset) {
        return _buildPresetChip(context, preset);
      }).toList(),
    );
  }

  Widget _buildMobilePresets(BuildContext context, List<FilterPreset> presets) {
    return Column(
      children: presets.map((preset) {
        return Container(
          margin: EdgeInsets.only(bottom: TossSpacing.space2),
          child: _buildMobilePresetCard(context, preset),
        );
      }).toList(),
    );
  }

  Widget _buildPresetChip(BuildContext context, FilterPreset preset) {
    return InkWell(
      onTap: () {
        _applyPreset(preset);
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: preset.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: preset.color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              preset.icon,
              color: preset.color,
              size: 16,
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              preset.name,
              style: TossTextStyles.caption.copyWith(
                color: preset.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilePresetCard(BuildContext context, FilterPreset preset) {
    return InkWell(
      onTap: () {
        _applyPreset(preset);
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: preset.color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: preset.color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: preset.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Icon(
                preset.icon,
                color: preset.color,
                size: 20,
              ),
            ),
            
            SizedBox(width: TossSpacing.space3),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preset.name,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    preset.description,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters(BuildContext context, SupplyChainFilters filters) {
    final activeFilterChips = <Widget>[];
    
    // Time range chip
    activeFilterChips.add(_buildActiveFilterChip(
      context,
      'Time: ${filters.timeRange.englishLabel}',
      Icons.date_range,
      () => _clearTimeRangeFilter(),
    ));
    
    // Severity chips
    if (filters.severityLevels.length < ProblemSeverity.values.length) {
      for (final severity in filters.severityLevels) {
        activeFilterChips.add(_buildActiveFilterChip(
          context,
          _getSeverityEnglishLabel(severity),
          severity.icon,
          () => _removeSeverityFilter(severity),
        ));
      }
    }
    
    // Stage chips
    if (filters.stages.length < SupplyChainStage.values.length) {
      for (final stage in filters.stages) {
        activeFilterChips.add(_buildActiveFilterChip(
          context,
          _getStageEnglishLabel(stage),
          Icons.timeline,
          () => _removeStageFilter(stage),
        ));
      }
    }
    
    if (activeFilterChips.isEmpty) return const SizedBox.shrink();
    
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Filters',
            style: TossTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray700,
            ),
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: activeFilterChips,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onRemove,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: TossColors.primary,
            size: 14,
          ),
          SizedBox(width: TossSpacing.space1),
          Text(
            label,
            style: TossTextStyles.small.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: TossSpacing.space1),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              color: TossColors.primary,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _applyPreset(FilterPreset preset) {
    ref.read(filtersProvider.notifier).state = preset.filters;
    widget.onFiltersChanged?.call();
  }

  void _clearAllFilters() {
    final now = DateTime.now();
    ref.read(filtersProvider.notifier).state = SupplyChainFilters(
      timeRange: DateRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
        koreanLabel: 'Last 7 Days',
      ),
      storeIds: [],
      productCategories: [],
      supplierIds: [],
      severityLevels: ProblemSeverity.values,
      stages: SupplyChainStage.values,
    );
    widget.onFiltersChanged?.call();
  }

  void _clearTimeRangeFilter() {
    final now = DateTime.now();
    final currentFilters = ref.read(filtersProvider);
    ref.read(filtersProvider.notifier).state = currentFilters.copyWith(
      timeRange: DateRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
        koreanLabel: 'Last 7 Days',
      ),
    );
    widget.onFiltersChanged?.call();
  }

  void _removeSeverityFilter(ProblemSeverity severity) {
    final currentFilters = ref.read(filtersProvider);
    final newSeverityLevels = List<ProblemSeverity>.from(currentFilters.severityLevels)
      ..remove(severity);
    
    if (newSeverityLevels.isEmpty) {
      newSeverityLevels.addAll(ProblemSeverity.values);
    }
    
    ref.read(filtersProvider.notifier).state = currentFilters.copyWith(
      severityLevels: newSeverityLevels,
    );
    widget.onFiltersChanged?.call();
  }

  void _removeStageFilter(SupplyChainStage stage) {
    final currentFilters = ref.read(filtersProvider);
    final newStages = List<SupplyChainStage>.from(currentFilters.stages)
      ..remove(stage);
    
    if (newStages.isEmpty) {
      newStages.addAll(SupplyChainStage.values);
    }
    
    ref.read(filtersProvider.notifier).state = currentFilters.copyWith(
      stages: newStages,
    );
    widget.onFiltersChanged?.call();
  }

  void _showAdvancedFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildAdvancedFiltersSheet(context),
    );
  }

  Widget _buildAdvancedFiltersSheet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Advanced Filters',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: TossColors.gray600),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeRangeSelector(context),
                  SizedBox(height: TossSpacing.space4),
                  _buildSeveritySelector(context),
                  SizedBox(height: TossSpacing.space4),
                  _buildStageSelector(context),
                ],
              ),
            ),
          ),
          
          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onFiltersChanged?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TossTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context) {
    final timeRangeOptions = [
      ('Last 7 Days', 7),
      ('Last 30 Days', 30),
      ('Last 90 Days', 90),
      ('Last Year', 365),
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Range',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          children: timeRangeOptions.map((option) {
            return FilterChip(
              label: Text(option.$1),
              selected: false, // Would check against current filter
              onSelected: (selected) {
                _applyTimeRangeFilter(option.$1, option.$2);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSeveritySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Problem Severity',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          children: ProblemSeverity.values.map((severity) {
            final currentFilters = ref.read(filtersProvider);
            final isSelected = currentFilters.severityLevels.contains(severity);
            
            return FilterChip(
              label: Text(_getSeverityEnglishLabel(severity)),
              selected: isSelected,
              selectedColor: severity.color.withValues(alpha: 0.2),
              onSelected: (selected) {
                _toggleSeverityFilter(severity, selected);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStageSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supply Chain Stages',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          children: SupplyChainStage.values.map((stage) {
            final currentFilters = ref.read(filtersProvider);
            final isSelected = currentFilters.stages.contains(stage);
            
            return FilterChip(
              label: Text(_getStageEnglishLabel(stage)),
              selected: isSelected,
              onSelected: (selected) {
                _toggleStageFilter(stage, selected);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _applyTimeRangeFilter(String label, int days) {
    final now = DateTime.now();
    final currentFilters = ref.read(filtersProvider);
    ref.read(filtersProvider.notifier).state = currentFilters.copyWith(
      timeRange: DateRange(
        start: now.subtract(Duration(days: days)),
        end: now,
        koreanLabel: label,
      ),
    );
  }

  void _toggleSeverityFilter(ProblemSeverity severity, bool selected) {
    final currentFilters = ref.read(filtersProvider);
    final severityLevels = List<ProblemSeverity>.from(currentFilters.severityLevels);
    
    if (selected) {
      severityLevels.add(severity);
    } else {
      severityLevels.remove(severity);
    }
    
    ref.read(filtersProvider.notifier).state = currentFilters.copyWith(
      severityLevels: severityLevels,
    );
  }

  void _toggleStageFilter(SupplyChainStage stage, bool selected) {
    final currentFilters = ref.read(filtersProvider);
    final stages = List<SupplyChainStage>.from(currentFilters.stages);
    
    if (selected) {
      stages.add(stage);
    } else {
      stages.remove(stage);
    }
    
    ref.read(filtersProvider.notifier).state = currentFilters.copyWith(
      stages: stages,
    );
  }

  String _getSeverityEnglishLabel(ProblemSeverity severity) {
    switch (severity) {
      case ProblemSeverity.critical:
        return 'Critical';
      case ProblemSeverity.warning:
        return 'Warning';
      case ProblemSeverity.normal:
        return 'Normal';
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