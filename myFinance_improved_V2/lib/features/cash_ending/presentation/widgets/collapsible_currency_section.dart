// lib/features/cash_ending/presentation/widgets/collapsible_currency_section.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/denomination.dart';
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

  const CollapsibleCurrencySection({
    super.key,
    required this.currency,
    required this.controllers,
    required this.focusNodes,
    required this.totalAmount,
    required this.onChanged,
    this.isExpanded = true,
    this.onToggle,
  });

  @override
  State<CollapsibleCurrencySection> createState() => _CollapsibleCurrencySectionState();
}

class _CollapsibleCurrencySectionState extends State<CollapsibleCurrencySection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.currency.currencyCode} • ${widget.currency.currencyName}',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: TossColors.gray700,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: TossSpacing.space4,
                right: TossSpacing.space4,
                top: TossSpacing.space4,
              ),
              child: Column(
                children: [
                  // Grid header
                  DenominationGridHeader(currencyCode: widget.currency.currencyCode),

                  const SizedBox(height: TossSpacing.space2),

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
          ],

          // Subtotal (always visible)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space4,  // left = 16px
              TossSpacing.space7,  // top = 28px
              TossSpacing.space4,  // right = 16px
              TossSpacing.space7,  // bottom = 28px
            ),
            child: TotalDisplay(
              totalAmount: widget.totalAmount,
              currencySymbol: widget.currency.symbol,
              label: 'Subtotal (${widget.currency.currencyCode})',
            ),
          ),
        ],
      ),
    );
  }
}
