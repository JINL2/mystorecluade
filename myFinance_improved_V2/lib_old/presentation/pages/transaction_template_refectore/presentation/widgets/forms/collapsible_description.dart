/// Collapsible Description - Optional description input for quick templates
///
/// Purpose: Provides an optional, space-saving description input that:
/// - Starts collapsed to save space in quick mode
/// - Expands when user wants to add description
/// - Uses consistent styling with Toss design system
/// - Supports multi-line input for detailed descriptions
///
/// Usage: CollapsibleDescription(controller: controller)
import 'package:flutter/material.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_text_field.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';

class CollapsibleDescription extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final bool initiallyExpanded;
  final int maxLines;
  
  const CollapsibleDescription({
    super.key,
    required this.controller,
    this.title = 'Add Description (Optional)',
    this.hintText = 'Transaction description...',
    this.initiallyExpanded = false,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray600,
        ),
      ),
      children: [
        TossTextField(
          controller: controller,
          hintText: hintText,
          maxLines: maxLines,
        ),
      ],
      initiallyExpanded: initiallyExpanded,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(bottom: TossSpacing.space2),
    );
  }
  
  /// Check if description has content
  bool get hasContent => controller.text.trim().isNotEmpty;
  
  /// Get trimmed description text
  String get description => controller.text.trim();
}