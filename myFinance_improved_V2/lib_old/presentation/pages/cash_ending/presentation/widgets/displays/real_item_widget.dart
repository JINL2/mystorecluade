import 'package:flutter/material.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../data/services/stock_flow_service.dart';

/// Real item builder widget for Cash Ending page
/// FROM PRODUCTION LINES 5091-5225
class RealItemWidget extends StatelessWidget {
  final ActualFlow flow;
  final bool showDate;
  final LocationSummary? locationSummary;
  final Map<String, dynamic> Function() getBaseCurrency;
  final String Function(double amount, String symbol) formatBalance;
  final TabController tabController;
  final Function(ActualFlow flow, {String locationType}) showRealDetailBottomSheet;

  const RealItemWidget({
    Key? key,
    required this.flow,
    required this.showDate,
    required this.locationSummary,
    required this.getBaseCurrency,
    required this.formatBalance,
    required this.tabController,
    required this.showRealDetailBottomSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use base currency symbol from location summary for consistency
    // Note: Amounts are still in original currency values, not converted
    final currencySymbol = locationSummary?.baseCurrencySymbol ?? 
                          getBaseCurrency()['symbol'] ?? 
                          flow.currency.symbol;
    
    return GestureDetector(
      onTap: () {
        // Determine location type based on current tab
        String locationType = 'cash';
        if (tabController.index == 1) {
          locationType = 'bank';
        } else if (tabController.index == 2) {
          locationType = 'vault';
        }
        showRealDetailBottomSheet(flow, locationType: locationType);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: TossSpacing.space4,
          right: TossSpacing.space4,
          top: TossSpacing.space3,
          bottom: TossSpacing.space3,
        ),
        child: Row(
          children: [
          // Date section
          Container(
            width: 42,
            padding: EdgeInsets.only(left: TossSpacing.space1),
            child: showDate
                ? Text(
                    flow.getFormattedDate(),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          
          SizedBox(width: TossSpacing.space3),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash Count',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: TossColors.black87,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        flow.createdBy.fullName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 13,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (flow.getFormattedTime().isNotEmpty) ...[
                      Text(
                        ' • ',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        flow.getFormattedTime(),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: TossSpacing.space2),
          
          // Flow amount and balance after
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Flow amount (the transaction amount) - blue for positive, black for negative
              Text(
                formatBalance(flow.flowAmount, currencySymbol),
                style: TossTextStyles.body.copyWith(
                  color: flow.flowAmount >= 0 
                      ? TossColors.primary 
                      : TossColors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4),
              // Balance after in gray
              Text(
                formatBalance(flow.balanceAfter, currencySymbol),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}