import 'package:flutter/material.dart';

import '../../../../../../core/constants/icon_mapper.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Time Settings Section Widget
///
/// Displays start and end time pickers in a styled container
class TimeSettingsSection extends StatelessWidget {
  final TimeOfDay? selectedStartTime;
  final TimeOfDay? selectedEndTime;
  final void Function(TimeOfDay) onStartTimeChanged;
  final void Function(TimeOfDay) onEndTimeChanged;

  const TimeSettingsSection({
    super.key,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: TossSpacing.space4),
          _buildStartTimePicker(),
          const SizedBox(height: TossSpacing.space4),
          _buildEndTimePicker(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
            fontWeight: TossFontWeight.semibold,
          ),
        ),
      ],
    );
  }

  Widget _buildStartTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start Time',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: TossFontWeight.medium,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTimePicker(
          time: selectedStartTime,
          placeholder: 'Select start time',
          onTimeChanged: onStartTimeChanged,
          use24HourFormat: false,
        ),
      ],
    );
  }

  Widget _buildEndTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'End Time',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: TossFontWeight.medium,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTimePicker(
          time: selectedEndTime,
          placeholder: 'Select end time',
          onTimeChanged: onEndTimeChanged,
          use24HourFormat: false,
        ),
      ],
    );
  }
}
