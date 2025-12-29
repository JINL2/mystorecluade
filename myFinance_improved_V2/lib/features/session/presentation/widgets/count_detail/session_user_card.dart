import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'session_user_model.dart';

/// Session user card widget for count detail page
class SessionUserCard extends StatelessWidget {
  final SessionUser user;
  final bool isCurrentUser;
  final VoidCallback? onTap;

  const SessionUserCard({
    super.key,
    required this.user,
    required this.isCurrentUser,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCurrentUser ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrentUser ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Profile image + User name
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User profile image
                _buildUserProfileImage(user.userProfileImage),
                const SizedBox(width: TossSpacing.space2),
                // User name
                Expanded(
                  child: Text(
                    user.userName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            // Details section
            Column(
              children: [
                _buildDetailRow('Items', '${user.itemsCount}'),
                const SizedBox(height: TossSpacing.space2),
                _buildDetailRow('Quantity', '${user.quantity}'),
                const SizedBox(height: TossSpacing.space2),
                _buildDetailRow(
                  'Started',
                  _formatShortDateTime(DateTime.now()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileImage(String? profileImageUrl) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: TossColors.gray100,
        image: profileImageUrl != null && profileImageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(profileImageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: profileImageUrl == null || profileImageUrl.isEmpty
          ? const Icon(
              Icons.person,
              color: TossColors.gray400,
              size: 12,
            )
          : null,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ),
        Text(
          value,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatShortDateTime(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$month $day, $year · $hour:$minute';
  }
}
