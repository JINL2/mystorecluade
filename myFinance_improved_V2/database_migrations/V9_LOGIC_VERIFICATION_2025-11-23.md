# V9 RPC Logic Verification

## 현재 V9 로직 (Line 261-274)

```sql
IF v_method_type = 'stock' THEN
  -- STOCK 방식
  v_balance_after := v_total_amount_base;
  v_net_cash_flow := v_balance_after - v_balance_before;

ELSIF v_method_type = 'flow' THEN
  -- FLOW 방식
  v_net_cash_flow := v_total_amount_base;
  v_balance_after := v_balance_before + v_net_cash_flow;

ELSE
  -- Default to stock
  v_balance_after := v_total_amount_base;
  v_net_cash_flow := v_balance_after - v_balance_before;
END IF;
```

---

## 케이스별 상세 분석

### 📊 Case 1: Cash Ending (STOCK)

**설정:**
- `p_entry_type = 'cash'`
- `v_method_type = 'stock'` (Line 181)

**입력 예시:**
```
VND: 500k × 10 + 200k × 5 + 100k × 8 = 6,800,000
USD: $100 × 3 = $300
Exchange Rate: $1 = 26,224.66 VND
Total Base Currency (VND): 6,800,000 + (300 × 26,224.66) = 14,667,398
```

**계산 로직:**
```sql
v_total_amount_base = 14,667,398  -- 입력한 현재 보유 현금

-- Previous balance 조회 (Line 243-251)
v_balance_before = (이전 Cash Entry의 balance_after)
  -- 첫 입력이면: 0
  -- 두 번째 입력이면: 첫 번째 입력의 balance_after

-- STOCK 계산 (Line 261-264)
v_balance_after = v_total_amount_base = 14,667,398  ✅
v_net_cash_flow = v_balance_after - v_balance_before  ✅
```

**실행 시나리오:**

| Day | 입력 현금 | v_balance_before | v_balance_after | v_net_cash_flow | 의미 |
|-----|----------|-----------------|-----------------|-----------------|------|
| Day 1 | 14,667,398 | 0 | 14,667,398 | **+14,667,398** | 최초 현금 |
| Day 2 | 14,667,398 | 14,667,398 | 14,667,398 | **0** | 변동 없음 |
| Day 3 | 20,000,000 | 14,667,398 | 20,000,000 | **+5,332,602** | 현금 증가 |
| Day 4 | 10,000,000 | 20,000,000 | 10,000,000 | **-10,000,000** | 현금 감소 |

**검증:**
- ✅ `balance_after` = 입력한 현재 재고
- ✅ `net_cash_flow` = 증감분 (자동 계산)
- ✅ 같은 금액 입력 시 `net_cash_flow = 0`

---

### 📊 Case 2: Bank (STOCK)

**설정:**
- `p_entry_type = 'bank'`
- `v_method_type = 'stock'` (Line 183)

**입력 예시:**
```json
p_currencies = [
  {"currency_id": "VND-UUID", "total_amount": 50000000},
  {"currency_id": "USD-UUID", "total_amount": 1000}
]

Total Base Currency: 50,000,000 + (1000 × 26,224.66) = 76,224,660
```

**계산 로직:**
```sql
v_total_amount_base = 76,224,660  -- 입력한 현재 은행 잔액

-- Previous balance 조회
v_balance_before = (이전 Bank Entry의 balance_after)

-- STOCK 계산
v_balance_after = 76,224,660  ✅
v_net_cash_flow = v_balance_after - v_balance_before  ✅
```

**실행 시나리오:**

| Day | 입력 은행 잔액 | v_balance_before | v_balance_after | v_net_cash_flow | 의미 |
|-----|-------------|-----------------|-----------------|-----------------|------|
| Day 1 | 76,224,660 | 0 | 76,224,660 | **+76,224,660** | 최초 은행 잔액 |
| Day 2 | 80,000,000 | 76,224,660 | 80,000,000 | **+3,775,340** | 입금 |
| Day 3 | 75,000,000 | 80,000,000 | 75,000,000 | **-5,000,000** | 출금 |

**검증:**
- ✅ `balance_after` = 입력한 현재 은행 잔액
- ✅ `net_cash_flow` = 증감분 (입출금)

---

### 📊 Case 3: Vault IN (FLOW)

**설정:**
- `p_entry_type = 'vault'`
- `p_vault_transaction_type = 'in'`
- `v_method_type = 'flow'` (Line 188)

**입력 예시:**
```
VND: 500k × 10 = 5,000,000 (금고에 입고)
USD: $100 × 5 = $500
Total Base Currency: 5,000,000 + (500 × 26,224.66) = 18,112,330
```

**계산 로직:**
```sql
v_total_amount_base = 18,112,330  -- 입고 금액 (증가분)

-- Previous balance 조회
v_balance_before = (이전 Vault Entry의 balance_after)

-- FLOW 계산 (Line 266-269)
v_net_cash_flow = v_total_amount_base = 18,112,330  ✅
v_balance_after = v_balance_before + v_net_cash_flow  ✅
```

**실행 시나리오:**

| Day | 입고 금액 | v_balance_before | v_net_cash_flow | v_balance_after | 의미 |
|-----|---------|-----------------|-----------------|-----------------|------|
| Day 1 | +18,112,330 | 0 | **+18,112,330** | 18,112,330 | 최초 입고 |
| Day 2 | +10,000,000 | 18,112,330 | **+10,000,000** | 28,112,330 | 추가 입고 |
| Day 3 | +5,000,000 | 28,112,330 | **+5,000,000** | 33,112,330 | 추가 입고 |

**검증:**
- ✅ `net_cash_flow` = 입력한 입고 금액 (그대로)
- ✅ `balance_after` = 이전 잔액 + 입고 금액 (누적)

---

### 📊 Case 4: Vault OUT (FLOW)

**설정:**
- `p_entry_type = 'vault'`
- `p_vault_transaction_type = 'out'`
- `v_method_type = 'flow'` (Line 188)

**입력 예시:**
```
VND: 500k × 6 = 3,000,000 (금고에서 출고)
v_currency_total = 3,000,000 * -1 = -3,000,000  (Line 143)
```

**계산 로직:**
```sql
v_total_amount_base = -3,000,000  -- 출고 금액 (음수)

-- Previous balance 조회
v_balance_before = 33,112,330

-- FLOW 계산
v_net_cash_flow = v_total_amount_base = -3,000,000  ✅
v_balance_after = v_balance_before + v_net_cash_flow = 33,112,330 + (-3,000,000) = 30,112,330  ✅
```

**실행 시나리오:**

| Day | 출고 금액 | v_balance_before | v_net_cash_flow | v_balance_after | 의미 |
|-----|---------|-----------------|-----------------|-----------------|------|
| Day 4 | 3,000,000 출고 | 33,112,330 | **-3,000,000** | 30,112,330 | 출고 |
| Day 5 | 10,000,000 출고 | 30,112,330 | **-10,000,000** | 20,112,330 | 출고 |

**검증:**
- ✅ `net_cash_flow` = 입력한 출고 금액 (음수)
- ✅ `balance_after` = 이전 잔액 - 출고 금액 (누적)

---

### 📊 Case 5: Vault RECOUNT (STOCK + Adjustment)

**설정:**
- `p_entry_type = 'vault'`
- `p_vault_transaction_type = 'recount'`
- `v_method_type = 'stock'` (Line 186)

**입력 예시:**
```
VND: 500k × 40 = 20,000,000 (실제 재고 확인)
System Stock (시스템 잔액): 20,112,330
Actual Stock (실제 확인 잔액): 20,000,000
```

**계산 로직:**
```sql
-- Step 4: Vault Recount Adjustment (Line 220-234)
v_actual_stock = 20,000,000  -- 입력한 실제 재고
v_system_stock = 20,112,330  -- 시스템 잔액 (이전 balance_after)
v_adjustment_amount = 20,000,000 - 20,112,330 = -112,330  -- 차이

v_total_amount_base = v_adjustment_amount = -112,330  ⚠️ 여기서 변경됨!
v_transaction_type = 'recount_adj'

-- Step 5: Previous balance 조회
v_balance_before = 20,112,330  -- 이전 Vault balance_after

-- Step 6: STOCK 계산
v_balance_after = v_total_amount_base = -112,330  ❌ 틀렸다!
v_net_cash_flow = -112,330 - 20,112,330 = -20,224,660  ❌ 완전히 틀렸다!
```

**문제 발견!**

현재 Vault Recount는:
- Step 4에서 `v_total_amount_base`를 **adjustment_amount**로 덮어씀
- Step 6에서 STOCK 로직 적용
- 결과: `balance_after`가 adjustment amount가 되어버림 (잘못됨!)

**올바른 로직이어야 할 것:**
```sql
-- Vault Recount는 STOCK이지만 특별 처리 필요:
v_actual_stock = 20,000,000  -- 입력한 실제 재고
v_system_stock = 20,112,330  -- 시스템 잔액

v_balance_after = v_actual_stock = 20,000,000  ✅ 실제 재고로 설정
v_net_cash_flow = v_balance_after - v_system_stock = -112,330  ✅ 차이(조정분)
```

**실행 시나리오 (올바른 로직 가정):**

| Day | 확인 재고 | 시스템 잔액 | v_balance_after | v_net_cash_flow | 의미 |
|-----|----------|-----------|-----------------|-----------------|------|
| Day 6 | 20,000,000 | 20,112,330 | 20,000,000 | **-112,330** | 실사 조정 (손실) |
| Day 7 | 25,000,000 | 20,000,000 | 25,000,000 | **+5,000,000** | 실사 조정 (발견) |

---

## 🚨 발견된 문제

### ❌ **Vault Recount 로직 오류**

**현재 V9 (Line 220-234, 261-264):**
```sql
-- Step 4: adjustment로 v_total_amount_base 덮어씀
v_total_amount_base := v_adjustment_amount;  -- ❌

-- Step 6: STOCK 계산
v_balance_after := v_total_amount_base;  -- ❌ adjustment가 balance가 됨!
```

**올바른 로직:**
```sql
-- Step 4: adjustment 별도 저장
v_adjustment_amount := v_actual_stock - v_system_stock;
-- v_total_amount_base는 유지! (실제 재고)

-- Step 6: Vault Recount 전용 계산
IF p_entry_type = 'vault' AND p_vault_transaction_type = 'recount' THEN
  v_balance_after := v_total_amount_base;  -- 실제 재고
  v_net_cash_flow := v_adjustment_amount;  -- 조정분
ELSE
  -- 일반 STOCK 계산
  v_balance_after := v_total_amount_base;
  v_net_cash_flow := v_balance_after - v_balance_before;
END IF;
```

---

## ✅ 올바른 로직 정리

| Entry Type | Method | v_balance_after | v_net_cash_flow | 비고 |
|-----------|--------|----------------|-----------------|------|
| **Cash** | stock | = 입력 현재 재고 | = after - before | ✅ V9 정상 |
| **Bank** | stock | = 입력 현재 잔액 | = after - before | ✅ V9 정상 |
| **Vault IN** | flow | = before + 입고 금액 | = 입고 금액 | ✅ V9 정상 |
| **Vault OUT** | flow | = before + (-출고) | = -출고 금액 | ✅ V9 정상 |
| **Vault RECOUNT** | stock | = 입력 실제 재고 | = 조정분 (차이) | ❌ **V9 오류!** |

---

## 📋 수정 필요 사항

V10에서 수정해야 할 부분:
1. Step 4에서 `v_total_amount_base`를 덮어쓰지 말 것
2. Vault Recount는 별도 분기 처리
3. `balance_after = 실제 재고`, `net_cash_flow = 조정분`으로 설정
