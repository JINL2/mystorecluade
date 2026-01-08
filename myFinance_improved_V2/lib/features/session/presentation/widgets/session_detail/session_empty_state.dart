import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Empty state widget for session detail page
/// Used for search empty states and no inventory states
class SessionEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SessionEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: TossSpacing.icon4XL, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space4),
            Text(
              title,
              style: TossTextStyles.h4.copyWith(color: TossColors.textPrimary),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              subtitle,
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          ],
        ),
      ),
    );
  }
}
