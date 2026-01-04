import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Dialog shown when account mapping is required for internal transactions
///
/// Displays a warning and allows users to navigate to account settings
/// to set up the required mapping.
class MappingRequiredDialog extends StatelessWidget {
  final String? counterpartyId;
  final String? counterpartyName;
  final VoidCallback onSetupPressed;
  final VoidCallback onCancelPressed;

  const MappingRequiredDialog({
    super.key,
    required this.counterpartyId,
    required this.counterpartyName,
    required this.onSetupPressed,
    required this.onCancelPressed,
  });

  /// Shows the mapping required dialog
  static Future<void> show({
    required BuildContext context,
    required String? counterpartyId,
    required String? counterpartyName,
    required VoidCallback onSetupPressed,
    required VoidCallback onCancelPressed,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return MappingRequiredDialog(
          counterpartyId: counterpartyId,
          counterpartyName: counterpartyName,
          onSetupPressed: () {
            Navigator.of(dialogContext).pop();
            onSetupPressed();
          },
          onCancelPressed: () {
            Navigator.of(dialogContext).pop();
            onCancelPressed();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space6),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: TossColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: TossColors.warning,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Account Mapping Required',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: TossColors.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space3),

            // Message
            Text(
              'This internal counterparty requires an account mapping to be set up first.',
              style: TossTextStyles.body.copyWith(
                fontSize: 15,
                color: TossColors.gray600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Setup Button
            TossButton.primary(
              text: 'Set Up Account Mapping',
              onPressed: onSetupPressed,
              fullWidth: true,
            ),
            const SizedBox(height: TossSpacing.space2),

            // Cancel Button
            TossButton.textButton(
              text: 'Cancel',
              onPressed: onCancelPressed,
            ),
          ],
        ),
      ),
    );
  }
}
