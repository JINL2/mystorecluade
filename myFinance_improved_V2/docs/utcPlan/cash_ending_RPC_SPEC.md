# Cash Ending - RPC 함수 명세서 (데이터베이스 팀용)

## 문서 정보
- **대상**: 데이터베이스 팀
- **목적**: Cash Ending 조회 RPC 함수 UTC 버전 생성
- **작성일**: 2025-11-25
- **우선순위**: 🟡 중간

---

## 📋 작업 범위

### 신규 RPC 함수 (4개)

| 기존 RPC | 신규 RPC (_utc) | 우선순위 | 복잡도 |
|---------|----------------|---------|--------|
| `get_location_stock_flow` | `get_location_stock_flow_utc` | 🔴 높음 | 낮음 |
| `get_cash_location_balance_summary_v2` | `get_cash_location_balance_summary_v2_utc` | 🟡 중간 | 중간 |
| `get_multiple_locations_balance_summary` | `get_multiple_locations_balance_summary_utc` | 🟡 중간 | 중간 |
| `get_company_balance_summary` | `get_company_balance_summary_utc` | 🟢 낮음 | 높음 |

---

## 🎯 RPC 1: `get_location_stock_flow_utc`

### 기능
특정 위치(Cash/Vault/Bank)의 stock flow 내역 조회 (시간순)

### 변경점
```sql
-- ❌ 기존 컬럼
SELECT
  flow_id,
  created_at,           -- timestamp (시간대 없음)
  system_time           -- timestamp (시간대 없음)
FROM cash_amount_stock_flow
ORDER BY created_at DESC;

-- ✅ 신규 컬럼 (_utc)
SELECT
  flow_id,
  created_at_utc,       -- timestamptz (UTC)
  system_time_utc       -- timestamptz (UTC)
FROM cash_amount_stock_flow
ORDER BY created_at_utc DESC;
```

### 함수 명세

```sql
CREATE OR REPLACE FUNCTION get_location_stock_flow_utc(
  p_company_id uuid,
  p_location_id uuid,
  p_start_date text,  -- ISO8601 또는 YYYY-MM-DD
  p_end_date text     -- ISO8601 또는 YYYY-MM-DD
)
RETURNS json
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN (
    SELECT json_agg(row_to_json(t))
    FROM (
      SELECT
        flow_id,
        company_id,
        store_id,
        cash_location_id,
        location_type,
        currency_id,
        flow_amount,
        balance_before,
        balance_after,
        denomination_details,
        created_by,
        created_at_utc as created_at,        -- ✅ UTC 컬럼 사용
        system_time_utc as system_time,      -- ✅ UTC 컬럼 사용
        base_currency_id,
        applied_exchange_rate,
        original_currency_amount
      FROM cash_amount_stock_flow
      WHERE company_id = p_company_id
        AND cash_location_id = p_location_id
        AND created_at_utc >= p_start_date::timestamptz
        AND created_at_utc <= p_end_date::timestamptz
      ORDER BY created_at_utc DESC
    ) t
  );
END;
$$;
```

### 반환 JSON 예시
```json
[
  {
    "flow_id": "uuid",
    "company_id": "uuid",
    "store_id": "uuid",
    "cash_location_id": "uuid",
    "location_type": "cash",
    "currency_id": "uuid",
    "flow_amount": 10000.00,
    "balance_before": 50000.00,
    "balance_after": 60000.00,
    "denomination_details": {...},
    "created_by": "uuid",
    "created_at": "2025-01-15T05:30:00.000Z",  // timestamptz
    "system_time": "2025-01-15T05:30:01.234Z", // timestamptz
    "base_currency_id": "uuid",
    "applied_exchange_rate": 1.0,
    "original_currency_amount": 10000.00
  }
]
```

---

## 🎯 RPC 2: `get_cash_location_balance_summary_v2_utc`

### 기능
특정 위치의 잔액 요약 (현재 vs 이전 비교)

### 변경점
```sql
-- ❌ 기존
WHERE record_date = p_current_date

-- ✅ 신규
WHERE record_date_utc::date = p_current_date::date
```

### 함수 명세

```sql
CREATE OR REPLACE FUNCTION get_cash_location_balance_summary_v2_utc(
  p_company_id uuid,
  p_location_id uuid,
  p_current_date text  -- YYYY-MM-DD
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
  v_location_type text;
  v_result json;
BEGIN
  -- 위치 타입 확인 (cash/vault/bank)
  SELECT location_type INTO v_location_type
  FROM cash_locations
  WHERE location_id = p_location_id;

  -- 위치 타입에 따라 다른 테이블 조회
  IF v_location_type = 'cash' THEN
    SELECT json_build_object(
      'current_balance', COALESCE(
        (SELECT balance_after
         FROM cash_amount_entries
         WHERE company_id = p_company_id
           AND location_id = p_location_id
           AND record_date_utc::date = p_current_date::date  -- ✅ UTC 컬럼
         ORDER BY created_at_utc DESC
         LIMIT 1), 0
      ),
      'previous_balance', COALESCE(
        (SELECT balance_after
         FROM cash_amount_entries
         WHERE company_id = p_company_id
           AND location_id = p_location_id
           AND record_date_utc::date < p_current_date::date  -- ✅ UTC 컬럼
         ORDER BY created_at_utc DESC
         LIMIT 1), 0
      )
    ) INTO v_result;

  ELSIF v_location_type = 'vault' THEN
    -- vault_amount_line 조회 (동일한 패턴)
    SELECT json_build_object(
      'current_balance', COALESCE(
        (SELECT SUM(debit - credit)
         FROM vault_amount_line
         WHERE company_id = p_company_id
           AND location_id = p_location_id
           AND record_date_utc::date <= p_current_date::date), 0  -- ✅ UTC 컬럼
      ),
      'previous_balance', COALESCE(
        (SELECT SUM(debit - credit)
         FROM vault_amount_line
         WHERE company_id = p_company_id
           AND location_id = p_location_id
           AND record_date_utc::date < p_current_date::date), 0   -- ✅ UTC 컬럼
      )
    ) INTO v_result;

  ELSIF v_location_type = 'bank' THEN
    -- bank_amount 조회 (동일한 패턴)
    SELECT json_build_object(
      'current_balance', COALESCE(
        (SELECT total_amount
         FROM bank_amount
         WHERE company_id = p_company_id
           AND location_id = p_location_id
           AND record_date_utc::date = p_current_date::date  -- ✅ UTC 컬럼
         ORDER BY created_at_utc DESC
         LIMIT 1), 0
      ),
      'previous_balance', COALESCE(
        (SELECT total_amount
         FROM bank_amount
         WHERE company_id = p_company_id
           AND location_id = p_location_id
           AND record_date_utc::date < p_current_date::date  -- ✅ UTC 컬럼
         ORDER BY created_at_utc DESC
         LIMIT 1), 0
      )
    ) INTO v_result;
  END IF;

  RETURN v_result;
END;
$$;
```

---

## 🎯 RPC 3: `get_multiple_locations_balance_summary_utc`

### 기능
여러 위치의 잔액 요약 (배열 반환)

### 변경점
```sql
-- ❌ 기존
WHERE record_date = p_date

-- ✅ 신규
WHERE record_date_utc::date = p_date::date
```

### 함수 명세

```sql
CREATE OR REPLACE FUNCTION get_multiple_locations_balance_summary_utc(
  p_company_id uuid,
  p_location_ids uuid[],  -- 위치 ID 배열
  p_date text             -- YYYY-MM-DD
)
RETURNS json
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN (
    SELECT json_agg(
      json_build_object(
        'location_id', loc.location_id,
        'location_name', loc.location_name,
        'location_type', loc.location_type,
        'balance', get_cash_location_balance_summary_v2_utc(
          p_company_id,
          loc.location_id,
          p_date
        )
      )
    )
    FROM cash_locations loc
    WHERE loc.company_id = p_company_id
      AND loc.location_id = ANY(p_location_ids)
  );
END;
$$;
```

---

## 🎯 RPC 4: `get_company_balance_summary_utc`

### 기능
전사 모든 위치의 잔액 집계

### 변경점
모든 `record_date` → `record_date_utc::date`

### 함수 명세

```sql
CREATE OR REPLACE FUNCTION get_company_balance_summary_utc(
  p_company_id uuid,
  p_date text  -- YYYY-MM-DD
)
RETURNS json
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN (
    SELECT json_build_object(
      'total_cash', COALESCE(
        (SELECT SUM(balance_after)
         FROM cash_amount_entries
         WHERE company_id = p_company_id
           AND record_date_utc::date = p_date::date
           AND entry_id IN (
             SELECT DISTINCT ON (location_id) entry_id
             FROM cash_amount_entries
             WHERE company_id = p_company_id
               AND record_date_utc::date = p_date::date
             ORDER BY location_id, created_at_utc DESC
           )), 0
      ),
      'total_vault', COALESCE(
        (SELECT SUM(debit - credit)
         FROM vault_amount_line
         WHERE company_id = p_company_id
           AND record_date_utc::date <= p_date::date), 0
      ),
      'total_bank', COALESCE(
        (SELECT SUM(total_amount)
         FROM bank_amount
         WHERE company_id = p_company_id
           AND record_date_utc::date = p_date::date), 0
      ),
      'date', p_date
    )
  );
END;
$$;
```

---

## 🧪 테스트 케이스

### 테스트 1: stock flow 조회
```sql
SELECT get_location_stock_flow_utc(
  'company-uuid'::uuid,
  'location-uuid'::uuid,
  '2025-01-01',
  '2025-01-31'
);
```

**예상 결과**: 1월 한 달간의 모든 stock flow (created_at_utc 기준)

### 테스트 2: 잔액 요약
```sql
SELECT get_cash_location_balance_summary_v2_utc(
  'company-uuid'::uuid,
  'location-uuid'::uuid,
  '2025-01-15'
);
```

**예상 결과**:
```json
{
  "current_balance": 150000.00,
  "previous_balance": 120000.00
}
```

### 테스트 3: 다중 위치
```sql
SELECT get_multiple_locations_balance_summary_utc(
  'company-uuid'::uuid,
  ARRAY['loc1-uuid', 'loc2-uuid', 'loc3-uuid']::uuid[],
  '2025-01-15'
);
```

### 테스트 4: 전사 집계
```sql
SELECT get_company_balance_summary_utc(
  'company-uuid'::uuid,
  '2025-01-15'
);
```

---

## ✅ 검증 쿼리

### 1. 기존 vs 신규 비교
```sql
-- 같은 데이터를 반환하는지 확인
WITH old_result AS (
  SELECT * FROM get_location_stock_flow(
    'company-uuid'::uuid, 'location-uuid'::uuid,
    '2025-01-01', '2025-01-31'
  )
),
new_result AS (
  SELECT * FROM get_location_stock_flow_utc(
    'company-uuid'::uuid, 'location-uuid'::uuid,
    '2025-01-01', '2025-01-31'
  )
)
SELECT
  (SELECT COUNT(*) FROM old_result) as old_count,
  (SELECT COUNT(*) FROM new_result) as new_count,
  (SELECT COUNT(*) FROM old_result) = (SELECT COUNT(*) FROM new_result) as counts_match;
```

### 2. 시간대 변환 확인
```sql
SELECT
  created_at,
  created_at_utc,
  created_at_utc::timestamp = created_at as matches
FROM cash_amount_stock_flow
LIMIT 10;
```

---

## 📋 체크리스트

### 데이터베이스 팀
- [ ] `get_location_stock_flow_utc` 생성
- [ ] `get_cash_location_balance_summary_v2_utc` 생성
- [ ] `get_multiple_locations_balance_summary_utc` 생성
- [ ] `get_company_balance_summary_utc` 생성
- [ ] 테스트 케이스 4개 실행
- [ ] 기존 vs 신규 비교 검증
- [ ] 개발 환경 배포
- [ ] 스테이징 환경 배포
- [ ] Flutter 팀에 완료 알림

---

## ⚠️ 주의사항

### 1. 기존 RPC 유지
- ❌ 기존 RPC는 **절대 수정하지 마세요**
- ✅ 새 RPC만 생성 (`_utc` 접미사)

### 2. 날짜 파라미터 처리
```sql
-- ✅ 올바른 변환
p_date::date                    -- 날짜만 비교
p_date::timestamptz            -- 시간까지 비교

-- ❌ 잘못된 변환
p_date::timestamp              -- 시간대 없음!
```

### 3. NULL 처리
```sql
-- ✅ COALESCE 사용
COALESCE(SUM(...), 0)

-- ❌ NULL 그대로
SUM(...)  -- NULL이면 에러 가능
```

---

**문서 작성일**: 2025-11-25
**담당**: 데이터베이스 팀
**검토**: Cash Ending 개발팀
