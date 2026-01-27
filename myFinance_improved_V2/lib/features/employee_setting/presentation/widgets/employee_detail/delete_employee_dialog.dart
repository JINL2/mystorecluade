import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../data/repositories/repository_providers.dart';
import '../../../domain/entities/employee_salary.dart';

/// Dialog for confirming employee deletion
class DeleteEmployeeDialog extends ConsumerStatefulWidget {
  final EmployeeSalary employee;
  final VoidCallback onConfirm;

  const DeleteEmployeeDialog({
    super.key,
    required this.employee,
    required this.onConfirm,
  });

  @override
  ConsumerState<DeleteEmployeeDialog> createState() => _DeleteEmployeeDialogState();
}

class _DeleteEmployeeDialogState extends ConsumerState<DeleteEmployeeDialog> {
  bool _isLoading = true;
  Map<String, dynamic>? _validationData;

  @override
  void initState() {
    super.initState();
    _loadValidationData();
  }

  Future<void> _loadValidationData() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final repository = ref.read(employeeRepositoryProvider);

    try {
      final result = await repository.validateEmployeeDelete(
        companyId: companyId,
        employeeUserId: widget.employee.userId,
      );

      if (mounted) {
        setState(() {
          _validationData = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _validationData = {
            'success': false,
            'message': 'Failed to validate: $e',
          };
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: TossColors.error, size: TossSpacing.iconXXL),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Remove Employee',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: _isLoading
          ? const SizedBox(
              height: TossDimensions.cardMinHeight,
              child: TossLoadingView(),
            )
          : _buildContent(),
      actions: _isLoading
          ? null
          : [
              TossButton.textButton(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
                textColor: TossColors.gray600,
              ),
              if (_validationData?['success'] == true)
                TossButton.destructive(
                  text: 'Remove',
                  onPressed: widget.onConfirm,
                ),
            ],
    );
  }

  Widget _buildContent() {
    if (_validationData?['success'] != true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: TossColors.error, size: TossSpacing.iconMD),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    (_validationData?['message'] as String?) ?? 'Cannot delete this employee.',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final dataSummary = _validationData?['data_summary'] as Map<String, dynamic>?;
    final willPreserve = dataSummary?['will_preserve'] as Map<String, dynamic>?;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Are you sure you want to remove "${widget.employee.fullName}" from your company?',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Data preservation notice
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data to be preserved:',
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              if (willPreserve != null) ...[
                _buildPreserveRow('Shift Records', (willPreserve['shift_requests'] as int?) ?? 0),
                _buildPreserveRow('Journal Entries', (willPreserve['journal_entries_created'] as int?) ?? 0),
                _buildPreserveRow('Cash Entries', (willPreserve['cash_amount_entries'] as int?) ?? 0),
              ],
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Salary preservation notice
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.success.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: TossColors.success, size: TossSpacing.iconMD),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  'Salary history will be automatically preserved for audit purposes.',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.success,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space3),

        Text(
          'This action will soft-delete the employee\'s company connection. The user account will remain active for other companies.',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildPreserveRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            '$count records',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
