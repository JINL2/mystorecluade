import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import '../toss/toss_primary_button.dart';
import '../toss/toss_secondary_button.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
enum TossDialogType {
  success,
  error,
  warning,
  info,
}

class TossDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? message;
  final TossDialogType type;
  final IconData? icon;
  final Color? iconColor;
  final Color backgroundColor;
  final String primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final Widget? customContent;
  final List<TossDialogInfoItem>? infoItems;
  final List<TossDialogAction>? actions;
  final Duration animationDuration;
  final bool dismissible;

  const TossDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.message,
    required this.type,
    this.icon,
    this.iconColor,
    this.backgroundColor = TossColors.white,
    required this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.customContent,
    this.infoItems,
    this.actions,
    this.animationDuration = const Duration(milliseconds: 600),
    this.dismissible = true,
  });

  // Factory constructors for backward compatibility
  factory TossDialog.success({
    Key? key,
    required String title,
    String? subtitle,
    String? message,
    IconData? icon,
    Color? iconColor,
    required String primaryButtonText,
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    Widget? customContent,
    List<TossDialogInfoItem>? infoItems,
    bool dismissible = true,
  }) {
    return TossDialog(
      key: key,
      title: title,
      subtitle: subtitle,
      message: message,
      type: TossDialogType.success,
      icon: icon ?? Icons.check_circle,
      iconColor: iconColor ?? TossColors.success,
      primaryButtonText: primaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      secondaryButtonText: secondaryButtonText,
      onSecondaryPressed: onSecondaryPressed,
      customContent: customContent,
      infoItems: infoItems,
      dismissible: dismissible,
    );
  }

  factory TossDialog.error({
    Key? key,
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    String? primaryButtonText,
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    List<TossDialogAction>? actions,
    bool dismissible = true,
  }) {
    return TossDialog(
      key: key,
      title: title,
      message: message,
      type: TossDialogType.error,
      icon: icon ?? Icons.error_outline,
      iconColor: iconColor ?? TossColors.error,
      primaryButtonText: primaryButtonText ?? 'OK',
      onPrimaryPressed: onPrimaryPressed,
      secondaryButtonText: secondaryButtonText,
      onSecondaryPressed: onSecondaryPressed,
      actions: actions,
      dismissible: dismissible,
    );
  }

  factory TossDialog.warning({
    Key? key,
    required String title,
    required String message,
    IconData? icon,
    String? primaryButtonText,
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    bool dismissible = true,
  }) {
    return TossDialog(
      key: key,
      title: title,
      message: message,
      type: TossDialogType.warning,
      icon: icon ?? Icons.warning_amber_rounded,
      iconColor: TossColors.warning,
      primaryButtonText: primaryButtonText ?? 'OK',
      onPrimaryPressed: onPrimaryPressed,
      secondaryButtonText: secondaryButtonText,
      onSecondaryPressed: onSecondaryPressed,
      dismissible: dismissible,
    );
  }

  factory TossDialog.info({
    Key? key,
    required String title,
    required String message,
    IconData? icon,
    String? primaryButtonText,
    VoidCallback? onPrimaryPressed,
    bool dismissible = true,
  }) {
    return TossDialog(
      key: key,
      title: title,
      message: message,
      type: TossDialogType.info,
      icon: icon ?? Icons.info_outline,
      iconColor: TossColors.info,
      primaryButtonText: primaryButtonText ?? 'OK',
      onPrimaryPressed: onPrimaryPressed,
      dismissible: dismissible,
    );
  }

  @override
  State<TossDialog> createState() => _TossDialogState();
}

class _TossDialogState extends State<TossDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _iconController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.type == TossDialogType.success 
          ? Curves.elasticOut 
          : Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _controller.forward();
    if (widget.type == TossDialogType.success) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _iconController.forward();
        }
      });
    } else {
      _iconController.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Color get _typeColor {
    switch (widget.type) {
      case TossDialogType.success:
        return widget.iconColor ?? TossColors.success;
      case TossDialogType.warning:
        return widget.iconColor ?? TossColors.warning;
      case TossDialogType.info:
        return widget.iconColor ?? TossColors.info;
      case TossDialogType.error:
        return widget.iconColor ?? TossColors.error;
    }
  }

  IconData get _typeIcon {
    if (widget.icon != null) return widget.icon!;
    
    switch (widget.type) {
      case TossDialogType.success:
        return Icons.check_circle;
      case TossDialogType.warning:
        return Icons.warning_amber_rounded;
      case TossDialogType.info:
        return Icons.info_outline;
      case TossDialogType.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TossColors.transparent,
      elevation: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space6),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: widget.type == TossDialogType.success
                      ? TossColors.black.withValues(alpha: 0.1)
                      : _typeColor.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconSection(),
                SizedBox(height: TossSpacing.space4),
                _buildTitleSection(),
                if (widget.infoItems != null && widget.infoItems!.isNotEmpty) ...[
                  SizedBox(height: TossSpacing.space4),
                  _buildInfoSection(),
                ],
                if (widget.customContent != null) ...[
                  SizedBox(height: TossSpacing.space4),
                  widget.customContent!,
                ],
                SizedBox(height: TossSpacing.space6),
                _buildButtonSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSection() {
    final iconSize = widget.type == TossDialogType.success ? 80.0 : 64.0;
    final iconContentSize = widget.type == TossDialogType.success ? 50.0 : 36.0;

    return ScaleTransition(
      scale: _iconScaleAnimation,
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              _typeColor.withValues(alpha: 0.2),
              _typeColor.withValues(alpha: 0.1),
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _typeIcon,
          size: iconContentSize,
          color: _typeColor,
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          widget.title,
          style: (widget.type == TossDialogType.success 
              ? TossTextStyles.h2 
              : TossTextStyles.h3).copyWith(
            color: TossColors.textPrimary,
            fontWeight: widget.type == TossDialogType.success 
                ? FontWeight.w800 
                : FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        if (widget.subtitle != null) ...[
          SizedBox(height: TossSpacing.space2),
          Text(
            widget.subtitle!,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (widget.message != null) ...[
          SizedBox(height: TossSpacing.space3),
          Text(
            widget.message!,
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: widget.infoItems!
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  if (index > 0) SizedBox(height: TossSpacing.space3),
                  Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 18,
                        color: item.iconColor ?? TossColors.textSecondary,
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Text(
                        '${item.label}: ',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.value,
                          style: TossTextStyles.body.copyWith(
                            color: item.valueColor ?? TossColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            })
            .toList(),
      ),
    );
  }

  Widget _buildButtonSection() {
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      return Column(
        children: widget.actions!
            .map((action) => Padding(
                  padding: EdgeInsets.only(bottom: TossSpacing.space2),
                  child: SizedBox(
                    width: double.infinity,
                    child: action.isPrimary
                        ? TossPrimaryButton(
                            text: action.text,
                            onPressed: action.onPressed,
                            fullWidth: true,
                            leadingIcon: widget.type == TossDialogType.success
                                ? Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                    color: TossColors.white,
                                  )
                                : null,
                          )
                        : TossSecondaryButton(
                            text: action.text,
                            onPressed: action.onPressed,
                            fullWidth: true,
                          ),
                  ),
                ))
            .toList(),
      );
    }

    // Default action buttons
    return Column(
      children: [
        TossPrimaryButton(
          text: widget.primaryButtonText,
          onPressed: widget.onPrimaryPressed ?? () => Navigator.of(context).pop(true),
          fullWidth: true,
          leadingIcon: widget.type == TossDialogType.success
              ? Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: TossColors.white,
                )
              : null,
        ),
        if (widget.secondaryButtonText != null) ...[
          SizedBox(height: TossSpacing.space3),
          TextButton(
            onPressed: widget.onSecondaryPressed ?? () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
            ),
            child: Text(
              widget.secondaryButtonText!,
              style: TossTextStyles.body.copyWith(
                color: widget.type == TossDialogType.success
                    ? TossColors.primary
                    : TossColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class TossDialogInfoItem {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? valueColor;

  const TossDialogInfoItem({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.valueColor,
  });
}

class TossDialogAction {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const TossDialogAction({
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
  });
}

// Utility methods combining both success and error dialog utilities
class TossDialogs {
  // Success dialogs
  static Future<bool?> showCompanyCreated({
    required BuildContext context,
    required String companyName,
    String? companyCode,
    VoidCallback? onContinue,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossDialog.success(
        title: 'Business Created Successfully!',
        subtitle: companyName,
        message: 'Your business is ready to go!',
        primaryButtonText: 'Continue Setup',
        secondaryButtonText: 'Go to Dashboard',
        onPrimaryPressed: onContinue ?? () => Navigator.of(context).pop(true),
        infoItems: companyCode != null ? [
          TossDialogInfoItem(
            label: 'Company Code',
            value: companyCode,
            icon: Icons.business,
            iconColor: TossColors.primary,
            valueColor: TossColors.primary,
          ),
        ] : null,
        customContent: companyCode != null ? Container(
          padding: EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: TossColors.info.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: TossColors.info, size: 20),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  'Share this code with employees to join your business',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.info,
                  ),
                ),
              ),
            ],
          ),
        ) : null,
      ),
    );
  }

  static Future<bool?> showStoreCreated({
    required BuildContext context,
    required String storeName,
    required String companyName,
    String? storeCode,
    String? storeAddress,
    String? storePhone,
    VoidCallback? onContinue,
    VoidCallback? onCreateAnother,
  }) {
    final infoItems = <TossDialogInfoItem>[
      TossDialogInfoItem(
        label: 'Company',
        value: companyName,
        icon: Icons.business,
        iconColor: TossColors.primary,
      ),
      if (storeCode != null)
        TossDialogInfoItem(
          label: 'Store Code',
          value: storeCode,
          icon: Icons.qr_code,
          iconColor: TossColors.primary,
          valueColor: TossColors.primary,
        ),
      if (storeAddress != null && storeAddress.isNotEmpty)
        TossDialogInfoItem(
          label: 'Address',
          value: storeAddress,
          icon: Icons.location_on,
        ),
      if (storePhone != null && storePhone.isNotEmpty)
        TossDialogInfoItem(
          label: 'Phone',
          value: storePhone,
          icon: Icons.phone,
        ),
    ];

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossDialog.success(
        title: 'Store Created Successfully!',
        subtitle: storeName,
        message: 'Your store is ready for operations',
        icon: Icons.store,
        primaryButtonText: 'Go to Dashboard',
        secondaryButtonText: onCreateAnother != null ? 'Create Another Store' : null,
        onPrimaryPressed: onContinue ?? () => Navigator.of(context).pop(true),
        onSecondaryPressed: onCreateAnother,
        infoItems: infoItems,
      ),
    );
  }

  static Future<bool?> showBusinessJoined({
    required BuildContext context,
    required String companyName,
    String? roleName,
    VoidCallback? onContinue,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossDialog.success(
        title: 'Successfully Joined Business!',
        subtitle: companyName,
        message: 'Welcome to the team!',
        primaryButtonText: 'Go to Dashboard',
        onPrimaryPressed: onContinue ?? () => Navigator.of(context).pop(true),
        infoItems: roleName != null ? [
          TossDialogInfoItem(
            label: 'Your Role',
            value: roleName,
            icon: Icons.person,
            iconColor: TossColors.success,
            valueColor: TossColors.success,
          ),
        ] : null,
      ),
    );
  }

  // Error dialogs
  static Future<bool?> showNetworkError({
    required BuildContext context,
    VoidCallback? onRetry,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.warning(
        title: 'Connection Error',
        message: 'Please check your internet connection and try again.',
        primaryButtonText: onRetry != null ? 'Retry' : 'OK',
        onPrimaryPressed: onRetry != null 
            ? () {
                Navigator.of(context).pop(true);
                onRetry();
              }
            : null,
        secondaryButtonText: onRetry != null ? 'Cancel' : null,
        onSecondaryPressed: onRetry != null 
            ? () => Navigator.of(context).pop(false)
            : null,
      ),
    );
  }

  static Future<bool?> showValidationError({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.warning(
        title: title ?? 'Validation Error',
        message: message,
        icon: Icons.warning_amber_rounded,
        primaryButtonText: 'OK',
      ),
    );
  }

  static Future<bool?> showBusinessCreationFailed({
    required BuildContext context,
    required String error,
    VoidCallback? onRetry,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.error(
        title: 'Failed to Create Business',
        message: _parseErrorMessage(error),
        actions: [
          if (onRetry != null)
            TossDialogAction(
              text: 'Try Again',
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry();
              },
              isPrimary: true,
            ),
          TossDialogAction(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showStoreCreationFailed({
    required BuildContext context,
    required String error,
    VoidCallback? onRetry,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.error(
        title: 'Failed to Create Store',
        message: _parseErrorMessage(error),
        actions: [
          if (onRetry != null)
            TossDialogAction(
              text: 'Try Again',
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry();
              },
              isPrimary: true,
            ),
          TossDialogAction(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showBusinessJoinFailed({
    required BuildContext context,
    required String error,
    VoidCallback? onRetry,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.error(
        title: 'Failed to Join Business',
        message: _parseBusinessJoinError(error),
        actions: [
          if (onRetry != null)
            TossDialogAction(
              text: 'Try Again',
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry();
              },
              isPrimary: true,
            ),
          TossDialogAction(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  // Helper methods
  static String _parseErrorMessage(String error) {
    if (error.toLowerCase().contains('network') || 
        error.toLowerCase().contains('connection')) {
      return 'Please check your internet connection and try again.';
    }
    
    if (error.toLowerCase().contains('timeout')) {
      return 'The operation took too long. Please try again.';
    }
    
    if (error.toLowerCase().contains('server')) {
      return 'Server error occurred. Please try again later.';
    }
    
    if (error.toLowerCase().contains('duplicate') || 
        error.toLowerCase().contains('already exists')) {
      return 'This name is already taken. Please choose a different name.';
    }
    
    return error.replaceAll('Exception:', '').trim();
  }

  static String _parseBusinessJoinError(String error) {
    if (error.toLowerCase().contains('invalid company code') || 
        error.toLowerCase().contains('invalid code')) {
      return 'The business code is invalid. Please check with your manager and try again.';
    }
    
    if (error.toLowerCase().contains('already a member')) {
      return 'You are already a member of this business.';
    }
    
    if (error.toLowerCase().contains('owner cannot join')) {
      return 'You cannot join your own business as an employee.';
    }
    
    if (error.toLowerCase().contains('not found')) {
      return 'Business not found. Please verify the code and try again.';
    }
    
    return _parseErrorMessage(error);
  }
}

// Compatibility aliases for easy migration
typedef TossSuccessDialogs = TossDialogs;
typedef TossErrorDialogs = TossDialogs;
typedef SuccessInfoItem = TossDialogInfoItem;
typedef ErrorAction = TossDialogAction;
typedef ErrorSeverity = TossDialogType;