import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

/// Calendar icon button with notification badge for unsolved problems
/// Extracted from MyScheduleTab._buildCalendarIconWithBadge
class CalendarIconWithBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int badgeCount;
  final VoidCallback onPressed;
  final String tooltip;

  const CalendarIconWithBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.badgeCount,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          tooltip: tooltip,
        ),
        // Badge with problem count
        if (badgeCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space1),
              decoration: const BoxDecoration(
                color: TossColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                badgeCount > 99 ? '99+' : '$badgeCount',
                style: TossTextStyles.labelSmall.copyWith(
                  color: TossColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
