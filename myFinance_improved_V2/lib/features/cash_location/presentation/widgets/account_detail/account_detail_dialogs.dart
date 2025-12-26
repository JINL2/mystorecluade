import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_confirm_cancel_dialog.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';

import '../sheets/auto_mapping_sheet.dart';
import '../sheets/filter_bottom_sheet.dart';

/// Helper class for showing dialogs and bottom sheets in AccountDetailPage
class AccountDetailDialogs {
  final BuildContext context;

  AccountDetailDialogs(this.context);

  /// Show processing dialog with loading indicator
  void showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TossLoadingView(),
                  SizedBox(height: TossSpacing.space4),
                  Text(
                    'Processing...',
                    style: TossTextStyles.body.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Close any open dialog
  void closeDialog() {
    Navigator.pop(context);
  }

  /// Show success dialog
  void showSuccessDialog({bool isError = false}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TossDialog.success(
          title: 'Success',
          message: isError
              ? 'Error adjustment has been recorded successfully.'
              : 'Foreign currency translation has been recorded successfully.',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => Navigator.pop(context),
        );
      },
    );
  }

  /// Show error dialog
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TossDialog.error(
          title: 'Error',
          message: message,
          primaryButtonText: 'OK',
          onPrimaryPressed: () => Navigator.pop(context),
        );
      },
    );
  }

  /// Show mapping confirmation dialog
  Future<bool> showMappingConfirmationDialog({
    required String mappingType,
    required double errorAmount,
    required String currencySymbol,
    required String Function(double, [String?]) formatCurrencyWithSign,
  }) async {
    // Custom content for Difference Amount
    final customContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Difference Amount label
        Text(
          'Difference Amount',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
            fontSize: 14,
          ),
        ),

        SizedBox(height: TossSpacing.space2),

        // Difference amount value
        Text(
          formatCurrencyWithSign(errorAmount, currencySymbol),
          style: TossTextStyles.h3.copyWith(
            color: TossColors.error,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ],
    );

    // Show confirm/cancel dialog using TossConfirmCancelDialog
    final confirmed = await TossConfirmCancelDialog.show(
      context: context,
      title: 'Auto Mapping',
      message: 'Do you want to make\n$mappingType?',
      confirmButtonText: 'OK',
      cancelButtonText: 'Cancel',
      customContent: customContent,
      barrierDismissible: true,
    );

    return confirmed == true;
  }

  /// Show filter bottom sheet
  void showFilterBottomSheet({
    required int selectedTab,
    required String selectedFilter,
    required void Function(String) onFilterSelected,
  }) {
    // Different filters based on tab
    List<String> filterOptions;
    if (selectedTab == 0) {
      // Journal tab filters
      filterOptions = [
        'All',
        'Money In',
        'Money Out',
        'Today',
        'Yesterday',
        'Last Week'
      ];
    } else {
      // Real tab filters
      filterOptions = ['All', 'Today', 'Yesterday', 'Last Week', 'Last Month'];
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FilterBottomSheet(
          selectedFilter: selectedFilter,
          filterOptions: filterOptions,
          onFilterSelected: onFilterSelected,
        );
      },
    );
  }

  /// Show auto mapping bottom sheet
  void showAutoMappingBottomSheet({
    required void Function(String) onMappingSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AutoMappingSheet(
          onMappingSelected: onMappingSelected,
        );
      },
    );
  }
}
