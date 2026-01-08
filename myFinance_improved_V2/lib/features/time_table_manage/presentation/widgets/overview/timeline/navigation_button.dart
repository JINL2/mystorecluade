import 'package:flutter/material.dart';

import '../../../../../../shared/themes/index.dart';

/// Navigation direction for timeline buttons
enum NavigationDirection { previous, next }

/// Navigation button (< 7 more) or (5 more >)
class NavigationButton extends StatelessWidget {
  final int count;
  final NavigationDirection direction;
  final VoidCallback? onTap;

  const NavigationButton({
    super.key,
    required this.count,
    required this.direction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = count > 0 && onTap != null;
    final color = isEnabled ? TossColors.gray600 : TossColors.gray300;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: TossSpacing.icon3XL,
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (direction == NavigationDirection.previous) ...[
              Icon(Icons.chevron_left, size: TossSpacing.iconMD, color: color),
              if (count > 0)
                Text(
                  '$count',
                  style: TossTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
            ] else ...[
              Icon(Icons.chevron_right, size: TossSpacing.iconMD, color: color),
              if (count > 0)
                Text(
                  '$count',
                  style: TossTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
