import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../data/repositories/repository_providers.dart';
import '../../../domain/entities/employee_salary.dart';

class DeleteEmployeeDialog extends ConsumerStatefulWidget {
  final EmployeeSalary employee;
  final void Function(bool deleteSalary) onConfirm;

  const DeleteEmployeeDialog({
    super.key,
    required this.employee,
    required this.onConfirm,
  });

  @override
  ConsumerState<DeleteEmployeeDialog> createState() => _DeleteEmployeeDialogState();
}

class _DeleteEmployeeDialogState extends ConsumerState<DeleteEmployeeDialog> {
  bool _deleteSalary = true;
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
          const Icon(Icons.warning_amber_rounded, color: TossColors.error, size: 28),
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
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : _buildContent(),
      actions: _isLoading
          ? null
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ),
              if (_validationData?['success'] == true)
                ElevatedButton(
                  onPressed: () => widget.onConfirm(_deleteSalary),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.error,
                    foregroundColor: TossColors.white,
                  ),
                  child: const Text('Remove'),
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
                const Icon(Icons.error_outline, color: TossColors.error, size: 20),
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

        // Delete salary option
        CheckboxListTile(
          value: _deleteSalary,
          onChanged: (value) => setState(() => _deleteSalary = value ?? true),
          title: Text(
            'Also delete salary information',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray900,
            ),
          ),
          subtitle: Text(
            'Uncheck to preserve salary history',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: TossColors.primary,
        ),

        const SizedBox(height: TossSpacing.space2),

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
