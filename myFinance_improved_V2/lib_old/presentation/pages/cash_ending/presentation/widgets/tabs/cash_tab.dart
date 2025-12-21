import 'package:flutter/material.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../widgets/toss/toss_card.dart';
import 'animated_tab_mixin.dart';

/// Cash tab component for Cash Ending page with automatic UI transitions
/// Enhanced with smooth animations when cash location is selected
class CashTab extends StatefulWidget {
  final String? selectedStoreId;
  final String? selectedLocationId;
  final List<Map<String, dynamic>> currencyTypes;
  final List<Map<String, dynamic>> companyCurrencies;
  final Map<String, List<Map<String, dynamic>>> currencyDenominations;
  final Widget Function() buildStoreSelector;
  final Widget Function(String) buildLocationSelector;
  final Widget Function({required String tabType}) buildDenominationSection;
  final Widget Function({required String tabType}) buildTotalSection;
  final Widget Function() buildSubmitButton;
  final Widget Function({required bool showSection}) buildRealJournalSection;

  const CashTab({
    super.key,
    required this.selectedStoreId,
    required this.selectedLocationId,
    required this.currencyTypes,
    required this.companyCurrencies,
    required this.currencyDenominations,
    required this.buildStoreSelector,
    required this.buildLocationSelector,
    required this.buildDenominationSection,
    required this.buildTotalSection,
    required this.buildSubmitButton,
    required this.buildRealJournalSection,
  });

  @override
  State<CashTab> createState() => _CashTabState();
}

class _CashTabState extends State<CashTab>
    with TickerProviderStateMixin, AnimatedTabMixin {
  
  @override
  void initState() {
    super.initState();
    // Initialize animations from mixin
    initializeAnimations();
  }
  
  @override
  void didUpdateWidget(CashTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check for location selection changes
    checkLocationChange(oldWidget.selectedLocationId, widget.selectedLocationId);
  }
  
  @override
  void dispose() {
    // Dispose animations from mixin
    disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController, // Use animated scroll controller from mixin
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build the location selection card
          _buildLocationSelectionCard(),
          
          // Build the animated cash counting card (conditional)
          if (widget.selectedLocationId != null) ...[
            const SizedBox(height: TossSpacing.space6),
            wrapWithFullAnimation(_buildCashCountingCard()),
          ],
          
          // Build the animated transaction history section (conditional)
          if (widget.selectedLocationId != null && widget.selectedLocationId!.isNotEmpty)
            buildDelayedAnimation(
              child: _buildTransactionHistorySection(),
              delay: const Duration(milliseconds: 300),
            ),
        ],
      ),
    );
  }

  /// Builds the first card containing store and location selection
  Widget _buildLocationSelectionCard() {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store selector
          widget.buildStoreSelector(),
          
          // Location selector (conditional on store selection)
          if (widget.selectedStoreId != null) ...[
            const SizedBox(height: TossSpacing.space6),
            widget.buildLocationSelector('cash'),
          ],
        ],
      ),
    );
  }

  /// Builds the second card containing cash counting inputs
  Widget _buildCashCountingCard() {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currency selection and denomination inputs
          widget.buildDenominationSection(tabType: 'cash'),
          
          const SizedBox(height: TossSpacing.space8),
          
          // Total display section
          widget.buildTotalSection(tabType: 'cash'),
          
          const SizedBox(height: TossSpacing.space10),
          
          // Submit button
          widget.buildSubmitButton(),
        ],
      ),
    );
  }

  /// Builds the transaction history section
  Widget _buildTransactionHistorySection() {
    return widget.buildRealJournalSection(
      showSection: true,
    );
  }
  
  // Keeping for reference in case needed in the future
  /*
  Widget _buildRecentEndingDetail(Map<String, dynamic> ending) {
    final createdAt = ending['created_at'] != null
        ? DateTime.parse(ending['created_at'].toString())
        : DateTime.now();
    final dateFormat = DateFormat('yyyy.MM.dd');
    final timeFormat = DateFormat('HH:mm:ss');
    final userFullName = ending['user_full_name'] ?? 'Unknown User';
    final currencies = ending['parsed_currencies'] ?? [];
    final denominationData = ending['denomination_data'] ?? {};
    final currencyData = ending['currency_data'] ?? {};
    
    return TossWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(createdAt),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              Text(
                timeFormat.format(createdAt),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          
          // User who edited
          Row(
            children: [
              Icon(
                TossIcons.person,
                size: UIConstants.iconSizeXS,
                color: TossColors.gray500,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Edited by: $userFullName',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          
          // Denomination details
          if (currencies.isNotEmpty) ...[
            // Process each currency
            for (var currency in currencies) ...[
              () {
                final currencyId = currency['currency_id'];
                final denominations = currency['denominations'] ?? [];
                
                
                // Get currency details - first try currencyData, then currencyTypes, then companyCurrencies
                var currencyInfo = currencyData[currencyId];
                
                if (currencyInfo == null || currencyInfo.isEmpty) {
                  // Try to find in currencyTypes (loaded from currency_types table)
                  currencyInfo = widget.currencyTypes.firstWhere(
                    (c) => c['currency_id'] == currencyId,
                    orElse: () => widget.companyCurrencies.firstWhere(
                      (c) => c['currency_id'] == currencyId,
                      orElse: () => {},
                    ),
                  );
                }
                
                // Use the actual currency symbol and code from the data
                final currencySymbol = currencyInfo['symbol'] ?? '';
                final currencyCode = currencyInfo['currency_code'] ?? '';
                
                
                // Calculate total amount
                double totalAmount = 0;
                for (var denom in denominations) {
                  final denominationId = denom['denomination_id'];
                  final quantity = (denom['quantity'] ?? 0) is int 
                      ? (denom['quantity'] ?? 0) as int 
                      : ((denom['quantity'] ?? 0) as num).toInt();
                  
                  // Find denomination value - use the denomination data we loaded
                  final denominationsList = denominationData[currencyId] ?? currencyDenominations[currencyId];
                  if (denominationsList != null) {
                    final denominationInfo = denominationsList.firstWhere(
                      (d) => d['denomination_id'] == denominationId,
                      orElse: () => {'value': 0},
                    );
                    final valueRaw = denominationInfo['value'] ?? 0;
                    final value = valueRaw is int ? valueRaw : (valueRaw as num).toDouble();
                    totalAmount += value * quantity;
                  }
                }
                
                
                // Only display if we have denomination data or if total is 0
                if (totalAmount > 0 || denominations.isNotEmpty) {
                  // Display total
                  return Container(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    margin: const EdgeInsets.only(bottom: TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount ($currencyCode)',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space1),
                        Text(
                          NumberFormat.currency(
                            symbol: currencySymbol,
                            decimalDigits: 0,
                          ).format(totalAmount),
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space3),
                        
                        // Show denomination breakdown
                        if (denominations.isNotEmpty) ...[
                          Text(
                            'Denomination Breakdown',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          // First, prepare and sort denominations by value
                          () {
                            // Create a list of denominations with their values
                            List<Map<String, dynamic>> sortedDenoms = [];
                            for (var denom in denominations) {
                              final denominationId = denom['denomination_id'];
                              final quantity = denom['quantity'] ?? 0;
                              
                              if (quantity > 0) {
                                // Find denomination value
                                final denominationsList = denominationData[currencyId] ?? currencyDenominations[currencyId];
                                var value = 0;
                                if (denominationsList != null) {
                                  final denominationInfo = denominationsList.firstWhere(
                                    (d) => d['denomination_id'] == denominationId,
                                    orElse: () => {'value': 0},
                                  );
                                  final valueRaw = denominationInfo['value'] ?? 0;
                                  value = valueRaw is int ? valueRaw : (valueRaw as num).toInt();
                                }
                                
                                sortedDenoms.add({
                                  'value': value,
                                  'quantity': quantity,
                                  'denominationId': denominationId,
                                });
                              }
                            }
                            
                            // Sort by value in descending order (largest first)
                            sortedDenoms.sort((a, b) {
                              final bValue = b['value'] is int ? b['value'] as int : (b['value'] as num).toInt();
                              final aValue = a['value'] is int ? a['value'] as int : (a['value'] as num).toInt();
                              return bValue.compareTo(aValue);
                            });
                            
                            // Now build the widgets
                            return Column(
                              children: sortedDenoms.map((item) {
                                final value = item['value'] is int 
                                    ? item['value'] as int 
                                    : (item['value'] as num).toInt();
                                final quantity = item['quantity'] is int 
                                    ? item['quantity'] as int 
                                    : (item['quantity'] as num).toInt();
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: TossSpacing.space2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$currencySymbol${NumberFormat('#,###').format(value)}',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray600,
                                        ),
                                      ),
                                      Text(
                                        '× $quantity pcs',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray500,
                                        ),
                                      ),
                                      Text(
                                        '$currencySymbol${NumberFormat('#,###').format(value * quantity)}',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }(),
                        ],
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }(),
            ],
          ],
        ],
      ),
    );
  }
  */

}