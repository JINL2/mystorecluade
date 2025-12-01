import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/icon_mapper.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../shared/widgets/toss/toss_text_field.dart';
import '../../../../shared/widgets/toss/toss_time_picker.dart';
import '../../domain/entities/store_shift.dart';
import '../../domain/value_objects/shift_params.dart';
import '../providers/store_shift_providers.dart';

/// Show Edit Shift Dialog
void showEditShiftDialog(
  BuildContext context,
  WidgetRef ref,
  StoreShift shift,
  String storeId,
) {
  // Parse existing time strings to TimeOfDay
  TimeOfDay? selectedStartTime = _parseTimeString(shift.startTime);
  TimeOfDay? selectedEndTime = _parseTimeString(shift.endTime);
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
                  child: _ShiftFormContent(
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
                          startTime: _formatTimeOfDay(startTime),
                          endTime: _formatTimeOfDay(endTime),
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
                  child: _ShiftFormContent(
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
                          startTime: _formatTimeOfDay(startTime),
                          endTime: _formatTimeOfDay(endTime),
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

/// Show Delete Confirmation Dialog
void showDeleteShiftDialog(
  BuildContext context,
  WidgetRef ref,
  StoreShift shift,
) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Shift'),
      content: Text('Are you sure you want to delete "${shift.shiftName}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await ref.read(deleteShiftProvider)(shift.shiftId);
              if (context.mounted) {
                Navigator.pop(context);
                await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => TossDialog.success(
                    title: 'Shift Deleted',
                    message: 'Shift deleted successfully',
                    primaryButtonText: 'OK',
                  ),
                );
              }
              ref.invalidate(storeShiftsProvider);
            } catch (e) {
              if (context.mounted) {
                Navigator.pop(context);
                await showDialog<bool>(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => TossDialog.error(
                    title: 'Delete Failed',
                    message: 'Failed to delete: $e',
                    primaryButtonText: 'OK',
                  ),
                );
              }
            }
          },
          style: TextButton.styleFrom(foregroundColor: TossColors.error),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

/// Shift Form Content Widget
class _ShiftFormContent extends StatefulWidget {
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
  final Future<void> Function(String name, TimeOfDay startTime, TimeOfDay endTime, int bonus, int numberShift, bool isCanOvertime) onSave;
  final String buttonText;

  const _ShiftFormContent({
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
  State<_ShiftFormContent> createState() => _ShiftFormContentState();
}

class _ShiftFormContentState extends State<_ShiftFormContent> {
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
      text: widget.initialBonus == 0 ? '' : NumberFormatter.formatWithCommas(widget.initialBonus),
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
                final numericValue = int.tryParse(newValue.text.replaceAll(',', '')) ?? 0;
                final formattedValue = NumberFormatter.formatWithCommas(numericValue);
                return TextEditingValue(
                  text: formattedValue,
                  selection: TextSelection.collapsed(offset: formattedValue.length),
                );
              }
              return newValue;
            }),
          ],
        ),

        const SizedBox(height: TossSpacing.space6),

        // Time Settings Section
        Container(
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
        ),

        const SizedBox(height: TossSpacing.space6),

        // Shift Settings Section (Number of Employees & Overtime)
        Container(
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
        ),

        const SizedBox(height: TossSpacing.space5),

        // Duration Display
        if (widget.selectedStartTime != null && widget.selectedEndTime != null)
          Container(
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
                      _calculateDuration(widget.selectedStartTime!, widget.selectedEndTime!),
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        const SizedBox(height: TossSpacing.space6),

        // Save Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : () async {
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

              final bonus = int.tryParse(_bonusController.text.replaceAll(',', '')) ?? 0;

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
        ),
      ],
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

/// Helper: Parse time string to TimeOfDay from timetz format
///
/// **중요:** DB에 저장된 timetz 값을 파싱합니다.
/// 예: "14:00:00+09:00" → TimeOfDay(14, 0)
/// PostgreSQL은 timetz를 클라이언트 타임존으로 자동 변환하여 반환합니다.
TimeOfDay? _parseTimeString(String timeString) {
  try {
    // Remove timezone offset if present (e.g., "14:00:00+09:00" → "14:00:00")
    String cleanedTime = timeString;
    if (timeString.contains('+') || timeString.contains('-')) {
      // Find the position of timezone offset
      final plusIndex = timeString.indexOf('+');
      final minusIndex = timeString.lastIndexOf('-');
      final offsetIndex = plusIndex != -1 ? plusIndex : minusIndex;

      if (offsetIndex > 0) {
        cleanedTime = timeString.substring(0, offsetIndex);
      }
    }

    // Parse "HH:mm" or "HH:mm:ss" format
    final parts = cleanedTime.split(':');
    if (parts.length >= 2) {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Return as TimeOfDay (already in local timezone from DB)
      return TimeOfDay(hour: hour, minute: minute);
    }
  } catch (e) {
    // Return null if parsing fails
  }
  return null;
}

/// Helper: Format TimeOfDay to "HH:mm" string (local time only)
///
/// **중요:** RPC 함수가 타임존을 별도 파라미터로 받으므로 시간만 전달합니다.
/// 예: 7:00 AM 선택 → "07:00"
/// RPC에서 p_timezone과 함께 UTC로 변환됩니다.
String _formatTimeOfDay(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');

  return '$hour:$minute';
}

/// Helper: Calculate duration between start and end times
String _calculateDuration(TimeOfDay start, TimeOfDay end) {
  int startMinutes = start.hour * 60 + start.minute;
  int endMinutes = end.hour * 60 + end.minute;

  // Handle overnight shifts
  if (endMinutes < startMinutes) {
    endMinutes += 24 * 60;
  }

  int durationMinutes = endMinutes - startMinutes;
  int hours = durationMinutes ~/ 60;
  int minutes = durationMinutes % 60;

  if (minutes == 0) {
    return '$hours hours';
  }
  return '$hours hours $minutes minutes';
}

/// Show Operational Settings Dialog
void showOperationalSettingsDialog(BuildContext context, Map<String, dynamic> store) {
  TossBottomSheet.show<void>(
    context: context,
    title: 'Edit Operational Settings',
    content: _OperationalSettingsContent(store: store),
  );
}

/// Operational Settings Content Widget
class _OperationalSettingsContent extends ConsumerStatefulWidget {
  final Map<String, dynamic> store;

  const _OperationalSettingsContent({required this.store});

  @override
  ConsumerState<_OperationalSettingsContent> createState() => _OperationalSettingsContentState();
}

class _OperationalSettingsContentState extends ConsumerState<_OperationalSettingsContent> {
  late final TextEditingController _huddleTimeController;
  late final TextEditingController _paymentTimeController;
  late final TextEditingController _allowedDistanceController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _huddleTimeController = TextEditingController(
      text: (widget.store['huddle_time'] ?? 15).toString(),
    );
    _paymentTimeController = TextEditingController(
      text: (widget.store['payment_time'] ?? 30).toString(),
    );
    _allowedDistanceController = TextEditingController(
      text: (widget.store['allowed_distance'] ?? 100).toString(),
    );
  }

  @override
  void dispose() {
    _huddleTimeController.dispose();
    _paymentTimeController.dispose();
    _allowedDistanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Huddle Time
          TossTextField(
          label: 'Huddle Time',
          hintText: '15',
          controller: _huddleTimeController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: TossSpacing.space3),
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: 1.0,
              child: Text(
                'minutes',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Time allocated for team meetings',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: TossSpacing.space5),

        // Payment Time
        TossTextField(
          label: 'Payment Time',
          hintText: '30',
          controller: _paymentTimeController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: TossSpacing.space3),
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: 1.0,
              child: Text(
                'minutes',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Time allocated for payment processing',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: TossSpacing.space5),

        // Check-in Distance
        TossTextField(
          label: 'Check-in Distance',
          hintText: '100',
          controller: _allowedDistanceController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: TossSpacing.space3),
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: 1.0,
              child: Text(
                'meters',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Maximum distance from store for check-in',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: TossSpacing.space6),

        // Save Button
        TossPrimaryButton(
          text: 'Save Changes',
          onPressed: _isSubmitting ? null : _handleSave,
          fullWidth: true,
          leadingIcon: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: TossColors.white,
                    strokeWidth: 2,
                  ),
                )
              : null,
        ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isSubmitting = true);

    try {
      final useCase = ref.read(updateOperationalSettingsUseCaseProvider);
      await useCase(UpdateOperationalSettingsParams(
        storeId: widget.store['store_id'] as String,
        huddleTime: int.tryParse(_huddleTimeController.text),
        paymentTime: int.tryParse(_paymentTimeController.text),
        allowedDistance: int.tryParse(_allowedDistanceController.text),
      ),);

      if (mounted) {
        // Refresh store details
        ref.invalidate(storeDetailsProvider);

        Navigator.pop(context);
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Settings Updated',
            message: 'Operational settings updated successfully',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update settings: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
}
