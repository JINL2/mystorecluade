# Correct Table Structure - Cash Location Data

## 테이블 구조 정리

### 1. Cash (현금) - Stock Method
- **Detail Table**: `cashier_amount_lines`
- **Has Denomination**: ✅ YES (denomination_id, quantity)
- **Method**: Stock (재고 방식)
- **Change Calculation**: Current - Previous

```sql
cashier_amount_lines:
- line_id (PK)
- entry_id (FK to cash_amount_entries)
- denomination_id (FK)
- quantity (integer)
- currency_id
- location_id
- created_at
```

---

### 2. Bank (은행) - Stock Method
- **Detail Table**: `bank_amount`
- **Has Denomination**: ❌ NO (only total_amount)
- **Method**: Stock (재고 방식)
- **Change Calculation**: Current - Previous

```sql
bank_amount:
- bank_amount_id (PK)
- entry_id (FK to cash_amount_entries)
- total_amount (numeric) ← No denominations!
- currency_id
- location_id
- created_at
```

---

### 3. Vault (금고) - Flow Method
- **Detail Table**: `vault_amount_line`
- **Has Denomination**: ✅ YES (denomination_id, debit/credit)
- **Method**: Flow (거래 방식)
- **Change Calculation**: Transaction amount itself
- **Transaction Types**: 'in', 'out', 'recount'

```sql
vault_amount_line:
- vault_amount_id (PK)
- entry_id (FK to cash_amount_entries)
- denomination_id (FK)
- debit (numeric) - IN transaction
- credit (numeric) - OUT transaction
- transaction_type ('in', 'out', 'recount')
- currency_id
- location_id
- created_at
```

---

## 핵심 차이점

| Type | Table | Denomination | Method | Change Logic |
|------|-------|--------------|--------|--------------|
| **Cash** | cashier_amount_lines | ✅ YES (quantity) | Stock | Current - Previous |
| **Bank** | bank_amount | ❌ NO (total_amount) | Stock | Current - Previous |
| **Vault** | vault_amount_line | ✅ YES (debit/credit) | Flow | Transaction amount |

---

## 각 타입별 Previous & Change 계산 방법

### Cash (cashier_amount_lines)
```sql
-- Previous: LATERAL JOIN으로 이전 quantity 찾기
LEFT JOIN LATERAL (
    SELECT cal.quantity as prev_quantity
    FROM cashier_amount_lines cal
    JOIN cash_amount_entries cae ON cal.entry_id = cae.entry_id
    WHERE cal.denomination_id = current_cal.denomination_id
      AND cal.location_id = current_cal.location_id
      AND cae.created_at < current_cae.created_at
    ORDER BY cae.created_at DESC
    LIMIT 1
) prev ON true

-- Current: cal.quantity
-- Change: cal.quantity - COALESCE(prev.prev_quantity, 0)
```

---

### Bank (bank_amount)
```sql
-- Previous: LATERAL JOIN으로 이전 total_amount 찾기
LEFT JOIN LATERAL (
    SELECT ba.total_amount as prev_amount
    FROM bank_amount ba
    JOIN cash_amount_entries cae ON ba.entry_id = cae.entry_id
    WHERE ba.location_id = current_ba.location_id
      AND ba.currency_id = current_ba.currency_id
      AND cae.created_at < current_cae.created_at
    ORDER BY cae.created_at DESC
    LIMIT 1
) prev ON true

-- Current: ba.total_amount
-- Change: ba.total_amount - COALESCE(prev.prev_amount, 0)

-- ❌ Bank는 denomination이 없으므로 denomination_details = NULL or []
```

---

### Vault (vault_amount_line)
```sql
-- Flow Method이므로:
-- Previous: 항상 0 (의미 없음)
-- Current:
--   - transaction_type = 'in' → debit (양수)
--   - transaction_type = 'out' → credit (음수)
--   - transaction_type = 'recount' → Stock method처럼 처리
-- Change: Current 그대로 (거래 자체가 변화량)

CASE val.transaction_type
    WHEN 'in' THEN val.debit
    WHEN 'out' THEN -val.credit
    WHEN 'recount' THEN val.debit - COALESCE(prev.prev_amount, 0)
END
```

---

## get_location_stock_flow_v2 수정 필요사항

현재 V2 RPC는 **cashier_amount_lines만** 사용하고 있음:
```sql
-- ❌ 잘못된 현재 코드
FROM cashier_amount_lines cal  -- Cash만 처리
```

**수정해야 할 부분**:
```sql
-- ✅ 올바른 코드 - entry_type에 따라 다른 테이블 JOIN
FROM cash_amount_entries cae
LEFT JOIN cashier_amount_lines cal
    ON cae.entry_id = cal.entry_id
    AND cae.entry_type = 'cash'
LEFT JOIN bank_amount ba
    ON cae.entry_id = ba.entry_id
    AND cae.entry_type = 'bank'
LEFT JOIN vault_amount_line val
    ON cae.entry_id = val.entry_id
    AND cae.entry_type = 'vault'
```

---

## denomination_details 생성 로직

### Cash - denomination_details 있음
```sql
SELECT json_agg(
    json_build_object(
        'denomination_id', cal.denomination_id,
        'current_quantity', cal.quantity,
        'previous_quantity', COALESCE(prev.prev_quantity, 0),
        'quantity_change', cal.quantity - COALESCE(prev.prev_quantity, 0)
    )
)
FROM cashier_amount_lines cal
WHERE cal.entry_id = cae.entry_id
```

### Bank - denomination_details 없음
```sql
-- Bank는 denomination이 없으므로 빈 배열
'[]'::json
```

### Vault - denomination_details 있음 (Flow Method)
```sql
SELECT json_agg(
    json_build_object(
        'denomination_id', val.denomination_id,
        'current_quantity', CASE val.transaction_type
            WHEN 'in' THEN val.debit
            WHEN 'out' THEN -val.credit
            WHEN 'recount' THEN val.debit
        END,
        'previous_quantity', CASE val.transaction_type
            WHEN 'recount' THEN COALESCE(prev.prev_quantity, 0)
            ELSE 0  -- Flow method
        END,
        'quantity_change', CASE val.transaction_type
            WHEN 'in' THEN val.debit
            WHEN 'out' THEN -val.credit
            WHEN 'recount' THEN val.debit - COALESCE(prev.prev_quantity, 0)
        END
    )
)
FROM vault_amount_line val
WHERE val.entry_id = cae.entry_id
```

---

## Summary

**핵심 깨달음**:
1. Cash = `cashier_amount_lines` (denomination ✅, Stock)
2. Bank = `bank_amount` (denomination ❌, Stock)
3. Vault = `vault_amount_line` (denomination ✅, Flow)

**V2 RPC가 해야 할 것**:
- `cash_amount_entries.entry_type`을 보고 적절한 detail 테이블 JOIN
- Cash: cashier_amount_lines에서 denomination details
- Bank: bank_amount에서 total_amount만 (denomination 없음)
- Vault: vault_amount_line에서 denomination details + transaction_type 기반 계산
