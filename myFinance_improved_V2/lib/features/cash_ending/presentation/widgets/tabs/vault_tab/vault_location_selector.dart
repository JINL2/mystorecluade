// lib/features/cash_ending/presentation/widgets/tabs/vault_tab/vault_location_selector.dart

import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_icons.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/location.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Vault location selector widget
///
/// Shows dropdown for selecting vault location or empty state if none available
class VaultLocationSelector extends StatelessWidget {
  final List<Location> vaultLocations;
  final String? selectedLocationId;
  final ValueChanged<String?> onLocationChanged;
  final bool isLoading;

  const VaultLocationSelector({
    super.key,
    required this.vaultLocations,
    this.selectedLocationId,
    required this.onLocationChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (vaultLocations.isEmpty) {
      return _buildEmptyState();
    }

    return TossDropdown<String>(
      label: 'Vault Location',
      hint: 'Select Vault Location',
      value: selectedLocationId,
      isLoading: isLoading,
      items: vaultLocations
          .map(
            (location) => TossDropdownItem<String>(
              value: location.locationId,
              label: location.locationName,
            ),
          )
          .toList(),
      onChanged: onLocationChanged,
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray300, width: 1),
      ),
      child: Row(
        children: [
          const Icon(TossIcons.lock, size: 20, color: TossColors.gray400),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vault Location',
                  style: TossTextStyles.smallSectionTitle,
                ),
                SizedBox(height: TossSpacing.space1 / 2),
                Text(
                  'No vault locations available',
                  style: TossTextStyles.emptyState,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
