import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';

enum TossResultType { success, error, warning, info }

class TossResultDialog extends StatefulWidget {
  const TossResultDialog({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
    this.autoDismiss = false,
    this.autoDismissDelay = const Duration(seconds: 2),
  });

  final TossResultType type;
  final String title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool autoDismiss;
  final Duration autoDismissDelay;

  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    String? message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    bool autoDismiss = true,
    Duration autoDismissDelay = const Duration(seconds: 2),
  }) {
    return _show(
      context: context,
      type: TossResultType.success,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      autoDismiss: autoDismiss,
      autoDismissDelay: autoDismissDelay,
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String title,
    String? message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    bool autoDismiss = false,
  }) {
    return _show(
      context: context,
      type: TossResultType.error,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      autoDismiss: autoDismiss,
    );
  }

  static Future<void> _show({
    required BuildContext context,
    required TossResultType type,
    required String title,
    String? message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    bool autoDismiss = false,
    Duration autoDismissDelay = const Duration(seconds: 2),
  }) {
    HapticFeedback.lightImpact();
    
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => TossResultDialog(
        type: type,
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        autoDismiss: autoDismiss,
        autoDismissDelay: autoDismissDelay,
      ),
    );
  }

  @override
  State<TossResultDialog> createState() => _TossResultDialogState();
}

class _TossResultDialogState extends State<TossResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    if (widget.autoDismiss) {
      Future.delayed(widget.autoDismissDelay, () {
        if (mounted) {
          _dismiss();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onButtonPressed?.call();
      }
    });
  }

  IconData _getIcon() {
    switch (widget.type) {
      case TossResultType.success:
        return Icons.check_circle;
      case TossResultType.error:
        return Icons.error;
      case TossResultType.warning:
        return Icons.warning;
      case TossResultType.info:
        return Icons.info;
    }
  }

  Color _getColor() {
    switch (widget.type) {
      case TossResultType.success:
        return TossColors.success;
      case TossResultType.error:
        return TossColors.error;
      case TossResultType.warning:
        return TossColors.warning;
      case TossResultType.info:
        return TossColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();

    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: TossSpacing.space8),
                  padding: EdgeInsets.all(TossSpacing.space6),
                  constraints: const BoxConstraints(
                    maxWidth: 320,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                size: 48,
                                color: color,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: TossSpacing.space5),
                      
                      // Title
                      Text(
                        widget.title,
                        style: TossTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.gray900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      // Message (if provided)
                      if (widget.message != null) ...[
                        SizedBox(height: TossSpacing.space3),
                        Text(
                          widget.message!,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      
                      // Button (if not auto-dismiss or if custom button text provided)
                      if (!widget.autoDismiss || widget.buttonText != null) ...[
                        SizedBox(height: TossSpacing.space6),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _dismiss,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: TossColors.surface,
                              padding: EdgeInsets.symmetric(
                                vertical: TossSpacing.space4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              widget.buttonText ?? 'OK',
                              style: TossTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.surface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}