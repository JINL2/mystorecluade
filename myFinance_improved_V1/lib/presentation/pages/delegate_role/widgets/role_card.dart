import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';

class RoleCard extends ConsumerWidget {
  final String roleId;
  final String roleName;
  final List<String> permissions;
  final int memberCount;
  final bool canEdit;
  final bool canDelegate;
  final VoidCallback? onTap;

  const RoleCard({
    super.key,
    required this.roleId,
    required this.roleName,
    required this.permissions,
    required this.memberCount,
    this.canEdit = false,
    this.canDelegate = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(
        left: TossSpacing.space5,
        right: TossSpacing.space5,
        bottom: TossSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Row(
            children: [
              // Role icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getRoleColor().withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getRoleIcon(),
                  color: _getRoleColor(),
                  size: 24,
                ),
              ),
              SizedBox(width: TossSpacing.space4),
              
              // Role info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roleName,
                      style: TossTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      _getRoleDescription(),
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    // Info badges row
                    Row(
                      children: [
                        // People count
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person, size: 10, color: TossColors.gray600),
                              SizedBox(width: 2),
                              Text('$memberCount', style: TossTextStyles.caption.copyWith(fontSize: 10)),
                            ],
                          ),
                        ),
                        SizedBox(width: 4),
                        // Permissions count
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shield_outlined, size: 10, color: TossColors.gray600),
                              SizedBox(width: 2),
                              Text('${permissions.length}', style: TossTextStyles.caption.copyWith(fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow indicator
              Icon(
                Icons.chevron_right,
                color: TossColors.gray400,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor() {
    switch (roleName.toLowerCase()) {
      case 'owner':
        return TossColors.error;
      case 'manager':
        return TossColors.warning;
      case 'employee':
        return TossColors.primary;
      case 'salesman':
        return TossColors.success;
      default:
        return TossColors.gray600;
    }
  }

  IconData _getRoleIcon() {
    switch (roleName.toLowerCase()) {
      case 'owner':
        return Icons.star;
      case 'manager':
        return Icons.supervisor_account;
      case 'employee':
        return Icons.person;
      case 'salesman':
        return Icons.shopping_bag;
      default:
        return Icons.badge;
    }
  }

  String _getRoleDescription() {
    switch (roleName.toLowerCase()) {
      case 'owner':
        return 'Full system access & company management';
      case 'manager':
        return 'Team oversight & operational control';
      case 'employee':
        return 'Standard access for daily operations';
      case 'salesman':
        return 'Customer-facing sales operations';
      case 'managerstore':
        return 'Store management & inventory control';
      default:
        return 'Custom role with specific permissions';
    }
  }

}