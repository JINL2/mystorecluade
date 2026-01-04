import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Empty state widget for when user has no shifts
/// Includes optional store selector for multi-store users
/// Extracted from MyScheduleTab._buildEmptyStateOnly
class ScheduleEmptyState extends StatelessWidget {
  final List<Map<String, dynamic>> stores;
  final String? selectedStoreId;
  final void Function(String)? onStoreChanged;
  final VoidCallback onGoToShiftSignUp;

  const ScheduleEmptyState({
    super.key,
    required this.stores,
    this.selectedStoreId,
    this.onStoreChanged,
    required this.onGoToShiftSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Store Selector (only if more than 1 store)
        if (stores.length > 1)
          Container(
            color: TossColors.white,
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space4,
              TossSpacing.space3,
              TossSpacing.space4,
              0,
            ),
            child: TossDropdown<String>(
              label: 'Store',
              value: selectedStoreId,
              items: stores.map((store) {
                return TossDropdownItem<String>(
                  value: store['store_id']?.toString() ?? '',
                  label: store['store_name']?.toString() ?? 'Unknown',
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onStoreChanged?.call(newValue);
                }
              },
            ),
          ),
        // Empty state content
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: TossColors.gray400,
                  size: 48,
                ),
                const SizedBox(height: TossSpacing.space3),
                Text(
                  'You have no shift',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TossSpacing.space1),
                TossButton.textButton(
                  text: 'Go to shift sign up',
                  onPressed: onGoToShiftSignUp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
