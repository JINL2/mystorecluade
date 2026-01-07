import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../../shared/themes/toss_opacity.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/cash_location.dart';
import '../../../providers/payment_providers.dart';
import '../../../providers/states/payment_method_state.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Payment method section with expandable Cash/Bank/Vault options
class PaymentMethodSection extends ConsumerStatefulWidget {
  final VoidCallback? onExpand;

  const PaymentMethodSection({
    super.key,
    this.onExpand,
  });

  @override
  ConsumerState<PaymentMethodSection> createState() =>
      _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends ConsumerState<PaymentMethodSection> {
  String? _expandedType; // 'cash', 'bank', or 'vault'
  bool _hasAutoSelected = false;

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentMethodNotifierProvider);

    // Auto-select if there's only one cash location total
    if (!_hasAutoSelected &&
        !paymentState.isLoading &&
        paymentState.cashLocations.length == 1 &&
        paymentState.selectedCashLocation == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(paymentMethodNotifierProvider.notifier)
            .selectCashLocation(paymentState.cashLocations.first);
      });
      _hasAutoSelected = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Payment method',
          style: TossTextStyles.h4.copyWith(
            fontWeight: TossFontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),

        // Content based on state
        if (paymentState.isLoading)
          _buildLoadingState()
        else if (paymentState.error != null)
          _buildErrorState(paymentState.error!)
        else if (paymentState.cashLocations.isEmpty)
          _buildEmptyState()
        else
          _buildPaymentMethods(paymentState),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          const TossLoadingView.inline(size: TossSpacing.iconMD),
          const SizedBox(width: TossSpacing.space3),
          Text(
            'Loading payment methods...',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.error.withValues(alpha: TossOpacity.light),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: TossColors.error.withValues(alpha: TossOpacity.heavy),
              width: TossDimensions.dividerThickness,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: TossColors.error,
                size: TossSpacing.iconMD,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  error,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossButton.textButton(
          text: 'Retry',
          onPressed: () =>
              ref.read(paymentMethodNotifierProvider.notifier).loadCurrencyData(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: TossSpacing.iconXXL,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'No payment methods available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(PaymentMethodState paymentState) {
    // Group locations by type
    final cashLocations = paymentState.cashLocations
        .where((loc) => loc.type.toLowerCase() == 'cash')
        .toList();
    final bankLocations = paymentState.cashLocations
        .where((loc) => loc.type.toLowerCase() == 'bank')
        .toList();
    final vaultLocations = paymentState.cashLocations
        .where((loc) => loc.type.toLowerCase() == 'vault')
        .toList();

    return Column(
      children: [
        // Cash option
        if (cashLocations.isNotEmpty)
          _buildPaymentTypeRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Cash',
            type: 'cash',
            locations: cashLocations,
            selectedLocation: paymentState.selectedCashLocation,
          ),

        // Bank option
        if (bankLocations.isNotEmpty)
          _buildPaymentTypeRow(
            icon: Icons.account_balance_outlined,
            label: 'Bank',
            type: 'bank',
            locations: bankLocations,
            selectedLocation: paymentState.selectedCashLocation,
          ),

        // Vault option
        if (vaultLocations.isNotEmpty)
          _buildPaymentTypeRow(
            icon: Icons.dashboard_outlined,
            label: 'Vault',
            type: 'vault',
            locations: vaultLocations,
            selectedLocation: paymentState.selectedCashLocation,
          ),
      ],
    );
  }

  Widget _buildPaymentTypeRow({
    required IconData icon,
    required String label,
    required String type,
    required List<CashLocation> locations,
    required CashLocation? selectedLocation,
  }) {
    final isExpanded = _expandedType == type;

    return Column(
      children: [
        // Type header row - always expandable with ink ripple effect
        Material(
          color: TossColors.transparent,
          child: InkWell(
            onTap: () {
              // Toggle expand/collapse
              setState(() {
                _expandedType = isExpanded ? null : type;
              });

              if (isExpanded) {
                // Collapsing - clear selection
                ref
                    .read(paymentMethodNotifierProvider.notifier)
                    .selectCashLocation(null);
              } else {
                // Expanding - auto-select first location
                if (locations.isNotEmpty) {
                  ref
                      .read(paymentMethodNotifierProvider.notifier)
                      .selectCashLocation(locations.first);
                  // Notify parent to scroll down
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onExpand?.call();
                  });
                }
              }
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TossSpacing.space2,
                horizontal: TossSpacing.space2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          size: TossSpacing.iconSM,
                          color: TossColors.gray600,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          label,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: TossFontWeight.semibold,
                            color: TossColors.gray900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Always show expand/collapse arrow
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: TossSpacing.iconSM,
                    color: TossColors.gray600,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Expanded location list
        if (isExpanded) _buildLocationList(locations, selectedLocation),
      ],
    );
  }

  Widget _buildLocationList(
    List<CashLocation> locations,
    CashLocation? selectedLocation,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: TossSpacing.space10),
      padding: const EdgeInsets.only(left: TossSpacing.space5),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: TossColors.gray200, width: TossDimensions.dividerThickness),
        ),
      ),
      child: Column(
        children: locations.map((location) {
          final isSelected = selectedLocation?.id == location.id;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              ref
                  .read(paymentMethodNotifierProvider.notifier)
                  .selectCashLocation(location);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      location.name,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: TossFontWeight.medium,
                        color: TossColors.gray900,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: TossSpacing.iconLG,
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: TossSpacing.iconMD2,
                            color: TossColors.primary,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
