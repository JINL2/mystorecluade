import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

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
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: TossColors.gray900.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Avatar
          Center(
            child: ProfileAvatarSection(
              profile: profile,
              temporaryImageUrl: temporaryImageUrl,
              onAvatarTap: onAvatarTap,
            ),
          ),

          SizedBox(height: TossSpacing.space6),

          // Name
          Text(
            _getDisplayName(profile),
            style: TossTextStyles.h2.copyWith(
              fontWeight: FontWeight.w800,
              color: TossColors.gray900,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: TossSpacing.space3),

          // Role badge
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              ),
              child: Text(
                businessData?.userRole ?? profile.displayRole,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: TossSpacing.space4),

          // Company info
          if (businessData?.companyName.isNotEmpty == true)
            Text(
              businessData!.companyName,
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

          if (businessData?.storeName.isNotEmpty == true) ...[
            SizedBox(height: TossSpacing.space1),
            Text(
              businessData!.storeName,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
