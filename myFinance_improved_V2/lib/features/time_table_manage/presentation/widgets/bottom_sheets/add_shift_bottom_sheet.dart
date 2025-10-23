// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, argument_type_not_assignable, invalid_assignment, non_bool_condition, non_bool_negation_expression, non_bool_operand, use_of_void_result

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App-level providers
import '../../../../../app/providers/app_state_provider.dart';

// Feature providers
import '../../providers/time_table_providers.dart';

// Shared themes
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_border_radius.dart';

// Shared widgets
import '../../../../../shared/widgets/common/toss_loading_view.dart';

/// AddShiftBottomSheet
///
/// Bottom sheet for adding new shifts to the schedule
class AddShiftBottomSheet extends ConsumerStatefulWidget {
  final VoidCallback? onShiftAdded;

  const AddShiftBottomSheet({
    super.key,
    this.onShiftAdded,
  });

  @override
  ConsumerState<AddShiftBottomSheet> createState() => _AddShiftBottomSheetState();
}

class _AddShiftBottomSheetState extends ConsumerState<AddShiftBottomSheet> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  
  // Data from RPC
  List<Map<String, dynamic>> _employees = [];
  List<Map<String, dynamic>> _shifts = [];
  
  // Selected values
  String? _selectedEmployeeId;
  String? _selectedShiftId;
  DateTime? _selectedDate;
  
  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }
  
  Future<void> _fetchScheduleData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      // Get store_id from app state
      final appState = ref.read(appStateProvider);
      final storeId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
      
      if (storeId == null || storeId.isEmpty) {
        setState(() {
          _error = 'Please select a store first';
          _isLoading = false;
        });
        return;
      }
      
      // Use repository instead of direct Supabase call
      final response = await ref.read(timeTableRepositoryProvider).getScheduleData(
        storeId: storeId,
      );

      setState(() {
        _employees = List<Map<String, dynamic>>.from(response['store_employees'] ?? []);
        _shifts = List<Map<String, dynamic>>.from(response['store_shifts'] ?? []);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
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
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  Future<void> _saveShift() async {
    try {
      setState(() {
        _isSaving = true;
      });
      
      // Get required data from app state
      final appState = ref.read(appStateProvider);
      final storeId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
      final approvedBy = appState.user['user_id'] ?? '';
      
      if (storeId == null || storeId.isEmpty || approvedBy.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error: Missing store or user information'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
          ),
        );
        setState(() {
          _isSaving = false;
        });
        return;
      }
      
      // Format the date as yyyy-MM-dd
      final formattedDate = '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

      // Use repository instead of direct Supabase call
      await ref.read(timeTableRepositoryProvider).insertSchedule(
        userId: _selectedEmployeeId!,
        shiftId: _selectedShiftId!,
        storeId: storeId,
        requestDate: formattedDate,
        approvedBy: approvedBy,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Shift scheduled successfully'),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
        ),
      );
      
      // Notify parent widget
      widget.onShiftAdded?.call();
      
      // Close the bottom sheet
      if (mounted) {
        Navigator.pop(context, true);
      }
      
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
          ),
        );
      }
      
      setState(() {
        _isSaving = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Check if all required fields are filled
    final bool isFormValid = _selectedEmployeeId != null && 
                            _selectedShiftId != null && 
                            _selectedDate != null && 
                            !_isLoading && 
                            !_isSaving;
    
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
            child: _isLoading
                ? const Center(
                    child: TossLoadingView(),
                  )
                : _error != null
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
                              _error!,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            InkWell(
                              onTap: _fetchScheduleData,
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
                            Text(
                              'Employee',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: TossColors.gray300),
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedEmployeeId,
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TossSpacing.space3,
                                    ),
                                    child: Text(
                                      'Select Employee',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ),
                                  isExpanded: true,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: TossSpacing.space3),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: TossColors.gray600,
                                    ),
                                  ),
                                  items: _employees.map((employee) {
                                    return DropdownMenuItem<String>(
                                      value: employee['user_id'],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: TossSpacing.space3,
                                        ),
                                        child: Text(
                                          employee['full_name'] ?? 'Unknown',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray900,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: _isSaving ? null : (value) {
                                    setState(() {
                                      _selectedEmployeeId = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: TossSpacing.space5),
                            
                            // Shift Dropdown
                            Text(
                              'Shift',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: TossColors.gray300),
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedShiftId,
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TossSpacing.space3,
                                    ),
                                    child: Text(
                                      'Select Shift',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ),
                                  isExpanded: true,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: TossSpacing.space3),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: TossColors.gray600,
                                    ),
                                  ),
                                  items: _shifts.map((shift) {
                                    return DropdownMenuItem<String>(
                                      value: shift['shift_id'],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: TossSpacing.space3,
                                        ),
                                        child: Text(
                                          '${shift['shift_name']} (${shift['start_time']} - ${shift['end_time']})',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray900,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: _isSaving ? null : (value) {
                                    setState(() {
                                      _selectedShiftId = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: TossSpacing.space5),
                            
                            // Date Selector
                            Text(
                              'Date',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            InkWell(
                              onTap: _isSaving ? null : _selectDate,
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              child: Container(
                                padding: const EdgeInsets.all(TossSpacing.space4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: TossColors.gray300),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                      color: TossColors.gray600,
                                    ),
                                    const SizedBox(width: TossSpacing.space3),
                                    Expanded(
                                      child: Text(
                                        _selectedDate != null
                                            ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                                            : 'Select Date',
                                        style: TossTextStyles.body.copyWith(
                                          color: _selectedDate != null
                                              ? TossColors.gray900
                                              : TossColors.gray500,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: TossColors.gray400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: TossSpacing.space4),
                            
                            // Required fields note
                            if (!isFormValid)
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
                                      size: 16,
                                      color: TossColors.warning,
                                    ),
                                    const SizedBox(width: TossSpacing.space2),
                                    Expanded(
                                      child: Text(
                                        'Please select all required fields to continue',
                                        style: TossTextStyles.caption.copyWith(
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
          
          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: const BoxDecoration(
              color: TossColors.white,
              border: Border(
                top: BorderSide(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: _isSaving ? 0.5 : 1.0,
                    child: AbsorbPointer(
                      absorbing: _isSaving,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
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
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Opacity(
                    opacity: isFormValid ? 1.0 : 0.5,
                    child: AbsorbPointer(
                      absorbing: !isFormValid,
                      child: InkWell(
                        onTap: isFormValid
                            ? () async {
                                HapticFeedback.mediumImpact();
                                await _saveShift();
                              }
                            : null,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: isFormValid
                                ? TossColors.primary
                                : TossColors.gray200,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          child: Center(
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: TossLoadingView(),
                                  )
                                : Text(
                                    'Save',
                                    style: TossTextStyles.bodyLarge.copyWith(
                                      color: isFormValid
                                          ? TossColors.white
                                          : TossColors.gray400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
