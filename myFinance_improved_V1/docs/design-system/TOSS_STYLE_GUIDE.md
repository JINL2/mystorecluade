# 🎨 Toss Design System - Complete Style Guide

> **MyFinance** now uses the **Toss Design System** - a clean, modern, and professional financial app design language based on Toss (토스), Korea's leading fintech super-app.

---

## 📋 Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [Color System](#color-system)
3. [Typography](#typography)
4. [Spacing & Layout](#spacing--layout)
5. [Components](#components)
6. [Animations](#animations)
7. [Best Practices](#best-practices)
8. [Implementation Guide](#implementation-guide)

---

## 🎯 Design Philosophy

### Core Principles

1. **Minimalist & Clean** 
   - White-dominant interface with generous breathing space
   - Remove unnecessary elements, focus on content
   - "Comfort through space, not clutter"

2. **Trust & Professionalism**
   - Consistent visual language builds trust
   - Predictable interactions reduce cognitive load
   - Financial data requires clarity and precision

3. **Single Focus**
   - One primary action per screen
   - Clear visual hierarchy guides users
   - Progressive disclosure for complex features

4. **Subtle Depth**
   - Minimal shadows (2-4% opacity max)
   - Use borders for definition, not heavy shadows
   - Depth through layering, not elevation

5. **Smooth Motion**
   - 200-250ms for most animations
   - No bouncy effects - professional feel
   - Ease-out for entering, ease-in for exiting

---

## 🎨 Color System

### Brand Colors

```dart
// Primary - Toss Blue
primary: #0064FF        // Main CTAs, links, focus states
primaryLight: #4D94FF   // Hover states
primaryDark: #0050CC    // Pressed states

// Secondary - Toss Dark
secondary: #202632      // Headers, important text
```

### Semantic Colors

```dart
// Success - Green
success: #00C896        // Profit, positive states
successLight: #E3FFF4   // Success backgrounds

// Error - Red  
error: #FF5847          // Loss, error states
errorLight: #FFEFED     // Error backgrounds

// Warning - Orange
warning: #FF9500        // Caution, attention
warningLight: #FFF4E6   // Warning backgrounds
```

### Grayscale Palette

```dart
// Main UI Colors (Use these!)
white: #FFFFFF          // Primary background
gray50: #F8F9FA        // Subtle backgrounds
gray100: #F1F3F5       // Section backgrounds
gray200: #E9ECEF       // Borders, dividers
gray300: #DEE2E6       // Disabled borders
gray400: #CED4DA       // Disabled text
gray500: #ADB5BD       // Placeholder text
gray600: #6C757D       // Secondary text ⭐
gray700: #495057       // Body text ⭐
gray800: #343A40       // Headings
gray900: #212529       // Primary text ⭐
black: #000000         // Pure black (rarely used)
```

### Usage Guidelines

- **Background**: Always white (`#FFFFFF`)
- **Text**: Primary (`gray900`), Secondary (`gray600`), Hint (`gray500`)
- **Borders**: Default (`gray200`), Focus (`primary`)
- **CTAs**: Always Toss Blue (`primary`)
- **Financial**: Profit (`success`), Loss (`error`), Neutral (`gray600`)

---

## 📝 Typography

### Font Stack

```dart
// Primary
fontFamily: 'Inter'           // Clean, international
fontFamilyKR: 'Pretendard'    // Korean support
fontFamilyMono: 'JetBrains Mono' // Numbers, amounts
```

### Type Scale (4px Grid)

```dart
// Display & Headings
display: 32px/40px, w800      // Hero sections
h1: 28px/36px, w700          // Page titles
h2: 24px/32px, w700          // Section headers
h3: 20px/28px, w600          // Subsections
h4: 18px/24px, w600          // Card titles

// Body Text
bodyLarge: 16px/24px, w400   // Important content
body: 14px/20px, w400        // Default text ⭐
bodySmall: 13px/18px, w400   // Secondary text

// UI Elements
button: 14px/20px, w600      // CTAs
label: 12px/16px, w500       // Form labels
caption: 12px/16px, w400     // Helper text
small: 11px/16px, w400       // Tiny text

// Financial
amountLarge: 28px/32px, w700 // Big numbers (mono)
amount: 20px/24px, w600      // Money display (mono)
amountSmall: 14px/20px, w500 // Inline money (mono)
```

### Typography Rules

1. **Hierarchy**: Use bold weight contrast (400 → 600 → 700)
2. **Line Height**: Maintain 4px vertical rhythm
3. **Letter Spacing**: Minimal adjustments, let font breathe
4. **Alignment**: Left-align body text, center CTAs

---

## 📐 Spacing & Layout

### 4px Grid System

All spacing is a multiple of 4px:

```dart
space0: 0px
space1: 4px    // Minimum spacing
space2: 8px    // Tight spacing
space3: 12px   // Small spacing
space4: 16px   // Default spacing ⭐
space5: 20px   // Medium spacing
space6: 24px   // Large spacing ⭐
space8: 32px   // Section spacing
space10: 40px  // Block spacing
space12: 48px  // Container spacing
```

### Component Spacing

```dart
// Padding
paddingXS: 8px    // Small buttons, chips
paddingSM: 12px   // Input fields
paddingMD: 16px   // Cards, list items ⭐
paddingLG: 20px   // Sections
paddingXL: 24px   // Page padding ⭐

// Margins
marginXS: 4px     // Inline elements
marginSM: 8px     // Related items
marginMD: 16px    // Between components ⭐
marginLG: 24px    // Between sections
marginXL: 32px    // Major sections
```

### Layout Rules

1. **Screen Padding**: 16px (mobile), 24px (tablet), 32px (desktop)
2. **Max Content Width**: 640px for readability
3. **Card Spacing**: 16px padding, 8px vertical margin
4. **List Items**: 16px horizontal, 12px vertical padding
5. **Button Height**: 48px (primary), 40px (secondary)
6. **Input Height**: 48px standard

---

## 🧩 Components

### Buttons

```dart
// Primary Button
- Height: 48px
- Padding: 16px horizontal
- Border Radius: 8px
- Background: Toss Blue (#0064FF)
- Text: White, 14px, w600
- Animation: Scale 0.95 on press (100ms)

// Secondary Button
- Same as primary but:
- Background: White
- Border: 1px solid gray200
- Text: gray900

// Text Button
- No background
- Text: Toss Blue
- Padding: 8px
```

### Cards

```dart
// Standard Card
- Background: White
- Border: 1px solid gray200
- Border Radius: 12px
- Padding: 16px
- Shadow: 0 2px 8px rgba(0,0,0,0.04)
- Hover: gray50 background
```

### Input Fields

```dart
// Text Input
- Height: 48px
- Border: 1px solid gray200
- Border Radius: 8px
- Padding: 12px 16px
- Focus: 2px solid primary
- Font: 14px/20px
```

### Lists

```dart
// List Item
- Padding: 16px horizontal, 12px vertical
- Border Bottom: 0.5px solid divider
- Press: Scale 0.98, gray50 background
- Selected: primarySurface background
```

---

## ⚡ Animations

### Timing

```dart
instant: 50ms       // Immediate feedback
quick: 100ms        // Micro-interactions
fast: 150ms         // Button presses
normal: 200ms       // Default ⭐
medium: 250ms       // Page transitions ⭐
slow: 300ms         // Complex transitions
```

### Easing Curves

```dart
standard: easeInOutCubic  // Default ⭐
enter: easeOutCubic       // Elements appearing ⭐
exit: easeInCubic         // Elements leaving
emphasis: fastOutSlowIn   // Attention-grabbing
linear: linear            // Progress indicators
```

### Animation Patterns

1. **Button Press**: Scale 0.95, 100ms, easeInOut
2. **Page Transition**: Slide + Fade, 250ms, easeOut
3. **List Item**: Scale 0.98, 150ms, easeInOut
4. **Bottom Sheet**: Slide up, 250ms, easeOut
5. **Loading**: Shimmer effect, 1500ms, linear

### Rules

- ❌ NO bounce effects (elasticOut, bounceOut)
- ❌ NO long animations (>400ms except special cases)
- ✅ Smooth and subtle
- ✅ Consistent timing across app
- ✅ Cancel on user interaction

---

## ✅ Best Practices

### Do's

1. ✅ **Use existing Toss components** from `/lib/presentation/widgets/toss/`
2. ✅ **Follow 4px grid** strictly for all spacing
3. ✅ **Maintain visual hierarchy** with typography and spacing
4. ✅ **Keep animations smooth** (200-250ms)
5. ✅ **Use semantic colors** for states (success, error, warning)
6. ✅ **Test on both light and dark themes**
7. ✅ **Ensure 44px minimum touch targets**
8. ✅ **Use borders for definition**, not heavy shadows

### Don'ts

1. ❌ **Don't use random colors** - stick to the palette
2. ❌ **Don't break the 4px grid** - no 5px, 7px, 13px spacing
3. ❌ **Don't use bouncy animations** - keep it professional
4. ❌ **Don't use heavy shadows** - max 4-6% opacity
5. ❌ **Don't center body text** - left-align for readability
6. ❌ **Don't mix font families** - Inter for UI, JetBrains Mono for numbers
7. ❌ **Don't create custom components** if Toss component exists

---

## 🚀 Implementation Guide

### Quick Start

```dart
import 'package:myfinance/core/themes/toss_colors.dart';
import 'package:myfinance/core/themes/toss_text_styles.dart';
import 'package:myfinance/core/themes/toss_spacing.dart';
import 'package:myfinance/core/themes/toss_animations.dart';
import 'package:myfinance/core/themes/toss_design_system.dart';
```

### Using Components

```dart
// Toss Button
TossPrimaryButton(
  text: 'Continue',
  onPressed: () {},
)

// Toss Card
TossCard(
  child: Text('Content'),
  onTap: () {},
)

// Toss List Tile
TossListTile(
  title: 'Settings',
  subtitle: 'Manage your preferences',
  leading: Icon(Icons.settings),
  onTap: () {},
)

// Toss Text Field
TossTextField(
  label: 'Email',
  hint: 'Enter your email',
  onChanged: (value) {},
)
```

### Creating New Components

If you must create a new component:

```dart
class MyTossComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingMD),  // Use Toss spacing
      decoration: BoxDecoration(
        color: TossColors.surface,                     // Use Toss colors
        borderRadius: BorderRadius.circular(
          TossBorderRadius.card,                       // Use Toss radius
        ),
        border: Border.all(
          color: TossColors.border,
          width: 1,
        ),
        boxShadow: TossShadows.card,                  // Use Toss shadows
      ),
      child: Text(
        'Content',
        style: TossTextStyles.body,                   // Use Toss typography
      ),
    );
  }
}
```

### Animations

```dart
// Using TossAnimatedWidget
TossAnimatedWidget(
  child: MyWidget(),
  duration: TossAnimations.normal,
  curve: TossAnimations.standard,
  onTap: () {},
)

// Manual animation
AnimatedContainer(
  duration: TossAnimations.normal,     // 200ms
  curve: TossAnimations.enter,         // easeOutCubic
  // ...
)
```

### Responsive Design

```dart
// Check device type
if (TossDesignSystem.isMobile(context)) {
  // Mobile layout
} else if (TossDesignSystem.isTablet(context)) {
  // Tablet layout
} else {
  // Desktop layout
}

// Get adaptive spacing
final padding = TossDesignSystem.getResponsivePadding(context);
```

---

## 📱 Component Catalog

All Toss components are in `/lib/presentation/widgets/toss/`:

- `toss_primary_button.dart` - Primary CTA button
- `toss_secondary_button.dart` - Secondary button
- `toss_text_field.dart` - Input field
- `toss_card.dart` - Card container
- `toss_list_tile.dart` - List item
- `toss_bottom_sheet.dart` - Bottom sheet
- `toss_dropdown.dart` - Dropdown selector
- `toss_checkbox.dart` - Checkbox
- `toss_chip.dart` - Chip/tag
- `toss_loading_overlay.dart` - Loading state
- `toss_refresh_indicator.dart` - Pull to refresh
- `toss_floating_button.dart` - FAB

---

## 🔍 Quick Reference

### Most Used Values

```dart
// Colors
Primary: TossColors.primary (#0064FF)
Text: TossColors.textPrimary (#212529)
Secondary: TossColors.textSecondary (#6C757D)
Border: TossColors.border (#E9ECEF)
Background: TossColors.background (#FFFFFF)

// Spacing
Default: TossSpacing.space4 (16px)
Padding: TossSpacing.paddingMD (16px)
Margin: TossSpacing.marginMD (16px)

// Typography
Body: TossTextStyles.body (14px/20px)
Button: TossTextStyles.button (14px/20px, w600)
Title: TossTextStyles.h3 (20px/28px, w600)

// Animation
Duration: TossAnimations.normal (200ms)
Curve: TossAnimations.standard (easeInOutCubic)

// Border Radius
Default: TossBorderRadius.md (8px)
Card: TossBorderRadius.card (12px)
Button: TossBorderRadius.button (8px)
```

---

## 📊 Design Tokens Cheatsheet

```
╔════════════════════════════════════════╗
║     TOSS DESIGN QUICK REFERENCE        ║
╠════════════════════════════════════════╣
║ Primary Blue:    #0064FF               ║
║ Success Green:   #00C896               ║
║ Error Red:       #FF5847               ║
║ Text Primary:    #212529               ║
║ Text Secondary:  #6C757D               ║
║ Border:          #E9ECEF               ║
║                                        ║
║ Base Unit:       4px                   ║
║ Default Space:   16px                  ║
║ Page Padding:    24px                  ║
║                                        ║
║ Body Text:       14px/20px             ║
║ Button Text:     14px/20px, w600       ║
║ Title:           20px/28px, w600       ║
║                                        ║
║ Animation:       200-250ms             ║
║ Curve:           easeInOutCubic        ║
║                                        ║
║ Button Height:   48px                  ║
║ Input Height:    48px                  ║
║ Border Radius:   8-12px                ║
╚════════════════════════════════════════╝
```

---

## 🎓 Learn More

- Study the actual Toss app for inspiration
- Check `/lib/core/themes/` for all design tokens
- Use `/lib/presentation/widgets/toss/` components
- Run `TossDesignSystem.printDesignTokens()` for debug info

---

*Last updated: 2024 | Based on Toss (토스) Design System*