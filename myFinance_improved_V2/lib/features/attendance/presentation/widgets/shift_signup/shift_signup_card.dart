import 'package:flutter/material.dart';
import '../../../../../shared/themes/index.dart';
import '../../../domain/entities/shift_signup_status.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

// Re-export for backward compatibility (prevents DCM false positive)
export '../../../domain/entities/shift_signup_status.dart';

/// ShiftSignupCard - Card showing shift details with action button
///
/// Design Specs (from provided Flutter code):
/// - Card background: White (default), gray50 for waitlist only
/// - Left: Shift info (type, time, location, applied/assigned count)
/// - Right: Action button + slots count
///
/// 5 Variations:
/// 1. Available: White card, blue "Apply" button, "0/3 assigned"
/// 2. Available + Applied: White card, blue "Apply" button, "1 applied", "0/3 assigned"
/// 3. Waitlist (Full): Gray card, gray "Waitlist" button, "4/4 assigned"
/// 4. Applied (User): White card, blue outline "Withdraw" button, "You applied", "1/3 assigned"
/// 5. Assigned: White card, gray "Assigned" badge, "3/3 assigned"
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
  final VoidCallback? onWaitlist;
  final VoidCallback? onLeaveWaitlist;
  final VoidCallback? onWithdraw;
  final VoidCallback? onTap; // Tap entire card
  final VoidCallback? onViewAppliedUsers; // Tap avatar stack to view applied users
  final bool isLoading; // Loading state to show spinner and disable button

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
    this.onWaitlist,
    this.onLeaveWaitlist,
    this.onWithdraw,
    this.onTap,
    this.onViewAppliedUsers,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // All cards use white background
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Shift information - tappable area for bottom sheet
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onViewAppliedUsers,
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

                  // Always show applied count with avatars (if any applicants exist)
                  // Show regardless of user's own application status
                  if (appliedCount > 0 || (assignedUserAvatars != null && assignedUserAvatars!.isNotEmpty)) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Avatar stack for applied users (always show if available)
                        if (assignedUserAvatars != null && assignedUserAvatars!.isNotEmpty) ...[
                          _buildAvatarStackWithoutGesture(assignedUserAvatars!),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '$appliedCount applied',
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
          ),

          const SizedBox(width: 12),

          // Right side: Action button + slots count (NOT tappable for bottom sheet)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(),
              const SizedBox(height: 4),
              Text(
                // Always show "X/Y assigned" - filledSlots = approved employees count
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
    );
  }

  Widget _buildActionButton() {
    switch (status) {
      case ShiftSignupStatus.available:
        // Blue filled button: "+ Apply"
        return TossButton.primary(
          text: 'Apply',
          onPressed: isLoading ? null : onApply,
          isLoading: isLoading,
          leadingIcon: isLoading ? null : const Icon(Icons.add, size: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );

      case ShiftSignupStatus.applied:
        // Blue outline button: "- Withdraw"
        return TossButton.outlined(
          text: 'Withdraw',
          onPressed: isLoading ? null : onWithdraw,
          isLoading: isLoading,
          leadingIcon: isLoading ? null : const Icon(Icons.remove, size: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );

      case ShiftSignupStatus.waitlist:
        // Gray filled button: "+ Waitlist"
        return TossButton.secondary(
          text: 'Waitlist',
          onPressed: isLoading ? null : onWaitlist,
          isLoading: isLoading,
          leadingIcon: isLoading ? null : const Icon(Icons.add, size: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );

      case ShiftSignupStatus.onWaitlist:
        // Gray filled button: "- Leave"
        return TossButton.secondary(
          text: 'Leave',
          onPressed: isLoading ? null : onLeaveWaitlist,
          isLoading: isLoading,
          leadingIcon: isLoading ? null : const Icon(Icons.remove, size: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fontSize: 14,
        );

      case ShiftSignupStatus.assigned:
        // Gray badge (non-interactive): "Assigned"
        return TossButton.secondary(
          text: 'Assigned',
          onPressed: null, // Disabled - non-interactive badge
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fontSize: 14,
        );
    }
  }

  /// Build avatar stack without gesture (used when parent row handles tap)
  Widget _buildAvatarStackWithoutGesture(List<String> avatars) {
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
              child: avatars[index].isNotEmpty
                ? CircleAvatar(
                    radius: 12,
                    backgroundColor: TossColors.gray200,
                    backgroundImage: NetworkImage(avatars[index]),
                  )
                : CircleAvatar(
                    radius: 12,
                    backgroundColor: TossColors.gray200,
                    child: const Icon(Icons.person, size: 12, color: TossColors.gray500),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
