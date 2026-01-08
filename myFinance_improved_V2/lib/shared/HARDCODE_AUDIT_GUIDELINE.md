# 🔍 Hardcode Audit Guideline for Flutter UI Consistency

> **Version:** 2025.1 | **Target:** time_table_manage feature
> **Goal:** Replace all hardcoded UI values with centralized theme tokens

---

## 📋 Table of Contents

1. [Pre-Audit Setup](#pre-audit-setup)
2. [Audit Categories](#audit-categories)
3. [Detection Methods (2025 Best Practices)](#detection-methods)
4. [Step-by-Step Screening Process](#screening-process)
5. [Decision Matrix](#decision-matrix)
6. [Available Theme Tokens Reference](#theme-tokens-reference)
7. [Checklist Templates](#checklist-templates)
8. [Post-Audit Validation](#post-audit-validation)

---

## 🛠️ Pre-Audit Setup {#pre-audit-setup}

### Required Tools

```bash
# 1. VS Code Extensions (2025 recommended)
- Dart/Flutter extension
- Error Lens (immediate inline feedback)
- Todo Tree (track TODOs during audit)

# 2. Enable strict analysis (pubspec.yaml or analysis_options.yaml)
analyzer:
  errors:
    avoid_hard_coded_colors: warning  # Custom lint if available
  strong-mode:
    implicit-casts: false
```

### Create Audit Tracking File

Create a spreadsheet or markdown file to track findings:

```markdown
| File | Line | Category | Hardcoded Value | Suggested Token | Status |
|------|------|----------|-----------------|-----------------|--------|
```

---

## 🎯 Audit Categories {#audit-categories}

### Category 1: COLORS 🎨
**Severity: HIGH** - Colors are the most visible inconsistency

| Pattern to Find | Example | Severity |
|-----------------|---------|----------|
| `Color(0x...)` | `Color(0xFF0064FF)` | 🔴 High |
| `Colors.*` | `Colors.red` | 🔴 High |
| `Color.fromRGBO(...)` | `Color.fromRGBO(0, 100, 255, 1)` | 🔴 High |
| `Color.fromARGB(...)` | `Color.fromARGB(255, 0, 100, 255)` | 🔴 High |
| Hex in string | `'#0064FF'` | 🟡 Medium |
| `.withOpacity(...)` | `.withOpacity(0.5)` | 🟡 Medium |
| `.withValues(alpha: ...)` | `.withValues(alpha: 0.15)` | 🟡 Medium |

### Category 2: SPACING & PADDING 📐
**Severity: HIGH** - Affects layout consistency

| Pattern to Find | Example | Severity |
|-----------------|---------|----------|
| `EdgeInsets.all(number)` | `EdgeInsets.all(16)` | 🔴 High |
| `EdgeInsets.symmetric(...)` | `EdgeInsets.symmetric(horizontal: 12)` | 🔴 High |
| `EdgeInsets.only(...)` | `EdgeInsets.only(left: 8)` | 🔴 High |
| `EdgeInsets.fromLTRB(...)` | `EdgeInsets.fromLTRB(8, 4, 8, 4)` | 🔴 High |
| `SizedBox(width: number)` | `SizedBox(width: 8)` | 🟡 Medium |
| `SizedBox(height: number)` | `SizedBox(height: 16)` | 🟡 Medium |
| `Padding(padding: ...)` with numbers | Direct number values | 🔴 High |

### Category 3: FONT SIZE & TYPOGRAPHY 🔤
**Severity: HIGH** - Text readability and hierarchy

| Pattern to Find | Example | Severity |
|-----------------|---------|----------|
| `fontSize: number` | `fontSize: 14` | 🔴 High |
| `fontWeight: FontWeight.w*` | `fontWeight: FontWeight.w600` | 🟡 Medium |
| `letterSpacing: number` | `letterSpacing: 0.5` | 🟡 Medium |
| `height: number` (line height) | `height: 1.5` | 🟡 Medium |
| `TextStyle(...)` with inline values | Full inline TextStyle | 🔴 High |

### Category 4: BORDER RADIUS 📦
**Severity: MEDIUM** - Affects visual consistency

| Pattern to Find | Example | Severity |
|-----------------|---------|----------|
| `BorderRadius.circular(number)` | `BorderRadius.circular(12)` | 🟡 Medium |
| `BorderRadius.all(Radius.circular(n))` | `Radius.circular(8)` | 🟡 Medium |
| `BorderRadius.only(...)` with numbers | `topLeft: Radius.circular(16)` | 🟡 Medium |
| `ClipRRect` with hardcoded radius | `borderRadius: BorderRadius.circular(20)` | 🟡 Medium |

### Category 5: ANIMATION 🎬
**Severity: MEDIUM** - Affects motion consistency

| Pattern to Find | Example | Severity |
|-----------------|---------|----------|
| `Duration(milliseconds: number)` | `Duration(milliseconds: 300)` | 🟡 Medium |
| `Duration(seconds: number)` | `Duration(seconds: 1)` | 🟡 Medium |
| `Curves.*` not from theme | `Curves.easeInOut` | 🟢 Low |
| `animationDuration` inline | Any inline duration | 🟡 Medium |

### Category 6: DIMENSIONS & SIZES 📏
**Severity: MEDIUM** - Component sizing

| Pattern to Find | Example | Severity |
|-----------------|---------|----------|
| `width: number` | `width: 100` | 🟡 Medium |
| `height: number` | `height: 48` | 🟡 Medium |
| `constraints: BoxConstraints(...)` | `minHeight: 44` | 🟡 Medium |
| `size: number` (icons) | `size: 24` | 🟡 Medium |
| Fixed aspect ratios | `aspectRatio: 1.5` | 🟢 Low |

### Category 7: SHADOWS & ELEVATION 🌑
**Severity: LOW** - Visual depth

| Pattern to Find | Example | Severity |
|-----------------|---------|----------|
| `BoxShadow(...)` inline | Full BoxShadow definition | 🟡 Medium |
| `elevation: number` | `elevation: 4` | 🟢 Low |
| `blurRadius: number` | `blurRadius: 10` | 🟢 Low |
| `spreadRadius: number` | `spreadRadius: 2` | 🟢 Low |

---

## 🔬 Detection Methods (2025 Best Practices) {#detection-methods}

### Method 1: Regex Search (VS Code)

Use **Ctrl/Cmd + Shift + F** with these regex patterns:

```regex
# COLORS
Color\(0x[A-Fa-f0-9]+\)
Colors\.[a-zA-Z]+
Color\.from(RGBO|ARGB)\(

# SPACING - Numbers in EdgeInsets
EdgeInsets\.(all|symmetric|only|fromLTRB)\s*\([^)]*\d+[^)]*\)

# FONT SIZE
fontSize:\s*\d+

# BORDER RADIUS
BorderRadius\.circular\(\s*\d+

# ANIMATIONS
Duration\((milliseconds|seconds):\s*\d+\)

# SIZES (SizedBox)
SizedBox\((width|height):\s*\d+

# GENERIC NUMBER DETECTION (careful - many false positives)
(width|height|size|padding|margin):\s*\d+(\.\d+)?
```

### Method 2: dart_code_metrics (Recommended 2025)

```yaml
# analysis_options.yaml
analyzer:
  plugins:
    - dart_code_metrics

dart_code_metrics:
  rules:
    - avoid-border-all
    - prefer-const-border-radius
    # Add custom rules for your project
```

### Method 3: Custom Lint Rules (flutter_lints)

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - avoid_redundant_argument_values
    - prefer_const_constructors
```

### Method 4: AST-Based Analysis Script

Create a Dart script for deep analysis:

```dart
// tools/hardcode_detector.dart
// Run: dart tools/hardcode_detector.dart lib/features/time_table_manage

import 'dart:io';

void main(List<String> args) {
  final directory = args.isNotEmpty ? args[0] : 'lib';

  final patterns = {
    'Color Hex': RegExp(r'Color\(0x[A-Fa-f0-9]+\)'),
    'Colors.*': RegExp(r'Colors\.[a-zA-Z]+'),
    'fontSize': RegExp(r'fontSize:\s*\d+'),
    'EdgeInsets numbers': RegExp(r'EdgeInsets\.\w+\([^)]*\d+'),
    'BorderRadius.circular': RegExp(r'BorderRadius\.circular\(\s*\d+'),
    'Duration': RegExp(r'Duration\((milliseconds|seconds):\s*\d+'),
    'SizedBox': RegExp(r'SizedBox\((width|height):\s*\d+'),
    'width/height': RegExp(r'(width|height):\s*\d+(\.\d+)?(?!,\s*(width|height))'),
  };

  scanDirectory(Directory(directory), patterns);
}

void scanDirectory(Directory dir, Map<String, RegExp> patterns) {
  for (final file in dir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      scanFile(file, patterns);
    }
  }
}

void scanFile(File file, Map<String, RegExp> patterns) {
  final lines = file.readAsLinesSync();
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    for (final entry in patterns.entries) {
      if (entry.value.hasMatch(line)) {
        print('${entry.key} | ${file.path}:${i + 1} | ${line.trim()}');
      }
    }
  }
}
```

### Method 5: IDE Navigation (Manual but Thorough)

1. **Find Usages** - Search for `TextStyle(` and check each usage
2. **Find Symbol** - Search for widget constructors with style params
3. **Code Outline** - Review widget build methods systematically

---

## 📝 Step-by-Step Screening Process {#screening-process}

### Phase 1: Preparation (10 min)

```
□ 1.1 Open your theme folder and review all available tokens
     Location: lib/shared/themes/

□ 1.2 Create the audit tracking spreadsheet/document

□ 1.3 Set up your regex search patterns in VS Code

□ 1.4 Identify all dart files in target feature:
     Run: find lib/features/time_table_manage -name "*.dart" | wc -l
```

### Phase 2: Automated Scan (15 min per category)

**For each category, follow this process:**

```
□ 2.1 Run regex search for the category
     Example: Ctrl+Shift+F → "fontSize:\s*\d+"

□ 2.2 Export results to tracking document
     Include: File, Line Number, Current Value

□ 2.3 Mark false positives (constants already defined correctly)

□ 2.4 Categorize by severity (High/Medium/Low)
```

### Phase 3: File-by-File Review (Most thorough)

**Go through each file systematically:**

```
□ 3.1 Open the file in editor

□ 3.2 Expand all code folds to see everything

□ 3.3 Use Ctrl+F to search within file:
     - Search: "EdgeInsets" → Check all padding
     - Search: "SizedBox" → Check all spacing
     - Search: "TextStyle" → Check all typography
     - Search: "Color" → Check all colors
     - Search: "BorderRadius" → Check all corners
     - Search: "Duration" → Check all animations
     - Search: "width:" and "height:" → Check sizes

□ 3.4 Look at widget parameters in build() methods

□ 3.5 Check decoration properties (BoxDecoration, InputDecoration)

□ 3.6 Review Container constraints

□ 3.7 Document all findings
```

### Phase 4: Cross-Reference with Theme Tokens

```
□ 4.1 For each finding, check if token exists:
     - TossColors.* for colors
     - TossSpacing.* for spacing
     - TossTextStyles.* for typography
     - TossBorderRadius.* for corners
     - TossAnimations.* for durations
     - TossShadows.* for shadows

□ 4.2 If token exists → Mark for direct replacement

□ 4.3 If no token exists → Document for new token creation

□ 4.4 Update tracking document with replacement decisions
```

### Phase 5: Pattern Grouping

```
□ 5.1 Group similar hardcoded values together
     Example: All "fontSize: 12" instances

□ 5.2 Identify repeated patterns that need new tokens
     Example: Multiple files use "EdgeInsets.symmetric(horizontal: 6, vertical: 2)"

□ 5.3 Prioritize by:
     - Frequency of occurrence
     - Visibility to users
     - Consistency impact
```

---

## 🎯 Decision Matrix {#decision-matrix}

### When to Use Existing Token

| Situation | Action |
|-----------|--------|
| Exact match exists | Use the token directly |
| Close match exists (±2px) | Use existing token, document minor deviation |
| Semantic match (e.g., "primary color") | Use semantic token |

### When to Create New Token

| Situation | Action |
|-----------|--------|
| Value used 3+ times | Create component-specific token |
| Represents new semantic meaning | Create semantic token |
| Standard UI pattern | Create pattern token |

### When NOT to Replace

| Situation | Reason |
|-----------|--------|
| Calculation-based value | `width: containerWidth - padding` |
| Platform-specific value | System requirements |
| One-off animation | Unique interaction |
| Responsive breakpoint | Layout-specific |

### Replacement Priority

```
Priority 1 (Must Replace)
├── Colors used in multiple places
├── Primary typography (body, headings)
├── Standard button/input sizes
└── Common spacing (8, 12, 16, 24px)

Priority 2 (Should Replace)
├── Border radius values
├── Animation durations
├── Icon sizes
└── Margin/padding patterns

Priority 3 (Consider Replacing)
├── One-off specific dimensions
├── Opacity values
└── Shadow parameters
└── Line heights
```

---

## 📚 Available Theme Tokens Reference {#theme-tokens-reference}

### TossColors (lib/shared/themes/toss_colors.dart)

```dart
// Primary
TossColors.primary           // #0064FF - Main brand color
TossColors.primaryLight      // Light variant
TossColors.primaryDark       // Dark variant

// Grayscale
TossColors.white             // #FFFFFF
TossColors.gray50            // Lightest gray
TossColors.gray100-900       // Gray scale
TossColors.black             // #000000

// Semantic
TossColors.success           // Green - positive actions
TossColors.error             // Red - errors/destructive
TossColors.warning           // Yellow/Orange - caution
TossColors.info              // Blue - informational

// Financial
TossColors.profit            // Green - gains
TossColors.loss              // Red - losses

// Text
TossColors.textPrimary       // Main text
TossColors.textSecondary     // Secondary text
TossColors.textTertiary      // Hint/disabled text
TossColors.textInverse       // Text on dark backgrounds

// Surfaces
TossColors.background        // Page background
TossColors.surface           // Card/component surface
TossColors.surfaceVariant    // Alternative surface
TossColors.overlay           // Modal overlays
```

### TossSpacing (lib/shared/themes/toss_spacing.dart)

```dart
// Base 4px Grid
TossSpacing.space0           // 0px
TossSpacing.space1           // 4px
TossSpacing.space2           // 8px
TossSpacing.space3           // 12px
TossSpacing.space4           // 16px
TossSpacing.space5           // 20px
TossSpacing.space6           // 24px
TossSpacing.space8           // 32px
TossSpacing.space10          // 40px
TossSpacing.space12          // 48px
TossSpacing.space16          // 64px
TossSpacing.space20          // 80px
TossSpacing.space24          // 96px

// Semantic Spacing
TossSpacing.paddingXS        // Extra small padding
TossSpacing.paddingSM        // Small padding
TossSpacing.paddingMD        // Medium padding
TossSpacing.paddingLG        // Large padding
TossSpacing.paddingXL        // Extra large padding

TossSpacing.marginXS/SM/MD/LG/XL   // Margin variants
TossSpacing.gapXS/SM/MD/LG/XL      // Gap variants

// Component Sizes
TossSpacing.iconXS           // 16px
TossSpacing.iconSM           // 20px
TossSpacing.iconMD           // 24px
TossSpacing.iconLG           // 32px
TossSpacing.iconXL           // 40px

TossSpacing.buttonHeightSM   // 32px
TossSpacing.buttonHeightMD   // 40px
TossSpacing.buttonHeightLG   // 48px
TossSpacing.buttonHeightXL   // 56px

TossSpacing.inputHeightSM    // 36px
TossSpacing.inputHeightMD    // 44px
TossSpacing.inputHeightLG    // 52px
TossSpacing.inputHeightXL    // 56px
```

### TossBorderRadius (lib/shared/themes/toss_border_radius.dart)

```dart
// Base Scale
TossBorderRadius.none        // 0px
TossBorderRadius.xs          // 4px
TossBorderRadius.sm          // 6px
TossBorderRadius.md          // 8px
TossBorderRadius.lg          // 12px
TossBorderRadius.xl          // 16px
TossBorderRadius.xxl         // 20px
TossBorderRadius.xxxl        // 24px
TossBorderRadius.full        // 999px (pill shape)

// Component-Specific
TossBorderRadius.button      // 8px
TossBorderRadius.input       // 8px
TossBorderRadius.card        // 12px
TossBorderRadius.dialog      // 16px
TossBorderRadius.bottomSheet // 20px
TossBorderRadius.chip        // 6px
TossBorderRadius.avatar      // 999px (circle)
```

### TossTextStyles (lib/shared/themes/toss_text_styles.dart)

```dart
// Display
TossTextStyles.display       // 32px bold

// Headings
TossTextStyles.h1            // 28px bold
TossTextStyles.h2            // 24px bold
TossTextStyles.h3            // 20px bold (semibold)
TossTextStyles.h4            // 18px bold (semibold)

// Titles
TossTextStyles.titleLarge    // 17px medium
TossTextStyles.titleMedium   // 15px medium

// Body
TossTextStyles.body          // 14px regular
TossTextStyles.bodyMedium    // 14px semibold
TossTextStyles.bodySmall     // 13px regular

// Labels & Captions
TossTextStyles.label         // 12px medium
TossTextStyles.labelSmall    // 11px medium
TossTextStyles.caption       // 12px regular
```

### TossAnimations (lib/shared/themes/toss_animations.dart)

```dart
// Durations
TossAnimations.instant       // 50ms
TossAnimations.quick         // 100ms
TossAnimations.fast          // 150ms
TossAnimations.normal        // 200ms
TossAnimations.medium        // 250ms
TossAnimations.slow          // 300ms
TossAnimations.slower        // 400ms

// Curves
TossAnimations.standard      // easeInOutCubic
TossAnimations.enter         // easeOutCubic
TossAnimations.exit          // easeInCubic
TossAnimations.emphasis      // fastOutSlowIn

// Special Durations
TossAnimations.loadingPulse      // 1200ms
TossAnimations.loadingRotation   // 1500ms
TossAnimations.debounceDelay     // 300ms
TossAnimations.toastDuration     // 3000ms
```

### TossShadows (lib/shared/themes/toss_shadows.dart)

```dart
TossShadows.none             // No shadow
TossShadows.elevation1       // Subtle
TossShadows.elevation2       // Light
TossShadows.elevation3       // Medium
TossShadows.elevation4       // Heavy

// Component-Specific
TossShadows.card             // Card shadow
TossShadows.button           // Button shadow
TossShadows.bottomSheet      // Bottom sheet shadow
TossShadows.fab              // FAB shadow
TossShadows.dropdown         // Dropdown shadow
TossShadows.navbar           // Navigation bar shadow
```

---

## ✅ Checklist Templates {#checklist-templates}

### Per-File Audit Checklist

```markdown
## File: [filename.dart]

### Colors
- [ ] No Color(0x...) found
- [ ] No Colors.* found
- [ ] No .withOpacity() found
- [ ] All colors use TossColors.*

### Spacing
- [ ] No EdgeInsets with raw numbers
- [ ] No SizedBox with raw numbers
- [ ] All spacing uses TossSpacing.*

### Typography
- [ ] No fontSize: with raw numbers
- [ ] No fontWeight: inline
- [ ] All text uses TossTextStyles.*

### Border Radius
- [ ] No BorderRadius.circular() with raw numbers
- [ ] All radius uses TossBorderRadius.*

### Animations
- [ ] No Duration() with raw numbers
- [ ] All durations use TossAnimations.*

### Dimensions
- [ ] width/height values are either:
  - [ ] Theme tokens
  - [ ] Calculation-based
  - [ ] Documented exceptions

### Notes
[Any special findings or exceptions]
```

### Feature-Level Summary Checklist

```markdown
## Feature: time_table_manage

### Overall Progress
- [ ] Presentation layer audited
- [ ] Widgets audited
- [ ] Bottom sheets audited
- [ ] All findings documented
- [ ] New tokens identified
- [ ] Ready for implementation

### Statistics
- Total files: __
- Files audited: __
- Hardcoded values found: __
- Tokens to create: __
- Direct replacements: __

### Priority Items
1. ____
2. ____
3. ____
```

---

## 🔒 Post-Audit Validation {#post-audit-validation}

### Validation Step 1: No-Error Check

After documenting all findings, verify the audit is complete:

```bash
# Run analyzer to ensure no syntax issues
flutter analyze lib/features/time_table_manage

# Run tests to ensure nothing is broken
flutter test
```

### Validation Step 2: Coverage Report

Create a summary report:

```markdown
## Audit Complete Report

### Scope
- Feature: time_table_manage
- Files Analyzed: [count]
- Date: [date]

### Findings Summary
| Category | Count | High | Medium | Low |
|----------|-------|------|--------|-----|
| Colors | | | | |
| Spacing | | | | |
| Typography | | | | |
| BorderRadius | | | | |
| Animations | | | | |
| Dimensions | | | | |
| **Total** | | | | |

### New Tokens Required
[List of tokens to add to theme system]

### Direct Replacements
[List of values that map directly to existing tokens]

### Exceptions (Justified Hardcodes)
[List of values that should remain hardcoded with reasons]
```

### Validation Step 3: Review Checklist

Before considering audit complete:

```
□ All .dart files in feature have been reviewed
□ All categories have been checked
□ Findings documented with file:line references
□ Each finding has suggested replacement
□ New token requirements are listed
□ Exceptions are documented with justification
□ No build errors after audit
□ Team has reviewed the findings
```

---

## 🚀 Quick Reference Commands

```bash
# Find all hardcoded colors
grep -rn "Color(0x" lib/features/time_table_manage/
grep -rn "Colors\." lib/features/time_table_manage/

# Find all hardcoded font sizes
grep -rn "fontSize:" lib/features/time_table_manage/

# Find all hardcoded spacing
grep -rn "EdgeInsets\." lib/features/time_table_manage/
grep -rn "SizedBox(" lib/features/time_table_manage/

# Find all hardcoded border radius
grep -rn "BorderRadius\.circular" lib/features/time_table_manage/

# Find all hardcoded durations
grep -rn "Duration(" lib/features/time_table_manage/

# Count total dart files
find lib/features/time_table_manage -name "*.dart" | wc -l

# List all dart files
find lib/features/time_table_manage -name "*.dart"
```

---

## 📌 Important Notes

1. **Don't fix during audit** - Document only, fix later in dedicated PR
2. **Include line numbers** - Always reference exact locations
3. **Context matters** - Some hardcodes are intentional (document why)
4. **Theme-first mindset** - Always check theme tokens before flagging
5. **Consistency > Perfection** - Some near-matches are acceptable
6. **Document exceptions** - If hardcode stays, explain why

---

*Created: 2025 | Last Updated: [date]*
*For: myFinance App Flutter Project*
