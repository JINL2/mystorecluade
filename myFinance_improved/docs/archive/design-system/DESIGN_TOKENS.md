# 🎨 Design Tokens Reference

Complete reference for all design tokens used in MyFinance Toss-style design system.

## Color Tokens

### Brand Colors (OKLCH-based)
```scss
// Primary
$color-primary: #5B5FCF;           // oklch(0.6231 0.1880 259.8145)
$color-primary-light: #8B8FDF;
$color-primary-dark: #4B4FBF;

// Error (from your OKLCH)
$color-error: #EF4444;             // oklch(0.6368 0.2078 25.3313)

// Background
$color-background: #FFFFFF;         // Pure white
$color-surface: #FBFBFB;           // Slight gray for cards
```

### Gray Scale
```scss
$gray-50: #FAFAFA;    // rgb(250, 250, 250)
$gray-100: #F5F5F5;   // rgb(245, 245, 245)
$gray-200: #E5E5E5;   // rgb(229, 229, 229)
$gray-300: #D4D4D4;   // rgb(212, 212, 212)
$gray-400: #A3A3A3;   // rgb(163, 163, 163)
$gray-500: #737373;   // rgb(115, 115, 115)
$gray-600: #525252;   // rgb(82, 82, 82)
$gray-700: #404040;   // rgb(64, 64, 64)
$gray-800: #262626;   // rgb(38, 38, 38)
$gray-900: #171717;   // rgb(23, 23, 23)
```

### Semantic Colors
```scss
// Status
$color-success: #22C55E;
$color-warning: #F59E0B;
$color-info: #3B82F6;

// Financial
$color-profit: #22C55E;
$color-loss: #EF4444;
$color-neutral: #737373;
```

## Typography Tokens

### Font Families
```scss
$font-family-sans: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
$font-family-mono: 'JetBrains Mono', 'Courier New', monospace;
$font-family-jp: 'Noto Sans JP', sans-serif;
```

### Font Sizes
```scss
// Display
$font-size-display: 48px;    // 3rem
$font-size-h1: 32px;         // 2rem
$font-size-h2: 24px;         // 1.5rem
$font-size-h3: 20px;         // 1.25rem

// Body
$font-size-body-large: 17px; // 1.0625rem
$font-size-body: 15px;       // 0.9375rem
$font-size-body-small: 13px; // 0.8125rem

// UI
$font-size-label-large: 15px;
$font-size-label: 13px;
$font-size-label-small: 11px;
$font-size-caption: 11px;

// Financial
$font-size-amount: 32px;
$font-size-amount-small: 20px;
```

### Font Weights
```scss
$font-weight-regular: 400;
$font-weight-medium: 500;
$font-weight-semibold: 600;
$font-weight-bold: 700;
```

### Line Heights
```scss
$line-height-tight: 1.1;
$line-height-snug: 1.2;
$line-height-normal: 1.5;
$line-height-relaxed: 1.6;
```

### Letter Spacing
```scss
$letter-spacing-tighter: -0.02em;
$letter-spacing-tight: -0.01em;
$letter-spacing-normal: 0;
$letter-spacing-wide: 0.02em;
```

## Spacing Tokens

### Base Unit: 4px
```scss
$space-0: 0;        // 0px
$space-1: 4px;      // 0.25rem
$space-2: 8px;      // 0.5rem
$space-3: 12px;     // 0.75rem
$space-4: 16px;     // 1rem - Default
$space-5: 20px;     // 1.25rem
$space-6: 24px;     // 1.5rem
$space-7: 28px;     // 1.75rem
$space-8: 32px;     // 2rem
$space-10: 40px;    // 2.5rem
$space-12: 48px;    // 3rem
$space-16: 64px;    // 4rem
$space-20: 80px;    // 5rem
$space-24: 96px;    // 6rem
```

### Component Spacing
```scss
// Padding
$padding-xs: $space-2;   // 8px
$padding-sm: $space-3;   // 12px
$padding-md: $space-4;   // 16px - Default
$padding-lg: $space-5;   // 20px
$padding-xl: $space-6;   // 24px

// Margin
$margin-xs: $space-2;    // 8px
$margin-sm: $space-3;    // 12px
$margin-md: $space-4;    // 16px - Default
$margin-lg: $space-6;    // 24px
$margin-xl: $space-8;    // 32px

// Gap (for flex/grid)
$gap-xs: $space-1;       // 4px
$gap-sm: $space-2;       // 8px
$gap-md: $space-3;       // 12px
$gap-lg: $space-4;       // 16px
$gap-xl: $space-5;       // 20px
```

## Border Radius Tokens

```scss
$radius-none: 0;
$radius-xs: 6px;    // Small elements
$radius-sm: 8px;    // Chips, tags
$radius-md: 12px;   // Cards, inputs - Default
$radius-lg: 16px;   // Buttons, containers
$radius-xl: 20px;   // Large cards
$radius-xxl: 24px;  // Bottom sheets
$radius-full: 999px; // Pills, avatars
```

## Shadow Tokens

### Toss-style Subtle Shadows
```scss
// Elevation levels
$shadow-0: none;

$shadow-1: 0 1px 2px 0 rgba(0, 0, 0, 0.02);

$shadow-2: 0 2px 8px 0 rgba(0, 0, 0, 0.03);

$shadow-3: 0 4px 16px 0 rgba(0, 0, 0, 0.04);

$shadow-4: 0 8px 24px 0 rgba(0, 0, 0, 0.05);

// Special shadows
$shadow-card: 0 2px 8px 0 rgba(0, 0, 0, 0.03);
$shadow-bottom-sheet: 0 -4px 16px 0 rgba(0, 0, 0, 0.08);
$shadow-floating: 0 8px 24px 0 rgba(0, 0, 0, 0.10);
```

## Animation Tokens

### Durations
```scss
$duration-instant: 0ms;
$duration-fast: 100ms;      // Micro-interactions
$duration-normal: 200ms;    // Default
$duration-slow: 300ms;      // Page transitions
$duration-slower: 500ms;    // Complex animations
```

### Easing Functions
```scss
$easing-linear: linear;
$easing-ease: ease;
$easing-ease-in: cubic-bezier(0.4, 0, 1, 1);
$easing-ease-out: cubic-bezier(0, 0, 0.2, 1);
$easing-ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
$easing-default: cubic-bezier(0.25, 0.1, 0.25, 1); // Toss default
```

## Size Tokens

### Touch Targets
```scss
$touch-target-min: 44px;    // iOS minimum
$touch-target-android: 48px; // Android minimum
```

### Button Heights
```scss
$button-height-sm: 32px;
$button-height-md: 40px;
$button-height-lg: 48px;
$button-height-xl: 56px;    // Primary CTAs
```

### Icon Sizes
```scss
$icon-size-xs: 16px;
$icon-size-sm: 20px;
$icon-size-md: 24px;        // Default
$icon-size-lg: 32px;
$icon-size-xl: 40px;
```

### Avatar Sizes
```scss
$avatar-size-xs: 24px;
$avatar-size-sm: 32px;
$avatar-size-md: 40px;      // Default
$avatar-size-lg: 48px;
$avatar-size-xl: 64px;
```

## Z-Index Scale

```scss
$z-index-dropdown: 1000;
$z-index-sticky: 1020;
$z-index-fixed: 1030;
$z-index-modal-backdrop: 1040;
$z-index-modal: 1050;
$z-index-popover: 1060;
$z-index-tooltip: 1070;
$z-index-toast: 1080;
```

## Breakpoints

```scss
$breakpoint-xs: 0;
$breakpoint-sm: 576px;
$breakpoint-md: 768px;
$breakpoint-lg: 992px;
$breakpoint-xl: 1200px;
$breakpoint-xxl: 1400px;
```

## Usage in Flutter

### Colors
```dart
// Use from TossColors class
color: TossColors.primary
color: TossColors.gray500
```

### Typography
```dart
// Use from TossTextStyles class
style: TossTextStyles.h1
style: TossTextStyles.body
```

### Spacing
```dart
// Use from TossSpacing class
padding: EdgeInsets.all(TossSpacing.space4)
SizedBox(height: TossSpacing.space2)
```

### Border Radius
```dart
// Use from TossBorderRadius class
borderRadius: BorderRadius.circular(TossBorderRadius.md)
```

### Shadows
```dart
// Use from TossShadows class
boxShadow: TossShadows.shadow2
```

## Token Naming Convention

### Pattern
`{category}-{property}-{variant}-{state}`

### Examples
- `color-primary-light`
- `font-size-body-large`
- `space-4`
- `shadow-card`
- `radius-md`

## Figma Integration

These tokens should be synced with Figma using:
1. Design Tokens plugin
2. Figma Variables
3. Style Dictionary

## CSS Custom Properties

For web version:
```css
:root {
  /* Colors */
  --color-primary: #5B5FCF;
  --color-gray-500: #737373;
  
  /* Typography */
  --font-family-sans: 'Inter', sans-serif;
  --font-size-body: 15px;
  
  /* Spacing */
  --space-4: 16px;
  
  /* Radius */
  --radius-md: 12px;
  
  /* Shadows */
  --shadow-2: 0 2px 8px 0 rgba(0, 0, 0, 0.03);
}
```

---

*Keep this document updated when adding new design tokens!* 🎨