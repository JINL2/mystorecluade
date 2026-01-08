import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Header section with session name and delete button
class CountDetailHeaderSection extends StatelessWidget {
  final String sessionName;
  final bool isOwner;
  final bool isDeleting;
  final VoidCallback? onDelete;

  const CountDetailHeaderSection({
    super.key,
    required this.sessionName,
    required this.isOwner,
    required this.isDeleting,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title (Session Name)
          Expanded(
            child: Text(
              sessionName,
              style: TossTextStyles.titleLarge.copyWith(
                fontWeight: TossFontWeight.bold,
                color: TossColors.gray900,
              ),
            ),
          ),
          // Delete button (only visible to session owner)
          if (isOwner)
            GestureDetector(
              onTap: isDeleting ? null : onDelete,
              child: isDeleting
                  ? TossLoadingView.inline(size: TossSpacing.iconMD + 2, color: TossColors.loss)
                  : const Icon(
                      Icons.delete_outline,
                      color: TossColors.loss,
                      size: TossSpacing.iconMD + 2,
                    ),
            ),
        ],
      ),
    );
  }
}
