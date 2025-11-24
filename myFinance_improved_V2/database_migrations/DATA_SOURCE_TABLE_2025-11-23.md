# 데이터 소스 테이블 - Total, Previous, Change, Denomination

## 1. CASH (entry_type = 'cash')

### 테이블 구조
- **Header**: `cash_amount_entries`
- **Detail**: `cashier_amount_lines`

### 데이터 가져오는 곳

| 필드 | 소스 | 설명 |
|------|------|------|
| **Total** | `cash_amount_entries.total_amount` | Entry 전체 합계 (base currency) |
| **Balance Before** | `cash_amount_entries.balance_before` | 이전 잔액 |
| **Balance After** | `cash_amount_entries.balance_after` | 현재 잔액 |
| | | |
| **Denomination별 Current** | `cashier_amount_lines.quantity` | 현재 denomination 수량 |
| **Denomination별 Previous** | LATERAL JOIN으로 이전 row 찾기 | 같은 location + denomination의 이전 `quantity` |
| **Denomination별 Change** | `current - previous` | 계산: `quantity - 이전 quantity` |
| **Denomination별 Subtotal** | `quantity × denomination.value` | 계산: 수량 × 액면가 |

---

## 2. BANK (entry_type = 'bank')

### 테이블 구조
- **Header**: `cash_amount_entries`
- **Detail**: `bank_amount`

### 데이터 가져오는 곳

| 필드 | 소스 | 설명 |
|------|------|------|
| **Total** | `cash_amount_entries.total_amount` | Entry 전체 합계 (base currency) |
| **Balance Before** | `cash_amount_entries.balance_before` | 이전 잔액 |
| **Balance After** | `cash_amount_entries.balance_after` | 현재 잔액 |
| | | |
| **Current Amount** | `bank_amount.total_amount` | 현재 은행 잔액 |
| **Previous Amount** | LATERAL JOIN으로 이전 row 찾기 | 같은 location + currency의 이전 `total_amount` |
| **Change** | `current - previous` | 계산: `total_amount - 이전 total_amount` |
| | | |
| **Denomination** | ❌ 없음 | Bank는 denomination이 없음! |

---

## 3. VAULT (entry_type = 'vault')

### 테이블 구조
- **Header**: `cash_amount_entries`
- **Detail**: `vault_amount_line`

### 데이터 가져오는 곳

| 필드 | 소스 | 설명 |
|------|------|------|
| **Total** | `cash_amount_entries.total_amount` | Entry 전체 합계 (base currency) |
| **Balance Before** | `cash_amount_entries.balance_before` | 이전 잔액 |
| **Balance After** | `cash_amount_entries.balance_after` | 현재 잔액 |
| | | |
| **Denomination별 Current** | `vault_amount_line.debit - vault_amount_line.credit` | 현재 거래: debit(입금) - credit(출금) |
| **Denomination별 Previous** | LATERAL JOIN으로 이전 row 찾기 | 같은 location + denomination의 이전 `(debit - credit)` |
| **Denomination별 Change** | `current - previous` | 계산: `(debit - credit) - 이전(debit - credit)` |
| **Denomination별 Subtotal** | `(debit - credit) × denomination.value` | 계산: 거래량 × 액면가 |

---

## 요약 테이블

| Type | Total | Previous (Entry) | Change (Entry) | Denomination Current | Denomination Previous | Denomination Change |
|------|-------|------------------|----------------|----------------------|----------------------|---------------------|
| **Cash** | `entries.total_amount` | `entries.balance_before` | `total_amount` | `cal.quantity` | LATERAL JOIN `prev.quantity` | `quantity - prev.quantity` |
| **Bank** | `entries.total_amount` | `entries.balance_before` | `total_amount` | ❌ 없음 | ❌ 없음 | ❌ 없음 |
| **Vault** | `entries.total_amount` | `entries.balance_before` | `total_amount` | `debit - credit` | LATERAL JOIN `prev.(debit-credit)` | `(debit-credit) - prev.(debit-credit)` |

---

## LATERAL JOIN 로직

### Cash - Previous Quantity
```sql
LEFT JOIN LATERAL (
    SELECT prev_cal.quantity as prev_quantity
    FROM cashier_amount_lines prev_cal
    JOIN cash_amount_entries prev_cae ON prev_cal.entry_id = prev_cae.entry_id
    WHERE prev_cal.denomination_id = cal.denomination_id
      AND prev_cal.location_id = cal.location_id
      AND prev_cae.created_at < cae.created_at
      AND prev_cae.company_id = p_company_id
      AND prev_cae.entry_type = 'cash'
    ORDER BY prev_cae.created_at DESC
    LIMIT 1
) prev ON true
```

### Bank - Previous Amount
```sql
LEFT JOIN LATERAL (
    SELECT prev_ba.total_amount as prev_amount
    FROM bank_amount prev_ba
    JOIN cash_amount_entries prev_cae ON prev_ba.entry_id = prev_cae.entry_id
    WHERE prev_ba.location_id = ba.location_id
      AND prev_ba.currency_id = ba.currency_id
      AND prev_cae.created_at < cae.created_at
      AND prev_cae.company_id = p_company_id
      AND prev_cae.entry_type = 'bank'
    ORDER BY prev_cae.created_at DESC
    LIMIT 1
) prev ON true
```

### Vault - Previous Quantity
```sql
LEFT JOIN LATERAL (
    SELECT
        COALESCE(prev_val.debit, 0) - COALESCE(prev_val.credit, 0) as prev_quantity
    FROM vault_amount_line prev_val
    JOIN cash_amount_entries prev_cae ON prev_val.entry_id = prev_cae.entry_id
    WHERE prev_val.denomination_id = val.denomination_id
      AND prev_val.location_id = val.location_id
      AND prev_cae.created_at < cae.created_at
      AND prev_cae.company_id = p_company_id
      AND prev_cae.entry_type = 'vault'
    ORDER BY prev_cae.created_at DESC
    LIMIT 1
) prev ON true
```

---

## 실제 예시

### Cash Example
```
Location: Cash Register 1
Denomination: 10,000 VND

Entry 1 (2025-11-20 10:00):
  cashier_amount_lines.quantity = 100
  → Current: 100
  → Previous: 0 (첫 entry)
  → Change: +100
  → Subtotal: 100 × 10,000 = 1,000,000

Entry 2 (2025-11-21 10:00):
  cashier_amount_lines.quantity = 85
  → Current: 85
  → Previous: 100 (Entry 1)
  → Change: -15
  → Subtotal: 85 × 10,000 = 850,000
```

### Bank Example
```
Location: Bank Account A
Currency: VND

Entry 1 (2025-11-20 10:00):
  bank_amount.total_amount = 5,000,000
  → Current: 5,000,000
  → Previous: 0
  → Change: +5,000,000
  → Denomination: 없음

Entry 2 (2025-11-21 10:00):
  bank_amount.total_amount = 7,500,000
  → Current: 7,500,000
  → Previous: 5,000,000
  → Change: +2,500,000
  → Denomination: 없음
```

### Vault Example
```
Location: Vault 1
Denomination: 10,000 VND

Entry 1 (2025-11-20 10:00):
  debit = 100, credit = 0
  → Current: 100 - 0 = 100
  → Previous: 0
  → Change: +100
  → Subtotal: 100 × 10,000 = 1,000,000

Entry 2 (2025-11-21 10:00):
  debit = 50, credit = 0
  → Current: 50 - 0 = 50
  → Previous: 100 (Entry 1)
  → Change: -50
  → Subtotal: 50 × 10,000 = 500,000

Entry 3 (2025-11-22 10:00):
  debit = 0, credit = 30
  → Current: 0 - 30 = -30
  → Previous: 50 (Entry 2)
  → Change: -80
  → Subtotal: -30 × 10,000 = -300,000
```

---

## 핵심 포인트

1. **Total, Balance Before/After**: 모두 `cash_amount_entries`에서 가져옴
2. **Denomination Details**: Cash/Vault만 있음 (Bank는 없음)
3. **Previous Quantity**: LATERAL JOIN으로 같은 location + denomination의 이전 row 찾기
4. **Change**: 항상 `Current - Previous` 계산
5. **Vault**: `debit - credit`을 quantity처럼 사용
