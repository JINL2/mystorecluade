import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'toss_border_radius.dart';
import 'toss_colors.dart';
import 'toss_spacing.dart';
import 'toss_text_styles.dart';

/// MyFinance Theme - Powered by Toss Design System
/// Clean, modern, and professional financial app design
/// 
/// Design Philosophy:
/// - Minimalist white-dominant UI
/// - Strategic use of Toss Blue
/// - 4px grid spacing system
/// - 200-250ms smooth animations
class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: TossColors.primary,
      onPrimary: TossColors.white,
      primaryContainer: TossColors.primarySurface,
      onPrimaryContainer: TossColors.primary,

      secondary: TossColors.gray800,
      onSecondary: TossColors.white,

      error: TossColors.error,
      onError: TossColors.white,

      surface: TossColors.white,
      onSurface: TossColors.textPrimary,

      surfaceContainer: TossColors.white,
      surfaceContainerHighest: TossColors.white,
      onSurfaceVariant: TossColors.textSecondary,

      outline: TossColors.border,
      outlineVariant: TossColors.gray200,

      shadow: TossColors.shadow,
      scrim: TossColors.overlay,
    ),
    
    // Background - Clean white like Toss
    scaffoldBackgroundColor: TossColors.background,
    
    // AppBar theme - Minimal like Toss
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,  // Toss uses left-aligned titles
      backgroundColor: TossColors.background,
      foregroundColor: TossColors.textPrimary,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TossTextStyles.h3.copyWith(color: TossColors.textPrimary),
      toolbarHeight: 56,
      iconTheme: const IconThemeData(
        color: TossColors.textPrimary,
        size: TossSpacing.iconMD,
      ),
    ),
    
    // Text theme - Updated to match new typography specifications
    textTheme: TextTheme(
      displayLarge: TossTextStyles.display,
      displayMedium: TossTextStyles.h1,
      displaySmall: TossTextStyles.h2,
      headlineLarge: TossTextStyles.headlineLarge,  // 28px/Bold - Big revenue numbers
      headlineMedium: TossTextStyles.h2,
      headlineSmall: TossTextStyles.h3,
      titleLarge: TossTextStyles.titleLarge,         // 17px/Bold - Section headers
      titleMedium: TossTextStyles.titleMedium,       // 15px/Bold - "Today Revenue"
      titleSmall: TossTextStyles.body,
      bodyLarge: TossTextStyles.bodyLarge,           // 14px/Regular - Body text
      bodyMedium: TossTextStyles.bodyMedium,         // 14px/Semibold - Feature names
      bodySmall: TossTextStyles.bodySmall,           // 13px/Semibold - Comparison text
      labelLarge: TossTextStyles.labelLarge,
      labelMedium: TossTextStyles.labelMedium,       // 12px/Semibold - Feature descriptions
      labelSmall: TossTextStyles.labelSmall,         // 11px/Semibold - Quick actions
    ),
    
    // Component themes - Toss style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size(double.infinity, TossSpacing.buttonHeightLG),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.paddingMD,
          vertical: TossSpacing.paddingSM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.button),
        ),
        backgroundColor: TossColors.primary,
        foregroundColor: TossColors.white,
        textStyle: TossTextStyles.button,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size(double.infinity, TossSpacing.buttonHeightLG),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.paddingMD,
          vertical: TossSpacing.paddingSM,
        ),
        side: const BorderSide(color: TossColors.border, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.button),
        ),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.textPrimary,
        textStyle: TossTextStyles.button,
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.paddingSM,
          vertical: TossSpacing.paddingXS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        foregroundColor: TossColors.primary,
        textStyle: TossTextStyles.button,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 0,
      color: TossColors.surface,
      surfaceTintColor: TossColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        side: const BorderSide(color: TossColors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.marginMD,
        vertical: TossSpacing.marginSM,
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: TossColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.input),
        borderSide: const BorderSide(color: TossColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.input),
        borderSide: const BorderSide(color: TossColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.input),
        borderSide: const BorderSide(color: TossColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.input),
        borderSide: const BorderSide(color: TossColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.input),
        borderSide: const BorderSide(color: TossColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingMD,
        vertical: TossSpacing.paddingSM,
      ),
      hintStyle: TossTextStyles.body.copyWith(color: TossColors.textTertiary),
      labelStyle: TossTextStyles.label.copyWith(color: TossColors.textSecondary),
      errorStyle: TossTextStyles.caption.copyWith(color: TossColors.error),
      helperStyle: TossTextStyles.caption.copyWith(color: TossColors.textTertiary),
    ),
    
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: TossColors.surface,
      surfaceTintColor: TossColors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.bottomSheet),
          topRight: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      showDragHandle: false, // Disable default drag handle to prevent double handler confusion
      dragHandleColor: TossColors.gray300,
      dragHandleSize: Size(40, 4),
    ),
    
    dividerTheme: const DividerThemeData(
      color: TossColors.border,
      thickness: 0.5,  // Toss uses very thin dividers
      space: 0,
      indent: 0,
      endIndent: 0,
    ),
    
    // Additional themes
    chipTheme: ChipThemeData(
      backgroundColor: TossColors.gray50,
      selectedColor: TossColors.primarySurface,
      disabledColor: TossColors.gray100,
      labelStyle: TossTextStyles.label,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingSM,
        vertical: TossSpacing.paddingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.chip),
        side: BorderSide.none,
      ),
    ),
    
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingMD,
        vertical: TossSpacing.paddingSM,
      ),
      dense: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      selectedColor: TossColors.primary,
      iconColor: TossColors.textSecondary,
      textColor: TossColors.textPrimary,
      titleTextStyle: TossTextStyles.body,
      subtitleTextStyle: TossTextStyles.bodySmall.copyWith(
        color: TossColors.textSecondary,
      ),
    ),

    // ═══════════════════════════════════════════════════════════════
    // IconButton - 전역 스타일 통일
    // ═══════════════════════════════════════════════════════════════
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: TossColors.gray600,
        iconSize: TossSpacing.iconMD,
        padding: const EdgeInsets.all(TossSpacing.space2),
      ),
    ),

    // ═══════════════════════════════════════════════════════════════
    // Switch - 전역 스타일 통일
    // ═══════════════════════════════════════════════════════════════
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected)
          ? TossColors.white
          : TossColors.gray300,
      ),
      trackColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected)
          ? TossColors.primary
          : TossColors.gray200,
      ),
      trackOutlineColor: WidgetStateProperty.all(TossColors.transparent),
    ),

    // ═══════════════════════════════════════════════════════════════
    // Checkbox - 전역 스타일 통일
    // ═══════════════════════════════════════════════════════════════
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected)
          ? TossColors.primary
          : TossColors.transparent,
      ),
      checkColor: WidgetStateProperty.all(TossColors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: const BorderSide(color: TossColors.gray300, width: 1.5),
    ),
    
    dialogTheme: DialogThemeData(
      backgroundColor: TossColors.surface,
      surfaceTintColor: TossColors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.dialog),
      ),
      titleTextStyle: TossTextStyles.h3.copyWith(color: TossColors.textPrimary),
      contentTextStyle: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
    ),
    
    snackBarTheme: SnackBarThemeData(
      backgroundColor: TossColors.gray800,
      contentTextStyle: TossTextStyles.body.copyWith(color: TossColors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),
    
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: TossColors.surface,
      surfaceTintColor: TossColors.transparent,
      elevation: 0,
      height: 64,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorColor: TossColors.primarySurface,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
    ),
    
    drawerTheme: const DrawerThemeData(
      backgroundColor: TossColors.surface,
      surfaceTintColor: TossColors.transparent,
      elevation: 0,
      width: 280,
    ),
  );

}