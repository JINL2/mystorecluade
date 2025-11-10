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
  String _selectedTab = 'Real'; // 'Journal' or 'Real'

  Widget _buildTabButton(String tab) {
    final isSelected = _selectedTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Text(
          tab,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: isSelected ? TossColors.white : TossColors.gray600,
          ),
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
              // Header with Journal/Real Tabs
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabButton('Journal'),
                    const SizedBox(width: TossSpacing.space2),
                    _buildTabButton('Real'),
                  ],
                ),
              ),
              // Content Area
              Expanded(
                child: _selectedTab == 'Journal'
                    ? _buildJournalContent()
                    : _buildRealContent(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJournalContent() {
    // TODO: Implement journal flow display when journal data is available
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 48,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Journal entries coming soon',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Theoretical balance calculations will be displayed here',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealContent() {
    if (widget.isLoading && widget.actualFlows.isEmpty) {
      return const Center(child: TossLoadingView());
    }

    if (widget.actualFlows.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No real data available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ),
      );
    }

    return _buildFlowList();
  }

  Widget _buildFlowList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
      itemCount: widget.actualFlows.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Load More button at the end
        if (index >= widget.actualFlows.length) {
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

        final flow = widget.actualFlows[index];
        final showDate = index == 0 ||
            flow.getFormattedDate() !=
                widget.actualFlows[index - 1].getFormattedDate();

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
