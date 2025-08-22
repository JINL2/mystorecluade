# 📱 FCM Notification Testing Guide

## ✅ Pre-Test Checklist

### 1. Database Setup
- [x] Tables exist: `notifications`, `user_fcm_tokens`, `user_notification_settings`
- [x] RLS is currently disabled for testing (as per SUPABASE_datastructure.md)
- [x] Tables have proper indexes and triggers

### 2. Code Fixes Applied
- [x] ✅ FCM token refresh implementation fixed in `fcm_service.dart`
- [x] ✅ NotificationService initialized via provider in `app.dart`
- [x] ✅ Debug page created at `/lib/presentation/pages/debug/notification_debug_page.dart`
- [x] ✅ Debug route added: `/debug/notifications`

## 🔧 Testing Steps for Physical Devices

### Step 1: Access Debug Page
```
1. Login to your app
2. Navigate to: /debug/notifications
3. You should see the Notification Debug page
```

### Step 2: Initialize & Verify
1. **Click "Initialize Service"**
   - Should show: ✅ Notification service initialized successfully
   - FCM Token should appear in Debug Information

2. **Click "Verify Supabase"**
   - Should show: ✅ Supabase connection verified

3. **Click "Store Token"**
   - Should show: ✅ FCM token stored successfully
   - Token should appear in "Saved FCM Tokens" section

### Step 3: Verify Token in Supabase
```sql
-- Run this query in Supabase SQL Editor
SELECT * FROM user_fcm_tokens 
WHERE user_id = 'YOUR_USER_ID' 
ORDER BY created_at DESC;
```

### Step 4: Test Notifications
1. **Local Test**:
   - Click "Send Test" button
   - Should receive a local notification immediately

2. **FCM Test** (requires backend):
   ```bash
   # Using Firebase Admin SDK or Postman
   POST https://fcm.googleapis.com/fcm/send
   Authorization: key=YOUR_SERVER_KEY
   Content-Type: application/json
   
   {
     "to": "FCM_TOKEN_FROM_DEBUG_PAGE",
     "notification": {
       "title": "Test from FCM",
       "body": "This is a test notification"
     }
   }
   ```

### Step 5: Token Refresh Test
1. **Force Token Refresh**:
   - Delete app and reinstall
   - Check if new token is saved automatically

2. **Verify Old Token Deactivation**:
   ```sql
   SELECT token, is_active, platform, last_used_at 
   FROM user_fcm_tokens 
   WHERE user_id = 'YOUR_USER_ID' 
   ORDER BY created_at DESC;
   ```

## 📊 Debug Information Explained

### FCM Token States
- **null**: Firebase not initialized or permissions denied
- **Simulator token**: Running on simulator (starts with "simulator_")
- **Real token**: Valid FCM token from physical device

### Platform Detection
- **ios**: iOS device
- **android**: Android device
- **macos/windows/linux**: Desktop (FCM may not work)

### Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| No FCM token | 1. Check Firebase configuration<br>2. Ensure permissions granted<br>3. Not on simulator |
| Token not saved | 1. Check user authentication<br>2. Verify Supabase connection<br>3. Check console logs |
| Not receiving notifications | 1. Check notification permissions<br>2. Verify FCM token is active<br>3. Check APNs configuration (iOS) |
| Token refresh not working | 1. Check console logs for errors<br>2. Verify _updateTokenInBackend implementation<br>3. Check Supabase connection |

## 🔍 Monitoring Commands

### Check Logs
```bash
# iOS
flutter run --verbose | grep -E "FCM|notification|token"

# Android
adb logcat | grep -E "FCM|FirebaseMessaging"
```

### Database Monitoring
```sql
-- Check active tokens
SELECT COUNT(*) as active_tokens 
FROM user_fcm_tokens 
WHERE is_active = true;

-- Check recent notifications
SELECT * FROM notifications 
ORDER BY created_at DESC 
LIMIT 10;

-- Check user settings
SELECT * FROM user_notification_settings 
WHERE user_id = 'YOUR_USER_ID';
```

## 🚀 Production Checklist

Before going to production:

1. **Enable RLS**:
   ```sql
   -- Enable Row Level Security
   ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
   ALTER TABLE user_fcm_tokens ENABLE ROW LEVEL SECURITY;
   ALTER TABLE user_notification_settings ENABLE ROW LEVEL SECURITY;
   ```

2. **Remove Debug Logs**:
   - Remove all `print()` statements
   - Set `NotificationConfig.debugMode = false`

3. **Implement Token Cleanup**:
   ```sql
   -- Schedule this to run daily
   SELECT cleanup_old_fcm_tokens();
   ```

4. **Test on Multiple Devices**:
   - [ ] iPhone (various models)
   - [ ] Android (various manufacturers)
   - [ ] Different OS versions

5. **Verify APNs Configuration** (iOS):
   - [ ] Upload APNs certificate to Firebase
   - [ ] Test on TestFlight build
   - [ ] Verify production APNs works

## 📝 Test Results Template

```markdown
Device: [iPhone 13 Pro / Samsung Galaxy S22]
OS Version: [iOS 16.5 / Android 13]
App Version: [1.0.0]
Date: [2025-01-22]

Token Generation: ✅/❌
Token Storage: ✅/❌
Local Notifications: ✅/❌
FCM Notifications: ✅/❌
Token Refresh: ✅/❌
Background Notifications: ✅/❌

Notes:
[Any issues or observations]
```

## 🆘 Troubleshooting

### iOS Specific
- Ensure APNs entitlement is added
- Check provisioning profile includes push notifications
- Verify Firebase has APNs authentication key

### Android Specific
- Check google-services.json is up to date
- Verify package name matches Firebase project
- Ensure notification channel is created (Android 8+)

### Firebase Console Test
1. Go to Firebase Console > Cloud Messaging
2. Click "Send your first message"
3. Enter test message
4. Target your app
5. Send to FCM token from debug page

## 📞 Support Resources

- Firebase Documentation: https://firebase.google.com/docs/cloud-messaging
- Supabase Documentation: https://supabase.com/docs
- Flutter FCM Plugin: https://pub.dev/packages/firebase_messaging

---

**Last Updated**: 2025-01-22
**Status**: Ready for Physical Device Testing