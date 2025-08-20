# SUPABASE Database Schema Documentation

**Project**: Lux  
**Owner**: williamwls130@gmail.com  
**Project ID**: atkekzwgukdvucqntryo  
**Last Updated**: 2025-08-19

---

## 📊 Table of Contents

1. [Core Business Tables](#core-business-tables)
2. [Financial Tables](#financial-tables)
3. [HR & Shift Management](#hr--shift-management)
4. [Permission & Feature Management](#permission--feature-management)
5. [Notification System Tables](#notification-system-tables)
6. [Cash Management Tables](#cash-management-tables)
7. [Asset Management Tables](#asset-management-tables)
8. [Additional Tables](#additional-tables)
9. [Views](#views)
10. [Data Flow Overview](#data-flow-overview)

---

## Core Business Tables

### 1. **users**
사용자 정보를 저장하는 핵심 테이블
```sql
- user_id (uuid, PK, default: gen_random_uuid())
- first_name (varchar)
- last_name (varchar)
- email (varchar, unique)
- password_hash (text)
- profile_image (text) -- 프로필 이미지
- fcm_token (text) -- FCM 토큰
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp, default: CURRENT_TIMESTAMP)
- updated_at (timestamp, default: CURRENT_TIMESTAMP)
```

### 2. **companies**
회사 정보 관리
```sql
- company_id (uuid, PK, default: gen_random_uuid())
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
- company_type_id (uuid, PK, default: gen_random_uuid())
- type_name (varchar)
- created_at (timestamp, default: CURRENT_TIMESTAMP)
- updated_at (timestamp, default: CURRENT_TIMESTAMP)
```

### 4. **stores**
매장 정보 관리
```sql
- store_id (uuid, PK, default: gen_random_uuid())
- store_name (varchar)
- store_code (varchar)
- store_address (text)
- store_phone (varchar)
- store_location (geography) -- PostGIS 위치 정보
- store_qrcode (text)
- company_id (uuid, FK → companies)
- huddle_time (integer) -- 회의 시간
- payment_time (integer) -- 결제 시간
- allowed_distance (integer) -- 허용 거리
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp, default: CURRENT_TIMESTAMP)
- updated_at (timestamp, default: CURRENT_TIMESTAMP)
```

### 5. **user_companies**
사용자-회사 연결 테이블
```sql
- user_company_id (uuid, PK, default: gen_random_uuid())
- user_id (uuid, FK → users)
- company_id (uuid, FK → companies)
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp, default: CURRENT_TIMESTAMP)
- updated_at (timestamp, default: CURRENT_TIMESTAMP)
```

### 6. **user_stores**
사용자-매장 연결 테이블
```sql
- user_store_id (uuid, PK, default: gen_random_uuid())
- user_id (uuid, FK → users)
- store_id (uuid, FK → stores)
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp, default: CURRENT_TIMESTAMP)
- updated_at (timestamp, default: CURRENT_TIMESTAMP)
```

---

## Financial Tables

### 7. **accounts**
계정 과목 마스터
```sql
- account_id (uuid, PK, default: gen_random_uuid())
- account_name (text, NOT NULL)
- account_type (text, NOT NULL) -- CHECK: asset/liability/equity/income/expense
- expense_nature (text) -- CHECK: fixed/variable
- category_tag (text)
- debt_tag (text)
- statement_category (text)
- statement_detail_category (text)
- description (text)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 8. **journal_entries**
분개 전표 헤더
```sql
- entry_id (uuid, PK, default: gen_random_uuid())
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
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 9. **journal_lines**
분개 전표 상세
```sql
- line_id (uuid, PK, default: gen_random_uuid())
- entry_id (uuid, FK → journal_entries)
- account_id (uuid, FK → accounts)
- store_id (uuid, FK → stores)
- counterparty_id (uuid, FK → counterparties)
- debit_amount (numeric, default: 0)
- credit_amount (numeric, default: 0)
- description (text)
- tags (jsonb)
- created_at (timestamp, default: now())
```

### 10. **journal_attachments**
분개 첨부파일
```sql
- attachment_id (uuid, PK, default: gen_random_uuid())
- entry_id (uuid, FK → journal_entries)
- file_name (text)
- file_url (text)
- file_type (text)
- file_size (integer)
- uploaded_by (uuid, FK → users)
- uploaded_at (timestamp, default: now())
```

### 11. **counterparties**
거래처 정보
```sql
- counterparty_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- name (text, NOT NULL)
- type (text)
- email (text)
- phone (text)
- address (text)
- notes (text)
- is_internal (boolean, default: false, NOT NULL)
- linked_company_id (uuid, FK → companies)
- created_by (uuid, FK → users)
- is_deleted (boolean, default: false, NOT NULL)
- created_at (timestamp, default: now())
```

### 12. **debts_receivable**
채권/채무 관리
```sql
- debt_id (uuid, PK, default: gen_random_uuid())
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
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 13. **recurring_journals**
반복 분개 설정
```sql
- recurring_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies)
- template_name (text)
- frequency (text) -- daily/weekly/monthly/quarterly/yearly
- next_run_date (date)
- last_run_date (date)
- is_active (boolean, default: true)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 14. **recurring_journal_lines**
반복 분개 상세
```sql
- line_id (uuid, PK, default: gen_random_uuid())
- recurring_id (uuid, FK → recurring_journals)
- account_id (uuid, FK → accounts)
- debit_amount (numeric, default: 0)
- credit_amount (numeric, default: 0)
- description (text)
- created_at (timestamp, default: now())
```

---

## HR & Shift Management

### 15. **roles**
역할 정의
```sql
- role_id (uuid, PK, default: gen_random_uuid())
- role_name (varchar)
- role_type (varchar)
- company_id (uuid, FK → companies)
- parent_role_id (uuid, FK → roles)
- description (text)
- tags (jsonb)
- icon (text) -- 아이콘 식별자
- is_deletable (boolean, default: true)
- created_at (timestamp, default: CURRENT_TIMESTAMP)
- updated_at (timestamp, default: CURRENT_TIMESTAMP)
```

### 16. **user_roles**
사용자-역할 연결
```sql
- user_role_id (uuid, PK, default: gen_random_uuid())
- user_id (uuid, FK → users)
- role_id (uuid, FK → roles)
- is_deleted (boolean, default: false)
- deleted_at (timestamp)
- created_at (timestamp, default: CURRENT_TIMESTAMP)
- updated_at (timestamp, default: CURRENT_TIMESTAMP)
```

### 17. **user_salaries**
급여 정보
```sql
- salary_id (uuid, PK, default: gen_random_uuid())
- user_id (uuid, FK → users, NOT NULL)
- company_id (uuid, FK → companies, NOT NULL)
- salary_amount (numeric, NOT NULL)
- salary_type (text, NOT NULL) -- CHECK: monthly/hourly
- bonus_amount (numeric, default: 0)
- currency_id (uuid, FK → currency_types)
- account_id (uuid, FK → accounts, NOT NULL)
- edited_by (uuid, FK → users)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 18. **store_shifts**
매장 근무 시프트
```sql
- shift_id (uuid, PK, default: gen_random_uuid())
- store_id (uuid, FK → stores, NOT NULL)
- shift_name (text, NOT NULL)
- start_time (time, NOT NULL)
- end_time (time, NOT NULL)
- number_shift (integer, default: 1) -- 근무 인원
- is_can_overtime (boolean, NOT NULL) -- 초과근무 가능 여부
- is_active (boolean, default: true)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 19. **shift_requests**
근무 신청/기록
```sql
- shift_request_id (uuid, PK, default: gen_random_uuid())
- user_id (uuid, FK → users, NOT NULL)
- shift_id (uuid, FK → store_shifts, NOT NULL)
- store_id (uuid, FK → stores, NOT NULL)
- request_date (date, NOT NULL)
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
- bonus_amount (numeric, default: 0)
- checkin_location (geography)
- checkin_distance_from_store (float8)
- is_valid_checkin_location (boolean)
- checkout_location (geography)
- checkout_distance_from_store (float8)
- is_valid_checkout_location (boolean)
- notice_tag (jsonb) -- 지각/조퇴/결근 사유
- is_reported (boolean, default: false) -- 문제 보고 여부
- report_time (timestamp)
- problem_type (text)
- is_problem (boolean, default: false) -- 문제 발생 여부
- is_problem_solved (boolean, default: false, NOT NULL) -- 문제 해결 여부
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 20. **shift_edit_logs**
근무 시간 수정 이력
```sql
- log_id (uuid, PK, default: gen_random_uuid())
- shift_request_id (uuid, FK → shift_requests, NOT NULL)
- edited_by (uuid, FK → users, NOT NULL)
- field_name (text, NOT NULL)
- old_value (text)
- new_value (text)
- edit_reason (text)
- edited_at (timestamp, default: now(), NOT NULL)
```

---

## Permission & Feature Management

### 21. **categories**
기능 카테고리
```sql
- category_id (uuid, PK, default: gen_random_uuid())
- name (varchar, NOT NULL)
- icon (varchar)
- created_at (timestamp, default: now())
```

### 22. **features**
기능 정의
```sql
- feature_id (uuid, PK, default: gen_random_uuid())
- category_id (uuid, FK → categories)
- feature_name (varchar, NOT NULL)
- icon (varchar) -- URL 형식
- icon_key (varchar) -- Font Awesome 키
- route (varchar)
- is_show_main (boolean, default: true) -- 메인 화면 표시 여부
- created_at (timestamp, default: now())
```

### 23. **role_permissions**
역할별 권한
```sql
- role_permission_id (uuid, PK, default: gen_random_uuid())
- role_id (uuid, FK → roles)
- feature_id (uuid, FK → features)
- can_access (boolean, default: false)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

---

## Notification System Tables

### 24. **notifications**
알림 내역 저장
```sql
- id (uuid, PK, default: gen_random_uuid())
- user_id (uuid, FK → users)
- title (text, NOT NULL)
- body (text, NOT NULL)
- category (varchar)
- data (jsonb) -- 추가 데이터
- image_url (text) -- 이미지 URL
- action_url (text) -- 액션 URL
- is_read (boolean, default: false)
- scheduled_time (timestamptz) -- 예약 발송 시간
- sent_at (timestamptz) -- 발송 시간
- read_at (timestamptz) -- 읽은 시간
- created_at (timestamptz, default: now())
- updated_at (timestamptz, default: now())
```

### 25. **user_fcm_tokens**
사용자 FCM 토큰 관리
```sql
- id (uuid, PK, default: gen_random_uuid())
- user_id (uuid, FK → users)
- token (text, NOT NULL)
- platform (varchar, NOT NULL) -- ios/android/web
- device_id (varchar) -- 디바이스 식별자
- device_model (varchar) -- 디바이스 모델
- app_version (varchar) -- 앱 버전
- is_active (boolean, default: true)
- created_at (timestamptz, default: now())
- updated_at (timestamptz, default: now())
- last_used_at (timestamptz, default: now())
```

### 26. **user_notification_settings**
사용자별 알림 설정
```sql
- id (uuid, PK, default: gen_random_uuid())
- user_id (uuid, FK → users)
- push_enabled (boolean, default: true)
- email_enabled (boolean, default: true)
- transaction_alerts (boolean, default: true)
- reminders (boolean, default: true)
- marketing_messages (boolean, default: true)
- sound_preference (varchar, default: 'default')
- vibration_enabled (boolean, default: true)
- category_preferences (jsonb, default: '{}')
- created_at (timestamptz, default: now())
- updated_at (timestamptz, default: now())
```

---

## Cash Management Tables

### 27. **currency_types**
통화 유형 마스터
```sql
- currency_id (uuid, PK, default: gen_random_uuid())
- currency_code (text, unique, NOT NULL) -- ISO 코드 (USD, VND 등)
- currency_name (text)
- symbol (text) -- 통화 기호 ($, ₫ 등)
- flag_emoji (text)
- created_at (timestamp, default: now())
```

### 28. **company_currency**
회사별 사용 통화
```sql
- id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- currency_id (uuid, FK → currency_types, NOT NULL)
- is_active (boolean, default: true)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 29. **currency_denominations**
화폐 단위 정보
```sql
- denomination_id (uuid, PK, default: gen_random_uuid())
- currency_id (uuid, FK → currency_types, NOT NULL)
- company_id (uuid, FK → companies, NOT NULL)
- denomination_value (numeric, NOT NULL)
- denomination_type (text, NOT NULL) -- bill/coin
- display_order (integer)
- is_active (boolean, default: true)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 30. **cash_locations**
현금 보관 위치
```sql
- location_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- store_id (uuid, FK → stores)
- location_name (text, NOT NULL)
- location_type (text, NOT NULL) -- cashier/bank/vault
- is_active (boolean, default: true)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 31. **cash_control**
현금 관리
```sql
- control_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- store_id (uuid, FK → stores)
- location_id (uuid, FK → cash_locations, NOT NULL)
- control_date (date, NOT NULL)
- control_type (text, NOT NULL) -- opening/closing/adjustment
- entry_id (uuid, FK → journal_entries)
- created_by (uuid, FK → users)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 32. **cashier_amount_lines**
계산대 현금 상세
```sql
- line_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- store_id (uuid, FK → stores)
- location_id (uuid, FK → cash_locations, NOT NULL)
- currency_id (uuid, FK → currency_types, NOT NULL)
- denomination_id (uuid, FK → currency_denominations)
- quantity (integer, NOT NULL)
- amount (numeric, NOT NULL)
- entry_id (uuid, FK → journal_entries)
- created_by (uuid, FK → users)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 33. **bank_amount**
은행 잔액 정보
```sql
- bank_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- store_id (uuid, FK → stores)
- location_id (uuid, FK → cash_locations, NOT NULL)
- currency_id (uuid, FK → currency_types, NOT NULL)
- amount (numeric, NOT NULL)
- entry_id (uuid, FK → journal_entries)
- created_by (uuid, FK → users)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 34. **vault_amount_line**
금고 현금 상세
```sql
- vault_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- store_id (uuid, FK → stores)
- location_id (uuid, FK → cash_locations, NOT NULL)
- currency_id (uuid, FK → currency_types, NOT NULL)
- denomination_id (uuid, FK → currency_denominations)
- quantity (integer, NOT NULL)
- amount (numeric, NOT NULL)
- entry_id (uuid, FK → journal_entries)
- created_by (uuid, FK → users)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 35. **book_exchange_rates**
장부 환율
```sql
- rate_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- from_currency_id (uuid, FK → currency_types, NOT NULL)
- to_currency_id (uuid, FK → currency_types, NOT NULL)
- exchange_rate (numeric, NOT NULL)
- effective_date (date, NOT NULL)
- created_by (uuid, FK → users)
- created_at (timestamp, default: now())
```

---

## Asset Management Tables

### 36. **fixed_assets**
고정자산 관리
```sql
- asset_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- store_id (uuid, FK → stores)
- asset_name (text, NOT NULL)
- asset_code (text)
- account_id (uuid, FK → accounts, NOT NULL)
- acquisition_date (date, NOT NULL)
- acquisition_cost (numeric, NOT NULL)
- depreciation_method_id (uuid, FK → depreciation_methods)
- useful_life_years (integer)
- salvage_value (numeric)
- current_value (numeric)
- accumulated_depreciation (numeric)
- last_depreciation_date (date)
- disposal_date (date)
- disposal_value (numeric)
- status (text)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 37. **depreciation_methods**
감가상각 방법
```sql
- method_id (uuid, PK, default: gen_random_uuid())
- method_name (text, NOT NULL)
- method_code (text)
- description (text)
- created_at (timestamp, default: now())
```

### 38. **depreciation_process_log**
감가상각 처리 로그
```sql
- log_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- process_date (date, NOT NULL)
- assets_processed (integer)
- total_depreciation (numeric)
- status (text)
- error_message (text)
- processed_at (timestamp, default: now(), NOT NULL)
```

---

## Additional Tables

### 39. **fiscal_years**
회계연도
```sql
- fiscal_year_id (uuid, PK, default: gen_random_uuid())
- company_id (uuid, FK → companies, NOT NULL)
- year (integer, NOT NULL)
- start_date (date, NOT NULL)
- end_date (date, NOT NULL)
- created_at (timestamp, default: now())
```

### 40. **fiscal_periods**
회계기간
```sql
- period_id (uuid, PK, default: gen_random_uuid())
- fiscal_year_id (uuid, FK → fiscal_years, NOT NULL)
- name (text, NOT NULL)
- start_date (date, NOT NULL)
- end_date (date, NOT NULL)
- created_at (timestamp, default: now())
```

### 41. **inventory_transactions**
재고 거래
```sql
- transaction_id (uuid, PK, default: gen_random_uuid())
- store_id (uuid, FK → stores, NOT NULL)
- transaction_type (text, NOT NULL)
- product_id (uuid)
- quantity (numeric, NOT NULL)
- unit_price (numeric)
- total_amount (numeric)
- entry_id (uuid, FK → journal_entries)
- created_at (timestamp, default: now())
```

### 42. **transaction_templates**
거래 템플릿
```sql
- template_id (uuid, PK, default: gen_random_uuid())
- template_name (text, NOT NULL)
- counterparty_id (uuid, FK → counterparties)
- description (text)
- tags (jsonb)
- is_active (boolean, default: true)
- created_at (timestamp, default: now())
- updated_at (timestamp, default: now())
```

### 43. **account_mappings**
계정 매핑 (회사간 거래)
```sql
- mapping_id (uuid, PK, default: gen_random_uuid())
- my_company_id (uuid, FK → companies, NOT NULL)
- my_account_id (uuid, FK → accounts, NOT NULL)
- counterparty_id (uuid, FK → counterparties, NOT NULL)
- linked_account_id (uuid, FK → accounts, NOT NULL)
- direction (text)
- created_by (uuid, FK → users)
- created_at (timestamp, default: now())
```
**Note**: linked_company_id는 counterparties 테이블의 linked_company_id를 통해 도출

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

### Notification Flow
```
users → user_notification_settings
  ↓           ↓
user_fcm_tokens → notifications
  ↓               ↓
device notifications ← push/local notifications
```

---

## 🔐 Security & RLS

다음 테이블들은 Row Level Security가 활성화되어 있습니다:
- users (forced RLS)
- notifications, user_fcm_tokens, user_notification_settings (currently disabled for testing)
- 기타 테이블들은 애플리케이션 레벨에서 보안 처리

---

## 📝 Notes

1. **Soft Delete Pattern**: 대부분의 테이블이 `is_deleted`와 `deleted_at` 필드를 사용
2. **Audit Trail**: `created_at`, `updated_at`, `created_by` 필드로 감사 추적
3. **UUID 사용**: 모든 PK는 UUID v4 사용 (`gen_random_uuid()`)
4. **JSONB Fields**: 유연한 데이터 저장을 위해 tags, notice_tag 등 JSONB 타입 활용
5. **Geography Type**: 위치 정보는 PostGIS의 geography 타입 사용
6. **Check Constraints**: account_type, expense_nature, salary_type 등에 CHECK 제약조건 적용

---

## 🆕 Recent Updates

- **2025-08-19**: 알림 시스템 테이블 추가
  - notifications 테이블 추가 (알림 내역 저장)
  - user_fcm_tokens 테이블 추가 (FCM 토큰 관리)
  - user_notification_settings 테이블 추가 (사용자별 알림 설정)
  - Notification Flow 데이터 흐름 다이어그램 추가
  - RLS 설정 상태 업데이트 (테스트를 위해 일시적으로 비활성화)

- **2025-01-22**: 전체 데이터베이스 스키마 최신화
  - 모든 테이블의 실제 구조 반영
  - RLS 설정 상태 업데이트
  - Check Constraints 추가
  - 누락된 테이블 추가 (journal_attachments, shift_edit_logs, depreciation 관련 등)
  - account_mappings 테이블 구조 수정 (linked_company_id는 counterparties를 통해 도출)

---

## 📚 Related Documents

- API Documentation: `/docs/api/`
- Migration Scripts: `/migrations/`
- Backup Procedures: `/docs/backup/`
- Supabase Setup Guide: `/docs/database/SUPABASE_SETUP.md`
