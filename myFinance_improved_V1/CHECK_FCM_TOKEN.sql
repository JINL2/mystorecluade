-- Check if FCM tokens are being saved
-- Run this in Supabase SQL Editor

-- 1. Check all FCM tokens
SELECT 
    id,
    user_id,
    token,
    platform,
    device_model,
    is_active,
    created_at,
    last_used_at
FROM user_fcm_tokens
ORDER BY created_at DESC
LIMIT 10;

-- 2. Check tokens for specific user (replace with your user_id)
SELECT * FROM user_fcm_tokens 
WHERE user_id = 'YOUR_USER_ID_HERE'
ORDER BY created_at DESC;

-- 3. Check active tokens count
SELECT 
    platform,
    COUNT(*) as token_count,
    COUNT(CASE WHEN is_active = true THEN 1 END) as active_count
FROM user_fcm_tokens
GROUP BY platform;

-- 4. Check recent notifications
SELECT 
    id,
    user_id,
    title,
    body,
    is_read,
    created_at
FROM notifications
ORDER BY created_at DESC
LIMIT 10;

-- 5. Check user notification settings
SELECT * FROM user_notification_settings
LIMIT 10;