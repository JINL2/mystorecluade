import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button_1.dart';

/// A custom time picker bottom sheet for confirming check-in/check-out times.
///
/// This bottom sheet is displayed when tapping on editable time fields
/// in the Shift Details Management screen.
class TimePickerBottomSheet extends StatefulWidget {
  final String title;
  final String recordedTimeLabel;
  final String recordedTime;
  final TimeOfDay initialTime;
  final int initialSeconds;
  final Function(TimeOfDay, int) onConfirm;

  const TimePickerBottomSheet({
    super.key,
    required this.title,
    required this.recordedTimeLabel,
    required this.recordedTime,
    required this.initialTime,
    this.initialSeconds = 0,
    required this.onConfirm,
  });

  /// Shows the time picker bottom sheet and returns the selected time with seconds
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required String title,
    required String recordedTimeLabel,
    required String recordedTime,
    required TimeOfDay initialTime,
    int initialSeconds = 0,
  }) async {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => TimePickerBottomSheet(
        title: title,
        recordedTimeLabel: recordedTimeLabel,
        recordedTime: recordedTime,
        initialTime: initialTime,
        initialSeconds: initialSeconds,
        onConfirm: (time, seconds) => Navigator.of(context).pop({
          'time': time,
          'seconds': seconds,
        }),
      ),
    );
  }

  @override
  State<TimePickerBottomSheet> createState() => _TimePickerBottomSheetState();
}

class _TimePickerBottomSheetState extends State<TimePickerBottomSheet> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _secondController;

  int _selectedHour = 0;
  int _selectedMinute = 0;
  int _selectedSecond = 0;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
    _selectedSecond = widget.initialSeconds;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
    _secondController = FixedExtentScrollController(initialItem: _selectedSecond);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(),

          // Content
          _buildContent(),

          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: TossColors.gray100)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            widget.title,
            style: TossTextStyles.titleMedium.copyWith(
              color: TossColors.gray900,
            ),
          ),
          Positioned(
            right: -8,
            child: IconButton(
              icon: const Icon(Icons.close, size: 20, color: TossColors.gray900),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          // Summary Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.recordedTimeLabel,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.recordedTime,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Time Picker
          _buildTimePicker(),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return SizedBox(
      height: 144,
      child: Stack(
        children: [
          // Selection Band (light blue background)
          Positioned.fill(
            child: Center(
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
            ),
          ),

          // Time Columns
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hours
              _buildTimeColumn(
                controller: _hourController,
                itemCount: 24,
                selectedValue: _selectedHour,
                onChanged: (value) => setState(() => _selectedHour = value),
              ),
              const SizedBox(width: TossSpacing.space4),

              // Minutes
              _buildTimeColumn(
                controller: _minuteController,
                itemCount: 60,
                selectedValue: _selectedMinute,
                onChanged: (value) => setState(() => _selectedMinute = value),
              ),
              const SizedBox(width: TossSpacing.space4),

              // Seconds
              _buildTimeColumn(
                controller: _secondController,
                itemCount: 60,
                selectedValue: _selectedSecond,
                onChanged: (value) => setState(() => _selectedSecond = value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn({
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedValue,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      width: 72,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 28,
        perspective: 0.005,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final isSelected = index == selectedValue;
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? TossColors.primary : TossColors.gray600,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: TossColors.gray100)),
      ),
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: TossButton1.secondary(
              text: 'Cancel',
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 8),

          // Confirm Button
          Expanded(
            child: TossButton1.primary(
              text: 'Confirm time',
              fullWidth: true,
              onPressed: () {
                final selectedTime = TimeOfDay(
                  hour: _selectedHour,
                  minute: _selectedMinute,
                );
                widget.onConfirm(selectedTime, _selectedSecond);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to format TimeOfDay with seconds
extension TimeOfDayExtension on TimeOfDay {
  String toFormattedString({int seconds = 0}) {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    final secondStr = seconds.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr:$secondStr';
  }
}
