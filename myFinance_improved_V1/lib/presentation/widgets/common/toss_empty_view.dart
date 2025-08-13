import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';

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
        padding: EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(height: TossSpacing.space4),
            ],
            Text(
              title,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              SizedBox(height: TossSpacing.space2),
              Text(
                description!,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: TossSpacing.space6),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}