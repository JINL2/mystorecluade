import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/icon_mapper.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_text_field.dart';
import '../../../../shared/widgets/toss/toss_time_picker.dart';
import '../../domain/entities/store_shift.dart';
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
                    selectedStartTime: selectedStartTime,
                    selectedEndTime: selectedEndTime,
                    onStartTimeChanged: (time) {
                      setState(() => selectedStartTime = time);
                    },
                    onEndTimeChanged: (time) {
                      setState(() => selectedEndTime = time);
                    },
                    onSave: (name, startTime, endTime, bonus) async {
                      try {
                        await ref.read(updateShiftProvider)(
                          shiftId: shift.shiftId,
                          shiftName: name,
                          startTime: _formatTimeOfDay(startTime),
                          endTime: _formatTimeOfDay(endTime),
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
                    onSave: (name, startTime, endTime, bonus) async {
                      try {
                        await ref.read(createShiftProvider)(
                          storeId: storeId,
                          shiftName: name,
                          startTime: _formatTimeOfDay(startTime),
                          endTime: _formatTimeOfDay(endTime),
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
  final TimeOfDay? selectedStartTime;
  final TimeOfDay? selectedEndTime;
  final void Function(TimeOfDay) onStartTimeChanged;
  final void Function(TimeOfDay) onEndTimeChanged;
  final Future<void> Function(String name, TimeOfDay startTime, TimeOfDay endTime, int bonus) onSave;
  final String buttonText;

  const _ShiftFormContent({
    required this.initialName,
    required this.initialBonus,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onSave,
    required this.buttonText,
  });

  @override
  State<_ShiftFormContent> createState() => _ShiftFormContentState();
}

class _ShiftFormContentState extends State<_ShiftFormContent> {
  late TextEditingController _nameController;
  late TextEditingController _bonusController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _bonusController = TextEditingController(
      text: widget.initialBonus == 0 ? '' : NumberFormatter.formatWithCommas(widget.initialBonus),
    );
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
                  FaIcon(
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
                FaIcon(
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
}

/// Helper: Parse time string to TimeOfDay and convert from UTC to local
///
/// **중요:** DB에 저장된 UTC 시간을 로컬 시간으로 변환합니다.
/// 예: DB의 UTC 06:15 → 한국(UTC+9)에서 15:15로 표시
TimeOfDay? _parseTimeString(String timeString) {
  try {
    // Parse "HH:mm" or "HH:mm:ss" format
    final parts = timeString.split(':');
    if (parts.length >= 2) {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Create a UTC DateTime object with today's date and the parsed time
      final now = DateTime.now();
      final utcDateTime = DateTime.utc(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // Convert to local time
      final localDateTime = utcDateTime.toLocal();

      // Return as TimeOfDay in local timezone
      return TimeOfDay(hour: localDateTime.hour, minute: localDateTime.minute);
    }
  } catch (e) {
    // Return null if parsing fails
  }
  return null;
}

/// Helper: Format TimeOfDay to "HH:mm" string and convert to UTC
///
/// **중요:** 사용자가 선택한 로컬 시간을 UTC로 변환하여 DB에 저장합니다.
/// 예: 한국(UTC+9)에서 15:15 선택 → UTC 06:15로 변환
String _formatTimeOfDay(TimeOfDay time) {
  // Create a DateTime object with today's date and the selected time (in local timezone)
  final now = DateTime.now();
  final localDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  // Convert to UTC
  final utcDateTime = localDateTime.toUtc();

  // Return UTC time in HH:mm format
  final hour = utcDateTime.hour.toString().padLeft(2, '0');
  final minute = utcDateTime.minute.toString().padLeft(2, '0');
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
