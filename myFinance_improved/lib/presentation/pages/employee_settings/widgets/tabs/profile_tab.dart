// lib/presentation/pages/employee_settings/widgets/tabs/profile_tab.dart

import 'package:flutter/material.dart';
import '../../../../../core/themes/toss_colors.dart';
import '../../../../../core/themes/toss_spacing.dart';
import '../../../../../core/themes/toss_text_styles.dart';
import '../../../../../core/themes/toss_border_radius.dart';
import '../../../../../domain/entities/employee_detail.dart';

class ProfileTab extends StatelessWidget {
  final EmployeeDetail employee;

  const ProfileTab({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Basic Information',
            [
              _buildInfoRow('Full Name', employee.fullName),
              _buildInfoRow('Email', employee.email ?? 'Not provided'),
              _buildInfoRow('Phone', employee.phoneNumber ?? 'Not provided'),
              _buildInfoRow('Date of Birth', _formatDate(employee.dateOfBirth)),
            ],
          ),
          SizedBox(height: TossSpacing.space6),
          
          _buildSection(
            'Employment Details',
            [
              _buildInfoRow('Role', employee.roleName ?? 'Not assigned'),
              _buildInfoRow('Company', employee.companyName ?? 'N/A'),
              _buildInfoRow('Store', employee.storeName ?? 'Not assigned'),
              _buildInfoRow('Hire Date', _formatDate(employee.hireDate)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space3),
        Column(
          children: children,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}