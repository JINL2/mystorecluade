import 'package:flutter/material.dart';
import 'package:myfinance_improved/features/delegate_role/domain/entities/role.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Modern role card widget
///
/// Displays role information with:
/// - Role icon with colored background
/// - Role name and subtitle (tags or description)
/// - Member count and permission count badges
/// - Tap interaction with visual feedback
class RoleCardWidget extends StatelessWidget {
  final Role role;
  final VoidCallback? onTap;
  final bool isOwnerRole;

  const RoleCardWidget({
    super.key,
    required this.role,
    this.onTap,
    this.isOwnerRole = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: isOwnerRole ? null : onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Row(
              children: [
                // Icon container
                _buildRoleIcon(),
                const SizedBox(width: TossSpacing.space3),

                // Role info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            role.roleName,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: TossColors.gray900,
                            ),
                          ),
                          if (isOwnerRole) ...[
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              'SYSTEM',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        _getSubtitleText(),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Stats badges
                const SizedBox(width: TossSpacing.space3),
                _buildStatsColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getRoleColor().withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          _getRoleIcon(),
          color: _getRoleColor(),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildStatsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatChip(
          icon: Icons.person_outline,
          label: role.memberCount.toString(),
        ),
        const SizedBox(height: TossSpacing.space2),
        _buildStatChip(
          icon: Icons.shield_outlined,
          label: role.permissions.length.toString(),
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: TossColors.gray600,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getSubtitleText() {
    if (role.tags.isNotEmpty) {
      final tagList = role.tags.take(3).toList();
      final remaining = role.tags.length - 3;
      String tagsText = tagList.join(' • ');
      if (remaining > 0) {
        tagsText += ' +$remaining';
      }
      return tagsText;
    } else {
      return _getRoleDescription();
    }
  }

  Color _getRoleColor() {
    switch (role.roleName.toLowerCase()) {
      case 'owner':
        return TossColors.primary;
      case 'admin':
        return TossColors.success;
      case 'manager':
      case 'store manager':
        return TossColors.warning;
      case 'employee':
        return TossColors.info;
      default:
        return TossColors.gray600;
    }
  }

  IconData _getRoleIcon() {
    switch (role.roleName.toLowerCase()) {
      case 'owner':
        return Icons.star;
      case 'admin':
        return Icons.admin_panel_settings;
      case 'manager':
      case 'store manager':
        return Icons.manage_accounts;
      case 'employee':
        return Icons.person;
      default:
        return Icons.group;
    }
  }

  String _getRoleDescription() {
    switch (role.roleName.toLowerCase()) {
      case 'owner':
        return 'Full system access & company management';
      case 'admin':
        return 'Custom role with specific permissions';
      case 'manager':
      case 'store manager':
        return 'Custom role with specific permissions';
      case 'employee':
        return 'Standard access for daily operations';
      default:
        return 'Custom role with specific permissions';
    }
  }
}
