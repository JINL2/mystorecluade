import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Unified InfoCard widget for displaying information
///
/// Supports multiple modes:
/// 1. **Default** - Label + Value display (gray50 background)
/// 2. **Summary** - Icon + Label + Value with optional edit action
/// 3. **Alert** - Warning/Info/Success/Error messages
///
/// ## Usage Examples
/// ```dart
/// // Basic label-value
/// InfoCard(label: 'PI Number', value: 'PI-2024-001')
///
/// // Summary with icon and edit
/// InfoCard.summary(
///   icon: Icons.store,
///   label: 'Store',
///   value: 'Main Branch',
///   onEdit: () => print('Edit tapped'),
/// )
///
/// // Alert messages
/// InfoCard.alertWarning(message: 'This will create a debt entry')
/// InfoCard.alertInfo(message: 'Tip: You can swipe to delete')
/// InfoCard.alertSuccess(message: 'Transaction completed')
/// InfoCard.alertError(message: 'Failed to save')
/// ```
class InfoCard extends StatelessWidget {
  /// Label text (for default mode)
  final String? label;

  /// Value text (for default/summary mode)
  final String? value;

  /// Message text (for alert mode)
  final String? message;

  /// Leading icon (for summary/alert mode)
  final IconData? icon;

  /// Background color
  final Color? backgroundColor;

  /// Border color (for alert mode)
  final Color? borderColor;

  /// Icon color (for alert mode)
  final Color? iconColor;

  /// Text color (for alert message)
  final Color? textColor;

  /// Internal padding
  final EdgeInsets padding;

  /// Border radius
  final double borderRadius;

  /// Label text style
  final TextStyle? labelStyle;

  /// Value text style
  final TextStyle? valueStyle;

  /// Trailing widget (icon, badge, etc.)
  final Widget? trailing;

  /// Tap callback
  final VoidCallback? onTap;

  /// Edit callback (for summary mode)
  final VoidCallback? onEdit;

  /// Whether this is an alert card
  final bool _isAlert;

  /// Whether this is a summary card
  final bool _isSummary;

  const InfoCard({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(TossSpacing.space4),
    this.borderRadius = TossBorderRadius.lg,
    this.labelStyle,
    this.valueStyle,
    this.trailing,
    this.onTap,
  })  : icon = null,
        message = null,
        borderColor = null,
        iconColor = null,
        textColor = null,
        onEdit = null,
        _isAlert = false,
        _isSummary = false;

  /// Internal constructor for summary mode
  const InfoCard._summary({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(TossSpacing.space3),
    this.borderRadius = TossBorderRadius.md,
  })  : message = null,
        borderColor = null,
        iconColor = null,
        textColor = null,
        labelStyle = null,
        valueStyle = null,
        trailing = null,
        onTap = null,
        _isAlert = false,
        _isSummary = true;

  /// Internal constructor for alert mode
  const InfoCard._alert({
    super.key,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    this.padding = const EdgeInsets.all(TossSpacing.space3),
    this.borderRadius = TossBorderRadius.md,
  })  : label = null,
        value = null,
        labelStyle = null,
        valueStyle = null,
        trailing = null,
        onTap = null,
        onEdit = null,
        _isAlert = true,
        _isSummary = false;

  // ══════════════════════════════════════════════════════════════════════════
  // HIGHLIGHT FACTORIES (for label-value cards)
  // ══════════════════════════════════════════════════════════════════════════

  /// Highlight style (primarySurface background)
  factory InfoCard.highlight({
    Key? key,
    required String label,
    required String value,
    EdgeInsets padding = const EdgeInsets.all(TossSpacing.space4),
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      key: key,
      label: label,
      value: value,
      backgroundColor: TossColors.primarySurface,
      padding: padding,
      trailing: trailing,
      onTap: onTap,
    );
  }

  /// Success style (successLight background)
  factory InfoCard.success({
    Key? key,
    required String label,
    required String value,
    EdgeInsets padding = const EdgeInsets.all(TossSpacing.space4),
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      key: key,
      label: label,
      value: value,
      backgroundColor: TossColors.successLight,
      padding: padding,
      trailing: trailing,
      onTap: onTap,
    );
  }

  /// Error style (errorLight background)
  factory InfoCard.error({
    Key? key,
    required String label,
    required String value,
    EdgeInsets padding = const EdgeInsets.all(TossSpacing.space4),
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      key: key,
      label: label,
      value: value,
      backgroundColor: TossColors.errorLight,
      padding: padding,
      trailing: trailing,
      onTap: onTap,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SUMMARY FACTORY (icon + label + value + edit)
  // ══════════════════════════════════════════════════════════════════════════

  /// Summary card with icon, label, value, and optional edit action
  /// Used to display selected information in multi-step flows
  factory InfoCard.summary({
    Key? key,
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onEdit,
  }) {
    return InfoCard._summary(
      key: key,
      icon: icon,
      label: label,
      value: value,
      onEdit: onEdit,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ALERT FACTORIES (warning, info, success, error messages)
  // ══════════════════════════════════════════════════════════════════════════

  /// Warning alert (yellow background)
  factory InfoCard.alertWarning({
    Key? key,
    required String message,
    IconData icon = Icons.warning_amber_rounded,
  }) {
    return InfoCard._alert(
      key: key,
      message: message,
      icon: icon,
      backgroundColor: TossColors.warningLight,
      borderColor: TossColors.warning.withValues(alpha: 0.3),
      iconColor: TossColors.warning,
      textColor: TossColors.warning,
    );
  }

  /// Info alert (blue background)
  factory InfoCard.alertInfo({
    Key? key,
    required String message,
    IconData icon = Icons.info_outline,
  }) {
    return InfoCard._alert(
      key: key,
      message: message,
      icon: icon,
      backgroundColor: TossColors.infoLight,
      borderColor: TossColors.info.withValues(alpha: 0.3),
      iconColor: TossColors.info,
      textColor: TossColors.info,
    );
  }

  /// Success alert (green background)
  factory InfoCard.alertSuccess({
    Key? key,
    required String message,
    IconData icon = Icons.check_circle_outline,
  }) {
    return InfoCard._alert(
      key: key,
      message: message,
      icon: icon,
      backgroundColor: TossColors.successLight,
      borderColor: TossColors.success.withValues(alpha: 0.3),
      iconColor: TossColors.success,
      textColor: TossColors.success,
    );
  }

  /// Error alert (red background)
  factory InfoCard.alertError({
    Key? key,
    required String message,
    IconData icon = Icons.error_outline,
  }) {
    return InfoCard._alert(
      key: key,
      message: message,
      icon: icon,
      backgroundColor: TossColors.errorLight,
      borderColor: TossColors.error.withValues(alpha: 0.3),
      iconColor: TossColors.error,
      textColor: TossColors.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isAlert) {
      return _buildAlertCard();
    }
    if (_isSummary) {
      return _buildSummaryCard();
    }
    return _buildDefaultCard();
  }

  /// Default label-value card
  Widget _buildDefaultCard() {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.gray50,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                Text(
                  label ?? '',
                  style: labelStyle ??
                      TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                ),
                const SizedBox(height: TossSpacing.space1),
                // Value
                Text(
                  value ?? '',
                  style: valueStyle ??
                      TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: TossSpacing.space3),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  /// Summary card with icon
  Widget _buildSummaryCard() {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.gray50,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          Icon(icon, size: TossSpacing.iconSM, color: TossColors.gray500),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label ?? '',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                Text(
                  value ?? '',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Text(
                'Change',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Alert card with message
  Widget _buildAlertCard() {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? Colors.transparent),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: TossSpacing.iconMD,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              message ?? '',
              style: TossTextStyles.caption.copyWith(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
