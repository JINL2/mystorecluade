import 'package:flutter/material.dart';

import '../../../../../../../core/constants/ui_constants.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_icons.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../widgets/common/toss_loading_view.dart';
import '../../../../../widgets/toss/toss_card.dart';

/// Location selector widget for Cash Ending page
/// Updated to use bottom sheet pattern like StoreSelector
class LocationSelector extends StatelessWidget {
  final String locationType;
  final bool isLoading;
  final List<Map<String, dynamic>> locations;
  final String? selectedLocation;
  final List<Map<String, dynamic>> currencyTypes;
  final VoidCallback onTap;

  const LocationSelector({
    super.key,
    required this.locationType,
    required this.isLoading,
    required this.locations,
    required this.selectedLocation,
    required this.currencyTypes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _buildLocationSelector();
  }

  Widget _buildLocationSelector() {
    // If loading
    if (isLoading) {
      return const TossCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        backgroundColor: TossColors.gray50,
        child: Center(
          child: TossLoadingView(),
        ),
      );
    }
    
    // If no locations available
    if (locations.isEmpty) {
      return TossCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        backgroundColor: TossColors.gray50,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_off,
                color: TossColors.gray500,
                size: 24,
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'No $locationType locations available for this store',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    // Get selected location name
    String locationName = _getLocationDisplayName();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getLocationTypeLabel(),
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (selectedLocation != null) ...[
                  Container(
                    width: UIConstants.avatarSizeSmall,
                    height: UIConstants.avatarSizeSmall,
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Icon(
                      _getLocationIcon(),
                      size: UIConstants.iconSizeMedium,
                      color: TossColors.primary,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                ],
                Expanded(
                  child: Text(
                    locationName,
                    style: TossTextStyles.body.copyWith(
                      color: selectedLocation != null ? TossColors.gray900 : TossColors.gray500,
                      fontWeight: selectedLocation != null ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                const Icon(
                  TossIcons.forward,
                  color: TossColors.gray400,
                  size: UIConstants.iconSizeLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getLocationDisplayName() {
    if (selectedLocation == null) {
      return 'Select ${_getLocationTypeLabel()}';
    }
    
    try {
      final location = locations.firstWhere(
        (l) => _getLocationId(l) == selectedLocation,
      );
      final locationName = location['location_name']?.toString() ?? 'Unknown Location';
      
      // Check if location has fixed currency and add it to display
      final locationCurrencyId = location['currency_id']?.toString();
      if ((locationType == 'bank' || locationType == 'vault') && 
          locationCurrencyId != null && 
          locationCurrencyId.isNotEmpty) {
        final currency = currencyTypes.firstWhere(
          (c) => c['currency_id']?.toString() == locationCurrencyId,
          orElse: () => {},
        );
        final currencyCode = currency['currency_code']?.toString();
        if (currencyCode != null) {
          return '$locationName ($currencyCode)';
        }
      }
      
      return locationName;
    } catch (e) {
      return 'Select ${_getLocationTypeLabel()}';
    }
  }

  String _getLocationId(Map<String, dynamic> location) {
    return location['cash_location_id']?.toString() ?? 
           location['bank_location_id']?.toString() ?? 
           location['vault_location_id']?.toString() ?? 
           location['id']?.toString() ?? 
           location['location_id']?.toString() ?? 
           '';
  }

  String _getLocationTypeLabel() {
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

  IconData _getLocationIcon() {
    switch (locationType) {
      case 'cash':
        return TossIcons.wallet;
      case 'bank':
        return TossIcons.bank;
      case 'vault':
        return TossIcons.lock; // Using lock icon for vault
      default:
        return TossIcons.location;
    }
  }

}