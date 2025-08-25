# Transaction Templates Database Guide

## Overview
Transaction templates allow users to save and reuse common transaction patterns. The system tracks usage to provide quick access to frequently used templates.

---

## Database Structure

### 1. **transaction_templates** (Main Table)
Stores the actual transaction template data
```sql
CREATE TABLE transaction_templates (
    template_id UUID PRIMARY KEY,
    name TEXT NOT NULL,                        -- Template name
    data JSONB NOT NULL,                       -- Transaction entries (see structure below)
    template_description TEXT,                 -- Optional description
    
    -- Organization
    company_id UUID,                           -- Company this template belongs to
    store_id UUID,                             -- Store (if store-specific)
    
    -- Access Control
    visibility_level VARCHAR,                  -- 'private', 'public', 'company', 'store'
    permission VARCHAR,                         -- Role ID that has access
    updated_by UUID,                           -- Owner/creator of template
    
    -- Metadata
    tags JSONB,                                -- {accounts: [], categories: [], cash_locations: []}
    counterparty_id UUID,                      -- Default counterparty
    counterparty_cash_location_id UUID,        -- Default counterparty location
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

#### Transaction Data Structure (JSONB)
```json
[
  {
    "type": "debit",
    "account_id": "uuid",
    "account_name": "Cash",
    "account_type": "asset",
    "category_tag": "cash",
    "debit": 1000,
    "credit": 0,
    "amount": 1000,
    "description": "Payment received",
    "counterparty_id": "uuid",
    "counterparty_name": "Customer ABC",
    "cash_location_id": "uuid",
    "cash_location_name": "Main Bank",
    "counterparty_cash_location_id": "uuid"
  },
  {
    "type": "credit",
    "account_id": "uuid",
    "account_name": "Sales Revenue",
    "account_type": "income",
    "category_tag": "revenue",
    "debit": 0,
    "credit": 1000,
    "amount": 1000,
    "description": "Product sale",
    "counterparty_id": null,
    "counterparty_name": null,
    "cash_location_id": null,
    "cash_location_name": null,
    "counterparty_cash_location_id": null
  }
]
```

### 2. **transaction_templates_preferences** (Usage Tracking)
Tracks when users use templates
```sql
CREATE TABLE transaction_templates_preferences (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,                     -- Who used it
    company_id UUID NOT NULL,                  -- In which company context
    template_id UUID NOT NULL,                 -- Which template
    template_name VARCHAR,                     -- Cached template name
    template_type VARCHAR,                     -- 'transaction', 'expense', 'income'
    usage_type VARCHAR,                        -- 'selected', 'used', 'edited', 'created'
    used_at TIMESTAMP,                         -- When it was used
    metadata JSONB,                            -- Additional context
    created_at TIMESTAMP
);
```

---

## Functions for Template Management

### 1. **Log Template Usage**
Track when a template is used
```sql
-- Function Call
SELECT log_template_usage(
    p_template_id := 'uuid',
    p_template_name := 'Monthly Rent Payment',
    p_company_id := 'uuid',
    p_template_type := 'expense',
    p_usage_type := 'selected',
    p_metadata := '{"source": "quick_access"}'
);
```

**Flutter Implementation:**
```dart
// Track when user selects a template
await supabase.rpc('log_template_usage', params: {
  'p_template_id': templateId,
  'p_template_name': 'Monthly Rent Payment',
  'p_company_id': companyId,
  'p_template_type': 'expense',
  'p_usage_type': 'selected',
  'p_metadata': jsonEncode({'source': 'quick_access'}),
});
```

### 2. **Get Top Templates (Quick Access)**
Get frequently used templates for quick access
```sql
-- Function Call
SELECT get_user_quick_access_templates(
    p_user_id := 'uuid',
    p_company_id := 'uuid',
    p_limit := 5  -- Top 5 templates
);
```

**Returns:**
```json
[
  {
    "template_id": "uuid",
    "template_name": "Monthly Rent Payment",
    "visibility_level": "private",
    "permission": "role_uuid",
    "usage_count": 15,
    "last_used": "2025-01-20T10:30:00Z"
  },
  {
    "template_id": "uuid",
    "template_name": "Salary Payment",
    "visibility_level": "company",
    "permission": null,
    "usage_count": 12,
    "last_used": "2025-01-19T14:20:00Z"
  }
]
```

**Flutter Implementation:**
```dart
// Get top 5 templates
final quickTemplates = await supabase.rpc('get_user_quick_access_templates', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
  'p_limit': 5,
});

// Display in UI
for (var template in quickTemplates) {
  print('Template: ${template['template_name']}');
  print('Used ${template['usage_count']} times');
  print('Last used: ${template['last_used']}');
}
```

---

## Complete Usage Flow

### Step 1: Create a Template
```dart
// Save a new template
final newTemplate = await supabase
  .from('transaction_templates')
  .insert({
    'name': 'Monthly Rent Payment',
    'data': [
      {
        'type': 'debit',
        'account_id': rentExpenseAccountId,
        'account_name': 'Rent Expense',
        'debit': 5000,
        'credit': 0,
        'description': 'Monthly office rent',
      },
      {
        'type': 'credit',
        'account_id': cashAccountId,
        'account_name': 'Cash',
        'debit': 0,
        'credit': 5000,
        'description': 'Payment for rent',
      }
    ],
    'company_id': companyId,
    'visibility_level': 'private',
    'tags': {
      'accounts': [rentExpenseAccountId, cashAccountId],
      'categories': ['expense', 'cash'],
    },
    'is_active': true,
  })
  .select()
  .single();
```

### Step 2: Get Quick Access Templates
```dart
// Load frequently used templates
final quickTemplates = await supabase.rpc('get_user_quick_access_templates', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
  'p_limit': 5,
});

// Display in dropdown or quick access panel
```

### Step 3: Load Full Template Data
```dart
// When user selects a template
final selectedTemplateId = quickTemplates[0]['template_id'];

// Fetch full template data
final fullTemplate = await supabase
  .from('transaction_templates')
  .select('*')
  .eq('template_id', selectedTemplateId)
  .single();

// Extract transaction data
final transactionEntries = fullTemplate['data'] as List;
```

### Step 4: Track Template Usage
```dart
// Log that template was selected
await supabase.rpc('log_template_usage', params: {
  'p_template_id': selectedTemplateId,
  'p_template_name': fullTemplate['name'],
  'p_company_id': companyId,
  'p_usage_type': 'selected',
});

// After creating transaction from template
await supabase.rpc('log_template_usage', params: {
  'p_template_id': selectedTemplateId,
  'p_template_name': fullTemplate['name'],
  'p_company_id': companyId,
  'p_usage_type': 'used',
  'p_metadata': jsonEncode({
    'transaction_id': createdTransactionId,
    'amount': totalAmount,
  }),
});
```

---

## View: top_templates_by_user

Aggregates template usage data for quick access

**What it does:**
1. Analyzes last 180 days of usage
2. Calculates usage score with recency bonus:
   - Last 7 days: +15 points
   - Last 30 days: +8 points
   - Last 90 days: +3 points
   - Older: +1 point
3. Returns top 8 templates per user per company

**Query the view directly:**
```dart
// Alternative: Query the view directly
final topTemplates = await supabase
  .from('top_templates_by_user')
  .select('top_templates')
  .eq('user_id', userId)
  .eq('company_id', companyId)
  .single();

final templates = topTemplates['top_templates'] as List;
```

---

## Visibility Levels Explained

| Level | Description | Who Can Access |
|-------|-------------|----------------|
| `private` | Only owner can see/use | Template creator only |
| `company` | All company members | Anyone in the same company |
| `store` | Store members only | Users assigned to specific store |
| `public` | Everyone | All users in system |

---

## Performance Optimization

### Indexes
```sql
-- Already created indexes
CREATE INDEX idx_templates_company ON transaction_templates(company_id);
CREATE INDEX idx_templates_active ON transaction_templates(is_active);
CREATE INDEX idx_preferences_user_company ON transaction_templates_preferences(user_id, company_id);
CREATE INDEX idx_preferences_template ON transaction_templates_preferences(template_id);
CREATE INDEX idx_preferences_used_at ON transaction_templates_preferences(used_at DESC);
```

### Best Practices

1. **Lazy Loading**: Only fetch full template data when needed
```dart
// DON'T: Load all template data upfront
final allTemplates = await supabase
  .from('transaction_templates')
  .select('*');  // Heavy query

// DO: Load IDs first, then fetch selected
final quickAccess = await supabase.rpc('get_user_quick_access_templates', ...);
// Then fetch specific template when selected
```

2. **Cache Template Data**: Store frequently used templates locally
```dart
class TemplateCache {
  static final Map<String, dynamic> _cache = {};
  
  static Future<dynamic> getTemplate(String templateId) async {
    if (_cache.containsKey(templateId)) {
      return _cache[templateId];
    }
    
    final template = await supabase
      .from('transaction_templates')
      .select('*')
      .eq('template_id', templateId)
      .single();
    
    _cache[templateId] = template;
    return template;
  }
}
```

3. **Batch Usage Tracking**: Don't track every micro-interaction
```dart
// Track meaningful actions only
- When template is actually used to create transaction ✓
- When template is selected from list ✓
- Not when hovering or viewing ✗
```

---

## Security Notes

1. **RLS Policies** are enabled on both tables
2. Users can only see their own usage data
3. Template visibility respects company/store boundaries
4. Use `SECURITY DEFINER` functions for controlled access

---

## Cleanup & Maintenance

Run periodically to clean old data:
```sql
-- Remove usage data older than 1 year
DELETE FROM transaction_templates_preferences
WHERE used_at < NOW() - INTERVAL '365 days';

-- Deactivate unused templates
UPDATE transaction_templates
SET is_active = false
WHERE template_id NOT IN (
  SELECT DISTINCT template_id 
  FROM transaction_templates_preferences
  WHERE used_at > NOW() - INTERVAL '180 days'
);
```
