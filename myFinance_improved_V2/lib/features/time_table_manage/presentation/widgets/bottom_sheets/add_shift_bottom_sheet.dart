// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, argument_type_not_assignable, invalid_assignment, non_bool_condition, non_bool_negation_expression, non_bool_operand, use_of_void_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App-level providers
import '../../../../../app/providers/app_state_provider.dart';
// Core utilities
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
// Shared themes
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
// Shared widgets
// Feature providers
import '../../providers/time_table_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// AddShiftBottomSheet
///
/// Bottom sheet for adding new shifts to the schedule
/// ✅ Refactored to use Riverpod Provider (addShiftFormProvider)
class AddShiftBottomSheet extends ConsumerWidget {
  final Future<void> Function()? onShiftAdded;

  const AddShiftBottomSheet({
    super.key,
    this.onShiftAdded,
  });

  Future<void> _selectDate(BuildContext context, WidgetRef ref, String storeId) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: TossColors.white,
              surface: TossColors.white,
              onSurface: TossColors.gray900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(addShiftFormProvider(storeId).notifier).selectDate(picked);
    }
  }

  Future<void> _saveShift(BuildContext context, WidgetRef ref, String storeId) async {
    final appState = ref.read(appStateProvider);
    final approvedBy = appState.user['user_id'] ?? '';

    if (approvedBy.isEmpty) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Error',
          message: 'User information not found',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    // Save via Provider
    final success = await ref.read(addShiftFormProvider(storeId).notifier).saveShift(
          approvedBy: approvedBy,
        );

    if (!context.mounted) return;

    if (success) {
      // Notify parent widget to refresh data BEFORE showing success dialog
      if (onShiftAdded != null) {
        await onShiftAdded!();
      }

      // Show success message
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.success(
          title: 'Success',
          message: 'Shift scheduled successfully',
          primaryButtonText: 'OK',
        ),
      );

      // Close the bottom sheet
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } else {
      // Error is already set in state, will be displayed
      final error = ref.read(addShiftFormProvider(storeId)).error;
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Error',
          message: error ?? 'Failed to save shift',
          primaryButtonText: 'OK',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get storeId from app state
    final appState = ref.watch(appStateProvider);
    final storeId = appState.storeChoosen;

    if (storeId.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: const Center(
          child: Text('Please select a store first'),
        ),
      );
    }

    // Watch form state
    final formState = ref.watch(addShiftFormProvider(storeId));

    // ✅ Use shiftMetadataProvider for shifts data (same as Schedule tab)
    final shiftMetadataAsync = ref.watch(shiftMetadataProvider(storeId));

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Text(
                  'Add Shift',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                  child: Container(
                    padding: const EdgeInsets.all(TossSpacing.space2),
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: TossColors.gray200,
          ),

          // Content
          Expanded(
            child: formState.isLoadingData
                ? const Center(
                    child: TossLoadingView(),
                  )
                : formState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: TossColors.error,
                            ),
                            const SizedBox(height: TossSpacing.space3),
                            Text(
                              formState.error!,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            InkWell(
                              onTap: () {
                                ref.read(addShiftFormProvider(storeId).notifier).loadScheduleData();
                              },
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space4,
                                  vertical: TossSpacing.space2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: TossColors.primary),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                child: Text(
                                  'Retry',
                                  style: TossTextStyles.bodyLarge.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(TossSpacing.space5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Employee Dropdown
                            TossDropdown<String>(
                              label: 'Employee',
                              hint: 'Select Employee',
                              value: formState.selectedEmployeeId,
                              items: formState.employees.map((employee) {
                                return TossDropdownItem<String>(
                                  value: employee['user_id'] as String,
                                  label: employee['user_name'] as String? ?? 'Unknown',
                                );
                              }).toList(),
                              onChanged: formState.isSaving
                                  ? null
                                  : (value) {
                                      ref.read(addShiftFormProvider(storeId).notifier).selectEmployee(value);
                                    },
                              isLoading: false,
                            ),

                            const SizedBox(height: TossSpacing.space5),

                            // Shift Dropdown
                            TossDropdown<String>(
                              label: 'Shift',
                              hint: 'Select Shift',
                              value: formState.selectedShiftId,
                              items: formState.shifts.map((shift) {
                                final shiftName = shift['shift_name'] as String? ?? 'Shift';
                                final startTime = shift['start_time'] as String? ?? '--:--';
                                final endTime = shift['end_time'] as String? ?? '--:--';

                                return TossDropdownItem<String>(
                                  value: shift['shift_id'] as String,
                                  label: '$shiftName ($startTime - $endTime)',
                                );
                              }).toList(),
                              onChanged: formState.isSaving
                                  ? null
                                  : (value) {
                                      ref.read(addShiftFormProvider(storeId).notifier).selectShift(value);
                                    },
                              isLoading: false,
                            ),

                            const SizedBox(height: TossSpacing.space5),

                            // Date Picker
                            Text(
                              'Date',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            InkWell(
                              onTap: formState.isSaving ? null : () => _selectDate(context, ref, storeId),
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              child: Container(
                                padding: const EdgeInsets.all(TossSpacing.space4),
                                decoration: BoxDecoration(
                                  color: TossColors.gray50,
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                  border: Border.all(
                                    color: TossColors.gray200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                      color: TossColors.gray600,
                                    ),
                                    const SizedBox(width: TossSpacing.space3),
                                    Text(
                                      formState.selectedDate != null
                                          ? DateTimeUtils.toDateOnly(formState.selectedDate!)
                                          : 'Select Date',
                                      style: TossTextStyles.body.copyWith(
                                        color: formState.selectedDate != null
                                            ? TossColors.gray900
                                            : TossColors.gray500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: TossColors.gray400,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: TossSpacing.space5),

                            // Validation message
                            if (!formState.isFormValid && !formState.isSaving)
                              Container(
                                padding: const EdgeInsets.all(TossSpacing.space3),
                                decoration: BoxDecoration(
                                  color: TossColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                  border: Border.all(
                                    color: TossColors.warning.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 20,
                                      color: TossColors.warning,
                                    ),
                                    const SizedBox(width: TossSpacing.space2),
                                    Expanded(
                                      child: Text(
                                        'Please select all required fields to continue',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.warning,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
          ),

          // Divider
          Container(
            height: 1,
            color: TossColors.gray200,
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                // Cancel button
                Expanded(
                  child: InkWell(
                    onTap: formState.isSaving ? null : () => Navigator.pop(context, false),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: TossSpacing.space3),

                // Save button
                Expanded(
                  child: InkWell(
                    onTap: formState.isFormValid && !formState.isSaving
                        ? () => _saveShift(context, ref, storeId)
                        : null,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: formState.isFormValid && !formState.isSaving
                            ? TossColors.primary
                            : TossColors.gray300,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Center(
                        child: formState.isSaving
                            ? const TossLoadingView.inline(
                                size: 20,
                                color: TossColors.white,
                              )
                            : Text(
                                'Save',
                                style: TossTextStyles.bodyLarge.copyWith(
                                  color: formState.isFormValid ? TossColors.white : TossColors.gray500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
