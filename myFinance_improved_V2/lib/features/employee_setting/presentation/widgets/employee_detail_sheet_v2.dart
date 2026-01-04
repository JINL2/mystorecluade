import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../domain/entities/employee_salary.dart';
import '../providers/employee_providers.dart';
import 'employee_detail/employee_detail_widgets.dart';

class EmployeeDetailSheetV2 extends ConsumerStatefulWidget {
  final EmployeeSalary employee;
  final void Function(EmployeeSalary) onUpdate;
  final void Function(EmployeeSalary) onEditSalary;
  final VoidCallback onManageRoles;

  const EmployeeDetailSheetV2({
    super.key,
    required this.employee,
    required this.onUpdate,
    required this.onEditSalary,
    required this.onManageRoles,
  });

  @override
  ConsumerState<EmployeeDetailSheetV2> createState() => 
      _EmployeeDetailSheetV2State();
}

class _EmployeeDetailSheetV2State extends ConsumerState<EmployeeDetailSheetV2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current employee data from the provider to reflect any updates
    final employees = ref.watch(mutableEmployeeListProvider);
    final employee = employees?.firstWhere(
      (emp) => emp.userId == widget.employee.userId,
      orElse: () => widget.employee,
    ) ?? widget.employee;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(
              top: TossSpacing.space3,
              bottom: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Header Section
          _buildHeader(employee),
          
          const SizedBox(height: TossSpacing.space5),
          
          // Tab Bar
          TossTabBar(
            tabs: const ['Salary', 'Attendance', 'Info', 'Role'],
            controller: _tabController,
            selectedLabelStyle: TossTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
            unselectedLabelStyle: TossTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
          ),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SalaryTab(
                  employee: employee,
                  onEdit: () => widget.onEditSalary(employee),
                ),
                AttendanceTab(employee: employee),
                InfoTab(employee: employee),
                RoleTab(
                  employee: employee,
                  onManage: widget.onManageRoles,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(EmployeeSalary employee) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        children: [
          // Large Avatar
          // Note: Hero removed to avoid duplicate tag error with BottomSheet
          // (BottomSheet doesn't support Hero animation anyway)
          _buildAvatar(employee, size: 80),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Name
          Text(
            employee.fullName,
            style: TossTextStyles.h2.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: TossSpacing.space2),

          const SizedBox(height: TossSpacing.space1),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Text(
              employee.roleName.isNotEmpty ? employee.roleName : 'No role assigned',
              style: TossTextStyles.bodySmall.copyWith(
                color: employee.roleName.isNotEmpty ? TossColors.gray900 : TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Last Activity Status
          const SizedBox(height: TossSpacing.space2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                employee.isActiveToday
                    ? Icons.circle
                    : Icons.access_time_rounded,
                size: 10,
                color: employee.isActiveToday
                    ? TossColors.success
                    : (employee.isInactive
                        ? TossColors.gray300
                        : TossColors.gray400),
              ),
              const SizedBox(width: 4),
              Text(
                employee.lastActivityAt != null
                    ? 'Last active ${employee.lastActivityText}'
                    : 'No recent activity',
                style: TossTextStyles.caption.copyWith(
                  color: employee.isActiveToday
                      ? TossColors.success
                      : (employee.isInactive
                          ? TossColors.gray400
                          : TossColors.gray500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAvatar(EmployeeSalary employee, {double size = 52}) {
    return EmployeeProfileAvatar(
      imageUrl: employee.profileImage,
      name: employee.fullName,
      size: size,
    );
  }
}