# SUPABASE Database Schema Documentation

**Project**: Lux  
**Owner**: williamwls130@gmail.com  
**Project ID**: atkekzwgukdvucqntryo  
**Last Updated**: 2025-01-22

---

## 📊 Table of Contents

1. [Core Business Tables](#core-business-tables)
2. [Financial Tables](#financial-tables)
3. [HR & Shift Management](#hr--shift-management)
4. [Permission & Feature Management](#permission--feature-management)
5. [Views](#views)
6. [Data Flow Overview](#data-flow-overview)

---

## Core Business Tables

### 1. **users**
사용자 정보를 저장하는 핵심 테이블
```sql
- user_id (uuid, PK)
- first_name (varchar)
- last_name (varchar)
- email (varchar, unique)
- password_hash (text)
- profile_image (text)
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp, default: CURRENT_TIMESTAMP)
- updated_at (timestamp, default: CURRENT_TIMESTAMP)
```

### 2. **companies**
회사 정보 관리
```sql
- company_id (uuid, PK)
- company_name (varchar)
- company_code (varchar)
- company_type_id (uuid, FK → company_types)
- owner_id (uuid, FK → users)
- base_currency_id (uuid, FK → currency_types)
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp, default: CURRENT_TIMESTAMP)
- updated_at (timestamp, default: CURRENT_TIMESTAMP)
```

### 3. **company_types**
회사 유형 분류
```sql
- company_type_id (uuid, PK)
- type_name (varchar)
- created_at (timestamp)
- updated_at (timestamp)
```

### 4. **stores**
매장 정보 관리
```sql
- store_id (uuid, PK)
- store_name (varchar)
- store_code (varchar)
- store_address (text)
- store_phone (varchar)
- store_location (geography) -- 위치 정보
- store_qrcode (text)
- company_id (uuid, FK → companies)
- huddle_time (integer) -- 회의 시간
- payment_time (integer) -- 결제 시간
- allowed_distance (integer) -- 허용 거리
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp)
- updated_at (timestamp)
```

### 5. **user_companies**
사용자-회사 연결 테이블
```sql
- user_company_id (uuid, PK)
- user_id (uuid, FK → users)
- company_id (uuid, FK → companies)
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp)
- updated_at (timestamp)
```

### 6. **user_stores**
사용자-매장 연결 테이블
```sql
- user_store_id (uuid, PK)
- user_id (uuid, FK → users)
- store_id (uuid, FK → stores)
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp)
- updated_at (timestamp)
```

---

## Financial Tables

### 7. **accounts**
계정 과목 마스터
```sql
- account_id (uuid, PK)
- account_name (text)
- account_type (text) -- asset/liability/equity/income/expense
- expense_nature (text) -- fixed/variable
- category_tag (text)
- debt_tag (text)
- statement_category (text)
- statement_detail_category (text)
- description (text)
- created_at (timestamp)
- updated_at (timestamp)
```

### 8. **journal_entries**
분개 전표 헤더
```sql
- entry_id (uuid, PK)
- company_id (uuid, FK → companies)
- store_id (uuid, FK → stores)
- entry_date (date)
- description (text)
- reference_number (text)
- counterparty_id (uuid, FK → counterparties)
- currency_id (uuid, FK → currency_types)
- exchange_rate (numeric)
- period_id (uuid, FK → fiscal_periods)
- is_posted (boolean)
- is_reversed (boolean)
- reversed_entry_id (uuid, FK → journal_entries)
- created_by (uuid, FK → users)
- approved_by (uuid, FK → users)
- created_at (timestamp)
- updated_at (timestamp)
```

### 9. **journal_lines**
분개 전표 상세
```sql
- line_id (uuid, PK)
- entry_id (uuid, FK → journal_entries)
- account_id (uuid, FK → accounts)
- store_id (uuid, FK → stores)
- counterparty_id (uuid, FK → counterparties)
- debit_amount (numeric)
- credit_amount (numeric)
- description (text)
- tags (jsonb)
- created_at (timestamp)
```

### 10. **counterparties**
거래처 정보
```sql
- counterparty_id (uuid, PK)
- company_id (uuid, FK → companies)
- name (text)
- type (text)
- email (text)
- phone (text)
- address (text)
- notes (text)
- is_internal (boolean, default: false)
- linked_company_id (uuid, FK → companies)
- created_by (uuid, FK → users)
- is_deleted (boolean, default: false)
- created_at (timestamp)
```

### 11. **currency_types**
통화 유형 마스터
```sql
- currency_id (uuid, PK)
- currency_code (text, unique) -- USD, VND 등
- currency_name (text)
- symbol (text) -- $, ₫ 등
- flag_emoji (text)
- created_at (timestamp)
```

### 12. **currency_denominations**
화폐 단위 정보
```sql
- denomination_id (uuid, PK)
- currency_id (uuid, FK → currency_types)
- company_id (uuid, FK → companies)
- denomination_value (numeric)
- denomination_type (text) -- bill/coin
- display_order (integer)
- is_active (boolean)
- created_at (timestamp)
- updated_at (timestamp)
```

### 13. **cash_locations**
현금 보관 위치
```sql
- location_id (uuid, PK)
- company_id (uuid, FK → companies)
- store_id (uuid, FK → stores)
- location_name (text)
- location_type (text) -- cashier/bank/vault
- is_active (boolean)
- created_at (timestamp)
- updated_at (timestamp)
```

### 14. **cashier_amount_lines**
계산대 현금 상세
```sql
- line_id (uuid, PK)
- company_id (uuid, FK → companies)
- store_id (uuid, FK → stores)
- location_id (uuid, FK → cash_locations)
- currency_id (uuid, FK → currency_types)
- denomination_id (uuid, FK → currency_denominations)
- quantity (integer)
- amount (numeric)
- entry_id (uuid, FK → journal_entries)
- created_by (uuid, FK → users)
- created_at (timestamp)
- updated_at (timestamp)
```

### 15. **bank_amount**
은행 잔액 정보
```sql
- bank_id (uuid, PK)
- company_id (uuid, FK → companies)
- store_id (uuid, FK → stores)
- location_id (uuid, FK → cash_locations)
- currency_id (uuid, FK → currency_types)
- amount (numeric)
- entry_id (uuid, FK → journal_entries)
- created_by (uuid, FK → users)
- created_at (timestamp)
- updated_at (timestamp)
```

### 16. **vault_amount_line**
금고 현금 상세
```sql
- vault_id (uuid, PK)
- company_id (uuid, FK → companies)
- store_id (uuid, FK → stores)
- location_id (uuid, FK → cash_locations)
- currency_id (uuid, FK → currency_types)
- denomination_id (uuid, FK → currency_denominations)
- quantity (integer)
- amount (numeric)
- entry_id (uuid, FK → journal_entries)
- created_by (uuid, FK → users)
- created_at (timestamp)
- updated_at (timestamp)
```

### 17. **debts_receivable**
채권/채무 관리
```sql
- debt_id (uuid, PK)
- company_id (uuid, FK → companies)
- store_id (uuid, FK → stores)
- counterparty_id (uuid, FK → counterparties)
- debt_type (text) -- receivable/payable
- original_amount (numeric)
- remaining_amount (numeric)
- account_id (uuid, FK → accounts)
- interest_rate (numeric)
- interest_account_id (uuid, FK → accounts)
- due_date (date)
- entry_id (uuid, FK → journal_entries)
- is_internal (boolean)
- linked_company_id (uuid, FK → companies)
- linked_company_store_id (uuid, FK → stores)
- status (text)
- created_at (timestamp)
- updated_at (timestamp)
```

### 18. **fixed_assets**
고정자산 관리
```sql
- asset_id (uuid, PK)
- company_id (uuid, FK → companies)
- store_id (uuid, FK → stores)
- asset_name (text)
- asset_code (text)
- account_id (uuid, FK → accounts)
- acquisition_date (date)
- acquisition_cost (numeric)
- depreciation_method_id (uuid, FK → depreciation_methods)
- useful_life_years (integer)
- salvage_value (numeric)
- current_value (numeric)
- accumulated_depreciation (numeric)
- last_depreciation_date (date)
- disposal_date (date)
- disposal_value (numeric)
- status (text)
- created_at (timestamp)
- updated_at (timestamp)
```

---

## HR & Shift Management

### 19. **roles**
역할 정의
```sql
- role_id (uuid, PK)
- role_name (varchar)
- role_type (varchar)
- company_id (uuid, FK → companies)
- parent_role_id (uuid, FK → roles)
- description (text)
- tags (jsonb)
- icon (text)
- is_deletable (boolean, default: true)
- created_at (timestamp)
- updated_at (timestamp)
```

### 20. **user_roles**
사용자-역할 연결
```sql
- user_role_id (uuid, PK)
- user_id (uuid, FK → users)
- role_id (uuid, FK → roles)
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp)
- updated_at (timestamp)
```

### 21. **user_salaries**
급여 정보
```sql
- salary_id (uuid, PK)
- user_id (uuid, FK → users)
- company_id (uuid, FK → companies)
- salary_amount (numeric)
- salary_type (text) -- monthly/hourly
- bonus_amount (numeric, default: 0)
- currency_id (uuid, FK → currency_types)
- account_id (uuid, FK → accounts)
- edited_by (uuid, FK → users)
- created_at (timestamp)
- updated_at (timestamp)
```

### 22. **store_shifts**
매장 근무 시프트
```sql
- shift_id (uuid, PK)
- store_id (uuid, FK → stores)
- shift_name (text)
- start_time (time)
- end_time (time)
- number_shift (integer, default: 1) -- 근무 인원
- is_can_overtime (boolean) -- 초과근무 가능 여부
- is_active (boolean, default: true)
- created_at (timestamp)
- updated_at (timestamp)
```

### 23. **shift_requests**
근무 신청/기록
```sql
- shift_request_id (uuid, PK)
- user_id (uuid, FK → users)
- shift_id (uuid, FK → store_shifts)
- store_id (uuid, FK → stores)
- request_date (date)
- start_time (timestamp)
- end_time (timestamp)
- actual_start_time (timestamp)
- actual_end_time (timestamp)
- confirm_start_time (timestamp)
- confirm_end_time (timestamp)
- is_approved (boolean, default: false)
- approved_by (uuid, FK → users)
- is_late (boolean)
- is_extratime (boolean)
- overtime_amount (numeric)
- late_deducut_amount (numeric)
- bonus_amount (numeric)
- checkin_location (geography)
- checkin_distance_from_store (float)
- is_valid_checkin_location (boolean)
- checkout_location (geography)
- checkout_distance_from_store (float)
- is_valid_checkout_location (boolean)
- notice_tag (jsonb) -- 사유 태그
- is_reported (boolean) -- 문제 보고 여부
- report_time (timestamp)
- problem_type (text)
- is_problem (boolean) -- 문제 발생 여부
- is_problem_solved (boolean) -- 문제 해결 여부
- created_at (timestamp)
- updated_at (timestamp)
```

### 24. **shift_edit_logs**
근무 시간 수정 이력
```sql
- log_id (uuid, PK)
- shift_request_id (uuid, FK → shift_requests)
- edited_by (uuid, FK → users)
- field_name (text)
- old_value (text)
- new_value (text)
- edit_reason (text)
- edited_at (timestamp)
```

---

## Permission & Feature Management

### 25. **categories**
기능 카테고리
```sql
- category_id (uuid, PK)
- name (varchar)
- icon (varchar)
- created_at (timestamp)
```

### 26. **features**
기능 정의
```sql
- feature_id (uuid, PK)
- category_id (uuid, FK → categories)
- feature_name (varchar)
- icon (varchar) -- URL (기존)
- icon_key (varchar) -- Font Awesome 키 (신규)
- route (varchar)
- created_at (timestamp)
```

### 27. **role_permissions**
역할별 권한
```sql
- role_permission_id (uuid, PK)
- role_id (uuid, FK → roles)
- feature_id (uuid, FK → features)
- can_access (boolean, default: false)
- created_at (timestamp)
- updated_at (timestamp)
```

---

## Additional Tables

### 28. **fiscal_years**
회계연도
```sql
- fiscal_year_id (uuid, PK)
- company_id (uuid, FK → companies)
- year (integer)
- start_date (date)
- end_date (date)
- created_at (timestamp)
```

### 29. **fiscal_periods**
회계기간
```sql
- period_id (uuid, PK)
- fiscal_year_id (uuid, FK → fiscal_years)
- name (text)
- start_date (date)
- end_date (date)
- created_at (timestamp)
```

### 30. **book_exchange_rates**
장부 환율
```sql
- rate_id (uuid, PK)
- company_id (uuid, FK → companies)
- from_currency_id (uuid, FK → currency_types)
- to_currency_id (uuid, FK → currency_types)
- exchange_rate (numeric)
- effective_date (date)
- created_by (uuid, FK → users)
- created_at (timestamp)
```

### 31. **transaction_templates**
거래 템플릿
```sql
- template_id (uuid, PK)
- template_name (text)
- counterparty_id (uuid, FK → counterparties)
- description (text)
- tags (jsonb)
- is_active (boolean)
- created_at (timestamp)
- updated_at (timestamp)
```

### 32. **account_mappings**
계정 매핑 (회사간 거래)
```sql
- mapping_id (uuid, PK)
- my_company_id (uuid, FK → companies)
- my_account_id (uuid, FK → accounts)
- counterparty_id (uuid, FK → counterparties)
- linked_company_id (uuid, FK → companies)
- linked_account_id (uuid, FK → accounts)
- is_active (boolean)
- created_at (timestamp)
- updated_at (timestamp)
```

### 33. **depreciation_methods**
감가상각 방법
```sql
- method_id (uuid, PK)
- method_name (text)
- method_code (text)
- description (text)
- created_at (timestamp)
```

### 34. **depreciation_process_log**
감가상각 처리 로그
```sql
- log_id (uuid, PK)
- company_id (uuid, FK → companies)
- process_date (date)
- assets_processed (integer)
- total_depreciation (numeric)
- status (text)
- error_message (text)
- processed_at (timestamp)
```

---

## Views

### Financial Views
- **v_balance_sheet_by_store** - 매장별 대차대조표
- **v_income_statement_by_store** - 매장별 손익계산서
- **v_store_balance_summary** - 매장 잔액 요약
- **v_store_income_summary** - 매장 수익 요약
- **v_journal_lines_complete** - 완전한 분개 내역
- **v_journal_lines_readable** - 읽기 쉬운 분개 내역

### Cash Management Views
- **v_cash_location** - 현금 위치 정보
- **v_bank_amount** - 은행 잔액 조회
- **view_cashier_real_latest_total** - 최신 계산대 현금 합계

### HR & Shift Views
- **v_shift_request** - 근무 신청 조회
- **v_shift_request_with_user** - 사용자 정보 포함 근무 신청
- **v_shift_request_with_realtime_problem** - 실시간 문제 포함 근무 신청
- **v_store_shifts** - 매장 시프트 조회
- **v_user_salary** - 사용자 급여 조회
- **v_user_salary_working** - 근무중인 직원 급여
- **v_salary_individual** - 개인별 급여 상세

### Permission Views
- **view_roles_with_permissions** - 권한 포함 역할 조회
- **v_user_role_info** - 사용자 역할 정보
- **top_features_by_user** - 사용자별 주요 기능

### Asset Management Views
- **v_depreciation_summary** - 감가상각 요약
- **v_monthly_depreciation_summary** - 월별 감가상각 요약
- **v_depreciation_process_status** - 감가상각 처리 상태
- **v_cron_job_status** - 자동화 작업 상태

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

### Permission Flow
```
roles → role_permissions → features → categories
  ↓
user_roles → users
```

### Cash Management Flow
```
cash_locations (cashier/bank/vault)
       ↓
cashier_amount_lines / bank_amount / vault_amount_line
       ↓
currency_denominations → currency_types
```

---

## 🔐 Security & RLS

다음 테이블들은 Row Level Security가 활성화되어 있습니다:
- users (forced)
- 기타 테이블들은 애플리케이션 레벨에서 보안 처리

---

## 📝 Notes

1. **Soft Delete Pattern**: 대부분의 테이블이 `is_deleted`와 `deleted_at` 필드를 사용
2. **Audit Trail**: `created_at`, `updated_at`, `created_by` 필드로 감사 추적
3. **UUID 사용**: 모든 PK는 UUID v4 사용 (`gen_random_uuid()`)
4. **JSONB Fields**: 유연한 데이터 저장을 위해 tags, notice_tag 등 JSONB 타입 활용
5. **Geography Type**: 위치 정보는 PostGIS의 geography 타입 사용

---

## 💡 DESIGN ANALYSIS: Debt Account Mapping System (ULTRATHINK)

### 🎯 **Core Business Problem**
**Issue**: When internal companies (both in database) trade with each other, only one side records the transaction → **Data Integrity Violation**

**Example Scenario**:
- Company A lends money to Company B
- Company A records: "Account Receivable" (they are owed money)
- Company B records: **NOTHING** ← Problem!
- **Result**: Unbalanced books, audit failures, compliance issues

### 🔧 **Solution: Automated Debt Mapping**
**Purpose**: Ensure BOTH internal companies automatically record their side of debt transactions

**Business Logic**:
- Company A → "Account Receivable" (automatic)
- Company B → "Account Payable" (automatic via mapping)
- **Result**: Both sides balanced, data integrity maintained

### 📊 **Current Database Structure Analysis**

#### **Documented vs. Actual Schema Mismatch**
```sql
-- DOCUMENTED (lines 516-528)
account_mappings:
- mapping_id (uuid, PK)
- my_company_id (uuid, FK → companies)
- my_account_id (uuid, FK → accounts)
- counterparty_id (uuid, FK → counterparties)
- linked_company_id (uuid, FK → companies) ← MISSING!
- linked_account_id (uuid, FK → accounts)
- is_active (boolean) ← MISSING!
- created_at (timestamp)
- updated_at (timestamp) ← MISSING!

-- ACTUAL DATABASE STRUCTURE
account_mappings:
- mapping_id (uuid, PK)
- my_company_id (uuid, FK → companies)
- my_account_id (uuid, FK → accounts)
- counterparty_id (uuid, FK → counterparties)
- linked_account_id (uuid, FK → accounts)
- direction (unknown type) ← EXTRA COLUMN!
- created_by (uuid, FK → users)
- created_at (timestamp)
```

#### **Critical Missing Elements**
1. **`linked_company_id`** - How do we know which company the counterparty belongs to?
2. **`is_active`** - How do we soft-delete mappings?
3. **`updated_at`** - Audit trail missing
4. **`direction`** - Purpose unclear, not documented

### 🏗️ **RPC-Based Solution (NO Database Changes)**

#### **Constraint: Work with Existing Database Structure Only**
```sql
-- CURRENT STRUCTURE (cannot change):
account_mappings:
- mapping_id (uuid, PK)
- my_company_id (uuid, FK → companies)
- my_account_id (uuid, FK → accounts)
- counterparty_id (uuid, FK → counterparties)
- linked_account_id (uuid, FK → accounts)
- direction (unknown type) ← Need to understand this
- created_by (uuid, FK → users)
- created_at (timestamp)

-- DERIVED RELATIONSHIPS (via RPC):
- linked_company_id ← FROM counterparties.linked_company_id
- is_active ← ASSUME true unless soft deleted
- updated_at ← USE created_at or track in application
```

#### **RPC Functions for Account Mappings**
```sql
-- 1. Get account mappings with derived company information
CREATE OR REPLACE FUNCTION get_account_mappings_with_company(
    p_counterparty_id UUID
) RETURNS TABLE (
    mapping_id UUID,
    my_company_id UUID,
    my_account_id UUID,
    counterparty_id UUID,
    linked_account_id UUID,
    direction TEXT,
    created_by UUID,
    created_at TIMESTAMP,
    -- DERIVED FIELDS
    linked_company_id UUID,
    linked_company_name TEXT,
    my_account_name TEXT,
    linked_account_name TEXT
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        am.mapping_id,
        am.my_company_id,
        am.my_account_id,
        am.counterparty_id,
        am.linked_account_id,
        am.direction,
        am.created_by,
        am.created_at,
        -- Derive linked company from counterparty
        cp.linked_company_id,
        lc.company_name as linked_company_name,
        ma.account_name as my_account_name,
        la.account_name as linked_account_name
    FROM account_mappings am
    JOIN counterparties cp ON am.counterparty_id = cp.counterparty_id
    LEFT JOIN companies lc ON cp.linked_company_id = lc.company_id
    LEFT JOIN accounts ma ON am.my_account_id = ma.account_id
    LEFT JOIN accounts la ON am.linked_account_id = la.account_id
    WHERE am.counterparty_id = p_counterparty_id
    ORDER BY am.created_at DESC;
END;
$$;

-- 2. Create account mapping with validation
CREATE OR REPLACE FUNCTION create_account_mapping(
    p_my_company_id UUID,
    p_my_account_id UUID,
    p_counterparty_id UUID,
    p_linked_account_id UUID,
    p_direction TEXT DEFAULT 'debit_credit',
    p_created_by UUID
) RETURNS JSON LANGUAGE plpgsql AS $$
DECLARE
    v_result JSON;
    v_mapping_id UUID;
    v_linked_company_id UUID;
BEGIN
    -- Validate counterparty is internal
    SELECT linked_company_id INTO v_linked_company_id
    FROM counterparties 
    WHERE counterparty_id = p_counterparty_id AND is_internal = true;
    
    IF v_linked_company_id IS NULL THEN
        RETURN JSON_BUILD_OBJECT(
            'success', false,
            'error', 'Counterparty must be internal company',
            'code', 'INVALID_COUNTERPARTY'
        );
    END IF;
    
    -- Check for duplicates
    IF EXISTS (
        SELECT 1 FROM account_mappings 
        WHERE my_company_id = p_my_company_id 
        AND my_account_id = p_my_account_id
        AND counterparty_id = p_counterparty_id
        AND linked_account_id = p_linked_account_id
    ) THEN
        RETURN JSON_BUILD_OBJECT(
            'success', false,
            'error', 'Mapping already exists',
            'code', 'DUPLICATE_MAPPING'
        );
    END IF;
    
    -- Create mapping
    INSERT INTO account_mappings (
        my_company_id, my_account_id, counterparty_id, 
        linked_account_id, direction, created_by
    ) VALUES (
        p_my_company_id, p_my_account_id, p_counterparty_id,
        p_linked_account_id, p_direction, p_created_by
    ) RETURNING mapping_id INTO v_mapping_id;
    
    RETURN JSON_BUILD_OBJECT(
        'success', true,
        'mapping_id', v_mapping_id,
        'linked_company_id', v_linked_company_id
    );
END;
$$;

-- 3. Find inter-company journals that need corresponding entries
CREATE OR REPLACE FUNCTION find_inter_company_journals(
    p_target_company_id UUID
) RETURNS TABLE (
    source_entry_id UUID,
    source_company_id UUID,
    counterparty_id UUID,
    account_mappings JSON
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        je.entry_id,
        je.company_id,
        je.counterparty_id,
        JSON_AGG(
            JSON_BUILD_OBJECT(
                'mapping_id', am.mapping_id,
                'my_account_id', am.my_account_id,
                'linked_account_id', am.linked_account_id,
                'direction', am.direction
            )
        ) as account_mappings
    FROM journal_entries je
    JOIN counterparties cp ON je.counterparty_id = cp.counterparty_id
    JOIN account_mappings am ON am.counterparty_id = cp.counterparty_id
    WHERE cp.is_internal = true
    AND cp.linked_company_id = p_target_company_id
    AND NOT EXISTS (
        -- Check if corresponding entry already exists
        SELECT 1 FROM journal_entries existing
        WHERE existing.reference_number = je.reference_number
        AND existing.company_id = p_target_company_id
    )
    GROUP BY je.entry_id, je.company_id, je.counterparty_id;
END;
$$;
```

### 🔄 **Data Flow Design for Debt Mapping**

#### **1. Mapping Creation Process**
```
User selects:
├── Your Debt Account (Account Receivable/Payable)
├── Internal Counterparty (linked to another company)
├── Their Debt Account (corresponding Payable/Receivable)
└── Auto-derive: linked_company_id from counterparty
```

#### **2. Auto-Journal Entry Logic & Recognition**
```
Step 1: Company A creates journal entry
├── entry_id: "abc-123"
├── my_company_id: "company-a-id"
├── counterparty_id: "company-b-counterparty" (is_internal=true)
├── Debit: Account Receivable $1000
├── Credit: Cash $1000
├── source_entry_id: NULL (original entry)
└── is_auto_generated: false

Step 2: System detects internal counterparty
├── Check: counterparties.is_internal = true
├── Lookup: account_mappings for this counterparty + account
└── Find linked_company_id from counterparty

Step 3: Auto-create corresponding entry in Company B
├── entry_id: "def-456" (new)
├── my_company_id: "company-b-id" 
├── counterparty_id: "company-a-counterparty"
├── Debit: Expense $1000 (from mapping)
├── Credit: Account Payable $1000 (from mapping)
├── source_entry_id: "abc-123" ← LINKS BACK!
├── is_auto_generated: true
└── inter_company_ref: "INTER-2025-001"

Step 4: Bidirectional Recognition
├── Company A can find Company B's entry via: entry_id = "abc-123"
├── Company B knows source via: source_entry_id = "abc-123"
└── Both share: inter_company_ref = "INTER-2025-001"
```

#### **Inter-Company Journal Recognition Query**
```sql
-- How Company B finds journals that affect them
SELECT je.* 
FROM journal_entries je
JOIN counterparties cp ON je.counterparty_id = cp.counterparty_id
WHERE cp.is_internal = true 
  AND cp.linked_company_id = 'company-b-id'
  AND je.is_auto_generated = false; -- Original entries only

-- How to find the corresponding auto-generated entry
SELECT target_entry.*
FROM journal_entries source_entry
JOIN journal_entries target_entry ON target_entry.source_entry_id = source_entry.entry_id
WHERE source_entry.entry_id = 'abc-123';
```

#### **3. Account Filtering Rules**
```sql
-- Only show debt accounts for mapping
SELECT * FROM accounts 
WHERE category_tag ILIKE '%payable%' 
   OR category_tag ILIKE '%receivable%'
   OR debt_tag IS NOT NULL;
```

### 🎯 **Page Design Specifications**

#### **Debt Account Settings Page Purpose**
- **Primary Function**: Manage debt mappings between internal companies
- **Secondary Function**: Ensure data integrity for inter-company transactions
- **Tertiary Function**: Automate corresponding journal entries

#### **Form Field Requirements**
```yaml
Your Debt Account:
  source: accounts table
  filter: debt_tag NOT NULL OR category_tag LIKE '%payable%' OR '%receivable%'
  display: "Account Name (Account Type)"
  
Linked Company:
  source: counterparties table
  filter: is_internal = true
  auto_derive: linked_company_id from selected counterparty
  
Their Debt Account:
  source: accounts table  
  filter: same as "Your Debt Account"
  dependency: requires linked company selection first
```

#### **Validation Rules**
```yaml
business_rules:
  - cannot_map_same_account: my_account_id ≠ linked_account_id
  - must_be_debt_accounts: both accounts must have debt_tag or payable/receivable
  - internal_only: counterparty.is_internal must be true
  - unique_mapping: no duplicate mappings for same account combination
  - reciprocal_logic: if A→B exists, B→A should be complementary
```

### 🔒 **Security & Data Integrity**

#### **Row Level Security (RLS)**
```sql
-- Users can only access mappings for companies they belong to
CREATE POLICY account_mappings_policy ON account_mappings
FOR ALL TO authenticated
USING (
    my_company_id IN (
        SELECT company_id FROM user_companies 
        WHERE user_id = auth.uid() AND is_deleted = false
    )
    OR
    linked_company_id IN (
        SELECT company_id FROM user_companies 
        WHERE user_id = auth.uid() AND is_deleted = false
    )
);
```

#### **Data Integrity Checks**
```sql
-- Ensure counterparty is actually internal
ALTER TABLE account_mappings 
ADD CONSTRAINT chk_internal_counterparty 
CHECK (
    EXISTS (
        SELECT 1 FROM counterparties 
        WHERE counterparty_id = account_mappings.counterparty_id 
        AND is_internal = true
    )
);
```


### 🚨 **Critical Issues to Address**

#### **Immediate Priority**
1. **Schema Mismatch**: Fix account_mappings table structure
2. **Missing Business Logic**: linked_company_id derivation
3. **Form Filtering**: Only show debt accounts
4. **Data Validation**: Ensure internal-only mappings

#### **Medium Priority**
1. **Auto-Journal Design**: How to create corresponding entries
2. **Conflict Resolution**: What if mappings conflict?
3. **Historical Data**: How to handle existing transactions?
4. **Performance**: Optimization for large-scale operations

#### **Future Considerations**
1. **Multi-Currency**: How do mappings work across currencies?
2. **Complex Transactions**: Multiple account mappings in one entry?
3. **Approval Workflows**: Should mappings require approval?
4. **Reporting**: Analytics and insights on inter-company transactions

### 🎯 **Success Metrics**

#### **Data Integrity**
- Zero unmatched debt transactions between internal companies
- 100% automated corresponding entry creation
- Audit trail completeness for all mapped transactions

#### **User Experience**
- <3 clicks to create a debt mapping
- Clear explanation of mapping purpose and impact
- Real-time validation feedback

#### **System Performance**
- <500ms mapping creation time
- <1s account filtering response
- Scalable to 1000+ internal companies

---

## 🆕 Recent Updates

- **2025-01-22**: `features` 테이블에 `icon_key` 컬럼 추가 (Font Awesome 아이콘 매핑)
- 모든 feature에 적절한 Font Awesome 아이콘 키 할당 완료
- **2025-01-22**: Added comprehensive debt account mapping system design analysis

---

## 📚 Related Documents

- API Documentation: `/docs/api/`
- Migration Scripts: `/migrations/`
- Backup Procedures: `/docs/backup/`
