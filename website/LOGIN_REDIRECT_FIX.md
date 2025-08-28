# Login Redirect Fix Documentation

## Problem
User logs in at: `http://localhost/mcparrange-main/myFinance_claude/website/pages/auth/login.html`
But gets redirected to: `http://localhost/mcparrange-main/pages/auth/login.html` (WRONG - missing myFinance_claude/website)

## Root Causes Identified
1. **Relative paths** (`../dashboard/index.html`) were being resolved incorrectly
2. **AuthManager** was competing with login.js for redirect control
3. **Race condition** between multiple redirect mechanisms

## Solutions Applied

### 1. Fixed getDashboardPath() in login.js
- Now ALWAYS uses absolute paths when in mcparrange-main structure
- Extracts base path and builds complete path: `/mcparrange-main/myFinance_claude/website/pages/dashboard/index.html`
- No more relative path confusion

### 2. Disabled AuthManager Redirects on Login Page
- AuthManager.handleSignIn() now checks if on login page and returns early
- Added multiple checks to ensure login page detection
- Added flag system to prevent interference

### 3. Added Redirect Guards
- Prevents double redirects with `isRedirecting` flag
- Session storage flag `loginPageRedirecting` to coordinate between scripts
- Comprehensive logging to debug any issues

## Testing Instructions

1. Clear browser cache and cookies
2. Open browser console (F12)
3. Navigate to: `http://localhost/mcparrange-main/myFinance_claude/website/pages/auth/login.html`
4. Enter credentials and click "Sign In"
5. Check console for debug output:
   - Should see: "=== LOGIN REDIRECT DEBUG ==="
   - Should see: "Calculated dashboard path: /mcparrange-main/myFinance_claude/website/pages/dashboard/index.html"
   - Should see: "=== AUTHMANAGER REDIRECT BLOCKED ==="

## Expected Result
After login, user should be redirected to:
`http://localhost/mcparrange-main/myFinance_claude/website/pages/dashboard/index.html`

## Debug Output in Console
```
getDashboardPath - Current path: /mcparrange-main/myFinance_claude/website/pages/auth/login.html
getDashboardPath - Built absolute path: /mcparrange-main/myFinance_claude/website/pages/dashboard/index.html
=== LOGIN REDIRECT DEBUG ===
Current URL: http://localhost/mcparrange-main/myFinance_claude/website/pages/auth/login.html
Calculated dashboard path: /mcparrange-main/myFinance_claude/website/pages/dashboard/index.html
EXECUTING REDIRECT NOW to: /mcparrange-main/myFinance_claude/website/pages/dashboard/index.html
```

## Files Modified
1. `/pages/auth/assets/login.js` - Fixed getDashboardPath() to use absolute paths
2. `/core/config/supabase.js` - Disabled AuthManager redirects on login page
3. `/core/utils/page-init.js` - Fixed path calculation for other pages

## If Still Having Issues
1. Check browser console for any JavaScript errors
2. Look for "EXECUTING REDIRECT NOW to:" message - verify the path is correct
3. Check if any browser extensions are interfering
4. Try in incognito/private browsing mode
5. Clear all site data and try again