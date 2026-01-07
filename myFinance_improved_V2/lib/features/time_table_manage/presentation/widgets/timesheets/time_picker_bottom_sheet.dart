import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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

  int _selectedHour = 0;
  int _selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
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

          // Safe area bottom padding
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: TossDimensions.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: TossColors.gray100)),
      ),
      child: Row(
        children: [
          // Left spacer to balance the close button
          SizedBox(width: TossDimensions.avatarLG),
          // Title centered
          Expanded(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TossTextStyles.titleMedium.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: TossColors.gray900,
              ),
            ),
          ),
          // Close button on the right
          IconButton(
            icon: const Icon(Icons.close, size: TossSpacing.iconMD, color: TossColors.gray900),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(TossSpacing.space4, TossSpacing.space3, TossSpacing.space4, TossSpacing.space4),
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
                  fontWeight: TossFontWeight.medium,
                ),
              ),
              Text(
                widget.recordedTime,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: TossFontWeight.medium,
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
      height: TossDimensions.timePickerHeight,
      child: Stack(
        children: [
          // Selection Band (light blue background)
          Positioned.fill(
            child: Center(
              child: Container(
                height: TossDimensions.timePickerSelectionHeight,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: TossOpacity.hover),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
            ),
          ),

          // Time Columns (Hours and Minutes only)
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
      width: TossDimensions.timePickerColumnWidth,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: TossDimensions.timePickerItemExtent,
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
                  fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.medium,
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
      padding: const EdgeInsets.fromLTRB(TossSpacing.space4, TossSpacing.space2, TossSpacing.space4, TossSpacing.space4),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: TossColors.gray100)),
      ),
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: TossButton.secondary(
              text: 'Cancel',
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SizedBox(width: TossSpacing.space2),

          // Confirm Button
          Expanded(
            child: TossButton.primary(
              text: 'Confirm time',
              fullWidth: true,
              onPressed: () {
                final selectedTime = TimeOfDay(
                  hour: _selectedHour,
                  minute: _selectedMinute,
                );
                widget.onConfirm(selectedTime, 0); // seconds fixed to 0
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to format TimeOfDay as HH:mm:ss (seconds always 00)
extension TimeOfDayExtension on TimeOfDay {
  String toFormattedString({int seconds = 0}) {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    // Always use 00 for seconds
    return '$hourStr:$minuteStr:00';
  }
}
