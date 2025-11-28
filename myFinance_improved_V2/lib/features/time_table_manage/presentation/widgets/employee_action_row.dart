import 'package:flutter/material.dart';
import '../../../../shared/widgets/common/employee_profile_avatar.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../models/schedule_models.dart';

/// Employee Action Row Widget
///
/// Displays an employee with an action button on the right.
/// Used for applicants and waitlist sections in shift cards.
///
/// Features:
/// - Employee avatar (32px)
/// - Employee name
/// - Customizable action button (Approve, Overbook, etc.)
class EmployeeActionRow extends StatelessWidget {
  final Employee employee;
  final String buttonText;
  final IconData? buttonIcon;
  final VoidCallback onTap;
  final Color? buttonColor;
  final Color? buttonTextColor;

  const EmployeeActionRow({
    super.key,
    required this.employee,
    required this.buttonText,
    this.buttonIcon,
    required this.onTap,
    this.buttonColor,
    this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        children: [
          // Employee Avatar
          EmployeeProfileAvatar(
            imageUrl: employee.avatarUrl,
            name: employee.name,
            size: 32,
          ),

          const SizedBox(width: TossSpacing.space2),

          // Employee Name
          Expanded(
            child: Text(
              employee.name,
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray900,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: TossSpacing.space2),

          // Action Button
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: buttonColor ?? TossColors.primary,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (buttonIcon != null) ...[
              Icon(
                buttonIcon,
                size: 16,
                color: buttonTextColor ?? TossColors.white,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              buttonText,
              style: TossTextStyles.labelMedium.copyWith(
                color: buttonTextColor ?? TossColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
