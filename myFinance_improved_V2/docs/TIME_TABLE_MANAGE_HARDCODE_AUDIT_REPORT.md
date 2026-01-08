# 🔍 COMPLETE HARDCODE AUDIT REPORT
## Feature: time_table_manage

> **Audit Date:** 2025-01-05
> **Method:** Systematic regex scanning per HARDCODE_AUDIT_GUIDELINE.md
> **Status:** AUDIT COMPLETE - Ready for Implementation

---

## 📊 EXECUTIVE SUMMARY

| Category | Issues Found | Severity | Theme Coverage |
|----------|-------------|----------|----------------|
| **Colors** | 0 hardcoded | ✅ None | 100% using TossColors |
| **Opacity Values** | 28 instances | 🟡 Medium | Need TossOpacity tokens |
| **Spacing (EdgeInsets)** | 25 hardcoded | 🔴 High | ~70% compliance |
| **Spacing (SizedBox)** | 120+ hardcoded | 🔴 High | Need TossSpacing |
| **Typography (fontSize)** | 13 hardcoded | 🔴 High | Should use TossTextStyles |
| **Typography (fontWeight)** | 125+ inline | 🟡 Medium | Should use TossTextStyles |
| **Border Radius** | 8 hardcoded | 🟡 Medium | Should use TossBorderRadius |
| **Animations** | 0 hardcoded | ✅ None | 100% centralized |
| **Dimensions (w/h)** | 80+ hardcoded | 🔴 High | Need component tokens |
| **Icon Sizes** | 60+ hardcoded | 🟡 Medium | Should use TossSpacing.icon* |
| **Shadows** | 0 hardcoded | ✅ None | 100% centralized |

**Overall Assessment:** ~65% theme compliant. Major work needed on spacing and dimensions.

---

## 🔴 CATEGORY 1: COLORS

### Status: ✅ EXCELLENT (No hardcoded colors found)

All color usages properly reference `TossColors.*` constants.

**Note:** No instances of:
- `Color(0x...)`
- `Colors.*` (Flutter built-in)
- `Color.fromRGBO/ARGB`

---

## 🟡 CATEGORY 2: OPACITY VALUES (.withOpacity / .withValues)

### Status: ⚠️ NEEDS ATTENTION (28 instances)

These use TossColors correctly but have hardcoded opacity values:

| File | Line | Current | Suggested Token |
|------|------|---------|-----------------|
| period_selector_bottom_sheet.dart | 62 | `.withValues(alpha: 0.08)` | `TossOpacity.hover` |
| period_selector_bottom_sheet.dart | 71 | `.withValues(alpha: 0.12)` | `TossOpacity.pressed` |
| timeline_date.dart | 58 | `.withValues(alpha: 0.1)` | `TossOpacity.subtle` |
| attention_timeline.dart | 252 | `.withValues(alpha: 0.1)` | `TossOpacity.subtle` |
| attention_timeline.dart | 270 | `.withValues(alpha: 0.1)` | `TossOpacity.subtle` |
| attention_timeline.dart | 288 | `.withValues(alpha: 0.1)` | `TossOpacity.subtle` |
| add_shift_bottom_sheet.dart | 364 | `.withValues(alpha: 0.1)` | `TossOpacity.subtle` |
| add_shift_bottom_sheet.dart | 367 | `.withValues(alpha: 0.3)` | `TossOpacity.medium` |
| staff_timelog_card.dart | 436 | `.withValues(alpha: 0.15)` | `TossOpacity.light` |
| staff_timelog_card.dart | 440 | `.withValues(alpha: 0.15)` | `TossOpacity.light` |
| staff_timelog_card.dart | 496 | `.withValues(alpha: 0.15)` | `TossOpacity.light` |
| staff_timelog_card.dart | 500 | `.withValues(alpha: 0.15)` | `TossOpacity.light` |
| employee_detail_page.dart | 550 | `.withValues(alpha: 0.1)` | `TossOpacity.subtle` |
| issue_report_card.dart | 119, 302, 305, 446 | `.withValues(alpha: 0.05-0.1)` | Various |
| time_picker_bottom_sheet.dart | 189 | `.withOpacity(0.08)` | `TossOpacity.hover` |

### Recommended: Create TossOpacity Class

```dart
class TossOpacity {
  static const double subtle = 0.05;    // Very light backgrounds
  static const double hover = 0.08;     // Hover states
  static const double light = 0.10;     // Light overlays
  static const double pressed = 0.12;   // Pressed states
  static const double medium = 0.15;    // Badge backgrounds
  static const double strong = 0.30;    // Stronger overlays
}
```

---

## 🔴 CATEGORY 3: SPACING (EdgeInsets)

### Status: ⚠️ 25 HARDCODED VALUES

**Pattern:** `EdgeInsets.*(number)` where number is not a TossSpacing token

| File | Line | Current | Replace With |
|------|------|---------|--------------|
| period_selector_bottom_sheet.dart | 27 | `EdgeInsets.only(top: 12, bottom: 8)` | `TossSpacing.space3, space2` |
| stats_leaderboard.dart | 354 | `EdgeInsets.only(top: 12, bottom: 8)` | `TossSpacing.space3, space2` |
| add_shift_bottom_sheet.dart | 159 | `EdgeInsets.only(top: 12)` | `TossSpacing.space3` |
| navigation_button.dart | 31 | `EdgeInsets.symmetric(vertical: 8)` | `TossSpacing.space2` |
| snapshot_metrics_section.dart | 193 | `EdgeInsets.only(top: 12, bottom: 16)` | `TossSpacing.space3, space4` |
| snapshot_metrics_section.dart | 202 | `EdgeInsets.symmetric(horizontal: 16)` | `TossSpacing.space4` |
| snapshot_metrics_section.dart | 215 | `EdgeInsets.symmetric(horizontal: 32)` | `TossSpacing.space8` |
| snapshot_metrics_section.dart | 224 | `EdgeInsets.only(top: 8, bottom: 32)` | `TossSpacing.space2, space8` |
| snapshot_metrics_section.dart | 243 | `EdgeInsets.symmetric(horizontal: 20, vertical: 12)` | `TossSpacing.space5, space3` |
| attention_timeline.dart | 250, 268, 286 | `EdgeInsets.symmetric(horizontal: 8, vertical: 2)` | Create `badgePadding` |
| staff_timelog_card.dart | 445, 505 | `EdgeInsets.symmetric(horizontal: 6, vertical: 2)` | Create `badgePaddingXS` |
| overview_tab.dart | 393 | `EdgeInsets.symmetric(vertical: 16.0)` | `TossSpacing.space4` |
| bonus_section.dart | 84 | `EdgeInsets.symmetric(horizontal: 16, vertical: 8)` | `TossSpacing.space4, space2` |
| adjustment_section.dart | 98 | `EdgeInsets.symmetric(vertical: 8)` | `TossSpacing.space2` |
| shift_logs_section.dart | 89 | `EdgeInsets.symmetric(horizontal: 8, vertical: 2)` | Create `badgePadding` |
| reliability_rankings_page.dart | 484 | `EdgeInsets.only(top: 12, bottom: 8)` | `TossSpacing.space3, space2` |

---

## 🔴 CATEGORY 4: SPACING (SizedBox)

### Status: ⚠️ 120+ HARDCODED VALUES

**Most Common Patterns:**

| Value | Count | Replace With |
|-------|-------|--------------|
| `SizedBox(height: 2)` | 25+ | `TossSpacing.space0` or create `space0_5` |
| `SizedBox(height: 4)` | 30+ | `TossSpacing.space1` |
| `SizedBox(width: 4)` | 20+ | `TossSpacing.space1` |
| `SizedBox(height: 8)` | 25+ | `TossSpacing.space2` |
| `SizedBox(width: 8)` | 15+ | `TossSpacing.space2` |
| `SizedBox(height: 12)` | 20+ | `TossSpacing.space3` |
| `SizedBox(width: 12)` | 5+ | `TossSpacing.space3` |
| `SizedBox(height: 16)` | 15+ | `TossSpacing.space4` |
| `SizedBox(width: 40)` | 3 | `TossSpacing.space10` |

**Files with Most SizedBox Issues:**

1. `salary_breakdown_card.dart` - 12 instances
2. `issue_report_card.dart` - 18 instances
3. `employee_detail_page.dart` - 10 instances
4. `confirmed_attendance_card.dart` - 8 instances
5. `manage_memo_card.dart` - 8 instances

---

## 🔴 CATEGORY 5: TYPOGRAPHY (fontSize)

### Status: ⚠️ 13 HARDCODED VALUES

| File | Line | Current | Replace With |
|------|------|---------|--------------|
| stats_metric_row.dart | 103 | `fontSize: 12` | `TossTextStyles.caption` |
| stats_metric_row.dart | 112 | `fontSize: 22` | `TossTextStyles.h3` or create |
| stats_metric_row.dart | 121 | `fontSize: 12` | `TossTextStyles.caption` |
| shift_info_card.dart | 64 | `fontSize: 13` | `TossTextStyles.bodySmall` |
| shift_info_card.dart | 80 | `fontSize: 14` | `TossTextStyles.body` |
| timeline_date.dart | 127 | `fontSize: 10` | `TossTextStyles.labelSmall` |
| dot_indicator.dart | 55 | `fontSize: 10` | `TossTextStyles.labelSmall` |
| staff_grid_section.dart | 101 | `fontSize: 13` | `TossTextStyles.bodySmall` |
| snapshot_metrics_section.dart | 118 | `fontSize: 12` | `TossTextStyles.caption` |
| snapshot_metrics_section.dart | 140 | `fontSize: 15` | `TossTextStyles.titleMedium` |
| schedule_shift_card.dart | 321 | `fontSize: 13` | `TossTextStyles.bodySmall` |
| staff_timelog_card.dart | 458 | `fontSize: 10` | `TossTextStyles.labelSmall` |
| staff_timelog_card.dart | 515 | `fontSize: 10` | `TossTextStyles.labelSmall` |

---

## 🟡 CATEGORY 6: TYPOGRAPHY (fontWeight)

### Status: ⚠️ 125+ INLINE VALUES

All use `fontWeight: FontWeight.wXXX` instead of using TossTextStyles presets.

**Pattern Distribution:**
- `FontWeight.w400` (regular): 5 instances
- `FontWeight.w500` (medium): 45+ instances
- `FontWeight.w600` (semibold): 60+ instances
- `FontWeight.w700` (bold): 30+ instances

**Recommendation:** These should be part of TossTextStyles variants:
- `TossTextStyles.bodyMedium` (w500)
- `TossTextStyles.bodySemibold` (w600)
- `TossTextStyles.bodyBold` (w700)

---

## 🟡 CATEGORY 7: BORDER RADIUS

### Status: ⚠️ 8 HARDCODED VALUES

| File | Line | Current | Replace With |
|------|------|---------|--------------|
| period_selector_bottom_sheet.dart | 32 | `BorderRadius.circular(2)` | `TossBorderRadius.xs` or create |
| period_selector_bottom_sheet.dart | 73 | `BorderRadius.circular(10)` | `TossBorderRadius.md` |
| stats_leaderboard.dart | 359 | `BorderRadius.circular(2)` | Create `dragHandle` token |
| snapshot_metrics_section.dart | 196 | `BorderRadius.circular(2)` | Create `dragHandle` token |
| attendance_card.dart | 145 | `BorderRadius.circular(100)` | `TossBorderRadius.full` |
| month_picker_sheet.dart | 52 | `BorderRadius.circular(2)` | Create `dragHandle` token |
| reliability_rankings_page.dart | 489 | `BorderRadius.circular(2)` | Create `dragHandle` token |
| shift_log_item.dart | 134 | `BorderRadius.circular(8)` | `TossBorderRadius.md` |

**Pattern:** `BorderRadius.circular(2)` is used for drag handles - should be centralized.

---

## ✅ CATEGORY 8: ANIMATIONS

### Status: ✅ EXCELLENT (0 hardcoded values)

No instances of `Duration(milliseconds: X)` or `Duration(seconds: X)` found.
All animations properly use `TossAnimations.*` constants.

---

## 🔴 CATEGORY 9: DIMENSIONS (width/height)

### Status: ⚠️ 80+ HARDCODED VALUES

### Component-Specific Dimensions Needing Tokens:

**Drag Handle (recurring pattern):**
```
width: 40, height: 4
```
Files: period_selector_bottom_sheet, stats_leaderboard, month_picker_sheet, add_shift_bottom_sheet, reliability_rankings_page

**Vertical Dividers:**
```
width: 1, height: 40-50
```
Files: stats_metric_row, snapshot_metrics_section, metric_card

**Timeline Components:**
```
width: 32, height: 32  (date circle)
width: 8, height: 8    (dot indicator)
width: 1, height: 16   (connector)
```
Files: timeline_date, legend_item, dot_indicator

**Avatar/Icon Containers:**
```
width: 32, height: 32  (small avatar)
width: 24, height: 24  (icon container)
width: 40, height: 40  (large icon)
```
Files: activity_log_item, attendance_card, shift_log_item, problem_card

**Cards/Containers:**
```
height: 116  (stats gauge card)
height: 52   (header height)
height: 144  (time picker)
height: 44   (button height)
```
Files: stats_gauge_card, time_picker_bottom_sheet, issue_report_card

**Misc:**
```
width: 72   (time picker column)
width: 100  (adjustment label)
width: 3    (rank indicator)
width: 28   (ranking number)
```

---

## 🟡 CATEGORY 10: ICON SIZES

### Status: ⚠️ 60+ HARDCODED VALUES

**Distribution:**

| Size | Count | Should Use |
|------|-------|------------|
| `size: 10` | 2 | Create `TossSpacing.iconXXS` |
| `size: 14` | 8 | Create `TossSpacing.iconXS2` |
| `size: 16` | 10 | `TossSpacing.iconXS` |
| `size: 18` | 5 | Create `TossSpacing.iconSM2` |
| `size: 20` | 25 | `TossSpacing.iconSM` |
| `size: 24` | 15 | `TossSpacing.iconMD` |
| `size: 28` | 3 | Create or use existing |
| `size: 32` | 2 | `TossSpacing.iconLG` |
| `size: 40` | 3 | `TossSpacing.iconXL` |
| `size: 48` | 6 | Create `TossSpacing.iconXXL` |
| `size: 56` | 1 | Create or use existing |
| `size: 64` | 1 | Create `TossSpacing.icon3XL` |

---

## ✅ CATEGORY 11: SHADOWS

### Status: ✅ EXCELLENT (0 hardcoded values)

No instances of inline `BoxShadow()` or hardcoded `elevation:` found.

---

## 📋 NEW TOKENS TO CREATE

### 1. TossOpacity (New Class)

```dart
class TossOpacity {
  static const double subtle = 0.05;
  static const double hover = 0.08;
  static const double light = 0.10;
  static const double pressed = 0.12;
  static const double medium = 0.15;
  static const double strong = 0.30;
}
```

### 2. TossSpacing Additions

```dart
// Micro spacing
static const double space0_5 = 2.0;  // For very tight spacing

// Icon sizes expansion
static const double iconXXS = 10.0;
static const double iconXS2 = 14.0;
static const double iconSM2 = 18.0;
static const double iconXXL = 48.0;
static const double icon3XL = 64.0;
```

### 3. TossDimensions (New Class)

```dart
class TossDimensions {
  // Drag Handle
  static const double dragHandleWidth = 40.0;
  static const double dragHandleHeight = 4.0;

  // Vertical Dividers
  static const double dividerHeight = 1.0;
  static const double verticalDividerHeight = 40.0;
  static const double verticalDividerHeightLarge = 50.0;

  // Timeline
  static const double timelineDateCircle = 32.0;
  static const double timelineDot = 8.0;
  static const double timelineConnector = 16.0;

  // Avatar Sizes
  static const double avatarXS = 24.0;
  static const double avatarSM = 28.0;
  static const double avatarMD = 32.0;
  static const double avatarLG = 40.0;
  static const double avatarXL = 48.0;
  static const double avatarXXL = 56.0;

  // Rank Indicator
  static const double rankIndicatorWidth = 3.0;
  static const double rankNumberWidth = 28.0;

  // Component Heights
  static const double statsCardHeight = 116.0;
  static const double headerHeight = 52.0;
  static const double timePickerHeight = 144.0;
  static const double buttonHeight = 44.0;
  static const double timePickerColumnWidth = 72.0;
}
```

### 4. TossBadgeStyles (New Class or add to TossSpacing)

```dart
class TossBadgeStyles {
  static const EdgeInsets paddingXS = EdgeInsets.symmetric(
    horizontal: 6.0, vertical: 2.0,
  );
  static const EdgeInsets paddingSM = EdgeInsets.symmetric(
    horizontal: 8.0, vertical: 2.0,
  );
  static const EdgeInsets paddingMD = EdgeInsets.symmetric(
    horizontal: 8.0, vertical: 4.0,
  );
}
```

### 5. TossBorderRadius Addition

```dart
// Add to TossBorderRadius
static const BorderRadius dragHandle = BorderRadius.all(Radius.circular(2));
```

---

## 📁 FILES BY ISSUE COUNT (Priority Order)

| Priority | File | Issues | Categories |
|----------|------|--------|------------|
| 🔴 1 | issue_report_card.dart | 35+ | Spacing, Dimensions, Opacity |
| 🔴 2 | staff_timelog_card.dart | 25+ | Spacing, fontSize, Dimensions |
| 🔴 3 | employee_detail_page.dart | 25+ | Spacing, fontWeight |
| 🔴 4 | reliability_rankings_page.dart | 20+ | Spacing, Dimensions |
| 🔴 5 | salary_breakdown_card.dart | 18+ | Spacing |
| 🟡 6 | confirmed_attendance_card.dart | 15+ | Spacing, Dimensions |
| 🟡 7 | manage_memo_card.dart | 15+ | Spacing |
| 🟡 8 | stats_leaderboard.dart | 15+ | Spacing, fontWeight |
| 🟡 9 | shift_logs_section.dart | 12+ | Spacing, Dimensions |
| 🟡 10 | add_shift_bottom_sheet.dart | 12+ | Spacing, Dimensions |
| 🟡 11 | timeline_date.dart | 10+ | Spacing, Dimensions, fontSize |
| 🟡 12 | time_picker_bottom_sheet.dart | 10+ | Spacing, Dimensions |
| 🟡 13 | snapshot_metrics_section.dart | 10+ | Spacing, fontSize |
| 🟢 14 | stats_metric_row.dart | 8 | fontSize, fontWeight |
| 🟢 15 | problem_card.dart | 6 | Dimensions |
| 🟢 16 | stats_gauge_card.dart | 6 | Spacing, Dimensions |

---

## ✅ VALIDATION CHECKLIST

Before implementation, verify:

```
□ All .dart files in time_table_manage have been scanned
□ All 11 categories have been checked with regex patterns
□ Findings documented with file:line references
□ Each finding has suggested replacement token
□ New token requirements are fully listed
□ Team has reviewed this report
□ flutter analyze passes with no errors
```

---

## 🎯 IMPLEMENTATION PRIORITY

### Phase 1: Create New Theme Tokens
1. Create `TossOpacity` class
2. Create `TossDimensions` class
3. Create `TossBadgeStyles` class
4. Add missing values to `TossSpacing`
5. Add `dragHandle` to `TossBorderRadius`

### Phase 2: High Priority Files (🔴)
1. issue_report_card.dart
2. staff_timelog_card.dart
3. employee_detail_page.dart
4. reliability_rankings_page.dart
5. salary_breakdown_card.dart

### Phase 3: Medium Priority Files (🟡)
- Remaining 11 files listed above

### Phase 4: Validation
- Run `flutter analyze`
- Run all tests
- Visual regression check

---

*Report Generated: 2025-01-05*
*Total Hardcoded Issues: ~350+*
*Estimated Fix Time: 4-6 hours*
