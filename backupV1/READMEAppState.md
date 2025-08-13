# 🚨 App State Structure Documentation - CRITICAL REFERENCE

## ⚠️ CRITICAL RULES - READ FIRST

### 🔒 **IMMUTABLE REQUIREMENTS**
1. **NEVER MODIFY** this documentation without explicit direct command from the user
2. **ALWAYS APPLY** this app state structure identically across ALL pages and features
3. **MANDATORY CONSISTENCY** - Every developer must implement exactly the same structure

---

## 📋 App State Overview

This document defines the **EXACT** app state structure that must be implemented consistently across the entire application. All AI assistants and developers must follow this structure precisely.

### 🎯 **Required App States**

| State Name | Type | Persistence | Purpose |
|------------|------|-------------|---------|
| `categoryFeatures` | `dynamic` (JSON Array) | ✅ SharedPreferences | Categories with their associated features |
| `user` | `dynamic` (JSON Object) | ✅ SharedPreferences | User information with companies and stores |
| `companyChoosen` | `String` | ✅ SharedPreferences | Currently selected company ID |
| `storeChoosen` | `String` | ✅ SharedPreferences | Currently selected store ID |

---

## 1️⃣ categoryFeatures

### **Purpose**
Stores all available categories and their associated features from the `get_categories_with_features()` RPC function.

### **Data Type**
```dart
dynamic // Raw JSON array from Supabase RPC
```

### **JSON Structure**
```json
// ⚠️ EXAMPLE DATA - Actual structure from get_categories_with_features() RPC
[
  {
    "category_id": "7eff79e6-6aa1-4f4b-bbd4-0a3b24b14605",
    "category_name": "Human Resources",
    "features": [
      {
        "feature_id": "f01b3856-c1fa-47f7-9941-63e354081923",
        "feature_name": "Delegate Role",
        "icon": "https://atkekzwgukdvucqntryo.supabase.co/storage/v1/object/public/icon/feature_icon/delegateRolePage.png",
        "route": "delegateRolePage"
      },
      {
        "feature_id": "4a0c90b6-7099-4d76-88b2-783302e1248f",
        "feature_name": "Employee Setting",
        "icon": "https://atkekzwgukdvucqntryo.supabase.co/storage/v1/object/public/icon/feature_icon/employeeSetting.png",
        "route": "employeeSetting"
      }
    ]
  },
  {
    "category_id": "68ba790c-d8d6-43bd-8dab-5fcb34934503",
    "category_name": "Finance",
    "features": [
      {
        "feature_id": "6e527ba2-9421-4243-a0f9-2497f5ed9772",
        "feature_name": "Account Mapping",
        "icon": "https://atkekzwgukdvucqntryo.supabase.co/storage/v1/object/public/icon/feature_icon/accountmapping.png",
        "route": "accountMapping"
      }
    ]
  }
]
```

### **Properties**
- **Persistence**: ✅ Saved to SharedPreferences
- **Default Value**: `[]` (empty array)
- **Source**: Supabase RPC `get_categories_with_features()`
- **Update**: Replace entire array when fetching from API

### **Implementation Notes**
- Store the EXACT JSON structure returned from RPC
- DO NOT modify or transform the data structure
- Access nested features using JSON path navigation

---

## 2️⃣ user

### **Purpose**
Stores complete user information including profile, companies, stores, and permissions from `get_user_companies_and_stores(user_id)` RPC function.

### **Data Type**
```dart
dynamic // Raw JSON object from Supabase RPC
```

### **JSON Structure**
```json
// ⚠️ EXAMPLE DATA - Actual structure from get_user_companies_and_stores(user_id) RPC
{
  "user_id": "005b6ebf-8784-4ef1-9481-4210152c25f5",
  "profile_image": "https://atkekzwgukdvucqntryo.supabase.co/storage/v1/object/public/icon/main_icon/person-svgrepo-com.png",
  "user_first_name": "Phuong",
  "user_last_name": "Thy",
  "company_count": 1,
  "companies": [
    {
      "role": {
        "role_id": "1c736b33-9578-4185-91ad-84f6c15bfb98",
        "role_name": "Admin",
        "permissions": [
          "0808e763-51a0-4f88-b470-f552e4a90113",
          "247a7896-ea5c-49b7-afec-94b500093cd4"
        ]
      },
      "stores": [
        {
          "store_id": "b895965a-cfc5-4b69-9313-e3c746f67200",
          "store_code": "a8a4e21aea",
          "store_name": "Cameraon Nha Trang",
          "store_phone": ""
        },
        {
          "store_id": "3e4e6093-4aca-46e7-ae78-8354269f897f",
          "store_code": "3c9780a7d8",
          "store_name": "Headsup Nha Trang",
          "store_phone": ""
        }
      ],
      "company_id": "ebd66ba7-fde7-4332-b6b5-0d8a7f615497",
      "store_count": 4,
      "company_code": "8437b11a3a",
      "company_name": "Cameraon&Headsup"
    }
  ]
}
```

### **Properties**
- **Persistence**: ✅ Saved to SharedPreferences
- **Default Value**: `{}` (empty object)
- **Source**: Supabase RPC `get_user_companies_and_stores(user_id)`
- **Update**: Replace entire object when fetching from API

### **Key Data Points**
- **User Profile**: `user_id`, `user_first_name`, `user_last_name`, `profile_image`
- **Company Information**: Array of companies with full details
- **Store Access**: Each company contains array of accessible stores
- **Permissions**: Role-based permissions as array of feature IDs

### **Implementation Notes**
- Store the EXACT JSON structure returned from RPC
- DO NOT modify or transform the data structure
- Use for authentication, authorization, and company/store selection

---

## 3️⃣ companyChoosen

### **Purpose**
Stores the currently selected company ID for filtering data throughout the app. This selection persists across app sessions to provide a consistent user experience.

### **Data Type**
```dart
String
```

### **Properties**
- **Persistence**: ✅ Saved to SharedPreferences
- **Default Value**: `''` (empty string)
- **Source**: User selection from available companies in `user.companies`
- **Update**: Set when user selects a company from sidebar menu or company selector

### **Validation**
- Must be a valid `company_id` from the user's accessible companies
- Must exist in `user.companies[].company_id`

### **Implementation Notes**
- Persisted to SharedPreferences for consistent experience across app sessions
- Should be validated against user's company access
- Used for filtering company-specific data throughout the app
- Updated whenever user changes company selection in sidebar menu

---

## 4️⃣ storeChoosen

### **Purpose**
Stores the currently selected store ID for filtering data throughout the app. This selection persists across app sessions to provide a consistent user experience.

### **Data Type**
```dart
String
```

### **Properties**
- **Persistence**: ✅ Saved to SharedPreferences
- **Default Value**: `''` (empty string)
- **Source**: User selection from available stores in selected company
- **Update**: Set when user selects a store from sidebar menu or store selector

### **Validation**
- Must be a valid `store_id` from the selected company's stores
- Must exist in `user.companies[].stores[].store_id` where company matches `companyChoosen`

### **Implementation Notes**
- Persisted to SharedPreferences for consistent experience across app sessions
- Should be validated against selected company's store access
- Used for filtering store-specific data throughout the app
- Updated whenever user changes store selection in sidebar menu

---

## 🔧 Implementation Guidelines

### **Riverpod Provider Structure**
```dart
// Example provider structure (adapt to your framework)
@riverpod
class AppState extends _$AppState {
  @override
  AppStateModel build() {
    return AppStateModel(
      categoryFeatures: [],
      user: {},
      companyChoosen: '',
      storeChoosen: '',
    );
  }

  // Update methods
  void setCategoryFeatures(dynamic features) {
    state = state.copyWith(categoryFeatures: features);
    // Save to SharedPreferences
  }

  void setUser(dynamic userData) {
    state = state.copyWith(user: userData);
    // Save to SharedPreferences
  }

  void setCompanyChoosen(String companyId) {
    state = state.copyWith(companyChoosen: companyId);
    // Save to SharedPreferences
  }

  void setStoreChoosen(String storeId) {
    state = state.copyWith(storeChoosen: storeId);
    // Save to SharedPreferences
  }
}
```

### **Data Access Patterns**
```dart
// Accessing categoryFeatures
final categories = ref.watch(appStateProvider).categoryFeatures;
final features = categories[0]['features'];

// Accessing user data
final user = ref.watch(appStateProvider).user;
final companies = user['companies'];
final firstName = user['user_first_name'];

// Accessing current selections
final currentCompany = ref.watch(appStateProvider).companyChoosen;
final currentStore = ref.watch(appStateProvider).storeChoosen;
```

### **Persistence Rules**
- **SAVE to SharedPreferences**: `categoryFeatures`, `user`, `companyChoosen`, `storeChoosen`
- **ALL states are now persisted for consistent user experience**

### **JSON Handling**
- Store RPC responses as-is (no transformation)
- Use `jsonEncode()` and `jsonDecode()` for persistence
- Access nested properties using map notation

---

## ⚠️ CRITICAL REMINDERS

### 🚫 **NEVER DO**
1. Modify this documentation without explicit user command
2. Change the JSON structure or data types
3. Add custom transformation to RPC responses
4. Implement different structures across different pages
5. Clear companyChoosen/storeChoosen on app restart

### ✅ **ALWAYS DO**
1. Use identical structure across ALL features and pages
2. Store exact JSON from RPC functions
3. Validate company/store selections against user access
4. Handle empty/null states gracefully
5. Follow persistence rules exactly
6. Persist ALL four app states to SharedPreferences
7. Update companyChoosen/storeChoosen when user makes selections in sidebar

---

## 📞 Support

If you need to modify this structure, request explicit approval from the project owner. This documentation serves as the single source of truth for app state management across the entire application.

**Last Updated**: Generated from Supabase RPC analysis
**Version**: 1.0.0
**Status**: IMMUTABLE - DO NOT MODIFY