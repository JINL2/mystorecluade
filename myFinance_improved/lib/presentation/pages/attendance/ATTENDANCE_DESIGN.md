# 📅 Attendance Page - Toss-Style Design Document (Balanced)

## Overview
Balanced attendance page with QR code scanning as the primary action while providing essential work schedule information, inspired by Toss's clean design philosophy.

## Design Principles
1. **QR Code First**: Primary action is always QR code scanning
2. **Essential Information**: Show work schedule and recent activity
3. **Single Tap Action**: One tap to scan, easy access to information
4. **Bottom Sheet Pattern**: Use Toss-style bottom sheets
5. **Progressive Disclosure**: Collapsible sections for detailed data

## Information Architecture

### 1. Compact Hero Section
**Purpose**: Current work status, shift info, and QR scan action
```
┌─────────────────────────────────────┐
│  Currently Working        2h 14m    │
│         15:38             [Timer]   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  🏪 Store A · Today         │   │
│  │  09:00 - 18:00              │   │
│  │  Check In: 09:24            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  📷 Scan to Check Out       │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### 2. Weekly Schedule View
**Purpose**: Show work schedule for the week
```
┌─────────────────────────────────────┐
│  This Week Schedule                 │
│                                     │
│  Mon  Tue  Wed  Thu  Fri  Sat  Sun │
│  11   12   13   14   15   16   17  │
│  🟢   🟢   🟢   🟠   🟠   Off  Off │
│  09:00 09:00 14:00 09:00 09:00     │
└─────────────────────────────────────┘
```

### 3. Recent Activity
**Purpose**: Show past attendance records
```
┌─────────────────────────────────────┐
│  Recent Activity         View All > │
│                                     │
│  Wed    ↘14:02  ↗22:05    8h 3m   │
│  11/13                              │
│                                     │
│  Tue    ↘09:01  ↗18:03    9h 2m   │
│  11/12                              │
│                                     │
│  Mon    ↘08:58  ↗17:59    9h 1m   │
│  11/11                              │
└─────────────────────────────────────┘
```

### 4. Monthly Summary (Collapsible)
**Purpose**: Monthly overview - tap to expand
```
┌─────────────────────────────────────┐
│  This Month          ₩2.4M    ▼    │
└─────────────────────────────────────┘
Expanded:
├─────────────────────────────────────┤
│  Days Worked         15 / 22       │
│  Total Hours         120h           │
│  Overtime            12h            │
│  Attendance Rate     95%            │
└─────────────────────────────────────┘
```

### 4. QR Scanner Bottom Sheet
**Purpose**: Clean scanning interface
```
┌─────────────────────────────────────┐
│         Check In/Out                │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │     QR Scanner View         │   │
│  │                             │   │
│  │   Point at store QR code    │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Store: Store A, Gangnam            │
│  Time: 09:24 AM                     │
│                                     │
│  [Cancel]                           │
└─────────────────────────────────────┘
```

## UI Components

### 1. Minimal Hero Card
```dart
TossCard(
  gradient: LinearGradient(
    colors: [TossColors.primary.withOpacity(0.1), Colors.white],
  ),
  child: Column(
    children: [
      // Large Clock Display
      Text('09:24', style: TossTextStyles.display),
      
      // Status Badge
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: TossColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: TossColors.success),
            SizedBox(width: 4),
            Text('Currently Working', style: TossTextStyles.label),
          ],
        ),
      ),
      
      // Work Duration
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, size: 20),
          SizedBox(width: 4),
          Text('2h 14m', style: TossTextStyles.h3),
        ],
      ),
    ],
  ),
)
```

### 2. Quick Stats Card
```dart
Container(
  height: 80,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
      StatCard(
        value: '15',
        label: 'Days',
        icon: Icons.calendar_today,
      ),
      StatCard(
        value: '120h',
        label: 'Hours',
        icon: Icons.access_time,
      ),
      StatCard(
        value: '₩2.4M',
        label: 'Expected',
        icon: Icons.account_balance_wallet,
      ),
    ],
  ),
)
```

### 3. Calendar Strip
```dart
Container(
  height: 80,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 7,
    itemBuilder: (context, index) {
      return DateChip(
        date: date,
        isToday: index == 2,
        hasShift: index < 5,
        isWorked: index < 2,
        onTap: () => navigateToDate(date),
      );
    },
  ),
)
```

### 4. Check In/Out Flow
```dart
// Bottom Sheet for QR Scanning
TossBottomSheet(
  title: 'Check In',
  content: Column(
    children: [
      // Animated QR Scanner Preview
      QRScannerPreview(),
      
      // Location Info
      LocationCard(
        distance: '15m away',
        address: 'Store A, Gangnam',
      ),
      
      // Action Button
      TossPrimaryButton(
        text: 'Scan QR Code',
        onPressed: () => scanQR(),
      ),
    ],
  ),
)
```

## Color Usage

### Primary Actions
- Check In/Out Button: `TossColors.primary`
- Success States: `TossColors.success`
- Warnings: `TossColors.warning`

### Status Indicators
- Working: Green dot with light green background
- Break: Orange dot with light orange background
- Off duty: Gray dot with light gray background

### Text Hierarchy
- Primary numbers: `TossColors.gray900` (bold)
- Labels: `TossColors.gray600`
- Secondary info: `TossColors.gray400`

## Animations & Interactions

### 1. Page Transitions
- Slide in from right with fade
- Duration: 300ms
- Easing: `Curves.easeOutCubic`

### 2. Card Interactions
- Scale down to 0.98 on tap
- Subtle shadow increase on hover
- Ripple effect on release

### 3. Number Animations
- Count up animation for stats
- Duration: 800ms
- Easing: `Curves.easeOut`

### 4. Status Changes
- Smooth color transitions
- Badge scale animation
- Haptic feedback on success

## Navigation Structure

```
Attendance Page
├── Today View (Default)
├── Calendar View (Full Month)
├── Statistics View
│   ├── Weekly Stats
│   ├── Monthly Stats
│   └── Yearly Summary
├── Shift Details
│   ├── Shift Info
│   ├── Location Map
│   └── Team Members
└── Settings
    ├── Notifications
    ├── Auto Check-in
    └── Work Preferences
```

## User Flows

### 1. Check-In Flow
```
Open App → View Status → Tap Check In → 
Scan QR → Confirm Location → Success Animation
```

### 2. View Schedule Flow
```
Open App → Swipe Calendar → Select Date → 
View Shift Details → See Team Members
```

### 3. Monthly Summary Flow
```
Open App → Tap Summary Card → Expand Details → 
View Breakdown → Export/Share
```

## Responsive Behavior

### Small Screens (< 360px)
- Stack stats cards vertically
- Reduce font sizes by 10%
- Hide secondary information

### Tablets
- Show calendar in grid view
- Display stats in 2-column layout
- Show shift details in side panel

## Accessibility

### Visual
- Minimum contrast ratio: 4.5:1
- Color-blind friendly indicators
- Clear focus states

### Interaction
- Touch targets: minimum 44x44px
- Swipe alternatives for all gestures
- Voice-over support

### Content
- Clear, concise labels
- Contextual help text
- Error messages with solutions

## Performance Considerations

### Initial Load
- Show skeleton screens
- Lazy load monthly data
- Cache recent shifts

### Interactions
- Debounce date changes
- Optimistic UI updates
- Offline support for viewing

## Error States

### No Shifts
```
┌─────────────────────────────────────┐
│         No shifts today             │
│    Enjoy your day off! 🌟          │
│                                     │
│  [View Schedule] Secondary Button   │
└─────────────────────────────────────┘
```

### Failed Check-In
```
┌─────────────────────────────────────┐
│     ⚠️ Check-in failed              │
│  Please try again or check          │
│  your location settings             │
│                                     │
│  [Retry] [Get Help]                 │
└─────────────────────────────────────┘
```

## Implementation Priority

### Phase 1 (MVP)
1. Today's status card
2. Check in/out functionality
3. Basic calendar navigation
4. Current shift display

### Phase 2
1. Monthly statistics
2. Calendar with indicators
3. Shift details page
4. Team member list

### Phase 3
1. Advanced analytics
2. Export functionality
3. Notification settings
4. Auto check-in

## Technical Specifications

### State Management
- Riverpod for global state
- Local state for animations
- Persistent storage for offline

### API Integration
```dart
// Shift Overview
final shiftOverviewProvider = FutureProvider((ref) async {
  return await UserShiftAPI.getOverview(
    userId: currentUser.id,
    month: selectedMonth,
  );
});

// Check In/Out
final checkInProvider = StateNotifierProvider((ref) {
  return CheckInNotifier(
    api: UserShiftAPI(),
    location: LocationService(),
  );
});
```

### Data Models
```dart
class AttendanceStatus {
  final bool isWorking;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final Duration workDuration;
  final ShiftDetails? currentShift;
}

class MonthlyStats {
  final int daysWorked;
  final Duration totalHours;
  final Duration overtime;
  final double expectedSalary;
  final double attendanceRate;
}
```

## Design Tokens Usage

### Colors
- Background: `TossColors.background`
- Cards: `TossColors.surface1`
- Primary Text: `TossColors.gray900`
- Secondary Text: `TossColors.gray600`

### Typography
- Clock: `TossTextStyles.display`
- Stats: `TossTextStyles.h1`
- Labels: `TossTextStyles.label`
- Body: `TossTextStyles.body`

### Spacing
- Page Padding: `TossSpacing.space5`
- Card Padding: `TossSpacing.space4`
- Element Gap: `TossSpacing.space3`
- Inline Gap: `TossSpacing.space2`

### Shadows
- Cards: `TossShadows.shadow2`
- Floating: `TossShadows.shadow3`
- Bottom Sheet: `TossShadows.shadow4`

## Future Enhancements

1. **Smart Notifications**
   - Shift reminders
   - Check-in alerts
   - Overtime warnings

2. **Analytics Dashboard**
   - Work patterns
   - Earnings trends
   - Attendance insights

3. **Social Features**
   - Team calendar
   - Shift swapping
   - Team chat

4. **Automation**
   - Geo-fenced check-in
   - Schedule sync
   - Payroll integration