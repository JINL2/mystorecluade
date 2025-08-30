# Supabase Database Structure Documentation - Lux Project

## Project Metadata
```yaml
project_id: atkekzwgukdvucqntryo
database_type: PostgreSQL (Supabase)
total_tables: 52  # Updated with notification tables
last_updated: 2025-01-14
primary_key_type: UUID (gen_random_uuid())
changelog:
  - 2025-01-14: Added detailed notification system documentation
  - 2025-01-14: Added 5 notification-related tables (notifications, user_notification_settings, user_fcm_tokens, fcm_cleanup_logs, sent_shift_notifications)
  - 2025-01-14: Added notification workflow, FCM token management, and notification triggers
  - 2025-01-13: Initial comprehensive documentation
```

## Database Overview

### Table Categories and Relationships

```
CORE_SYSTEM
├── users (central user management)
├── companies (organization entities)
├── company_types (company classifications)
├── stores (physical locations/branches)
├── roles (permission roles)
├── user_roles (user-role associations)
├── user_companies (user-company associations)
└── user_stores (user-store associations)

FINANCIAL_ACCOUNTING
├── accounts (chart of accounts)
├── journal_entries (transaction headers)
├── journal_lines (transaction details)
├── fiscal_years (accounting years)
├── fiscal_periods (accounting periods)
├── counterparties (customers/vendors)
├── account_mappings (inter-company mappings)
├── journal_attachments (supporting documents)
└── journal_templates (reusable templates)

CASH_MANAGEMENT
├── cash_locations (cash storage points)
├── cash_control (cash reconciliation)
├── cashier_amount_lines (cash counting details)
├── bank_amount (bank balance records)
└── vault_amount_line (vault cash details)

CURRENCY_EXCHANGE
├── currency_types (currency definitions)
├── currency_denominations (bill/coin values)
├── book_exchange_rates (exchange rates)
└── company_currency (company-currency links)

HR_PAYROLL
├── user_salaries (salary configurations)
├── shift_requests (attendance/scheduling)
├── store_shifts (shift definitions)
└── shift_edit_logs (shift modification history)

ASSET_INVENTORY
├── fixed_assets (capital assets)
├── depreciation_methods (depreciation rules)
├── depreciation_process_log (depreciation history)
├── asset_impairments (asset write-downs)
├── inventory_transactions (stock movements)
└── products (product master)

DEBT_MANAGEMENT
├── debts_receivable (AR/AP records)
└── debt_payments (payment records)

PERMISSION_SYSTEM
├── categories (feature categories)
├── features (system features)
└── role_permissions (role-feature mapping)

RECURRING_TRANSACTIONS
├── recurring_journals (recurring entries)
├── recurring_journal_lines (recurring details)
└── transaction_templates (transaction patterns)

NOTIFICATION_SYSTEM
├── notifications (notification records)
├── user_notification_settings (user notification preferences)
├── user_fcm_tokens (Firebase Cloud Messaging tokens)
├── fcm_cleanup_logs (FCM token maintenance logs)
├── sent_shift_notifications (shift notification tracking)
└── user_preferences (user settings)
```

## Detailed Table Schemas

### 1. USERS TABLE
```sql
TABLE: users
PURPOSE: Central user authentication and profile management
PRIMARY_KEY: user_id (UUID)

COLUMNS:
- user_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- first_name: VARCHAR, NULL
- last_name: VARCHAR, NULL  
- email: VARCHAR, NULL, UNIQUE INDEX
- password_hash: TEXT, NULL (encrypted)
- profile_image: TEXT, NULL (URL/base64)
- fcm_token: TEXT, NULL (Firebase push token)
- created_at: TIMESTAMP, NULL, DEFAULT: CURRENT_TIMESTAMP
- updated_at: TIMESTAMP, NULL, DEFAULT: CURRENT_TIMESTAMP
- is_deleted: BOOLEAN, NULL, DEFAULT: false (soft delete)
- deleted_at: TIMESTAMP, NULL

FOREIGN_KEYS_FROM_THIS_TABLE: None

FOREIGN_KEYS_TO_THIS_TABLE:
- user_roles.user_id → users.user_id
- user_companies.user_id → users.user_id
- user_stores.user_id → users.user_id
- user_salaries.user_id → users.user_id
- shift_requests.user_id → users.user_id
- companies.owner_id → users.user_id
- journal_entries.created_by → users.user_id
- journal_entries.approved_by → users.user_id

INDEXES:
- PRIMARY: user_id
- UNIQUE: email
```

### 2. COMPANIES TABLE
```sql
TABLE: companies
PURPOSE: Company/organization entity management
PRIMARY_KEY: company_id (UUID)

COLUMNS:
- company_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- company_name: VARCHAR, NULL
- company_code: VARCHAR, NULL (unique identifier code)
- company_type_id: UUID, NULL, FK → company_types.company_type_id
- owner_id: UUID, NULL, FK → users.user_id
- base_currency_id: UUID, NULL, FK → currency_types.currency_id
- created_at: TIMESTAMP, NULL, DEFAULT: CURRENT_TIMESTAMP
- updated_at: TIMESTAMP, NULL, DEFAULT: CURRENT_TIMESTAMP
- is_deleted: BOOLEAN, NULL, DEFAULT: false
- deleted_at: TIMESTAMP, NULL

FOREIGN_KEYS_FROM_THIS_TABLE:
- company_type_id → company_types.company_type_id
- owner_id → users.user_id
- base_currency_id → currency_types.currency_id

FOREIGN_KEYS_TO_THIS_TABLE:
- stores.company_id → companies.company_id
- roles.company_id → companies.company_id
- user_companies.company_id → companies.company_id
- journal_entries.company_id → companies.company_id
- cash_locations.company_id → companies.company_id
- counterparties.company_id → companies.company_id
- fiscal_years.company_id → companies.company_id
```

### 3. STORES TABLE
```sql
TABLE: stores
PURPOSE: Physical store/branch locations
PRIMARY_KEY: store_id (UUID)

COLUMNS:
- store_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- store_name: VARCHAR, NULL
- store_code: VARCHAR, NULL
- store_address: TEXT, NULL
- store_phone: VARCHAR, NULL
- store_location: GEOGRAPHY, NULL (PostGIS point for GPS)
- store_qrcode: TEXT, NULL
- company_id: UUID, NULL, FK → companies.company_id
- huddle_time: INTEGER, NULL (minutes)
- payment_time: INTEGER, NULL (minutes)
- allowed_distance: INTEGER, NULL (meters for check-in)
- created_at: TIMESTAMP, NULL, DEFAULT: CURRENT_TIMESTAMP
- updated_at: TIMESTAMP, NULL, DEFAULT: CURRENT_TIMESTAMP
- is_deleted: BOOLEAN, NULL, DEFAULT: false
- deleted_at: TIMESTAMP, NULL

FOREIGN_KEYS_FROM_THIS_TABLE:
- company_id → companies.company_id

FOREIGN_KEYS_TO_THIS_TABLE:
- user_stores.store_id → stores.store_id
- shift_requests.store_id → stores.store_id
- store_shifts.store_id → stores.store_id
- journal_entries.store_id → stores.store_id
- cash_locations.store_id → stores.store_id
```

### 4. ACCOUNTS TABLE
```sql
TABLE: accounts
PURPOSE: Chart of accounts for double-entry bookkeeping
PRIMARY_KEY: account_id (UUID)

COLUMNS:
- account_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- account_name: TEXT, NOT NULL
- account_type: TEXT, NOT NULL, CHECK IN ('asset','liability','equity','income','expense')
- expense_nature: TEXT, NULL, CHECK IN ('fixed','variable')
- category_tag: TEXT, NULL
- debt_tag: TEXT, NULL
- statement_category: TEXT, NULL
- statement_detail_category: TEXT, NULL
- description: TEXT, NULL
- created_at: TIMESTAMP, NULL, DEFAULT: now()
- updated_at: TIMESTAMP, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE: None

FOREIGN_KEYS_TO_THIS_TABLE:
- journal_lines.account_id → accounts.account_id
- user_salaries.account_id → accounts.account_id
- debts_receivable.account_id → accounts.account_id
- fixed_assets.account_id → accounts.account_id
- account_mappings.my_account_id → accounts.account_id
- account_mappings.linked_account_id → accounts.account_id
```

### 5. JOURNAL_ENTRIES TABLE
```sql
TABLE: journal_entries
PURPOSE: General ledger transaction headers
PRIMARY_KEY: journal_id (UUID)

COLUMNS:
- journal_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- journal_number: TEXT, NOT NULL (unique transaction number)
- journal_date: DATE, NOT NULL
- journal_type: TEXT, NULL, DEFAULT: 'manual'
- company_id: UUID, NOT NULL, FK → companies.company_id
- store_id: UUID, NULL, FK → stores.store_id
- counterparty_id: UUID, NULL, FK → counterparties.counterparty_id
- currency_id: UUID, NULL, FK → currency_types.currency_id
- exchange_rate: NUMERIC, NULL, DEFAULT: 1
- period_id: UUID, NULL, FK → fiscal_periods.period_id
- description: TEXT, NULL
- reference_number: TEXT, NULL
- notes: TEXT, NULL
- tags: JSONB, NULL
- status: TEXT, NULL, DEFAULT: 'draft' ('draft','posted','cancelled')
- created_by: UUID, NOT NULL, FK → users.user_id
- created_at: TIMESTAMP, NULL, DEFAULT: now()
- approved_by: UUID, NULL, FK → users.user_id
- approved_at: TIMESTAMP, NULL

FOREIGN_KEYS_FROM_THIS_TABLE:
- company_id → companies.company_id
- store_id → stores.store_id
- counterparty_id → counterparties.counterparty_id
- currency_id → currency_types.currency_id
- period_id → fiscal_periods.period_id
- created_by → users.user_id
- approved_by → users.user_id

FOREIGN_KEYS_TO_THIS_TABLE:
- journal_lines.journal_id → journal_entries.journal_id
- journal_attachments.journal_id → journal_entries.journal_id
```

### 6. JOURNAL_LINES TABLE
```sql
TABLE: journal_lines
PURPOSE: General ledger transaction line items
PRIMARY_KEY: line_id (UUID)

COLUMNS:
- line_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- journal_id: UUID, NOT NULL, FK → journal_entries.journal_id
- account_id: UUID, NOT NULL, FK → accounts.account_id
- debit: NUMERIC, NULL, DEFAULT: 0
- credit: NUMERIC, NULL, DEFAULT: 0
- amount_base: NUMERIC, NULL (base currency amount)
- description: TEXT, NULL
- store_id: UUID, NULL, FK → stores.store_id
- counterparty_id: UUID, NULL, FK → counterparties.counterparty_id
- tax_amount: NUMERIC, NULL
- tax_rate: NUMERIC, NULL
- line_order: INTEGER, NULL
- created_at: TIMESTAMP, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE:
- journal_id → journal_entries.journal_id
- account_id → accounts.account_id
- store_id → stores.store_id
- counterparty_id → counterparties.counterparty_id

VALIDATION_RULES:
- CONSTRAINT: debit + credit must balance per journal_id
- CONSTRAINT: either debit or credit must be > 0, not both
```

### 7. SHIFT_REQUESTS TABLE
```sql
TABLE: shift_requests
PURPOSE: Employee attendance and shift management
PRIMARY_KEY: shift_request_id (UUID)

COLUMNS:
- shift_request_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- user_id: UUID, NOT NULL, FK → users.user_id
- shift_id: UUID, NOT NULL, FK → store_shifts.shift_id
- store_id: UUID, NOT NULL, FK → stores.store_id
- request_date: DATE, NOT NULL
- start_time: TIMESTAMP, NULL (scheduled)
- end_time: TIMESTAMP, NULL (scheduled)
- actual_start_time: TIMESTAMP, NULL (actual clock-in)
- actual_end_time: TIMESTAMP, NULL (actual clock-out)
- confirm_start_time: TIMESTAMP, NULL (manager confirmed)
- confirm_end_time: TIMESTAMP, NULL (manager confirmed)
- is_approved: BOOLEAN, NULL, DEFAULT: false
- approved_by: UUID, NULL, FK → users.user_id
- is_late: BOOLEAN, NULL
- is_extratime: BOOLEAN, NULL
- overtime_amount: NUMERIC, NULL
- late_deducut_amount: NUMERIC, NULL
- bonus_amount: NUMERIC, NULL, DEFAULT: 0
- checkin_location: GEOGRAPHY, NULL
- checkin_distance_from_store: FLOAT8, NULL
- is_valid_checkin_location: BOOLEAN, NULL
- checkout_location: GEOGRAPHY, NULL
- checkout_distance_from_store: FLOAT8, NULL
- is_valid_checkout_location: BOOLEAN, NULL
- notice_tag: JSONB, NULL (reason codes/notes)
- is_reported: BOOLEAN, NULL, DEFAULT: false
- report_time: TIMESTAMP, NULL
- problem_type: TEXT, NULL
- is_problem: BOOLEAN, NULL, DEFAULT: false
- is_problem_solved: BOOLEAN, NOT NULL, DEFAULT: false
- created_at: TIMESTAMP, NULL, DEFAULT: now()
- updated_at: TIMESTAMP, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE:
- user_id → users.user_id
- shift_id → store_shifts.shift_id
- store_id → stores.store_id
- approved_by → users.user_id

BUSINESS_LOGIC:
- Distance validation: checkin_distance_from_store <= stores.allowed_distance
- Late detection: actual_start_time > start_time
- Overtime: actual_end_time > end_time AND store_shifts.is_can_overtime = true
```

### 8. CASH_LOCATIONS TABLE
```sql
TABLE: cash_locations
PURPOSE: Define cash storage locations (vault, bank, cashier)
PRIMARY_KEY: cash_location_id (UUID)

COLUMNS:
- cash_location_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- location_name: TEXT, NOT NULL
- location_type: TEXT, NOT NULL ('vault','bank','cashier')
- company_id: UUID, NOT NULL, FK → companies.company_id
- store_id: UUID, NULL, FK → stores.store_id
- currency_id: UUID, NULL, FK → currency_types.currency_id
- currency_code: TEXT, NULL (legacy)
- bank_name: TEXT, NULL
- bank_account: TEXT, NULL
- location_info: TEXT, NULL
- icon: TEXT, NULL
- main_cash_location: BOOLEAN, NULL, DEFAULT: false
- note: TEXT, NULL
- is_deleted: BOOLEAN, NULL, DEFAULT: false
- deleted_at: TIMESTAMP, NULL
- created_at: TIMESTAMP, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE:
- company_id → companies.company_id
- store_id → stores.store_id
- currency_id → currency_types.currency_id

FOREIGN_KEYS_TO_THIS_TABLE:
- cash_control.location_id → cash_locations.cash_location_id
- cashier_amount_lines.location_id → cash_locations.cash_location_id
- bank_amount.location_id → cash_locations.cash_location_id
- vault_amount_line.location_id → cash_locations.cash_location_id
```

### 9. COUNTERPARTIES TABLE
```sql
TABLE: counterparties
PURPOSE: Customers, vendors, and internal entities
PRIMARY_KEY: counterparty_id (UUID)

COLUMNS:
- counterparty_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- name: TEXT, NOT NULL
- type: TEXT, NULL ('customer','vendor','employee','internal')
- company_id: UUID, NOT NULL, FK → companies.company_id
- linked_company_id: UUID, NULL, FK → companies.company_id (for internal)
- email: TEXT, NULL
- phone: TEXT, NULL
- address: TEXT, NULL
- notes: TEXT, NULL
- is_internal: BOOLEAN, NOT NULL, DEFAULT: false
- is_deleted: BOOLEAN, NOT NULL, DEFAULT: false
- created_by: UUID, NULL, FK → users.user_id
- created_at: TIMESTAMP, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE:
- company_id → companies.company_id
- linked_company_id → companies.company_id
- created_by → users.user_id

FOREIGN_KEYS_TO_THIS_TABLE:
- journal_entries.counterparty_id → counterparties.counterparty_id
- journal_lines.counterparty_id → counterparties.counterparty_id
- debts_receivable.counterparty_id → counterparties.counterparty_id
- account_mappings.counterparty_id → counterparties.counterparty_id
```

### 10. CURRENCY_TYPES TABLE
```sql
TABLE: currency_types
PURPOSE: Currency definitions
PRIMARY_KEY: currency_id (UUID)

COLUMNS:
- currency_id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- currency_code: TEXT, NOT NULL, UNIQUE (ISO code: USD, EUR, VND)
- currency_name: TEXT, NULL
- symbol: TEXT, NULL ($, €, ₫)
- flag_emoji: TEXT, NULL
- created_at: TIMESTAMP, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE: None

FOREIGN_KEYS_TO_THIS_TABLE:
- companies.base_currency_id → currency_types.currency_id
- journal_entries.currency_id → currency_types.currency_id
- user_salaries.currency_id → currency_types.currency_id
- cash_locations.currency_id → currency_types.currency_id
- book_exchange_rates.from_currency_id → currency_types.currency_id
- book_exchange_rates.to_currency_id → currency_types.currency_id
```

## Key Business Rules and Constraints

### 1. Double-Entry Bookkeeping
```sql
-- For each journal_id, sum of debits must equal sum of credits
SELECT journal_id, 
       SUM(debit) as total_debit, 
       SUM(credit) as total_credit
FROM journal_lines
GROUP BY journal_id
HAVING SUM(debit) != SUM(credit) -- This should return no rows
```

### 2. Shift Attendance Validation
```sql
-- Valid check-in location
is_valid_checkin_location = (checkin_distance_from_store <= stores.allowed_distance)

-- Late detection
is_late = (actual_start_time > start_time)

-- Overtime calculation
is_extratime = (actual_end_time > end_time AND store_shifts.is_can_overtime = true)
```

### 3. Cash Reconciliation
```sql
-- Cash control matches sum of denominations
cash_control.actual_amount = SUM(cashier_amount_lines.quantity * currency_denominations.value)
WHERE cash_control.location_id = cashier_amount_lines.location_id
  AND cash_control.record_date = cashier_amount_lines.record_date
```

### 4. Multi-Currency Handling
```sql
-- Base amount calculation
journal_lines.amount_base = (debit - credit) * journal_entries.exchange_rate
WHERE journal_entries.currency_id != companies.base_currency_id
```

### 5. Fiscal Period Constraints
```sql
-- Journal entries must fall within fiscal period dates
journal_entries.journal_date BETWEEN fiscal_periods.start_date AND fiscal_periods.end_date
WHERE journal_entries.period_id = fiscal_periods.period_id
```

### 11. NOTIFICATIONS TABLE
```sql
TABLE: notifications
PURPOSE: Store notification messages for users
PRIMARY_KEY: id (UUID)

COLUMNS:
- id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- user_id: UUID, NULL, FK → auth.users.id
- title: TEXT, NOT NULL (notification title)
- body: TEXT, NOT NULL (notification body text)
- category: VARCHAR(50), NULL (notification category type)
- data: JSONB, NULL (additional custom data)
- image_url: TEXT, NULL (optional image URL)
- action_url: TEXT, NULL (optional action/redirect URL)
- is_read: BOOLEAN, NULL, DEFAULT: false
- scheduled_time: TIMESTAMPTZ, NULL (for scheduled notifications)
- sent_at: TIMESTAMPTZ, NULL (when notification was sent)
- read_at: TIMESTAMPTZ, NULL (when user read notification)
- created_at: TIMESTAMPTZ, NULL, DEFAULT: now()
- updated_at: TIMESTAMPTZ, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE:
- user_id → auth.users.id

INDEXES:
- PRIMARY: id
- idx_notifications_user_id: user_id
- idx_notifications_is_read: is_read
- idx_notifications_created_at: created_at DESC

BUSINESS_LOGIC:
- Notifications can be immediate or scheduled
- Track read status and timing
- Support rich content with images and actions
- Category-based filtering and grouping
```

### 12. USER_NOTIFICATION_SETTINGS TABLE
```sql
TABLE: user_notification_settings
PURPOSE: Store user preferences for notifications
PRIMARY_KEY: id (UUID)

COLUMNS:
- id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- user_id: UUID, NULL, UNIQUE, FK → auth.users.id
- push_enabled: BOOLEAN, NULL, DEFAULT: true
- email_enabled: BOOLEAN, NULL, DEFAULT: true
- transaction_alerts: BOOLEAN, NULL, DEFAULT: true
- reminders: BOOLEAN, NULL, DEFAULT: true
- marketing_messages: BOOLEAN, NULL, DEFAULT: true
- sound_preference: VARCHAR(50), NULL, DEFAULT: 'default'
- vibration_enabled: BOOLEAN, NULL, DEFAULT: true
- category_preferences: JSONB, NULL, DEFAULT: '{}' (per-category settings)
- created_at: TIMESTAMPTZ, NULL, DEFAULT: now()
- updated_at: TIMESTAMPTZ, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE:
- user_id → auth.users.id

INDEXES:
- PRIMARY: id
- UNIQUE: user_id

BUSINESS_LOGIC:
- One settings record per user
- Granular control over notification types
- Support for sound and vibration preferences
- Category-specific preferences in JSON
```

### 13. USER_FCM_TOKENS TABLE
```sql
TABLE: user_fcm_tokens
PURPOSE: Store Firebase Cloud Messaging tokens for push notifications
PRIMARY_KEY: id (UUID)

COLUMNS:
- id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- user_id: UUID, NULL, FK → auth.users.id
- token: TEXT, NOT NULL, UNIQUE (FCM token)
- platform: VARCHAR(20), NOT NULL (ios/android/web)
- device_id: VARCHAR(255), NULL (unique device identifier)
- device_model: VARCHAR(255), NULL (device model/type)
- app_version: VARCHAR(50), NULL (app version)
- is_active: BOOLEAN, NULL, DEFAULT: true
- created_at: TIMESTAMPTZ, NULL, DEFAULT: now()
- updated_at: TIMESTAMPTZ, NULL, DEFAULT: now()
- last_used_at: TIMESTAMPTZ, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE:
- user_id → auth.users.id

INDEXES:
- PRIMARY: id
- UNIQUE: token
- UNIQUE: unique_active_token (token WHERE is_active = true)
- UNIQUE: unique_active_device_token (user_id, device_id WHERE is_active = true AND device_id IS NOT NULL)
- idx_user_fcm_tokens_user_id: user_id
- idx_user_fcm_tokens_token: token
- idx_user_fcm_tokens_active: is_active
- idx_fcm_tokens_user_active_used: (user_id, is_active, last_used_at DESC WHERE is_active = true)
- idx_fcm_tokens_cleanup: (updated_at, is_active WHERE is_active = false)

BUSINESS_LOGIC:
- Multiple tokens per user (multi-device support)
- Token lifecycle management with is_active flag
- Track platform and device information
- Auto-deactivate stale tokens
- Prevent duplicate active tokens
```

### 14. FCM_CLEANUP_LOGS TABLE
```sql
TABLE: fcm_cleanup_logs
PURPOSE: Log FCM token cleanup operations
PRIMARY_KEY: id (UUID)

COLUMNS:
- id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- job_name: VARCHAR(100), NULL (cleanup job identifier)
- execution_time: TIMESTAMPTZ, NULL, DEFAULT: now()
- tokens_processed: INTEGER, NULL (number of tokens processed)
- status: VARCHAR(50), NULL (SUCCESS/FAILED/PARTIAL)
- error_message: TEXT, NULL (error details if failed)
- details: JSONB, NULL (additional execution details)

FOREIGN_KEYS_FROM_THIS_TABLE: None

INDEXES:
- PRIMARY: id
- idx_fcm_cleanup_logs_time: execution_time DESC

BUSINESS_LOGIC:
- Track automated cleanup job execution
- Monitor token lifecycle management
- Debug token-related issues
```

### 15. SENT_SHIFT_NOTIFICATIONS TABLE
```sql
TABLE: sent_shift_notifications
PURPOSE: Track shift-related notifications sent to users
PRIMARY_KEY: id (UUID)

COLUMNS:
- id: UUID, NOT NULL, DEFAULT: gen_random_uuid(), PK
- shift_request_id: UUID, NULL, FK → shift_requests.shift_request_id
- notification_type: VARCHAR(50), NULL, DEFAULT: 'shift_start'
- sent_at: TIMESTAMPTZ, NULL, DEFAULT: now()

FOREIGN_KEYS_FROM_THIS_TABLE:
- shift_request_id → shift_requests.shift_request_id

INDEXES:
- PRIMARY: id
- UNIQUE: (shift_request_id, notification_type)

BUSINESS_LOGIC:
- Prevent duplicate shift notifications
- Track different notification types per shift
- Types: shift_start, shift_end, reminder, late_warning, etc.
```

## Common Query Patterns

### Get User's Accessible Companies
```sql
SELECT DISTINCT c.*
FROM companies c
LEFT JOIN user_companies uc ON c.company_id = uc.company_id
WHERE c.owner_id = :user_id 
   OR uc.user_id = :user_id
   AND c.is_deleted = false
```

### Get User's Permissions
```sql
SELECT f.*, rp.can_access
FROM users u
JOIN user_roles ur ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id
JOIN role_permissions rp ON r.role_id = rp.role_id
JOIN features f ON rp.feature_id = f.feature_id
WHERE u.user_id = :user_id
  AND rp.can_access = true
```

### Get Financial Statement Data
```sql
SELECT 
  a.account_type,
  a.statement_category,
  SUM(jl.debit - jl.credit) as balance
FROM journal_lines jl
JOIN accounts a ON jl.account_id = a.account_id
JOIN journal_entries je ON jl.journal_id = je.journal_id
WHERE je.status = 'posted'
  AND je.journal_date BETWEEN :start_date AND :end_date
  AND je.company_id = :company_id
GROUP BY a.account_type, a.statement_category
```

### Get User's Unread Notifications
```sql
SELECT 
  n.*,
  CASE 
    WHEN n.scheduled_time IS NOT NULL THEN 'scheduled'
    WHEN n.sent_at IS NOT NULL THEN 'sent'
    ELSE 'draft'
  END as status
FROM notifications n
WHERE n.user_id = :user_id
  AND n.is_read = false
  AND (n.sent_at IS NOT NULL OR n.scheduled_time <= NOW())
ORDER BY n.created_at DESC
LIMIT 20
```

### Get Active FCM Tokens for User
```sql
SELECT 
  token,
  platform,
  device_model,
  last_used_at
FROM user_fcm_tokens
WHERE user_id = :user_id
  AND is_active = true
ORDER BY last_used_at DESC
```

### Check Notification Preferences
```sql
SELECT 
  uns.*,
  COALESCE(
    (uns.category_preferences->>:category)::boolean,
    true
  ) as category_enabled
FROM user_notification_settings uns
WHERE uns.user_id = :user_id
```

### Clean Up Inactive FCM Tokens
```sql
-- Deactivate tokens not used in 30 days
UPDATE user_fcm_tokens
SET 
  is_active = false,
  updated_at = NOW()
WHERE is_active = true
  AND last_used_at < NOW() - INTERVAL '30 days'
RETURNING *;

-- Log cleanup operation
INSERT INTO fcm_cleanup_logs (job_name, tokens_processed, status, details)
SELECT 
  'auto_cleanup_30d',
  COUNT(*),
  'SUCCESS',
  jsonb_build_object(
    'criteria', '30_days_inactive',
    'platforms', jsonb_object_agg(platform, count)
  )
FROM (
  SELECT platform, COUNT(*) as count
  FROM user_fcm_tokens
  WHERE is_active = false
    AND updated_at >= NOW() - INTERVAL '1 minute'
  GROUP BY platform
) t
```

### Calculate Employee Shift Hours
```sql
SELECT 
  sr.user_id,
  SUM(EXTRACT(EPOCH FROM (confirm_end_time - confirm_start_time))/3600) as total_hours,
  SUM(overtime_amount) as total_overtime,
  SUM(late_deducut_amount) as total_deductions,
  SUM(bonus_amount) as total_bonus
FROM shift_requests sr
WHERE sr.is_approved = true
  AND sr.request_date BETWEEN :start_date AND :end_date
  AND sr.store_id = :store_id
GROUP BY sr.user_id
```

## Data Integrity Rules

### Soft Delete Pattern
```yaml
Tables with soft delete:
- users, companies, stores, roles, user_roles, user_companies, user_stores
- counterparties, cash_locations

Soft delete columns:
- is_deleted: BOOLEAN (flag)
- deleted_at: TIMESTAMP (when deleted)

Query pattern:
- Always include: WHERE is_deleted = false OR is_deleted IS NULL
```

### Audit Trail Pattern
```yaml
Created tracking:
- created_at: TIMESTAMP
- created_by: UUID → users.user_id

Updated tracking:
- updated_at: TIMESTAMP
- edited_by: UUID → users.user_id

Approval tracking:
- approved_by: UUID → users.user_id
- approved_at: TIMESTAMP
```

### Status Workflow
```yaml
journal_entries.status:
- draft → posted (approved_by required)
- draft → cancelled
- posted → cannot change

shift_requests.is_approved:
- false → true (approved_by required)
- actual times → confirm times (manager review)
```

## Performance Optimization Indexes

### Recommended Indexes
```sql
-- Frequent lookups
CREATE INDEX idx_users_email ON users(email) WHERE is_deleted = false;
CREATE INDEX idx_companies_owner ON companies(owner_id) WHERE is_deleted = false;
CREATE INDEX idx_journal_entries_date ON journal_entries(journal_date, company_id);
CREATE INDEX idx_journal_lines_account ON journal_lines(account_id, journal_id);

-- Reporting
CREATE INDEX idx_shift_requests_date ON shift_requests(request_date, store_id, user_id);
CREATE INDEX idx_journal_entries_period ON journal_entries(period_id, status);

-- Foreign keys (auto-created by PostgreSQL)
-- All FK columns automatically get indexes
```

## Data Types Reference
```yaml
UUID: 128-bit unique identifier (gen_random_uuid())
TEXT: Variable length string
VARCHAR: Variable length string with optional limit
NUMERIC: Arbitrary precision number (for money/calculations)
INTEGER: 32-bit integer
BIGINT: 64-bit integer
BOOLEAN: true/false/null
DATE: Date without time
TIMESTAMP: Date and time (without timezone)
TIMESTAMPTZ: Date and time with timezone
JSONB: Binary JSON (queryable)
GEOGRAPHY: PostGIS spatial type (for GPS coordinates)
FLOAT8: Double precision floating point
```

## Security Considerations

### Row Level Security (RLS)
```yaml
Currently disabled on all tables (rls_enabled: false)
Recommendation: Enable RLS with policies for:
- User data isolation
- Company data isolation
- Store data isolation
```

### Sensitive Data
```yaml
Encrypted/Hashed:
- users.password_hash (never store plain text)

PII Data:
- users.email, first_name, last_name
- counterparties.email, phone, address
- shift_requests.checkin_location, checkout_location

Financial Data:
- journal_entries, journal_lines (audit trail required)
- user_salaries (restricted access)
- bank_amount, cash_control (reconciliation required)
```

## Notification System Architecture

### Notification Workflow
```yaml
1. Trigger Event:
   - Shift reminder (30 min before)
   - Transaction completion
   - Approval required
   - System alerts

2. Check User Settings:
   - Query user_notification_settings
   - Check category_preferences
   - Verify push_enabled/email_enabled

3. Create Notification:
   - Insert into notifications table
   - Set category and data fields
   - Schedule if needed (scheduled_time)

4. Send Push Notification:
   - Get active tokens from user_fcm_tokens
   - Send via Firebase Cloud Messaging
   - Update sent_at timestamp

5. Track Delivery:
   - Update notification status
   - Log any errors
   - Deactivate invalid tokens

6. User Interaction:
   - Mark as read (is_read = true)
   - Update read_at timestamp
   - Handle action_url if clicked
```

### Notification Categories
```yaml
SHIFT_NOTIFICATIONS:
  - shift_reminder: 30 minutes before shift
  - shift_start: At shift start time
  - shift_late: 15 minutes after scheduled start
  - shift_end: At shift end time
  - shift_approved: When manager approves
  - shift_problem: When problem reported

FINANCIAL_NOTIFICATIONS:
  - transaction_created: New journal entry
  - transaction_approved: Entry approved
  - transaction_rejected: Entry rejected
  - payment_received: Debt payment received
  - payment_due: Payment reminder

CASH_NOTIFICATIONS:
  - cash_count_required: Daily cash count reminder
  - cash_discrepancy: Mismatch detected
  - vault_transfer: Transfer completed

SYSTEM_NOTIFICATIONS:
  - depreciation_processed: Monthly depreciation
  - backup_completed: System backup done
  - security_alert: Unusual activity detected
  - maintenance: Scheduled maintenance
```

### FCM Token Management
```yaml
Token Lifecycle:
  1. Registration:
     - App sends token to backend
     - Store in user_fcm_tokens
     - Deactivate old tokens for same device
  
  2. Validation:
     - Check token format
     - Verify platform matches
     - Ensure user association
  
  3. Usage:
     - Update last_used_at on each send
     - Track success/failure rates
     - Handle token refresh
  
  4. Cleanup:
     - Auto-deactivate after 30 days inactive
     - Remove invalid tokens from FCM
     - Log cleanup operations

Best Practices:
  - One active token per device
  - Regular token refresh (monthly)
  - Immediate deactivation on logout
  - Platform-specific handling
```

### Notification Queries

#### Send Shift Reminder Notifications
```sql
-- Find shifts starting in 30 minutes
WITH upcoming_shifts AS (
  SELECT 
    sr.shift_request_id,
    sr.user_id,
    sr.start_time,
    s.store_name,
    ss.shift_name
  FROM shift_requests sr
  JOIN stores s ON sr.store_id = s.store_id
  JOIN store_shifts ss ON sr.shift_id = ss.shift_id
  WHERE sr.request_date = CURRENT_DATE
    AND sr.start_time BETWEEN NOW() + INTERVAL '25 minutes' 
                          AND NOW() + INTERVAL '35 minutes'
    AND sr.is_approved = true
    AND NOT EXISTS (
      SELECT 1 FROM sent_shift_notifications ssn
      WHERE ssn.shift_request_id = sr.shift_request_id
        AND ssn.notification_type = 'shift_reminder'
    )
)
-- Create notifications
INSERT INTO notifications (user_id, title, body, category, data)
SELECT 
  user_id,
  'Shift Starting Soon',
  'Your shift at ' || store_name || ' starts in 30 minutes',
  'shift_reminder',
  jsonb_build_object(
    'shift_request_id', shift_request_id,
    'start_time', start_time,
    'shift_name', shift_name
  )
FROM upcoming_shifts;

-- Track sent notifications
INSERT INTO sent_shift_notifications (shift_request_id, notification_type)
SELECT shift_request_id, 'shift_reminder'
FROM upcoming_shifts;
```

#### Get Notification Statistics
```sql
SELECT 
  n.category,
  COUNT(*) as total_sent,
  COUNT(*) FILTER (WHERE is_read = true) as total_read,
  ROUND(AVG(EXTRACT(EPOCH FROM (read_at - sent_at))/60)::numeric, 2) as avg_read_time_minutes,
  COUNT(*) FILTER (WHERE sent_at > NOW() - INTERVAL '24 hours') as last_24h
FROM notifications n
WHERE n.sent_at IS NOT NULL
  AND n.created_at > NOW() - INTERVAL '30 days'
GROUP BY n.category
ORDER BY total_sent DESC;
```

#### Monitor FCM Token Health
```sql
-- Token statistics by platform
SELECT 
  platform,
  COUNT(*) FILTER (WHERE is_active = true) as active_tokens,
  COUNT(*) FILTER (WHERE is_active = false) as inactive_tokens,
  COUNT(*) FILTER (WHERE last_used_at > NOW() - INTERVAL '7 days') as recently_used,
  COUNT(*) FILTER (WHERE last_used_at < NOW() - INTERVAL '30 days' AND is_active = true) as stale_tokens
FROM user_fcm_tokens
GROUP BY platform;

-- Users with multiple active tokens
SELECT 
  u.email,
  COUNT(t.id) as token_count,
  ARRAY_AGG(DISTINCT t.platform) as platforms,
  ARRAY_AGG(DISTINCT t.device_model) as devices
FROM user_fcm_tokens t
JOIN users u ON t.user_id = u.user_id
WHERE t.is_active = true
GROUP BY u.user_id, u.email
HAVING COUNT(t.id) > 1
ORDER BY token_count DESC;
```

### Notification System Triggers

```sql
-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_notification_timestamp()
RETURNS TRIGGER AS $
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER update_notifications_timestamp
  BEFORE UPDATE ON notifications
  FOR EACH ROW
  EXECUTE FUNCTION update_notification_timestamp();

-- Auto-set read_at when marking as read
CREATE OR REPLACE FUNCTION set_notification_read_time()
RETURNS TRIGGER AS $
BEGIN
  IF NEW.is_read = true AND OLD.is_read = false THEN
    NEW.read_at = NOW();
  END IF;
  RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER set_notification_read_timestamp
  BEFORE UPDATE ON notifications
  FOR EACH ROW
  EXECUTE FUNCTION set_notification_read_time();

-- Prevent duplicate active tokens
CREATE OR REPLACE FUNCTION deactivate_old_tokens()
RETURNS TRIGGER AS $
BEGIN
  IF NEW.is_active = true THEN
    -- Deactivate other tokens for same device
    UPDATE user_fcm_tokens
    SET is_active = false, updated_at = NOW()
    WHERE user_id = NEW.user_id
      AND device_id = NEW.device_id
      AND id != NEW.id
      AND is_active = true;
  END IF;
  RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER manage_token_activation
  AFTER INSERT OR UPDATE ON user_fcm_tokens
  FOR EACH ROW
  EXECUTE FUNCTION deactivate_old_tokens();
```

## Migration Dependencies Order
```yaml
1. First Wave (No dependencies):
   - company_types
   - currency_types
   - categories
   - depreciation_methods
   - spatial_ref_sys

2. Second Wave (Basic dependencies):
   - users
   - companies (needs: company_types, users, currency_types)
   - accounts
   - products

3. Third Wave:
   - stores (needs: companies)
   - roles (needs: companies)
   - counterparties (needs: companies, users)
   - fiscal_years (needs: companies)
   - features (needs: categories)

4. Fourth Wave:
   - user_companies (needs: users, companies)
   - user_stores (needs: users, stores)
   - user_roles (needs: users, roles)
   - fiscal_periods (needs: fiscal_years)
   - role_permissions (needs: roles, features)
   - cash_locations (needs: companies, stores, currency_types)

5. Fifth Wave (Complex dependencies):
   - journal_entries (needs: companies, stores, users, counterparties, currency_types, fiscal_periods)
   - journal_lines (needs: journal_entries, accounts, stores, counterparties)
   - shift_requests (needs: users, stores, store_shifts)
   - All remaining tables
```
