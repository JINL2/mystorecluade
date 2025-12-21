import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/delegate_role_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class DelegationListItem extends StatelessWidget {
  const DelegationListItem({
    super.key,
    required this.delegation,
    required this.onEdit,
    required this.onRevoke,
  });

  final RoleDelegation delegation;
  final VoidCallback onEdit;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final isActive = delegation.isActiveNow;
    
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        boxShadow: TossShadows.card,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          onTap: onEdit,
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delegated user info
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: TossColors.primary,
                      child: Text(
                        delegation.delegateUserInitial,
                        style: TossTextStyles.label.copyWith(
                          color: TossColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
                    
                    // User details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            delegation.delegateUserName,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            delegation.delegateUserEmail,
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: isActive 
                          ? TossColors.success.withValues(alpha: 0.1) 
                          : TossColors.gray200,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Expired',
                        style: TossTextStyles.caption.copyWith(
                          color: isActive 
                            ? TossColors.success 
                            : TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: TossSpacing.space3),
                
                // Role and permissions info
                Row(
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      size: 16,
                      color: TossColors.gray500,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      'Role: ${delegation.roleName}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: TossSpacing.space1),
                
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: TossColors.gray500,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      'Expires: ${DateFormat('MMM dd, yyyy').format(delegation.endDate)}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    if (isActive && delegation.daysRemaining <= 7) ...[
                      SizedBox(width: TossSpacing.space2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space1,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          '${delegation.daysRemaining} days left',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.warning,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                
                if (delegation.permissions.isNotEmpty) ...[
                  SizedBox(height: TossSpacing.space2),
                  Wrap(
                    spacing: TossSpacing.space1,
                    runSpacing: TossSpacing.space1,
                    children: delegation.permissions.take(3).map((permission) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          permission,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                
                SizedBox(height: TossSpacing.space3),
                
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onEdit,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                      ),
                      child: Text(
                        'Edit',
                        style: TossTextStyles.label.copyWith(
                          color: TossColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    TextButton(
                      onPressed: isActive ? onRevoke : null,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                      ),
                      child: Text(
                        'Revoke',
                        style: TossTextStyles.label.copyWith(
                          color: isActive ? TossColors.error : TossColors.gray400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}