# 🎨 MyPage Design Specification - Toss Style
## 📱 Animated, User-Intuitive Personal Dashboard

**Version**: 1.0.0  
**Created**: 2025-01-17  
**Status**: 🎯 Ready for Implementation

---

## 🌟 Executive Summary

MyPage is a personalized user dashboard following Toss's minimalist design philosophy, featuring smooth animations, intuitive navigation, and a clean financial-focused interface. The page serves as the user's personal control center for account management, preferences, achievements, and financial insights.

**Core Design Principles**:
- 🎯 **Single Focus**: Clear hierarchy with primary actions prominent
- ⚡ **Smooth Animations**: 200-250ms transitions, no bouncy effects
- 💙 **Strategic Color**: Toss Blue for CTAs, grayscale for UI
- 📐 **4px Grid System**: Strict spacing consistency
- ✨ **Micro-interactions**: Subtle feedback for all user actions

---

## 🏗️ Architecture Overview

### Route Configuration
```yaml
supabase_route: myPage
gorouter_path: /myPage
page_class: MyPage
category: User Management
priority: High
```

### Page Structure
```
MyPage/
├── Profile Header (Animated)
├── Quick Stats Section
├── Action Cards Grid
├── Recent Activity Timeline
└── Settings & Preferences
```

---

## 🎨 Visual Design System

### Color Palette
```dart
// Background Layers
scaffold: TossColors.gray100      // #F1F3F5 - Main background
cards: TossColors.surface          // #FFFFFF - Card surfaces
header: TossColors.primary         // #0064FF - Header accent

// Interactive Elements
primary_cta: TossColors.primary    // #0064FF - Primary actions
success: TossColors.success        // #00C896 - Achievements
warning: TossColors.warning        // #FF9500 - Notifications
error: TossColors.error            // #FF5847 - Critical alerts

// Text Hierarchy
primary_text: TossColors.textPrimary     // #212529
secondary_text: TossColors.textSecondary // #6C757D
tertiary_text: TossColors.textTertiary   // #ADB5BD
```

### Typography System
```dart
// Headers
profile_name: TossTextStyles.h2        // 24px, bold
section_title: TossTextStyles.h3       // 20px, semibold
card_title: TossTextStyles.bodyLarge   // 16px, semibold

// Body Text
body: TossTextStyles.body              // 14px, regular
caption: TossTextStyles.caption        // 12px, regular
amount: TossTextStyles.amount          // 18px, bold (for financial data)
```

### Spacing Grid (4px System)
```dart
space1: 4px   // Micro spacing
space2: 8px   // Compact spacing
space3: 12px  // Default spacing
space4: 16px  // Standard padding ⭐
space5: 20px  // Section spacing
space6: 24px  // Large spacing ⭐
```

---

## 🧩 Component Architecture

### 1. Profile Header Component
```dart
ProfileHeader:
  structure:
    - Avatar Container (80x80) with badge indicator
    - User Info Section (name, role, company)
    - Edit Profile Button (icon)
    - Settings Button (gear icon)
  
  animations:
    - Avatar: Scale animation on tap (0.95x, 100ms)
    - Badge: Pulse animation for notifications (1.0-1.1x, 800ms)
    - Buttons: Tap feedback (opacity 0.7, 150ms)
  
  interactions:
    - Tap avatar: Open image picker/viewer
    - Tap edit: Navigate to profile edit
    - Tap settings: Navigate to settings
```

### 2. Quick Stats Cards
```dart
QuickStatsSection:
  layout: Horizontal scroll (if > 3 items)
  
  card_types:
    - Balance Card (current balance with trend)
    - Activity Card (today's transactions)
    - Achievement Card (points/level)
    - Notification Card (pending items)
  
  animations:
    - Entry: Staggered fade-in (50ms delay between cards)
    - Tap: Scale down to 0.97x with shadow reduction
    - Update: Number counter animation (500ms)
  
  interactions:
    - Tap: Navigate to detailed view
    - Long press: Show tooltip/info
```

### 3. Action Cards Grid
```dart
ActionCardsGrid:
  layout: 2x2 grid (responsive)
  
  cards:
    - Personal Info (edit profile details)
    - Security (password, 2FA, biometrics)
    - Preferences (theme, language, notifications)
    - Payment Methods (cards, accounts)
    - Activity History (login, transactions)
    - Help & Support (FAQ, contact)
  
  card_design:
    - Icon (44x44) with background tint
    - Title (16px, semibold)
    - Subtitle (14px, gray)
    - Chevron indicator
  
  animations:
    - Hover: Elevation increase (web)
    - Tap: Ripple effect from touch point
    - Navigate: Slide transition to detail page
```

### 4. Recent Activity Timeline
```dart
ActivityTimeline:
  structure:
    - Section header with "View All" link
    - Vertical timeline with connecting line
    - Activity items with time stamps
  
  item_types:
    - Transaction (amount, party, time)
    - Login (device, location, time)
    - Profile Update (field changed, time)
    - Achievement (milestone reached, points)
  
  animations:
    - Load: Items fade in sequentially
    - Expand: Smooth height animation for details
    - Delete: Swipe to dismiss with fade out
```

### 5. Bottom Navigation Integration
```dart
BottomNavigation:
  mypage_icon: Icons.person_outline
  selected_state: Icons.person (filled)
  badge: Red dot for notifications
  
  animation:
    - Icon swap: Morph animation (200ms)
    - Color change: Fade transition
    - Badge: Bounce-in animation
```

---

## ⚡ Animation Sequences

### Page Entry Animation
```dart
PageEntrySequence:
  duration: 600ms total
  
  timeline:
    0ms: Background fade in (gray100)
    50ms: Header slide down + fade in
    150ms: Stats cards stagger in (50ms each)
    300ms: Action grid fade in with scale
    450ms: Timeline items cascade in
    600ms: Complete
  
  curves:
    - Header: easeOutCubic
    - Cards: easeInOutCubic  
    - Timeline: easeOutQuart
```

### Profile Picture Animation
```dart
ProfilePictureAnimation:
  idle_state:
    - Subtle shadow (4% opacity)
    - Border: 2px white
  
  tap_sequence:
    0ms: Scale to 0.95x
    100ms: Return to 1.0x with bounce
    150ms: Ripple effect expands
    300ms: Ripple fades out
  
  loading_state:
    - Rotating border gradient
    - Blur effect on image
    - Progress indicator overlay
```

### Card Interactions
```dart
CardTapAnimation:
  press_down:
    - Scale: 1.0x → 0.97x (100ms)
    - Shadow: 4% → 2% opacity
    - Background: Add 5% black overlay
  
  release:
    - Scale: 0.97x → 1.0x (150ms)
    - Shadow: Return to 4%
    - Background: Remove overlay
  
  navigation:
    - Current card: Fade out (200ms)
    - New page: Slide in from right (250ms)
```

### Pull-to-Refresh
```dart
RefreshAnimation:
  pull_phase:
    - Elastic stretch effect
    - Refresh icon rotation (0-180°)
    - Haptic feedback at threshold
  
  refresh_phase:
    - Icon continuous rotation
    - Loading shimmer on content
    - Pulse animation on cards
  
  complete_phase:
    - Success checkmark morph
    - Content fade in
    - Bounce-back animation
```

---

## 📱 Responsive Behavior

### Mobile (< 768px)
```yaml
layout:
  - Single column
  - Full-width cards
  - Vertical scroll only
  - Bottom sheet modals
  
spacing:
  - Padding: 16px
  - Card gap: 12px
  - Compact headers
```

### Tablet (768px - 1024px)
```yaml
layout:
  - 2-column grid for cards
  - Side-by-side stats
  - Modal dialogs
  - Expanded timeline
  
spacing:
  - Padding: 20px
  - Card gap: 16px
  - Larger touch targets
```

### Desktop (> 1024px)
```yaml
layout:
  - 3-column layout
  - Sidebar navigation
  - Inline editing
  - Hover states enabled
  
spacing:
  - Padding: 24px
  - Card gap: 20px
  - Maximum width: 1200px
```

---

## 🔄 State Management

### Provider Architecture
```dart
// User Profile Provider
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier(ref);
});

// Activity Provider  
final recentActivityProvider = FutureProvider<List<Activity>>((ref) async {
  return ref.watch(activityRepositoryProvider).getRecentActivity();
});

// Stats Provider (with auto-refresh)
final quickStatsProvider = StreamProvider<QuickStats>((ref) {
  return ref.watch(statsRepositoryProvider).watchQuickStats();
});

// Preferences Provider
final userPreferencesProvider = StateProvider<UserPreferences>((ref) {
  return UserPreferences.defaults();
});
```

### State Transitions
```dart
StateTransitions:
  loading:
    - Show skeleton loaders
    - Maintain layout structure
    - Shimmer animation on placeholders
  
  success:
    - Fade in content
    - Trigger success animations
    - Update badges/counters
  
  error:
    - Show error card
    - Provide retry action
    - Log to analytics
  
  empty:
    - Show empty state illustration
    - Provide action suggestions
    - Maintain positive messaging
```

---

## 🎯 User Flow & Navigation

### Primary User Flows

#### 1. Profile Editing Flow
```mermaid
User taps Edit → Slide up modal → Edit fields → Validate → Save → Success feedback → Update UI
```

#### 2. Settings Navigation
```mermaid
User taps Settings → Navigate with slide → Show settings list → Select category → Show details → Apply changes
```

#### 3. Activity Detail Flow
```mermaid
User taps activity → Expand inline → Show details → Provide actions → Execute → Update timeline
```

### Navigation Patterns
```yaml
navigation_types:
  - Push: Settings, detailed views
  - Modal: Quick edits, confirmations
  - Bottom Sheet: Filters, options
  - Inline: Expandable content
  
transitions:
  - Slide from right: Push navigation
  - Slide from bottom: Modals/sheets
  - Fade: Overlays and tooltips
  - Expand: Inline content
```

---

## 🚀 Performance Optimizations

### Rendering Optimizations
```dart
OptimizationStrategies:
  lazy_loading:
    - Timeline items load on scroll
    - Images load with placeholders
    - Heavy components defer rendering
  
  caching:
    - Profile data: 5 minutes
    - Activity: 1 minute
    - Stats: Real-time (stream)
    - Preferences: Session
  
  batching:
    - Group API calls
    - Debounce search inputs
    - Throttle scroll events
```

### Animation Performance
```dart
PerformanceTargets:
  frame_rate: 60fps minimum
  animation_budget: 16ms per frame
  
techniques:
  - Use transform instead of layout changes
  - Leverage GPU acceleration
  - Preload animation assets
  - Use will-change CSS hints
  - Implement animation pooling
```

---

## 🔐 Security Considerations

### Data Protection
```yaml
sensitive_data:
  - Mask financial amounts until authenticated
  - Blur profile picture in public mode
  - Hide email/phone partially
  - Encrypt stored preferences
  
session_security:
  - Auto-logout after inactivity
  - Biometric re-authentication for sensitive actions
  - Session token refresh
  - Device fingerprinting
```

### Privacy Controls
```yaml
user_controls:
  - Profile visibility settings
  - Activity history management
  - Data export options
  - Account deletion flow
  
compliance:
  - GDPR data portability
  - Right to be forgotten
  - Consent management
  - Audit logging
```

---

## 📊 Analytics & Tracking

### Key Metrics
```yaml
engagement_metrics:
  - Page views per session
  - Time spent on page
  - Feature interaction rate
  - Settings modification frequency
  
performance_metrics:
  - Page load time
  - Animation frame rate
  - API response time
  - Error rate
  
user_behavior:
  - Most used features
  - Navigation patterns
  - Drop-off points
  - Feature discovery rate
```

### Event Tracking
```dart
TrackedEvents:
  page_view: { timestamp, user_id, session_id }
  profile_edit: { field, old_value, new_value }
  setting_change: { setting, value, source }
  navigation: { from, to, method }
  error: { type, message, stack_trace }
```

---

## ✅ Implementation Checklist

### Phase 1: Foundation (Week 1)
- [ ] Create page structure and routing
- [ ] Implement basic layout components
- [ ] Set up state management
- [ ] Add navigation integration

### Phase 2: Core Features (Week 2)
- [ ] Build profile header with animations
- [ ] Implement quick stats cards
- [ ] Create action cards grid
- [ ] Add activity timeline

### Phase 3: Interactions (Week 3)
- [ ] Add all micro-interactions
- [ ] Implement page transitions
- [ ] Add pull-to-refresh
- [ ] Create loading states

### Phase 4: Polish (Week 4)
- [ ] Fine-tune animations
- [ ] Add error handling
- [ ] Implement caching
- [ ] Performance optimization
- [ ] Accessibility features
- [ ] Testing & QA

---

## 🎬 Animation Reference Examples

### Toss-Style Animation Characteristics
```yaml
timing:
  standard: 200ms     # Most UI transitions
  emphasis: 250ms     # Important state changes
  quick: 100ms        # Micro-interactions
  
easing:
  enter: cubic-bezier(0.0, 0.0, 0.2, 1)    # easeOutCubic
  exit: cubic-bezier(0.4, 0.0, 1, 1)       # easeInCubic
  standard: cubic-bezier(0.4, 0.0, 0.2, 1) # easeInOutCubic
  
principles:
  - No spring/bounce animations
  - Consistent timing creates rhythm
  - Animations support user intent
  - Performance over complexity
  - Subtle over dramatic
```

---

## 📚 References

- Toss Design System: `lib/core/themes/toss_design_system.dart`
- Animation System: `lib/core/themes/toss_animations.dart`
- Homepage Pattern: `lib/presentation/pages/homepage/homepage_redesigned.dart`
- Color System: `lib/core/themes/toss_colors.dart`
- Component Library: `lib/presentation/widgets/toss/`

---

## 🏁 Success Criteria

**The MyPage implementation will be considered successful when:**

1. ✅ All animations run at 60fps
2. ✅ Page loads in under 1 second
3. ✅ Touch targets meet 44px minimum
4. ✅ All interactions have feedback within 100ms
5. ✅ Accessibility score > 95%
6. ✅ User satisfaction score > 4.5/5
7. ✅ Zero critical bugs in production
8. ✅ 100% Toss design system compliance

---

**Document Status**: Ready for implementation  
**Next Steps**: Begin Phase 1 development with routing setup and basic structure