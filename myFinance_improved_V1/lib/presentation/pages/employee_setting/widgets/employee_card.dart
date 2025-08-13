import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_shadows.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.employeeName,
    required this.employeeRole,
    required this.salaryAmount,
    required this.currencySymbol,
    this.profileImageUrl,
    required this.onEdit,
  });

  final String employeeName;
  final String employeeRole;
  final double salaryAmount;
  final String currencySymbol;
  final String? profileImageUrl;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        boxShadow: TossShadows.shadow1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          onTap: onEdit,
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space3),
            child: Row(
              children: [
                // Profile Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TossColors.gray100,
                  ),
                  child: ClipOval(
                    child: profileImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: profileImageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: TossColors.gray100,
                              child: const Icon(
                                Icons.person,
                                size: 20,
                                color: TossColors.gray400,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: TossColors.gray100,
                              child: const Icon(
                                Icons.person,
                                size: 20,
                                color: TossColors.gray400,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 20,
                            color: TossColors.gray400,
                          ),
                  ),
                ),
                
                SizedBox(width: TossSpacing.space3),
                
                // Employee Info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeName,
                        style: TossTextStyles.label.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        employeeRole,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Salary Display
                Text(
                  '${salaryAmount.toStringAsFixed(2)}$currencySymbol',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                
                SizedBox(width: TossSpacing.space2),
                
                // Edit Icon
                Icon(
                  Icons.edit_outlined,
                  size: 24,
                  color: TossColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}