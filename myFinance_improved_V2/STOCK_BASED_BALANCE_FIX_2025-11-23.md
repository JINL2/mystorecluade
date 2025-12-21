# Stock-Based Balance Summary Fix

**날짜**: 2025-11-23
**상태**: ✅ Ready for Deployment

---

## 🔍 문제 분석

### 발견된 문제
Cash Ending 완료 페이지에서 **Total Real**이 **FLOW 데이터**(거래 기록)를 표시하고 있었습니다.

하지만 **Total Real**은 **STOCK 데이터**(실제 잔액)를 보여줘야 합니다.

### 스크린샷 분석
```
Total Journal:  đ0.00
Total Real:     đ8,868,172.00  ❌ FLOW 데이터
Difference:     đ8,868,172.00
```

### 근본 원인
기존 RPC `get_cash_location_balance_summary`가 `v_cash_location` 뷰를 사용하는데, 이 뷰는:
- `cashier_amount_lines` 테이블에서 데이터를 가져옴 (FLOW)
- 가장 최근 거래 기록만 표시
- 실제 잔액(STOCK)이 아닌 거래 내역(FLOW)을 보여줌

---

## ✅ 해결 방법

### 새로운 RPC 함수 생성

**함수명**: `get_cash_location_balance_summary_v2`

**변경 사항**:
1. ❌ **기존**: `cashier_amount_lines` (FLOW) 사용
2. ✅ **신규**: `cash_amount_entries.balance_after` (STOCK) 사용

### 핵심 로직
```sql
-- Step 4: Calculate Total Real (STOCK from cash_amount_entries)
SELECT COALESCE(SUM(latest.balance_after), 0)
INTO v_total_real
FROM (
  SELECT DISTINCT ON (cae.currency_id)
    cae.balance_after,
    cae.currency_id
  FROM cash_amount_entries cae
  WHERE cae.location_id = p_location_id
    AND cae.entry_type = v_location_type
  ORDER BY cae.currency_id, cae.created_at DESC, cae.entry_id DESC
) latest;
```

---

## 📋 배포 단계

### Step 1: 데이터베이스 마이그레이션 적용

Supabase SQL Editor에서 다음 파일을 실행하세요:

```bash
database_migrations/GET_BALANCE_SUMMARY_STOCK_BASED_2025-11-23.sql
```

### Step 2: RPC 함수 테스트

```sql
-- 샘플 테스트 (실제 location_id로 변경)
SELECT * FROM get_cash_location_balance_summary_v2('your-location-uuid-here');
```

**예상 결과**:
```json
{
  "success": true,
  "location_id": "...",
  "location_name": "...",
  "location_type": "cash",
  "total_journal": 0,
  "total_real": 8868172,  // ✅ STOCK 데이터
  "difference": 8868172,
  "is_balanced": false,
  "has_shortage": false,
  "has_surplus": true,
  "currency_symbol": "đ",
  "currency_code": "VND",
  "last_updated": "2025-11-23T..."
}
```

### Step 3: Flutter 앱 빌드 및 배포

Flutter 코드는 이미 수정되었습니다:

**변경된 파일**:
1. [lib/features/cash_ending/core/constants.dart](lib/features/cash_ending/core/constants.dart#L38)
   - `rpcGetBalanceSummaryV2` 상수 추가

2. [lib/features/cash_ending/data/datasources/cash_ending_remote_datasource.dart](lib/features/cash_ending/data/datasources/cash_ending_remote_datasource.dart#L68)
   - `getBalanceSummary()` 메서드에서 V2 RPC 사용

```bash
# 빌드 및 테스트
flutter pub get
flutter analyze
flutter build apk  # or ios
```

---

## 🧪 테스트 시나리오

### 테스트 1: Cash Ending 후 Balance Summary 확인
1. Cash Ending 페이지에서 현금 카운트 입력
2. Submit 버튼 클릭
3. Completion 페이지에서 **Total Real** 확인
4. ✅ **예상**: `cash_amount_entries`의 `balance_after` 값 표시

### 테스트 2: Multi-Currency 테스트
1. VND와 USD 현금 모두 입력
2. Submit 후 Total Real 확인
3. ✅ **예상**: 모든 currency의 balance_after 합계 표시

### 테스트 3: Balance Summary vs Journal 비교
1. Journal에 거래 입력 (예: Sales)
2. Cash Ending 실행
3. Total Journal과 Total Real 비교
4. ✅ **예상**: Difference가 정확하게 계산됨

---

## 🔄 Rollback Plan (필요시)

만약 문제가 발생하면 기존 RPC로 되돌릴 수 있습니다:

### Flutter Code Rollback
```dart
// lib/features/cash_ending/data/datasources/cash_ending_remote_datasource.dart
final response = await _client.rpc(
  CashEndingConstants.rpcGetBalanceSummary,  // ⬅️ V2에서 원래 버전으로
  params: {'p_location_id': locationId},
);
```

### Database Rollback
기존 RPC 함수는 그대로 남아있으므로 Flutter 코드만 변경하면 됩니다.

---

## 📊 데이터 구조 비교

### FLOW (기존 - 잘못된 방법)
```
cashier_amount_lines
├── entry_id
├── denomination_id
├── quantity          ⬅️ 거래 수량
└── record_date
```

### STOCK (신규 - 올바른 방법)
```
cash_amount_entries
├── entry_id
├── location_id
├── currency_id
├── balance_before
├── balance_after     ⬅️ ✅ 실제 잔액 (STOCK)
└── created_at
```

---

## ✅ 체크리스트

- [x] 문제 분석 완료
- [x] 새로운 RPC 함수 생성
- [x] Flutter constants 업데이트
- [x] Flutter datasource 업데이트
- [ ] **데이터베이스 마이그레이션 적용 (수동)**
- [ ] RPC 함수 테스트
- [ ] Flutter 앱 빌드
- [ ] 실제 환경에서 테스트

---

## 📝 참고 문서

- RPC 함수: [GET_BALANCE_SUMMARY_STOCK_BASED_2025-11-23.sql](database_migrations/GET_BALANCE_SUMMARY_STOCK_BASED_2025-11-23.sql)
- 기존 RPC (참고용): [GET_BALANCE_SUMMARY_RPC_FIXED_2025-11-23.sql](database_migrations/GET_BALANCE_SUMMARY_RPC_FIXED_2025-11-23.sql)
- Cash Amount Entry 스키마: [CASH_AMOUNT_ENTRIES_WITH_BALANCE_2025-11-22.sql](database_migrations/CASH_AMOUNT_ENTRIES_WITH_BALANCE_2025-11-22.sql)

---

## 🚀 배포 후 예상 결과

### Before (기존)
```
Total Real: đ8,868,172.00  (from cashier_amount_lines - FLOW)
```

### After (수정 후)
```
Total Real: đ1,000,000.00  (from cash_amount_entries.balance_after - STOCK)
```

이제 **Total Real**이 실제 현금 잔액을 정확하게 표시합니다!
