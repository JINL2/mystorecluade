# iOS Push Notification Setup Guide

## Current Status
✅ Local notifications work
❌ Firebase push notifications not working

## Required Steps to Fix

### 1. Configure APNs Authentication Key in Firebase Console

**Go to Apple Developer Console:**
1. Visit https://developer.apple.com/account
2. Navigate to Certificates, Identifiers & Profiles
3. Go to Keys section
4. Create new key with "Apple Push Notifications service (APNs)" enabled
5. Download the .p8 file and note the Key ID

**Upload to Firebase Console:**
1. Visit https://console.firebase.google.com
2. Select your project: `notification-f1653`
3. Go to Project Settings → Cloud Messaging tab
4. Under "Apple app configuration", find your iOS app
5. Upload APNs Authentication Key (.p8 file)
6. Enter Key ID and Team ID from Apple Developer account

### 2. Enable Push Notifications Capability in Xcode

1. Open Xcode project:
```bash
open /Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1/ios/Runner.xcworkspace
```

2. Select Runner target
3. Go to "Signing & Capabilities" tab
4. Click "+ Capability"
5. Add "Push Notifications" capability
6. Ensure "Background Modes" is enabled with "Remote notifications" checked

### 3. Verify Bundle Identifier

**Current Configuration:**
- Bundle ID: `com.storebase.app`
- Firebase iOS App ID: `1:204633647743:ios:deb0f3c99fa71951a12d4a`

**Verify in Firebase Console:**
1. Check that bundle ID matches exactly
2. Ensure app is properly registered

### 4. Test Push Notification

**Option A: Firebase Console Test**
1. Go to Firebase Console → Messaging
2. Create new notification
3. Target your iOS app
4. Send test message

**Option B: Using FCM Token**
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "FCM_TOKEN_FROM_DEBUG_PAGE",
    "notification": {
      "title": "Test Push",
      "body": "This is a Firebase push notification"
    }
  }'
```

### 5. Debug Checklist

- [ ] APNs Authentication Key uploaded to Firebase
- [ ] Push Notifications capability enabled in Xcode
- [ ] Background Modes → Remote notifications enabled
- [ ] Bundle ID matches Firebase configuration
- [ ] FCM token is being retrieved (check debug page)
- [ ] Device is not on simulator (push doesn't work on simulator)
- [ ] Notification permissions granted in iOS Settings

### 6. Common Issues & Solutions

**Issue**: No FCM token on device
**Solution**: Ensure Firebase is initialized and device has internet

**Issue**: Token received but notifications not showing
**Solution**: APNs key not configured in Firebase Console

**Issue**: Works in development but not production
**Solution**: Ensure APNs key is configured for both environments

### 7. Testing on Physical Device

Push notifications ONLY work on physical iOS devices, not simulators.
Connect your iPhone/iPad and run:

```bash
flutter run --release
```

## Current Code Status

✅ AppDelegate.swift - Firebase initialization enabled
✅ Info.plist - Background modes configured
✅ Runner.entitlements - Push notifications entitlement set
✅ GoogleService-Info.plist - Firebase configuration present
✅ NotificationService - Properly implemented
✅ FCM Service - Token handling implemented

## Next Steps

1. **Immediate Action Required**: Upload APNs Authentication Key to Firebase Console
2. Enable Push Notifications capability in Xcode if not already enabled
3. Test on physical device (not simulator)
4. Monitor FCM token in debug page
5. Send test notification from Firebase Console

## Support Resources

- [Firebase iOS Setup](https://firebase.google.com/docs/cloud-messaging/ios/client)
- [APNs Setup Guide](https://firebase.google.com/docs/cloud-messaging/ios/certs)
- [Troubleshooting Guide](https://firebase.google.com/docs/cloud-messaging/ios/troubleshooting)