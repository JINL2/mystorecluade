# 📋 Hardcode Audit Tracking: time_table_manage

> **Feature:** time_table_manage
> **Audit Date:** [Fill in]
> **Auditor:** [Fill in]

---

## 📊 Pre-Audit Summary

Based on initial exploration, here are the files to audit:

### Files List (Presentation Layer)

| # | File | Path | Status |
|---|------|------|--------|
| 1 | staff_timelog_card.dart | presentation/widgets/ | ⬜ Not Started |
| 2 | stats_gauge_card.dart | presentation/widgets/ | ⬜ Not Started |
| 3 | stats_metric_row.dart | presentation/widgets/ | ⬜ Not Started |
| 4 | stats_leaderboard.dart | presentation/widgets/ | ⬜ Not Started |
| 5 | attendance_card.dart | presentation/employee_detail/ | ⬜ Not Started |
| 6 | problem_card.dart | presentation/timesheets/ | ⬜ Not Started |
| 7 | add_shift_bottom_sheet.dart | presentation/bottom_sheets/ | ⬜ Not Started |
| 8 | period_selector_bottom_sheet.dart | presentation/bottom_sheets/ | ⬜ Not Started |
| 9 | time_picker_bottom_sheet.dart | presentation/bottom_sheets/ | ⬜ Not Started |
| 10 | timeline_date.dart | presentation/widgets/ | ⬜ Not Started |
| 11 | dot_indicator.dart | presentation/widgets/ | ⬜ Not Started |
| 12 | shift_info_card.dart | presentation/overview/ | ⬜ Not Started |
| 13 | snapshot_metrics_section.dart | presentation/overview/ | ⬜ Not Started |
| 14 | staff_grid_section.dart | presentation/overview/ | ⬜ Not Started |

**Status Legend:**
- ⬜ Not Started
- 🔄 In Progress
- ✅ Completed
- ⚠️ Needs Review

---

## 🔍 Detailed Findings

### File 1: staff_timelog_card.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Spacing | `height: 2` | `TossSpacing.space0` or create microSpacing | Medium | Divider height |
| | Spacing | `height: 4` | `TossSpacing.space1` | High | |
| | Spacing | `horizontal: 6, vertical: 2` | Create `badgePadding` | High | Badge pattern |
| | Font | `fontSize: 10` | `TossTextStyles.labelSmall` | High | Badge text |

---

### File 2: stats_gauge_card.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Dimension | `height: 116` | Create `statsCardHeight` | Medium | Card container |
| | Spacing | `width: 2` | `TossSpacing.space0` | Low | Minor spacing |
| | Spacing | `height: 16` | `TossSpacing.space4` | High | |

---

### File 3: stats_metric_row.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Dimension | `width: 1, height: 40` | Create `dividerVertical` | Medium | Vertical divider |
| | Font | `fontSize: 12` | `TossTextStyles.caption` | High | |
| | Font | `fontSize: 22` | `TossTextStyles.h3` or create | High | Large metric |
| | Font | `fontSize: 12` | `TossTextStyles.caption` | High | |

---

### File 4: stats_leaderboard.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Spacing | `height: 1` | Create `dividerHeight` | Low | |
| | Dimension | `width: 3` | Create `rankIndicatorWidth` | Low | Rank indicator |
| | Dimension | `width: 24` | `TossSpacing.space6` | Medium | |
| | Dimension | `width: 40` | `TossSpacing.space10` | Medium | |

---

### File 5: attendance_card.dart (employee_detail)

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Dimension | `32 x 32` | Create `avatarSizeMD` | High | Avatar size |

---

### File 6: problem_card.dart (timesheets)

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Dimension | `40 x 40` | `TossSpacing.space10` x 2 | High | Icon container |

---

### File 7: add_shift_bottom_sheet.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Dimension | `40 x 4` | ✅ Use `TossDesignSystem.dragHandleSize` | High | Already exists! |

---

### File 8: period_selector_bottom_sheet.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Dimension | `40 x 4` | ✅ Use `TossDesignSystem.dragHandleSize` | High | Already exists! |
| | Dimension | `68` | Create `periodButtonWidth` | Medium | Period button |

---

### File 9: time_picker_bottom_sheet.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Dimension | `height: 52` | `TossSpacing.inputHeightLG` | Medium | |
| | Dimension | `height: 144` | Create `timePickerHeight` | Medium | Picker container |
| | Dimension | `height: 32` | `TossSpacing.buttonHeightSM` | Medium | |

---

### File 10: timeline_date.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Dimension | `32 x 32` | Create `timelineDateSize` | High | Date circle |
| | Spacing | `16` | `TossSpacing.space4` | High | |
| | Spacing | `32` | `TossSpacing.space8` | High | |
| | Spacing | `8` | `TossSpacing.space2` | High | |
| | Spacing | `4` | `TossSpacing.space1` | High | |
| | Font | `fontSize: 10` | `TossTextStyles.labelSmall` | High | Small text |

---

### File 11: dot_indicator.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Dimension | `8 x 8` | Create `dotIndicatorSize` | Medium | Status dot |

---

### File 12: shift_info_card.dart (overview)

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Spacing | `height: 1` | Create `dividerHeight` | Low | |
| | Spacing | `4` | `TossSpacing.space1` | High | |
| | Spacing | `2` | Create `space0_5` or use 0 | Medium | Micro spacing |

---

### File 13: snapshot_metrics_section.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Font | `fontSize: 12` | `TossTextStyles.caption` | High | |
| | Font | `fontSize: 15` | `TossTextStyles.titleMedium` | High | |

---

### File 14: staff_grid_section.dart

| Line | Category | Current Value | Suggested Token | Priority | Notes |
|------|----------|---------------|-----------------|----------|-------|
| | Font | `fontSize: 13` | `TossTextStyles.bodySmall` | High | |

---

## 📈 Summary Statistics

### By Category

| Category | Total Found | High Priority | Medium | Low |
|----------|-------------|---------------|--------|-----|
| Colors | 0 | 0 | 0 | 0 |
| Spacing | ~25 | 15 | 8 | 2 |
| Typography | ~12 | 10 | 2 | 0 |
| BorderRadius | ~3 | 1 | 2 | 0 |
| Animations | 0 | 0 | 0 | 0 |
| Dimensions | ~18 | 8 | 8 | 2 |
| **Total** | **~58** | **34** | **20** | **4** |

### By Resolution Type

| Resolution | Count | Notes |
|------------|-------|-------|
| Direct replacement (token exists) | ~35 | Can use existing TossSpacing, TossTextStyles |
| New token needed | ~15 | New component-specific tokens |
| Exception (keep hardcoded) | ~3 | Document reason |
| Already correct | ~5 | Using theme correctly |

---

## 🆕 New Tokens to Create

Based on audit findings, these tokens should be added to the theme system:

### TossSpacing Additions

```dart
// Micro spacing (for tight UI)
static const double space0_5 = 2.0;  // 2px for very tight spacing

// Component-specific
static const double dividerHeight = 1.0;
static const double dividerVerticalHeight = 40.0;
static const double rankIndicatorWidth = 3.0;
```

### New TossDimensions Class (Suggested)

```dart
class TossDimensions {
  // Avatar sizes
  static const double avatarXS = 24.0;
  static const double avatarSM = 28.0;
  static const double avatarMD = 32.0;
  static const double avatarLG = 40.0;
  static const double avatarXL = 48.0;

  // Dot indicators
  static const double dotSM = 6.0;
  static const double dotMD = 8.0;
  static const double dotLG = 12.0;

  // Timeline specific
  static const double timelineDateCircle = 32.0;
  static const double timelineConnectorWidth = 2.0;

  // Stats specific
  static const double statsCardHeight = 116.0;
  static const double gaugeHeight = 108.0;

  // Picker specific
  static const double timePickerHeight = 144.0;
  static const double periodButtonWidth = 68.0;
}
```

### TossBadgeStyles (New File Suggested)

```dart
class TossBadgeStyles {
  static const EdgeInsets paddingXS = EdgeInsets.symmetric(
    horizontal: 6.0,
    vertical: 2.0,
  );
  static const EdgeInsets paddingSM = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 4.0,
  );
}
```

---

## ✅ Completion Checklist

### Pre-Fix Validation

- [ ] All 14+ files have been audited
- [ ] All findings documented with line numbers
- [ ] Each finding has suggested replacement
- [ ] New tokens list is finalized
- [ ] Team has reviewed findings

### Sign-off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Auditor | | | |
| Reviewer | | | |
| Tech Lead | | | |

---

## 📝 Notes & Observations

### Positive Findings
- Colors are well-managed - almost 100% using TossColors
- Animations are perfect - 100% using TossAnimations
- Border radius mostly correct

### Areas of Concern
- Micro-spacing (2-4px) not well covered by current tokens
- Component-specific dimensions scattered
- Font sizes sometimes inline instead of using TossTextStyles

### Recommendations
1. Create `TossDimensions` class for component sizes
2. Add micro-spacing tokens (space0_5 = 2px)
3. Create badge/tag specific styles
4. Consider timeline-specific tokens

---

*Document Version: 1.0*
*Last Updated: [date]*
