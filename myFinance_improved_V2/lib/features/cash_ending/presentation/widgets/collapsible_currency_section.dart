// lib/features/cash_ending/presentation/widgets/collapsible_currency_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/currency.dart';
import 'denomination_grid_header.dart';
import 'denomination_input.dart';
import 'total_display.dart';

/// Collapsible currency section with accordion behavior
///
/// Shows currency header with expand/collapse arrow
class CollapsibleCurrencySection extends StatefulWidget {
  final Currency currency;
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;
  final double totalAmount;
  final VoidCallback onChanged;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final String? baseCurrencySymbol; // For exchange rate display

  const CollapsibleCurrencySection({
    super.key,
    required this.currency,
    required this.controllers,
    required this.focusNodes,
    required this.totalAmount,
    required this.onChanged,
    this.isExpanded = true,
    this.onToggle,
    this.baseCurrencySymbol,
  });

  @override
  State<CollapsibleCurrencySection> createState() => _CollapsibleCurrencySectionState();
}

class _CollapsibleCurrencySectionState extends State<CollapsibleCurrencySection> {
  void _toggle() {
    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currency header (clickable)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              child: Row(
                children: [
                  // Currency name with exchange rate on same line for non-base currencies
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${widget.currency.currencyCode} • ${widget.currency.currencyName}',
                          style: TossTextStyles.titleMedium.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Show exchange rate on same line for non-base currencies
                        if (!widget.currency.isBaseCurrency && widget.currency.exchangeRateToBase != 1.0) ...[
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            '1 ${widget.currency.currencyCode} = ${widget.baseCurrencySymbol ?? ''}${NumberFormat('#,##0.00').format(widget.currency.exchangeRateToBase)}',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0.0,
                    duration: TossAnimations.fast,
                    curve: TossAnimations.standard,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: TossColors.gray700,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider (full width - no padding)
          Container(
            height: 1,
            color: TossColors.gray200,
          ),

          // Expanded content with smooth bottom-to-top animation
          ClipRect(
            child: AnimatedAlign(
              duration: TossAnimations.fast,
              curve: TossAnimations.standard,
              heightFactor: widget.isExpanded ? 1.0 : 0.0,
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: TossSpacing.space4,
                  right: TossSpacing.space4,
                  top: TossSpacing.space4,
                ),
                child: Column(
                  children: [
                    // Grid header
                    DenominationGridHeader(currencyCode: widget.currency.currencyCode),

                    SizedBox(height: TossSpacing.space1),

                    // Denomination inputs
                    ...widget.currency.denominations.map((denom) {
                      final controller = widget.controllers[denom.denominationId];
                      final focusNode = widget.focusNodes[denom.denominationId];

                      if (controller == null || focusNode == null) {
                        return const SizedBox.shrink();
                      }

                      return DenominationInput(
                        denomination: denom,
                        controller: controller,
                        focusNode: focusNode,
                        currencySymbol: widget.currency.symbol,
                        onChanged: widget.onChanged,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Subtotal (always visible)
          // Use ListenableBuilder to update when any denomination quantity changes
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space4,  // left = 16px
              TossSpacing.space4,  // top = 16px (reduced from 28px)
              TossSpacing.space4,  // right = 16px
              TossSpacing.space4,  // bottom = 16px (reduced from 28px)
            ),
            child: ListenableBuilder(
              listenable: Listenable.merge(widget.controllers.values.toList()),
              builder: (context, _) {
                // Calculate subtotal from controller values
                double subtotal = 0.0;
                for (final denomination in widget.currency.denominations) {
                  final controller = widget.controllers[denomination.denominationId];
                  if (controller != null) {
                    final quantity = int.tryParse(controller.text.trim()) ?? 0;
                    subtotal += denomination.value * quantity;
                  }
                }

                // Subtotal label (exchange rate is now shown in header)
                return TotalDisplay(
                  totalAmount: subtotal,
                  currencySymbol: widget.currency.symbol,
                  label: 'Subtotal ${widget.currency.currencyCode}',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
