import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../register_denomination/domain/entities/currency.dart';

/// Currency Selector Bottom Sheet
/// Shows a list of currencies with search functionality
class CurrencySelectorSheet extends StatefulWidget {
  final List<CurrencyType> currencies;
  final String? selectedCurrencyId;
  final void Function(CurrencyType) onCurrencySelected;

  const CurrencySelectorSheet({
    super.key,
    required this.currencies,
    this.selectedCurrencyId,
    required this.onCurrencySelected,
  });

  @override
  State<CurrencySelectorSheet> createState() => _CurrencySelectorSheetState();

  static Future<CurrencyType?> show({
    required BuildContext context,
    required List<CurrencyType> currencies,
    String? selectedCurrencyId,
  }) {
    return showModalBottomSheet<CurrencyType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => CurrencySelectorSheet(
        currencies: currencies,
        selectedCurrencyId: selectedCurrencyId,
        onCurrencySelected: (currency) {
          Navigator.pop(context, currency);
        },
      ),
    );
  }
}

class _CurrencySelectorSheetState extends State<CurrencySelectorSheet> {
  late List<CurrencyType> filteredCurrencies;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    filteredCurrencies = widget.currencies;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCurrencies = widget.currencies;
      } else {
        filteredCurrencies = widget.currencies.where((currency) {
          return currency.currencyName.toLowerCase().contains(query) ||
              currency.currencyCode.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    // 키보드 높이를 제외한 사용 가능한 높이 계산
    final availableHeight = screenHeight - keyboardHeight - mediaQuery.padding.top;
    // 키보드가 열렸을 때는 사용 가능한 높이의 90%, 아니면 70%
    final sheetHeight = isKeyboardOpen
        ? availableHeight * 0.90
        : screenHeight * 0.7;

    return AnimatedPadding(
      duration: TossAnimations.quick,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        // 키보드가 열렸을 때는 고정 높이, 아니면 최대 높이 제한
        height: isKeyboardOpen ? sheetHeight : null,
        constraints: BoxConstraints(
          maxHeight: sheetHeight,
        ),
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: isKeyboardOpen ? MainAxisSize.max : MainAxisSize.min,
          children: [
            // Handle bar
            GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                child: Center(
                  child: Container(
                    width: TossDimensions.dragHandleWidth,
                    height: TossDimensions.dragHandleHeight,
                    decoration: BoxDecoration(
                      color: TossColors.gray300,
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                  ),
                ),
              ),
            ),

            // Header with title and close button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              child: Row(
                children: [
                  SizedBox(width: TossDimensions.avatarLG), // Balance for close button
                  Expanded(
                    child: Text(
                      'Select Currency',
                      style: TossTextStyles.h4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: () {
                      _searchFocusNode.unfocus();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: TossDimensions.avatarLG,
                      height: TossDimensions.avatarLG,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.full),
                      ),
                      child: Icon(
                        Icons.close,
                        color: TossColors.gray600,
                        size: TossSpacing.iconMD,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar using TossSearchField
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              child: TossSearchField(
                hintText: 'Search currency...',
                controller: _searchController,
                focusNode: _searchFocusNode,
                onClear: () {
                  setState(() {
                    filteredCurrencies = widget.currencies;
                  });
                },
              ),
            ),

            // Currency list
            Flexible(
              child: GestureDetector(
                onTap: () => _searchFocusNode.unfocus(),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: filteredCurrencies.length,
                  itemBuilder: (context, index) {
                    final currency = filteredCurrencies[index];
                    final isSelected = currency.currencyId == widget.selectedCurrencyId;
                    final isLast = index == filteredCurrencies.length - 1;

                    return _buildCurrencyItem(
                      currency: currency,
                      isSelected: isSelected,
                      isLast: isLast,
                    );
                  },
                ),
              ),
            ),

            // Bottom safe area
            SizedBox(
              height: isKeyboardOpen
                  ? TossSpacing.space4
                  : mediaQuery.padding.bottom + TossSpacing.space4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyItem({
    required CurrencyType currency,
    required bool isSelected,
    required bool isLast,
  }) {
    return InkWell(
      onTap: () {
        _searchFocusNode.unfocus();
        widget.onCurrencySelected(currency);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: TossOpacity.subtle) : TossColors.transparent,
          border: Border(
            bottom: BorderSide(
              color: TossColors.gray100,
              width: isLast ? 0 : 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Flag emoji
            Container(
              width: TossDimensions.avatarLG,
              height: TossDimensions.avatarLG,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: TossOpacity.light)
                    : TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Text(
                  currency.flagEmoji,
                  style: TossTextStyles.h3,
                ),
              ),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Currency info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.currencyName,
                    style: isSelected
                        ? TossTextStyles.bodyMedium.copyWith(color: TossColors.gray900)
                        : TossTextStyles.body.copyWith(color: TossColors.gray900),
                  ),
                  SizedBox(height: TossSpacing.space0),
                  Text(
                    currency.currencyCode,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),

            // Selected indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: TossColors.primary,
                size: TossSpacing.iconMD2,
              ),
          ],
        ),
      ),
    );
  }
}
