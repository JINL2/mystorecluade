# FCM Token Troubleshooting Guide

## Current Issue
Your FCM tokens are not being stored in the `user_fcm_tokens` table, causing retry loops.

## Diagnostic Steps

### 1. Use the Debug Button (Recommended)
- Run your app in debug mode
- Go to the login page
- Click the "Debug FCM Token" button at the bottom
- This will show you exactly what's wrong with your table

### 2. Check Console Logs
Look for these enhanced debug messages:
```
🔍 Attempting to store FCM token for user: [userId], platform: [platform]
📊 Token data: {token details}
🔍 Existing token check: Found/Not found
```

Error messages will now tell you specifically:
- 🚨 Table or column issues
- 🔐 Authentication issues  
- 🔒 Permission/RLS issues
- ⚠️ Constraint violations

## Common Issues and Fixes

### Issue 1: RLS Policies Blocking Access
**Symptoms:**
- Insert/update operations return null
- Logs show "permission denied"

**Fix:**
Run `/sql/fix_fcm_token_rls.sql` in Supabase SQL Editor

### Issue 2: Missing Columns
**Symptoms:**
- "column does not exist" errors
- Insert fails with column errors

**Fix:**
The SQL script includes column creation commands (uncomment if needed)

### Issue 3: Table Doesn't Exist
**Symptoms:**
- "relation does not exist" errors
- Debug button shows "Table Exists: false"

**Fix:**
Run the table creation script from `/sql/create_user_fcm_tokens_table.sql`

## Quick Fix Steps

1. **Run the RLS fix script in Supabase:**
   ```sql
   -- In Supabase SQL Editor, run:
   /sql/fix_fcm_token_rls.sql
   ```

2. **Test with the debug button:**
   - Should show:
     - Table Exists: true
     - Can Select: true
     - Can Insert: true

3. **Monitor the logs:**
   - Look for: "✅ FCM token inserted successfully"
   - Or: "✅ FCM token updated successfully"

## What We've Improved

### Enhanced Error Logging
- Detailed error messages with specific issue identification
- Step-by-step logging of the storage process
- Automatic error categorization (RLS, auth, columns, etc.)

### Diagnostic Tool
- Added debug button to login page (debug mode only)
- Comprehensive table verification
- Test insert/select operations
- Specific recommendations based on issues found

### Fallback Mechanisms
- Returns minimal token model on failure (prevents crashes)
- Queues failed updates for retry
- Exponential backoff retry strategy

## Verification

After fixing, you should see:
1. No more retry loops in console
2. Success messages: "✅ FCM token inserted/updated successfully"
3. Tokens visible in Supabase dashboard under `user_fcm_tokens` table
4. Debug button shows all green checks

## Still Having Issues?

If problems persist after running the fix:

1. **Check Supabase Dashboard:**
   - Go to Authentication → Policies
   - Verify RLS is enabled on `user_fcm_tokens`
   - Check that policies exist for authenticated users

2. **Verify Table Structure:**
   - Ensure all columns match the expected structure
   - Check data types are correct (UUID for ids, TEXT for token, etc.)

3. **Test Manually in SQL Editor:**
   ```sql
   -- Test insert as authenticated user
   INSERT INTO user_fcm_tokens (
     user_id, token, platform, device_id, 
     device_model, app_version, is_active
   ) VALUES (
     auth.uid(), 'test_token', 'test', 'test_device',
     'test_model', '1.0.0', true
   );
   ```

## Success Indicators

✅ Console shows successful token storage  
✅ No retry loops  
✅ Tokens appear in Supabase dashboard  
✅ Debug diagnostics all pass  
✅ Push notifications work after login