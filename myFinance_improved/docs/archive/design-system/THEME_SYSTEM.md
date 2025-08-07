# Theme System Design (Toss-Style Enhanced)

## Color Palette (OKLCH-Based)

### Brand Colors
```dart
// Primary - Blue/Purple from your OKLCH values
static const primary = Color(0xFF5B5FCF);      // oklch(0.6231 0.1880 259.8145)
static const primaryLight = Color(0xFF8B8FDF);  // Lighter variant
static const primaryDark = Color(0xFF4B4FBF);   // Darker variant

// Secondary - Near white for clean backgrounds
static const secondary = Color(0xFFF7F7F7);     // oklch(0.9670 0.0029 264.5419)
static const secondaryForeground = Color(0xFF6B6B6B); // oklch(0.5510 0.0234 264.3637)

// Accent - Purple accent
static const accent = Color(0xFF4A4DAF);        // oklch(0.3791 0.1378 265.5222)
static const accentLight = Color(0xFF7A7DCF);
static const accentDark = Color(0xFF3A3D9F);
```

### Semantic Colors (Toss-Style)
```dart
// Status Colors - More muted for Toss aesthetic
static const success = Color(0xFF22C55E);       // Softer green
static const warning = Color(0xFFF59E0B);       // Warm orange
static const error = Color(0xFFEF4444);         // oklch(0.6368 0.2078 25.3313)
static const info = Color(0xFF3B82F6);          // Friendly blue

// Financial Indicators
static const profit = Color(0xFF22C55E);        // Green for positive
static const loss = Color(0xFFEF4444);          // Red for negative
static const neutral = Color(0xFF737373);       // Gray for no change
```

### Neutral Colors (Toss-Style Grays)
```dart
// Toss uses extensive gray palette for hierarchy
static const gray50 = Color(0xFFFAFAFA);
static const gray100 = Color(0xFFF5F5F5);
static const gray200 = Color(0xFFE5E5E5);
static const gray300 = Color(0xFFD4D4D4);
static const gray400 = Color(0xFFA3A3A3);
static const gray500 = Color(0xFF737373);
static const gray600 = Color(0xFF525252);
static const gray700 = Color(0xFF404040);
static const gray800 = Color(0xFF262626);
static const gray900 = Color(0xFF171717);

// Special Toss colors
static const background = Color(0xFFFFFFFF);    // Pure white
static const surface = Color(0xFFFBFBFB);       // Slight gray
static const border = Color(0xFFE5E7EB);        // Light border
```

## Typography System (Toss-Style)

```dart
class TossTextStyles {
  static const String fontFamily = 'Inter'; // Your choice - perfect for Toss style
  static const String fontFamilyJP = 'Noto Sans JP'; // Japanese support
  static const String fontFamilyMono = 'JetBrains Mono'; // For numbers
  
  // Display - Used sparingly for maximum impact
  static const display = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 1.1,
    fontFamily: fontFamily,
  );
  
  // Headlines - Clear visual hierarchy
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.2,
    fontFamily: fontFamily,
  );
  
  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.3,
    fontFamily: fontFamily,
  );
  
  static const h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    fontFamily: fontFamily,
  );
  
  // Body text - Optimized for readability
  static const bodyLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.6,
    fontFamily: fontFamily,
  );
  
  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    fontFamily: fontFamily,
  );
  
  static const bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    fontFamily: fontFamily,
  );
  
  // Labels - For UI elements
  static const labelLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.3,
    fontFamily: fontFamily,
  );
  
  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.02,
    height: 1.3,
    fontFamily: fontFamily,
  );
  
  static const labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.02,
    height: 1.3,
    fontFamily: fontFamily,
  );
  
  // Caption - For secondary information
  static const caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.02,
    height: 1.3,
    fontFamily: fontFamily,
  );
  
  // Special styles for finance
  static const amount = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 1.1,
    fontFamily: fontFamilyMono,
  );
  
  static const amountSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.2,
    fontFamily: fontFamilyMono,
  );
}
```

## Component Themes

### Shadow System (Toss-Style)
```dart
class TossShadows {
  // Toss uses very subtle, layered shadows
  static const shadow0 = <BoxShadow>[];
  
  static const shadow1 = [
    BoxShadow(
      color: Color(0x05000000), // 2% opacity
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  
  static const shadow2 = [
    BoxShadow(
      color: Color(0x08000000), // 3% opacity
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];
  
  static const shadow3 = [
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];
  
  static const shadow4 = [
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];
  
  // Special shadows for cards and floating elements
  static const cardShadow = [
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  static const bottomSheetShadow = [
    BoxShadow(
      color: Color(0x15000000),
      offset: Offset(0, -4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}
```

### Border Radius System (Toss-Style)
```dart
class TossBorderRadius {
  static const none = 0.0;
  static const xs = 6.0;   // Small elements
  static const sm = 8.0;   // Chips, tags
  static const md = 12.0;  // Cards, inputs
  static const lg = 16.0;  // Buttons, containers
  static const xl = 20.0;  // Large cards
  static const xxl = 24.0; // Bottom sheets
  static const full = 999.0; // Circular elements
}
```

### Spacing System (Toss-Style)
```dart
class TossSpacing {
  static const space0 = 0.0;
  static const space1 = 4.0;   // Minimal spacing
  static const space2 = 8.0;   // Tight spacing
  static const space3 = 12.0;  // Small spacing
  static const space4 = 16.0;  // Default spacing
  static const space5 = 20.0;  // Medium spacing
  static const space6 = 24.0;  // Large spacing
  static const space7 = 28.0;  // Extra spacing
  static const space8 = 32.0;  // Section spacing
  static const space10 = 40.0; // Block spacing
  static const space12 = 48.0; // Major spacing
  static const space16 = 64.0; // Page spacing
  static const space20 = 80.0; // Hero spacing
  static const space24 = 96.0; // Maximum spacing
}
```

## Theme Implementation

```dart
// lib/core/themes/app_theme.dart

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.secondaryDark,
      
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      
      error: AppColors.error,
      onError: Colors.white,
      
      surface: AppColors.gray50,
      onSurface: AppColors.gray900,
      
      surfaceVariant: AppColors.gray100,
      onSurfaceVariant: AppColors.gray700,
      
      outline: AppColors.gray300,
      outlineVariant: AppColors.gray200,
      
      shadow: Colors.black12,
      scrim: Colors.black54,
    ),
    
    // Typography
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.gray900),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.gray900),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.gray900),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.gray900),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.gray900),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.gray900),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.gray900),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.gray800),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.gray800),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.gray700),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray700),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.gray600),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.gray700),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.gray600),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.gray500),
    ),
    
    // Component themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: AppElevations.elevation2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
      ),
    ),
    
    cardTheme: CardTheme(
      elevation: AppElevations.elevation1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.gray50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.gray300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.gray300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.gray900,
      primaryContainer: AppColors.primary,
      onPrimaryContainer: AppColors.gray100,
      
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.gray900,
      secondaryContainer: AppColors.secondary,
      onSecondaryContainer: AppColors.gray100,
      
      surface: AppColors.gray900,
      onSurface: AppColors.gray50,
      
      surfaceVariant: AppColors.gray800,
      onSurfaceVariant: AppColors.gray300,
      
      outline: AppColors.gray600,
      outlineVariant: AppColors.gray700,
    ),
    
    // ... rest of dark theme configuration
  );
}
```

## Theme Extensions

```dart
// Custom theme extensions for finance-specific styling
@immutable
class FinanceThemeExtension extends ThemeExtension<FinanceThemeExtension> {
  final Color? profitColor;
  final Color? lossColor;
  final Color? neutralColor;
  final TextStyle? currencyStyle;
  final TextStyle? percentageStyle;
  
  const FinanceThemeExtension({
    this.profitColor,
    this.lossColor,
    this.neutralColor,
    this.currencyStyle,
    this.percentageStyle,
  });
  
  @override
  FinanceThemeExtension copyWith({...}) {...}
  
  @override
  FinanceThemeExtension lerp(FinanceThemeExtension? other, double t) {...}
  
  static const light = FinanceThemeExtension(
    profitColor: AppColors.profit,
    lossColor: AppColors.loss,
    neutralColor: AppColors.neutral,
    currencyStyle: TextStyle(
      fontFamily: 'Roboto Mono',
      fontWeight: FontWeight.w500,
    ),
    percentageStyle: TextStyle(
      fontFamily: 'Roboto Mono',
      fontWeight: FontWeight.w600,
    ),
  );
}
```

## Usage Example

```dart
// Access theme in widgets
class TransactionAmount extends StatelessWidget {
  final double amount;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final financeTheme = theme.extension<FinanceThemeExtension>()!;
    
    return Text(
      formatCurrency(amount),
      style: theme.textTheme.titleMedium?.copyWith(
        color: amount >= 0 ? financeTheme.profitColor : financeTheme.lossColor,
        fontFamily: financeTheme.currencyStyle?.fontFamily,
      ),
    );
  }
}
```