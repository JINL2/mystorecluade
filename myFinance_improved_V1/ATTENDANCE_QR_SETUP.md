# Attendance QR Scanner Setup Guide

## Overview
The attendance system uses QR codes for employees to check in and out of their shifts. This document explains the setup and fixes applied.

## Changes Made

### 1. QR Scanner Page Improvements
- **Single Scan Prevention**: Added `hasScanned` flag to prevent multiple scans of the same QR code
- **Camera Control**: Camera stops after successful scan and only restarts on errors
- **Centered Success Popup**: Replaced bottom snackbar with centered success dialog
- **Auto-close**: Success dialog auto-closes after 2 seconds and returns to attendance page

### 2. QR Code Format
The QR code should contain only the store ID (UUID format):
```
d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff
```

### 3. RPC Parameters
The `update_shift_requests_v3` RPC function receives:
- `p_user_id`: User's UUID from auth state
- `p_store_id`: Store UUID from scanned QR code  
- `p_request_date`: Current date in `yyyy-MM-dd` format
- `p_time`: Current timestamp in ISO 8601 format
- `p_lat`: Device location latitude
- `p_lng`: Device location longitude

### 4. Activity List Auto-refresh
After successful QR scan:
1. The QR scanner returns `true` to the attendance page
2. The attendance page calls `_fetchMonthData()` to refresh the activity list
3. The shift overview provider is also refreshed

## Database Setup

### Step 1: Add Location Columns (if not exists)
Run the SQL script in `/sql/add_location_columns.sql`:
```sql
ALTER TABLE shift_requests 
ADD COLUMN IF NOT EXISTS checkin_lat DOUBLE PRECISION;
-- ... (see full script)
```

### Step 2: Create RPC Function
Run the SQL script in `/sql/update_shift_requests_v3_simple.sql`:
```sql
CREATE OR REPLACE FUNCTION public.update_shift_requests_v3(
  p_user_id UUID,
  p_store_id UUID,
  p_request_date DATE,
  p_time TEXT,
  p_lat DOUBLE PRECISION,
  p_lng DOUBLE PRECISION
)
RETURNS JSON
-- ... (see full script)
```

### Step 3: Grant Permissions
```sql
GRANT EXECUTE ON FUNCTION public.update_shift_requests_v3 TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_shift_requests_v3 TO anon;
```

## Testing the Flow

1. **Generate QR Code**: Create a QR code containing the store UUID
2. **Approve Shift**: Ensure the user has an approved shift for today
3. **Scan QR**: Click "Scan QR" button and scan the code
4. **Check Results**: 
   - Success popup should appear in center of screen
   - Activity list should update automatically
   - Console logs will show RPC parameters and response

## Debugging

Enable console logging to see:
- QR code content parsed
- RPC parameters sent
- RPC response received
- Action determined (check-in vs check-out)

Check the Flutter console for lines starting with:
```
========================================
Calling update_shift_requests_v3 RPC
========================================
```

## Common Issues

### "No approved shift found"
- User doesn't have an approved shift for today
- Check the shift_requests table for the user's shifts

### "RPC function does not exist"
- Run the SQL script to create the function
- Check Supabase dashboard for the function

### Multiple Scans Issue
- Fixed by adding `hasScanned` flag
- Camera stops after successful scan

### Activity Not Updating
- Fixed by calling refresh methods after successful scan
- Check that QR scanner returns `true` on success