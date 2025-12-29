import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../../shared/widgets/toss/toss_text_field.dart';
import '../../../domain/entities/store_shift.dart';
import '../../providers/store_shift_providers.dart';
import 'dialog_utils.dart';
import 'widgets/duration_display.dart';
import 'widgets/shift_save_button.dart';
import 'widgets/shift_settings_section.dart';
import 'widgets/time_settings_section.dart';

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
        child: _ShiftFormSheet(
          height: 0.85,
          title: 'Edit Shift',
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
        child: _ShiftFormSheet(
          height: 0.8,
          title: 'Create New Shift',
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
    ),
  );
}

/// Shift Form Sheet Container
class _ShiftFormSheet extends StatelessWidget {
  final double height;
  final String title;
  final Widget child;

  const _ShiftFormSheet({
    required this.height,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * height,
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
              title,
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
              child: child,
            ),
          ),
        ],
      ),
    );
  }
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
    _numberShift = widget.initialNumberShift;
    _isCanOvertime = widget.initialIsCanOvertime;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bonusController.dispose();
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
        TimeSettingsSection(
          selectedStartTime: widget.selectedStartTime,
          selectedEndTime: widget.selectedEndTime,
          onStartTimeChanged: widget.onStartTimeChanged,
          onEndTimeChanged: widget.onEndTimeChanged,
        ),
        const SizedBox(height: TossSpacing.space6),

        // Shift Settings Section
        ShiftSettingsSection(
          numberShift: _numberShift,
          isCanOvertime: _isCanOvertime,
          onNumberShiftChanged: (value) {
            setState(() => _numberShift = value);
            widget.onNumberShiftChanged?.call(value);
          },
          onIsCanOvertimeChanged: (value) {
            setState(() => _isCanOvertime = value);
            widget.onIsCanOvertimeChanged?.call(value);
          },
        ),
        const SizedBox(height: TossSpacing.space5),

        // Duration Display
        if (widget.selectedStartTime != null && widget.selectedEndTime != null)
          DurationDisplay(
            startTime: widget.selectedStartTime!,
            endTime: widget.selectedEndTime!,
          ),
        const SizedBox(height: TossSpacing.space6),

        // Save Button
        ShiftSaveButton(
          buttonText: widget.buttonText,
          isSubmitting: _isSubmitting,
          onPressed: _handleSave,
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
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

    if (widget.selectedStartTime == null || widget.selectedEndTime == null) {
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
  }
}
