import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Success Dialog for Create Business
///
/// Shows company creation success with company code and copy functionality.
class CreateBusinessSuccessDialog extends StatelessWidget {
  final String companyName;
  final String companyCode;

  const CreateBusinessSuccessDialog({
    super.key,
    required this.companyName,
    required this.companyCode,
  });

  /// Show the dialog and return whether user wants to create store
  static Future<bool?> show(
    BuildContext context, {
    required String companyName,
    required String companyCode,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateBusinessSuccessDialog(
        companyName: companyName,
        companyCode: companyCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Business Created!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your business "$companyName" has been created successfully.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TossSpacing.space4),
          _buildCompanyCodeSection(context),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Share this code with your team members to invite them.',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
            ),
            child: const Text('Create Store'),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyCodeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        children: [
          Text(
            'Company Code:',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                companyCode,
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: TossSpacing.space2),
              IconButton(
                icon: const Icon(
                  Icons.copy,
                  color: TossColors.primary,
                  size: 20,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: companyCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Company code copied!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Copy code',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
