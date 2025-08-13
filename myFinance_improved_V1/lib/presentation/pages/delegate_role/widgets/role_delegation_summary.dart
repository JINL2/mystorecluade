import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../providers/delegate_role_providers.dart';

class RoleDelegationSummary extends ConsumerWidget {
  const RoleDelegationSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(delegatableRolesProvider);
    
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: TossColors.primary,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Delegation Permissions',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          rolesAsync.when(
            data: (roles) {
              if (roles.isEmpty) {
                return Text(
                  'You do not have permission to delegate roles.',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                );
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You can delegate the following roles:',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  ...roles.map((role) => Padding(
                    padding: EdgeInsets.only(bottom: TossSpacing.space1),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: TossColors.success,
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Text(
                          role.roleName,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Text(
                          '(${role.permissions.length} permissions)',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              );
            },
            loading: () => Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
                ),
              ),
            ),
            error: (_, __) => Text(
              'Failed to load delegation permissions',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}