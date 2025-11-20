import 'package:flutter/material.dart';

import '../../shared/themes/index.dart';
import '../../shared/widgets/common/toss_app_bar_1.dart';
import '../config/widget_migration_config.dart';

/// Helper class for safe widget migration
///
/// Provides clean methods to conditionally use new widgets
/// based on feature flags without cluttering the code.
class WidgetMigrationHelper {
  /// Get the appropriate IconButton based on feature flag
  static Widget iconButton({
    required IconData icon,
    VoidCallback? onPressed,
    Color? color,
    double? size,
    String? tooltip,
    String pageName = 'default',
  }) {
    // Always use default IconButton since TossIconButton is not imported
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color,
      iconSize: size ?? 24,
      tooltip: tooltip,
    );
  }

  /// Get the appropriate AppBar based on feature flag
  static PreferredSizeWidget appBar({
    required String title,
    Widget? leading,
    List<Widget>? actions,
    bool centerTitle = true,
    String pageName = 'default',
  }) {
    if (WidgetMigrationConfig.shouldUseNewWidget('appbar', pageName: pageName)) {
      WidgetMigrationConfig.logMigration('TossAppBar1', pageName);
      return TossAppBar1(
        title: title,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
      );
    }
    
    return AppBar(
      title: Text(
        title,
        style: TossTextStyles.h3.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: TossColors.gray100,
      foregroundColor: TossColors.black,
    );
  }
  
  /// Get the appropriate Card widget based on feature flag
  static Widget card({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    BorderRadius? borderRadius,
    String pageName = 'default',
  }) {
    // Always use default Container since TossCard is not imported
    
    // Use traditional Container with BoxDecoration
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? TossColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(TossBorderRadius.md),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
  
  /// Get the appropriate primary button based on feature flag
  static Widget primaryButton({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isEnabled = true,
    String pageName = 'default',
  }) {
    // Always use default ElevatedButton since TossPrimaryButton is not imported
    
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: TossColors.primary,
        foregroundColor: TossColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
      ),
      child: isLoading
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
            strokeWidth: 2,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon),
                const SizedBox(width: TossSpacing.space2),
              ],
              Text(text),
            ],
          ),
    );
  }
  
  /// Get the appropriate secondary button based on feature flag
  static Widget secondaryButton({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    String pageName = 'default',
  }) {
    // Always use default TextButton since TossSecondaryButton is not imported
    
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon),
            const SizedBox(width: TossSpacing.space2),
          ],
          Text(text),
        ],
      ),
    );
  }
  
  /// Check if migration is active for a page
  static bool isMigrationActive(String pageName) {
    final status = WidgetMigrationConfig.getMigrationStatus();
    final pages = status['pages'] as Map<String, dynamic>?;
    return pages?[pageName] as bool? ?? false;
  }
  
  /// Log migration status for monitoring
  static void logStatus(String pageName) {
    final status = WidgetMigrationConfig.getMigrationStatus();
  }
}