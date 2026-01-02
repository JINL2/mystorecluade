# Cash Location 데이터 무결성 문제 명세서

> **작성일**: 2026-01-01
> **심각도**: 🔴 High
> **영향 범위**: Cash Location 잔액 조회, Balance Sheet 불일치
> **발견 회사**: Lux Nha Trang (`563ad9ff-e17b-49f3-8f4b-de137f025f03`)

---

## 1. 문제 요약

**Balance Sheet의 현금(Cash) 잔액과 Cash Location 페이지의 잔액이 일치하지 않음**

| 조회 방법 | 금액 (VND) |
|-----------|------------|
| Balance Sheet (`get_bs_detail`, account_code=1000) | **2,855,019,722.83** |
| Cash Location 합계 (cash_location_id 기반) | **2,362,213,102.83** |
| **차이** | **492,806,620** |

---

## 2. 근본 원인

### 2.1 비정상 데이터 발견

**Error 계정(9900)**에 `cash_location_id`가 잘못 연결되어 있음.

```sql
-- 문제가 되는 레코드
SELECT line_id, account_code, account_name, debit, credit, cash_location_id, location_name
FROM journal_lines jl
JOIN accounts a ON jl.account_id = a.account_id
JOIN cash_locations cl ON jl.cash_location_id = cl.cash_location_id
WHERE a.account_code = '9900'
  AND cl.company_id = '563ad9ff-e17b-49f3-8f4b-de137f025f03';
```

| line_id | 계정 | Debit | Credit | cash_location_id | location_name |
|---------|------|-------|--------|------------------|---------------|
| `62edbffc-b2c5-4a79-9c68-e32f5326d802` | Error (9900) | 0 | **400,000,000** | `fd5c4a67-42d7-433b-9189-fa3caa636450` | Cherry Account |
| `3fc6f097-7a78-469b-8968-63902a98bd90` | Error (9900) | 0 | **92,806,620** | `fd5c4a67-42d7-433b-9189-fa3caa636450` | Cherry Account |

### 2.2 왜 문제인가?

1. **Cash Location 페이지**는 `journal_lines.cash_location_id`로 조회
   - `account_code`를 필터링하지 않음
   - 따라서 Error(9900) 계정의 Credit도 합산됨 → **마이너스 492백만**

2. **Balance Sheet**는 `account_code = '1000'`만 집계
   - Error 계정은 제외됨
   - 순수 Cash 잔액만 표시 → **2.85B**

3. **결과**: 동일한 "현금"인데 페이지마다 다른 금액이 표시됨

### 2.3 Cherry Account 상세 분석

```
Cash(1000):  +492,806,622  (정상 - Debit)
Error(9900): -492,806,620  (비정상 - Credit이 cash_location에 연결됨)
────────────────────────────
순 잔액:              2원   ← Cash Location 페이지에서 보이는 값
```

---

## 3. 영향 분석

### 3.1 직접적 영향
- ❌ Cash Location 페이지에서 잘못된 잔액 표시
- ❌ Balance Sheet와 Cash Location 간 금액 불일치
- ❌ 사용자 혼란 및 회계 신뢰도 저하

### 3.2 잠재적 영향
- ❌ Cash Ending 정산 시 불일치
- ❌ 리포트 데이터 오류
- ❌ 다른 회사에도 동일 문제 존재 가능성

---

## 4. 해결 방법

### 4.1 즉시 수정 (데이터 패치)

**Step 1: 문제 레코드의 `cash_location_id`를 NULL로 변경**

```sql
-- Lux Nha Trang 회사의 Error 계정 수정
UPDATE journal_lines
SET cash_location_id = NULL
WHERE line_id IN (
    '62edbffc-b2c5-4a79-9c68-e32f5326d802',
    '3fc6f097-7a78-469b-8968-63902a98bd90'
);
```

**Step 2: 수정 확인**

```sql
-- 수정 후 Cash Location 합계 재확인
SELECT
    SUM(jl.debit) - SUM(jl.credit) as total_balance
FROM journal_lines jl
JOIN cash_locations cl ON jl.cash_location_id = cl.cash_location_id
WHERE cl.company_id = '563ad9ff-e17b-49f3-8f4b-de137f025f03'
  AND (jl.is_deleted = false OR jl.is_deleted IS NULL);

-- 예상 결과: 2,855,019,722.83 (Balance Sheet와 동일)
```

### 4.2 전체 회사 대상 점검

**다른 회사에도 동일 문제가 있는지 확인:**

```sql
-- 비현금 계정(account_code NOT LIKE '1%')에 cash_location_id가 있는 모든 레코드
SELECT
    c.company_name,
    a.account_code,
    a.account_name,
    COUNT(*) as problem_count,
    SUM(jl.debit) - SUM(jl.credit) as balance_impact
FROM journal_lines jl
JOIN accounts a ON jl.account_id = a.account_id
JOIN cash_locations cl ON jl.cash_location_id = cl.cash_location_id
JOIN companies c ON cl.company_id = c.company_id
WHERE a.account_code NOT IN ('1000', '1001', '1010')  -- Cash 관련 계정 제외
  AND jl.cash_location_id IS NOT NULL
  AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
GROUP BY c.company_name, a.account_code, a.account_name
ORDER BY ABS(SUM(jl.debit) - SUM(jl.credit)) DESC;
```

### 4.3 앱 로직 수정 (재발 방지)

**문제 발생 원인 추정:**
- 거래 입력 시 계정 선택과 무관하게 `cash_location_id`가 저장됨
- Error 계정(9900) 선택 시에도 이전에 선택된 cash_location이 유지됨

**수정 필요 위치:**
1. `journal_input` feature - 거래 저장 로직
2. `cash_transaction` feature - 현금 거래 입력 로직

**수정 방향:**
```dart
// 저장 전 검증 로직 추가
if (accountCode != '1000' && accountCode != '1001' && accountCode != '1010') {
  // Cash 계정이 아니면 cash_location_id를 null로 설정
  cashLocationId = null;
}
```

---

## 5. 검증 쿼리 모음

### 5.1 Balance Sheet vs Cash Location 불일치 확인

```sql
-- 회사별 Balance Sheet Cash vs Cash Location 합계 비교
WITH bs_cash AS (
    SELECT
        s.company_id,
        SUM(jl.debit) - SUM(jl.credit) as bs_cash_balance
    FROM journal_lines jl
    JOIN accounts a ON jl.account_id = a.account_id
    JOIN stores s ON jl.store_id = s.store_id
    WHERE a.account_code = '1000'
      AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
    GROUP BY s.company_id
),
cl_cash AS (
    SELECT
        cl.company_id,
        SUM(jl.debit) - SUM(jl.credit) as cl_cash_balance
    FROM journal_lines jl
    JOIN cash_locations cl ON jl.cash_location_id = cl.cash_location_id
    WHERE (jl.is_deleted = false OR jl.is_deleted IS NULL)
    GROUP BY cl.company_id
)
SELECT
    c.company_name,
    bs.bs_cash_balance,
    cl.cl_cash_balance,
    bs.bs_cash_balance - COALESCE(cl.cl_cash_balance, 0) as difference
FROM bs_cash bs
LEFT JOIN cl_cash cl ON bs.company_id = cl.company_id
JOIN companies c ON bs.company_id = c.company_id
WHERE ABS(bs.bs_cash_balance - COALESCE(cl.cl_cash_balance, 0)) > 1
ORDER BY ABS(bs.bs_cash_balance - COALESCE(cl.cl_cash_balance, 0)) DESC;
```

### 5.2 비정상 cash_location_id 연결 탐지

```sql
-- Cash 계정이 아닌데 cash_location_id가 있는 레코드
SELECT
    c.company_name,
    cl.location_name,
    a.account_code,
    a.account_name,
    jl.line_id,
    jl.debit,
    jl.credit,
    jl.description,
    jl.created_at
FROM journal_lines jl
JOIN accounts a ON jl.account_id = a.account_id
JOIN cash_locations cl ON jl.cash_location_id = cl.cash_location_id
JOIN companies c ON cl.company_id = c.company_id
WHERE a.account_code NOT LIKE '10%'  -- 1000번대 자산계정 제외
  AND jl.cash_location_id IS NOT NULL
  AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
ORDER BY c.company_name, jl.created_at DESC;
```

### 5.3 Cash Location별 상세 검증

```sql
-- 특정 회사의 Cash Location별 계정 분포 확인
SELECT
    cl.location_name,
    a.account_code,
    a.account_name,
    COUNT(*) as line_count,
    SUM(jl.debit) as total_debit,
    SUM(jl.credit) as total_credit,
    SUM(jl.debit) - SUM(jl.credit) as balance
FROM journal_lines jl
JOIN accounts a ON jl.account_id = a.account_id
JOIN cash_locations cl ON jl.cash_location_id = cl.cash_location_id
WHERE cl.company_id = '563ad9ff-e17b-49f3-8f4b-de137f025f03'  -- 회사 ID 변경
  AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
GROUP BY cl.location_name, a.account_code, a.account_name
ORDER BY cl.location_name, a.account_code;
```

---

## 6. 향후 방지책

### 6.1 데이터베이스 제약 조건 추가 (권장)

```sql
-- cash_location_id가 있으면 반드시 Cash 계정(1000번대)이어야 함
-- 트리거 또는 체크 제약 조건 추가

CREATE OR REPLACE FUNCTION check_cash_location_account()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.cash_location_id IS NOT NULL THEN
        -- account_code가 Cash 관련인지 확인
        IF NOT EXISTS (
            SELECT 1 FROM accounts
            WHERE account_id = NEW.account_id
            AND account_code LIKE '10%'
        ) THEN
            RAISE EXCEPTION 'cash_location_id can only be set for Cash accounts (10xx)';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_cash_location_account
    BEFORE INSERT OR UPDATE ON journal_lines
    FOR EACH ROW
    EXECUTE FUNCTION check_cash_location_account();
```

### 6.2 정기 검증 RPC 함수

```sql
-- 데이터 무결성 검증 RPC
CREATE OR REPLACE FUNCTION validate_cash_location_integrity(p_company_id UUID DEFAULT NULL)
RETURNS TABLE (
    company_name TEXT,
    issue_type TEXT,
    location_name TEXT,
    account_code TEXT,
    account_name TEXT,
    affected_lines BIGINT,
    balance_impact NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.company_name::TEXT,
        'Non-cash account linked to cash_location'::TEXT as issue_type,
        cl.location_name::TEXT,
        a.account_code::TEXT,
        a.account_name::TEXT,
        COUNT(*)::BIGINT as affected_lines,
        (SUM(jl.debit) - SUM(jl.credit))::NUMERIC as balance_impact
    FROM journal_lines jl
    JOIN accounts a ON jl.account_id = a.account_id
    JOIN cash_locations cl ON jl.cash_location_id = cl.cash_location_id
    JOIN companies c ON cl.company_id = c.company_id
    WHERE a.account_code NOT LIKE '10%'
      AND jl.cash_location_id IS NOT NULL
      AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
      AND (p_company_id IS NULL OR cl.company_id = p_company_id)
    GROUP BY c.company_name, cl.location_name, a.account_code, a.account_name
    ORDER BY ABS(SUM(jl.debit) - SUM(jl.credit)) DESC;
END;
$$ LANGUAGE plpgsql;

-- 사용법
-- SELECT * FROM validate_cash_location_integrity();  -- 전체 회사
-- SELECT * FROM validate_cash_location_integrity('563ad9ff-e17b-49f3-8f4b-de137f025f03');  -- 특정 회사
```

---

## 7. 체크리스트

### 즉시 조치
- [ ] Lux Nha Trang Error 계정 2건의 `cash_location_id` NULL 처리
- [ ] 수정 후 Balance Sheet vs Cash Location 일치 확인
- [ ] 다른 회사 대상 동일 문제 스캔

### 앱 수정
- [ ] journal_lines 저장 시 비현금 계정의 cash_location_id 제거 로직 추가
- [ ] 기존 입력 화면에서 계정 변경 시 cash_location_id 초기화

### 장기 방지
- [ ] 데이터베이스 트리거 추가 검토
- [ ] 정기 무결성 검증 배치 작업 구성

---

## 8. 참고: 관련 테이블 구조

### journal_lines
| Column | Type | Description |
|--------|------|-------------|
| line_id | UUID | PK |
| journal_id | UUID | FK → journals |
| account_id | UUID | FK → accounts |
| store_id | UUID | FK → stores |
| cash_location_id | UUID | FK → cash_locations (nullable) |
| debit | NUMERIC | 차변 금액 |
| credit | NUMERIC | 대변 금액 |
| is_deleted | BOOLEAN | 삭제 여부 |

### cash_locations
| Column | Type | Description |
|--------|------|-------------|
| cash_location_id | UUID | PK |
| company_id | UUID | FK → companies |
| store_id | UUID | FK → stores |
| location_name | TEXT | 위치명 |
| location_type | TEXT | cash / bank / vault |
| is_deleted | BOOLEAN | 삭제 여부 |

### accounts
| Column | Type | Description |
|--------|------|-------------|
| account_id | UUID | PK |
| account_code | TEXT | 계정코드 (1000=Cash) |
| account_name | TEXT | 계정명 |
| company_id | UUID | FK → companies (nullable, 공용계정은 NULL) |
