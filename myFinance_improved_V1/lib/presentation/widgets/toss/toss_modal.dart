import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_shadows.dart';
import 'toss_primary_button.dart';

/// Base modal component that prevents common anti-patterns
/// Eliminates StatefulBuilder conflicts and provides consistent modal behavior
class TossModal extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final bool showHandleBar;
  final double? height;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool isScrollControlled;

  const TossModal({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.actions,
    this.onClose,
    this.showCloseButton = true,
    this.showHandleBar = true,
    this.height,
    this.padding,
    this.backgroundColor,
    this.isScrollControlled = true,
  });

  /// Show modal as bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget child,
    List<Widget>? actions,
    VoidCallback? onClose,
    bool showCloseButton = true,
    bool showHandleBar = true,
    double? height,
    EdgeInsets? padding,
    Color? backgroundColor,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54, // Standard barrier color to prevent double barriers
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag, // Allow swipe-to-dismiss by default
      builder: (context) => TossModal(
        title: title,
        subtitle: subtitle,
        child: child,
        actions: actions,
        onClose: onClose ?? (() => Navigator.of(context).pop()),
        showCloseButton: showCloseButton,
        showHandleBar: showHandleBar,
        height: height,
        padding: padding,
        backgroundColor: backgroundColor,
        isScrollControlled: isScrollControlled,
      ),
    );
  }

  @override
  State<TossModal> createState() => _TossModalState();
}

class _TossModalState extends State<TossModal> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.enter,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.enter,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modalHeight = widget.height ?? MediaQuery.of(context).size.height * 0.8;
    // Get keyboard height for dynamic adjustment
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: modalHeight,
                minHeight: 0,
              ),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? TossColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(TossBorderRadius.xl),
                ),
                boxShadow: TossShadows.bottomSheet,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  if (widget.showHandleBar)
                    Container(
                      margin: EdgeInsets.only(top: TossSpacing.space3),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: TossColors.gray300, // Restore grey handle bar
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                  // Header
                  _buildHeader(),

                  // Content - Now with flexible sizing and scroll capability
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: keyboardHeight > 0 ? 20 : 0, // Extra padding when keyboard shown
                      ),
                      child: widget.child,
                    ),
                  ),

                  // Actions
                  if (widget.actions != null && widget.actions!.isNotEmpty)
                    _buildActions(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TossTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                if (widget.subtitle != null)
                  Padding(
                    padding: EdgeInsets.only(top: TossSpacing.space1),
                    child: Text(
                      widget.subtitle!,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.showCloseButton)
            IconButton(
              icon: Icon(Icons.close, color: TossColors.gray600),
              onPressed: () {
                FocusScope.of(context).unfocus();
                widget.onClose?.call();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space5,
        TossSpacing.space4,
        TossSpacing.space5,
        MediaQuery.of(context).padding.bottom + TossSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? TossColors.background,
        border: Border(
          top: BorderSide(color: TossColors.gray200, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.actions!,
        ),
      ),
    );
  }
}

/// Specialized modal for forms with built-in save/cancel actions
class TossFormModal extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final String saveButtonText;
  final String cancelButtonText;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final bool isLoading;
  final bool saveEnabled;

  const TossFormModal({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.saveButtonText = 'Save',
    this.cancelButtonText = 'Cancel',
    this.onSave,
    this.onCancel,
    this.isLoading = false,
    this.saveEnabled = true,
  });

  /// Show form modal as bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget child,
    String saveButtonText = 'Save',
    String cancelButtonText = 'Cancel',
    VoidCallback? onSave,
    VoidCallback? onCancel,
    bool isLoading = false,
    bool saveEnabled = true,
  }) {
    return TossModal.show<T>(
      context: context,
      title: title,
      subtitle: subtitle,
      child: child,
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: onCancel ?? (() {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                }),
                child: Text(
                  cancelButtonText,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            Expanded(
              flex: 2,
              child: TossPrimaryButton(
                text: saveButtonText,
                onPressed: saveEnabled && !isLoading ? onSave : null,
                isLoading: isLoading,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  State<TossFormModal> createState() => _TossFormModalState();
}

class _TossFormModalState extends State<TossFormModal> {
  @override
  Widget build(BuildContext context) {
    return TossModal(
      title: widget.title,
      subtitle: widget.subtitle,
      child: widget.child,
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: widget.onCancel ?? (() {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                }),
                child: Text(
                  widget.cancelButtonText,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            Expanded(
              flex: 2,
              child: TossPrimaryButton(
                text: widget.saveButtonText,
                onPressed: widget.saveEnabled && !widget.isLoading ? widget.onSave : null,
                isLoading: widget.isLoading,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Confirmation modal with standard actions
class TossConfirmationModal extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;

  const TossConfirmationModal({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.icon,
  });

  /// Show confirmation modal
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? icon,
  }) {
    return TossModal.show<bool>(
      context: context,
      title: title,
      height: 300,
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 48,
                color: confirmColor ?? TossColors.primary,
              ),
              SizedBox(height: TossSpacing.space4),
            ],
            Text(
              message,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  onCancel?.call();
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  cancelText,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            Expanded(
              child: TossPrimaryButton(
                text: confirmText,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  onConfirm?.call();
                  Navigator.of(context).pop(true);
                },
                fullWidth: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is handled by the static show method
    return const SizedBox.shrink();
  }
}