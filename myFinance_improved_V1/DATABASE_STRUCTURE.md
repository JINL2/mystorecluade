# Database Structure & Functions Reference

## Core Tables

### user_preferences
Tracks user feature clicks for personalization
```sql
- id: UUID (PK)
- user_id: UUID (FK → auth.users)
- company_id: UUID (FK → companies) 
- feature_id: UUID
- feature_name: VARCHAR
- category_id: UUID
- clicked_at: TIMESTAMP
- created_at: TIMESTAMP
```

### accounts_preferences
Tracks user account usage patterns
```sql
- id: UUID (PK)
- user_id: UUID (FK → auth.users)
- company_id: UUID (FK → companies)
- account_id: UUID
- account_name: VARCHAR
- account_type: VARCHAR
- usage_type: VARCHAR (clicked/selected/created_transaction)
- used_at: TIMESTAMP
- metadata: JSONB
- created_at: TIMESTAMP
```

### transaction_templates_preferences
Tracks template usage patterns
```sql
- id: UUID (PK)
- user_id: UUID (FK → auth.users)
- company_id: UUID (FK → companies)
- template_id: UUID (FK → transaction_templates)
- template_name: VARCHAR
- template_type: VARCHAR
- usage_type: VARCHAR (used/edited/created/selected)
- used_at: TIMESTAMP
- metadata: JSONB
- created_at: TIMESTAMP
```

### transaction_templates (existing table)
Stores actual transaction template data
```sql
- template_id: UUID (PK)
- name: TEXT
- data: JSONB (transaction entries with accounts/amounts)
- company_id: UUID
- store_id: UUID
- visibility_level: VARCHAR (private/public/company/store)
- permission: VARCHAR (role_id that has access)
- tags: JSONB (accounts, categories, cash_locations)
- is_active: BOOLEAN
- updated_by: UUID (owner)
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

---

## Views

### top_features_by_user
Returns top 6 most used features per user per company
```sql
SELECT: user_id, company_id, top_features (JSON array)
- Filters: Last 90 days, existing features only
- Validation: INNER JOIN ensures feature still exists
- Requirements: Feature must have valid route and is_show_main=true
- Ordering: Click count DESC, last_clicked DESC
- Limit: 6 features per user/company
```

### top_accounts_by_user
Returns top 10 most used accounts with recency weighting
```sql
SELECT: user_id, company_id, top_accounts (JSON array)
- Filters: Last 180 days, existing accounts only
- Validation: Checks if account still exists in system
- Scoring: usage_count + recency_bonus (7/30/90 days)
- Returns: Only accounts where exists_in_system=true
- Limit: 10 accounts per user/company
```

### top_templates_by_user
Returns top 8 most used templates (minimal data)
```sql
SELECT: user_id, company_id, top_templates (JSON array)
- Filters: Last 180 days, active templates only
- Validation: INNER JOIN ensures template exists and is_active=true
- Scoring: usage_count + recency_bonus (7/30/90 days)
- Limit: 8 templates per user/company
- Returns: template_id, name, visibility_level, permission only
```

---

## RPC Functions

### log_feature_click
Logs when user clicks a feature
```dart
await supabase.rpc('log_feature_click', params: {
  'p_feature_id': UUID,        // Required
  'p_feature_name': String,     // Required
  'p_company_id': UUID,         // Required
  'p_category_id': UUID,        // Optional
});
```
**Purpose**: Track feature usage for Quick Access personalization

---

### log_account_usage
Logs account interactions
```dart
await supabase.rpc('log_account_usage', params: {
  'p_account_id': UUID,         // Required
  'p_account_name': String,     // Required
  'p_company_id': UUID,         // Required
  'p_account_type': String,     // Optional (expense/income/asset/liability)
  'p_usage_type': String,       // Default: 'clicked'
  'p_metadata': JSONB,          // Optional additional data
});
```
**Purpose**: Track account usage patterns

---

### log_template_usage
Logs template interactions
```dart
await supabase.rpc('log_template_usage', params: {
  'p_template_id': UUID,        // Required
  'p_template_name': String,    // Required
  'p_company_id': UUID,         // Required
  'p_template_type': String,    // Optional
  'p_usage_type': String,       // Default: 'used'
  'p_metadata': JSONB,          // Optional
});
```
**Purpose**: Track template usage patterns

---

### get_user_companies_and_stores
Gets all companies and stores for a user
```dart
final result = await supabase.rpc('get_user_companies_and_stores', params: {
  'p_user_id': UUID,            // Required
});

// Returns:
{
  'user_id': UUID,
  'user_email': String,
  'user_first_name': String,
  'user_last_name': String,
  'company_count': Integer,
  'companies': [
    {
      'company_id': UUID,
      'company_name': String,
      'company_code': String,
      'role': {
        'role_id': UUID,
        'role_name': String,
        'permissions': [feature_ids...]
      },
      'stores': [
        {
          'store_id': UUID,
          'store_name': String,
          'store_address': String
        }
      ]
    }
  ]
}
```
**Purpose**: Get user's complete organizational structure with permissions

---

### get_categories_with_features
Gets all feature categories with their features
```dart
final result = await supabase.rpc('get_categories_with_features_v2');

// Returns:
[
  {
    'category_id': UUID,
    'category_name': String,
    'features': [
      {
        'feature_id': UUID,
        'feature_name': String,
        'icon': String,
        'icon_key': String,
        'route': String,
        'is_show_main': Boolean
      }
    ]
  }
]
```
**Purpose**: Get all available features organized by category

---

### get_user_quick_access_features
Gets user's frequently used features
```dart
final result = await supabase.rpc('get_user_quick_access_features', params: {
  'p_user_id': UUID,            // Required
  'p_company_id': UUID,         // Required
});

// Returns: JSON array
[
  {
    'feature_id': UUID,
    'feature_name': String,
    'icon': String,
    'icon_key': String,
    'route': String,
    'click_count': Integer,
    'last_clicked': Timestamp,
    'is_default': Boolean
  }
]
```
**Purpose**: Get top 6 most used features for Quick Access display

---

### get_user_quick_access_accounts
Gets frequently used accounts
```dart
final result = await supabase.rpc('get_user_quick_access_accounts', params: {
  'p_user_id': UUID,            // Required
  'p_company_id': UUID,         // Required
  'p_limit': Integer,           // Default: 6
});

// Returns: JSON array
[
  {
    'account_id': UUID,
    'account_name': String,
    'account_type': String,
    'usage_count': Integer,
    'last_used': Timestamp,
    'usage_score': Float
  }
]
```
**Purpose**: Get frequently used accounts for quick selection

---

### get_user_quick_access_templates
Gets frequently used templates (minimal data)
```dart
final result = await supabase.rpc('get_user_quick_access_templates', params: {
  'p_user_id': UUID,            // Required
  'p_company_id': UUID,         // Required
  'p_limit': Integer,           // Default: 5
});

// Returns: JSON array
[
  {
    'template_id': UUID,          // Use this to fetch full template data
    'template_name': String,
    'visibility_level': String,   // private/public/company/store
    'permission': UUID,           // Role ID that has access
    'usage_count': Integer,
    'last_used': Timestamp
  }
]
```
**Purpose**: Get frequently used template IDs with permission info only
**Note**: Fetch full transaction data separately using template_id when needed

---

### Usage Pattern for Templates

#### 1. Get Quick Access Templates (minimal data)
```dart
// Get frequently used template IDs
final quickTemplates = await supabase.rpc('get_user_quick_access_templates', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
});

// Result: [{template_id, template_name, visibility_level, permission}]
```

#### 2. Fetch Full Template Data When Needed
```dart
// When user selects a template, fetch full data
final templateData = await supabase
  .from('transaction_templates')
  .select('*')
  .eq('template_id', selectedTemplateId)
  .single();

// Now you have full transaction data
final transactionData = templateData['data'];
```

#### 3. Track Template Usage
```dart
// Log when template is used
await supabase.rpc('log_template_usage', params: {
  'p_template_id': templateId,
  'p_template_name': templateName,
  'p_company_id': companyId,
  'p_usage_type': 'selected',
});
```

---

### get_user_financial_quick_access
Combined function for accounts and templates
```dart
final result = await supabase.rpc('get_user_financial_quick_access', params: {
  'p_user_id': UUID,            // Required
  'p_company_id': UUID,         // Required
  'p_account_limit': Integer,   // Default: 6
  'p_template_limit': Integer,  // Default: 5
});

// Returns:
{
  'quick_accounts': [...],      // Array of accounts
  'quick_templates': [...],     // Array of templates
  'generated_at': Timestamp
}
```
**Purpose**: Get both accounts and templates in one call (reduces network requests)

---

### cleanup_old_financial_preferences
Removes old preference data
```dart
final result = await supabase.rpc('cleanup_old_financial_preferences');

// Returns:
{
  'accounts_deleted': Integer,
  'templates_deleted': Integer,
  'cleanup_date': Timestamp
}
```
**Purpose**: Clean up data older than 1 year for performance

---

## Usage Patterns

### 1. Track User Activity
```dart
// When user clicks a feature
await supabase.rpc('log_feature_click', params: {
  'p_feature_id': featureId,
  'p_feature_name': 'Employee Management',
  'p_company_id': companyId,
  'p_category_id': categoryId,
});

// When user selects an account
await supabase.rpc('log_account_usage', params: {
  'p_account_id': accountId,
  'p_account_name': 'Cash Account',
  'p_company_id': companyId,
  'p_account_type': 'asset',
  'p_usage_type': 'selected',
});
```

### 2. Load Quick Access Data
```dart
// On homepage load
final quickFeatures = await supabase.rpc('get_user_quick_access_features', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
});

// On transaction page load
final financialQuickAccess = await supabase.rpc('get_user_financial_quick_access', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
});
```

### 3. Initial App Load
```dart
// Get user's companies and permissions
final userData = await supabase.rpc('get_user_companies_and_stores', params: {
  'p_user_id': userId,
});

// Get all available features
final categories = await supabase.rpc('get_categories_with_features_v2');

// Filter features by user permissions
final userPermissions = userData['companies'][0]['role']['permissions'];
final allowedFeatures = categories.where((category) {
  final features = category['features'].where((f) => 
    userPermissions.contains(f['feature_id'])
  );
  return features.isNotEmpty;
});
```

---

## Cleanup & Maintenance Functions

### cleanup_orphaned_feature_preferences
Removes preferences for deleted features
```dart
final result = await supabase.rpc('cleanup_orphaned_feature_preferences');
// Returns: {deleted_count: Integer}
```

### cleanup_orphaned_account_preferences
Removes preferences for deleted accounts
```dart
final result = await supabase.rpc('cleanup_orphaned_account_preferences');
// Returns: {deleted_count: Integer}
```

### cleanup_orphaned_template_preferences
Removes preferences for deleted/inactive templates
```dart
final result = await supabase.rpc('cleanup_orphaned_template_preferences');
// Returns: {deleted_count: Integer}
```

### cleanup_all_orphaned_preferences
Master cleanup for all orphaned preferences
```dart
final result = await supabase.rpc('cleanup_all_orphaned_preferences');
// Returns:
{
  'features_deleted': Integer,
  'accounts_deleted': Integer,
  'templates_deleted': Integer,
  'cleanup_date': Timestamp
}
```
**Purpose**: Run periodically (e.g., weekly) to clean orphaned references

---

## Important Notes

1. **Always include company_id**: All preference functions require company_id for multi-tenant isolation

2. **User context**: Functions using `auth.uid()` automatically get current user, no need to pass user_id for logging functions

3. **Recency weighting**: Views prioritize recently used items (last 7/30/90 days get bonus points)

4. **Performance**: All tables have proper indexes on (user_id, company_id) for fast queries

5. **Security**: RLS policies ensure users can only access their own data

6. **Data Integrity**: 
   - Views use INNER JOIN to exclude deleted items
   - Functions check if items still exist before returning
   - Run cleanup functions periodically to remove orphaned preferences

7. **Handling Deletions**:
   - When feature/account/template is deleted, preferences remain
   - Views automatically filter out non-existent items
   - Cleanup functions remove orphaned preferences
