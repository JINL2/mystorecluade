/// Complex Template Card - Warning card for complex template setup
///
/// Purpose: Informs users when a template requires complex setup:
/// - Shows descriptive warning about complexity
/// - Provides action button to open detailed mode
/// - Uses consistent warning styling
/// - Guides users to appropriate interface
///
/// Usage: ComplexTemplateCard(onOpenDetailed: callback)
import 'package:flutter/material.dart';
import '../../../../../../core/themes/toss_colors.dart';
import '../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../core/themes/toss_border_radius.dart';

class ComplexTemplateCard extends StatelessWidget {
  final VoidCallback? onOpenDetailed;
  final String title;
  final String description;
  final String buttonText;
  
  const ComplexTemplateCard({
    super.key,
    this.onOpenDetailed,
    this.title = 'Complex Template',
    this.description = 'This template requires detailed setup including debt configuration, multiple selections, and validation.',
    this.buttonText = 'Open Detailed Setup',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: TossColors.gray600, size: 20),
              SizedBox(width: TossSpacing.space2),
              Text(
                title,
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            description,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          TextButton.icon(
            onPressed: onOpenDetailed,
            icon: Icon(Icons.open_in_full, size: 16),
            label: Text(buttonText),
            style: TextButton.styleFrom(
              foregroundColor: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}