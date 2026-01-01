import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Homepage Alert Dialog with "Don't show again" checkbox
///
/// Displays a notice dialog with option to suppress future alerts.
class HomepageAlertDialog extends StatefulWidget {
  final String message;
  final void Function(bool dontShow) onDontShowAgain;

  const HomepageAlertDialog({
    super.key,
    required this.message,
    required this.onDontShowAgain,
  });

  @override
  State<HomepageAlertDialog> createState() => _HomepageAlertDialogState();
}

class _HomepageAlertDialogState extends State<HomepageAlertDialog> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return TossDialog(
      title: 'Notice',
      message: widget.message,
      type: TossDialogType.info,
      icon: Icons.info_outline,
      iconColor: TossColors.info,
      primaryButtonText: 'OK',
      onPrimaryPressed: () {
        widget.onDontShowAgain(_dontShowAgain);
        Navigator.of(context).pop();
      },
      customContent: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _dontShowAgain,
              onChanged: (value) {
                setState(() {
                  _dontShowAgain = value ?? false;
                });
              },
              activeColor: TossColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _dontShowAgain = !_dontShowAgain;
              });
            },
            child: Text(
              "Don't show again",
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
