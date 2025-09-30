import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../widgets/common/toss_white_card.dart';
import '../../../../../widgets/common/toss_loading_view.dart';
import '../../../../../widgets/toss/toss_primary_button.dart';
import '../../../../../../../core/themes/toss_icons.dart';
import '../../../../../../../core/constants/ui_constants.dart';

/// Transactions bottom sheet for Cash Ending page
/// FROM PRODUCTION LINES 2714-2988
class TransactionsBottomSheet {
  
  /// Show all transactions bottom sheet
  /// FROM PRODUCTION LINES 2714-2842
  static void showAllTransactionsBottomSheet({
    required BuildContext context,
    required List<Map<String, dynamic>> allBankTransactions,
    required bool hasMoreTransactions,
    required bool isLoadingAllTransactions,
    required List<Map<String, dynamic>> bankLocations,
    required List<Map<String, dynamic>> currencyTypes,
    required Future<void> Function({required bool loadMore, required VoidCallback updateUI}) fetchAllBankTransactions,
    required VoidCallback resetTransactionState,
  }) {
    // Reset state before showing bottom sheet
    resetTransactionState();
    
    // Show the bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setBottomSheetState) {
            // Fetch data when bottom sheet is first built
            if (isLoadingAllTransactions && allBankTransactions.isEmpty) {
              Future.microtask(() {
                fetchAllBankTransactions(
                  loadMore: false,
                  updateUI: () => setBottomSheetState(() {}),
                );
              });
            }
            
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(TossBorderRadius.xxl),
                  topRight: Radius.circular(TossBorderRadius.xxl),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: TossSpacing.space3),
                    width: UIConstants.iconSizeHuge,
                    height: UIConstants.modalDragHandleHeight,
                    decoration: BoxDecoration(
                      color: TossColors.gray300,
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                  ),
                  // Header
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Bank Transactions',
                          style: TossTextStyles.h2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.gray900,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(TossIcons.close, color: TossColors.gray700),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: TossColors.gray200, height: 1),
                  // Transaction list
                  Expanded(
                    child: isLoadingAllTransactions && allBankTransactions.isEmpty
                        ? Center(
                            child: TossLoadingView(),
                          )
                        : allBankTransactions.isEmpty && !isLoadingAllTransactions
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      TossIcons.receipt,
                                      color: TossColors.gray400,
                                      size: UIConstants.iconSizeHuge + 16, // 64px for empty state
                                    ),
                                    const SizedBox(height: TossSpacing.space4),
                                    Text(
                                      'No transactions found',
                                      style: TossTextStyles.bodyLarge.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(TossSpacing.space5),
                                itemCount: allBankTransactions.length + (hasMoreTransactions ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == allBankTransactions.length) {
                                    // Load more button
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                                      child: TossPrimaryButton(
                                        text: 'Load More',
                                        onPressed: isLoadingAllTransactions
                                            ? null
                                            : () async {
                                                await fetchAllBankTransactions(
                                                  loadMore: true,
                                                  updateUI: () => setBottomSheetState(() {}),
                                                );
                                              },
                                        isLoading: isLoadingAllTransactions,
                                      ),
                                    );
                                  }
                                  
                                  final transaction = allBankTransactions[index];
                                  return _buildTransactionCard(
                                    transaction: transaction,
                                    bankLocations: bankLocations,
                                    currencyTypes: currencyTypes,
                                  );
                                },
                              ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  /// Build transaction card for bottom sheet
  /// FROM PRODUCTION LINES 2845-2988
  static Widget _buildTransactionCard({
    required Map<String, dynamic> transaction,
    required List<Map<String, dynamic>> bankLocations,
    required List<Map<String, dynamic>> currencyTypes,
  }) {
    // Get location name
    final locationName = bankLocations.firstWhere(
      (loc) => loc['cash_location_id']?.toString() == transaction['location_id']?.toString() ||
               loc['location_id']?.toString() == transaction['location_id']?.toString(),
      orElse: () => {'location_name': 'Unknown'},
    )['location_name'] ?? 'Unknown';
    
    // Get currency info
    final currency = currencyTypes.firstWhere(
      (c) => c['currency_id']?.toString() == transaction['currency_id']?.toString(),
      orElse: () => {'symbol': '', 'currency_code': ''},
    );
    final currencySymbol = currency['symbol'] ?? '';
    final currencyCode = currency['currency_code'] ?? '';
    
    // Parse dates
    final createdAt = DateTime.tryParse(transaction['created_at'] ?? '');
    final recordDate = transaction['record_date'] ?? '';
    final dateStr = recordDate.isNotEmpty ? recordDate : 
                   (createdAt != null ? DateFormat('yyyy-MM-dd').format(createdAt) : 'Unknown');
    final timeStr = createdAt != null ? DateFormat('HH:mm').format(createdAt) : '';
    
    // Get user info
    final userFullName = transaction['user_full_name'] ?? 'Unknown User';
    final amount = transaction['total_amount'] ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: TossWhiteCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Header row with location and amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space2),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Icon(
                        TossIcons.bank,
                        size: UIConstants.iconSizeXS,
                        color: TossColors.primary,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationName,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$dateStr $timeStr',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$currencySymbol${NumberFormat('#,###').format(amount)}',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                    if (currencyCode.isNotEmpty)
                      Text(
                        currencyCode,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            // Divider
            Container(
              height: 1,
              color: TossColors.gray100,
            ),
            const SizedBox(height: TossSpacing.space3),
            // Bottom row with user and record date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      TossIcons.person,
                      size: UIConstants.textSizeRegular,
                      color: TossColors.gray400,
                    ),
                    const SizedBox(width: TossSpacing.space1),
                    Text(
                      userFullName,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      TossIcons.calendar,
                      size: UIConstants.textSizeRegular,
                      color: TossColors.gray400,
                    ),
                    const SizedBox(width: TossSpacing.space1),
                    Text(
                      'Record: $dateStr $timeStr',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}