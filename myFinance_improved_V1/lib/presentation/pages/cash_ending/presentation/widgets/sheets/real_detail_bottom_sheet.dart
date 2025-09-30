import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../data/services/stock_flow_service.dart';

/// Real detail bottom sheet for Cash Ending page
/// FROM PRODUCTION LINES 5358-5782
class RealDetailBottomSheet {
  
  /// Show real detail bottom sheet
  /// FROM PRODUCTION LINES 5358-5782
  static void showRealDetailBottomSheet({
    required BuildContext context,
    required ActualFlow flow,
    required LocationSummary? locationSummary,
    required Map<String, dynamic> Function() getBaseCurrency,
    required String Function(double amount, String symbol) formatBalance,
    required String Function(double amount, String symbol) formatTransactionAmount,
    required String Function(double amount, String symbol) formatCurrency,
    String locationType = 'cash',
  }) {
    // Use base currency symbol from location summary for consistency
    // Note: Amounts are still in original currency values, not converted
    final String currencySymbol = locationSummary?.baseCurrencySymbol ?? 
                          (getBaseCurrency()['symbol'] as String?) ?? 
                          flow.currency.symbol;
    
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Get screen dimensions and determine if it's a small device
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallDevice = screenHeight < 700 || screenWidth < 380; // iPhone SE, iPhone 8, etc.
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;
        
        // Calculate responsive max height based on device size
        final maxHeightRatio = isSmallDevice ? 0.80 : 0.90; // Reduced for small devices
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: (screenHeight * maxHeightRatio) - bottomInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max, // Changed to max for proper scrolling
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isSmallDevice ? 20 : 24,
                  isSmallDevice ? 16 : 20,
                  16,
                  isSmallDevice ? 12 : 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        isSmallDevice ? 'Cash Details' : 'Cash Count Details',
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: isSmallDevice ? 18 : 20,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24, color: TossColors.gray500),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallDevice ? 16 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Balance Section
                      Container(
                        padding: EdgeInsets.all(isSmallDevice ? 16 : 20),
                        decoration: BoxDecoration(
                          color: TossColors.infoLight,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Balance',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray700,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      formatBalance(flow.balanceAfter, currencySymbol),
                                      style: TossTextStyles.h1.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: TossColors.primary,
                                        fontSize: isSmallDevice ? 24 : 32,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(isSmallDevice ? 6 : 8),
                                  decoration: BoxDecoration(
                                    color: TossColors.white,
                                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                  ),
                                  child: Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: TossColors.primary,
                                    size: isSmallDevice ? 20 : 24,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Previous Balance',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatBalance(flow.balanceBefore, currencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: TossColors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Change',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatTransactionAmount(flow.flowAmount, currencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: flow.flowAmount >= 0 ? TossColors.primary : TossColors.black87,
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
                      
                      SizedBox(height: isSmallDevice ? 16 : 24),
                      
                      // Denomination Breakdown Section (only show for cash and vault, not for bank)
                      if (flow.currentDenominations.isNotEmpty && locationType != 'bank') ...[
                        Text(
                          isSmallDevice ? 'Denominations' : 'Denomination Breakdown',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: isSmallDevice ? 15 : 17,
                            color: TossColors.black87,
                          ),
                        ),
                        SizedBox(height: isSmallDevice ? 12 : 16),
                        
                        // Denomination cards
                        ...flow.currentDenominations.map((denomination) {
                          final subtotal = denomination.denominationValue * denomination.currentQuantity;
                          // Use denomination's own currency symbol if available, otherwise use flow's currency
                          final String denomCurrencySymbol = denomination.currencySymbol ?? currencySymbol;
                          return Container(
                            margin: EdgeInsets.only(bottom: isSmallDevice ? 12 : 16),
                            decoration: BoxDecoration(
                              color: TossColors.white,
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              border: Border.all(color: TossColors.gray200),
                              boxShadow: [
                                BoxShadow(
                                  color: TossColors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Denomination header
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallDevice ? 12 : 16,
                                    vertical: isSmallDevice ? 10 : 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TossColors.gray50,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatCurrency(denomination.denominationValue, denomCurrencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: TossColors.primary,
                                          fontSize: isSmallDevice ? 14 : 16,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: TossColors.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                        ),
                                        child: Text(
                                          denomination.denominationType.toUpperCase(),
                                          style: TossTextStyles.caption.copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: TossColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Quantity details
                                Padding(
                                  padding: EdgeInsets.all(isSmallDevice ? 12 : 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Previous Qty',
                                                  style: TossTextStyles.caption.copyWith(
                                                    color: TossColors.gray600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${denomination.previousQuantity}',
                                                  style: TossTextStyles.body.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Change',
                                                  style: TossTextStyles.caption.copyWith(
                                                    color: TossColors.gray600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${denomination.quantityChange > 0 ? "+" : ""}${denomination.quantityChange}',
                                                  style: TossTextStyles.body.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: denomination.quantityChange > 0 
                                                        ? TossColors.success 
                                                        : denomination.quantityChange < 0 
                                                            ? TossColors.error 
                                                            : TossColors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Current Qty',
                                                  style: TossTextStyles.caption.copyWith(
                                                    color: TossColors.gray600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${denomination.currentQuantity}',
                                                  style: TossTextStyles.body.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: TossSpacing.space4),
                                      const Divider(color: TossColors.gray200, thickness: 1),
                                      const SizedBox(height: TossSpacing.space3),
                                      
                                      // Subtotal
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Subtotal',
                                            style: TossTextStyles.body.copyWith(
                                              color: TossColors.gray700,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            formatCurrency(subtotal, denomCurrencySymbol),
                                            style: TossTextStyles.body.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: TossColors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      
                      SizedBox(height: isSmallDevice ? 16 : 24),
                      
                      // Footer information
                      Container(
                        padding: EdgeInsets.all(isSmallDevice ? 12 : 16),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow('Counted By', flow.createdBy.fullName),
                            const SizedBox(height: TossSpacing.space3),
                            _buildInfoRow('Date', DateFormat('MMM d, yyyy').format(DateTime.parse(flow.createdAt))),
                            const SizedBox(height: TossSpacing.space3),
                            _buildInfoRow('Time', flow.getFormattedTime()),
                          ],
                        ),
                      ),
                      
                      // Bottom spacing for safe area
                      SizedBox(height: safeAreaBottom + 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Build info row widget - matches production layout
  static Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: TossColors.black87,
          ),
        ),
      ],
    );
  }
}