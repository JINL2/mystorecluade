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
    this.compact = false,
  });

  final Widget? icon;
  final String title;
  final String? description;
  final Widget? action;

  /// When true, uses smaller padding and font sizes
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final padding = compact ? TossSpacing.space3 : TossSpacing.space6;
    final titleStyle = compact
        ? TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          )
        : TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
          );
    final descriptionStyle = compact
        ? TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          )
        : TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          );

    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(height: compact ? TossSpacing.space2 : TossSpacing.space4),
            ],
            Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              SizedBox(height: compact ? TossSpacing.space1 : TossSpacing.space2),
              Text(
                description!,
                style: descriptionStyle,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: compact ? TossSpacing.space3 : TossSpacing.space6),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
