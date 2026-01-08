# Hardcode Refactoring Guideline - time_table_manage Feature

> **Goal**: Replace all hardcoded values (fonts, sizes, colors, spacing, animations) with shared theme data from `/lib/shared/themes/`
>
> **Author**: UI/UX Design System Specialist
> **Date**: 2025
> **Feature Scope**: `lib/features/time_table_manage/presentation/`

---

## ⚠️ CRITICAL: Iterative Verification Required

**DO NOT consider this task complete until ALL categories show 0 remaining issues.**

This refactoring MUST be done iteratively:
1. Run verification script
2. Fix ALL issues found
3. Run verification script AGAIN
4. Repeat until ALL categories = 0

---

## Table of Contents

1. [Current Theme System Overview](#1-current-theme-system-overview)
2. [Hardcode Detection Patterns](#2-hardcode-detection-patterns)
3. [Replacement Mapping Table](#3-replacement-mapping-table)
4. [Step-by-Step Migration Process](#4-step-by-step-migration-process)
5. [File-by-File Audit Checklist](#5-file-by-file-audit-checklist)
6. [Code Examples - Before & After](#6-code-examples---before--after)
7. [Validation & Testing](#7-validation--testing)
8. [**MANDATORY Iterative Verification Checklist**](#8-mandatory-iterative-verification-checklist)
9. [**NEAREST MATCH RULES - Text Styles & Font Weights**](#9--nearest-match-rules---text-styles--font-weights)
10. [Acceptable Exceptions](#10-acceptable-exceptions-do-not-fix)
11. [Completion Criteria](#11-completion-criteria)

---

## 1. Current Theme System Overview

Your project already has an excellent **Toss Design System** in `/lib/shared/themes/`:

| File | Purpose | Status |
|------|---------|--------|
| `toss_colors.dart` | Color palette (brand, semantic, grayscale) | ✅ Well-defined |
| `toss_spacing.dart` | 4px grid spacing system | ✅ Well-defined |
| `toss_text_styles.dart` | Typography hierarchy (Inter font) | ✅ Well-defined |
| `toss_animations.dart` | Durations, curves, helper widgets | ✅ Well-defined |
| `toss_border_radius.dart` | Border radius tokens | ✅ Well-defined |
| `toss_shadows.dart` | Shadow elevation system | ✅ Well-defined |
| `app_theme.dart` | Complete ThemeData configuration | ✅ Well-defined |

---

## 2. Hardcode Detection Patterns

### 2.1 Regex Patterns for Detection

Use these patterns to find hardcoded values:

```bash
# Run in terminal from project root

# 1. SPACING - Hardcoded EdgeInsets (not using TossSpacing)
grep -rn "EdgeInsets\.\(only\|symmetric\|all\)([^T]" lib/features/time_table_manage/presentation/

# 2. FONT SIZE - Hardcoded fontSize values
grep -rn "fontSize:\s*\d" lib/features/time_table_manage/presentation/

# 3. COLORS - Direct Color() or Colors. usage (not TossColors)
grep -rn "Color(0x\|Colors\." lib/features/time_table_manage/presentation/ | grep -v "TossColors"

# 4. BORDER RADIUS - Hardcoded radius values
grep -rn "BorderRadius\.circular(\d" lib/features/time_table_manage/presentation/

# 5. DURATIONS - Hardcoded animation durations
grep -rn "Duration(milliseconds:" lib/features/time_table_manage/presentation/

# 6. SIZED BOX - Hardcoded dimensions
grep -rn "SizedBox(width:\s*\d\|SizedBox(height:\s*\d" lib/features/time_table_manage/presentation/

# 7. ICON SIZE - Hardcoded icon sizes
grep -rn "size:\s*\d" lib/features/time_table_manage/presentation/ | grep -i "icon"

# 8. FONT WEIGHT - Hardcoded font weights (already in TextStyles)
grep -rn "fontWeight:\s*FontWeight\.w\d" lib/features/time_table_manage/presentation/
```

### 2.2 Detected Hardcode Summary (Current State)

| Category | Count | Priority |
|----------|-------|----------|
| EdgeInsets with raw numbers | 50+ | 🔴 HIGH |
| fontSize hardcoded | 13 | 🔴 HIGH |
| BorderRadius.circular(N) | 8 | 🟡 MEDIUM |
| Hardcoded SizedBox | 40+ | 🟡 MEDIUM |
| Duration hardcoded | 0 | ✅ CLEAN |

---

## 3. Replacement Mapping Table

### 3.1 Spacing Replacements

| Hardcoded Value | Replace With | Token |
|----------------|--------------|-------|
| `2` | `TossSpacing.space1 / 2` | 2px |
| `4` | `TossSpacing.space1` | 4px |
| `6` | `TossSpacing.space1 + 2` | 6px (rare) |
| `8` | `TossSpacing.space2` | 8px |
| `12` | `TossSpacing.space3` | 12px |
| `16` | `TossSpacing.space4` | 16px ⭐ |
| `20` | `TossSpacing.space5` | 20px |
| `24` | `TossSpacing.space6` or `paddingXL` | 24px ⭐ |
| `32` | `TossSpacing.space8` | 32px |

**Common Semantic Replacements:**

```dart
// Padding
padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)
→ padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1 / 2)

// Or for very common patterns, create semantic constants:
padding: EdgeInsets.symmetric(horizontal: TossSpacing.paddingXS, vertical: TossSpacing.marginXS / 2)
```

### 3.2 Font Size Replacements

| Hardcoded Size | Replace With | Purpose |
|----------------|--------------|---------|
| `fontSize: 10` | `TossTextStyles.small` or `.caption.copyWith(fontSize: 10)` | Tiny text |
| `fontSize: 11` | `TossTextStyles.small` | Footnotes |
| `fontSize: 12` | `TossTextStyles.caption` or `label` | Helper text |
| `fontSize: 13` | `TossTextStyles.bodySmall` | Secondary body |
| `fontSize: 14` | `TossTextStyles.body` | Default body ⭐ |
| `fontSize: 15` | `TossTextStyles.titleMedium` | Emphasized |
| `fontSize: 16` | `TossTextStyles.subtitle` | Subtitle |
| `fontSize: 17` | `TossTextStyles.titleLarge` | Nav headers |
| `fontSize: 18` | `TossTextStyles.h4` | Card titles |
| `fontSize: 20` | `TossTextStyles.h3` | Subsection |
| `fontSize: 22` | `TossTextStyles.h2` | Section header |
| `fontSize: 24` | `TossTextStyles.h2` | Headers |
| `fontSize: 28` | `TossTextStyles.h1` | Page titles |
| `fontSize: 32` | `TossTextStyles.display` | Hero |

### 3.3 Border Radius Replacements

| Hardcoded Value | Replace With | Use Case |
|-----------------|--------------|----------|
| `2` | `TossBorderRadius.none` or custom | Drag handle |
| `4` | `TossBorderRadius.xs` | Minimal |
| `6` | `TossBorderRadius.sm` | Chips |
| `8` | `TossBorderRadius.md` | Default ⭐ |
| `10` | `TossBorderRadius.buttonLarge` | Large button |
| `12` | `TossBorderRadius.lg` | Cards ⭐ |
| `16` | `TossBorderRadius.xl` | Modals |
| `20` | `TossBorderRadius.bottomSheet` | Sheets |
| `100` or `999` | `TossBorderRadius.full` | Circular |

### 3.4 Animation Replacements

| Hardcoded Duration | Replace With | Use Case |
|--------------------|--------------|----------|
| `50ms` | `TossAnimations.instant` | Immediate feedback |
| `100ms` | `TossAnimations.quick` | Micro-interactions |
| `150ms` | `TossAnimations.fast` | Button press ⭐ |
| `200ms` | `TossAnimations.normal` | Default ⭐ |
| `250ms` | `TossAnimations.medium` | Page transitions ⭐ |
| `300ms` | `TossAnimations.slow` | Complex animations |
| `400ms` | `TossAnimations.slower` | Major scenes |

---

## 4. Step-by-Step Migration Process

### Phase 1: Audit (1-2 hours)

1. **Run all grep patterns** from Section 2.1
2. **Export results** to a spreadsheet
3. **Prioritize by file** - start with most-used widgets
4. **Mark false positives** - some TossColors references are correct

### Phase 2: Prepare (30 mins)

1. **Check imports** - ensure all theme files are importable
2. **Create barrel export** if not exists:

```dart
// lib/shared/themes/index.dart
export 'toss_colors.dart';
export 'toss_spacing.dart';
export 'toss_text_styles.dart';
export 'toss_animations.dart';
export 'toss_border_radius.dart';
export 'toss_shadows.dart';
export 'app_theme.dart';
export 'toss_design_system.dart';
```

### Phase 3: Migrate File-by-File

**Order of migration:**

1. **Shared/reusable widgets first** (used by many files)
2. **Pages second** (compose widgets)
3. **Bottom sheets/dialogs last**

**For each file:**

```
□ Open file
□ Add import: import 'package:myfinance_improved/shared/themes/index.dart';
□ Find & replace spacing values
□ Find & replace fontSize values
□ Find & replace borderRadius values
□ Find & replace hardcoded colors (if any non-Toss)
□ Run flutter analyze
□ Hot reload and visually verify
□ Commit with clear message
```

### Phase 4: Validation

1. Run `flutter analyze`
2. Run visual regression test
3. Compare screenshots before/after

---

## 5. File-by-File Audit Checklist

### Widgets Directory

| File | Status | Issues Found |
|------|--------|--------------|
| `widgets/overview/attention_timeline.dart` | ⬜ TODO | `EdgeInsets(horizontal: 8)` x3 |
| `widgets/overview/snapshot_metrics_section.dart` | ⬜ TODO | `fontSize: 12, 15`, `EdgeInsets(horizontal: 16, 20, 32)` |
| `widgets/overview/staff_grid_section.dart` | ⬜ TODO | `fontSize: 13` |
| `widgets/overview/timeline/timeline_date.dart` | ⬜ TODO | `fontSize: 10` |
| `widgets/overview/timeline/dot_indicator.dart` | ⬜ TODO | `fontSize: 10`, `margin: 2` |
| `widgets/overview/timeline/navigation_button.dart` | ⬜ TODO | `EdgeInsets(vertical: 8)` |
| `widgets/stats/stats_gauge_card.dart` | ⬜ TODO | `size: 16`, `height: 116` |
| `widgets/stats/stats_metric_row.dart` | ⬜ TODO | `fontSize: 12, 22` x3 |
| `widgets/stats/stats_leaderboard.dart` | ⬜ TODO | `margin: 12, 8`, `BorderRadius: 2` |
| `widgets/stats/period_selector_bottom_sheet.dart` | ⬜ TODO | `margin: 12, 8`, `BorderRadius: 2, 10` |
| `widgets/timesheets/staff_timelog_card.dart` | ⬜ TODO | `fontSize: 10` x2, `EdgeInsets: 6, 2` |
| `widgets/schedule/schedule_shift_card.dart` | ⬜ TODO | `fontSize: 13` |
| `widgets/employee_detail/attendance_card.dart` | ⬜ TODO | `BorderRadius: 100` |
| `widgets/employee_detail/month_picker_sheet.dart` | ⬜ TODO | `BorderRadius: 2` |
| `widgets/bottom_sheets/add_shift_bottom_sheet.dart` | ⬜ TODO | `margin: 12` |

### Pages Directory

| File | Status | Issues Found |
|------|--------|--------------|
| `pages/employee_detail_page.dart` | ⬜ TODO | Multiple TossColors (correct), check spacing |
| `pages/reliability_rankings_page.dart` | ⬜ TODO | `BorderRadius: 2`, `margin: 12, 8` |
| `pages/staff_timelog_detail_page.dart` | ⬜ TODO | Check EdgeInsets |
| `pages/staff_timelog_detail/widgets/shift_info_card.dart` | ⬜ TODO | `fontSize: 13, 14` |
| `pages/staff_timelog_detail/widgets/shift_log_item.dart` | ⬜ TODO | `BorderRadius: 8` |
| `pages/staff_timelog_detail/widgets/shift_logs_section.dart` | ⬜ TODO | `EdgeInsets: 8, 2` |

---

## 6. Code Examples - Before & After

### Example 1: Badge/Tag Padding

**BEFORE:**
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(
    color: TossColors.warning.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
  ),
  child: Text(
    '$totalSchedule',
    style: TossTextStyles.labelSmall.copyWith(
      color: TossColors.warning,
      fontWeight: FontWeight.w600,
    ),
  ),
),
```

**AFTER:**
```dart
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: TossSpacing.space2,  // 8px
    vertical: TossSpacing.space1 / 2, // 2px
  ),
  decoration: BoxDecoration(
    color: TossColors.warning.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
  ),
  child: Text(
    '$totalSchedule',
    style: TossTextStyles.labelSmall.copyWith(
      color: TossColors.warning,
      fontWeight: FontWeight.w600,
    ),
  ),
),
```

### Example 2: Custom fontSize Override

**BEFORE:**
```dart
Text(
  label,
  style: TossTextStyles.caption.copyWith(
    color: textColor,
    fontWeight: FontWeight.w600,
    fontSize: 10,  // ❌ Hardcoded
  ),
),
```

**AFTER (Option A - Use existing style):**
```dart
Text(
  label,
  style: TossTextStyles.small.copyWith(
    color: textColor,
    fontWeight: FontWeight.w600,
  ),
),
```

**AFTER (Option B - Add new token if needed):**
```dart
// In toss_text_styles.dart, add:
static TextStyle get micro => GoogleFonts.inter(
  fontSize: 10,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.02,
  height: 1.6,
);

// Then use:
Text(
  label,
  style: TossTextStyles.micro.copyWith(color: textColor),
),
```

### Example 3: Gauge Widget Heights

**BEFORE:**
```dart
SizedBox(
  height: 116,  // ❌ Magic number
  child: Stack(...),
),
```

**AFTER (Create semantic constant):**
```dart
// In toss_spacing.dart or a feature-specific constants file:
static const double gaugeCardHeight = 116.0;

// Usage:
SizedBox(
  height: TossSpacing.gaugeCardHeight,
  child: Stack(...),
),
```

### Example 4: Bottom Sheet Drag Handle

**BEFORE:**
```dart
Container(
  margin: const EdgeInsets.only(top: 12, bottom: 8),
  width: 40,
  height: 4,
  decoration: BoxDecoration(
    color: TossColors.gray300,
    borderRadius: BorderRadius.circular(2),
  ),
),
```

**AFTER:**
```dart
Container(
  margin: EdgeInsets.only(
    top: TossSpacing.space3,   // 12px
    bottom: TossSpacing.space2, // 8px
  ),
  width: 40,  // Standard drag handle width
  height: 4,  // Standard drag handle height
  decoration: BoxDecoration(
    color: TossColors.gray300,
    borderRadius: BorderRadius.circular(TossBorderRadius.xs / 2), // 2px
  ),
),
```

---

## 7. Validation & Testing

### 7.1 Automated Checks

```bash
# Run flutter analyze after each file
flutter analyze lib/features/time_table_manage/

# Check for any remaining hardcoded values
grep -rn "EdgeInsets\.\(only\|symmetric\|all\)([^T]" lib/features/time_table_manage/presentation/ | wc -l
# Target: 0
```

### 7.2 Visual Regression

1. **Before migration**: Take screenshots of all screens
2. **After migration**: Compare pixel-by-pixel
3. **Expected result**: No visual changes (same values, different source)

### 7.3 Theme Consistency Check

Run this diagnostic in dev mode:

```dart
// Add to debug tools
void checkThemeConsistency() {
  final files = [/* list of migrated files */];
  for (final file in files) {
    // Check all Text widgets use TossTextStyles
    // Check all Container paddings use TossSpacing
    // Check all BorderRadius use TossBorderRadius
  }
}
```

---

## Summary: Priority Action Items

### Immediate (High Impact)

1. ✅ Add missing tokens to `toss_spacing.dart` if needed (e.g., `space1 / 2` for 2px)
2. ✅ Add `TossTextStyles.micro` for 10px text if frequently used
3. 🔄 Start with `attention_timeline.dart` - high visibility widget

### Short-term (1 week)

1. Complete all `widgets/overview/` directory
2. Complete all `widgets/stats/` directory
3. Complete all `widgets/timesheets/` directory

### Medium-term (2 weeks)

1. Complete all `pages/` directory
2. Complete all remaining widgets
3. Final validation and testing

---

## Appendix: Quick Reference Card

```
╔══════════════════════════════════════════════════════════════╗
║                  TOSS DESIGN TOKENS CHEATSHEET               ║
╠══════════════════════════════════════════════════════════════╣
║ SPACING (4px grid)                                           ║
║ ─────────────────────────────────────────────────────────────║
║ 4px  → TossSpacing.space1    │ 24px → TossSpacing.space6    ║
║ 8px  → TossSpacing.space2    │ 32px → TossSpacing.space8    ║
║ 12px → TossSpacing.space3    │ 16px → TossSpacing.paddingMD ║
║ 16px → TossSpacing.space4    │ 24px → TossSpacing.paddingXL ║
║ 20px → TossSpacing.space5    │                              ║
╠══════════════════════════════════════════════════════════════╣
║ TYPOGRAPHY                                                   ║
║ ─────────────────────────────────────────────────────────────║
║ 10px → TossTextStyles.small   │ 18px → TossTextStyles.h4    ║
║ 11px → TossTextStyles.small   │ 20px → TossTextStyles.h3    ║
║ 12px → TossTextStyles.caption │ 24px → TossTextStyles.h2    ║
║ 13px → TossTextStyles.bodySmall│ 28px → TossTextStyles.h1   ║
║ 14px → TossTextStyles.body    │ 32px → TossTextStyles.display║
╠══════════════════════════════════════════════════════════════╣
║ BORDER RADIUS                                                ║
║ ─────────────────────────────────────────────────────────────║
║ 4px  → TossBorderRadius.xs    │ 16px → TossBorderRadius.xl  ║
║ 6px  → TossBorderRadius.sm    │ 20px → TossBorderRadius.bottomSheet║
║ 8px  → TossBorderRadius.md    │ 999  → TossBorderRadius.full║
║ 12px → TossBorderRadius.lg    │                              ║
╠══════════════════════════════════════════════════════════════╣
║ ANIMATIONS                                                   ║
║ ─────────────────────────────────────────────────────────────║
║ 50ms  → TossAnimations.instant │ 250ms → TossAnimations.medium║
║ 100ms → TossAnimations.quick   │ 300ms → TossAnimations.slow ║
║ 150ms → TossAnimations.fast    │ 400ms → TossAnimations.slower║
║ 200ms → TossAnimations.normal  │                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## 8. MANDATORY Iterative Verification Checklist

### 🚨 IMPORTANT: This section MUST be executed REPEATEDLY until ALL counts = 0

### 8.1 Complete Verification Script

Run this FULL script to check ALL hardcoded values:

```bash
#!/bin/bash
# Save as: verify_hardcodes.sh
# Usage: ./verify_hardcodes.sh [feature_path]

FEATURE_PATH="${1:-lib/features/time_table_manage}"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║      HARDCODE REFACTORING VERIFICATION REPORT                ║"
echo "║      Target: $FEATURE_PATH"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Function to count and display
check_pattern() {
    local name="$1"
    local pattern="$2"
    local exclude="${3:-}"

    if [ -z "$exclude" ]; then
        count=$(grep -rE "$pattern" "$FEATURE_PATH" 2>/dev/null | wc -l | tr -d ' ')
    else
        count=$(grep -rE "$pattern" "$FEATURE_PATH" 2>/dev/null | grep -v "$exclude" | wc -l | tr -d ' ')
    fi

    if [ "$count" -eq 0 ]; then
        echo "✅ $name: $count"
    else
        echo "❌ $name: $count"
    fi
}

echo "=== CATEGORY COUNTS ==="
echo ""

# 1. FontWeight hardcoded
check_pattern "FontWeight.w* (use TossFontWeight)" "FontWeight\.w[0-9]+"

# 2. EdgeInsets with numeric values
check_pattern "EdgeInsets numeric (use TossSpacing)" "EdgeInsets\.(all|symmetric|only|fromLTRB)\(\s*[0-9]"

# 3. SizedBox with numeric values
check_pattern "SizedBox numeric (use TossSpacing)" "SizedBox\((width|height):\s*[0-9]"

# 4. withOpacity numeric
check_pattern "withOpacity numeric (use TossOpacity)" "withOpacity\(\s*0\."

# 5. fontSize hardcoded
check_pattern "fontSize numeric (use TossTextStyles)" "fontSize:\s*[0-9]"

# 6. BorderRadius.circular with number
check_pattern "BorderRadius.circular numeric (use TossBorderRadius)" "BorderRadius\.circular\(\s*[0-9]"

# 7. Duration hardcoded
check_pattern "Duration numeric (use TossAnimations)" "Duration\(milliseconds:\s*[0-9]"

# 8. Icon size hardcoded (excluding TossSpacing)
check_pattern "Icon size numeric (use TossSpacing.icon*)" "Icon\([^)]*size:\s*[0-9]" "TossSpacing"

# 9. Container width/height (excluding border width:1 and TossSpacing/TossDimensions)
echo ""
echo "=== WIDTH/HEIGHT ANALYSIS ==="
width_count=$(grep -rE "width:\s+[0-9]+[,\)]" "$FEATURE_PATH/presentation/" 2>/dev/null | grep -v "width:\s*1[,\)]" | grep -v "TossSpacing\|TossDimensions" | wc -l | tr -d ' ')
height_count=$(grep -rE "height:\s+[0-9]+[,\)]" "$FEATURE_PATH/presentation/" 2>/dev/null | grep -v "height:\s*1[,\)]" | grep -v "TossSpacing\|TossDimensions\|Divider" | wc -l | tr -d ' ')

if [ "$width_count" -eq 0 ]; then
    echo "✅ width (non-border): $width_count"
else
    echo "❌ width (non-border): $width_count"
fi

if [ "$height_count" -eq 0 ]; then
    echo "✅ height (non-divider): $height_count"
else
    echo "❌ height (non-divider): $height_count"
fi

echo ""
echo "=== SUMMARY ==="
total=$(($(grep -rE "FontWeight\.w[0-9]+" "$FEATURE_PATH" 2>/dev/null | wc -l) + \
         $(grep -rE "EdgeInsets\.(all|symmetric|only|fromLTRB)\(\s*[0-9]" "$FEATURE_PATH" 2>/dev/null | wc -l) + \
         $(grep -rE "SizedBox\((width|height):\s*[0-9]" "$FEATURE_PATH" 2>/dev/null | wc -l) + \
         $(grep -rE "withOpacity\(\s*0\." "$FEATURE_PATH" 2>/dev/null | wc -l) + \
         $(grep -rE "fontSize:\s*[0-9]" "$FEATURE_PATH" 2>/dev/null | wc -l) + \
         $(grep -rE "BorderRadius\.circular\(\s*[0-9]" "$FEATURE_PATH" 2>/dev/null | wc -l)))

if [ "$total" -eq 0 ]; then
    echo "🎉 ALL CLEAR! Total remaining issues: 0"
    echo "✅ Refactoring complete!"
else
    echo "⚠️  Total remaining issues: $total"
    echo "❌ Continue fixing until all categories = 0"
fi

echo ""
echo "Run 'flutter analyze $FEATURE_PATH' to check for errors"
```

### 8.2 Quick One-Liner Verification

Copy-paste this for quick verification:

```bash
echo "FontWeight:" && grep -rE "FontWeight\.w[0-9]+" lib/features/time_table_manage/ 2>/dev/null | wc -l && \
echo "EdgeInsets:" && grep -rE "EdgeInsets\.(all|symmetric|only|fromLTRB)\(\s*[0-9]" lib/features/time_table_manage/ 2>/dev/null | wc -l && \
echo "SizedBox:" && grep -rE "SizedBox\((width|height):\s*[0-9]" lib/features/time_table_manage/ 2>/dev/null | wc -l && \
echo "withOpacity:" && grep -rE "withOpacity\(\s*0\." lib/features/time_table_manage/ 2>/dev/null | wc -l && \
echo "fontSize:" && grep -rE "fontSize:\s*[0-9]" lib/features/time_table_manage/ 2>/dev/null | wc -l && \
echo "BorderRadius:" && grep -rE "BorderRadius\.circular\(\s*[0-9]" lib/features/time_table_manage/ 2>/dev/null | wc -l
```

### 8.3 Iterative Verification Checklist

**REPEAT THIS CHECKLIST UNTIL ALL BOXES ARE CHECKED:**

```
╔══════════════════════════════════════════════════════════════════════╗
║ ITERATION #___  DATE: ___________                                    ║
╠══════════════════════════════════════════════════════════════════════╣
║ CATEGORY                          │ COUNT │ STATUS                   ║
╠═══════════════════════════════════╪═══════╪══════════════════════════╣
║ □ FontWeight.w*                   │ _____ │ □ PASS (0) / □ FIX       ║
║ □ EdgeInsets numeric              │ _____ │ □ PASS (0) / □ FIX       ║
║ □ SizedBox numeric                │ _____ │ □ PASS (0) / □ FIX       ║
║ □ withOpacity numeric             │ _____ │ □ PASS (0) / □ FIX       ║
║ □ fontSize numeric                │ _____ │ □ PASS (0) / □ FIX       ║
║ □ BorderRadius.circular numeric   │ _____ │ □ PASS (0) / □ FIX       ║
║ □ Duration numeric                │ _____ │ □ PASS (0) / □ FIX       ║
║ □ Icon size numeric               │ _____ │ □ PASS (0) / □ FIX       ║
║ □ width (non-border)              │ _____ │ □ PASS (0) / □ FIX       ║
║ □ height (non-divider)            │ _____ │ □ PASS (0) / □ FIX       ║
╠══════════════════════════════════════════════════════════════════════╣
║ □ flutter analyze: 0 errors                                          ║
║ □ All categories = 0                                                 ║
║ □ Visual regression test passed                                      ║
╠══════════════════════════════════════════════════════════════════════╣
║ RESULT: □ COMPLETE / □ NEEDS MORE ITERATIONS                         ║
╚══════════════════════════════════════════════════════════════════════╝
```

### 8.4 Token Replacement Quick Reference

| Hardcoded Pattern | Replace With |
|-------------------|--------------|
| `FontWeight.w400` | `TossFontWeight.regular` |
| `FontWeight.w500` | `TossFontWeight.medium` |
| `FontWeight.w600` | `TossFontWeight.semibold` |
| `FontWeight.w700` | `TossFontWeight.bold` |
| `FontWeight.w800` | `TossFontWeight.extraBold` |
| `withOpacity(0.05)` | `withValues(alpha: TossOpacity.subtle)` |
| `withOpacity(0.08)` | `withValues(alpha: TossOpacity.hover)` |
| `withOpacity(0.1)` | `withValues(alpha: TossOpacity.light)` |
| `withOpacity(0.15)` | `withValues(alpha: TossOpacity.medium)` |
| `withOpacity(0.2)` | `withValues(alpha: TossOpacity.overlay)` |
| `size: 16` | `size: TossSpacing.iconSM` |
| `size: 20` | `size: TossSpacing.iconMD` |
| `size: 24` | `size: TossSpacing.iconLG` |
| `size: 32` | `size: TossSpacing.iconXL` |
| `size: 48` | `size: TossSpacing.iconXXL` |
| `height: 52` | `height: TossDimensions.headerHeight` |
| `height: 144` | `height: TossDimensions.timePickerHeight` |
| `width: 72` | `width: TossDimensions.timePickerColumnWidth` |
| `width: 40` | `width: TossDimensions.avatarLG` |

---

## 9. 📐 NEAREST MATCH RULES - Text Styles & Font Weights

### 🚨 CRITICAL: Always map to the NEAREST available token

When refactoring hardcoded `fontSize` or `fontWeight` values, you MUST replace them with the **closest matching** theme token. **DO NOT** leave any hardcoded values.

---

### 9.1 Complete TossTextStyles Reference (by font size)

| Font Size | TossTextStyles Token | Use Case |
|-----------|---------------------|----------|
| 10px | `TossTextStyles.small` (11px) | Use for tiny text - closest match |
| 11px | `TossTextStyles.small` ⭐ | Footnotes, micro labels |
| 12px | `TossTextStyles.caption` or `label` ⭐ | Helper text, timestamps |
| 13px | `TossTextStyles.bodySmall` ⭐ | Secondary content |
| 14px | `TossTextStyles.body` ⭐ | Default body text |
| 15px | `TossTextStyles.titleMedium` ⭐ | Emphasized text |
| 16px | `TossTextStyles.subtitle` ⭐ | Subtitles |
| 17px | `TossTextStyles.titleLarge` ⭐ | Navigation headers |
| 18px | `TossTextStyles.h4` ⭐ | Card titles |
| 19px | `TossTextStyles.h4` (18px) | Use h4 - closest match |
| 20px | `TossTextStyles.h3` ⭐ | Subsection headers |
| 21px-23px | `TossTextStyles.h3` (20px) or `h2` (24px) | Choose closest |
| 24px | `TossTextStyles.h2` ⭐ | Section headers |
| 25px-27px | `TossTextStyles.h2` (24px) | Use h2 - closest match |
| 28px | `TossTextStyles.h1` ⭐ | Page titles |
| 29px-31px | `TossTextStyles.h1` (28px) | Use h1 - closest match |
| 32px | `TossTextStyles.display` ⭐ | Hero text, large displays |
| 33px+ | `TossTextStyles.display` (32px) | Use display |

### 9.2 Font Size Nearest Match Decision Tree

```
fontSize value → Find nearest TossTextStyles:

≤10  → small (11px)
11   → small ⭐
12   → caption/label ⭐
13   → bodySmall ⭐
14   → body ⭐
15   → titleMedium ⭐
16   → subtitle ⭐
17   → titleLarge ⭐
18   → h4 ⭐
19   → h4 (nearest: 18px)
20   → h3 ⭐
21-22→ h3 (nearest: 20px)
23   → h2 (nearest: 24px)
24   → h2 ⭐
25-27→ h2 (nearest: 24px)
28   → h1 ⭐
29-31→ h1 (nearest: 28px)
≥32  → display ⭐
```

### 9.3 Complete TossFontWeight Reference

| Hardcoded Value | TossFontWeight Token | Weight Value |
|-----------------|---------------------|--------------|
| `FontWeight.w100` | `TossFontWeight.regular` | Use regular (w400) - lightest available |
| `FontWeight.w200` | `TossFontWeight.regular` | Use regular (w400) |
| `FontWeight.w300` | `TossFontWeight.regular` | Use regular (w400) |
| `FontWeight.w400` | `TossFontWeight.regular` ⭐ | Normal text |
| `FontWeight.w500` | `TossFontWeight.medium` ⭐ | Slightly emphasized |
| `FontWeight.w600` | `TossFontWeight.semibold` ⭐ | Labels, buttons |
| `FontWeight.w700` | `TossFontWeight.bold` ⭐ | Headings, strong emphasis |
| `FontWeight.w800` | `TossFontWeight.extraBold` ⭐ | Extra strong |
| `FontWeight.w900` | `TossFontWeight.extraBold` | Use extraBold (w800) - heaviest available |

### 9.4 Font Weight Nearest Match Decision Tree

```
FontWeight value → Find nearest TossFontWeight:

w100-w300 → regular (w400)  ← round UP to lightest available
w400      → regular ⭐
w500      → medium ⭐
w600      → semibold ⭐
w700      → bold ⭐
w800-w900 → extraBold ⭐
```

### 9.5 Semantic Font Weight Aliases (Alternative)

| Context | Use This Alias | Maps To |
|---------|---------------|---------|
| Body text with emphasis | `TossFontWeight.bodyEmphasis` | medium (w500) |
| Labels | `TossFontWeight.label` | medium (w500) |
| Buttons | `TossFontWeight.button` | semibold (w600) |
| Titles | `TossFontWeight.title` | semibold (w600) |
| Headings | `TossFontWeight.heading` | bold (w700) |
| Numbers/Values | `TossFontWeight.value` | bold (w700) |
| Display text | `TossFontWeight.display` | extraBold (w800) |

### 9.6 BEFORE → AFTER Examples

**Example 1: fontSize 10 (no exact match)**
```dart
// ❌ BEFORE
Text('tiny', style: TextStyle(fontSize: 10))

// ✅ AFTER - Use nearest: small (11px)
Text('tiny', style: TossTextStyles.small)
```

**Example 2: fontSize 19 (no exact match)**
```dart
// ❌ BEFORE
Text('title', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600))

// ✅ AFTER - Use nearest: h4 (18px) with semibold
Text('title', style: TossTextStyles.h4.copyWith(fontWeight: TossFontWeight.semibold))
```

**Example 3: fontSize 22 (between h3:20 and h2:24)**
```dart
// ❌ BEFORE
Text('section', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700))

// ✅ AFTER - Use nearest: h3 (20px) or h2 (24px) - prefer h2 for visual prominence
Text('section', style: TossTextStyles.h2.copyWith(fontWeight: TossFontWeight.bold))
```

**Example 4: fontWeight w300 (no exact match)**
```dart
// ❌ BEFORE
Text('light', style: TextStyle(fontWeight: FontWeight.w300))

// ✅ AFTER - Use nearest: regular (w400)
Text('light', style: TossTextStyles.body.copyWith(fontWeight: TossFontWeight.regular))
```

**Example 5: Combined fontSize + fontWeight replacement**
```dart
// ❌ BEFORE
Text(
  'Amount',
  style: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: TossColors.gray900,
  ),
)

// ✅ AFTER - Use titleMedium (15px) + semibold
Text(
  'Amount',
  style: TossTextStyles.titleMedium.copyWith(
    fontWeight: TossFontWeight.semibold,
    color: TossColors.gray900,
  ),
)
```

### 9.7 Common Patterns Cheatsheet

| Pattern | Replace With |
|---------|-------------|
| `TextStyle(fontSize: 10)` | `TossTextStyles.small` |
| `TextStyle(fontSize: 11)` | `TossTextStyles.small` |
| `TextStyle(fontSize: 12)` | `TossTextStyles.caption` |
| `TextStyle(fontSize: 13)` | `TossTextStyles.bodySmall` |
| `TextStyle(fontSize: 14)` | `TossTextStyles.body` |
| `TextStyle(fontSize: 15)` | `TossTextStyles.titleMedium` |
| `TextStyle(fontSize: 16)` | `TossTextStyles.subtitle` |
| `TextStyle(fontSize: 18)` | `TossTextStyles.h4` |
| `TextStyle(fontSize: 20)` | `TossTextStyles.h3` |
| `TextStyle(fontSize: 24)` | `TossTextStyles.h2` |
| `TextStyle(fontSize: 28)` | `TossTextStyles.h1` |
| `TextStyle(fontSize: 32)` | `TossTextStyles.display` |
| `.copyWith(fontWeight: FontWeight.w400)` | `.copyWith(fontWeight: TossFontWeight.regular)` |
| `.copyWith(fontWeight: FontWeight.w500)` | `.copyWith(fontWeight: TossFontWeight.medium)` |
| `.copyWith(fontWeight: FontWeight.w600)` | `.copyWith(fontWeight: TossFontWeight.semibold)` |
| `.copyWith(fontWeight: FontWeight.w700)` | `.copyWith(fontWeight: TossFontWeight.bold)` |

### 9.8 Verification for Text Styles

Run these commands to find remaining hardcoded text values:

```bash
# Find hardcoded fontSize values
grep -rn "fontSize:\s*[0-9]" lib/features/time_table_manage/

# Find hardcoded fontWeight values
grep -rn "FontWeight\.w[0-9]" lib/features/time_table_manage/

# Find TextStyle() instead of TossTextStyles
grep -rn "TextStyle(" lib/features/time_table_manage/ | grep -v "TossTextStyles"
```

**Target: ALL results should be 0**

---

### 9.9 Files to Check for New Tokens

If you encounter a dimension that doesn't have a token, add it to:

| Value Type | Add To File |
|------------|-------------|
| Spacing (4px grid) | `toss_spacing.dart` |
| Component dimensions | `toss_dimensions.dart` |
| Font weights | `toss_font_weight.dart` |
| Opacity values | `toss_opacity.dart` |
| Border radius | `toss_border_radius.dart` |
| Animation durations | `toss_animations.dart` |

---

## 10. Acceptable Exceptions (DO NOT FIX)

These values are **intentionally hardcoded** and should NOT be replaced:

| Pattern | Reason |
|---------|--------|
| `Border.all(width: 1)` | Standard 1px border |
| `BorderSide(width: 1)` | Standard 1px border |
| `Divider(height: 1)` | Standard divider height |
| `Container(height: 1)` used as divider | Visual separator |
| `thickness: 1` | Standard line thickness |

---

## 11. Completion Criteria

✅ **DONE when ALL of these are true:**

1. All 10 categories show count = 0 (excluding acceptable exceptions)
2. `flutter analyze` returns 0 errors
3. App builds successfully
4. Visual appearance unchanged (regression test)
5. All imports use barrel export (`index.dart`)

❌ **NOT DONE if ANY of these are true:**

1. Any category count > 0
2. Flutter analyze has errors
3. Build fails
4. Visual differences detected

---

**Document Version**: 3.0
**Last Updated**: January 2025
**Major Updates**:
- v2.0: Added Section 8 - Mandatory Iterative Verification
- v3.0: Added Section 9 - Nearest Match Rules for Text Styles & Font Weights
**Next Review**: After each feature refactoring
