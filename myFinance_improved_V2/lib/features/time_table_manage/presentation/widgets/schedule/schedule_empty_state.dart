import 'package:flutter/material.dart';

import '../../../../../shared/themes/index.dart';

/// Empty state widget for schedule tab
///
/// Shows an icon and message when no shifts are available
class ScheduleEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const ScheduleEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.calendar_today_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: TossSpacing.icon3XL,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
