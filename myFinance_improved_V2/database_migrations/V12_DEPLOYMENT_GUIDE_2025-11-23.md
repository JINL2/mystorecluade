# V12 배포 가이드

## 🔥 중요한 변경사항

V12는 **Vault의 debit/credit 저장 방식을 변경**합니다:
- **V11 이전**: `debit/credit` = 금액 (AMOUNT) - 예: 200.0 USD
- **V12**: `debit/credit` = 수량 (QUANTITY) - 예: 2 (100 USD 지폐 2장)

## ⚠️ 왜 변경했나요?

`v_cash_location` 뷰가 다음과 같이 계산합니다:
```sql
SUM((debit - credit) * denomination_value * exchange_rate)
```

### 문제 (V11):
```sql
-- RPC에서 저장
debit = 2 * 100 = 200  -- 금액 저장

-- 뷰에서 계산
200 * 100 * 26,224.66 = 524,493,200  -- ❌ 중복 곱셈!
```

### 해결 (V12):
```sql
-- RPC에서 저장
debit = 2  -- ✅ 수량만 저장

-- 뷰에서 계산
2 * 100 * 26,224.66 = 5,244,932  -- ✅ 정확!
```

## 📋 배포 순서

### 1단계: 기존 Vault 데이터 삭제

**⚠️ 매우 중요**: 기존 데이터(AMOUNT 방식)와 새 데이터(QUANTITY 방식)가 섞이면 계산이 틀립니다!

Supabase Dashboard → SQL Editor → 다음 실행:

```sql
-- 1. Vault 관련 모든 데이터 삭제
DELETE FROM vault_amount_line;
DELETE FROM cash_amount_entries WHERE entry_type = 'vault';

-- 2. 확인
SELECT COUNT(*) FROM vault_amount_line;  -- 0이어야 함
SELECT COUNT(*) FROM cash_amount_entries WHERE entry_type = 'vault';  -- 0이어야 함
```

### 2단계: V12 RPC 배포

파일: `DEPLOY_INSERT_AMOUNT_MULTI_CURRENCY_V12_FIX_VAULT_QUANTITY_2025-11-23.sql`

Supabase Dashboard → SQL Editor → 파일 전체 복사 → 실행

### 3단계: 배포 확인

```sql
-- RPC 함수가 업데이트되었는지 확인
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_name = 'insert_amount_multi_currency';
```

### 4단계: Flutter에서 테스트

1. **Vault IN** 테스트:
   - VND 500,000 지폐 3장 입력
   - 결과: `balance_after = 1,500,000` (VND)

2. **Vault OUT** 테스트:
   - VND 100,000 지폐 1장 출금
   - 결과: `balance_after = 1,400,000` (VND)

3. **Multi-Currency** 테스트:
   - VND 500,000 × 2 + USD 100 × 1 입력
   - VND total: 1,000,000
   - USD total: 100 → 2,622,466 VND (환율 적용)
   - 결과: `balance_after = 3,622,466` (VND)

### 5단계: v_cash_location 확인

```sql
SELECT
  location_name,
  location_type,
  total_real_cash_amount,
  cash_difference
FROM v_cash_location
WHERE location_type = 'vault'
  AND cash_location_id = 'be7ddbae-af60-4317-b83c-61f7e0b47c7c';
```

**기대 결과**:
- `total_real_cash_amount`가 정확한 금액으로 표시됨
- 더 이상 중복 곱셈이 발생하지 않음

## 🎯 테스트 체크리스트

- [ ] 1단계: 기존 vault 데이터 삭제 완료
- [ ] 2단계: V12 RPC 배포 완료
- [ ] 3단계: RPC 함수 확인 완료
- [ ] 4단계: Vault IN 테스트 성공
- [ ] 4단계: Vault OUT 테스트 성공
- [ ] 4단계: Multi-Currency 테스트 성공
- [ ] 5단계: v_cash_location 뷰 확인 완료

## 🐛 문제 해결

### 에러: "invalid input syntax for type integer: '200.0'"

**원인**: V11 RPC가 아직 실행 중입니다.
**해결**: 2단계(V12 배포)를 다시 실행하세요.

### v_cash_location의 금액이 여전히 이상함

**원인**: 기존 데이터(AMOUNT)가 남아있습니다.
**해결**: 1단계(데이터 삭제)를 다시 실행하세요.

### Cash/Bank는 정상 작동하나요?

네! V12는 Vault만 수정했습니다. Cash와 Bank는 영향 없습니다.

## 📝 참고사항

- **Cash**: `cashier_amount_lines.quantity` = INTEGER (변경 없음)
- **Bank**: `bank_amount.total_amount` = NUMERIC (변경 없음)
- **Vault**: `vault_amount_line.debit/credit` = NUMERIC (값은 INTEGER 수량)

V12에서 Vault도 수량을 저장하지만, 컬럼 타입은 NUMERIC으로 유지됩니다 (다른 로직과의 호환성).
