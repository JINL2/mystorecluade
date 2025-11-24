# Vault Flow Concept 정리

## 핵심 개념

### Vault는 무조건 Flow Concept
- **Previous Quantity**: 이전 row의 `(debit - credit)` 값
- **Current Quantity**: 현재 row의 `(debit - credit)` 값
- **Change**: `current - previous` = `(현재 debit - 현재 credit) - (이전 debit - 이전 credit)`

### Transaction Type
- `transaction_type = 'normal'` (in/out/recount 없음!)
- `debit` = 입금 (양수)
- `credit` = 출금 (양수, 하지만 계산시 음수로)

---

## 샘플 데이터 분석

```sql
location_id: c95458a4-5406-4a76-9c01-31542e54de31
denomination_id: 62e1b7e1-7e03-44f3-84b8-53f678c2493e

Row 1 (2025-11-21 16:53:46):
  debit: 26, credit: null
  → Current Qty = 26 - 0 = 26
  → Previous Qty = 0 (첫 row)
  → Change = 26 - 0 = 26

Row 2 (2025-11-21 16:54:25):
  debit: 411, credit: null
  → Current Qty = 411 - 0 = 411
  → Previous Qty = 26 (Row 1의 결과)
  → Change = 411 - 26 = 385

Row 3 (2025-11-22 14:23:57):
  debit: null, credit: 100
  → Current Qty = 0 - 100 = -100
  → Previous Qty = 411 (Row 2의 결과)
  → Change = -100 - 411 = -511
```

---

## Location별 데이터 가져오는 방법

### 1. Cash (cashier_amount_lines) - Stock Method

```sql
-- Location별로 denomination별로 시간순 정렬
SELECT
  cal.denomination_id,
  cal.quantity as current_quantity,

  -- Previous: 같은 location + 같은 denomination의 이전 row
  LAG(cal.quantity) OVER (
    PARTITION BY cal.location_id, cal.denomination_id
    ORDER BY cae.created_at
  ) as previous_quantity,

  -- Change = Current - Previous
  cal.quantity - COALESCE(
    LAG(cal.quantity) OVER (
      PARTITION BY cal.location_id, cal.denomination_id
      ORDER BY cae.created_at
    ), 0
  ) as quantity_change

FROM cashier_amount_lines cal
JOIN cash_amount_entries cae ON cal.entry_id = cae.entry_id
WHERE cal.location_id = 'xxx'
  AND cae.entry_type = 'cash'
ORDER BY cae.created_at DESC;
```

---

### 2. Bank (bank_amount) - Stock Method

```sql
-- Location별로 currency별로 시간순 정렬 (denomination 없음!)
SELECT
  ba.total_amount as current_amount,

  -- Previous: 같은 location + 같은 currency의 이전 row
  LAG(ba.total_amount) OVER (
    PARTITION BY ba.location_id, ba.currency_id
    ORDER BY cae.created_at
  ) as previous_amount,

  -- Change = Current - Previous
  ba.total_amount - COALESCE(
    LAG(ba.total_amount) OVER (
      PARTITION BY ba.location_id, ba.currency_id
      ORDER BY cae.created_at
    ), 0
  ) as amount_change

FROM bank_amount ba
JOIN cash_amount_entries cae ON ba.entry_id = cae.entry_id
WHERE ba.location_id = 'xxx'
  AND cae.entry_type = 'bank'
ORDER BY cae.created_at DESC;
```

---

### 3. Vault (vault_amount_line) - Flow Method

```sql
-- Location별로 denomination별로 시간순 정렬
-- ❌ transaction_type 구분 없음! (모두 'normal')
SELECT
  val.denomination_id,

  -- Current = debit - credit
  COALESCE(val.debit, 0) - COALESCE(val.credit, 0) as current_quantity,

  -- Previous: 이전 row의 (debit - credit)
  LAG(COALESCE(val.debit, 0) - COALESCE(val.credit, 0)) OVER (
    PARTITION BY val.location_id, val.denomination_id
    ORDER BY cae.created_at
  ) as previous_quantity,

  -- Change = Current - Previous
  (COALESCE(val.debit, 0) - COALESCE(val.credit, 0)) - COALESCE(
    LAG(COALESCE(val.debit, 0) - COALESCE(val.credit, 0)) OVER (
      PARTITION BY val.location_id, val.denomination_id
      ORDER BY cae.created_at
    ), 0
  ) as quantity_change

FROM vault_amount_line val
JOIN cash_amount_entries cae ON val.entry_id = cae.entry_id
WHERE val.location_id = 'xxx'
  AND cae.entry_type = 'vault'
ORDER BY cae.created_at DESC;
```

---

## 핵심 차이점

| Type | Table | Denomination | Current | Previous | Change |
|------|-------|--------------|---------|----------|--------|
| **Cash** | cashier_amount_lines | ✅ YES | `quantity` | LAG(quantity) | Current - Previous |
| **Bank** | bank_amount | ❌ NO | `total_amount` | LAG(total_amount) | Current - Previous |
| **Vault** | vault_amount_line | ✅ YES | `debit - credit` | LAG(debit - credit) | Current - Previous |

---

## Vault Flow 예시

```
Location: Vault A
Denomination: 10,000 VND

Time 1: debit=100, credit=0
  → Current = 100, Previous = 0, Change = +100

Time 2: debit=50, credit=0
  → Current = 50, Previous = 100, Change = -50

Time 3: debit=0, credit=30
  → Current = -30, Previous = 50, Change = -80

Time 4: debit=200, credit=0
  → Current = 200, Previous = -30, Change = +230
```

---

## 결론

**Vault는 Flow Concept이지만**:
- Previous Quantity ≠ 0
- Previous Quantity = 이전 row의 (debit - credit)
- Change = 현재 (debit - credit) - 이전 (debit - credit)

**Stock vs Flow의 차이**:
- Stock (Cash/Bank): `quantity` 자체가 재고 수량
- Flow (Vault): `debit - credit`이 거래 후 잔액 (balance)
