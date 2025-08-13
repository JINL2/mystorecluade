# MyFinance Homepage Documentation

## Overview
This document provides comprehensive information about the homepage of the MyFinance (Lux App v1) FlutterFlow application, including its structure, widgets, API calls, and necessary components for replication.

## Application Structure

### Base Information
- **App Name**: Lux App v1
- **Framework**: Flutter with FlutterFlow
- **Backend**: Supabase
- **Authentication**: Supabase Auth

## Homepage Component Details

### File Location
`lib/homepage/homepage_widget.dart`

### Route Configuration
- **Route Name**: `homepage`
- **Route Path**: `/homepage`
- **Parameters**:
  - `firstLogin` (bool) - Indicates if this is the user's first login
  - `companyclicked` (bool) - Indicates if a company was clicked
  - `storeclicked` (bool) - Indicates if a store was clicked

## Key Widgets and Components

### 1. Main Page Structure

#### AppBar Section
- **Menu Icon**: Opens drawer with company/store selection
- **User Greeting**: Displays "Hello! {user_first_name}"
- **Profile Image**: Circular avatar (40x40) - clickable to edit
- **Company Info**: Shows current company name
- **Store Info**: Shows current store name (if selected)
- **Logout Button**: Signs out user
- **Sync Button**: Refreshes user data

#### Drawer Menu
Contains:
- Company list (using `DrawerListViewWidget`)
- Add Company button
- Add Store button (only for Owners)
- Add By Code button (join company by code)
- Show Code button (display company code)

#### Main Content Area
- Categories list with features grid
- Uses `HomeCateListViewV1Widget` for each category
- Features displayed in 3-column grid layout

### 2. Child Components Used

1. **DrawerListViewWidget** (`jeong_work/drawer_list_view/`)
   - Displays company information in drawer

2. **HomeCateListViewV1Widget** (`jeong_work/home_cate_list_view_v1/`)
   - Displays category with its features
   - Features filtered by user permissions

3. **HomeFeatureV1Widget** (`jeong_work/home_feature_v1/`)
   - Individual feature card in grid

4. **AddWidget** (`jeong_work/add/`)
   - Reusable add button component

5. **PopupWidget** (`jeong_work/popup/`)
   - Modal popup container

6. **IsloadingWidget** (`components/`)
   - Loading overlay

### 3. Popup Modals

1. **EditProfileNameWidget** - Edit user's first/last name
2. **EditProfileImageWidget** - Update profile picture
3. **CreateCompanyF1Widget** - Create new company
4. **CreateStoreF1Widget** - Create new store
5. **CreateCompanyByCodeF1Widget** - Join company by code
6. **CreateCodeF1Widget** - Display company invitation code

## API Endpoints

### Supabase Configuration
- **URL**: `https://atkekzwgukdvucqntryo.supabase.co`
- **API Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8`

### Primary API Calls

1. **GetUserCompaniesCall**
   - Endpoint: `/rest/v1/rpc/get_user_companies`
   - Method: POST
   - Parameters: `p_user_id`
   - Returns: User data with companies and stores

2. **GetCategoriesWithFeaturesCall**
   - Endpoint: `/rest/v1/rpc/get_categories_with_features`
   - Method: GET
   - Returns: List of categories with their features

## Data Models

### UserStruct
```dart
{
  user_id: String,
  user_first_name: String,
  user_last_name: String,
  company_count: int,
  companies: List<CompaniesStruct>,
  profile_image: String
}
```

### CompaniesStruct
```dart
{
  company_id: String,
  company_name: String,
  role: RoleStruct,
  stores: List<StoresStruct>
}
```

### CategoryFeaturesStruct
```dart
{
  category_id: String,
  category_name: String,
  features: List<FeaturesStruct>
}
```

### FeaturesStruct
```dart
{
  feature_id: String,
  feature_name: String,
  feature_route: String,
  feature_icon: String
}
```

## State Management

### App State Variables
- `user`: UserStruct - Current user data
- `companyChoosen`: String - Selected company ID
- `storeChoosen`: String - Selected store ID
- `categoryFeatures`: List<CategoryFeaturesStruct> - Available features
- `localMyCompanyCount`: int - Company count cache
- `isLoading1`, `isLoading2`, `isLoading3`: bool - Loading states

## Navigation Flow

1. On first login:
   - Fetch user companies
   - Fetch categories with features
   - Set default company and store

2. On subsequent visits:
   - Check if company count changed
   - Update data if needed
   - Maintain selected company/store

3. Company/Store switching:
   - Via drawer menu selection
   - Updates global state
   - Refreshes page with new context

## Permission System

Features are filtered based on user's role permissions:
- Each role has a list of permitted feature IDs
- Features only display if user's role includes the feature ID
- Owner role typically has access to all features

## Styling and Theme

- Primary color scheme from `FlutterFlowTheme`
- Font: Noto Sans JP (Google Fonts)
- Responsive layouts with MediaQuery
- Consistent spacing using EdgeInsets

## Key Implementation Notes

1. **Loading States**: Three separate loading states for different operations
2. **Error Handling**: Alert dialogs for API failures
3. **State Persistence**: Uses FFAppState for global state management
4. **Offline Support**: None - requires active internet connection
5. **Security**: Role-based access control at feature level
6. **Localization**: Currently Japanese-focused (Noto Sans JP font)

## Required Dependencies

From pubspec.yaml:
- Flutter SDK
- FlutterFlow dependencies
- Supabase Flutter client
- Google Fonts
- Provider for state management

## Testing Considerations

1. Test with multiple companies/stores
2. Verify role-based permissions
3. Test offline behavior
4. Validate API error handling
5. Check responsive design on various screen sizes