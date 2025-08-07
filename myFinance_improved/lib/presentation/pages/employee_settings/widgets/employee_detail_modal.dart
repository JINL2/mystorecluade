// lib/presentation/pages/employee_settings/widgets/employee_detail_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/employee_provider.dart';
import 'tabs/profile_tab.dart';
import 'tabs/compensation_tab.dart';
import 'tabs/attendance_tab.dart';

class EmployeeDetailModal extends ConsumerWidget {
  const EmployeeDetailModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(selectedEmployeeProvider);
    
    if (employee == null) {
      return const SizedBox.shrink();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TossBorderRadius.xxl),
          ),
        ),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              // Handle bar
              _buildHandleBar(),
              
              // Header with employee info
              _buildHeader(context, employee),
              
              // Tab bar
              _buildTabBar(),
              
              // Tab content
              Expanded(
                child: TabBarView(
                  children: [
                    ProfileTab(employee: employee),
                    CompensationTab(employee: employee),
                    AttendanceTab(employee: employee),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      width: 40,
      height: 4,
      margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray300,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, employee) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          // Profile image
          CircleAvatar(
            radius: 36,
            backgroundImage: employee.profileImage != null 
              ? NetworkImage(employee.profileImage!)
              : null,
            backgroundColor: TossColors.primary.withOpacity(0.1),
            child: employee.profileImage == null
              ? Text(
                  employee.initials,
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.primary,
                  ),
                )
              : null,
          ),
          SizedBox(width: TossSpacing.space4),
          
          // Employee info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.fullName,
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  employee.roleName ?? 'Unknown',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                if (employee.email != null && employee.email!.isNotEmpty)
                  Text(
                    employee.email!,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        labelColor: TossColors.primary,
        unselectedLabelColor: TossColors.gray600,
        labelStyle: TossTextStyles.labelLarge,
        unselectedLabelStyle: TossTextStyles.labelLarge,
        indicatorColor: TossColors.primary,
        indicatorWeight: 2,
        tabs: const [
          Tab(text: 'Profile'),
          Tab(text: 'Salary'),
          Tab(text: 'Attendance'),
        ],
      ),
    );
  }
}