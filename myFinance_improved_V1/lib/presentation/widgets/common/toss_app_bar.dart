import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class TossAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TossAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    // New parameters for custom action buttons
    this.primaryActionText,
    this.primaryActionIcon,
    this.onPrimaryAction,
    this.secondaryActionIcon,
    this.onSecondaryAction,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  
  // Custom action button parameters (max 2 buttons)
  final String? primaryActionText;  // Text for primary button (e.g., "Add")
  final IconData? primaryActionIcon; // Icon for primary button (optional)
  final VoidCallback? onPrimaryAction; // Callback for primary button
  final IconData? secondaryActionIcon; // Icon for secondary button (icon only)
  final VoidCallback? onSecondaryAction; // Callback for secondary button

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    // Build custom action buttons if provided
    List<Widget>? finalActions = actions;
    
    // If no actions provided but custom buttons defined, build them
    if (finalActions == null || finalActions.isEmpty) {
      finalActions = [];
      
      // Add secondary action button (icon only) if provided
      if (secondaryActionIcon != null && onSecondaryAction != null) {
        finalActions.add(
          IconButton(
            icon: Icon(
              secondaryActionIcon,
              color: TossColors.textSecondary,
              size: TossSpacing.iconLG,
            ),
            onPressed: onSecondaryAction,
          ),
        );
      }
      
      // Add primary action button (text with optional icon) if provided
      if (primaryActionText != null && onPrimaryAction != null) {
        finalActions.add(
          Padding(
            padding: EdgeInsets.only(right: TossSpacing.space3),
            child: Material(
              color: TossColors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                onTap: onPrimaryAction,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (primaryActionIcon != null) ...[
                        Icon(
                          primaryActionIcon,
                          size: TossSpacing.iconMD,
                          color: TossColors.primary,
                        ),
                        SizedBox(width: TossSpacing.space1),
                      ],
                      Text(
                        primaryActionText!,
                        style: TossTextStyles.h4.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
      
      // Ensure max 2 action buttons
      if (finalActions.length > 2) {
        finalActions = finalActions.take(2).toList();
      }
    }
    
    return AppBar(
      title: Text(
        title,
        style: TossTextStyles.h3.copyWith(
          color: TossColors.textPrimary,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? TossColors.gray100,
      elevation: elevation,
      leading: leading,
      actions: finalActions.isNotEmpty ? finalActions : null,
      iconTheme: IconThemeData(
        color: TossColors.textPrimary,
      ),
    );
  }
}