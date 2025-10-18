import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../../../core/constants/ui_constants.dart';

/// Currency selector bottom sheet for Cash Ending page
class CurrencySelectorSheet {
  
  /// Show currency selector bottom sheet
  static void showCurrencySelector({
    required BuildContext context,
    required List<Map<String, dynamic>> companyCurrencies,
    required String? selectedCurrencyId,
    required Function(String currencyId) onCurrencySelected,
    required String tabType,
    Function(String)? currencyHasData,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: _CurrencySelectorContent(
          companyCurrencies: companyCurrencies,
          selectedCurrencyId: selectedCurrencyId,
          onCurrencySelected: onCurrencySelected,
          tabType: tabType,
          currencyHasData: currencyHasData,
        ),
      ),
    );
  }
}

class _CurrencySelectorContent extends StatelessWidget {
  final List<Map<String, dynamic>> companyCurrencies;
  final String? selectedCurrencyId;
  final Function(String currencyId) onCurrencySelected;
  final String tabType;
  final Function(String)? currencyHasData;

  const _CurrencySelectorContent({
    required this.companyCurrencies,
    required this.selectedCurrencyId,
    required this.onCurrencySelected,
    required this.tabType,
    this.currencyHasData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.only(top: TossSpacing.space3),
          width: UIConstants.modalDragHandleWidth,
          height: UIConstants.modalDragHandleHeight,
          decoration: BoxDecoration(
            color: TossColors.gray600,
            borderRadius: BorderRadius.circular(TossBorderRadius.full),
          ),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Row(
            children: [
              Text(
                'Select Currency',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
          
        // Currency list
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: companyCurrencies.length,
            itemBuilder: (context, index) {
              final currency = companyCurrencies[index];
              final currencyId = currency['currency_id']?.toString() ?? '';
              var symbol = (currency['symbol'] as String?) ?? '';
              final currencyCode = (currency['currency_code'] as String?) ?? 'N/A';
              
              // Fix VND symbol if corrupted
              if (currencyCode == 'VND' && (symbol == 'd' || symbol == 'đ' || symbol.isEmpty)) {
                symbol = '₫';
              }
              
              final isSelected = selectedCurrencyId == currencyId;
              final bool hasData = (currencyId.isNotEmpty && currencyHasData != null) 
                  ? (currencyHasData!(currencyId) == true) 
                  : false;
              
              return InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(context);
                  onCurrencySelected(currencyId);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space5,
                    vertical: TossSpacing.space4,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: TossColors.gray100,
                        width: index == companyCurrencies.length - 1 ? 0 : 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Center(
                          child: Text(
                            symbol,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? TossColors.primary : TossColors.gray500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  currencyCode,
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                                if (hasData) ...[
                                  const SizedBox(width: TossSpacing.space2),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: TossColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: TossSpacing.space1),
                                  Text(
                                    'has data',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              _getCurrencyName(currencyCode),
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check,
                          size: 20,
                          color: TossColors.primary,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Bottom padding for safe area
        SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
      ],
    );
  }
  
  String _getCurrencyName(String code) {
    switch (code) {
      case 'VND':
        return 'Vietnamese Dong';
      case 'USD':
        return 'US Dollar';
      case 'EUR':
        return 'Euro';
      case 'JPY':
        return 'Japanese Yen';
      case 'KRW':
        return 'Korean Won';
      default:
        return code;
    }
  }
}