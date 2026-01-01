import 'package:flutter/material.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Recorded Attendance Card widget
///
/// Displays the recorded check-in and check-out times from device logs.
class RecordedAttendanceCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final String recordedCheckIn;
  final String recordedCheckOut;

  const RecordedAttendanceCard({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.recordedCheckIn,
    required this.recordedCheckOut,
  });

  @override
  Widget build(BuildContext context) {
    return TossExpandableCard(
      title: 'Recorded attendance',
      isExpanded: isExpanded,
      onToggle: onToggle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(label: 'Recorded check-in', value: recordedCheckIn),
          const SizedBox(height: 12),
          _buildInfoRow(label: 'Recorded check-out', value: recordedCheckOut),
          const SizedBox(height: 12),
          Text(
            'Based on check-in/out device logs.',
            style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return InfoRow.between(
      label: label,
      value: value,
    );
  }
}
