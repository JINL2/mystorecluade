import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';

/// Reusable Toss-style Floating Action Button
/// Supports both regular and extended versions with consistent styling
class TossFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final bool isExtended;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final String? tooltip;
  final bool isLoading;

  const TossFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.tooltip,
    this.isLoading = false,
  }) : label = null, isExtended = false;

  const TossFloatingActionButton.extended({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon = Icons.add,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.tooltip,
    this.isLoading = false,
  }) : isExtended = true;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? TossColors.primary;
    final effectiveForegroundColor = foregroundColor ?? TossColors.textInverse;
    final effectiveElevation = elevation ?? TossSpacing.space1;

    if (isLoading) {
      return _buildLoadingButton(effectiveBackgroundColor, effectiveForegroundColor, effectiveElevation);
    }

    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        elevation: effectiveElevation,
        tooltip: tooltip,
        icon: icon != null ? Icon(
          icon,
          size: TossSpacing.iconSM,
          color: effectiveForegroundColor,
        ) : null,
        label: Text(
          label!,
          style: TossTextStyles.body.copyWith(
            color: effectiveForegroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: effectiveElevation,
      tooltip: tooltip,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Icon(
        icon,
        size: TossSpacing.iconLG,
        color: effectiveForegroundColor,
      ),
    );
  }

  Widget _buildLoadingButton(Color backgroundColor, Color foregroundColor, double elevation) {
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: null,
        backgroundColor: backgroundColor.withOpacity(0.7),
        elevation: elevation,
        icon: SizedBox(
          width: TossSpacing.iconSM,
          height: TossSpacing.iconSM,
          child: CircularProgressIndicator(
            strokeWidth: TossSpacing.space0 + 2,
            valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
          ),
        ),
        label: Text(
          label!,
          style: TossTextStyles.body.copyWith(
            color: foregroundColor.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: null,
      backgroundColor: backgroundColor.withOpacity(0.7),
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: SizedBox(
        width: TossSpacing.iconLG,
        height: TossSpacing.iconLG,
        child: CircularProgressIndicator(
          strokeWidth: TossSpacing.space0 + 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      ),
    );
  }
}

/// Pre-configured Add New button for common use cases
class TossAddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

  const TossAddButton({
    super.key,
    required this.onPressed,
    this.label = 'Add New',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TossFloatingActionButton.extended(
      onPressed: onPressed,
      label: label,
      icon: Icons.add,
      isLoading: isLoading,
    );
  }
}