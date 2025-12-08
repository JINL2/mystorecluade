import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

class TossEmptyView extends StatelessWidget {
  const TossEmptyView({
    super.key,
    this.icon,
    required this.title,
    this.description,
    this.action,
  });

  final Widget? icon;
  final String title;
  final String? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: TossSpacing.space4),
            ],
            Text(
              title,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: TossSpacing.space2),
              Text(
                description!,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: TossSpacing.space6),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}