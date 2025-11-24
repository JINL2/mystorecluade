# Vault RECOUNT 올바른 로직

## 🔑 핵심 개념

### Vault 데이터 저장 방식:
- **vault_amount_line 테이블**: FLOW 데이터 (debit/credit)
- **transaction_type**: 'normal', 'recount_adj'

### Vault 재고 계산:
```sql
-- System Stock (시스템 재고) = SUM(debit - credit) WHERE transaction_type = 'normal'
-- Actual Stock (실제 재고) = 사용자가 입력한 현재 재고
-- Adjustment (조정분) = Actual Stock - System Stock
```

---

## 📊 Vault RECOUNT 로직 상세

### Step 1: 사용자 입력 → Actual Stock 계산
```
사용자 입력:
  VND 500k × 40 = 20,000,000
  VND 200k × 10 = 2,000,000
  USD $100 × 50 = $5,000

Actual Stock (Base Currency):
  20,000,000 + 2,000,000 + (5,000 × 26,224.66) = 153,123,300
```

### Step 2: System Stock 계산 (Flow → Stock 변환)
```sql
-- 각 denomination별로 debit - credit 누적
SELECT
  denomination_id,
  SUM(COALESCE(debit, 0) - COALESCE(credit, 0)) as system_stock
FROM vault_amount_line
WHERE location_id = p_location_id
  AND company_id = p_company_id
  AND transaction_type = 'normal'  -- recount_adj 제외!
GROUP BY denomination_id;

-- 예시 결과:
denomination_id: 500k VND → system_stock: 38 (입고 40 - 출고 2)
denomination_id: 200k VND → system_stock: 12
denomination_id: $100 USD → system_stock: 48
```

### Step 3: Denomination별 Adjustment 계산
```
VND 500k:
  Actual: 40
  System: 38
  Adjustment: +2 (발견)
  → debit: 2 × 500,000 = 1,000,000

VND 200k:
  Actual: 10
  System: 12
  Adjustment: -2 (손실)
  → credit: 2 × 200,000 = 400,000

USD $100:
  Actual: 50
  System: 48
  Adjustment: +2 (발견)
  → debit: 2 × 100 × 26,224.66 = 5,244,932
```

### Step 4: Total Net Cash Flow (Base Currency)
```
Net Cash Flow = SUM(adjustment × value × exchange_rate)
  = +1,000,000 - 400,000 + 5,244,932
  = 5,844,932 (순 증가)
```

### Step 5: Balance After 계산
```
Balance Before (System Stock):
  = SUM(debit - credit) for all denominations
  = 38×500k + 12×200k + 48×$100×rate
  = 19,000,000 + 2,400,000 + 125,878,368
  = 147,278,368

Balance After (Actual Stock):
  = Actual Stock (사용자 입력)
  = 153,123,300

Net Cash Flow:
  = Balance After - Balance Before
  = 153,123,300 - 147,278,368
  = 5,844,932 ✅
```

---

## ✅ 올바른 RPC 로직 (V10)

### V9의 문제:
```sql
-- Step 4: 잘못된 로직
v_actual_stock := v_total_amount_base;
v_system_stock := (이전 balance_after);  -- ❌ 잘못됨!
v_adjustment_amount := v_actual_stock - v_system_stock;
v_total_amount_base := v_adjustment_amount;  -- ❌ 덮어씀!

-- Step 6: 잘못된 계산
v_balance_after := v_total_amount_base;  -- ❌ adjustment가 balance가 됨!
v_net_cash_flow := v_balance_after - v_balance_before;  -- ❌ 완전히 틀림!
```

### V10의 올바른 로직:
```sql
-- Step 4: Vault Recount - System Stock 계산 (Flow → Stock 변환)
IF p_entry_type = 'vault' AND p_vault_transaction_type = 'recount' THEN

  -- System Stock: SUM(debit - credit) WHERE transaction_type = 'normal'
  SELECT COALESCE(SUM(
    COALESCE(debit, 0) - COALESCE(credit, 0)
  ), 0)
  INTO v_system_stock
  FROM vault_amount_line
  WHERE location_id = p_location_id
    AND company_id = p_company_id
    AND transaction_type = 'normal';  -- ✅ recount_adj 제외

  -- Actual Stock: 사용자 입력 (v_total_amount_base는 유지!)
  v_actual_stock := v_total_amount_base;

  -- Adjustment: 차이 계산
  v_adjustment_amount := v_actual_stock - v_system_stock;

  v_transaction_type := 'recount_adj';

  -- ✅ v_total_amount_base는 덮어쓰지 않음!

ELSE
  v_transaction_type := 'normal';
END IF;

-- Step 5: Previous Balance 조회 (이건 맞음)
SELECT COALESCE(balance_after, 0)
INTO v_balance_before
FROM cash_amount_entries
WHERE company_id = p_company_id
  AND location_id = p_location_id
  AND entry_type = 'vault'
ORDER BY created_at DESC
LIMIT 1;

-- Step 6: Balance 계산
IF p_entry_type = 'vault' AND p_vault_transaction_type = 'recount' THEN
  -- ✅ Vault Recount 전용 로직
  v_balance_after := v_total_amount_base;  -- ✅ Actual Stock (입력값)
  v_net_cash_flow := v_adjustment_amount;  -- ✅ 조정분 (차이)

ELSIF v_method_type = 'stock' THEN
  -- 일반 STOCK (Cash, Bank)
  v_balance_after := v_total_amount_base;
  v_net_cash_flow := v_balance_after - v_balance_before;

ELSIF v_method_type = 'flow' THEN
  -- FLOW (Vault IN/OUT)
  v_net_cash_flow := v_total_amount_base;
  v_balance_after := v_balance_before + v_net_cash_flow;

END IF;
```

---

## 📋 Vault RECOUNT 실행 예시

### 시나리오:
```
Day 1: Vault IN
  500k × 40 입고 → debit: 20,000,000
  200k × 15 입고 → debit: 3,000,000
  System Stock: 23,000,000
  Balance After: 23,000,000

Day 2: Vault OUT
  500k × 2 출고 → credit: 1,000,000
  200k × 3 출고 → credit: 600,000
  System Stock: 23,000,000 - 1,600,000 = 21,400,000
  Balance After: 21,400,000

Day 3: Vault RECOUNT ⭐
  실제 확인:
    500k × 40 = 20,000,000 (입고 40 - 출고 2 = 38인데, 실제는 40)
    200k × 10 = 2,000,000 (입고 15 - 출고 3 = 12인데, 실제는 10)

  System Stock (Flow → Stock):
    500k: 40 - 2 = 38 → 19,000,000
    200k: 15 - 3 = 12 → 2,400,000
    Total: 21,400,000

  Actual Stock (입력):
    500k: 40 → 20,000,000
    200k: 10 → 2,000,000
    Total: 22,000,000

  Adjustment:
    500k: +2 → debit: 1,000,000
    200k: -2 → credit: 400,000
    Net: +600,000

  Result:
    balance_before: 21,400,000 (이전 balance_after)
    balance_after: 22,000,000 (실제 재고)
    net_cash_flow: +600,000 (조정분)
    transaction_type: 'recount_adj'
```

### vault_amount_line INSERT:
```sql
-- 500k 조정 (발견)
INSERT INTO vault_amount_line (
  debit: 1,000,000,
  credit: NULL,
  denomination_id: 500k,
  transaction_type: 'recount_adj'
)

-- 200k 조정 (손실)
INSERT INTO vault_amount_line (
  debit: NULL,
  credit: 400,000,
  denomination_id: 200k,
  transaction_type: 'recount_adj'
)
```

### cash_amount_entries INSERT:
```sql
INSERT INTO cash_amount_entries (
  entry_type: 'vault',
  transaction_type: 'recount_adj',
  method_type: 'stock',
  balance_before: 21,400,000,  -- 이전 balance_after
  balance_after: 22,000,000,   -- 실제 재고
  net_cash_flow: 600,000,      -- 조정분
  ...
)
```

---

## 🎯 결론

### Vault RECOUNT의 특수성:
1. **Flow 데이터 (debit/credit) → Stock으로 변환** 필요
2. **System Stock** = SUM(debit - credit) WHERE transaction_type = 'normal'
3. **Actual Stock** = 사용자 입력 (현재 실제 재고)
4. **Net Cash Flow** = Adjustment (차이)
5. **Balance After** = Actual Stock (입력값)

### V10에서 수정할 부분:
- Step 4: `v_total_amount_base` 덮어쓰지 말 것
- Step 4: System Stock을 vault_amount_line에서 직접 계산
- Step 6: Vault RECOUNT 전용 분기 추가
