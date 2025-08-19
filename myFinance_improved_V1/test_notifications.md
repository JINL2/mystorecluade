# 📱 Push Notification Testing Guide

## Prerequisites Checklist
- [ ] Firebase project configured (notification-f1653)
- [ ] GoogleService-Info.plist in ios/Runner/
- [ ] APNs key uploaded to Firebase
- [ ] Supabase tables created
- [ ] Physical iPhone connected
- [ ] App permissions enabled

## 🚀 Quick Test Steps

### Step 1: Build and Run
```bash
# Clean build
flutter clean
flutter pub get
cd ios && pod install && cd ..

# Run on physical device
flutter run --debug
```

### Step 2: Check Console Output
Look for these logs in terminal:
```
🔥 Initializing Firebase...
✅ Firebase initialized
🚀 Initializing Notification Service...
📱 APNs Token: [token]
🔑 FCM Token: [token]
✅ Notification Service initialized successfully
```

### Step 3: Access Debug Dashboard

#### Option A: Direct Navigation
Add this temporary code to any button in your app:
```dart
onPressed: () => context.go('/notification-debug'),
```

#### Option B: URL Navigation
If you have a way to navigate by URL, go to:
```
/notification-debug
```

### Step 4: Debug Dashboard Tests

On the debug dashboard, verify:

1. **System Status**
   - ✅ Initialized: Should show "Active"
   - ✅ Push Enabled: Should show "Active"

2. **Tokens**
   - FCM Token: Should display a long token string
   - APNs Token: Should display (iOS only)

3. **Test Actions**
   - Click "Send Test Notification"
   - You should see a local notification appear

### Step 5: Firebase Console Test

1. Go to [Firebase Console](https://console.firebase.google.com/project/notification-f1653)
2. Navigate to "Cloud Messaging"
3. Click "Create your first campaign" or "New campaign"
4. Choose "Notifications"
5. Fill in:
   - Title: "Test from Firebase"
   - Text: "This is a test notification"
6. Click "Send test message"
7. Paste your FCM token from the debug dashboard
8. Click "Test"

### Step 6: Check Supabase

1. Go to your Supabase dashboard
2. Check the `user_fcm_tokens` table
3. You should see your token stored there

## 🔍 Troubleshooting

### No FCM Token Generated?
```bash
# Check these:
1. Is GoogleService-Info.plist in ios/Runner/?
2. Bundle ID matches: com.mycompany.luxappv1
3. Running on physical device (not simulator)
4. Check Xcode console for errors
```

### Notification Not Showing?
```bash
# Check:
1. App has notification permissions (Settings > Your App > Notifications)
2. Phone is not in Do Not Disturb mode
3. Check debug dashboard logs
4. Try sending while app is in background
```

### APNs Token Issues?
```bash
# Verify:
1. Push Notifications capability added in Xcode
2. Provisioning profile includes push notifications
3. APNs key in Firebase supports both environments
```

### Environment Detection
The debug dashboard will show:
- 🔨 Development: When running from Xcode
- 📲 TestFlight: When installed via TestFlight
- 🏪 App Store: When from App Store

## 📊 What Success Looks Like

1. **Debug Dashboard Shows:**
   - ✅ All green status indicators
   - FCM token displayed
   - APNs token displayed (iOS)
   - Test notification works

2. **Console Shows:**
   - No errors
   - Tokens generated
   - "Notification Service initialized successfully"

3. **Firebase Test:**
   - Notification received on device
   - Shows in notification center

4. **Supabase Shows:**
   - Token stored in database
   - User ID correctly linked

## 🎯 Next Steps After Testing

1. **Test Different App States:**
   - Foreground (app open)
   - Background (app minimized)
   - Terminated (app closed)

2. **Test Notification Types:**
   - Data-only messages
   - Notification + data
   - Silent notifications

3. **Production Testing:**
   - Archive and upload to TestFlight
   - Test with production APNs

## 💡 Pro Tips

1. **Keep Console Open**: Watch for real-time logs
2. **Use Debug Dashboard**: It's your best friend for troubleshooting
3. **Test on Multiple Devices**: Different iOS versions may behave differently
4. **Document Your Tokens**: Save FCM tokens for testing

## 🆘 Common Error Messages

### "No valid 'aps-environment' entitlement"
- Add Push Notifications capability in Xcode

### "The certificate is not valid for the current environment"
- Your APNs key needs to support both Sandbox and Production

### "MismatchSenderId"
- GoogleService-Info.plist doesn't match Firebase project

### "InvalidRegistration"
- FCM token is malformed or expired

---

**Ready?** Start with Step 1 and work through each step. The debug dashboard at `/notification-debug` is your control center!