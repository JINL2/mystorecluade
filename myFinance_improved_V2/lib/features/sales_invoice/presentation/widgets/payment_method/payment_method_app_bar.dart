// lib/features/sales_invoice/presentation/widgets/payment_method/payment_method_app_bar.dart
//
// Payment method page AppBar extracted from payment_method_page.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'exchange_rate_button.dart';

/// AppBar for payment method page
class PaymentMethodAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isExchangeRatePanelExpanded;
  final VoidCallback onExchangeRateToggle;
  final VoidCallback? onBackPressed;

  const PaymentMethodAppBar({
    super.key,
    required this.isExchangeRatePanelExpanded,
    required this.onExchangeRateToggle,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TossColors.gray50,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 24),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      titleSpacing: 0,
      title: Text(
        'Sales Invoice',
        style: TossTextStyles.body.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      actions: [
        ExchangeRateButton(
          isExpanded: isExchangeRatePanelExpanded,
          onTap: onExchangeRateToggle,
        ),
      ],
    );
  }
}
