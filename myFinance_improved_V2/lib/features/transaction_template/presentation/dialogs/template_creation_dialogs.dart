/// Template Creation Dialogs - UI feedback dialogs for template creation
///
/// Purpose: Provides user feedback dialogs for template creation results:
/// - Success dialog with confirmation message and navigation
/// - Error dialog with detailed error information
/// - Consistent styling with Toss design system
/// - Simple dismiss and navigation actions
///
/// Usage: TemplateCreationDialogs.showSuccess(context), TemplateCreationDialogs.showError(context, error)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';

class TemplateCreationDialogs {
  /// Show success dialog
  static Future<void> showSuccess(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: TossColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: TossColors.success,
                  size: 40,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Success!',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Template created successfully',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.pop();
              },
              child: Text(
                'OK',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  /// Show error dialog
  static Future<void> showError(BuildContext context, String error) async {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: TossColors.errorLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: TossColors.error,
                  size: 40,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Error',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Failed to create template',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                error,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'OK',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}