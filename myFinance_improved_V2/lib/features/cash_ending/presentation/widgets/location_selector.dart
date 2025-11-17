// lib/features/cash_ending/presentation/widgets/location_selector.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../domain/entities/location.dart';

/// Location selector widget
///
/// Displays a button to select location based on location type
class LocationSelector extends StatelessWidget {
  final String locationType; // 'cash', 'bank', 'vault'
  final bool isLoading;
  final List<Location> locations;
  final String? selectedLocationId;
  final VoidCallback onTap;

  const LocationSelector({
    super.key,
    required this.locationType,
    required this.isLoading,
    required this.locations,
    required this.selectedLocationId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: const Center(
          child: TossLoadingView(),
        ),
      );
    }

    if (locations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                TossIcons.locationOff,
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
    String locationName = 'Select ${_getLocationTypeLabel()}';
    if (selectedLocationId != null) {
      try {
        final location = locations.firstWhere(
          (loc) => loc.locationId == selectedLocationId,
        );
        locationName = location.locationName;
      } catch (e) {
        locationName = 'Select ${_getLocationTypeLabel()}';
      }
    }

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
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    locationName,
                    style: TossTextStyles.labelLarge.copyWith(
                      color: selectedLocationId != null ? TossColors.gray900 : TossColors.gray500,
                    ),
                  ),
                ),
                const Icon(
                  TossIcons.forward,
                  color: TossColors.gray400,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
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
