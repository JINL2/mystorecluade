import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Attendance tab widget
class AttendanceTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const AttendanceTab({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(bottom: TossSpacing.space3),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? TossColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? TossColors.gray900 : TossColors.gray500,
          ),
        ),
      ),
    );
  }
}
