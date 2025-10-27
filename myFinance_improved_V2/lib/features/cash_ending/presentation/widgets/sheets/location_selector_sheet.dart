// lib/features/cash_ending/presentation/widgets/sheets/location_selector_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_icons.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/location.dart';
import '../../providers/cash_ending_provider.dart';

/// Location selector bottom sheet
///
/// Displays a list of locations to select from (Cash/Bank/Vault)
class LocationSelectorSheet extends ConsumerWidget {
  final String locationType; // 'cash', 'bank', 'vault'
  final List<Location> locations;
  final String? selectedLocationId;

  const LocationSelectorSheet({
    super.key,
    required this.locationType,
    required this.locations,
    required this.selectedLocationId,
  });

  /// Show location selector bottom sheet
  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required String locationType,
    required List<Location> locations,
    required String? selectedLocationId,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LocationSelectorSheet(
        locationType: locationType,
        locations: locations,
        selectedLocationId: selectedLocationId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Text(
                  'Select ${_getLocationTypeLabel()}',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Location list
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: locations.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final location = locations[index];
                      final isSelected =
                          selectedLocationId == location.locationId;

                      return _buildLocationItem(
                        context,
                        ref,
                        location: location,
                        isSelected: isSelected,
                        isLast: index == locations.length - 1,
                      );
                    },
                  ),
          ),

          // Bottom padding
          const SizedBox(height: TossSpacing.space5),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            TossIcons.locationOff,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'No ${_getLocationTypeLabel()} locations available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(
    BuildContext context,
    WidgetRef ref, {
    required Location location,
    required bool isSelected,
    required bool isLast,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);

        // Update selected location based on type
        switch (locationType) {
          case 'cash':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedCashLocation(location.locationId);
            break;
          case 'bank':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedBankLocation(location.locationId);
            // If bank location has fixed currency, update it
            if (location.currencyId != null &&
                location.currencyId!.isNotEmpty) {
              ref
                  .read(cashEndingProvider.notifier)
                  .setSelectedBankCurrency(location.currencyId);
            }
            break;
          case 'vault':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedVaultLocation(location.locationId);
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TossColors.gray100,
              width: isLast ? 0 : 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primarySurface
                    : TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                _getLocationIcon(),
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray500,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.locationName,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  // Show currency for bank/vault if has fixed currency
                  if ((locationType == 'bank' || locationType == 'vault') &&
                      location.currencyId != null &&
                      location.currencyId!.isNotEmpty)
                    Text(
                      'Currency: ${location.currencyId}', // TODO: Show currency code
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                TossIcons.check,
                size: 20,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  String _getLocationTypeLabel() {
    switch (locationType) {
      case 'cash':
        return 'Cash Location';
      case 'bank':
        return 'Bank Account';
      case 'vault':
        return 'Vault Location';
      default:
        return 'Location';
    }
  }

  IconData _getLocationIcon() {
    switch (locationType) {
      case 'cash':
        return TossIcons.wallet;
      case 'bank':
        return TossIcons.bank;
      case 'vault':
        return TossIcons.lock;
      default:
        return TossIcons.location;
    }
  }
}
