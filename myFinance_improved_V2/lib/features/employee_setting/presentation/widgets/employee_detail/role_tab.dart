import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../data/repositories/repository_providers.dart';
import '../../../domain/entities/employee_salary.dart';
import '../../providers/employee_providers.dart';
import 'delete_employee_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class RoleTab extends ConsumerWidget {
  final EmployeeSalary employee;
  final VoidCallback onManage;

  const RoleTab({
    super.key,
    required this.employee,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasRole = employee.roleName.isNotEmpty;
    final isOwnerAsync = ref.watch(isCurrentUserOwnerProvider);

    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Role Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        hasRole ? TossColors.primary.withValues(alpha: 0.08) : TossColors.gray100,
                        hasRole ? TossColors.primary.withValues(alpha: 0.03) : TossColors.gray50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: hasRole ? TossColors.primary.withValues(alpha: 0.2) : TossColors.gray200,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        hasRole ? Icons.verified_user : Icons.person_outline,
                        size: 48,
                        color: hasRole ? TossColors.primary : TossColors.gray400,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        hasRole ? employee.roleName : 'No Role Assigned',
                        style: TossTextStyles.h3.copyWith(
                          color: hasRole ? TossColors.gray900 : TossColors.gray600,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Fixed bottom buttons
        Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: const BoxDecoration(
            color: TossColors.background,
            border: Border(
              top: BorderSide(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Change Role Button
                SizedBox(
                  width: double.infinity,
                  child: TossPrimaryButton(
                    text: hasRole ? 'Change Role' : 'Assign Role',
                    onPressed: onManage,
                    fullWidth: true,
                  ),
                ),

                // Delete Employee Button - Only visible to Owner
                isOwnerAsync.when(
                  data: (isOwner) {
                    if (!isOwner) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(top: TossSpacing.space3),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _showDeleteConfirmationDialog(context, ref),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: TossColors.error,
                            side: const BorderSide(color: TossColors.error),
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                          ),
                          child: Text(
                            'Remove Employee',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => DeleteEmployeeDialog(
        employee: employee,
        onConfirm: (deleteSalary) async {
          Navigator.of(dialogContext).pop();
          await _executeDelete(context, ref, deleteSalary);
        },
      ),
    );
  }

  Future<void> _executeDelete(BuildContext context, WidgetRef ref, bool deleteSalary) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final repository = ref.read(employeeRepositoryProvider);

    // Show loading indicator
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final result = await repository.deleteEmployee(
        companyId: companyId,
        employeeUserId: employee.userId,
        deleteSalary: deleteSalary,
      );

      // Hide loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (result['success'] == true) {
        // Remove employee from mutable list immediately
        final currentList = ref.read(mutableEmployeeListProvider);
        if (currentList != null) {
          final updatedList = currentList.where((e) => e.userId != employee.userId).toList();
          ref.read(mutableEmployeeListProvider.notifier).update(updatedList);
        }

        // Also invalidate the source provider to refresh from server
        ref.invalidate(employeeSalaryListProvider);

        // Close the bottom sheet
        if (context.mounted) {
          Navigator.of(context).pop();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${employee.fullName} has been removed from the company.'),
              backgroundColor: TossColors.success,
            ),
          );
        }
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text((result['message'] as String?) ?? 'Failed to remove employee.'),
              backgroundColor: TossColors.error,
            ),
          );
        }
      }
    } catch (e) {
      // Hide loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
}
