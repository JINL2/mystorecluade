import 'package:flutter/material.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';

/// Filter bottom sheet for Cash Ending page
/// FROM PRODUCTION LINES 4727-4823
class FilterBottomSheet {
  
  /// Show filter bottom sheet
  /// FROM PRODUCTION LINES 4727-4792
  static void showFilterBottomSheet({
    required BuildContext context,
    required String selectedFilter,
    required Function(String) onFilterSelected,
  }) {
    // Filters for Real tab only (Journal removed)
    List<String> filterOptions = ['All', 'Today', 'Yesterday', 'Last Week', 'Last Month'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Filter options
              ...filterOptions.map((option) => 
                _buildFilterOption(
                  title: option,
                  isSelected: selectedFilter == option,
                  onTap: () {
                    onFilterSelected(option);
                    Navigator.pop(context);
                  },
                )
              ),
              
              // Bottom safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        );
      },
    );
  }
  
  /// Build filter option widget
  /// FROM PRODUCTION LINES 4794-4823
  static Widget _buildFilterOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: TossColors.primary,
                size: 28,
                weight: 900,
              ),
          ],
        ),
      ),
    );
  }
}