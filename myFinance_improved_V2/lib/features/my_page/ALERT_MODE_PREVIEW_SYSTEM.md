# Alert Mode Interactive Preview System

## Overview
Implemented intuitive tap-to-preview system where users **experience** alert modes by simply tapping on them, following iOS ringtone selection pattern.

## Research Findings

### Industry Patterns Analyzed
1. **iOS Ringtone Selection** ✅ - Plays preview immediately when tapped, shows checkmark for selected
2. **Telegram Notification Settings** - Long-press plays preview sound + vibration
3. **Android Notification Channels** - "Test notification" button sends real notification
4. **WhatsApp Call Ringtones** - Tap to preview, automatic stop after 3-5 seconds
5. **Slack Notification Preferences** - "Send me a test notification" with actual delivery

### Chosen Approach: Direct Tap-to-Preview
**Why**:
- ✅ **Most intuitive** - No separate "Try" button needed
- ✅ **iOS-like** - Familiar pattern from ringtone selection
- ✅ **Faster exploration** - Single tap selects AND previews
- ✅ **Cleaner UI** - No extra buttons cluttering the interface

## Implementation

### Preview Mechanism

**Simply tap any alert mode option** - it selects AND previews simultaneously:

#### 1. Full Alerts (Mode 0)
- ✅ System notification sound (`SystemSoundType.alert`)
- ✅ Double vibration pattern (100ms gap)
- **Context**: Default mode for important business alerts

#### 2. Sound Only (Mode 1)
- ✅ System notification sound only
- ❌ No vibration
- **Context**: Best for desk work environments

#### 3. Vibration Only (Mode 2)
- ❌ No sound
- ✅ Double vibration pattern
- **Context**: Best for meetings/quiet environments

#### 4. Visual Only (Mode 3)
- ❌ No sound
- ❌ No vibration
- ✅ Visual notification banner (SnackBar)
- ✅ Light haptic feedback (single tap)
- **Context**: Silent notifications for focus mode

### Sound Design Philosophy

**Chosen**: System notification sound (`SystemSoundType.alert`)

**Why**:
- ✅ Pleasant and familiar to all users
- ✅ Platform-appropriate (iOS/Android native)
- ✅ Short duration (under 1 second)
- ✅ Gentle, non-traumatic sound profile
- ✅ Always available (no file dependencies)
- ✅ Consistent across app lifecycle

**Alternative**: Custom notification.mp3 (see `assets/sounds/notification_placeholder.txt` for guidelines)

### Vibration Pattern Design

**Pattern**: Double medium impact
```dart
await HapticFeedback.mediumImpact();
await Future.delayed(const Duration(milliseconds: 100));
await HapticFeedback.mediumImpact();
```

**Why**:
- Industry standard for notifications (WhatsApp, Telegram use similar)
- Distinctive from single tap feedback
- Not too aggressive (medium vs heavy impact)
- Clear beginning and end

### Visual-Only Preview

**Design**: Realistic notification banner
- App icon in colored circle
- Title: "Shift Starting Soon"
- Subtitle: "Your shift starts in 15 minutes"
- Auto-dismiss after 3 seconds

**Why**: Shows users exactly what visual-only notifications look like in real usage.

## User Experience Flow

### Discovery Phase
1. User opens Notifications Settings
2. Sees 4 alert mode options with descriptions
3. Natural curiosity to tap and explore

### Exploration Phase (Tap = Select + Preview)
1. User taps "Full Alerts"
   - ✅ Option becomes selected (checkmark + blue highlight)
   - 🔊 Hears gentle system sound
   - 📳 Feels double vibration pattern
2. User taps "Vibration Only"
   - ✅ Option becomes selected
   - 📳 Feels double vibration (no sound)
3. User taps "Visual Only"
   - ✅ Option becomes selected
   - 📱 Sees notification banner appear at bottom
   - 📳 Feels single light tap

### Decision Phase
1. User naturally explores by tapping different options
2. Each tap previews AND selects simultaneously
3. User settles on preferred mode - already selected!

## Context-Aware Timing

### When Alerts Trigger in Real App
- **Shift Reminders**: 15 minutes before shift start
- **Employee Late**: 5+ minutes after shift start
- **Attendance Issues**: Immediately when detected
- **Report Submissions**: When manager submits report

Visual preview uses realistic example: "Your shift starts in 15 minutes"

## Technical Implementation

### Files Modified
- [lib/features/my_page/presentation/pages/notifications_settings_page.dart](notifications_settings_page.dart)
  - Created `_playAlertPreview()`, `_playSound()`, `_playVibration()`, `_showVisualPreview()`
  - Updated `_buildAlertModeOption()` to call preview on tap
  - Integrated preview into selection flow

### Dependencies
- **System APIs**: `SystemSound.play()` for pleasant system notification sound
- **Haptic Feedback**: `HapticFeedback.mediumImpact()` and `lightImpact()`

### Design Simplification
- ✅ **No separate "Try" button** - tap the option itself
- ✅ **No audio files needed** - uses built-in system sounds
- ✅ **No preview state tracking** - immediate execution
- ✅ **Cleaner UI** - less visual clutter

## Accessibility Considerations

### Sound Selection
- ✅ System sound respects device volume settings
- ✅ Works with accessibility settings (VoiceOver, TalkBack)
- ✅ Short duration prevents disorientation

### Vibration Pattern
- ✅ Medium impact (not too strong)
- ✅ Clear pattern (distinguishable from UI interactions)
- ✅ Respects device vibration settings

### Visual Preview
- ✅ High contrast notification banner
- ✅ Clear text hierarchy
- ✅ Sufficient display time (3 seconds)
- ✅ Works with screen readers

## Future Enhancements

### Custom Sound Support
If system sound doesn't meet requirements:
1. Add pleasant notification.mp3 to `assets/sounds/`
2. Uncomment alternative code in `_playSound()` method
3. See `assets/sounds/notification_placeholder.txt` for sound selection guidelines

### Recommended Sound Characteristics
- Duration: 0.3-0.8 seconds
- Gentle attack (no sudden loud starts)
- Natural tones (bells, chimes, marimba, water drop)
- Mid-range frequency (not too high-pitched)
- Clean finish (no harsh ending)

### Sources for Pleasant Notification Sounds
- Freesound.org (CC0 license)
- Zapsplat.com (free sound effects)
- Apple System Sounds (gentle, familiar)

**Search Terms**: "gentle notification", "soft chime", "water drop", "positive notification"

## Testing Checklist

- [ ] Full Alerts mode plays sound + vibration
- [ ] Sound Only mode plays sound only
- [ ] Vibration Only mode vibrates only
- [ ] Visual Only mode shows banner + light haptic
- [ ] Preview button shows "Stop" icon while playing
- [ ] Preview auto-resets after 2 seconds
- [ ] Cannot trigger multiple previews simultaneously
- [ ] System sound respects device volume
- [ ] Vibration respects device settings
- [ ] Visual banner displays for 3 seconds
- [ ] Works on both iOS and Android
- [ ] Works with accessibility features enabled

## Performance Notes

- Minimal resource usage (system APIs)
- No audio file loading delays (uses system sounds)
- Automatic cleanup after 2 seconds
- Prevents preview spam with `_isPreviewPlaying` flag
- AudioPlayer properly disposed in widget lifecycle
