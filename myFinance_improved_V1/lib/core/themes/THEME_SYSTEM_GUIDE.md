# 🎨 Toss Design System Guide

**Complete guide for maintaining theme consistency in the myFinance Flutter application**

---

## 📋 Table of Contents

1. [System Overview](#-system-overview)
2. [Core Rules & Guidelines](#-core-rules--guidelines)
3. [File Structure & Organization](#-file-structure--organization)
4. [Usage Patterns](#-usage-patterns)
5. [Creating New Theme Files](#-creating-new-theme-files)
6. [Validation & Monitoring](#-validation--monitoring)
7. [Common Issues & Solutions](#-common-issues--solutions)
8. [Best Practices](#-best-practices)
9. [Anti-Patterns](#-anti-patterns)
10. [Migration Guide](#-migration-guide)

---

## 🏗️ System Overview

### Design Philosophy

The Toss Design System is built on **7 core principles**:

1. **Minimalist & Clean**: White-dominant interface with strategic use of space
2. **Trust & Clarity**: Professional financial interface prioritizing user confidence  
3. **Single Focus**: One primary action per screen to reduce cognitive load
4. **Subtle Depth**: Borders and elevation over heavy shadows
5. **Smooth Motion**: 200-250ms animations, no bounce effects
6. **Consistent Grid**: Strict 4px spacing system throughout
7. **Strategic Color**: Blue (#0064FF) for CTAs, grayscale for UI structure

### Architecture

```
📦 Theme System Architecture
├── 🎨 Design Tokens (Foundation)
│   ├── Colors (Brand, Semantic, Financial)
│   ├── Typography (Inter/Pretendard/JetBrains)
│   ├── Spacing (4px Grid System)
│   ├── Border Radius (Component-Specific)
│   ├── Shadows (Ultra-Subtle)
│   └── Animations (Professional Motion)
├── 🏗️ Application Layer
│   ├── Flutter ThemeData Configuration
│   ├── Page-Level Style Patterns
│   └── Component Integration
└── 🔧 Developer Tools
    ├── Theme Validator (Runtime Analysis)
    ├── Compatibility Layer (Migration)
    └── Extensions (Developer Experience)
```

---

## ⚖️ Core Rules & Guidelines

### 🎨 Color Usage Rules

#### ✅ **ALWAYS DO**
```dart
// Use TossColors constants
Container(color: TossColors.primary)
Text(style: TextStyle(color: TossColors.textSecondary))

// Use opacity methods for variations
Container(color: TossColors.black.withOpacity(0.1))
```

#### ❌ **NEVER DO**
```dart
// Hardcoded hex colors
Container(color: Color(0xFF0064FF))  // ❌
Container(color: Colors.blue)        // ❌

// Hardcoded opacity colors in const contexts
const BoxShadow(color: Color(0x1A0064FF))  // ❌ Compilation error
```

#### 📋 **Color Categories**
- **Brand Colors**: `primary`, `primarySurface`
- **Grayscale**: `gray50` → `gray900`, `black`, `white`
- **Semantic**: `success`, `error`, `warning`, `info` (+Light variants)
- **Financial**: `profit`, `loss` (same as success/error)
- **Surface**: `background`, `surface`, `overlay`
- **Text**: `textPrimary`, `textSecondary`, `textTertiary`, `textInverse`
- **Borders**: `border`, `borderLight`
- **Special**: `shadow`, `transparent`, `shimmer`

### 📝 Typography Rules

#### ✅ **ALWAYS DO**
```dart
// Use TossTextStyles as base, customize with copyWith
Text(
  'Hello World',
  style: TossTextStyles.h1.copyWith(
    color: TossColors.primary,
    fontWeight: FontWeight.w700,
  ),
)

// For standard patterns, use directly
Text('Body text', style: TossTextStyles.body)
```

#### ❌ **NEVER DO**
```dart
// Direct TextStyle instantiation
Text(style: TextStyle(fontSize: 16, color: Colors.black))  // ❌

// Hardcoded font sizes in copyWith
style: TossTextStyles.body.copyWith(fontSize: 14)  // ❌

// Const context with copyWith
const Text(style: TossTextStyles.body.copyWith(...))  // ❌ Compilation error
```

#### 📋 **Text Style Hierarchy**
- **Display**: `display` (32px) - Hero titles
- **Headlines**: `h1` (24px), `h2` (20px), `h3` (18px) - Section titles
- **Body**: `bodyLarge` (16px), `body` (14px) - Content text
- **Labels**: `labelLarge` (14px), `label` (12px) - UI labels
- **Support**: `caption` (12px), `small` (11px) - Secondary info

### 📐 Spacing Rules

#### ✅ **ALWAYS DO**
```dart
// Use TossSpacing constants
EdgeInsets.all(TossSpacing.space4)  // 16px
Padding(padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3))

// Component-specific spacing
Container(height: TossSpacing.buttonHeight)  // 48px
SizedBox(height: TossSpacing.space6)  // 24px
```

#### ❌ **NEVER DO**
```dart
// Hardcoded pixel values
EdgeInsets.all(16)                    // ❌
EdgeInsets.fromLTRB(12, 8, 12, 8)    // ❌
SizedBox(height: 20)                 // ❌
```

#### 📋 **Spacing Scale** (4px Grid)
- **Micro**: `space0` (0), `space1` (4), `space2` (8)
- **Small**: `space3` (12), `space4` (16), `space5` (20)
- **Medium**: `space6` (24), `space7` (28), `space8` (32)
- **Large**: `space9` (36), `space10` (40), `space12` (48)
- **XL**: `space16` (64), `space20` (80), `space24` (96)

### 🔘 Border Radius Rules

#### ✅ **ALWAYS DO**
```dart
// Use TossBorderRadius constants
BorderRadius.circular(TossBorderRadius.md)    // 8px - Standard
BorderRadius.circular(TossBorderRadius.lg)    // 12px - Cards
BorderRadius.circular(TossBorderRadius.xl)    // 16px - Modals
```

#### 📋 **Border Radius Scale**
- **Micro**: `xs` (4px), `sm` (6px)
- **Standard**: `md` (8px) - Buttons, inputs
- **Cards**: `lg` (12px) - Card components
- **Modals**: `xl` (16px), `xxl` (20px)
- **Special**: `full` (999px) - Circular

---

## 📁 File Structure & Organization

### 🎨 **Foundation Layer** (Design Tokens)

```
lib/core/themes/
├── toss_colors.dart          # Complete color palette
├── toss_text_styles.dart     # Typography system  
├── toss_spacing.dart         # 4px grid spacing
├── toss_border_radius.dart   # Component radii
├── toss_shadows.dart         # Elevation system
├── toss_animations.dart      # Motion system
└── toss_icons.dart           # Semantic icons
```

**When to modify**: Only when adding new design tokens or updating brand colors

### 🏗️ **Application Layer** (Integration)

```
lib/core/themes/
├── app_theme.dart            # Flutter ThemeData configuration
├── toss_design_system.dart   # Master reference & utilities  
├── toss_page_styles.dart     # Page-level patterns
└── index.dart               # Barrel export (single import)
```

**When to modify**: When configuring new Flutter components or adding page patterns

### 🔧 **Developer Tools** (Quality & Migration)

```
lib/core/themes/
├── theme_validator.dart      # Runtime consistency checking
├── theme_compatibility.dart  # Migration support
└── theme_extensions.dart     # BuildContext extensions
```

**When to modify**: When adding new validation rules or migration utilities

### 🛠️ **Build Tools**

```
bin/
└── improved_theme_monitor.dart  # Static analysis tool
```

**When to use**: Run `dart bin/improved_theme_monitor.dart` to check consistency

---

## 💡 Usage Patterns

### Import Strategy

```dart
// Single import for everything
import 'package:myfinance_improved/core/themes/index.dart';

// Now use all theme components
Container(
  padding: EdgeInsets.all(TossSpacing.space4),
  decoration: BoxDecoration(
    color: TossColors.surface,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
    boxShadow: TossShadows.card,
  ),
  child: Text(
    'Example',
    style: TossTextStyles.body.copyWith(
      color: TossColors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

### Common Component Patterns

#### **Card Pattern**
```dart
Container(
  padding: EdgeInsets.all(TossSpacing.space4),
  decoration: BoxDecoration(
    color: TossColors.surface,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
    border: Border.all(color: TossColors.borderLight),
    boxShadow: TossShadows.card,  // Ultra-subtle
  ),
  child: Column(
    children: [
      Text('Title', style: TossTextStyles.h3),
      SizedBox(height: TossSpacing.space3),
      Text('Content', style: TossTextStyles.body),
    ],
  ),
)
```

#### **Button Pattern**
```dart
TossPrimaryButton(
  text: 'Action',
  onPressed: () {},
  // Automatically uses correct spacing, colors, shadows
)

// Or custom button
Container(
  height: TossSpacing.buttonHeight,  // 48px
  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
  decoration: BoxDecoration(
    color: TossColors.primary,
    borderRadius: BorderRadius.circular(TossBorderRadius.md),
  ),
  child: Text(
    'Custom Button',
    style: TossTextStyles.body.copyWith(
      color: TossColors.white,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

#### **List Item Pattern**
```dart
Container(
  padding: EdgeInsets.all(TossSpacing.space4),
  decoration: BoxDecoration(
    border: Border(
      bottom: BorderSide(color: TossColors.borderLight),
    ),
  ),
  child: Row(
    children: [
      Container(
        width: TossSpacing.iconLG,  // 32px
        height: TossSpacing.iconLG,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Icon(
          Icons.person,
          color: TossColors.primary,
          size: TossSpacing.iconMD,
        ),
      ),
      SizedBox(width: TossSpacing.space3),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title', style: TossTextStyles.body),
            Text('Subtitle', style: TossTextStyles.caption),
          ],
        ),
      ),
    ],
  ),
)
```

---

## 🆕 Creating New Theme Files

### When to Create New Theme Files

**Create new files when**:
- Adding a new category of design tokens (e.g., `toss_breakpoints.dart`)
- Building page-specific style collections (e.g., `dashboard_styles.dart`)
- Adding component-specific theme extensions

**DON'T create new files for**:
- Single color or spacing additions (add to existing files)
- Temporary styling needs (use inline styling)
- Component-specific overrides (use copyWith patterns)

### Template for New Theme Files

```dart
// lib/core/themes/toss_[category].dart
import 'package:flutter/material.dart';
import 'toss_colors.dart';  // Only import what you need
import 'toss_spacing.dart';

/// [Category] System - [Brief description]
/// Based on Toss design patterns
/// 
/// Design Philosophy:
/// - [Principle 1]
/// - [Principle 2]
/// - [Principle 3]
class Toss[Category] {
  Toss[Category]._();  // Private constructor

  // ==================== [SECTION NAME] ====================
  
  /// [Description of constant]
  static const [Type] [name] = [value];
  
  // ==================== UTILITIES ====================
  
  /// Helper method for [purpose]
  static [ReturnType] [methodName]([Parameters]) {
    return [implementation];
  }
}
```

### Adding to Barrel Export

After creating a new theme file, add it to `index.dart`:

```dart
// lib/core/themes/index.dart
export 'toss_colors.dart';
export 'toss_text_styles.dart';
export 'toss_spacing.dart';
export 'toss_border_radius.dart';
export 'toss_shadows.dart';
export 'toss_animations.dart';
export 'toss_icons.dart';
export 'toss_design_system.dart';
export 'app_theme.dart';
export 'toss_page_styles.dart';
export 'theme_extensions.dart';
export 'toss_[new_category].dart';  // Add your new file here
```

---

## 🔍 Validation & Monitoring

### Theme Monitor Tool

**Run the theme monitor**:
```bash
dart bin/improved_theme_monitor.dart
```

**Expected output**:
```
🎉 No real theme issues found!
✅ Theme consistency: 100%
```

**If issues are found**:
```
📊 Theme Issues Summary:
🔍 Real issues found: 2

🎨 Issues to fix:
📝 TextStyle issue at lib/presentation/pages/example.dart:45:
  Current: TextStyle(fontSize: 16, color: Colors.black)
  Suggested: Use TossTextStyles instead

🎨 Color issue at lib/presentation/widgets/example.dart:23:
  Current: Container(color: Color(0xFF0064FF))
  Suggested: Use TossColors instead
```

### Real-time Validation

**Enable theme validator in debug mode**:
```dart
// In main.dart or app initialization
void main() {
  if (kDebugMode) {
    ThemeValidator.initialize();  // Runtime validation
  }
  runApp(MyApp());
}
```

### IDE Integration

**VS Code settings** (`.vscode/settings.json`):
```json
{
  "dart.analysisExcludedFolders": [],
  "dart.showTodos": true,
  "dart.previewFlutterUiGuides": true,
  "dart.flutterHotRestartOnSave": false,
  "files.associations": {
    "*.dart": "dart"
  }
}
```

---

## ⚠️ Common Issues & Solutions

### Issue 1: Compilation Errors with const

**Problem**:
```dart
const Text(
  'Hello',
  style: TossTextStyles.body.copyWith(color: TossColors.primary),  // ❌
)
```
**Error**: `Method invocation is not a constant expression`

**Solution**:
```dart
Text(  // Remove const
  'Hello',
  style: TossTextStyles.body.copyWith(color: TossColors.primary),  // ✅
)
```

### Issue 2: Theme Monitor False Positives

**Problem**: Monitor flags legitimate theme system files

**Solution**: The improved monitor excludes system files automatically:
```dart
// These files are automatically excluded:
// - lib/core/themes/toss_colors.dart
// - lib/core/themes/theme_validator.dart
// - lib/core/themes/theme_compatibility.dart
```

### Issue 3: Inconsistent Spacing

**Problem**:
```dart
EdgeInsets.fromLTRB(16, 12, 16, 8)  // ❌ Not grid-aligned
```

**Solution**:
```dart
EdgeInsets.symmetric(
  horizontal: TossSpacing.space4,  // 16px
  vertical: TossSpacing.space3,    // 12px
)
```

### Issue 4: Shadow Performance

**Problem**: Heavy shadow causing performance issues

**Solution**: Use Toss ultra-subtle shadows:
```dart
// Instead of heavy shadows
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.3),  // ❌ Too heavy
    blurRadius: 20,
    spreadRadius: 5,
  )
]

// Use Toss shadows (2-8% opacity)
boxShadow: TossShadows.card  // ✅ Professional & performant
```

---

## ✅ Best Practices

### 1. **Design Token First**
Always start with design tokens, not hardcoded values:
```dart
// ✅ Good
Container(
  padding: EdgeInsets.all(TossSpacing.space4),
  decoration: BoxDecoration(
    color: TossColors.surface,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
  ),
)

// ❌ Bad  
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

### 2. **Semantic Naming**
Use semantic color names, not descriptive ones:
```dart
// ✅ Good - Intent-based
color: TossColors.textSecondary
color: TossColors.error
color: TossColors.success

// ❌ Bad - Appearance-based
color: TossColors.gray600
color: TossColors.red
color: TossColors.green
```

### 3. **Consistent Component Patterns**
Establish patterns for common components:
```dart
// ✅ Good - Consistent card pattern
Widget buildCard({required String title, required Widget child}) {
  return Container(
    padding: EdgeInsets.all(TossSpacing.space4),
    decoration: BoxDecoration(
      color: TossColors.surface,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      boxShadow: TossShadows.card,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TossTextStyles.h3),
        SizedBox(height: TossSpacing.space3),
        child,
      ],
    ),
  );
}
```

### 4. **Responsive Spacing**
Use the responsive spacing system:
```dart
// ✅ Good - Responsive
EdgeInsets.all(TossSpacing.space4)  // 16px mobile, 20px tablet

// ❌ Bad - Fixed  
EdgeInsets.all(16)
```

### 5. **Theme Extensions**
Use theme extensions for complex logic:
```dart
// ✅ Good - Use extension methods
context.theme.colors.primary
context.spacing.cardPadding
context.textStyles.bodyWithPrimary

// ❌ Bad - Direct access
TossColors.primary
TossSpacing.space4
TossTextStyles.body.copyWith(color: TossColors.primary)
```

---

## 🚫 Anti-Patterns

### 1. **Magic Numbers**
```dart
// ❌ NEVER - Hardcoded values
SizedBox(height: 24)
EdgeInsets.all(16)
fontSize: 14

// ✅ ALWAYS - Design tokens
SizedBox(height: TossSpacing.space6)
EdgeInsets.all(TossSpacing.space4)
style: TossTextStyles.body
```

### 2. **Color Calculations**
```dart
// ❌ NEVER - Manual color calculations
Color.fromRGBO(0, 100, 255, 0.1)
Colors.blue.withOpacity(0.8)

// ✅ ALWAYS - Theme colors with opacity
TossColors.primary.withOpacity(0.1)
TossColors.primarySurface
```

### 3. **Mixed Systems**
```dart
// ❌ NEVER - Mixing systems
Container(
  padding: EdgeInsets.all(TossSpacing.space4),  // Toss system
  decoration: BoxDecoration(
    color: Colors.white,  // Material system ❌
    borderRadius: BorderRadius.circular(8),  // Hardcoded ❌
  ),
)

// ✅ ALWAYS - Consistent system
Container(
  padding: EdgeInsets.all(TossSpacing.space4),
  decoration: BoxDecoration(
    color: TossColors.surface,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
  ),
)
```

### 4. **Const Context Violations**
```dart
// ❌ NEVER - copyWith in const context
const Container(
  decoration: BoxDecoration(
    color: TossColors.primary.withOpacity(0.1),  // ❌ Runtime method
  ),
)

// ✅ ALWAYS - Remove const or use const colors
Container(  // No const
  decoration: BoxDecoration(
    color: TossColors.primary.withOpacity(0.1),
  ),
)
```

### 5. **Style Inheritance Violations**
```dart
// ❌ NEVER - Custom TextStyle without base
Text(
  'Hello',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  ),
)

// ✅ ALWAYS - Extend theme styles  
Text(
  'Hello',
  style: TossTextStyles.body.copyWith(
    fontWeight: FontWeight.w600,
  ),
)
```

---

## 🔄 Migration Guide

### Gradual Migration Strategy

**Phase 1: Colors**
```dart
// Old
Container(color: Color(0xFF0064FF))
Container(color: Colors.grey[100])

// New
Container(color: TossColors.primary)
Container(color: TossColors.gray100)
```

**Phase 2: Typography**
```dart
// Old
Text(style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))

// New
Text(style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600))
```

**Phase 3: Spacing**
```dart
// Old
EdgeInsets.all(16)
EdgeInsets.fromLTRB(16, 12, 16, 8)

// New
EdgeInsets.all(TossSpacing.space4)
EdgeInsets.symmetric(horizontal: TossSpacing.space4, vertical: TossSpacing.space3)
```

### Automated Migration Tool

Use the theme compatibility layer for automatic migration:

```dart
// Enable compatibility mode
ThemeCompatibility.enable();

// Use migration helpers
final themeColor = ThemeCompatibility.migrateColor(Color(0xFF0064FF));
final themeStyle = ThemeCompatibility.migrateTextStyle(fontSize: 16);
```

### Migration Checklist

- [ ] Replace all `Color(0x...)` with `TossColors.*`
- [ ] Replace all `TextStyle(fontSize: ...)` with `TossTextStyles.*`  
- [ ] Replace all hardcoded `EdgeInsets` with `TossSpacing.*`
- [ ] Replace all hardcoded `BorderRadius` with `TossBorderRadius.*`
- [ ] Remove `const` from widgets using `.copyWith()`
- [ ] Run theme monitor: `dart bin/improved_theme_monitor.dart`
- [ ] Verify build success: `flutter build ios --release`

---

## 📚 Quick Reference

### Import
```dart
import 'package:myfinance_improved/core/themes/index.dart';
```

### Colors
```dart
TossColors.primary          // #0064FF (Toss Blue)
TossColors.gray100          // Background
TossColors.textPrimary      // Main text
TossColors.success          // Green states
TossColors.error            // Error states
```

### Typography  
```dart
TossTextStyles.h1           // 24px headlines
TossTextStyles.body         // 14px body text
TossTextStyles.caption      // 12px secondary
```

### Spacing
```dart
TossSpacing.space4          // 16px (default)
TossSpacing.buttonHeight    // 48px components
TossSpacing.iconMD          // 20px icons
```

### Border Radius
```dart
TossBorderRadius.md         // 8px buttons
TossBorderRadius.lg         // 12px cards
TossBorderRadius.xl         // 16px modals
```

### Shadows
```dart
TossShadows.card            // Subtle card elevation
TossShadows.bottomSheet     // Modal shadows
TossShadows.none            // Flat appearance
```

---

## 🎯 Validation Commands

**Check theme consistency**:
```bash
dart bin/improved_theme_monitor.dart
```

**Build verification**:
```bash
flutter build ios --release --no-pub
```

**Analyze code quality**:
```bash
flutter analyze --no-pub
```

---

**📝 Last Updated**: December 2024  
**✅ Version**: 2.0 - Comprehensive Theme System  
**👥 Maintained by**: myFinance Development Team

For questions or updates to this guide, please check with the development team or refer to the theme system source files in `lib/core/themes/`.