# Alert Mode Preview - Testing Checklist

## Testing Instructions

### Prerequisites
- Device volume should be audible (30%+ for sound testing)
- Vibration should be enabled in device settings
- App has necessary permissions

### Test Scenarios

## ✅ Test 1: Full Alerts Mode
**Steps:**
1. Open Notifications Settings
2. Tap on "Full Alerts" option
3. **Expected Results:**
   - ✓ Option becomes selected (blue background + checkmark)
   - ✓ You HEAR system notification sound
   - ✓ You FEEL double vibration pattern (buzz-pause-buzz)

**Pass Criteria:** Sound + Vibration both work

---

## ✅ Test 2: Sound Only Mode
**Steps:**
1. Tap on "Sound Only" option
2. **Expected Results:**
   - ✓ Option becomes selected
   - ✓ You HEAR system notification sound
   - ✗ NO vibration

**Pass Criteria:** Sound works, no vibration

---

## ✅ Test 3: Vibration Only Mode
**Steps:**
1. Tap on "Vibration Only" option
2. **Expected Results:**
   - ✓ Option becomes selected
   - ✗ NO sound
   - ✓ You FEEL double vibration pattern

**Pass Criteria:** Vibration works, no sound

---

## ✅ Test 4: Visual Only Mode
**Steps:**
1. Tap on "Visual Only" option
2. **Expected Results:**
   - ✓ Option becomes selected
   - ✗ NO sound
   - ✗ NO strong vibration (only light tap)
   - ✓ Notification banner slides down from TOP of screen
   - ✓ Banner shows: "Shift Starting Soon - Your shift starts in 15 minutes"
   - ✓ Banner has dark background with app icon
   - ✓ Banner auto-dismisses after 3 seconds

**Pass Criteria:** Visual banner appears at top, minimal haptic feedback

---

## Cross-Device Testing

### iOS Devices
| Device | iOS Version | Full Alerts | Sound Only | Vibration Only | Visual Only | Status |
|--------|-------------|-------------|------------|----------------|-------------|--------|
| iPhone 14 Pro | 17.x | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| iPhone 13 | 16.x | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| iPhone 12 | 15.x | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| iPad Pro | 17.x | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

**iOS-Specific Notes:**
- System sound uses `SystemSoundType.alert` (iOS native sound)
- Vibration uses `HapticFeedback.mediumImpact()` (iOS haptic engine)
- Visual banner respects safe area (notch, dynamic island)

---

### Android Devices
| Device | Android Version | Full Alerts | Sound Only | Vibration Only | Visual Only | Status |
|--------|-----------------|-------------|------------|----------------|-------------|--------|
| Pixel 8 | 14 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Samsung S23 | 13 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| OnePlus 11 | 13 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Xiaomi 13 | 12 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

**Android-Specific Notes:**
- System sound plays Android notification sound
- Vibration uses Android vibration API
- Visual banner respects status bar height
- Some manufacturers (Samsung, Xiaomi) have custom vibration engines

---

## Device Settings to Check

### iOS Settings
1. **Sound:**
   - Settings → Sounds & Haptics → Volume slider
   - Ensure "Change with Buttons" is ON

2. **Vibration:**
   - Settings → Sounds & Haptics → Vibrate on Ring/Silent should be ON

3. **Do Not Disturb:**
   - Make sure DND is OFF during testing

### Android Settings
1. **Sound:**
   - Settings → Sound & Vibration → Volume
   - Ensure "Notification volume" is up

2. **Vibration:**
   - Settings → Sound & Vibration → Vibration & haptics
   - Ensure vibration is enabled

3. **Do Not Disturb:**
   - Make sure DND is OFF during testing

---

## Troubleshooting

### Sound Not Playing
**iOS:**
- Check if Silent mode switch is ON (orange indicator)
- Increase volume with physical buttons
- Check Settings → Sounds & Haptics

**Android:**
- Check notification volume (separate from media volume)
- Settings → Sound & Vibration → Notification volume
- Some devices have separate DND for notifications

### Vibration Not Working
**iOS:**
- Check Settings → Sounds & Haptics → Vibrate on Ring
- Try restarting device (some iOS updates disable haptics)

**Android:**
- Settings → Sound & Vibration → Vibration intensity
- Some devices have per-app vibration settings
- Samsung: Settings → Sounds and vibration → Vibration intensity → Notifications

### Visual Banner Not Appearing
**All Devices:**
- Check if another overlay is blocking (e.g., system dialog)
- Try restarting the app
- Check console for errors: `flutter logs`

**iOS:**
- Ensure app has notification permissions (even though this is in-app)

**Android:**
- Ensure "Draw over other apps" permission is granted (for overlay)

---

## Expected Behavior Summary

| Mode | Sound | Vibration | Visual | Haptic |
|------|-------|-----------|--------|--------|
| **Full Alerts** | ✅ System sound | ✅ Double (strong) | ❌ | ❌ |
| **Sound Only** | ✅ System sound | ❌ | ❌ | ❌ |
| **Vibration Only** | ❌ | ✅ Double (strong) | ❌ | ❌ |
| **Visual Only** | ❌ | ❌ | ✅ Top banner | ✅ Light tap |

---

## Performance Testing

### Response Time
- Tap → Preview should start within **100ms**
- No lag or delay
- Smooth animations

### Battery Impact
- Minimal battery drain during normal usage
- System sounds and haptics are low-power

### Memory Usage
- No memory leaks from repeated previews
- Overlay properly disposed after 3 seconds

---

## Regression Testing

After each app update, verify:
- [ ] All 4 alert modes still work
- [ ] Sound respects device volume
- [ ] Vibration respects device settings
- [ ] Visual banner appears at correct position
- [ ] No crashes or errors in console

---

## Accessibility Testing

### VoiceOver (iOS) / TalkBack (Android)
- [ ] Each alert mode is announced properly
- [ ] Selection state is communicated
- [ ] Visual banner content is readable by screen reader

### Reduced Motion
- [ ] Visual banner animation respects reduced motion settings
- [ ] System → Accessibility → Reduce Motion

### Hearing Accessibility
- [ ] Visual Only mode provides full notification experience without sound
- [ ] Banner provides all necessary information

---

## Production Checklist

Before releasing to users:
- [ ] All 4 modes tested on iOS
- [ ] All 4 modes tested on Android
- [ ] Tested on at least 2 iOS versions
- [ ] Tested on at least 2 Android versions
- [ ] Tested with various device settings (silent mode, DND, etc.)
- [ ] Performance is smooth (<100ms response)
- [ ] No console errors or warnings
- [ ] Accessibility features work correctly
- [ ] Battery impact is minimal

---

## Bug Reporting Template

If you find issues, report with:
```
**Device:** [e.g., iPhone 14 Pro, Samsung S23]
**OS Version:** [e.g., iOS 17.2, Android 13]
**Alert Mode:** [Full Alerts, Sound Only, Vibration Only, Visual Only]
**Issue:** [Describe what's not working]
**Expected:** [What should happen]
**Actual:** [What actually happens]
**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]
**Console Logs:** [Any error messages]
```

---

## Notes

- **System Sounds:** Flutter's `SystemSound.play()` uses platform-native notification sounds, so they will sound slightly different on iOS vs Android
- **Haptic Feedback:** Intensity and feel vary by device manufacturer and model
- **Visual Banner:** Position respects safe areas, so appearance may vary on devices with notches, dynamic islands, or punch-holes
