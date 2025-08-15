import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../widgets/toss/toss_card.dart';

class RoleCard extends ConsumerWidget {
  final String roleId;
  final String roleName;
  final String? description;
  final List<String> permissions;
  final int memberCount;
  final bool canEdit;
  final bool canDelegate;
  final VoidCallback? onTap;

  const RoleCard({
    super.key,
    required this.roleId,
    required this.roleName,
    this.description,
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
      child: TossCard(
        onTap: onTap,
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            // Role info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roleName,
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    description?.isNotEmpty == true ? description! : _getDefaultRoleDescription(),
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Counts on the right
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // People count
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: TossColors.gray400,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      '$memberCount',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: TossSpacing.space1),
                // Permissions count
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 16,
                      color: TossColors.gray400,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      '${permissions.length}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(width: TossSpacing.space3),
            
            // Arrow indicator
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }


  String _getDefaultRoleDescription() {
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