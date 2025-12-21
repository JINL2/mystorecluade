# RPC 함수 원본 vs UTC 버전 차이점 분석

## ✅ 함수 1: get_cash_location_balance_summary_v2

### 차이점 (1개)
| 위치 | 원본 | UTC 버전 | 상태 |
|------|------|----------|------|
| Line 78 (ORDER BY) | `ORDER BY cae.currency_id, cae.created_at DESC, cae.entry_id DESC` | `ORDER BY cae.currency_id, cae.created_at_utc DESC, cae.entry_id DESC` | ✅ UTC만 변경 |

### JSON 출력 필드명
- ✅ **모두 동일**: `location_id`, `location_name`, `location_type`, `total_journal`, `total_real`, `difference`, etc.

---

## ✅ 함수 2: get_multiple_locations_balance_summary

### 차이점
**없음** - View(`v_cash_location`)를 사용하므로 함수 자체는 동일

### ⚠️ 문제점
- View `v_cash_location`이 내부적으로 `created_at` (non-UTC) 사용
- View를 수정하지 않으면 UTC 데이터를 가져올 수 없음

### JSON 출력 필드명
- ✅ **모두 동일**: `location_id`, `location_name`, `location_type`, `total_journal`, `total_real`, `difference`, `currency_symbol`, `currency_code`

---

## ✅ 함수 3: get_company_balance_summary

### 차이점
**없음** - View(`v_cash_location`)를 사용하므로 함수 자체는 동일

### ⚠️ 문제점
- 함수 2와 동일하게 View 의존성 문제

### JSON 출력 필드명
- ✅ **모두 동일**: `success`, `company_id`, `location_type_filter`, `total_journal`, `total_real`, `total_difference`, `location_count`, etc.

---

## ✅ 함수 4: get_location_stock_flow

### 차이점 (총 9곳)

| 위치 | 원본 | UTC 버전 | 상태 |
|------|------|----------|------|
| location_info CTE (L249) | `ORDER BY system_time DESC` | `ORDER BY system_time_utc DESC` | ✅ |
| location_info CTE (L257) | `ORDER BY c2.system_time DESC` | `ORDER BY c2.system_time_utc DESC` | ✅ |
| location_info CTE (L265) | `ORDER BY c2.system_time DESC` | `ORDER BY c2.system_time_utc DESC` | ✅ |
| journal_flows_data CTE (L285) | `j.created_at` | `j.created_at_utc as created_at` | ✅ |
| journal_flows_data CTE (L286) | `j.system_time` | `j.system_time_utc as system_time` | ✅ |
| journal_flows_data ORDER BY (L324) | `ORDER BY j.system_time DESC` | `ORDER BY j.system_time_utc DESC` | ✅ |
| actual_flows_data CTE (L332) | `c.created_at` | `c.created_at_utc as created_at` | ✅ |
| actual_flows_data CTE (L333) | `c.system_time` | `c.system_time_utc as system_time` | ✅ |
| actual_flows_data ORDER BY (L351) | `ORDER BY c.system_time DESC` | `ORDER BY c.system_time_utc DESC` | ✅ |

### 중요 패턴
```sql
-- ✅ 컬럼 선택시: 별칭 사용하여 JSON 필드명 동일하게 유지
j.created_at_utc as created_at   -- JSON에는 여전히 'created_at'으로 출력
j.system_time_utc as system_time  -- JSON에는 여전히 'system_time'으로 출력

-- ✅ ORDER BY/WHERE절: _utc 컬럼 직접 사용
ORDER BY j.system_time_utc DESC
```

### JSON 출력 필드명
- ✅ **모두 동일**: `created_at`, `system_time` (별칭 사용으로 필드명 유지)
- ✅ Flutter DTO에서 변경 불필요

---

## 📊 전체 요약

### ✅ 로직 변경: **없음**
- 모든 WHERE 조건, JOIN, GROUP BY, 계산 로직 **100% 동일**

### ✅ JSON 필드명: **모두 동일**
- 별칭(`as created_at`) 사용으로 Flutter DTO 호환성 유지

### ✅ UTC 변경 패턴 (일관성)
1. **SELECT 절**: `컬럼_utc as 컬럼` (별칭 사용)
2. **ORDER BY 절**: `컬럼_utc` (직접 사용)
3. **WHERE 절**: 해당 없음 (날짜 필터링 없음)

### ⚠️ 발견된 문제

#### 함수 2, 3번: View 의존성
```sql
-- 현재 코드
FROM v_cash_location  -- ❌ View가 created_at 사용 (non-UTC)

-- 해결책 2가지:
-- 1) v_cash_location_utc View 새로 생성
-- 2) View 사용 대신 직접 쿼리로 변경
```

---

## 🎯 결론

### 함수 1, 4번: ✅ 완벽
- UTC 컬럼만 변경, 모든 필드명 동일
- Flutter 코드 변경 최소화 (constants만 변경)

### 함수 2, 3번: ⚠️ 추가 작업 필요
**옵션 1: View 수정 (권장)**
```sql
CREATE OR REPLACE VIEW v_cash_location_utc AS
-- v_cash_location의 created_at → created_at_utc로 변경
```

**옵션 2: 함수에서 View 제거**
```sql
-- FROM v_cash_location 대신
-- 직접 cash_amount_entries 조인하여 created_at_utc 사용
```

---

## 검증 체크리스트

- [x] 함수 시그니처 동일 (파라미터 수, 타입)
- [x] JSON 필드명 동일 (Flutter DTO 호환)
- [x] 로직 동일 (WHERE, JOIN, 계산)
- [x] UTC 컬럼만 변경
- [ ] **함수 2, 3번 View 문제 해결 필요**
