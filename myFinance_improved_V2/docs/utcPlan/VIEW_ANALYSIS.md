# v_cash_location View 분석

## View 이름
`v_cash_location`

## View가 하는 일
각 cash location(금고/은행/현금)에 대해:
1. **Journal 금액** (장부상 금액) 계산
2. **Real 금액** (실제 재고 금액) 계산
3. **차이** (Real - Journal) 계산
4. 회사 기본 통화 정보 제공

## View가 반환하는 컬럼 (13개)

```sql
1. cash_location_id           -- Location UUID
2. company_id                  -- 회사 ID
3. store_id                    -- 매장 ID
4. location_name               -- Location 이름
5. location_type               -- 'cash', 'vault', 'bank'
6. created_at                  -- ⚠️ timestamp without time zone (UTC 아님)
7. location_info               -- 추가 정보
8. is_deleted                  -- 삭제 여부
9. total_journal_cash_amount   -- 장부상 총액
10. total_real_cash_amount     -- 실제 재고 총액
11. cash_difference            -- 차이 (Real - Journal)
12. primary_currency_symbol    -- 통화 기호 ($, ₩, etc)
13. primary_currency_code      -- 통화 코드 (USD, KRW, etc)
```

## View 내부 로직 상세

### 1. Journal 금액 계산 (장부상 금액)
```sql
SELECT
  COALESCE(SUM(jl.debit), 0) - COALESCE(SUM(jl.credit), 0) AS total_journal_cash_amount
FROM journal_lines jl
WHERE jl.cash_location_id = cl.cash_location_id
  AND jl.is_deleted IS NOT TRUE
```
→ `journal_lines` 테이블에서 차변-대변 합계

### 2. Real 금액 계산 (실제 재고 금액)
Location 타입별로 다른 테이블 사용:

#### 2-1. Cash (현금) 타입
```sql
SELECT SUM(l.quantity::numeric * d.value * exchange_rate)
FROM cashier_amount_lines l
  JOIN currency_denominations d ON l.denomination_id = d.denomination_id
WHERE l.location_id = cl.cash_location_id
  AND l.record_date = (SELECT max(l2.record_date) ...)
  AND l.created_at = (SELECT max(l3.created_at) ...)  -- ⚠️ created_at 사용 (UTC 아님)
```

#### 2-2. Vault (금고) 타입
```sql
SELECT SUM((COALESCE(val.debit, 0) - COALESCE(val.credit, 0)) * cd.value * exchange_rate)
FROM vault_amount_line val
  JOIN currency_denominations cd ON val.denomination_id = cd.denomination_id
WHERE val.location_id = cl.cash_location_id
```

#### 2-3. Bank (은행) 타입
```sql
SELECT ba.total_amount * exchange_rate
FROM bank_amount ba
WHERE ba.location_id = cl.cash_location_id
ORDER BY ba.created_at DESC  -- ⚠️ created_at 사용 (UTC 아님)
LIMIT 1
```

### 3. 환율 적용 (모든 타입 공통)
```sql
-- Base currency와 다른 통화일 경우 환율 적용
SELECT ber.rate
FROM book_exchange_rates ber
WHERE ber.company_id = cl.company_id
  AND ber.from_currency_id = d.currency_id
  AND ber.to_currency_id = comp.base_currency_id
ORDER BY ber.rate_date DESC, ber.created_at DESC  -- ⚠️ created_at 사용 (UTC 아님)
LIMIT 1
```

## ⚠️ UTC 관련 문제점

View 내부에서 `created_at` (UTC 아님)을 사용하는 곳:

| 테이블 | 사용 위치 | 용도 |
|--------|----------|------|
| `cashier_amount_lines` | `WHERE l.created_at = (SELECT max(...))` | 최신 레코드 찾기 |
| `bank_amount` | `ORDER BY ba.created_at DESC` | 최신 레코드 찾기 |
| `book_exchange_rates` | `ORDER BY ber.created_at DESC` | 최신 환율 찾기 |

## 🎯 함수 2, 3번에 미치는 영향

### 함수 2: `get_multiple_locations_balance_summary_utc`
```sql
SELECT json_agg(
  json_build_object(
    'location_id', cash_location_id,
    'total_journal', COALESCE(total_journal_cash_amount, 0),  -- View에서 계산됨
    'total_real', COALESCE(total_real_cash_amount, 0),        -- View에서 계산됨
    'difference', COALESCE(cash_difference, 0),               -- View에서 계산됨
    'currency_symbol', primary_currency_symbol,
    'currency_code', primary_currency_code
  )
)
FROM v_cash_location  -- ⚠️ View 사용
WHERE cash_location_id = ANY(p_location_ids)
```

### 함수 3: `get_company_balance_summary_utc`
```sql
SELECT json_build_object(
  'total_journal', COALESCE(SUM(total_journal_cash_amount), 0),  -- View에서 계산됨
  'total_real', COALESCE(SUM(total_real_cash_amount), 0),        -- View에서 계산됨
  'total_difference', COALESCE(SUM(cash_difference), 0),         -- View에서 계산됨
  'locations', json_agg(...)
)
FROM v_cash_location  -- ⚠️ View 사용
WHERE company_id = p_company_id
```

## 📊 영향 분석

### ✅ 영향 없음 (안전)
- **이유**: 함수 2, 3번은 **타임스탬프를 반환하지 않음**
- 집계 데이터만 반환: `total_journal`, `total_real`, `difference`
- View의 `created_at`은 **내부 계산용**이지, JSON 출력에 포함 안됨

### ⚠️ 잠재적 문제
View가 `created_at` (UTC 아님)을 사용하므로:
- 최신 레코드 선택시 **타임존 차이**로 다른 레코드 선택 가능
- 하지만 **실무적으로는 거의 영향 없음** (같은 날짜 내 레코드)

## 🔧 수정 필요 여부

### 현재 상황
```sql
-- cashier_amount_lines에서 최신 레코드 찾기
WHERE l.created_at = (SELECT max(l3.created_at) ...)  -- UTC 아님

-- 이론상 문제:
-- Server timezone이 UTC+9일 때
-- created_at: "2025-01-15 23:30:00" (로컬)
-- created_at_utc: "2025-01-15 14:30:00" (UTC)
-- → 다른 레코드 선택 가능
```

### 권장 사항

**Option 1: 현재 그대로 사용 (권장)**
- 함수 2, 3번은 타임스탬프 반환 안함
- 집계 데이터만 사용
- 실무적 영향 거의 없음

**Option 2: View UTC 버전 생성 (완벽주의)**
```sql
CREATE OR REPLACE VIEW v_cash_location_utc AS
-- 모든 created_at → created_at_utc로 변경
-- 함수 2, 3번에서 v_cash_location_utc 사용
```

## 결론

**View 이름**: `v_cash_location`
**역할**: Cash location별 장부/재고 금액 집계
**UTC 문제**: 내부 계산에 `created_at` 사용하지만, 최종 JSON에 타임스탬프 미포함
**조치**: **현재 그대로 사용 가능** (함수 2, 3번 수정 불필요)
