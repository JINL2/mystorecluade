// lib/features/cash_ending/presentation/widgets/real_section_widget.dart

import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_shadows.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../domain/entities/stock_flow.dart';
import 'real_item_widget.dart';

/// Widget for displaying the Real section with stock flow data
class RealSectionWidget extends StatefulWidget {
  final List<ActualFlow> actualFlows;
  final LocationSummary? locationSummary;
  final bool isLoading;
  final bool hasMore;
  final String baseCurrencySymbol;
  final VoidCallback onLoadMore;
  final void Function(ActualFlow) onItemTap;

  const RealSectionWidget({
    super.key,
    required this.actualFlows,
    required this.locationSummary,
    required this.isLoading,
    required this.hasMore,
    required this.baseCurrencySymbol,
    required this.onLoadMore,
    required this.onItemTap,
  });

  @override
  State<RealSectionWidget> createState() => _RealSectionWidgetState();
}

class _RealSectionWidgetState extends State<RealSectionWidget> {
  String _selectedFilter = 'All';

  /// Filter flows based on selected filter
  List<ActualFlow> get _filteredFlows {
    if (_selectedFilter == 'All') {
      return widget.actualFlows;
    }
    // Add other filters if needed (Cash, Bank, Vault)
    return widget.actualFlows;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.lg),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: TossSpacing.space4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('All'),
              _buildFilterOption('Cash'),
              _buildFilterOption('Bank'),
              _buildFilterOption('Vault'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String filter) {
    final isSelected = _selectedFilter == filter;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              filter,
              style: TossTextStyles.body.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? TossColors.primary : TossColors.gray900,
              ),
            ),
            if (isSelected)
              const Icon(
                TossIcons.check,
                color: TossColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: TossSpacing.space5),
        // Real Section Card
        Container(
          height: 400, // Fixed height matching lib_old
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.card,
          ),
          child: Column(
            children: [
              // Header
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space5,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: TossColors.gray200,
                      width: 1,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Real',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: TossColors.black87,
                    ),
                  ),
                ),
              ),
              // Filter Header
              Container(
                padding: const EdgeInsets.only(
                  left: TossSpacing.space5,
                  right: TossSpacing.space4,
                  top: TossSpacing.space5,
                  bottom: TossSpacing.space3,
                ),
                child: GestureDetector(
                  onTap: _showFilterBottomSheet,
                  child: Row(
                    children: [
                      Text(
                        _selectedFilter,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: TossColors.gray600,
                      ),
                    ],
                  ),
                ),
              ),
              // Content Area
              Expanded(
                child: widget.isLoading && widget.actualFlows.isEmpty
                    ? const Center(child: TossLoadingView())
                    : _filteredFlows.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(TossSpacing.space5),
                            child: Center(
                              child: Text(
                                'No real data available',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                            ),
                          )
                        : _buildFlowList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlowList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
      itemCount: _filteredFlows.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Load More button at the end
        if (index >= _filteredFlows.length) {
          return InkWell(
            onTap: widget.onLoadMore,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: TossSpacing.space4,
              ),
              child: Center(
                child: Text(
                  'Load More',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }

        final flow = _filteredFlows[index];
        final showDate = index == 0 ||
            flow.getFormattedDate() !=
                _filteredFlows[index - 1].getFormattedDate();

        return RealItemWidget(
          flow: flow,
          showDate: showDate,
          locationSummary: widget.locationSummary,
          baseCurrencySymbol: widget.baseCurrencySymbol,
          onTap: () => widget.onItemTap(flow),
        );
      },
    );
  }
}
