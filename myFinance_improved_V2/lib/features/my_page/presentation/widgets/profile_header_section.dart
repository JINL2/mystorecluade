import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';

import '../../domain/entities/business_dashboard.dart';
import '../../domain/entities/user_profile.dart';
import 'profile_avatar_section.dart';

class ProfileHeaderSection extends StatelessWidget {
  final UserProfile profile;
  final BusinessDashboard? businessData;
  final String? temporaryImageUrl;
  final VoidCallback onAvatarTap;

  const ProfileHeaderSection({
    super.key,
    required this.profile,
    this.businessData,
    this.temporaryImageUrl,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: TossColors.gray900.withValues(alpha: TossOpacity.subtle),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar on left
          ProfileAvatarSection(
            profile: profile,
            temporaryImageUrl: temporaryImageUrl,
            onAvatarTap: onAvatarTap,
          ),

          const SizedBox(width: TossSpacing.space4),

          // Info on right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name
                Text(
                  _getDisplayName(profile),
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: TossFontWeight.bold,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: TossSpacing.space1),

                // Role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: TossOpacity.hover),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    businessData?.userRole ?? profile.displayRole,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),

                // Company info
                if (businessData?.companyName.isNotEmpty == true) ...[
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    businessData!.companyName,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                      fontWeight: TossFontWeight.medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                if (businessData?.storeName.isNotEmpty == true) ...[
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    businessData!.storeName,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayName(UserProfile profile) {
    // If we have first name or last name, use fullName (which combines them)
    if ((profile.firstName?.isNotEmpty == true) || (profile.lastName?.isNotEmpty == true)) {
      return profile.fullName;
    }

    // If no names available, extract name from email or use 'User'
    final email = profile.email;
    if (email.isNotEmpty) {
      // Try to extract a reasonable name from email (e.g., "john.doe@example.com" → "John Doe")
      final localPart = email.split('@').first;
      if (localPart.contains('.')) {
        final parts = localPart.split('.');
        return parts.map((part) => part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1)).join(' ');
      } else if (localPart.contains('_')) {
        final parts = localPart.split('_');
        return parts.map((part) => part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1)).join(' ');
      } else {
        // Single word email, capitalize it
        return localPart.isEmpty ? 'User' : localPart[0].toUpperCase() + localPart.substring(1);
      }
    }

    return 'User';
  }
}
