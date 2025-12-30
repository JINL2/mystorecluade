import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_section_header.dart';

class SettingsSection extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onNotifications;
  final VoidCallback onPrivacySecurity;
  final VoidCallback onLanguage;
  final VoidCallback onSignOut;

  const SettingsSection({
    super.key,
    required this.onEditProfile,
    required this.onNotifications,
    required this.onPrivacySecurity,
    required this.onLanguage,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
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
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            child: const TossSectionHeader(
              title: 'Settings',
              icon: Icons.settings,
              backgroundColor: TossColors.white,
              padding: EdgeInsets.all(TossSpacing.space4),
            ),
          ),

          // Settings Items
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: onEditProfile,
          ),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: onNotifications,
          ),
          _buildSettingsTile(
            icon: Icons.security_outlined,
            title: 'Privacy & Security',
            onTap: onPrivacySecurity,
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Language',
            onTap: onLanguage,
          ),

          // Sign Out - Destructive styling
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Sign Out',
            onTap: onSignOut,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive ? TossColors.error : TossColors.primary;
    final iconBgColor = isDestructive
        ? TossColors.error.withValues(alpha: 0.1)
        : TossColors.primary.withValues(alpha: 0.12);
    final textColor = isDestructive ? TossColors.error : TossColors.gray900;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            Container(
              width: TossSpacing.space10,
              height: TossSpacing.space10,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: TossSpacing.iconSM,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: TossSpacing.iconSM,
            ),
          ],
        ),
      ),
    );
  }
}
