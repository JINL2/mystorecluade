// lib/features/cash_ending/presentation/widgets/denomination_input.dart
// Adapted from legacy denomination_widgets.dart (lines 293-708)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/denomination.dart';

/// Denomination input widget - exact legacy UI/UX from denomination_widgets.dart
///
/// Compact 3-column layout (denomination | controls | total)
/// Fixed 40px height with responsive font sizing
class DenominationInput extends StatelessWidget {
  final Denomination denomination;
  final TextEditingController controller;
  final String currencySymbol;
  final VoidCallback onChanged;
  final FocusNode? focusNode;

  const DenominationInput({
    super.key,
    required this.denomination,
    required this.controller,
    required this.currencySymbol,
    required this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final amount = denomination.value.toInt();
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
                      fontSize: _getResponsiveFontSize(
                          '$currencySymbol$formattedAmount', 'denomination'),
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
                  onTap: () => _decrementQuantity(),
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
                      TossIcons.remove,
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
                    focusNode: focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5), // Max 99999
                    ],
                    textAlign: TextAlign.center,
                    // KEY FIX: scrollPadding accounts for keyboard toolbar height
                    // Toolbar height (48) + keyboard height + comfortable padding (80)
                    scrollPadding: const EdgeInsets.only(bottom: 130),
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                      fontSize: _getOptimalQuantityFontSize(
                          controller.text.isEmpty ? '0' : controller.text),
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
                        borderSide: const BorderSide(
                            color: TossColors.gray200, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: const BorderSide(
                            color: TossColors.gray200, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: BorderSide(
                            color: TossColors.primary.withOpacity(0.3),
                            width: 1.0),
                      ),
                      fillColor: TossColors.surface,
                      filled: true,
                    ),
                    onChanged: (value) {
                      // Validate max value
                      final intValue = int.tryParse(value);
                      if (intValue != null && intValue > 99999) {
                        controller.text = '99999';
                        controller.selection =
                            TextSelection.fromPosition(
                                const TextPosition(offset: 5));
                      }
                      onChanged();
                    },
                  ),
                ),

                const SizedBox(width: 1), // Ultra-minimal spacing

                // Increment button (compact for space efficiency)
                GestureDetector(
                  onTap: () => _incrementQuantity(),
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
                      TossIcons.add,
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
                  child: Builder(builder: (context) {
                    // Calculate once for performance and consistency
                    final subtotalText = _calculateSubtotal(
                        denomination.value.toInt().toString(),
                        controller.text,
                        currencySymbol);

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
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper functions (from legacy denomination_widgets.dart)

  /// Enhanced subtotal calculation with comprehensive error handling
  String _calculateSubtotal(String denomValue, String quantity, String currencySymbol) {
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
  String _getSafeCurrencySymbol(String currencySymbol) {
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
    if (trimmedSymbol == 'd' ||
        trimmedSymbol == 'đ' ||
        trimmedSymbol.toLowerCase().contains('vnd')) {
      return '₫'; // Proper Vietnamese dong symbol
    }

    // Return validated symbol
    return trimmedSymbol;
  }

  /// Unified, sustainable font sizing system with comprehensive edge case handling
  double _getResponsiveFontSize(String text, String containerType) {
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
  double _getUnifiedMonetaryFontSize(int effectiveLength, String containerType) {
    // Accessibility minimum: 12px for mobile readability (WCAG compliant)
    const double minAccessibleSize = 12.0;

    // Unified breakpoints for both denomination and total
    double baseSize;
    if (effectiveLength <= 8) {
      baseSize = 16.0; // ₫50,000 - Optimal readability
    } else if (effectiveLength <= 10) {
      baseSize = 14.0; // ₫9,400,000 - Large and clear
    } else if (effectiveLength <= 12) {
      baseSize = 13.0; // ₫277,500,000 - Good readability
    } else if (effectiveLength <= 14) {
      baseSize = 12.0; // Very long amounts - Still accessible
    } else if (effectiveLength <= 16) {
      baseSize = 11.0; // Extremely long - Compact but readable
    } else if (effectiveLength <= 18) {
      baseSize = 10.0; // Ultra-long - Minimum comfortable
    } else if (effectiveLength <= 20) {
      baseSize = 9.0; // Massive amounts - Small but usable
    } else {
      baseSize = 8.0; // Ultra-massive - Absolute minimum
    }

    // Ensure accessibility compliance
    final accessibleSize =
        baseSize < minAccessibleSize ? minAccessibleSize : baseSize;

    // Container-specific fine-tuning
    return _applyContainerCompensation(accessibleSize, containerType);
  }

  /// Calculate effective length with currency symbol weight compensation
  int _calculateEffectiveLength(String text) {
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
  double _applyContainerCompensation(double baseSize, String containerType) {
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
  double _getQuantityFontSize(int effectiveLength) {
    // Optimized for 46px width container with tight spacing
    if (effectiveLength <= 2) return 15.0; // 1-99: Large
    if (effectiveLength <= 3) return 15.0; // 100-999: Still large
    if (effectiveLength <= 4) return 11.5; // 1000-9999: Medium
    if (effectiveLength <= 5) return 9.5; // 10000-99999: Compact
    return 8.0; // Edge cases: Small but readable
  }

  /// Default font sizes for unknown container types
  double _getDefaultFontSize(String containerType) {
    switch (containerType) {
      case 'denomination':
      case 'total':
        return 14.0; // Safe default for monetary displays
      case 'quantity':
        return 12.0; // Safe default for numeric input
      default:
        return 12.0; // Universal fallback
    }
  }

  /// Optimized quantity font sizing using unified system
  double _getOptimalQuantityFontSize(String text) {
    // Delegate to unified system for consistency
    return _getResponsiveFontSize(text, 'quantity');
  }

  // Quantity increment/decrement functions
  void _incrementQuantity() {
    final currentValue = int.tryParse(controller.text.trim()) ?? 0;
    final newValue = currentValue + 1;
    controller.text = newValue.toString();
    onChanged();
    HapticFeedback.selectionClick();
  }

  void _decrementQuantity() {
    final currentValue = int.tryParse(controller.text.trim()) ?? 0;
    if (currentValue > 0) {
      final newValue = currentValue - 1;
      controller.text = newValue == 0 ? '' : newValue.toString();
      onChanged();
      HapticFeedback.selectionClick();
    }
  }
}
