import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../extensions/cash_location_extension.dart';
import '../../../providers/payment_providers.dart';
import '../helpers/payment_helpers.dart';

/// Bottom sheet for selecting cash location
class CashLocationBottomSheet extends StatelessWidget {
  final List<CashLocation> locations;
  final WidgetRef ref;

  const CashLocationBottomSheet({
    super.key,
    required this.locations,
    required this.ref,
  });

  /// Show the cash location selection bottom sheet
  static void show(
    BuildContext context,
    WidgetRef ref,
    List<CashLocation> locations,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.lg),
        ),
      ),
      builder: (context) => CashLocationBottomSheet(
        locations: locations,
        ref: ref,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: TossSpacing.space3),
          ...locations.map((location) => _buildLocationItem(context, location)),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Select Cash Location',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.close,
            color: TossColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationItem(BuildContext context, CashLocation location) {
    return InkWell(
      onTap: () {
        ref.read(paymentMethodProvider.notifier).selectCashLocation(location);
        context.pop();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(TossSpacing.space3),
        margin: const EdgeInsets.only(bottom: TossSpacing.space2),
        decoration: BoxDecoration(
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          children: [
            PaymentHelpers.getCashLocationIcon(location.type),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.displayName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  _buildLocationTypeBadge(location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTypeBadge(CashLocation location) {
    // Get badge color based on location type
    Color badgeColor;
    if (location.isBank) {
      badgeColor = TossColors.primary;
    } else if (location.isVault) {
      badgeColor = TossColors.warning;
    } else {
      badgeColor = TossColors.success;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space2,
            vertical: TossSpacing.space1,
          ),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
          child: Text(
            location.displayType,
            style: TossTextStyles.caption.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
