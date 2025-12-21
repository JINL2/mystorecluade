# Journal Input - RPC 함수 명세서 (데이터베이스 팀용)

## 문서 정보
- **대상**: 데이터베이스 팀
- **목적**: RPC 함수 UTC 마이그레이션 가이드
- **긴급도**: 보통 (신규 배포 전까지)
- **작성일**: 2025-11-25

---

## 📊 현황 요약

### 현재 사용 중인 RPC 함수 (3개)

| RPC 함수명 | 마이그레이션 필요 | 이유 |
|-----------|------------------|------|
| `get_cash_locations` | ❌ 불필요 | 시간 데이터 없음 |
| `get_exchange_rate_v2` | ❌ 불필요 | 시간 데이터 없음 |
| `insert_journal_with_everything` | ✅ **필수** | `entry_date`, `issue_date`, `due_date`, `acquisition_date` 포함 |

---

## 🎯 작업 범위

### 1. 신규 RPC 함수 생성: `insert_journal_with_everything_utc`

#### 기존 함수 (수정 금지)
```sql
CREATE OR REPLACE FUNCTION insert_journal_with_everything(
  p_base_amount numeric,
  p_company_id uuid,
  p_created_by uuid,
  p_description text,
  p_entry_date timestamp without time zone,  -- ⚠️ timestamp (시간대 없음)
  p_lines jsonb,
  p_counterparty_id text,            -- ⚠️ 실제 DB는 text 타입
  p_if_cash_location_id text,        -- ⚠️ 실제 DB는 text 타입
  p_store_id text                    -- ⚠️ 실제 DB는 text 타입
)
RETURNS uuid                         -- ⚠️ 실제로는 uuid 반환
LANGUAGE plpgsql
AS $$
-- ... 기존 로직 (변경 금지)
$$;
```

#### 신규 함수 (새로 생성)
```sql
CREATE OR REPLACE FUNCTION insert_journal_with_everything_utc(
  p_base_amount numeric,
  p_company_id uuid,
  p_created_by uuid,
  p_description text,
  p_entry_date_utc timestamptz,     -- ✅ timestamptz (시간대 포함)
  p_lines jsonb,
  p_counterparty_id text,           -- ✅ text 타입 (기존과 동일)
  p_if_cash_location_id text,       -- ✅ text 타입 (기존과 동일)
  p_store_id text                   -- ✅ text 타입 (기존과 동일)
)
RETURNS uuid                        -- ✅ uuid 반환 (기존과 동일)
LANGUAGE plpgsql
AS $$
DECLARE
  v_journal_id uuid;
  v_line_id uuid;
  v_line jsonb;
BEGIN
  -- ======================
  -- 1. Insert Journal Header
  -- ======================
  INSERT INTO journal_entries (      -- ✅ 실제 테이블명
    company_id,
    entry_date_utc,                  -- ✅ 새 컬럼 사용
    description,
    base_amount,
    created_by,
    counterparty_id,
    -- if_cash_location_id 컬럼은 실제 테이블에 없음
    store_id,
    created_at_utc,                  -- ✅ timestamptz
    approved_at_utc                  -- ✅ 추가 컬럼
  ) VALUES (
    p_company_id,
    p_entry_date_utc,
    p_description,
    p_base_amount,
    p_created_by,
    NULLIF(p_counterparty_id, '')::uuid,
    -- p_if_cash_location_id는 별도 처리 필요
    NULLIF(p_store_id, '')::uuid,
    NOW(),                           -- PostgreSQL NOW()는 자동으로 timestamptz
    NULL                             -- 승인 시점에 업데이트
  )
  RETURNING journal_id INTO v_journal_id;

  -- ======================
  -- 2. Process Journal Lines
  -- ======================
  FOR v_line IN SELECT * FROM jsonb_array_elements(p_lines)
  LOOP
    -- Insert journal line
    INSERT INTO journal_lines (
      journal_id,
      account_id,
      description,
      debit,
      credit,
      counterparty_id,
      created_at_utc
    ) VALUES (
      v_journal_id,
      (v_line->>'account_id')::uuid,
      v_line->>'description',
      (v_line->>'debit')::numeric,
      (v_line->>'credit')::numeric,
      NULLIF(v_line->>'counterparty_id', '')::uuid,
      NOW()
    )
    RETURNING line_id INTO v_line_id;

    -- ======================
    -- 3. Handle Debt Information
    -- ======================
    IF v_line ? 'debt' THEN
      INSERT INTO debts_receivable (  -- ✅ 실제 테이블명
        company_id,                   -- ✅ 필수 컬럼 추가
        store_id,                     -- ✅ 필수 컬럼 추가
        account_id,                   -- ✅ 필수 컬럼 추가
        related_journal_id,           -- ✅ journal_line_id 대신 사용
        direction,
        category,
        counterparty_id,
        original_amount,
        remaining_amount,             -- ✅ outstanding_amount 대신 사용
        interest_rate,
        interest_account_id,
        interest_due_day,
        issue_date_utc,               -- ✅ timestamptz
        due_date_utc,                 -- ✅ timestamptz
        description,
        linked_company_store_id,      -- ✅ 실제 컬럼명
        linked_company_id,            -- ✅ 실제 컬럼명
        status,
        created_at_utc
      ) VALUES (
        p_company_id,                 -- ✅ 추가
        NULLIF(p_store_id, '')::uuid, -- ✅ 추가
        (v_line->>'account_id')::uuid, -- ✅ 추가
        v_journal_id,                 -- ✅ 변경
        v_line->'debt'->>'direction',
        v_line->'debt'->>'category',
        (v_line->'debt'->>'counterparty_id')::uuid,
        (v_line->'debt'->>'original_amount')::numeric,
        (v_line->'debt'->>'original_amount')::numeric,  -- ✅ remaining_amount
        (v_line->'debt'->>'interest_rate')::numeric,
        NULLIF(v_line->'debt'->>'interest_account_id', '')::uuid,
        (v_line->'debt'->>'interest_due_day')::integer,
        (v_line->'debt'->>'issue_date')::timestamptz,   -- ✅ ISO8601 → timestamptz
        (v_line->'debt'->>'due_date')::timestamptz,     -- ✅ ISO8601 → timestamptz
        v_line->'debt'->>'description',
        NULLIF(v_line->'debt'->>'linkedCounterparty_store_id', '')::uuid,
        NULLIF(v_line->'debt'->>'linkedCounterparty_companyId', '')::uuid,
        'unpaid',                     -- ✅ 기본값 변경
        NOW()
      );
    END IF;

    -- ======================
    -- 4. Handle Fixed Asset Information
    -- ======================
    IF v_line ? 'fix_asset' THEN
      INSERT INTO fixed_assets (
        company_id,                  -- ✅ 필수 컬럼 추가
        store_id,                    -- ✅ 필수 컬럼 추가
        account_id,                  -- ✅ 필수 컬럼 추가
        related_journal_line_id,     -- ✅ journal_line_id 대신 사용
        asset_name,
        salvage_value,
        acquisition_date_utc,        -- ✅ timestamptz
        useful_life_years,           -- ✅ 실제 컬럼명
        acquisition_cost,            -- ✅ 필수 컬럼 추가
        depreciation_method_id,      -- ✅ uuid 타입
        is_active,                   -- ✅ status 대신 사용
        created_at_utc
      ) VALUES (
        p_company_id,                -- ✅ 추가
        NULLIF(p_store_id, '')::uuid, -- ✅ 추가
        (v_line->>'account_id')::uuid, -- ✅ 추가
        v_line_id,
        v_line->'fix_asset'->>'asset_name',
        (v_line->'fix_asset'->>'salvage_value')::numeric,
        (v_line->'fix_asset'->>'acquire_date')::timestamptz,  -- ✅ ISO8601 → timestamptz
        (v_line->'fix_asset'->>'useful_life')::integer,
        (v_line->>'debit')::numeric, -- ✅ acquisition_cost
        NULL,                        -- ✅ depreciation_method_id (별도 설정)
        true,                        -- ✅ is_active
        NOW()
      );
    END IF;

    -- ======================
    -- 5. Handle Cash Transaction
    -- ======================
    -- ⚠️ 주의: cash_transactions 테이블이 실제 DB에 존재하지 않음
    -- 현재 시스템은 journal_amount_stock_flow 또는 다른 테이블을 사용할 수 있음
    -- 실제 구현 시 현재 시스템의 현금 처리 로직을 참조해야 함
    IF v_line ? 'cash' THEN
      -- TODO: 실제 현금 처리 로직 확인 필요
      -- 가능한 테이블: cash_amount_entries, cash_amount_stock_flow 등
      NULL; -- 임시 처리
    END IF;

    -- ======================
    -- 6. Handle Account Mapping (Internal Transactions)
    -- ======================
    IF v_line ? 'account_mapping' THEN
      -- Create counterparty journal entry (내부거래 상대 회사 분개)
      -- (기존 로직과 동일, 단 created_at_utc 사용)
      -- ... (구현 상세는 기존 함수 참조)
    END IF;

  END LOOP;

  RAISE NOTICE 'Journal created successfully: %', v_journal_id;

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'Failed to create journal: %', SQLERRM;
END;
$$;
```

---

## 🗄️ 테이블 스키마 변경

### ✅ 1. `journal_entries` 테이블 (이미 완료됨)

```sql
-- ✅ 아래 컬럼들이 이미 존재합니다 (2024-11-24 마이그레이션에서 추가됨)
-- entry_date_utc timestamptz
-- created_at_utc timestamptz
-- approved_at_utc timestamptz

-- 인덱스 확인 및 생성 (필요시)
CREATE INDEX IF NOT EXISTS idx_journal_entries_entry_date_utc
ON journal_entries(entry_date_utc);

CREATE INDEX IF NOT EXISTS idx_journal_entries_created_at_utc
ON journal_entries(created_at_utc);
```

### ✅ 2. `debts_receivable` 테이블 (이미 완료됨)

```sql
-- ✅ 아래 컬럼들이 이미 존재합니다 (2024-11-24 마이그레이션에서 추가됨)
-- issue_date_utc timestamptz
-- due_date_utc timestamptz
-- created_at_utc timestamptz

-- 인덱스 확인 및 생성 (필요시)
CREATE INDEX IF NOT EXISTS idx_debts_receivable_issue_date_utc
ON debts_receivable(issue_date_utc);

CREATE INDEX IF NOT EXISTS idx_debts_receivable_due_date_utc
ON debts_receivable(due_date_utc);
```

### ✅ 3. `fixed_assets` 테이블 (이미 완료됨)

```sql
-- ✅ 아래 컬럼들이 이미 존재합니다 (2024-11-24 마이그레이션에서 추가됨)
-- acquisition_date_utc timestamptz
-- created_at_utc timestamptz
-- impaired_at_utc timestamptz

-- 인덱스 확인 및 생성 (필요시)
CREATE INDEX IF NOT EXISTS idx_fixed_assets_acquisition_date_utc
ON fixed_assets(acquisition_date_utc);
```

### ✅ 4. `journal_lines` 테이블 (확인 필요)

```sql
-- 컬럼 존재 여부 확인 후 추가
-- created_at_utc가 이미 있을 수 있음

-- 인덱스 확인 및 생성 (필요시)
CREATE INDEX IF NOT EXISTS idx_journal_lines_created_at_utc
ON journal_lines(created_at_utc)
WHERE created_at_utc IS NOT NULL;
```

### ⚠️ 5. 현금 거래 처리

```sql
-- ⚠️ 주의: cash_transactions 테이블이 실제 DB에 존재하지 않음
-- 현재 시스템은 다음 테이블들을 사용:
-- - cash_amount_entries
-- - cash_amount_stock_flow
-- - cashier_amount_lines
--
-- 실제 구현 시 현재 시스템의 현금 처리 로직을 확인하여
-- 적절한 테이블에 UTC 컬럼 추가 필요
```

---

## 📋 입력 데이터 형식

### Flutter 앱에서 전송하는 형식

#### `p_entry_date_utc`
```
형식: ISO 8601 (timestamptz)
예시: "2025-01-15T05:30:00.000Z"
설명: UTC 기준 분개 입력 날짜
```

#### `p_lines` (JSONB 배열)
```json
[
  {
    "account_id": "uuid-string",
    "description": "거래 설명",
    "debit": "10000.00",
    "credit": "0",
    "counterparty_id": "uuid-string",

    // 현금 거래인 경우
    "cash": {
      "cash_location_id": "uuid-string"
    },

    // 채무/채권인 경우
    "debt": {
      "direction": "payable",  // or "receivable"
      "category": "trade",
      "counterparty_id": "uuid-string",
      "original_amount": "10000.00",
      "interest_rate": "5.5",
      "interest_account_id": "uuid-string",
      "interest_due_day": 15,
      "issue_date": "2025-01-15T00:00:00.000Z",    // ✅ ISO8601 timestamptz
      "due_date": "2025-12-31T23:59:59.999Z",      // ✅ ISO8601 timestamptz
      "description": "채무 설명",
      "linkedCounterparty_store_id": "uuid-string",
      "linkedCounterparty_companyId": "uuid-string"
    },

    // 고정자산인 경우
    "fix_asset": {
      "asset_name": "자산명",
      "salvage_value": "1000.00",
      "acquire_date": "2025-01-15T09:00:00.000Z",  // ✅ ISO8601 timestamptz
      "useful_life": "5"
    }
  }
]
```

---

## 🧪 테스트 케이스

### Test 1: 기본 분개 입력
```sql
SELECT insert_journal_with_everything_utc(
  p_base_amount := 10000.00,
  p_company_id := '12345678-1234-1234-1234-123456789012'::uuid,
  p_created_by := '87654321-4321-4321-4321-210987654321'::uuid,
  p_description := 'Test journal entry',
  p_entry_date_utc := '2025-01-15T05:30:00.000Z'::timestamptz,
  p_lines := '[
    {
      "account_id": "11111111-1111-1111-1111-111111111111",
      "description": "Debit line",
      "debit": "10000.00",
      "credit": "0"
    },
    {
      "account_id": "22222222-2222-2222-2222-222222222222",
      "description": "Credit line",
      "debit": "0",
      "credit": "10000.00"
    }
  ]'::jsonb,
  p_counterparty_id := NULL,
  p_if_cash_location_id := NULL,
  p_store_id := '33333333-3333-3333-3333-333333333333'::uuid
);
```

### Test 2: 채무 정보 포함
```sql
SELECT insert_journal_with_everything_utc(
  p_base_amount := 50000.00,
  p_company_id := '12345678-1234-1234-1234-123456789012'::uuid,
  p_created_by := '87654321-4321-4321-4321-210987654321'::uuid,
  p_description := 'Trade payable',
  p_entry_date_utc := '2025-01-15T05:30:00.000Z'::timestamptz,
  p_lines := '[
    {
      "account_id": "11111111-1111-1111-1111-111111111111",
      "description": "Purchase",
      "debit": "50000.00",
      "credit": "0"
    },
    {
      "account_id": "22222222-2222-2222-2222-222222222222",
      "description": "Accounts payable",
      "debit": "0",
      "credit": "50000.00",
      "counterparty_id": "44444444-4444-4444-4444-444444444444",
      "debt": {
        "direction": "payable",
        "category": "trade",
        "counterparty_id": "44444444-4444-4444-4444-444444444444",
        "original_amount": "50000.00",
        "interest_rate": "0",
        "interest_account_id": "",
        "interest_due_day": 0,
        "issue_date": "2025-01-15T00:00:00.000Z",
        "due_date": "2025-02-15T23:59:59.999Z",
        "description": "30 days payment term",
        "linkedCounterparty_store_id": "",
        "linkedCounterparty_companyId": ""
      }
    }
  ]'::jsonb,
  p_counterparty_id := '44444444-4444-4444-4444-444444444444'::uuid,
  p_if_cash_location_id := NULL,
  p_store_id := '33333333-3333-3333-3333-333333333333'::uuid
);
```

### Test 3: 고정자산 취득
```sql
SELECT insert_journal_with_everything_utc(
  p_base_amount := 1000000.00,
  p_company_id := '12345678-1234-1234-1234-123456789012'::uuid,
  p_created_by := '87654321-4321-4321-4321-210987654321'::uuid,
  p_description := 'Purchase equipment',
  p_entry_date_utc := '2025-01-15T05:30:00.000Z'::timestamptz,
  p_lines := '[
    {
      "account_id": "11111111-1111-1111-1111-111111111111",
      "description": "Equipment",
      "debit": "1000000.00",
      "credit": "0",
      "fix_asset": {
        "asset_name": "Production Machine",
        "salvage_value": "100000.00",
        "acquire_date": "2025-01-15T09:00:00.000Z",
        "useful_life": "10"
      }
    },
    {
      "account_id": "22222222-2222-2222-2222-222222222222",
      "description": "Cash payment",
      "debit": "0",
      "credit": "1000000.00",
      "cash": {
        "cash_location_id": "55555555-5555-5555-5555-555555555555"
      }
    }
  ]'::jsonb,
  p_counterparty_id := NULL,
  p_if_cash_location_id := NULL,
  p_store_id := '33333333-3333-3333-3333-333333333333'::uuid
);
```

---

## ✅ 검증 쿼리

### 1. 분개 헤더 확인
```sql
SELECT
  journal_id,
  company_id,
  entry_date,              -- 구 컬럼 (date 타입)
  entry_date_utc,          -- 신 컬럼 (timestamptz)
  description,
  base_amount,
  created_at,              -- 구 컬럼 (timestamp)
  created_at_utc,          -- 신 컬럼 (timestamptz)
  approved_at_utc          -- 신 컬럼 (timestamptz)
FROM journal_entries       -- ✅ 실제 테이블명
WHERE journal_id = 'xxx'::uuid;
```

### 2. 채무 데이터 확인
```sql
SELECT
  debt_id,
  related_journal_id,      -- ✅ 실제 컬럼명
  direction,
  issue_date,              -- 구 컬럼 (date 타입)
  issue_date_utc,          -- 신 컬럼 (timestamptz)
  due_date,                -- 구 컬럼 (date 타입)
  due_date_utc,            -- 신 컬럼 (timestamptz)
  original_amount,
  remaining_amount,        -- ✅ 실제 컬럼명
  status
FROM debts_receivable      -- ✅ 실제 테이블명
WHERE related_journal_id = 'xxx'::uuid;
```

### 3. 고정자산 데이터 확인
```sql
SELECT
  asset_id,
  related_journal_line_id, -- ✅ 실제 컬럼명
  asset_name,
  acquisition_date,        -- 구 컬럼 (date 타입)
  acquisition_date_utc,    -- 신 컬럼 (timestamptz)
  salvage_value,
  useful_life_years,       -- ✅ 실제 컬럼명
  is_active,               -- ✅ 실제 컬럼명
  impaired_at_utc          -- 신 컬럼 (timestamptz)
FROM fixed_assets
WHERE related_journal_line_id IN (
  SELECT line_id FROM journal_lines WHERE journal_id = 'xxx'::uuid
);
```

### 4. 시간대 검증
```sql
-- UTC 변환이 올바른지 확인
-- ⚠️ 주의: entry_date는 date 타입이므로 시간 정보 없음
SELECT
  entry_date,              -- date 타입
  entry_date_utc,          -- timestamptz 타입
  created_at,              -- timestamp 타입
  created_at_utc,          -- timestamptz 타입
  -- 시간대 변환 검증
  entry_date_utc::date = entry_date AS date_matches,
  created_at_utc::timestamp = created_at AS timestamp_matches
FROM journal_entries
WHERE entry_date_utc IS NOT NULL
LIMIT 100;
```

---

## 🚨 주의사항

### 1. 기존 함수 절대 수정 금지
- ❌ `insert_journal_with_everything` 함수는 **절대 수정하지 마세요**
- ✅ 새 함수 `insert_journal_with_everything_utc`만 생성하세요

### 2. 컬럼 이름 규칙
- ✅ 모든 새 컬럼은 `_utc` 접미사 사용
- ✅ 기존 컬럼은 그대로 유지

### 3. 데이터 타입
- ✅ `timestamptz` 사용 (timezone 포함)
- ❌ `timestamp` 사용 금지 (timezone 없음)

### 4. 기본값
- ✅ `NOW()` 사용 시 자동으로 `timestamptz` 반환
- ✅ `CURRENT_TIMESTAMP` 도 `timestamptz` 반환

### 5. 에러 처리
- ✅ JSONB 파싱 에러 핸들링
- ✅ 외래키 제약조건 검증
- ✅ NULL 값 처리 (`NULLIF` 사용)

---

## 📅 배포 일정

| 단계 | 예상 일자 | 담당 팀 | 상태 |
|------|----------|---------|------|
| 테이블 스키마 변경 | TBD | DB 팀 | ⏳ 대기 |
| 기존 데이터 마이그레이션 | TBD | DB 팀 | ⏳ 대기 |
| RPC 함수 생성 | TBD | DB 팀 | ⏳ 대기 |
| 개발 환경 테스트 | TBD | DB 팀 | ⏳ 대기 |
| Flutter 앱 코드 수정 | TBD | 앱 개발팀 | ⏳ 대기 |
| 통합 테스트 | TBD | QA 팀 | ⏳ 대기 |
| 스테이징 배포 | TBD | DevOps | ⏳ 대기 |
| 프로덕션 배포 | TBD | DevOps | ⏳ 대기 |

---

## 📞 연락처

### 데이터베이스 팀
- 질문 사항: [DB 팀 연락처]
- 코드 리뷰: [리뷰어 이름]

### 앱 개발 팀
- 기술 문의: [개발팀 연락처]
- RPC 인터페이스 협의: [담당자 이름]

---

**마지막 업데이트**: 2025-11-25
