import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Segmented toggle button group - pill-shaped connected buttons
/// Similar to Week/Month toggle style with smooth animation
class ToggleButtonGroup extends StatelessWidget {
  final List<ToggleButtonItem> items;
  final String selectedId;
  final void Function(String) onToggle;
  final double height;

  const ToggleButtonGroup({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onToggle,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final isSelected = selectedId == item.id;

          return GestureDetector(
            onTap: () => onToggle(item.id),
            child: AnimatedContainer(
              duration: TossAnimations.normal,
              curve: TossAnimations.standard,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                color: isSelected ? TossColors.primary : TossColors.transparent,
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: TossSpacing.iconXS,
                        color: isSelected ? TossColors.white : TossColors.gray700,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                    ],
                    Text(
                      item.label,
                      style: TossTextStyles.body.copyWith(
                        color: isSelected ? TossColors.white : TossColors.gray700,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Data class for toggle button items
class ToggleButtonItem {
  final String id;
  final String label;
  final IconData? icon;

  const ToggleButtonItem({
    required this.id,
    required this.label,
    this.icon,
  });
}
