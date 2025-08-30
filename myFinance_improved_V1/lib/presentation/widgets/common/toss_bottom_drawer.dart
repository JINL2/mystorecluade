import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_shadows.dart';

/// Light mode bottom drawer that slides up from bottom
/// Uses TossColors for consistent styling
class TossBottomDrawer extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<TossDrawerAction>? actions;
  final bool showHandle;
  final double? height;
  final VoidCallback? onClose;
  
  const TossBottomDrawer({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.showHandle = true,
    this.height,
    this.onClose,
  });
  
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<TossDrawerAction>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: TossColors.overlay,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      transitionAnimationController: AnimationController(
        duration: TossAnimations.medium,
        vsync: Navigator.of(context),
      ),
      builder: (context) => TossBottomDrawer(
        title: title,
        content: content,
        actions: actions,
        height: height,
        onClose: onClose,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = height ?? screenHeight * 0.8;
    
    return AnimatedContainer(
      duration: TossAnimations.medium,
      curve: TossAnimations.enter,
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        minHeight: 200,
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
          if (showHandle) _buildHandle(context),
          if (title != null) _buildTitle(context),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space5,
                vertical: TossSpacing.space3,
              ),
              child: content,
            ),
          ),
          if (actions != null) _buildActions(context),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
  
  Widget _buildHandle(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: TossSpacing.space3),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: TossColors.gray300,
            borderRadius: BorderRadius.circular(TossBorderRadius.micro),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
      ],
    );
  }
  
  Widget _buildTitle(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            const SizedBox(width: TossSpacing.space5),
            Expanded(
              child: Text(
                title!,
                style: TossTextStyles.h3,
                textAlign: TextAlign.center,
              ),
            ),
            if (onClose != null)
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  onClose?.call();
                },
                icon: const Icon(
                  Icons.close,
                  color: TossColors.gray600,
                ),
              )
            else
              const SizedBox(width: TossSpacing.space5),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        const Divider(
          color: TossColors.gray200,
          height: 1,
        ),
      ],
    );
  }
  
  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: TossColors.gray200,
          height: 1,
        ),
        ...actions!.map((action) => _buildActionItem(context, action)),
      ],
    );
  }
  
  Widget _buildActionItem(BuildContext context, TossDrawerAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (action.closeOnTap) {
            Navigator.pop(context);
          }
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
                  size: TossSpacing.iconMD,
                  color: action.isDestructive 
                    ? TossColors.error 
                    : TossColors.gray600,
                ),
                const SizedBox(width: TossSpacing.space4),
              ],
              Expanded(
                child: Text(
                  action.title,
                  style: TossTextStyles.body.copyWith(
                    color: action.isDestructive 
                      ? TossColors.error 
                      : TossColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (action.showChevron)
                const Icon(
                  Icons.chevron_right,
                  size: TossSpacing.iconSM,
                  color: TossColors.gray400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Action item for TossBottomDrawer
class TossDrawerAction {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isDestructive;
  final bool closeOnTap;
  final bool showChevron;
  
  const TossDrawerAction({
    required this.title,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
    this.closeOnTap = true,
    this.showChevron = true,
  });
}