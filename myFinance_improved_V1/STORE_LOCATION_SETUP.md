# Store Location Feature Setup Guide

## Overview
This guide documents the implementation of the store location feature that allows setting GPS coordinates for stores, which are used for employee check-in/out validation.

## Features Implemented
1. **Choose Location Tap** - Added under Operational Settings in Store Settings tab
2. **Location Permission Handling** - Requests and manages location permissions
3. **GPS Coordinate Capture** - Gets current device location with high accuracy
4. **Database Integration** - Stores location in PostGIS GEOGRAPHY format
5. **Visual Feedback** - Shows location status and coordinates

## UI Changes
### Store Settings Tab (`store_shift_page.dart`)
- Added new "Store Location" config option under Operational Settings
- Displays current location status or prompts to set location
- Tappable item opens location setting dialog

## Database Setup

### 1. Deploy SQL Functions to Supabase

Execute the following SQL functions in your Supabase SQL Editor:

#### Update Store Location Function
```sql
-- File: supabase/functions/update_store_location.sql
-- Run this in Supabase SQL Editor

CREATE OR REPLACE FUNCTION update_store_location(
  p_store_id UUID,
  p_store_lat DOUBLE PRECISION,
  p_store_lng DOUBLE PRECISION
) RETURNS VOID AS $$
BEGIN
  UPDATE stores
  SET 
    store_location = ST_SetSRID(ST_MakePoint(p_store_lng, p_store_lat), 4326)::geography,
    updated_at = NOW()
  WHERE store_id = p_store_id;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Store with ID % not found', p_store_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION update_store_location(UUID, DOUBLE PRECISION, DOUBLE PRECISION) TO authenticated;
```

#### Get Store Location Function (Optional)
```sql
-- File: supabase/functions/get_store_location.sql
-- Run this in Supabase SQL Editor

CREATE OR REPLACE FUNCTION get_store_location(p_store_id UUID)
RETURNS TABLE(
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    ST_Y(store_location::geometry) AS latitude,
    ST_X(store_location::geometry) AS longitude
  FROM stores
  WHERE store_id = p_store_id
    AND store_location IS NOT NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_store_location(UUID) TO authenticated;
```

### 2. Verify PostGIS Extension
Ensure PostGIS extension is enabled in your Supabase database:
```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

## Implementation Details

### Location Permission Flow
1. User taps "Store Location" option
2. App requests location permission
3. If denied, shows error with option to open settings
4. If granted, proceeds to get current location

### Location Capture Process
1. Shows loading dialog while fetching GPS coordinates
2. Gets high-accuracy position using Geolocator
3. Displays coordinates and accuracy in confirmation dialog
4. User can confirm or cancel location setting

### Database Storage
- Location stored as PostGIS GEOGRAPHY type
- Format: POINT(longitude latitude) with SRID 4326
- Enables spatial queries for check-in distance validation

## Dependencies
The following packages are used (already in pubspec.yaml):
- `geolocator: ^11.0.0` - For GPS location services
- `permission_handler: ^11.3.1` - For managing permissions
- `supabase_flutter` - For database operations

## Platform Configuration

### iOS (Info.plist)
Add these permissions if not already present:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to set store location for employee check-in</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs location access to validate employee check-in/out</string>
```

### Android (AndroidManifest.xml)
Add these permissions if not already present:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## Testing

### Manual Testing Steps
1. Navigate to Store Settings page
2. Select "Store Settings" tab
3. Look for "Store Location" under Operational Settings
4. Tap on "Store Location"
5. Grant location permission when prompted
6. Wait for location to be fetched
7. Confirm location in the dialog
8. Verify success message appears
9. Check that location subtitle updates to "Location set - Tap to update"

### Verification in Database
After setting location, verify in Supabase:
```sql
-- Check if location was saved
SELECT 
  store_id,
  store_name,
  ST_AsText(store_location) as location_wkt,
  ST_Y(store_location::geometry) as latitude,
  ST_X(store_location::geometry) as longitude
FROM stores
WHERE store_id = 'YOUR_STORE_ID';
```

## How It Works with Check-in

The stored location is used with the `allowed_distance` field to validate employee check-ins:

```sql
-- Example check-in validation
SELECT 
  ST_Distance(
    store_location,
    ST_SetSRID(ST_MakePoint(check_lng, check_lat), 4326)::geography
  ) as distance_meters
FROM stores
WHERE store_id = 'STORE_ID';

-- Valid if: distance_meters <= allowed_distance
```

## Troubleshooting

### Location Permission Issues
- Ensure app has location permissions in device settings
- For iOS simulator, set a custom location in Debug > Location menu
- For Android emulator, use extended controls to set location

### Database Errors
- Verify PostGIS extension is enabled
- Check that RPC functions are deployed
- Ensure user has execute permissions on functions

### GPS Accuracy
- Location accuracy depends on device and environment
- Indoor locations may have lower accuracy
- Consider adding a manual coordinate entry option for edge cases

## Future Enhancements
1. **Map View** - Show location on a map for visual confirmation
2. **Address Geocoding** - Convert coordinates to readable address
3. **Manual Entry** - Allow entering coordinates manually
4. **Multiple Locations** - Support for stores with multiple check-in points
5. **Location History** - Track location changes over time