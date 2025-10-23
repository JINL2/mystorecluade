import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_list_tile.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_section_header.dart';

class SettingsSection extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onNotifications;
  final VoidCallback onPrivacySecurity;
  final VoidCallback onSignOut;

  const SettingsSection({
    super.key,
    required this.onEditProfile,
    required this.onNotifications,
    required this.onPrivacySecurity,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
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
        children: [
          // Section Header - Using TossSectionHeader
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            child: TossSectionHeader(
              title: 'Settings',
              icon: Icons.settings,
              backgroundColor: TossColors.white,
              padding: EdgeInsets.all(TossSpacing.space4),
            ),
          ),

          // Settings Items
          TossListTile(
            title: 'Edit Profile',
            leading: Container(
              width: TossSpacing.space10,
              height: TossSpacing.space10,
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                Icons.person_outline,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: TossSpacing.iconSM,
            ),
            onTap: onEditProfile,
          ),

          TossListTile(
            title: 'Notifications',
            leading: Container(
              width: TossSpacing.space10,
              height: TossSpacing.space10,
              decoration: BoxDecoration(
                color: TossColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: TossColors.info,
                size: TossSpacing.iconSM,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: TossSpacing.iconSM,
            ),
            onTap: onNotifications,
          ),

          TossListTile(
            title: 'Privacy & Security',
            leading: Container(
              width: TossSpacing.space10,
              height: TossSpacing.space10,
              decoration: BoxDecoration(
                color: TossColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                Icons.security_outlined,
                color: TossColors.success,
                size: TossSpacing.iconSM,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: TossSpacing.iconSM,
            ),
            onTap: onPrivacySecurity,
          ),

          // Sign Out - Using TossListTile with destructive styling
          Container(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
            child: InkWell(
              onTap: onSignOut,
              child: Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Row(
                  children: [
                    Container(
                      width: TossSpacing.space10,
                      height: TossSpacing.space10,
                      decoration: BoxDecoration(
                        color: TossColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Icon(
                        Icons.logout,
                        color: TossColors.error,
                        size: TossSpacing.iconSM,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Text(
                        'Sign Out',
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.error,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: TossColors.gray400,
                      size: TossSpacing.iconSM,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
