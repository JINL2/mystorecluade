import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../domain/entities/denomination.dart';
import '../../domain/entities/denomination_delete_result.dart';
import '../providers/currency_providers.dart';
import '../providers/denomination_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';

class DenominationGrid extends ConsumerWidget {
  final List<Denomination> denominations;

  const DenominationGrid({
    super.key,
    required this.denominations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Prevent scroll conflicts
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: TossSpacing.space2,
        crossAxisSpacing: TossSpacing.space2,
        childAspectRatio: 0.85, // More compact for 4 columns
      ),
      itemCount: denominations.length,
      itemBuilder: (context, index) => DenominationItem(
        denomination: denominations[index],
        onTap: () => _onDenominationTap(context, ref, denominations[index]),
        onLongPress: () => _onDenominationLongPress(context, ref, denominations[index]),
      ),
    );
  }

  void _onDenominationTap(BuildContext context, WidgetRef ref, Denomination denomination) {
    HapticFeedback.lightImpact();

    TossBottomSheet.show<void>(
      context: context,
      title: '${denomination.formattedValue} ${denomination.displayName}',
      content: _buildDenominationOptionsContent(context, ref, denomination),
    );
  }

  void _onDenominationLongPress(BuildContext context, WidgetRef ref, Denomination denomination) {
    // Show delete confirmation with haptic feedback
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Text(
          'Delete Denomination',
          style: TossTextStyles.h3,
        ),
        content: Text(
          'Are you sure you want to delete ${denomination.formattedValue} ${denomination.displayName}?',
          style: TossTextStyles.body,
        ),
        actions: [
          TossButton.textButton(
            text: 'Cancel',
            onPressed: () => context.pop(),
          ),
          TossButton.textButton(
            text: 'Delete',
            onPressed: () async {
              context.pop();
              await _removeDenominationWithRefresh(context, ref, denomination);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDenominationOptionsContent(BuildContext context, WidgetRef ref, Denomination denomination) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hint text
        Text(
          'Choose an action for this denomination',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // Options
        _buildOptionItem(
          context,
          icon: Icons.delete,
          title: 'Delete',
          isDestructive: true,
          onTap: () async {
            context.pop(); // Close the bottom sheet first
            await _removeDenominationWithRefresh(context, ref, denomination);
          },
        ),
      ],
    );
  }

  Future<void> _removeDenominationWithRefresh(BuildContext context, WidgetRef ref, Denomination denomination) async {
    HapticFeedback.lightImpact();

    try {
      final result = await ref.read(denominationOperationsProvider.notifier)
          .removeDenomination(denomination.id, denomination.currencyId);

      if (result.success) {
        // Refresh providers to get updated data
        ref.invalidate(denominationListProvider(denomination.currencyId));
        ref.invalidate(companyCurrenciesProvider);
        ref.invalidate(companyCurrenciesStreamProvider);
        ref.invalidate(searchFilteredCurrenciesProvider);
        ref.read(localDenominationListProvider.notifier).reset(denomination.currencyId);

        if (context.mounted) {
          await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.success(
              title: 'Success',
              message: '${denomination.formattedValue} denomination removed successfully!',
              primaryButtonText: 'OK',
            ),
          );
        }

        HapticFeedback.selectionClick();
      } else {
        // Show blocking locations error
        HapticFeedback.heavyImpact();
        if (context.mounted) {
          await _showBlockingLocationsDialog(context, denomination, result);
        }
      }
    } catch (e) {
      if (context.mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Failed to remove denomination: ${e.toString().replaceAll('Exception: ', '')}',
            primaryButtonText: 'OK',
          ),
        );
      }

      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _showBlockingLocationsDialog(
    BuildContext context,
    Denomination denomination,
    DenominationDeleteResult result,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: TossColors.error, size: TossSpacing.iconLG),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Cannot Delete',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cannot delete ${denomination.formattedValue} because money exists in the following locations:',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            // Blocking locations list
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  children: result.blockingLocations.map((location) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
                      padding: const EdgeInsets.all(TossSpacing.space3),
                      decoration: BoxDecoration(
                        color: TossColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        border: Border.all(color: TossColors.error.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getLocationIcon(location.locationType),
                            color: TossColors.error,
                            size: TossSpacing.iconMD,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.locationName,
                                  style: TossTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: TossColors.gray900,
                                  ),
                                ),
                                Text(
                                  location.reason,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(color: TossColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: TossColors.primary, size: TossSpacing.iconMD),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Please clear all money from these locations before deleting this denomination.',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TossButton.textButton(
            text: 'Understood',
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }

  IconData _getLocationIcon(String locationType) {
    switch (locationType) {
      case 'bank':
        return Icons.account_balance;
      case 'vault':
        return Icons.lock;
      case 'cashier':
        return Icons.point_of_sale;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: TossSpacing.iconLG,
              color: isDestructive ? TossColors.error : TossColors.gray700,
            ),
            const SizedBox(width: TossSpacing.space4),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  color: isDestructive ? TossColors.error : TossColors.gray900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DenominationItem extends StatelessWidget {
  final Denomination denomination;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const DenominationItem({
    super.key,
    required this.denomination,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress, // Keep long press on outer detector
      child: TossAnimatedWidget(
        enableTap: true,
        onTap: onTap, // Use TossAnimatedWidget's tap handling
        duration: TossAnimations.quick,
        curve: TossAnimations.standard,
        child: Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: TossColors.gray300,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Smaller emoji icon
              Text(
                denomination.emoji,
                style: TossTextStyles.body.copyWith(fontSize: TossSpacing.iconSM3),
              ),
              const SizedBox(height: TossSpacing.space1),
              
              // Value - more compact
              Text(
                denomination.formattedValue,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                  fontSize: TossSpacing.iconSM2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: TossSpacing.space1 / 2),
              
              // Simple type text - smaller
              Text(
                denomination.type == DenominationType.coin ? 'Coin' : 'Bill',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                  fontSize: TossSpacing.space2 + TossSpacing.space1 / 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}