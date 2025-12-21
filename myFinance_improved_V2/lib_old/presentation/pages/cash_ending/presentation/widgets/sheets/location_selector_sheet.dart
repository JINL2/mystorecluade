import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../../../core/themes/toss_icons.dart';
import '../../../../../../../core/constants/ui_constants.dart';

/// Location selector bottom sheet for Cash Ending page
/// Consistent with StoreSelectorSheet structure
class LocationSelectorSheet {
  
  /// Show location selector bottom sheet
  static void showLocationSelector({
    required BuildContext context,
    required String locationType,
    required List<Map<String, dynamic>> locations,
    required String? selectedLocationId,
    required List<Map<String, dynamic>> currencyTypes,
    required Function(String locationId, Map<String, dynamic> location) onLocationSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
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
              width: UIConstants.modalDragHandleWidth,
              height: UIConstants.modalDragHandleHeight,
              decoration: BoxDecoration(
                color: TossColors.gray600,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  Text(
                    'Select ${_getLocationTypeLabel(locationType)}',
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
                  ? _buildEmptyState(locationType)
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        final locationId = _getLocationId(location);
                        final locationName = location['location_name']?.toString() ?? 'Unknown Location';
                        final isSelected = selectedLocationId == locationId;
                        
                        // Check if location has fixed currency
                        final locationCurrencyId = location['currency_id']?.toString();
                        final hasFixedCurrency = (locationType == 'bank' || locationType == 'vault') && 
                                                locationCurrencyId != null && 
                                                locationCurrencyId.isNotEmpty;
                        
                        String? currencyCode;
                        if (hasFixedCurrency) {
                          final currency = currencyTypes.firstWhere(
                            (c) => c['currency_id']?.toString() == locationCurrencyId,
                            orElse: () => {},
                          );
                          currencyCode = currency['currency_code']?.toString();
                        }
                        
                        return InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.pop(context);
                            onLocationSelected(locationId, location);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space5,
                              vertical: TossSpacing.space4,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: TossColors.gray100,
                                  width: index == locations.length - 1 ? 0 : 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray50,
                                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                  ),
                                  child: Icon(
                                    _getLocationIcon(locationType),
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
                                        locationName,
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.gray900,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        ),
                                      ),
                                      if (hasFixedCurrency && currencyCode != null)
                                        Text(
                                          'Currency: $currencyCode',
                                          style: TossTextStyles.caption.copyWith(
                                            color: TossColors.gray500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    size: 20,
                                    color: TossColors.primary,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  /// Build empty state widget
  static Widget _buildEmptyState(String locationType) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 48,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No $locationType locations available',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get location ID from location map
  static String _getLocationId(Map<String, dynamic> location) {
    return location['cash_location_id']?.toString() ?? 
           location['bank_location_id']?.toString() ?? 
           location['vault_location_id']?.toString() ?? 
           location['id']?.toString() ?? 
           location['location_id']?.toString() ?? 
           '';
  }

  /// Get location type label
  static String _getLocationTypeLabel(String locationType) {
    switch (locationType) {
      case 'cash':
        return 'Cash Location';
      case 'bank':
        return 'Bank Location';
      case 'vault':
        return 'Vault Location';
      default:
        return 'Location';
    }
  }

  /// Get icon for location type
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
}