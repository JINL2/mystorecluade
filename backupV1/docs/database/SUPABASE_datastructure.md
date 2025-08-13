# SUPABASE Database Schema Documentation


** dont change anything in this file**
**9. 너는 supabase database mcp를 사용할수있어. supabse williamwls130@gmail.com's Project 안에 Lux야. 프로젝트 id는 "atkekzwgukdvucqntryo" 이거야.**
**annon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8""

---

## 🔄 Data Flow Overview

### Core Business Structure
```
companies (owner_id) → users → user_companies → companies
    ↓                    ↓          ↓
stores → user_stores ← users → user_roles → roles
    ↓                              ↓
store_shifts → shift_requests ← users
```

### Financial Flow
```
journal_entries → journal_lines → accounts
       ↓               ↓
counterparties    cash_locations → cashier_amount_lines
       ↓               ↓
debts_receivable  bank_amount / vault_amount_line
```

### Key Relationships Summary
1. **Company-User-Store Triangle**: Users belong to companies through `user_companies`, work at stores through `user_stores`
2. **Role-Based Access**: Users have roles (`user_roles` → `roles` → `role_permissions`)
3. **Double-Entry Accounting**: Every `journal_entry` has multiple `journal_lines` (debit/credit must balance)
4. **Shift Management**: `stores` have `store_shifts`, users request shifts via `shift_requests`
5. **Multi-Currency**: Companies have base currency, but support multiple currencies with exchange rates
6. **Cash Tracking**: Physical cash/bank/vault tracked through `cash_locations` with denominations

---

## All Tables

### account_mappings
- **Primary Key**: mapping_id (uuid)
- **Columns**:
  - mapping_id (uuid)
  - my_company_id (uuid) → FK to companies
  - my_account_id (uuid) → FK to accounts
  - counterparty_id (uuid) → FK to counterparties
  - linked_account_id (uuid) → FK to accounts
  - direction (text)
  - created_at (timestamp)
  - created_by (uuid)

### accounts
- **Primary Key**: account_id (uuid)
- **Columns**:
  - account_id (uuid)
  - account_name (text)
  - account_type (text) - CHECK: asset, liability, equity, income, expense
  - expense_nature (text) - CHECK: fixed, variable
  - category_tag (text)
  - description (text)
  - debt_tag (text)
  - statement_category (text)
  - statement_detail_category (text)
  - created_at (timestamp)
  - updated_at (timestamp)

### bank_amount
- **Primary Key**: bank_amount_id (uuid)
- **Columns**:
  - bank_amount_id (uuid)
  - company_id (uuid) → FK to companies
  - store_id (uuid) → FK to stores
  - location_id (uuid) → FK to cash_locations
  - currency_id (uuid) → FK to currency_types
  - record_date (timestamp)
  - total_amount (numeric)
  - created_by (uuid) → FK to users
  - created_at (timestamp)

### book_exchange_rates
- **Primary Key**: rate_id (uuid)
- **Columns**:
  - rate_id (uuid)
  - company_id (uuid) → FK to companies
  - from_currency_id (uuid) → FK to currency_types
  - to_currency_id (uuid) → FK to currency_types
  - rate (numeric)
  - rate_date (date)
  - created_by (uuid) → FK to users
  - created_at (timestamp)

### cash_control
- **Primary Key**: control_id (uuid)
- **Columns**:
  - control_id (uuid)
  - company_id (uuid) → FK to companies
  - store_id (uuid) → FK to stores
  - location_id (uuid) → FK to cash_locations
  - check_date (date)
  - expected_amount (numeric)
  - actual_amount (numeric)
  - difference (numeric)
  - notes (text)
  - created_by (uuid) → FK to users
  - created_at (timestamp)

### cash_locations
- **Primary Key**: cash_location_id (uuid)
- **Columns**:
  - cash_location_id (uuid)
  - company_id (uuid) → FK to companies
  - store_id (uuid) → FK to stores
  - location_name (text)
  - location_type (text)
  - location_info (text)
  - currency_code (text)
  - bank_account (text)
  - bank_name (text)
  - deleted_at (timestamp)
  - created_at (timestamp)

### cashier_amount_lines
- **Primary Key**: cashier_line_id (uuid)
- **Columns**:
  - cashier_line_id (uuid)
  - company_id (uuid) → FK to companies
  - store_id (uuid) → FK to stores
  - location_id (uuid) → FK to cash_locations
  - currency_id (uuid) → FK to currency_types
  - denomination_id (uuid) → FK to currency_denominations
  - quantity (int4)
  - record_date (date)
  - created_by (uuid) → FK to users
  - created_at (timestamp)

### categories
- **Primary Key**: category_id (uuid)
- **Columns**:
  - category_id (uuid)
  - name (varchar)
  - icon (varchar)
  - created_at (timestamp)

### companies
- **Primary Key**: company_id (uuid)
- **Columns**:
  - company_id (uuid)
  - company_name (varchar)
  - company_code (varchar)
  - company_type_id (uuid) → FK to company_types
  - owner_id (uuid) → FK to users
  - base_currency_id (uuid) → FK to currency_types
  - created_at (timestamp)
  - updated_at (timestamp)
  - is_deleted (boolean)
  - deleted_at (timestamp)

### company_currency
- **Primary Key**: company_currency_id (uuid)
- **Columns**:
  - company_currency_id (uuid)
  - company_id (uuid) → FK to companies
  - currency_id (uuid) → FK to currency_types
  - created_at (timestamp)

### company_types
- **Primary Key**: company_type_id (uuid)
- **Columns**:
  - company_type_id (uuid)
  - type_name (varchar)
  - created_at (timestamp)
  - updated_at (timestamp)

### counterparties
- **Primary Key**: counterparty_id (uuid)
- **Columns**:
  - counterparty_id (uuid)
  - company_id (uuid) → FK to companies
  - name (text)
  - type (text)
  - email (text)
  - phone (text)
  - address (text)
  - notes (text)
  - is_internal (boolean)
  - is_deleted (boolean)
  - linked_company_id (uuid) → FK to companies
  - created_by (uuid) → FK to users
  - created_at (timestamp)

### currency_denominations
- **Primary Key**: denomination_id (uuid)
- **Columns**:
  - denomination_id (uuid)
  - company_id (uuid) → FK to companies
  - currency_id (uuid) → FK to currency_types
  - value (numeric)
  - type (text) - CHECK: coin, bill
  - is_active (boolean)
  - created_at (timestamp)

### currency_types
- **Primary Key**: currency_id (uuid)
- **Columns**:
  - currency_id (uuid)
  - currency_code (text) - UNIQUE
  - currency_name (text)
  - symbol (text)
  - created_at (timestamp)

### debts_receivable
- **Primary Key**: debt_id (uuid)
- **Columns**:
  - debt_id (uuid)
  - company_id (uuid) → FK to companies
  - store_id (uuid) → FK to stores
  - counterparty_id (uuid) → FK to counterparties
  - direction (text)
  - category (text)
  - account_id (uuid) → FK to accounts
  - interest_account_id (uuid) → FK to accounts
  - related_journal_id (uuid)
  - original_amount (numeric)
  - remaining_amount (numeric)
  - interest_rate (numeric)
  - interest_due_day (int4)
  - issue_date (date)
  - due_date (date)
  - status (text)
  - description (text)
  - linked_company_id (uuid) → FK to companies
  - linked_company_store_id (uuid) → FK to stores
  - is_active (boolean)
  - created_at (timestamp)
  - updated_at (timestamp)

### depreciation_methods
- **Primary Key**: method_id (uuid)
- **Columns**:
  - method_id (uuid)
  - method_name (text)
  - method_code (text)
  - description (text)
  - formula (text)
  - created_at (timestamp)

### depreciation_process_log
- **Primary Key**: log_id (uuid)
- **Columns**:
  - log_id (uuid)
  - company_id (uuid) → FK to companies
  - process_date (date)
  - asset_count (int4)
  - total_amount (numeric)
  - status (text)
  - error_message (text)
  - created_at (timestamp)

### features
- **Primary Key**: feature_id (uuid)
- **Columns**:
  - feature_id (uuid)
  - category_id (uuid) → FK to categories
  - feature_name (varchar)
  - icon (varchar)
  - route (varchar)
  - created_at (timestamp)

### fiscal_periods
- **Primary Key**: period_id (uuid)
- **Columns**:
  - period_id (uuid)
  - fiscal_year_id (uuid) → FK to fiscal_years
  - name (text)
  - start_date (date)
  - end_date (date)
  - created_at (timestamp)

### fiscal_years
- **Primary Key**: fiscal_year_id (uuid)
- **Columns**:
  - fiscal_year_id (uuid)
  - company_id (uuid) → FK to companies
  - year (int4)
  - start_date (date)
  - end_date (date)
  - created_at (timestamp)

### fixed_assets
- **Primary Key**: asset_id (uuid)
- **Columns**:
  - asset_id (uuid)
  - company_id (uuid) → FK to companies
  - store_id (uuid) → FK to stores
  - account_id (uuid) → FK to accounts
  - asset_name (text)
  - acquisition_date (date)
  - acquisition_cost (numeric)
  - useful_life_years (int4)
  - salvage_value (numeric)
  - depreciation_method_id (uuid)
  - related_journal_line_id (uuid)
  - is_active (boolean)
  - created_at (timestamp)
  - updated_at (timestamp)

### inventory_items
- **Primary Key**: item_id (uuid)
- **Columns**:
  - item_id (uuid)
  - item_name (text)
  - item_code (text)
  - category (text)
  - unit_of_measure (text)
  - reorder_level (numeric)
  - created_at (timestamp)
  - updated_at (timestamp)

### inventory_transactions
- **Primary Key**: transaction_id (uuid)
- **Columns**:
  - transaction_id (uuid)
  - item_id (uuid) → FK to inventory_items
  - store_id (uuid) → FK to stores
  - transaction_type (text)
  - quantity (numeric)
  - unit_cost (numeric)
  - total_cost (numeric)
  - transaction_date (timestamp)
  - reference_number (text)
  - created_at (timestamp)

### journal_attachments
- **Primary Key**: attachment_id (uuid)
- **Columns**:
  - attachment_id (uuid)
  - journal_id (uuid) → FK to journal_entries
  - file_name (text)
  - file_url (text)
  - file_size (int4)
  - file_type (text)
  - uploaded_by (uuid) → FK to users
  - uploaded_at (timestamp)

### journal_entries
- **Primary Key**: journal_id (uuid)
- **Columns**:
  - journal_id (uuid)
  - company_id (uuid) → FK to companies
  - store_id (uuid) → FK to stores
  - entry_date (timestamp)
  - period_id (uuid) → FK to fiscal_periods
  - currency_id (uuid) → FK to currency_types
  - exchange_rate (numeric)
  - base_amount (numeric)
  - description (text)
  - journal_type (text)
  - counterparty_id (uuid) → FK to counterparties
  - created_by (uuid) → FK to users
  - approved_by (uuid) → FK to users
  - is_draft (boolean)
  - is_auto_created (boolean)
  - is_deleted (boolean)
  - created_at (timestamp)
  - updated_at (timestamp)

### journal_lines
- **Primary Key**: line_id (uuid)
- **Columns**:
  - line_id (uuid)
  - journal_id (uuid) → FK to journal_entries
  - account_id (uuid) → FK to accounts
  - debit (numeric)
  - credit (numeric)
  - description (text)
  - store_id (uuid) → FK to stores
  - cash_location_id (uuid) → FK to cash_locations
  - counterparty_id (uuid) → FK to counterparties
  - debt_id (uuid) → FK to debts_receivable
  - fixed_asset_id (uuid) → FK to fixed_assets
  - is_deleted (boolean)
  - created_at (timestamp)
  - updated_at (timestamp)

### recurring_journal_lines
- **Primary Key**: line_id (uuid)
- **Columns**:
  - line_id (uuid)
  - recurring_id (uuid) → FK to recurring_journals
  - account_id (uuid) → FK to accounts
  - description (text)
  - debit (numeric)
  - credit (numeric)
  - store_id (uuid)
  - fixed_asset_id (uuid)
  - created_at (timestamp)

### recurring_journals
- **Primary Key**: recurring_id (uuid)
- **Columns**:
  - recurring_id (uuid)
  - company_id (uuid) → FK to companies
  - description (text)
  - repeat_cycle (text)
  - next_run_date (date)
  - last_run_date (date)
  - enabled (boolean)
  - created_at (timestamp)
  - updated_at (timestamp)

### role_permissions
- **Primary Key**: role_permission_id (uuid)
- **Columns**:
  - role_permission_id (uuid)
  - role_id (uuid) → FK to roles
  - feature_id (uuid) → FK to features
  - can_access (boolean)
  - created_at (timestamp)
  - updated_at (timestamp)

### roles
- **Primary Key**: role_id (uuid)
- **Columns**:
  - role_id (uuid)
  - role_name (varchar)
  - role_type (varchar)
  - company_id (uuid) → FK to companies
  - parent_role_id (uuid) → FK to roles
  - description (text)
  - tags (jsonb)
  - is_deletable (boolean)
  - created_at (timestamp)
  - updated_at (timestamp)

### shift_edit_logs
- **Primary Key**: log_id (uuid)
- **Columns**:
  - log_id (uuid)
  - shift_request_id (uuid) → FK to shift_requests
  - edited_by (uuid) → FK to users
  - edit_type (text)
  - old_value (jsonb)
  - new_value (jsonb)
  - edit_reason (text)
  - created_at (timestamp)

### shift_requests
- **Primary Key**: shift_request_id (uuid)
- **Columns**:
  - shift_request_id (uuid)
  - user_id (uuid) → FK to users
  - shift_id (uuid) → FK to store_shifts
  - store_id (uuid) → FK to stores
  - request_date (date)
  - start_time (timestamp)
  - end_time (timestamp)
  - actual_start_time (timestamp)
  - actual_end_time (timestamp)
  - confirm_start_time (timestamp)
  - confirm_end_time (timestamp)
  - is_approved (boolean)
  - approved_by (uuid) → FK to users
  - is_late (boolean)
  - is_extratime (boolean)
  - overtime_amount (numeric)
  - late_deducut_amount (numeric)
  - bonus_amount (numeric)
  - checkin_location (geography)
  - checkin_distance_from_store (float8)
  - is_valid_checkin_location (boolean)
  - checkout_location (geography)
  - checkout_distance_from_store (float8)
  - is_valid_checkout_location (boolean)
  - notice_tag (jsonb)
  - is_reported (boolean)
  - report_time (timestamp)
  - problem_type (text)
  - is_problem (boolean)
  - is_problem_solved (boolean)
  - created_at (timestamp)
  - updated_at (timestamp)

### store_shifts
- **Primary Key**: shift_id (uuid)
- **Columns**:
  - shift_id (uuid)
  - store_id (uuid) → FK to stores
  - shift_name (text)
  - start_time (time)
  - end_time (time)
  - number_shift (int4)
  - is_can_overtime (boolean)
  - is_active (boolean)
  - created_at (timestamp)
  - updated_at (timestamp)

### stores
- **Primary Key**: store_id (uuid)
- **Columns**:
  - store_id (uuid)
  - store_name (varchar)
  - store_code (varchar)
  - store_address (text)
  - store_phone (varchar)
  - company_id (uuid) → FK to companies
  - store_location (geography)
  - store_qrcode (text)
  - huddle_time (int4)
  - payment_time (int4)
  - allowed_distance (int4)
  - created_at (timestamp)
  - updated_at (timestamp)
  - is_deleted (boolean)
  - deleted_at (timestamp)

### user_companies
- **Primary Key**: user_company_id (uuid)
- **Columns**:
  - user_company_id (uuid)
  - user_id (uuid) → FK to users
  - company_id (uuid) → FK to companies
  - created_at (timestamp)
  - updated_at (timestamp)
  - is_deleted (boolean)
  - deleted_at (timestamp)

### user_preferences
- **Primary Key**: id (uuid)
- **Columns**:
  - id (uuid)
  - user_id (uuid)
  - feature_id (uuid)
  - feature_name (varchar)
  - category_id (uuid)
  - clicked_at (timestamp)
  - created_at (timestamp)
  - updated_at (timestamp)

### user_roles
- **Primary Key**: user_role_id (uuid)
- **Columns**:
  - user_role_id (uuid)
  - user_id (uuid) → FK to users
  - role_id (uuid) → FK to roles
  - created_at (timestamp)
  - updated_at (timestamp)
  - is_deleted (boolean)
  - deleted_at (timestamp)

### user_salaries
- **Primary Key**: salary_id (uuid)
- **Columns**:
  - salary_id (uuid)
  - user_id (uuid) → FK to users
  - company_id (uuid) → FK to companies
  - currency_id (uuid) → FK to currency_types
  - salary_amount (numeric)
  - salary_type (text) - CHECK: monthly, hourly
  - bonus_amount (numeric)
  - account_id (uuid) → FK to accounts
  - edited_by (uuid) → FK to users
  - created_at (timestamp)
  - updated_at (timestamp)

### user_stores
- **Primary Key**: user_store_id (uuid)
- **Columns**:
  - user_store_id (uuid)
  - user_id (uuid) → FK to users
  - store_id (uuid) → FK to stores
  - created_at (timestamp)
  - updated_at (timestamp)
  - is_deleted (boolean)
  - deleted_at (timestamp)

### users
- **Primary Key**: user_id (uuid)
- **RLS Enabled**: Yes (forced)
- **Columns**:
  - user_id (uuid)
  - first_name (varchar)
  - last_name (varchar)
  - email (varchar) - UNIQUE
  - password_hash (text)
  - profile_image (text)
  - created_at (timestamp)
  - updated_at (timestamp)
  - is_deleted (boolean)
  - deleted_at (timestamp)

### vault_amount_line
- **Primary Key**: vault_line_id (uuid)
- **Columns**:
  - vault_line_id (uuid)
  - company_id (uuid) → FK to companies
  - store_id (uuid) → FK to stores
  - location_id (uuid) → FK to cash_locations
  - currency_id (uuid) → FK to currency_types
  - denomination_id (uuid) → FK to currency_denominations
  - debit (int4)
  - credit (int4)
  - record_date (date)
  - created_by (uuid) → FK to users
  - created_at (timestamp)

---

## Views (40+ views)

- cash_locations_with_total_amount
- geography_columns
- geometry_columns
- top_features_by_user
- v_account_mappings_with_linked_company
- v_balance_sheet_by_store
- v_bank_amount
- v_cash_location
- v_cron_job_status
- v_depreciation_process_status
- v_depreciation_summary
- v_income_statement_by_store
- v_journal_lines_complete
- v_journal_lines_readable
- v_monthly_depreciation_summary
- v_salary_individual
- v_shift_request
- v_shift_request_with_realtime_problem
- v_shift_request_with_user
- v_store_balance_summary
- v_store_income_summary
- v_store_shifts
- v_user_role_info
- v_user_salary
- v_user_salary_working
- v_user_stores
- view_cashier_real_latest_total
- view_company_currency
- view_roles_with_permissions

---

## Functions (887 total)

Too many to list all. Key functions include cash management, HR operations, accounting processes, shift management, and various triggers.

---

**Database Type**: SUPABASE (PostgreSQL)
