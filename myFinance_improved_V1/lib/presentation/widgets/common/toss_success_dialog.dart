import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_animations.dart';
import '../toss/toss_primary_button.dart';

class TossSuccessDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? message;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final Widget? customContent;
  final List<SuccessInfoItem>? infoItems;
  final Duration animationDuration;
  final bool dismissible;

  const TossSuccessDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.message,
    this.icon = Icons.check_circle,
    this.iconColor = TossColors.success,
    this.backgroundColor = TossColors.white,
    required this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.customContent,
    this.infoItems,
    this.animationDuration = const Duration(milliseconds: 600),
    this.dismissible = true,
  });

  @override
  State<TossSuccessDialog> createState() => _TossSuccessDialogState();
}

class _TossSuccessDialogState extends State<TossSuccessDialog>
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
      curve: Curves.elasticOut,
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
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _iconController.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconController.dispose();
    super.dispose();
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
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
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
    return ScaleTransition(
      scale: _iconScaleAnimation,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              widget.iconColor.withOpacity(0.2),
              widget.iconColor.withOpacity(0.1),
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.icon,
          size: 50,
          color: widget.iconColor,
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          widget.title,
          style: TossTextStyles.h2.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w800,
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
        borderRadius: BorderRadius.circular(12),
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
    return Column(
      children: [
        TossPrimaryButton(
          text: widget.primaryButtonText,
          onPressed: widget.onPrimaryPressed ?? () => Navigator.of(context).pop(true),
          fullWidth: true,
          leadingIcon: Icon(
            Icons.arrow_forward,
            size: 18,
            color: TossColors.white,
          ),
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
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class SuccessInfoItem {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? valueColor;

  const SuccessInfoItem({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.valueColor,
  });
}

// Utility methods for common success dialogs
class TossSuccessDialogs {
  /// Show company creation success dialog
  static Future<bool?> showCompanyCreated({
    required BuildContext context,
    required String companyName,
    String? companyCode,
    VoidCallback? onContinue,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossSuccessDialog(
        title: 'Business Created Successfully!',
        subtitle: companyName,
        message: 'Your business is ready to go!',
        primaryButtonText: 'Continue Setup',
        secondaryButtonText: 'Go to Dashboard',
        onPrimaryPressed: onContinue ?? () => Navigator.of(context).pop(true),
        infoItems: companyCode != null ? [
          SuccessInfoItem(
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
            color: TossColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: TossColors.info.withOpacity(0.3),
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

  /// Show store creation success dialog
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
    final infoItems = <SuccessInfoItem>[
      SuccessInfoItem(
        label: 'Company',
        value: companyName,
        icon: Icons.business,
        iconColor: TossColors.primary,
      ),
      if (storeCode != null)
        SuccessInfoItem(
          label: 'Store Code',
          value: storeCode,
          icon: Icons.qr_code,
          iconColor: TossColors.primary,
          valueColor: TossColors.primary,
        ),
      if (storeAddress != null && storeAddress.isNotEmpty)
        SuccessInfoItem(
          label: 'Address',
          value: storeAddress,
          icon: Icons.location_on,
        ),
      if (storePhone != null && storePhone.isNotEmpty)
        SuccessInfoItem(
          label: 'Phone',
          value: storePhone,
          icon: Icons.phone,
        ),
    ];

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossSuccessDialog(
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

  /// Show business joined success dialog
  static Future<bool?> showBusinessJoined({
    required BuildContext context,
    required String companyName,
    String? roleName,
    VoidCallback? onContinue,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossSuccessDialog(
        title: 'Successfully Joined Business!',
        subtitle: companyName,
        message: 'Welcome to the team!',
        primaryButtonText: 'Go to Dashboard',
        onPrimaryPressed: onContinue ?? () => Navigator.of(context).pop(true),
        infoItems: roleName != null ? [
          SuccessInfoItem(
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
}