import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_spacing.dart';

/// Toss-style bottom sheet with smooth animations
class TossBottomSheet extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<TossActionItem>? actions;
  final bool showHandle;
  
  const TossBottomSheet({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.showHandle = true,
  });
  
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<TossActionItem>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: TossColors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => TossBottomSheet(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Use DraggableScrollableSheet for better handling of large content
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8, // 80% of screen height
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
        boxShadow: TossShadows.bottomSheet,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(
              width: TossSpacing.space9,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
          if (title != null) ...[
            const SizedBox(height: TossSpacing.space5),
            Text(
              title!,
              style: TossTextStyles.h3,
              textAlign: TextAlign.center,
            ),
          ],
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: content,
            ),
          ),
          if (actions != null) ...[
            const Divider(color: TossColors.gray200, height: 1),
            ...actions!.map((action) => _buildActionItem(context, action)),
          ],
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
  
  Widget _buildActionItem(BuildContext context, TossActionItem action) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
        action.onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        child: Row(
          children: [
            if (action.icon != null) ...[
              Icon(
                action.icon,
                size: TossSpacing.iconLG,
                color: action.isDestructive ? TossColors.error : TossColors.gray700,
              ),
              const SizedBox(width: TossSpacing.space4),
            ],
            Expanded(
              child: Text(
                action.title,
                style: TossTextStyles.body.copyWith(
                  color: action.isDestructive ? TossColors.error : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: TossSpacing.iconMD,
              color: TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}

/// Action item for TossBottomSheet
class TossActionItem {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isDestructive;
  
  const TossActionItem({
    required this.title,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
  });
}