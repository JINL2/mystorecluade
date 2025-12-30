/// Cash Location Tabs
///
/// Tab bar for switching between Company and Store views.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Scope tabs widget for Company/Store selection
class CashLocationScopeTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const CashLocationScopeTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          _buildTabButton(0, 'Company', Icons.business),
          Container(width: 1, height: TossSpacing.space6, color: TossColors.gray200),
          _buildTabButton(1, 'Store', Icons.store),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTabChanged(index),
        borderRadius: BorderRadius.horizontal(
          left: index == 0 ? const Radius.circular(11) : Radius.zero,
          right: index == 1 ? const Radius.circular(11) : Radius.zero,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          decoration: BoxDecoration(
            color: isSelected ? TossColors.white : TossColors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: index == 0 ? const Radius.circular(11) : Radius.zero,
              right: index == 1 ? const Radius.circular(11) : Radius.zero,
            ),
            border: isSelected ? Border.all(color: TossColors.primary) : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: TossSpacing.iconXS,
                  color: isSelected ? TossColors.primary : TossColors.gray500,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  label,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
