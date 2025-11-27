# Attendance Page UI Redesign Plan

**Created**: 2025-11-20
**Status**: Planning Phase
**Scope**: Presentation Layer Only (Domain & Data layers untouched)

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Design Analysis](#design-analysis)
3. [Component Architecture](#component-architecture)
4. [Widget Tree - Week View](#widget-tree---week-view)
5. [Widget Tree - Month View](#widget-tree---month-view)
6. [Implementation Stages](#implementation-stages)
7. [Component Specifications](#component-specifications)
8. [Risk Assessment](#risk-assessment)
9. [Technical Notes](#technical-notes)

---

## Overview

### Current State
- **2 Tabs**: "Check In/Out", "Register"
- **Pill-style tab bar**: Custom implementation
- **Complex logic**: 8,511 lines across 3 main files
- **Monthly caching**: Performance-optimized data fetching

### Target State
- **3 Tabs**: "My Schedule", "Requests", "Stats"
- **Underline tab bar**: Using existing TossTabBarView1
- **Week/Month toggle**: Segmented control (adapted from ToggleButton)
- **Simplified UI**: Featured today's shift + list view
- **Month calendar**: Full month grid with date states

### Key Constraints
- ✅ **Presentation layer only** - No domain/data changes
- ✅ **Minimize logic changes** - Aim for 20-30% wrapper pattern
- ✅ **Reuse shared components** - Maximize existing Toss design system
- ✅ **Maintain performance** - Keep monthly caching strategy

---

## Design Analysis

### Week View Features
```
┌─────────────────────────────────────┐
│  My Schedule │ Requests │ Stats     │ ← TossTabBarView1 (3 tabs)
├─────────────────────────────────────┤
│  [Week] [Month]                     │ ← TossSegmentedControl
├─────────────────────────────────────┤
│  ┌───────────────────────────────┐  │
│  │ TODAY'S SHIFT                 │  │ ← TossTodayShiftCard
│  │ Morning - 9:00 AM - 5:00 PM   │  │   (Featured card with CTA)
│  │ [Check In] button             │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│  < Week 45, 2024 >                  │ ← TossWeekNavigation
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐    │
│  │ Mon 11 │ Morning 9AM-5PM    │    │ ← TossWeekShiftCard
│  └─────────────────────────────┘    │   (Compact 2-row card)
│  ┌─────────────────────────────┐    │
│  │ Tue 12 │ Evening 2PM-10PM   │    │
│  └─────────────────────────────┘    │
│  ...                                │
└─────────────────────────────────────┘
```

### Month View Features
```
┌─────────────────────────────────────┐
│  My Schedule │ Requests │ Stats     │ ← TossTabBarView1 (3 tabs)
├─────────────────────────────────────┤
│  [Week] [Month]                     │ ← TossSegmentedControl
├─────────────────────────────────────┤
│  ┌───────────────────────────────┐  │
│  │ TODAY'S SHIFT                 │  │ ← TossTodayShiftCard
│  │ Morning - 9:00 AM - 5:00 PM   │  │   (Same as Week view)
│  │ [Check In] button             │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│  < November 2024 >                  │ ← TossMonthNavigation
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐    │
│  │ Mon Tue Wed Thu Fri Sat Sun │    │ ← TossMonthCalendar
│  │  1   2   3   4   5   6   7  │    │   (GridView 7×5-6)
│  │  ●   ○   ●   ○   ●   ○   ○  │    │   (● = has shift)
│  │  8   9  [10] 11  12  13  14 │    │   ([10] = selected)
│  │  ●   ●   ●   ○   ●   ○   ○  │    │
│  │ ...                         │    │
│  └─────────────────────────────┘    │
├─────────────────────────────────────┤
│  Shifts on Nov 10                   │
│  ┌─────────────────────────────┐    │
│  │ Mon 11 │ Morning 9AM-5PM    │    │ ← TossWeekShiftCard
│  └─────────────────────────────┘    │   (Filtered by selected date)
└─────────────────────────────────────┘
```

---

## Component Architecture

### Legend
- ✅ **Existing** - Use as-is from shared/widgets/toss
- 🔵 **Adapt** - Modify existing component for new use case
- 🆕 **New** - Create new component (custom)
- 📦 **Flutter** - Built-in Flutter widgets

### Component Inventory

| Component | Type | Lines | Hours | Priority |
|-----------|------|-------|-------|----------|
| TossTabBarView1 | ✅ Existing | 579 | 0 | ✅ Ready |
| TossSegmentedControl | 🔵 Adapt | ~120 | 1.5-2 | 🔴 Critical |
| TossTodayShiftCard | 🆕 New | ~150 | 2-3 | 🔴 Critical |
| TossWeekShiftCard | 🆕 New | ~100 | 1-1.5 | 🔴 Critical |
| TossWeekNavigation | 🆕 New | ~80 | 1 | 🟡 High |
| TossMonthNavigation | 🆕 New | ~100 | 1 | 🟡 High |
| TossMonthCalendar | 🆕 New | ~300 | 4-5 | 🔴 Critical |
| MyScheduleTab | 🆕 New | ~400 | 4-5 | 🔴 Critical |
| StatsTab | 🆕 New | ~50 | 0.5 | 🟢 Low |

**Total New Development**: ~1,300 lines, 16-19 hours

---

## Widget Tree - Week View

```
AttendanceMainPage (UPDATED - Use TossTabBarView1)
└── TossTabBarView1 ✅
    ├── tabs: ["My Schedule", "Requests", "Stats"]
    └── children:
        ├── [0] MyScheduleTab 🆕
        │   └── Column 📦
        │       ├── Padding 📦
        │       │   └── TossSegmentedControl 🔵
        │       │       └── options: ["Week", "Month"]
        │       │       └── onChanged: (value) → setState(viewMode)
        │       │
        │       └── Expanded 📦
        │           └── AnimatedSwitcher 📦
        │               └── child: viewMode == "Week"
        │                   ? _buildWeekView() 🆕
        │                   : _buildMonthView() 🆕
        │
        ├── [1] ShiftRegisterTab ✅ (Renamed to "Requests")
        │
        └── [2] StatsTab 🆕 (Placeholder)
```

### Week View Detail (_buildWeekView)

```
Column 📦
├── TossTodayShiftCard 🆕
│   ├── shiftType: "Morning"
│   ├── timeRange: "9:00 AM - 5:00 PM"
│   ├── status: "upcoming" | "in_progress" | "completed"
│   └── onCheckIn: () → _handleCheckIn()
│
├── SizedBox 📦 (height: 16)
│
├── TossWeekNavigation 🆕
│   ├── currentWeekNumber: 45
│   ├── year: 2024
│   ├── onPrevWeek: () → _navigateWeek(-1)
│   ├── onCurrentWeek: () → _navigateWeek(0)
│   └── onNextWeek: () → _navigateWeek(1)
│
├── SizedBox 📦 (height: 16)
│
└── Expanded 📦
    └── ListView.separated 📦
        └── itemBuilder: (context, index)
            └── TossWeekShiftCard 🆕
                ├── date: "Mon 11"
                ├── shiftType: "Morning"
                ├── timeRange: "9:00 AM - 5:00 PM"
                ├── status: "upcoming" | "completed" | "late"
                └── onTap: () → _showShiftDetails()
```

---

## Widget Tree - Month View

### Month View Detail (_buildMonthView)

```
Column 📦
├── TossTodayShiftCard 🆕
│   └── (Same as Week view)
│
├── SizedBox 📦 (height: 16)
│
├── TossMonthNavigation 🆕
│   ├── currentMonth: "November"
│   ├── year: 2024
│   ├── onPrevMonth: () → _navigateMonth(-1)
│   ├── onCurrentMonth: () → _navigateMonth(0)
│   └── onNextMonth: () → _navigateMonth(1)
│
├── SizedBox 📦 (height: 16)
│
├── TossMonthCalendar 🆕
│   ├── selectedDate: DateTime(2024, 11, 10)
│   ├── currentMonth: DateTime(2024, 11, 1)
│   ├── shiftsInMonth: Map<DateTime, bool>
│   └── onDateSelected: (date) → setState(selectedDate)
│   │
│   └── Internal Structure:
│       └── Container 📦 (border, padding)
│           └── Column 📦
│               ├── GridView 📦 (Header: Mon-Sun)
│               │   └── 7 cells × Text("Mon", "Tue", ...)
│               │
│               └── GridView.builder 📦 (Calendar grid)
│                   └── itemCount: 35-42 (7×5-6 rows)
│                   └── itemBuilder: (context, index)
│                       └── _CalendarDayCell 🆕
│                           ├── date: DateTime
│                           ├── isToday: bool
│                           ├── isPast: bool
│                           ├── isSelected: bool
│                           ├── hasShift: bool
│                           └── onTap: () → onDateSelected(date)
│                           │
│                           └── Column 📦
│                               ├── _DateCircle 🆕 (24×24)
│                               │   ├── date: int (1-31)
│                               │   ├── backgroundColor: Color
│                               │   ├── border: BoxBorder?
│                               │   └── textColor: Color
│                               │   │
│                               │   └── States:
│                               │       ├── Past: border + gray400
│                               │       ├── Today: transparent + blue500
│                               │       ├── Upcoming: blue500 border
│                               │       ├── Selected: blue500 bg + white
│                               │       └── Default: transparent
│                               │
│                               └── _DateDot 🆕 (4×4)
│                                   ├── hasShift: bool
│                                   └── visible: !isPast && !isToday
│                                   │
│                                   └── States:
│                                       ├── Has shift: blue500 bg
│                                       ├── No shift: gray300 bg
│                                       └── Hidden: if past/today
│
├── SizedBox 📦 (height: 16)
│
├── Text 📦 ("Shifts on Nov 10")
│   └── style: TossTextStyles.body1Medium
│
├── SizedBox 📦 (height: 8)
│
└── Expanded 📦
    └── ListView.separated 📦
        └── itemBuilder: (context, index)
            └── TossWeekShiftCard 🆕
                └── (Filtered by selectedDate)
```

---

## Implementation Stages

### Stage 1: Shared Components (Phase 1)
**Goal**: Create reusable components used in both Week and Month views

- [ ] **1.1 TossSegmentedControl** (🔵 Adapt from ToggleButton)
  - [ ] Create file: `lib/shared/widgets/toss/toss_segmented_control.dart`
  - [ ] Implement 2-option segmented control (Week/Month)
  - [ ] Style: Underline indicator (not pill style)
  - [ ] Props: `options: List<String>`, `selectedIndex: int`, `onChanged: Function(int)`
  - [ ] Colors: TossColors.blue500 (selected), gray400 (unselected)
  - [ ] Animation: Smooth 200ms transition
  - [ ] **Lines**: ~120 | **Hours**: 1.5-2

- [ ] **1.2 TossTodayShiftCard** (🆕 New)
  - [ ] Create file: `lib/shared/widgets/toss/toss_today_shift_card.dart`
  - [ ] Featured card with rounded border (TossBorderRadius.lg = 12px)
  - [ ] Props: `shiftType: String`, `timeRange: String`, `status: ShiftStatus`, `onCheckIn: VoidCallback?`
  - [ ] Status states: upcoming (blue), in_progress (green), completed (gray)
  - [ ] Action button: "Check In" / "Check Out" / "View Details"
  - [ ] Layout: 2 rows (shift info + action button)
  - [ ] **Lines**: ~150 | **Hours**: 2-3

- [ ] **1.3 TossWeekShiftCard** (🆕 New)
  - [ ] Create file: `lib/shared/widgets/toss/toss_week_shift_card.dart`
  - [ ] Compact card for list view
  - [ ] Props: `date: String`, `shiftType: String`, `timeRange: String`, `status: ShiftStatus`, `onTap: VoidCallback?`
  - [ ] Layout: 2 rows (date | shift type + time)
  - [ ] Border: TossBorderRadius.md = 8px
  - [ ] Status indicator: Left border color (blue/green/red)
  - [ ] **Lines**: ~100 | **Hours**: 1-1.5

**Stage 1 Completion Criteria**:
- [ ] All 3 components render correctly in isolation
- [ ] Components added to `design_library_page.dart` for testing
- [ ] Design system colors/spacing/typography applied
- [ ] No errors or warnings

---

### Stage 2: Shared Components (Phase 2)
**Goal**: Create navigation components

- [ ] **2.1 TossWeekNavigation** (🆕 New)
  - [ ] Create file: `lib/shared/widgets/toss/toss_week_navigation.dart`
  - [ ] Props: `currentWeekNumber: int`, `year: int`, `onPrevWeek`, `onCurrentWeek`, `onNextWeek`
  - [ ] Layout: `< Week 45, 2024 >`
  - [ ] Buttons: Icon buttons (chevron_left, refresh, chevron_right)
  - [ ] Center text: "Week {number}, {year}"
  - [ ] **Lines**: ~80 | **Hours**: 1

- [ ] **2.2 TossMonthNavigation** (🆕 New)
  - [ ] Create file: `lib/shared/widgets/toss/toss_month_navigation.dart`
  - [ ] Props: `currentMonth: String`, `year: int`, `onPrevMonth`, `onCurrentMonth`, `onNextMonth`
  - [ ] Layout: `< November 2024 >`
  - [ ] Buttons: Icon buttons (chevron_left, refresh, chevron_right)
  - [ ] Center text: "{Month} {year}"
  - [ ] **Lines**: ~100 | **Hours**: 1

**Stage 2 Completion Criteria**:
- [ ] Navigation components work with state management
- [ ] Date calculations are correct (week/month boundaries)
- [ ] Components added to design library
- [ ] No errors or warnings

---

### Stage 3: Month Calendar Component
**Goal**: Create complex calendar grid component

- [ ] **3.1 TossMonthCalendar** (🆕 New - Main component)
  - [ ] Create file: `lib/shared/widgets/toss/toss_month_calendar.dart`
  - [ ] Props:
    - [ ] `selectedDate: DateTime`
    - [ ] `currentMonth: DateTime`
    - [ ] `shiftsInMonth: Map<DateTime, bool>`
    - [ ] `onDateSelected: Function(DateTime)`
  - [ ] Container: Border (gray200), padding (16px), rounded (12px)
  - [ ] **Lines**: ~300 | **Hours**: 4-5

- [ ] **3.2 Calendar Header Row**
  - [ ] GridView: 7 columns (Mon-Sun)
  - [ ] Text style: TossTextStyles.label2 (gray500)
  - [ ] Height: 32px

- [ ] **3.3 Calendar Grid**
  - [ ] GridView.builder: 7 columns × 5-6 rows (35-42 cells)
  - [ ] Calculate first day of month offset
  - [ ] Calculate total days in month
  - [ ] Handle previous/next month overflow dates

- [ ] **3.4 _CalendarDayCell** (Internal widget)
  - [ ] Props: `date`, `isToday`, `isPast`, `isSelected`, `hasShift`, `onTap`
  - [ ] Column layout: _DateCircle + _DateDot
  - [ ] GestureDetector for tap handling
  - [ ] **One component with multiple visual variants**

- [ ] **3.5 _DateCircle** (Internal widget)
  - [ ] Size: 24×24
  - [ ] Props: `date: int`, `backgroundColor`, `border`, `textColor`
  - [ ] States:
    - [ ] **Past**: border (gray300) + text (gray400)
    - [ ] **Today**: transparent + text (blue500)
    - [ ] **Upcoming**: border (blue500) + text (gray900)
    - [ ] **Selected**: bg (blue500) + text (white)
  - [ ] Border radius: 12px (circle)

- [ ] **3.6 _DateDot** (Internal widget)
  - [ ] Size: 4×4
  - [ ] Props: `hasShift: bool`
  - [ ] Visibility: Hidden if `isPast` or `isToday`
  - [ ] States:
    - [ ] **Has shift**: bg (blue500)
    - [ ] **No shift**: bg (gray300)
  - [ ] Border radius: 2px (circle)
  - [ ] Positioned: 4px below _DateCircle

**Stage 3 Completion Criteria**:
- [ ] Calendar renders correct number of days for any month
- [ ] Date selection works correctly
- [ ] Visual states (past/today/upcoming/selected) render correctly
- [ ] Shift indicators (dots) show/hide correctly
- [ ] Tap handling works on all dates
- [ ] Component added to design library
- [ ] No errors or warnings

---

### Stage 4: MyScheduleTab Implementation
**Goal**: Create main tab with Week/Month view switching

- [ ] **4.1 MyScheduleTab** (🆕 New)
  - [ ] Create file: `lib/features/attendance/presentation/pages/my_schedule_tab.dart`
  - [ ] StatefulWidget with view mode state (Week/Month)
  - [ ] Selected date state for Month view
  - [ ] Current week/month navigation state
  - [ ] **Lines**: ~400 | **Hours**: 4-5

- [ ] **4.2 State Management**
  - [ ] `ViewMode` enum: week, month
  - [ ] `selectedDate: DateTime` (for Month view)
  - [ ] `currentWeekOffset: int` (for Week navigation)
  - [ ] `currentMonthOffset: int` (for Month navigation)

- [ ] **4.3 Data Fetching Integration**
  - [ ] Connect to existing `attendanceCheckInUseCaseProvider`
  - [ ] Use existing monthly caching strategy
  - [ ] Filter shifts by week (7-day centered view)
  - [ ] Filter shifts by selected date (Month view)
  - [ ] Get today's shift for TossTodayShiftCard

- [ ] **4.4 _buildWeekView Method**
  - [ ] Column layout with components
  - [ ] TossTodayShiftCard (with real data)
  - [ ] TossWeekNavigation (with navigation handlers)
  - [ ] ListView.separated with TossWeekShiftCard items
  - [ ] Calculate 7-day range centered on current week

- [ ] **4.5 _buildMonthView Method**
  - [ ] Column layout with components
  - [ ] TossTodayShiftCard (same as Week view)
  - [ ] TossMonthNavigation (with navigation handlers)
  - [ ] TossMonthCalendar (with shift data map)
  - [ ] "Shifts on {date}" header
  - [ ] ListView.separated with filtered TossWeekShiftCard items

- [ ] **4.6 Navigation Handlers**
  - [ ] `_navigateWeek(int offset)` - Update currentWeekOffset
  - [ ] `_navigateMonth(int offset)` - Update currentMonthOffset
  - [ ] `_handleDateSelected(DateTime date)` - Update selectedDate
  - [ ] Trigger data refetch if needed (monthly caching)

- [ ] **4.7 AnimatedSwitcher Integration**
  - [ ] Wrap Week/Month views
  - [ ] Duration: 300ms
  - [ ] Transition: FadeTransition + SlideTransition

**Stage 4 Completion Criteria**:
- [ ] Tab renders without errors
- [ ] Week/Month toggle works smoothly
- [ ] Real shift data displays correctly
- [ ] Navigation works in both views
- [ ] Date selection in Month view updates shift list
- [ ] Today's shift card shows correct data
- [ ] Loading states handled gracefully
- [ ] Error states handled gracefully

---

### Stage 5: AttendanceMainPage Update
**Goal**: Update main page to use new tab structure

- [ ] **5.1 Update AttendanceMainPage**
  - [ ] File: `lib/features/attendance/presentation/pages/attendance_main_page.dart`
  - [ ] Replace custom TabBar with TossTabBarView1
  - [ ] Change from 2 to 3 tabs
  - [ ] Simplify from 136 lines to ~35 lines

- [ ] **5.2 Tab Configuration**
  - [ ] tabs: `["My Schedule", "Requests", "Stats"]`
  - [ ] children: `[MyScheduleTab(), ShiftRegisterTab(), StatsTab()]`
  - [ ] Remove TabController (TossTabBarView1 handles it internally)
  - [ ] Remove SingleTickerProviderStateMixin

- [ ] **5.3 StatsTab Placeholder**
  - [ ] Create file: `lib/features/attendance/presentation/pages/stats_tab.dart`
  - [ ] Simple Center widget with "Coming Soon" text
  - [ ] **Lines**: ~50 | **Hours**: 0.5

**Stage 5 Completion Criteria**:
- [ ] All 3 tabs render without errors
- [ ] Tab switching works smoothly
- [ ] MyScheduleTab functions correctly
- [ ] ShiftRegisterTab (Requests) still works as before
- [ ] StatsTab placeholder renders
- [ ] No visual regressions
- [ ] No errors or warnings

---

### Stage 6: Testing & Refinement
**Goal**: Ensure quality and fix edge cases

- [ ] **6.1 Visual Testing**
  - [ ] Test on different screen sizes (small, medium, large)
  - [ ] Test on iOS and Android
  - [ ] Verify all colors match design system
  - [ ] Verify all spacing/padding matches design system
  - [ ] Verify all typography matches design system

- [ ] **6.2 Functional Testing**
  - [ ] Test Week navigation (prev/current/next)
  - [ ] Test Month navigation (prev/current/next)
  - [ ] Test date selection in Month view
  - [ ] Test Week/Month toggle switching
  - [ ] Test shift card tap handlers
  - [ ] Test check-in/check-out flows
  - [ ] Test empty states (no shifts)
  - [ ] Test loading states
  - [ ] Test error states

- [ ] **6.3 Edge Cases**
  - [ ] Test month with 28 days (February)
  - [ ] Test month with 31 days
  - [ ] Test first day of month = Sunday
  - [ ] Test first day of month = Monday
  - [ ] Test leap year February
  - [ ] Test week spanning two months
  - [ ] Test today's shift missing
  - [ ] Test past shifts display
  - [ ] Test future shifts display

- [ ] **6.4 Performance Testing**
  - [ ] Verify monthly caching still works
  - [ ] Measure initial load time
  - [ ] Measure navigation speed (week/month)
  - [ ] Check for unnecessary rebuilds
  - [ ] Verify smooth scrolling (60fps)

- [ ] **6.5 Cleanup**
  - [ ] Remove unused imports
  - [ ] Remove commented code
  - [ ] Add documentation comments
  - [ ] Format code (dart format)
  - [ ] Run analyzer (dart analyze)

**Stage 6 Completion Criteria**:
- [ ] All visual tests pass
- [ ] All functional tests pass
- [ ] All edge cases handled
- [ ] Performance meets targets
- [ ] Code quality standards met
- [ ] No errors or warnings

---

## Component Specifications

### 1. TossSegmentedControl

**File**: `lib/shared/widgets/toss/toss_segmented_control.dart`

**Purpose**: 2-option segmented control for Week/Month toggle

**Properties**:
```dart
class TossSegmentedControl extends StatelessWidget {
  final List<String> options;      // ["Week", "Month"]
  final int selectedIndex;          // 0 or 1
  final ValueChanged<int> onChanged; // Callback
  final EdgeInsets? padding;        // Optional padding
}
```

**Design Specs**:
- **Layout**: Row with 2 equal-width sections
- **Height**: 40px
- **Border**: 1px solid TossColors.gray200, radius 8px
- **Selected**:
  - Background: TossColors.blue500
  - Text: TossColors.white
  - Font: TossTextStyles.body2Bold
- **Unselected**:
  - Background: TossColors.transparent
  - Text: TossColors.gray600
  - Font: TossTextStyles.body2Regular
- **Animation**: 200ms ease-in-out

**Usage**:
```dart
TossSegmentedControl(
  options: ["Week", "Month"],
  selectedIndex: _viewMode == ViewMode.week ? 0 : 1,
  onChanged: (index) {
    setState(() {
      _viewMode = index == 0 ? ViewMode.week : ViewMode.month;
    });
  },
)
```

---

### 2. TossTodayShiftCard

**File**: `lib/shared/widgets/toss/toss_today_shift_card.dart`

**Purpose**: Featured card showing today's shift with action button

**Properties**:
```dart
class TossTodayShiftCard extends StatelessWidget {
  final String? shiftType;          // "Morning", "Evening", "Night"
  final String? timeRange;          // "9:00 AM - 5:00 PM"
  final ShiftStatus status;         // upcoming, in_progress, completed
  final VoidCallback? onCheckIn;    // Action handler
  final VoidCallback? onCheckOut;   // Action handler
  final bool isLoading;             // Loading state
}

enum ShiftStatus {
  upcoming,      // Blue - not started yet
  in_progress,   // Green - currently working
  completed,     // Gray - shift finished
  no_shift,      // No shift today
}
```

**Design Specs**:
- **Container**:
  - Border: 1px solid (status-dependent color)
  - Border radius: TossBorderRadius.lg (12px)
  - Padding: TossSpacing.lg (16px)
  - Background: TossColors.white
- **Layout**: Column (2 rows)
  - Row 1: Title + Status badge
  - Row 2: Time range + Action button

**Status Colors**:
- **upcoming**: TossColors.blue500 (border + badge bg)
- **in_progress**: TossColors.green500 (border + badge bg)
- **completed**: TossColors.gray300 (border + badge bg)
- **no_shift**: TossColors.gray200 (border), gray text

**Action Button**:
- **upcoming**: "Check In" (blue)
- **in_progress**: "Check Out" (green)
- **completed**: "View Details" (gray)
- **no_shift**: Hidden

**Empty State** (no shift today):
```dart
// Show friendly message instead
Column(
  children: [
    Icon(Icons.calendar_today_outlined, color: gray400, size: 48),
    SizedBox(height: 8),
    Text("No shift scheduled today", style: body1Regular),
    Text("Enjoy your day off!", style: label1Regular, color: gray500),
  ],
)
```

**Usage**:
```dart
TossTodayShiftCard(
  shiftType: "Morning",
  timeRange: "9:00 AM - 5:00 PM",
  status: ShiftStatus.upcoming,
  onCheckIn: () => _handleCheckIn(),
  onCheckOut: () => _handleCheckOut(),
  isLoading: false,
)
```

---

### 3. TossWeekShiftCard

**File**: `lib/shared/widgets/toss/toss_week_shift_card.dart`

**Purpose**: Compact card for shift list (used in both Week and Month views)

**Properties**:
```dart
class TossWeekShiftCard extends StatelessWidget {
  final String date;                // "Mon 11"
  final String shiftType;           // "Morning"
  final String timeRange;           // "9:00 AM - 5:00 PM"
  final ShiftCardStatus status;     // upcoming, completed, late, in_progress
  final VoidCallback? onTap;        // Tap handler
}

enum ShiftCardStatus {
  upcoming,      // Blue left border
  in_progress,   // Green left border
  completed,     // Gray left border
  late,          // Red left border
}
```

**Design Specs**:
- **Container**:
  - Border radius: TossBorderRadius.md (8px)
  - Background: TossColors.gray50
  - Left border: 4px solid (status-dependent color)
  - Padding: TossSpacing.md (12px)
- **Layout**: Row (2 columns)
  - Column 1 (25%): Date
  - Column 2 (75%): Shift type + Time range
- **Height**: 72px

**Status Colors**:
- **upcoming**: TossColors.blue500
- **in_progress**: TossColors.green500
- **completed**: TossColors.gray300
- **late**: TossColors.red500

**Typography**:
- **Date**: TossTextStyles.body1Bold (gray900)
- **Shift Type**: TossTextStyles.body2Medium (gray900)
- **Time Range**: TossTextStyles.label1Regular (gray600)

**Usage**:
```dart
TossWeekShiftCard(
  date: "Mon 11",
  shiftType: "Morning",
  timeRange: "9:00 AM - 5:00 PM",
  status: ShiftCardStatus.upcoming,
  onTap: () => _showShiftDetails(),
)
```

---

### 4. TossWeekNavigation

**File**: `lib/shared/widgets/toss/toss_week_navigation.dart`

**Purpose**: Navigation for Week view (Prev/Current/Next)

**Properties**:
```dart
class TossWeekNavigation extends StatelessWidget {
  final int currentWeekNumber;      // 1-53
  final int year;                   // 2024
  final VoidCallback onPrevWeek;    // Navigate to previous week
  final VoidCallback onCurrentWeek; // Jump to current week
  final VoidCallback onNextWeek;    // Navigate to next week
}
```

**Design Specs**:
- **Layout**: Row (space-between)
  - Left: IconButton (chevron_left)
  - Center: GestureDetector → Text ("Week 45, 2024")
  - Right: IconButton (chevron_right)
- **Height**: 48px
- **Background**: TossColors.transparent

**Typography**:
- **Week text**: TossTextStyles.body1Medium (gray900)

**Icon Buttons**:
- **Size**: 24×24
- **Color**: TossColors.gray600
- **Icons**: Icons.chevron_left, Icons.chevron_right

**Center Text** (tappable):
- **Action**: Jump to current week
- **Feedback**: Ripple effect (InkWell)

**Usage**:
```dart
TossWeekNavigation(
  currentWeekNumber: 45,
  year: 2024,
  onPrevWeek: () => _navigateWeek(-1),
  onCurrentWeek: () => _navigateWeek(0),
  onNextWeek: () => _navigateWeek(1),
)
```

---

### 5. TossMonthNavigation

**File**: `lib/shared/widgets/toss/toss_month_navigation.dart`

**Purpose**: Navigation for Month view (Prev/Current/Next)

**Properties**:
```dart
class TossMonthNavigation extends StatelessWidget {
  final String currentMonth;        // "November"
  final int year;                   // 2024
  final VoidCallback onPrevMonth;   // Navigate to previous month
  final VoidCallback onCurrentMonth; // Jump to current month
  final VoidCallback onNextMonth;   // Navigate to next month
}
```

**Design Specs**:
- **Layout**: Row (space-between)
  - Left: IconButton (chevron_left)
  - Center: GestureDetector → Text ("November 2024")
  - Right: IconButton (chevron_right)
- **Height**: 48px
- **Background**: TossColors.transparent

**Typography**:
- **Month text**: TossTextStyles.body1Medium (gray900)

**Icon Buttons**:
- **Size**: 24×24
- **Color**: TossColors.gray600
- **Icons**: Icons.chevron_left, Icons.chevron_right

**Center Text** (tappable):
- **Action**: Jump to current month
- **Feedback**: Ripple effect (InkWell)

**Usage**:
```dart
TossMonthNavigation(
  currentMonth: "November",
  year: 2024,
  onPrevMonth: () => _navigateMonth(-1),
  onCurrentMonth: () => _navigateMonth(0),
  onNextMonth: () => _navigateMonth(1),
)
```

---

### 6. TossMonthCalendar

**File**: `lib/shared/widgets/toss/toss_month_calendar.dart`

**Purpose**: Full month calendar grid with shift indicators

**Properties**:
```dart
class TossMonthCalendar extends StatelessWidget {
  final DateTime selectedDate;              // Currently selected date
  final DateTime currentMonth;              // Month to display
  final Map<DateTime, bool> shiftsInMonth;  // date → hasShift
  final ValueChanged<DateTime> onDateSelected; // Date selection callback
}
```

**Design Specs**:
- **Container**:
  - Border: 1px solid TossColors.gray200
  - Border radius: TossBorderRadius.lg (12px)
  - Padding: TossSpacing.lg (16px)
  - Background: TossColors.white

**Layout Structure**:
```
Column
├── GridView (Header)
│   └── 7 cells: Mon, Tue, Wed, Thu, Fri, Sat, Sun
│       └── Text (TossTextStyles.label2, gray500)
│       └── Height: 32px
│
└── GridView.builder (Calendar grid)
    └── 35-42 cells (7 columns × 5-6 rows)
        └── _CalendarDayCell (internal widget)
```

**Grid Configuration**:
- **Columns**: 7 (fixed)
- **Rows**: 5-6 (depends on month)
- **Cell size**: Square (aspect ratio 1:1)
- **Spacing**: 8px horizontal, 4px vertical

**Date Calculation Logic**:
```dart
// Calculate first day of month (0=Mon, 6=Sun)
final firstDayOfMonth = DateTime(year, month, 1);
final firstWeekday = firstDayOfMonth.weekday - 1; // 0-6

// Calculate total cells needed
final daysInMonth = DateTime(year, month + 1, 0).day;
final totalCells = ((firstWeekday + daysInMonth) / 7).ceil() * 7;

// Grid builder
GridView.builder(
  itemCount: totalCells,
  itemBuilder: (context, index) {
    final dayNumber = index - firstWeekday + 1;
    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return SizedBox.shrink(); // Empty cell
    }

    final date = DateTime(year, month, dayNumber);
    final isToday = _isSameDay(date, DateTime.now());
    final isPast = date.isBefore(DateTime.now());
    final isSelected = _isSameDay(date, selectedDate);
    final hasShift = shiftsInMonth[date] ?? false;

    return _CalendarDayCell(
      date: date,
      isToday: isToday,
      isPast: isPast,
      isSelected: isSelected,
      hasShift: hasShift,
      onTap: () => onDateSelected(date),
    );
  },
)
```

**Usage**:
```dart
TossMonthCalendar(
  selectedDate: DateTime(2024, 11, 10),
  currentMonth: DateTime(2024, 11, 1),
  shiftsInMonth: {
    DateTime(2024, 11, 1): true,
    DateTime(2024, 11, 3): true,
    DateTime(2024, 11, 5): true,
    // ... more dates
  },
  onDateSelected: (date) {
    setState(() {
      _selectedDate = date;
    });
  },
)
```

---

### 6.1. _CalendarDayCell (Internal Widget)

**Purpose**: Individual calendar cell with date and shift indicator

**Properties**:
```dart
class _CalendarDayCell extends StatelessWidget {
  final DateTime date;              // Full date
  final bool isToday;               // Is this today?
  final bool isPast;                // Is this in the past?
  final bool isSelected;            // Is this selected?
  final bool hasShift;              // Does this date have a shift?
  final VoidCallback? onTap;        // Tap handler
}
```

**Design Pattern**: **One component with multiple visual variants**

**Layout**:
```dart
GestureDetector(
  onTap: onTap,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _DateCircle(
        date: date.day,
        backgroundColor: _getBackgroundColor(),
        border: _getBorder(),
        textColor: _getTextColor(),
      ),
      if (!isPast && !isToday) ...[
        SizedBox(height: 4),
        _DateDot(hasShift: hasShift),
      ],
    ],
  ),
)
```

**Conditional Styling Methods**:
```dart
Color _getBackgroundColor() {
  if (isSelected) return TossColors.blue500;
  return TossColors.transparent;
}

BoxBorder? _getBorder() {
  if (isSelected) return null; // No border when selected
  if (isPast) return Border.all(color: TossColors.gray300, width: 1);
  if (isToday) return null; // No border for today
  return Border.all(color: TossColors.blue500, width: 1); // Upcoming
}

Color _getTextColor() {
  if (isSelected) return TossColors.white;
  if (isPast) return TossColors.gray400;
  if (isToday) return TossColors.blue500;
  return TossColors.gray900; // Upcoming
}
```

**Visual States Summary**:

| State | Background | Border | Text Color | Dot Visible |
|-------|------------|--------|------------|-------------|
| **Past** | transparent | gray300 (1px) | gray400 | No |
| **Today** | transparent | none | blue500 | No |
| **Upcoming** | transparent | blue500 (1px) | gray900 | Yes |
| **Selected** | blue500 | none | white | Yes (if upcoming) |

---

### 6.2. _DateCircle (Internal Widget)

**Purpose**: Circular container for date number

**Properties**:
```dart
class _DateCircle extends StatelessWidget {
  final int date;                   // 1-31
  final Color backgroundColor;       // From parent
  final BoxBorder? border;          // From parent
  final Color textColor;            // From parent
}
```

**Design Specs**:
- **Size**: 24×24
- **Border radius**: 12px (circle)
- **Alignment**: Center
- **Typography**: TossTextStyles.label1Medium

**Implementation**:
```dart
Container(
  width: 24,
  height: 24,
  decoration: BoxDecoration(
    color: backgroundColor,
    border: border,
    borderRadius: BorderRadius.circular(12),
  ),
  alignment: Alignment.center,
  child: Text(
    date.toString(),
    style: TossTextStyles.label1Medium.copyWith(
      color: textColor,
    ),
  ),
)
```

---

### 6.3. _DateDot (Internal Widget)

**Purpose**: Shift indicator dot below date

**Properties**:
```dart
class _DateDot extends StatelessWidget {
  final bool hasShift;              // Show blue or gray dot?
}
```

**Design Specs**:
- **Size**: 4×4
- **Border radius**: 2px (circle)
- **Colors**:
  - **Has shift**: TossColors.blue500
  - **No shift**: TossColors.gray300

**Implementation**:
```dart
Container(
  width: 4,
  height: 4,
  decoration: BoxDecoration(
    color: hasShift ? TossColors.blue500 : TossColors.gray300,
    borderRadius: BorderRadius.circular(2),
  ),
)
```

---

## Risk Assessment

### Identified Risks

#### 1. Data Loss Risk (🔴 Critical)
**Risk**: Monthly caching logic disruption could lose cached data
**Mitigation**:
- [ ] Thoroughly understand existing caching strategy before changes
- [ ] Test cache persistence across view mode switches
- [ ] Add fallback to re-fetch if cache is corrupted
- [ ] Verify cache keys remain compatible

#### 2. State Management Risk (🟡 High)
**Risk**: Provider breaking changes could affect other features
**Mitigation**:
- [ ] Use existing providers without modification
- [ ] Create new view-specific providers if needed
- [ ] Test provider interactions thoroughly
- [ ] Add defensive null checks

#### 3. Navigation Risk (🟡 High)
**Risk**: Week/month navigation could cause out-of-bounds dates
**Mitigation**:
- [ ] Use DateTime built-in methods for date calculations
- [ ] Test edge cases (month boundaries, year boundaries)
- [ ] Add validation for date ranges
- [ ] Handle February leap year correctly

#### 4. Performance Risk (🟢 Medium)
**Risk**: AnimatedSwitcher could cause performance issues
**Mitigation**:
- [ ] Use const constructors where possible
- [ ] Limit widget rebuilds with proper key management
- [ ] Test on low-end devices
- [ ] Monitor frame rate (target: 60fps)

#### 5. UI Consistency Risk (🟢 Medium)
**Risk**: New components might not match design system
**Mitigation**:
- [ ] Use design library page for visual testing
- [ ] Reference existing Toss components for patterns
- [ ] Get design review before finalizing
- [ ] Document any design system additions

---

## Technical Notes

### Design System References

**Colors** (from `toss_colors.dart`):
```dart
TossColors.blue500      // #0064FF (primary)
TossColors.green500     // #00C896 (success)
TossColors.red500       // #FF3B30 (error)
TossColors.gray900      // #212121 (primary text)
TossColors.gray600      // #757575 (secondary text)
TossColors.gray400      // #BDBDBD (disabled text)
TossColors.gray300      // #E0E0E0 (borders)
TossColors.gray200      // #EEEEEE (dividers)
TossColors.gray50       // #FAFAFA (backgrounds)
TossColors.white        // #FFFFFF
TossColors.transparent  // Colors.transparent
```

**Spacing** (from `toss_spacing.dart`):
```dart
TossSpacing.xxxs   // 2px
TossSpacing.xxs    // 4px
TossSpacing.xs     // 8px
TossSpacing.sm     // 12px
TossSpacing.md     // 16px
TossSpacing.lg     // 20px
TossSpacing.xl     // 24px
TossSpacing.xxl    // 32px
TossSpacing.xxxl   // 40px
```

**Border Radius** (from `toss_border_radius.dart`):
```dart
TossBorderRadius.xs    // 2px
TossBorderRadius.sm    // 4px
TossBorderRadius.md    // 8px
TossBorderRadius.lg    // 12px
TossBorderRadius.xl    // 16px
TossBorderRadius.xxl   // 20px
TossBorderRadius.xxxl  // 24px
TossBorderRadius.full  // 9999px (circle)
```

**Typography** (from `toss_text_styles.dart`):
```dart
// Headings
TossTextStyles.heading1Bold      // 24px, Bold, Inter
TossTextStyles.heading2Bold      // 20px, Bold, Inter

// Body
TossTextStyles.body1Bold         // 16px, Bold, Inter
TossTextStyles.body1Medium       // 16px, Medium, Inter
TossTextStyles.body1Regular      // 16px, Regular, Inter
TossTextStyles.body2Bold         // 14px, Bold, Inter
TossTextStyles.body2Medium       // 14px, Medium, Inter
TossTextStyles.body2Regular      // 14px, Regular, Inter

// Labels
TossTextStyles.label1Bold        // 12px, Bold, Inter
TossTextStyles.label1Medium      // 12px, Medium, Inter
TossTextStyles.label1Regular     // 12px, Regular, Inter
TossTextStyles.label2Regular     // 10px, Regular, Inter
```

### Date Calculation Helpers

**Week Number Calculation**:
```dart
int getWeekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
  return (daysSinceFirstDay / 7).ceil() + 1;
}
```

**Week Range Calculation**:
```dart
DateTimeRange getWeekRange(DateTime date) {
  final weekday = date.weekday; // 1=Mon, 7=Sun
  final monday = date.subtract(Duration(days: weekday - 1));
  final sunday = monday.add(Duration(days: 6));
  return DateTimeRange(
    start: DateTime(monday.year, monday.month, monday.day),
    end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
  );
}
```

**Same Day Comparison**:
```dart
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
```

**Month Grid Calculation**:
```dart
int getFirstWeekdayOfMonth(int year, int month) {
  final firstDay = DateTime(year, month, 1);
  return firstDay.weekday - 1; // 0=Mon, 6=Sun
}

int getDaysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

int getCalendarRows(int year, int month) {
  final firstWeekday = getFirstWeekdayOfMonth(year, month);
  final daysInMonth = getDaysInMonth(year, month);
  final totalCells = firstWeekday + daysInMonth;
  return (totalCells / 7).ceil();
}
```

### State Management Pattern

**MyScheduleTab State**:
```dart
class _MyScheduleTabState extends State<MyScheduleTab> {
  // View mode state
  ViewMode _viewMode = ViewMode.week;

  // Navigation state
  int _currentWeekOffset = 0;  // 0 = current week, -1 = prev, +1 = next
  int _currentMonthOffset = 0; // 0 = current month, -1 = prev, +1 = next

  // Selection state (for Month view)
  DateTime _selectedDate = DateTime.now();

  // Computed properties
  DateTime get _currentWeek {
    return DateTime.now().add(Duration(days: _currentWeekOffset * 7));
  }

  DateTime get _currentMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + _currentMonthOffset, 1);
  }

  DateTimeRange get _weekRange => getWeekRange(_currentWeek);

  // Navigation handlers
  void _navigateWeek(int offset) {
    if (offset == 0) {
      setState(() => _currentWeekOffset = 0);
    } else {
      setState(() => _currentWeekOffset += offset);
    }
  }

  void _navigateMonth(int offset) {
    if (offset == 0) {
      setState(() => _currentMonthOffset = 0);
    } else {
      setState(() => _currentMonthOffset += offset);
    }
  }

  void _handleDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
  }
}
```

### Existing Provider Integration

**Providers to Use** (from attendance feature):
```dart
// Use cases
final getShiftOverviewProvider
final getMonthlyShiftCardsProvider
final checkInShiftProvider
final checkOutShiftProvider
final getShiftByIdProvider

// State providers
final attendanceCheckInUseCaseProvider
final shiftRegisterUseCaseProvider
final employeeShiftManagementUseCaseProvider
```

**Example Data Fetching**:
```dart
// In MyScheduleTab
Widget build(BuildContext context) {
  // Get use case provider
  final checkInUseCase = ref.watch(attendanceCheckInUseCaseProvider);

  // Fetch monthly data (uses existing caching)
  final monthKey = '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}';

  return FutureBuilder(
    future: checkInUseCase.getShiftOverview(monthKey),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildLoadingState();
      }

      if (snapshot.hasError) {
        return _buildErrorState(snapshot.error);
      }

      final shiftData = snapshot.data;
      return _buildContent(shiftData);
    },
  );
}
```

---

## Completion Checklist

### Pre-Implementation
- [ ] Design mockups reviewed and approved
- [ ] Widget tree plans reviewed and approved
- [ ] Component specifications finalized
- [ ] Risk assessment completed
- [ ] Development environment ready

### Stage 1: Shared Components (Phase 1)
- [ ] TossSegmentedControl completed and tested
- [ ] TossTodayShiftCard completed and tested
- [ ] TossWeekShiftCard completed and tested
- [ ] All components added to design library

### Stage 2: Shared Components (Phase 2)
- [ ] TossWeekNavigation completed and tested
- [ ] TossMonthNavigation completed and tested
- [ ] All components added to design library

### Stage 3: Month Calendar Component
- [ ] TossMonthCalendar main component completed
- [ ] Calendar header row implemented
- [ ] Calendar grid implemented
- [ ] _CalendarDayCell implemented with all states
- [ ] _DateCircle implemented
- [ ] _DateDot implemented
- [ ] Date selection working correctly
- [ ] Component added to design library

### Stage 4: MyScheduleTab Implementation
- [ ] MyScheduleTab file created
- [ ] State management implemented
- [ ] Data fetching integrated
- [ ] _buildWeekView method implemented
- [ ] _buildMonthView method implemented
- [ ] Navigation handlers implemented
- [ ] AnimatedSwitcher transitions working

### Stage 5: AttendanceMainPage Update
- [ ] AttendanceMainPage updated to use TossTabBarView1
- [ ] 3-tab structure implemented
- [ ] StatsTab placeholder created
- [ ] All tabs rendering correctly

### Stage 6: Testing & Refinement
- [ ] Visual testing completed (all screen sizes)
- [ ] Functional testing completed (all interactions)
- [ ] Edge cases tested and handled
- [ ] Performance testing completed
- [ ] Code cleanup completed

### Final Acceptance
- [ ] All features working as designed
- [ ] No errors or warnings
- [ ] Performance targets met
- [ ] Design system consistency verified
- [ ] Code review completed
- [ ] Documentation updated
- [ ] Ready for production

---

## File Structure Reference

```
lib/
├── features/
│   └── attendance/
│       └── presentation/
│           ├── pages/
│           │   ├── attendance_main_page.dart (UPDATE - 136→35 lines)
│           │   ├── my_schedule_tab.dart (NEW - ~400 lines)
│           │   └── stats_tab.dart (NEW - ~50 lines)
│           │
│           ├── widgets/
│           │   ├── check_in_out/
│           │   │   └── attendance_content.dart (KEEP - will be archived)
│           │   │
│           │   └── shift_register/
│           │       └── shift_register_tab.dart (KEEP - rename to "Requests")
│           │
│           └── attend_page_UI_plan.md (THIS FILE)
│
└── shared/
    └── widgets/
        └── toss/
            ├── toss_tab_bar_1.dart (EXISTING - reuse)
            ├── toggle_button.dart (EXISTING - adapt from)
            ├── toss_segmented_control.dart (NEW - ~120 lines)
            ├── toss_today_shift_card.dart (NEW - ~150 lines)
            ├── toss_week_shift_card.dart (NEW - ~100 lines)
            ├── toss_week_navigation.dart (NEW - ~80 lines)
            ├── toss_month_navigation.dart (NEW - ~100 lines)
            └── toss_month_calendar.dart (NEW - ~300 lines)
```

---

## Notes & Questions

### Open Questions
- [ ] Do we need loading skeletons for shift cards?
- [ ] Should we add swipe gestures for week/month navigation?
- [ ] Do we want pull-to-refresh on shift lists?
- [ ] Should stats tab be implemented now or later?

### Design Decisions Made
- ✅ Use TossTabBarView1 instead of custom tab bar (saves ~80 lines)
- ✅ Adapt from ToggleButton for segmented control
- ✅ Single _CalendarDayCell component with multiple visual variants
- ✅ Reuse TossWeekShiftCard in both Week and Month views
- ✅ Keep existing monthly caching strategy
- ✅ Use AnimatedSwitcher for smooth view transitions

### Future Enhancements (Post-Launch)
- [ ] Add filters (shift type, status)
- [ ] Add sort options (date, type, status)
- [ ] Add search functionality
- [ ] Implement stats tab with charts
- [ ] Add shift swap/trade functionality
- [ ] Add calendar export (iCal)
- [ ] Add notifications for upcoming shifts

---

**Last Updated**: 2025-11-20
**Plan Status**: ✅ Complete - Ready for Implementation
**Next Action**: Begin Stage 1 - Create TossSegmentedControl
