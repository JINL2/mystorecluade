// lib/features/cash_ending/presentation/widgets/sheets/cash_ending_selection_helpers.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_icons.dart';
import '../../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../domain/entities/location.dart';
import '../../../domain/entities/store.dart';
import '../../providers/cash_ending_provider.dart';

/// Cash Ending feature bottom sheet helpers using shared TossSelectionBottomSheet
///
/// These helpers provide Cash Ending-specific styling to match the original design:
/// - Selected font weight: w700 (vs default w600)
/// - Unselected font weight: w500 (vs default w400)
/// - Unselected icon color: gray500 (vs default gray600)
/// - Border width: 0.5 (vs default 1.0)
/// - Check icon: TossIcons.check (vs default circleCheck)
/// - Haptic feedback: enabled

class CashEndingSelectionHelpers {
  /// Show store selector bottom sheet with Cash Ending styling
  static Future<void> showStoreSelector({
    required BuildContext context,
    required WidgetRef ref,
    required List<Store> stores,
    required String? selectedStoreId,
    required String companyId,
  }) async {
    // Prepare items: Headquarter + Stores
    final items = <TossSelectionItem>[
      // Headquarter item
      TossSelectionItem(
        id: 'headquarter',
        title: 'Headquarter',
        subtitle: 'Company Level',
        icon: TossIcons.business,
      ),
      // Store items
      ...stores.map((store) => TossSelectionItem(
            id: store.storeId,
            title: store.storeName,
            subtitle: store.storeCode,
            icon: TossIcons.store,
          )),
    ];

    await TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Select Store',
      items: items,
      selectedId: selectedStoreId,
      // Cash Ending styling
      selectedFontWeight: FontWeight.w700,
      unselectedFontWeight: FontWeight.w500,
      unselectedIconColor: TossColors.gray500,
      borderBottomWidth: 0.5,
      checkIcon: TossIcons.check,
      enableHapticFeedback: true,
      onItemSelected: (item) async {
        // Update selected store
        ref.read(cashEndingProvider.notifier).setSelectedStore(item.id);

        // Load locations for all tabs
        await Future.wait([
          ref.read(cashEndingProvider.notifier).loadLocations(
                companyId: companyId,
                locationType: 'cash',
                storeId: item.id,
              ),
          ref.read(cashEndingProvider.notifier).loadLocations(
                companyId: companyId,
                locationType: 'bank',
                storeId: item.id,
              ),
          ref.read(cashEndingProvider.notifier).loadLocations(
                companyId: companyId,
                locationType: 'vault',
                storeId: item.id,
              ),
        ]);
      },
    );
  }

  /// Show location selector bottom sheet with Cash Ending styling
  static Future<void> showLocationSelector({
    required BuildContext context,
    required WidgetRef ref,
    required String locationType,
    required List<Location> locations,
    required String? selectedLocationId,
  }) async {
    if (locations.isEmpty) {
      return;
    }

    // Prepare items from locations
    final items = locations.map((location) {
      return TossSelectionItem(
        id: location.locationId,
        title: location.locationName,
        subtitle: _getLocationSubtitle(location, locationType),
        icon: _getLocationIcon(locationType),
      );
    }).toList();

    await TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Select ${_getLocationTypeLabel(locationType)}',
      items: items,
      selectedId: selectedLocationId,
      // Cash Ending styling
      selectedFontWeight: FontWeight.w700,
      unselectedFontWeight: FontWeight.w500,
      unselectedIconColor: TossColors.gray500,
      borderBottomWidth: 0.5,
      checkIcon: TossIcons.check,
      enableHapticFeedback: true,
      onItemSelected: (item) {
        // Update selected location based on type
        switch (locationType) {
          case 'cash':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedCashLocation(item.id);
            break;
          case 'bank':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedBankLocation(item.id);
            // If bank location has fixed currency, update it
            final location = locations.firstWhere((loc) => loc.locationId == item.id);
            if (location.currencyId != null && location.currencyId!.isNotEmpty) {
              ref
                  .read(cashEndingProvider.notifier)
                  .setSelectedBankCurrency(location.currencyId);
            }
            break;
          case 'vault':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedVaultLocation(item.id);
            break;
        }
      },
    );
  }

  static String _getLocationTypeLabel(String locationType) {
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

  static IconData _getLocationIcon(String locationType) {
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

  static String? _getLocationSubtitle(Location location, String locationType) {
    // Show currency for bank/vault if has fixed currency
    if ((locationType == 'bank' || locationType == 'vault') &&
        location.currencyId != null &&
        location.currencyId!.isNotEmpty) {
      return 'Currency: ${location.currencyId}';
    }
    return null;
  }
}
