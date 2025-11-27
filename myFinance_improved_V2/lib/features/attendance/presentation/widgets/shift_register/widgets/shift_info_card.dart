import 'package:flutter/material.dart';
import '../../../../../core/theme/toss_theme.dart';

/// Reusable shift information card component
class ShiftInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ShiftInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: TossColors.gray500),
        const SizedBox(width: TossSpacing.space1),
        Text(
          '$label:',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
