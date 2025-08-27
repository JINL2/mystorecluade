import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';

/// Toss-style notification icon with optional badge
class TossNotificationIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool showBadge;
  final int? badgeCount;
  final Color? iconColor;
  
  const TossNotificationIcon({
    super.key,
    this.onPressed,
    this.showBadge = false,
    this.badgeCount,
    this.iconColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: iconColor ?? TossColors.textSecondary,
            size: TossSpacing.iconLG,
          ),
          onPressed: onPressed,
        ),
        if (showBadge || (badgeCount != null && badgeCount! > 0))
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: badgeCount != null 
                ? EdgeInsets.all(TossSpacing.space0 + 2)
                : null,
              constraints: BoxConstraints(
                minWidth: badgeCount != null ? 16 : 8,
                minHeight: badgeCount != null ? 16 : 8,
              ),
              decoration: BoxDecoration(
                color: TossColors.error,
                shape: BoxShape.circle,
              ),
              child: badgeCount != null
                ? Center(
                    child: Text(
                      badgeCount! > 99 ? '99+' : badgeCount.toString(),
                      style: TextStyle(
                        color: TossColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : null,
            ),
          ),
      ],
    );
  }
}