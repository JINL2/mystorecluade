# 🗺 Route System Guide

> **CRITICAL**: Routes are the bridge between Supabase features and your app pages. Mismatched routes = broken navigation.

---

## 🔴 Route System Architecture

```yaml
DATA_FLOW:
  1. Supabase features table stores routes
  2. App fetches features via RPC
  3. Homepage displays features with routes
  4. User clicks → Navigate using route
  5. GoRouter matches route → Shows page

SYNC_REQUIREMENT:
  Supabase.features.route === GoRouter.path
  MUST match EXACTLY (case-sensitive)
```

---

## 📋 How to Add a New Route

### Step 1: Add to Supabase
```sql
INSERT INTO features (
  feature_name,
  route,
  icon,
  category_id
) VALUES (
  'Your Feature Name',
  'yourFeatureRoute',  -- camelCase, no 'Page' suffix
  'https://your-icon-url',
  'category-uuid-here'
);
```

### Step 2: Add to Router
```dart
// File: /lib/presentation/app/app_router.dart

// 1. Import your page
import '../pages/your_feature/your_feature_page.dart';

// 2. Add route (inside routes array)
GoRoute(
  path: 'yourFeatureRoute',  // MUST match Supabase exactly
  builder: (context, state) => const YourFeaturePage(),
),
```

### Step 3: Verify
```yaml
TEST_CHECKLIST:
□ Feature appears in homepage menu?
□ Clicking navigates to correct page?
□ No "route not found" errors?
□ Route works after app restart?
```

---

## 🚫 Common Route Errors

### Error 1: Feature Not Showing
```yaml
SYMPTOM: Feature missing from homepage
CAUSE: Not in Supabase features table
FIX: Insert into features table with correct category_id
```

### Error 2: Click Does Nothing
```yaml
SYMPTOM: Clicking feature has no effect
CAUSE: Route empty in Supabase
FIX: Update features.route with correct value
```

### Error 3: Route Not Found
```yaml
SYMPTOM: "Could not find a generator for route"
CAUSE: Route not in app_router.dart
FIX: Add GoRoute with matching path
```

### Error 4: Wrong Page Opens
```yaml
SYMPTOM: Different page opens than expected
CAUSE: Route mismatch or duplicate routes
FIX: Verify exact match between Supabase and router
```

---

## 📐 Naming Conventions

### ✅ CORRECT Route Names
```yaml
attendance         # Simple, clear
employeeSetting    # camelCase for multi-word
cashEnding         # Descriptive action
balanceSheet       # Domain term
```

### ❌ WRONG Route Names
```yaml
attendancePage     # Don't add 'Page'
employee_setting   # Don't use underscore
employee-setting   # Don't use hyphen
EmployeeSetting    # Don't use PascalCase
```

---

## 🔄 Route Synchronization

### Manual Check
1. List all routes in Supabase:
```sql
SELECT feature_name, route 
FROM features 
ORDER BY route;
```

2. Compare with app_router.dart routes
3. Fix any mismatches

### Debugging Routes
```dart
// Add to homepage to debug
print('Supabase route: ${feature['route']}');
print('Navigating to: /$route');
```

---

## 📊 Route State Flow

```
User Login
    ↓
Fetch features from Supabase
    ↓
Store in AppState.categoryFeatures
    ↓
Homepage reads categoryFeatures
    ↓
Display features with routes
    ↓
User clicks feature
    ↓
Read route from feature data
    ↓
context.push('/${route}')
    ↓
GoRouter matches path
    ↓
Display corresponding page
```

---

## 🛠 Route Utilities

### Get All Routes
```dart
// To see all registered routes
final router = ref.read(appRouterProvider);
router.configuration.routes.forEach((route) {
  print(route.path);
});
```

### Validate Route Exists
```dart
bool isRouteValid(String route) {
  try {
    context.push(route);
    return true;
  } catch (e) {
    return false;
  }
}
```

---

## 📚 Related Files

```yaml
SUPABASE_FEATURES:
  table: features
  columns: feature_id, feature_name, route, icon, category_id

ROUTER_FILE:
  path: /lib/presentation/app/app_router.dart
  
HOMEPAGE:
  path: /lib/presentation/pages/homepage/homepage_redesigned.dart
  method: _handleFeatureTap()
  
ROUTE_MAPPING:
  docs: /docs/ROUTE_MAPPING_TABLE.md
```

---

**REMEMBER**: Every route must exist in BOTH places. No exceptions.