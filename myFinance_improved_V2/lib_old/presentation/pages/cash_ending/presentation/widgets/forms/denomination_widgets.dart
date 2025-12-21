import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../widgets/toss/toss_card.dart';
import '../../../../../widgets/toss/toss_chip.dart';
import '../sheets/currency_selector_sheet.dart';

/// Denomination widgets for Cash Ending page
/// FROM PRODUCTION LINES 1638-1963
class DenominationWidgets {
  
  /// Build denomination section main widget
  /// FROM PRODUCTION LINES 1638-1703
  static Widget buildDenominationSection({
    required BuildContext context,
    required String tabType,
    required String? selectedCashCurrencyId,
    required String? selectedBankCurrencyId,
    required String? selectedVaultCurrencyId,
    required List<Map<String, dynamic>> companyCurrencies,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required Function(VoidCallback) setState,
    required Function(String) currencyHasData,
    required Function(String, String) onCurrencySelected, // Add callback for currency selection
  }) {
    
    // Get selected currency ID based on tab
    final String? selectedCurrencyId;
    if (tabType == 'cash') {
      selectedCurrencyId = selectedCashCurrencyId;
    } else if (tabType == 'bank') {
      selectedCurrencyId = selectedBankCurrencyId;
    } else {
      selectedCurrencyId = selectedVaultCurrencyId;
    }
    
    // For Cash and Vault tabs: Show denomination list with currency selector in header
    if (tabType != 'bank') {
      // Show currency selector even if no currency is selected yet
      if (companyCurrencies.isEmpty) {
        return TossCard(
          padding: const EdgeInsets.all(TossSpacing.space4),
          backgroundColor: TossColors.gray50,
          child: Center(
            child: Text(
              'Loading currency data...',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      
      // Show denominations (currency selector is now in the header)
      if (selectedCurrencyId != null && currencyDenominations.containsKey(selectedCurrencyId)) {
        return _buildDenominationList(
          context,
          selectedCurrencyId,
          tabType,
          companyCurrencies: companyCurrencies,
          currencyDenominations: currencyDenominations,
          denominationControllers: denominationControllers,
          setState: setState,
          onCurrencySelected: onCurrencySelected,
          currencyHasData: currencyHasData,
        );
      } else {
        // Use first currency as default if none selected
        final defaultCurrencyId = companyCurrencies.first['currency_id'].toString();
        return _buildDenominationList(
          context,
          defaultCurrencyId,
          tabType,
          companyCurrencies: companyCurrencies,
          currencyDenominations: currencyDenominations,
          denominationControllers: denominationControllers,
          setState: setState,
          onCurrencySelected: onCurrencySelected,
          currencyHasData: currencyHasData,
        );
      }
    }
    
    // For Bank tab: Must have a selected currency from location
    if (selectedCurrencyId == null || !currencyDenominations.containsKey(selectedCurrencyId)) {
      return TossCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        backgroundColor: TossColors.gray50,
        child: Center(
          child: Text(
            'Loading currency data...',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    
    // Bank tab continues with denominations only (no currency selector)
    return _buildDenominationList(
      context,
      selectedCurrencyId,
      tabType,
      companyCurrencies: companyCurrencies,
      currencyDenominations: currencyDenominations,
      denominationControllers: denominationControllers,
      setState: setState,
      currencyHasData: currencyHasData,
    );
  }
  
  /// Build denomination list
  /// FROM PRODUCTION LINES 1705-1759
  static Widget _buildDenominationList(
    BuildContext context,
    String selectedCurrencyId,
    String tabType, {
    required List<Map<String, dynamic>> companyCurrencies,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required Function(VoidCallback) setState,
    Function(String, String)? onCurrencySelected,
    Function(String)? currencyHasData,
  }) {
    // Get currency info from companyCurrencies (already has all details)
    final currencyInfo = companyCurrencies.firstWhere(
      (c) => c['currency_id'].toString() == selectedCurrencyId,
      orElse: () => {},
    );
    
    final currencyCode = currencyInfo['currency_code'] ?? 'N/A';
    // Handle VND symbol specially - use the correct Unicode character
    var currencySymbol = currencyInfo['symbol'] ?? '';
    
    // If the symbol looks corrupted (like 'd' instead of '₫'), fix it for VND
    if (currencyCode == 'VND' && (currencySymbol == 'd' || currencySymbol == 'đ' || currencySymbol.isEmpty)) {
      currencySymbol = '₫';  // Use the correct Unicode character for Vietnamese dong
    }
    
    final denominations = currencyDenominations[selectedCurrencyId] ?? [];
    final controllers = denominationControllers[selectedCurrencyId] ?? {};
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern simple header like cash_location Accounts
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cash Count',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            if (onCurrencySelected != null && tabType != 'bank')
              GestureDetector(
                onTap: () {
                  CurrencySelectorSheet.showCurrencySelector(
                    context: context,
                    companyCurrencies: companyCurrencies,
                    selectedCurrencyId: selectedCurrencyId,
                    onCurrencySelected: (currencyId) {
                      onCurrencySelected(tabType, currencyId);
                    },
                    tabType: tabType,
                    currencyHasData: currencyHasData,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currencyCode,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: TossColors.primary,
                      size: 24,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: TossSpacing.space5),
        ...denominations.map((denom) {
          final denomValue = (denom['value'] ?? 0).toString();
          // IMPORTANT: Only use existing controllers from the map, don't create new ones
          final controller = controllers[denomValue];
          if (controller == null) {
            // Skip this denomination if controller doesn't exist
            // Controllers should be created in loadCurrencyDenominations
            return const SizedBox.shrink();
          }
          return _buildDenominationInput(
            context: context,
            denomination: denom,
            controller: controller,
            currencySymbol: currencySymbol,
            setState: setState,
          );
        }).toList(),
      ],
    );
  }
  
  // Build currency selector for multiple currencies
  /// FROM PRODUCTION LINES 1762-1834
  static Widget _buildCurrencySelector({
    required String tabType,
    required String? selectedCashCurrencyId,
    required String? selectedBankCurrencyId,
    required String? selectedVaultCurrencyId,
    required List<Map<String, dynamic>> companyCurrencies,
    required Function(VoidCallback) setState,
    required Function(String) currencyHasData,
    required Function(String, String) onCurrencySelected,
  }) {
    final String? selectedCurrencyId;
    if (tabType == 'cash') {
      selectedCurrencyId = selectedCashCurrencyId;
    } else if (tabType == 'bank') {
      selectedCurrencyId = selectedBankCurrencyId;
    } else {
      selectedCurrencyId = selectedVaultCurrencyId;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Wrap(
          spacing: TossSpacing.space3,
          runSpacing: TossSpacing.space3,
          children: companyCurrencies.map((currency) {
            final currencyId = currency['currency_id'].toString();
            // Currency details are already in companyCurrencies after the join
            var symbol = currency['symbol'] ?? '';
            final currencyCode = currency['currency_code'] ?? 'N/A';
            
            // Fix VND symbol if corrupted
            if (currencyCode == 'VND' && (symbol == 'd' || symbol == 'đ' || symbol.isEmpty)) {
              symbol = '₫';
            }
            
            final isSelected = selectedCurrencyId == currencyId;
            
            // Check if this currency has data (only for cash tab)
            final hasData = tabType == 'cash' ? currencyHasData(currencyId) : false;
            
            return TossChip(
              label: '$symbol - $currencyCode',
              isSelected: isSelected,
              trailing: hasData 
                ? Icon(Icons.check_circle, size: 14, color: TossColors.success)
                : null,
              onTap: () {
                onCurrencySelected(tabType, currencyId);
                HapticFeedback.selectionClick();
              },
            );
          }).toList(),
        ),
      ],
    );
  }
  
  /// Build denomination input widget
  /// FROM PRODUCTION LINES 1836-1962
  static Widget _buildDenominationInput({
    required BuildContext context,
    required Map<String, dynamic> denomination,
    required TextEditingController controller,
    required String currencySymbol,
    required Function(VoidCallback) setState,
  }) {
    final amountRaw = denomination['value'] ?? 0;
    final amount = amountRaw is int ? amountRaw : (amountRaw as num).toInt();
    final formattedAmount = NumberFormat('#,###').format(amount);
    
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      height: 40, // Fixed container height to prevent overflow
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left section: Denomination + × symbol (tighter spacing)
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    '$currencySymbol$formattedAmount',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray700,
                      fontSize: _getResponsiveFontSize('$currencySymbol$formattedAmount', 'denomination'),
                    ),
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 4), // Closer to denomination
                Text(
                  '×',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Center section: Compact quantity controls only
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button (compact for space efficiency)
                GestureDetector(
                  onTap: () => _decrementQuantity(controller, setState),
                  child: Container(
                    width: 20,
                    height: 32,
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      border: Border.all(
                        color: TossColors.gray200,
                        width: 1.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.remove,
                      size: 12,
                      color: TossColors.gray600,
                    ),
                  ),
                ),
                
                const SizedBox(width: 1), // Ultra-minimal spacing
                
                // Quantity input (TextField with numeric keyboard) - Optimized width
                Container(
                  width: 46,
                  height: 32,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5), // Max 99999
                    ],
                    textAlign: TextAlign.center,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                      fontSize: _getOptimalQuantityFontSize(controller.text.isEmpty ? '0' : controller.text),
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TossTextStyles.body.copyWith(
                        color: TossColors.gray400,
                        fontSize: _getOptimalQuantityFontSize('0'),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space1,
                        vertical: TossSpacing.space1,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: const BorderSide(color: TossColors.gray200, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: const BorderSide(color: TossColors.gray200, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: BorderSide(color: TossColors.primary.withValues(alpha: 0.3), width: 1.0),
                      ),
                      fillColor: TossColors.surface,
                      filled: true,
                    ),
                    onChanged: (value) {
                      // Validate max value
                      final intValue = int.tryParse(value);
                      if (intValue != null && intValue > 99999) {
                        controller.text = '99999';
                        controller.selection = TextSelection.fromPosition(TextPosition(offset: 5));
                      }
                      setState(() {});
                    },
                  ),
                ),
                
                const SizedBox(width: 1), // Ultra-minimal spacing
                
                // Increment button (compact for space efficiency)
                GestureDetector(
                  onTap: () => _incrementQuantity(controller, setState),
                  child: Container(
                    width: 20,
                    height: 32,
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      border: Border.all(
                        color: TossColors.gray200,
                        width: 1.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 12,
                      color: TossColors.gray600,
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          
          // Right section: = symbol + Total (tighter spacing)
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(
                  '=',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4), // Closer to = symbol
                Flexible(
                  child: Builder(
                    builder: (context) {
                      // Calculate once for performance and consistency
                      final subtotalText = _calculateSubtotal(
                        _getDenominationValueAsString(denomination), 
                        controller.text, 
                        currencySymbol
                      );
                      
                      return Text(
                        subtotalText,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                          fontFamily: TossTextStyles.fontFamilyMono,
                          fontSize: _getResponsiveFontSize(subtotalText, 'total'),
                        ),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper functions
  /// Enhanced subtotal calculation with comprehensive error handling
  static String _calculateSubtotal(String denomValue, String quantity, String currencySymbol) {
    // Edge case handling: null or empty inputs
    if (denomValue.isEmpty || quantity.isEmpty) {
      final safeSymbol = _getSafeCurrencySymbol(currencySymbol);
      return '${safeSymbol}0';
    }
    
    // Parse values with error handling
    final denom = int.tryParse(denomValue.trim()) ?? 0;
    final qty = int.tryParse(quantity.trim()) ?? 0;
    
    // Prevent integer overflow for very large calculations
    late final int subtotal;
    try {
      subtotal = denom * qty;
      // Check for overflow (though unlikely with our constraints)
      if (subtotal < 0) {
        // Overflow occurred, use safe fallback
        final safeSymbol = _getSafeCurrencySymbol(currencySymbol);
        return '${safeSymbol}999,999,999,999'; // Safe maximum display
      }
    } catch (e) {
      // Fallback for any calculation errors
      final safeSymbol = _getSafeCurrencySymbol(currencySymbol);
      return '${safeSymbol}0';
    }
    
    // Format with proper currency symbol
    final safeSymbol = _getSafeCurrencySymbol(currencySymbol);
    
    try {
      return '$safeSymbol${NumberFormat('#,###').format(subtotal)}';
    } catch (e) {
      // Fallback for number formatting errors
      return '${safeSymbol}${subtotal.toString()}';
    }
  }
  
  /// Safe currency symbol handling with fallbacks
  static String _getSafeCurrencySymbol(String currencySymbol) {
    // Handle null, empty, or invalid currency symbols
    if (currencySymbol.isEmpty) {
      return '¤'; // Generic currency symbol (Unicode U+00A4)
    }
    
    // Validate common currency symbols and provide fallbacks
    final trimmedSymbol = currencySymbol.trim();
    if (trimmedSymbol.isEmpty) {
      return '¤';
    }
    
    // Check for corrupted VND symbol and fix it
    if (trimmedSymbol == 'd' || trimmedSymbol == 'đ' || trimmedSymbol.toLowerCase().contains('vnd')) {
      return '₫'; // Proper Vietnamese dong symbol
    }
    
    // Return validated symbol
    return trimmedSymbol;
  }
  
  static String _getDenominationValueAsString(Map<String, dynamic> denomination) {
    final amountRaw = denomination['value'] ?? 0;
    final amount = amountRaw is int ? amountRaw : (amountRaw as num).toInt();
    return amount.toString();
  }
  
  /// Unified, sustainable font sizing system with comprehensive edge case handling
  static double _getResponsiveFontSize(String text, String containerType) {
    // Edge case handling: null, empty, or invalid input
    if (text.isEmpty) {
      return _getDefaultFontSize(containerType);
    }
    
    // Normalize text for consistent measurement
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      return _getDefaultFontSize(containerType);
    }
    
    // Calculate effective length with currency symbol weight compensation
    final effectiveLength = _calculateEffectiveLength(cleanText);
    
    // Route to appropriate sizing strategy
    switch (containerType) {
      case 'denomination':
      case 'total':
        return _getUnifiedMonetaryFontSize(effectiveLength, containerType);
      case 'quantity':
        return _getQuantityFontSize(effectiveLength);
      default:
        return _getDefaultFontSize(containerType);
    }
  }
  
  /// Unified font sizing for both denomination and total amounts
  /// Ensures perfect consistency and accessibility compliance
  static double _getUnifiedMonetaryFontSize(int effectiveLength, String containerType) {
    // Accessibility minimum: 12px for mobile readability (WCAG compliant)
    const double minAccessibleSize = 12.0;
    const double maxOptimalSize = 16.0;
    
    // Unified breakpoints for both denomination and total
    double baseSize;
    if (effectiveLength <= 8) {
      baseSize = 16.0;      // ₫50,000 - Optimal readability
    } else if (effectiveLength <= 10) {
      baseSize = 14.0;      // ₫9,400,000 - Large and clear
    } else if (effectiveLength <= 12) {
      baseSize = 13.0;      // ₫277,500,000 - Good readability
    } else if (effectiveLength <= 14) {
      baseSize = 12.0;      // Very long amounts - Still accessible
    } else if (effectiveLength <= 16) {
      baseSize = 11.0;      // Extremely long - Compact but readable
    } else if (effectiveLength <= 18) {
      baseSize = 10.0;      // Ultra-long - Minimum comfortable
    } else if (effectiveLength <= 20) {
      baseSize = 9.0;       // Massive amounts - Small but usable
    } else {
      baseSize = 8.0;       // Ultra-massive - Absolute minimum
    }
    
    // Ensure accessibility compliance
    final accessibleSize = baseSize < minAccessibleSize ? minAccessibleSize : baseSize;
    
    // Container-specific fine-tuning
    return _applyContainerCompensation(accessibleSize, containerType);
  }
  
  /// Calculate effective length with currency symbol weight compensation
  static int _calculateEffectiveLength(String text) {
    final baseLength = text.length;
    
    // Currency symbols have different visual weights
    if (text.startsWith('₫')) {
      // Vietnamese dong symbol is visually wider
      return baseLength + 1;
    } else if (text.startsWith('\$') || text.startsWith('€')) {
      // Dollar and Euro are standard width
      return baseLength;
    } else if (text.startsWith('¥') || text.startsWith('£')) {
      // Yen and Pound are slightly wider
      return (baseLength + 0.5).round();
    }
    
    return baseLength;
  }
  
  /// Apply fine-tuning based on container characteristics
  static double _applyContainerCompensation(double baseSize, String containerType) {
    switch (containerType) {
      case 'denomination':
        // Denomination section: Slightly more generous due to fixed values
        return baseSize * 1.0;
      case 'total':
        // Total section: Slightly tighter due to dynamic calculations
        return baseSize * 0.95;
      default:
        return baseSize;
    }
  }
  
  /// Quantity input font sizing optimized for 46px width container  
  static double _getQuantityFontSize(int effectiveLength) {
    // Optimized for 46px width container with tight spacing
    if (effectiveLength <= 2) return 15.0;      // 1-99: Large
    if (effectiveLength <= 3) return 15.0;      // 100-999: Still large
    if (effectiveLength <= 4) return 11.5;      // 1000-9999: Medium
    if (effectiveLength <= 5) return 9.5;       // 10000-99999: Compact
    return 8.0;                                  // Edge cases: Small but readable
  }
  
  /// Default font sizes for unknown container types
  static double _getDefaultFontSize(String containerType) {
    switch (containerType) {
      case 'denomination':
      case 'total':
        return 14.0;  // Safe default for monetary displays
      case 'quantity':
        return 12.0;  // Safe default for numeric input
      default:
        return 12.0;  // Universal fallback
    }
  }
  
  /// Optimized quantity font sizing using unified system
  static double _getOptimalQuantityFontSize(String text) {
    // Delegate to unified system for consistency
    return _getResponsiveFontSize(text, 'quantity');
  }
  
  // Quantity increment/decrement functions
  static void _incrementQuantity(TextEditingController controller, Function(VoidCallback) setState) {
    final currentValue = int.tryParse(controller.text.trim()) ?? 0;
    final newValue = currentValue + 1;
    controller.text = newValue.toString();
    setState(() {});
    HapticFeedback.selectionClick();
  }
  
  static void _decrementQuantity(TextEditingController controller, Function(VoidCallback) setState) {
    final currentValue = int.tryParse(controller.text.trim()) ?? 0;
    if (currentValue > 0) {
      final newValue = currentValue - 1;
      controller.text = newValue == 0 ? '' : newValue.toString();
      setState(() {});
      HapticFeedback.selectionClick();
    }
  }
}