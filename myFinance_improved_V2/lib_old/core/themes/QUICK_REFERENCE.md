# 🚀 Toss Theme System - Quick Reference

**Essential commands and patterns for daily development**

---

## 📦 Single Import

```dart
import 'package:myfinance_improved/core/themes/index.dart';
```

---

## 🎨 Colors

```dart
// Brand & UI
TossColors.primary          // #0064FF Toss Blue
TossColors.gray100          // Light background
TossColors.surface          // White cards
TossColors.border           // Default borders

// Text Colors
TossColors.textPrimary      // Main text (#212529)
TossColors.textSecondary    // Secondary text (#6C757D)
TossColors.textTertiary     // Hint text (#ADB5BD)

// States
TossColors.success          // Green confirmations
TossColors.error            // Red errors/warnings
TossColors.warning          // Orange alerts
```

---

## 📝 Typography

```dart
// Headlines
TossTextStyles.h1           // 24px section titles
TossTextStyles.h2           // 20px subsections
TossTextStyles.h3           // 18px card headers

// Body Text
TossTextStyles.bodyLarge    // 16px important content
TossTextStyles.body         // 14px standard text
TossTextStyles.caption      // 12px secondary info

// Usage Pattern
Text(
  'Title',
  style: TossTextStyles.h2.copyWith(
    color: TossColors.primary,
    fontWeight: FontWeight.w700,
  ),
)
```

---

## 📐 Spacing (4px Grid)

```dart
// Common Spacing
TossSpacing.space4          // 16px - Standard padding
TossSpacing.space3          // 12px - Compact spacing
TossSpacing.space6          // 24px - Section gaps

// Component Spacing
TossSpacing.buttonHeight    // 48px - Button height
TossSpacing.iconMD          // 20px - Standard icons
TossSpacing.iconLG          // 32px - Large icons

// Usage Pattern
EdgeInsets.all(TossSpacing.space4)
EdgeInsets.symmetric(
  horizontal: TossSpacing.space4,
  vertical: TossSpacing.space3,
)
```

---

## 🔘 Border Radius

```dart
TossBorderRadius.md         // 8px - Buttons, inputs
TossBorderRadius.lg         // 12px - Cards, containers
TossBorderRadius.xl         // 16px - Modals, dialogs

// Usage
BorderRadius.circular(TossBorderRadius.lg)
```

---

## 🌟 Common Patterns

### Card Pattern
```dart
Container(
  padding: EdgeInsets.all(TossSpacing.space4),
  decoration: BoxDecoration(
    color: TossColors.surface,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
    boxShadow: TossShadows.card,
  ),
  child: Text('Content', style: TossTextStyles.body),
)
```

### List Item Pattern
```dart
Container(
  padding: EdgeInsets.all(TossSpacing.space4),
  decoration: BoxDecoration(
    border: Border(bottom: BorderSide(color: TossColors.borderLight)),
  ),
  child: Row(
    children: [
      Icon(Icons.person, color: TossColors.primary, size: TossSpacing.iconMD),
      SizedBox(width: TossSpacing.space3),
      Text('Title', style: TossTextStyles.body),
    ],
  ),
)
```

### Button Pattern
```dart
Container(
  height: TossSpacing.buttonHeight,
  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
  decoration: BoxDecoration(
    color: TossColors.primary,
    borderRadius: BorderRadius.circular(TossBorderRadius.md),
  ),
  child: Text(
    'Action',
    style: TossTextStyles.body.copyWith(
      color: TossColors.white,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

---

## ⚡ Quick Commands

```bash
# Check theme consistency
dart bin/improved_theme_monitor.dart

# Build verification  
flutter build ios --release --no-pub

# Expected output: ✅ Theme consistency: 100%
```

---

## 🚫 Avoid These

```dart
// ❌ NEVER
Container(color: Color(0xFF0064FF))          // Use TossColors.primary
Text(style: TextStyle(fontSize: 16))         // Use TossTextStyles.body
EdgeInsets.all(16)                           // Use TossSpacing.space4
const Text(style: TossTextStyles.body.copyWith(...))  // Remove const

// ✅ ALWAYS
Container(color: TossColors.primary)
Text(style: TossTextStyles.body)
EdgeInsets.all(TossSpacing.space4)
Text(style: TossTextStyles.body.copyWith(...))  // No const
```

---

## 📚 Full Documentation

For complete documentation, see: [`THEME_SYSTEM_GUIDE.md`](./THEME_SYSTEM_GUIDE.md)

---

**🎯 Key Rule**: Always use design tokens, never hardcoded values!