// lib/presentation/pages/delegate_role/widgets/user_role_card.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/delegate_role_provider.dart';

class UserRoleCard extends StatelessWidget {
  final UserRoleInfo user;
  final VoidCallback onTap;

  const UserRoleCard({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        constraints: BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.gray100, width: 1),
        ),
        padding: EdgeInsets.all(TossSpacing.space3),
        child: Row(
          children: [
            // Profile Image
            _buildProfileImage(),
            SizedBox(width: TossSpacing.space3),
            
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name
                  Text(
                    user.displayName,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: TossSpacing.space1),
                  
                  // Email
                  Text(
                    user.email,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (user.storeName != null) ...[
                    SizedBox(height: TossSpacing.space1),
                    // Store name
                    Text(
                      user.storeName!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: TossSpacing.space2),
                  
                  // Role Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(user.roleName).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getRoleColor(user.roleName),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Text(
                          user.roleName,
                          style: TossTextStyles.caption.copyWith(
                            color: _getRoleColor(user.roleName),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Chevron icon
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (user.hasProfileImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.network(
          user.profileImage!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
        ),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: TossTextStyles.body.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String roleName) {
    final Map<String, Color> roleColors = {
      'Owner': TossColors.error,
      'Admin': TossColors.primary,
      'Manager': TossColors.warning,
      'Employee': TossColors.success,
      'Staff': TossColors.info,
    };
    
    return roleColors[roleName] ?? TossColors.gray500;
  }
}