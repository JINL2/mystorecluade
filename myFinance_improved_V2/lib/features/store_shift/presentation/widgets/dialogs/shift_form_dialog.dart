import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/icon_mapper.dart';
import '../../../../../core/utils/number_formatter.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../../shared/widgets/toss/toss_text_field.dart';
import '../../../../../shared/widgets/toss/toss_time_picker.dart';
import '../../../domain/entities/store_shift.dart';
import '../../providers/store_shift_providers.dart';
import 'dialog_utils.dart';

/// Show Edit Shift Dialog
void showEditShiftDialog(
  BuildContext context,
  WidgetRef ref,
  StoreShift shift,
  String storeId,
) {
  // Parse existing time strings to TimeOfDay
  TimeOfDay? selectedStartTime = parseTimeString(shift.startTime);
  TimeOfDay? selectedEndTime = parseTimeString(shift.endTime);
  int numberShift = shift.numberShift;
  bool isCanOvertime = shift.isCanOvertime;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: TossColors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
                margin: const EdgeInsets.only(top: TossSpacing.space3),
                width: TossSpacing.iconXL,
                height: TossSpacing.space1,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
              ),

              // Header
              Container(
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Text(
                  'Edit Shift',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: ShiftFormContent(
                    initialName: shift.shiftName,
                    initialBonus: shift.shiftBonus,
                    initialNumberShift: numberShift,
                    initialIsCanOvertime: isCanOvertime,
                    selectedStartTime: selectedStartTime,
                    selectedEndTime: selectedEndTime,
                    onStartTimeChanged: (time) {
                      setState(() => selectedStartTime = time);
                    },
                    onEndTimeChanged: (time) {
                      setState(() => selectedEndTime = time);
                    },
                    onNumberShiftChanged: (value) {
                      setState(() => numberShift = value);
                    },
                    onIsCanOvertimeChanged: (value) {
                      setState(() => isCanOvertime = value);
                    },
                    onSave: (name, startTime, endTime, bonus, numShift, canOvertime) async {
                      try {
                        await ref.read(updateShiftProvider)(
                          shiftId: shift.shiftId,
                          shiftName: name,
                          startTime: formatTimeOfDay(startTime),
                          endTime: formatTimeOfDay(endTime),
                          numberShift: numShift,
                          isCanOvertime: canOvertime,
                          shiftBonus: bonus,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => TossDialog.success(
                              title: 'Shift Updated',
                              message: 'Shift updated successfully',
                              primaryButtonText: 'OK',
                            ),
                          );
                        }
                        ref.invalidate(storeShiftsProvider);
                      } catch (e) {
                        if (context.mounted) {
                          await showDialog<bool>(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => TossDialog.error(
                              title: 'Update Failed',
                              message: 'Failed: $e',
                              primaryButtonText: 'OK',
                            ),
                          );
                        }
                      }
                    },
                    buttonText: 'Save Changes',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Show Add Shift Dialog
void showAddShiftDialog(
  BuildContext context,
  WidgetRef ref,
  String storeId,
) {
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: TossColors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
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
                margin: const EdgeInsets.only(top: TossSpacing.space3),
                width: TossSpacing.iconXL,
                height: TossSpacing.space1,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
              ),

              // Header
              Container(
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Text(
                  'Create New Shift',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: ShiftFormContent(
                    initialName: '',
                    initialBonus: 0,
                    selectedStartTime: selectedStartTime,
                    selectedEndTime: selectedEndTime,
                    onStartTimeChanged: (time) {
                      setState(() => selectedStartTime = time);
                    },
                    onEndTimeChanged: (time) {
                      setState(() => selectedEndTime = time);
                    },
                    onSave: (name, startTime, endTime, bonus, numShift, canOvertime) async {
                      try {
                        await ref.read(createShiftProvider)(
                          storeId: storeId,
                          shiftName: name,
                          startTime: formatTimeOfDay(startTime),
                          endTime: formatTimeOfDay(endTime),
                          numberShift: numShift,
                          isCanOvertime: canOvertime,
                          shiftBonus: bonus,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => TossDialog.success(
                              title: 'Shift Created',
                              message: 'Shift created successfully',
                              primaryButtonText: 'OK',
                            ),
                          );
                        }
                        ref.invalidate(storeShiftsProvider);
                      } catch (e) {
                        if (context.mounted) {
                          await showDialog<bool>(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => TossDialog.error(
                              title: 'Creation Failed',
                              message: 'Failed: $e',
                              primaryButtonText: 'OK',
                            ),
                          );
                        }
                      }
                    },
                    buttonText: 'Create Shift',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Shift Form Content Widget
class ShiftFormContent extends StatefulWidget {
  final String initialName;
  final int initialBonus;
  final int initialNumberShift;
  final bool initialIsCanOvertime;
  final TimeOfDay? selectedStartTime;
  final TimeOfDay? selectedEndTime;
  final void Function(TimeOfDay) onStartTimeChanged;
  final void Function(TimeOfDay) onEndTimeChanged;
  final void Function(int)? onNumberShiftChanged;
  final void Function(bool)? onIsCanOvertimeChanged;
  final Future<void> Function(
    String name,
    TimeOfDay startTime,
    TimeOfDay endTime,
    int bonus,
    int numberShift,
    bool isCanOvertime,
  ) onSave;
  final String buttonText;

  const ShiftFormContent({
    super.key,
    required this.initialName,
    required this.initialBonus,
    this.initialNumberShift = 1,
    this.initialIsCanOvertime = false,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    this.onNumberShiftChanged,
    this.onIsCanOvertimeChanged,
    required this.onSave,
    required this.buttonText,
  });

  @override
  State<ShiftFormContent> createState() => _ShiftFormContentState();
}

class _ShiftFormContentState extends State<ShiftFormContent> {
  late TextEditingController _nameController;
  late TextEditingController _bonusController;
  late TextEditingController _numberShiftController;
  late int _numberShift;
  late bool _isCanOvertime;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _bonusController = TextEditingController(
      text: widget.initialBonus == 0
          ? ''
          : NumberFormatter.formatWithCommas(widget.initialBonus),
    );
    _numberShiftController = TextEditingController(
      text: widget.initialNumberShift.toString(),
    );
    _numberShift = widget.initialNumberShift;
    _isCanOvertime = widget.initialIsCanOvertime;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bonusController.dispose();
    _numberShiftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shift Name Input
        TossTextField(
          label: 'Shift Name',
          hintText: 'e.g., Morning Shift, Night Shift',
          controller: _nameController,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: TossSpacing.space6),

        // Shift Bonus Input
        TossTextField(
          label: 'Shift Bonus',
          hintText: '0',
          controller: _bonusController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isNotEmpty) {
                final numericValue =
                    int.tryParse(newValue.text.replaceAll(',', '')) ?? 0;
                final formattedValue =
                    NumberFormatter.formatWithCommas(numericValue);
                return TextEditingValue(
                  text: formattedValue,
                  selection:
                      TextSelection.collapsed(offset: formattedValue.length),
                );
              }
              return newValue;
            }),
          ],
        ),

        const SizedBox(height: TossSpacing.space6),

        // Time Settings Section
        _buildTimeSettingsSection(),

        const SizedBox(height: TossSpacing.space6),

        // Shift Settings Section (Number of Employees & Overtime)
        _buildShiftSettingsSection(),

        const SizedBox(height: TossSpacing.space5),

        // Duration Display
        if (widget.selectedStartTime != null && widget.selectedEndTime != null)
          _buildDurationDisplay(),

        const SizedBox(height: TossSpacing.space6),

        // Save Button
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildTimeSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.1),
          width: TossSpacing.space1 / 4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                IconMapper.getIcon('clock'),
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Shift Hours',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Start Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start Time',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossTimePicker(
                time: widget.selectedStartTime,
                placeholder: 'Select start time',
                onTimeChanged: widget.onStartTimeChanged,
                use24HourFormat: false,
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // End Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'End Time',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossTimePicker(
                time: widget.selectedEndTime,
                placeholder: 'Select end time',
                onTimeChanged: widget.onEndTimeChanged,
                use24HourFormat: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShiftSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray200,
          width: TossSpacing.space1 / 4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                IconMapper.getIcon('users'),
                color: TossColors.gray700,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Shift Settings',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Number of Employees
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Required Employees',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      'Number of staff needed for this shift',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              // Stepper for number
              Row(
                children: [
                  _buildStepperButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (_numberShift > 1) {
                        setState(() => _numberShift--);
                        widget.onNumberShiftChanged?.call(_numberShift);
                      }
                    },
                    enabled: _numberShift > 1,
                  ),
                  Container(
                    width: 48,
                    alignment: Alignment.center,
                    child: Text(
                      '$_numberShift',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                  ),
                  _buildStepperButton(
                    icon: Icons.add,
                    onTap: () {
                      if (_numberShift < 99) {
                        setState(() => _numberShift++);
                        widget.onNumberShiftChanged?.call(_numberShift);
                      }
                    },
                    enabled: _numberShift < 99,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),
          const Divider(height: 1, color: TossColors.gray200),
          const SizedBox(height: TossSpacing.space4),

          // Allow Overtime Toggle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Allow Overtime',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      'Enable overtime work for this shift',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isCanOvertime,
                onChanged: (value) {
                  setState(() => _isCanOvertime = value);
                  widget.onIsCanOvertimeChanged?.call(value);
                },
                activeTrackColor: TossColors.primary.withValues(alpha: 0.5),
                activeThumbColor: TossColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationDisplay() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.success.withValues(alpha: 0.2),
          width: TossSpacing.space1 / 4,
        ),
      ),
      child: Row(
        children: [
          Icon(
            IconMapper.getIcon('stopwatch'),
            color: TossColors.success,
            size: TossSpacing.iconSM,
          ),
          const SizedBox(width: TossSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Duration',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                calculateDuration(
                  widget.selectedStartTime!,
                  widget.selectedEndTime!,
                ),
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting
            ? null
            : () async {
                if (_nameController.text.isEmpty) {
                  await showDialog<bool>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => TossDialog.error(
                      title: 'Validation Error',
                      message: 'Please enter shift name',
                      primaryButtonText: 'OK',
                    ),
                  );
                  return;
                }

                if (widget.selectedStartTime == null ||
                    widget.selectedEndTime == null) {
                  await showDialog<bool>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => TossDialog.error(
                      title: 'Validation Error',
                      message: 'Please select start and end times',
                      primaryButtonText: 'OK',
                    ),
                  );
                  return;
                }

                setState(() => _isSubmitting = true);

                final bonus =
                    int.tryParse(_bonusController.text.replaceAll(',', '')) ?? 0;

                await widget.onSave(
                  _nameController.text,
                  widget.selectedStartTime!,
                  widget.selectedEndTime!,
                  bonus,
                  _numberShift,
                  _isCanOvertime,
                );

                if (mounted) {
                  setState(() => _isSubmitting = false);
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          foregroundColor: TossColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: TossColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.buttonText,
                style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  /// Helper: Build stepper button for number input
  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? TossColors.gray200 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Icon(
          icon,
          size: TossSpacing.iconSM,
          color: enabled ? TossColors.gray700 : TossColors.gray400,
        ),
      ),
    );
  }
}
