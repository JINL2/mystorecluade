import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_button_1.dart';

/// Shift signup status determining the action button state
enum ShiftSignupStatus {
  available, // Can apply - shows blue "+ Apply" button
  applied, // Already applied - shows blue outline "- Withdraw" button
  assigned, // Already assigned - shows gray "Assigned" badge
}

/// ShiftSignupCard - Card showing shift details with action button
///
/// Design Specs (from provided Flutter code):
/// - Card background: White
/// - Left: Shift info (type, time, location, applied/assigned count)
/// - Right: Action button + slots count
///
/// 3 Variations:
/// 1. Available: White card, blue "Apply" button, "0/3 applied"
/// 2. Applied (User): White card, blue outline "Withdraw" button, "You applied", "1/3 applied"
/// 3. Assigned: White card, gray "Assigned" badge, "3/3 assigned"
class ShiftSignupCard extends StatelessWidget {
  final String shiftType; // "Morning", "Afternoon", "Night"
  final String timeRange; // "09:00 - 13:00"
  final String location; // "Downtown Store"
  final ShiftSignupStatus status;
  final int filledSlots; // Currently assigned count
  final int totalSlots; // Total capacity
  final int appliedCount; // Number of people who applied (not assigned yet)
  final bool userApplied; // Whether current user has applied
  final List<String>? assignedUserAvatars; // Avatar URLs (max 4) - for assigned status
  final VoidCallback? onApply;
  final VoidCallback? onWithdraw;
  final VoidCallback? onTap; // Tap entire card
  final VoidCallback? onViewAppliedUsers; // Tap avatar stack to view applied users

  const ShiftSignupCard({
    super.key,
    required this.shiftType,
    required this.timeRange,
    required this.location,
    required this.status,
    required this.filledSlots,
    required this.totalSlots,
    this.appliedCount = 0,
    this.userApplied = false,
    this.assignedUserAvatars,
    this.onApply,
    this.onWithdraw,
    this.onTap,
    this.onViewAppliedUsers,
  });

  @override
  Widget build(BuildContext context) {
    // All cards use white background
    return GestureDetector(
      onTap: onViewAppliedUsers ?? onTap,
      child: Container(
        decoration: BoxDecoration(
          color: TossColors.white,
          border: Border.all(color: TossColors.gray100, width: 1),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Shift information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shift name (h3)
                  Text(
                    shiftType,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Time with clock icon
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: TossColors.gray700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeRange,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Location
                  Text(
                    location,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Applied/Assigned count - ALWAYS show when there are users
                  if (assignedUserAvatars != null && assignedUserAvatars!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Avatar stack (always visible when avatars available)
                        _buildAvatarStack(assignedUserAvatars!),
                        const SizedBox(width: 8),
                        Text(
                          userApplied
                            ? 'You applied'
                            : '$appliedCount applied',
                          style: TossTextStyles.labelSmall.copyWith(
                            color: TossColors.gray600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right side: Action button + slots count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(),
                const SizedBox(height: 4),
                Text(
                  // ONLY show assigned count on right side
                  '$filledSlots/$totalSlots assigned',
                  style: TossTextStyles.labelSmall.copyWith(
                    color: TossColors.gray500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    switch (status) {
      case ShiftSignupStatus.available:
        // Blue filled button: "+ Apply"
        return TossButton1.primary(
          text: 'Apply',
          onPressed: onApply,
          leadingIcon: const Icon(Icons.add, size: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );

      case ShiftSignupStatus.applied:
        // Blue outline button: "- Withdraw"
        return TossButton1.outlined(
          text: 'Withdraw',
          onPressed: onWithdraw,
          leadingIcon: const Icon(Icons.remove, size: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );

      case ShiftSignupStatus.assigned:
        // Gray badge (non-interactive): "Assigned"
        return TossButton1.secondary(
          text: 'Assigned',
          onPressed: null, // Disabled - non-interactive badge
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fontSize: 14,
        );
    }
  }

  /// Build avatar stack
  Widget _buildAvatarStack(List<String> avatars) {
    return SizedBox(
      height: 24,
      width: (avatars.length * 18).toDouble() + 6,
      child: Stack(
        children: List.generate(
          avatars.length.clamp(0, 4),
          (index) => Positioned(
            left: index * 18.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: TossColors.white, width: 1),
              ),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: TossColors.gray200,
                backgroundImage: NetworkImage(avatars[index]),
                onBackgroundImageError: (_, __) {},
                child: const Icon(Icons.person, size: 12, color: TossColors.gray500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
