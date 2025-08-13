import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'toss_colors.dart';
import 'toss_text_styles.dart';
import 'toss_border_radius.dart';
import 'toss_shadows.dart';

/// Main theme configuration for MyFinance app
class AppTheme {
  // Private constructor
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: TossColors.primary,
      onPrimary: Colors.white,
      primaryContainer: TossColors.primaryLight,
      onPrimaryContainer: TossColors.primaryDark,
      
      secondary: TossColors.gray100,
      onSecondary: TossColors.gray900,
      
      error: TossColors.error,
      onError: Colors.white,
      
      surface: Colors.white,
      onSurface: TossColors.gray900,
      
      surfaceContainer: TossColors.gray50,
      surfaceContainerHighest: TossColors.gray100,
      surfaceVariant: TossColors.gray100,
      onSurfaceVariant: TossColors.gray700,
      
      outline: TossColors.border,
      outlineVariant: TossColors.gray200,
      
      shadow: Colors.black12,
      scrim: Colors.black54,
    ),
    
    // Background colors - Toss-style greyish background
    scaffoldBackgroundColor: TossColors.gray50,
    
    // AppBar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: TossColors.gray50,
      foregroundColor: TossColors.gray900,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TossTextStyles.h3,
    ),
    
    // Text theme
    textTheme: TextTheme(
      displayLarge: TossTextStyles.display,
      displayMedium: TossTextStyles.h1,
      displaySmall: TossTextStyles.h2,
      headlineLarge: TossTextStyles.h1,
      headlineMedium: TossTextStyles.h2,
      headlineSmall: TossTextStyles.h3,
      titleLarge: TossTextStyles.h3,
      titleMedium: TossTextStyles.bodyLarge,
      titleSmall: TossTextStyles.body,
      bodyLarge: TossTextStyles.bodyLarge,
      bodyMedium: TossTextStyles.body,
      bodySmall: TossTextStyles.bodySmall,
      labelLarge: TossTextStyles.labelLarge,
      labelMedium: TossTextStyles.label,
      labelSmall: TossTextStyles.labelSmall,
    ),
    
    // Component themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        textStyle: TossTextStyles.labelLarge,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: const BorderSide(color: TossColors.gray300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        textStyle: TossTextStyles.label,
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        textStyle: TossTextStyles.label,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: TossColors.gray50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        borderSide: const BorderSide(color: TossColors.gray300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        borderSide: const BorderSide(color: TossColors.gray300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        borderSide: const BorderSide(color: TossColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        borderSide: const BorderSide(color: TossColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TossTextStyles.body.copyWith(color: TossColors.gray400),
      labelStyle: TossTextStyles.label,
      errorStyle: TossTextStyles.caption.copyWith(color: TossColors.error),
    ),
    
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
    ),
    
    dividerTheme: const DividerThemeData(
      color: TossColors.divider,
      thickness: 1,
      space: 0,
    ),
    
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    colorScheme: const ColorScheme.dark(
      primary: TossColors.primaryLight,
      onPrimary: TossColors.gray900,
      primaryContainer: TossColors.primary,
      onPrimaryContainer: TossColors.gray100,
      
      secondary: TossColors.gray800,
      onSecondary: TossColors.gray100,
      
      error: TossColors.error,
      onError: Colors.white,
      
      surface: TossColors.gray900,
      onSurface: TossColors.gray50,
      
      surfaceVariant: TossColors.gray800,
      onSurfaceVariant: TossColors.gray300,
      
      outline: TossColors.gray600,
      outlineVariant: TossColors.gray700,
    ),
    
    scaffoldBackgroundColor: Colors.black,
    
    // Dark theme configurations...
  );
}