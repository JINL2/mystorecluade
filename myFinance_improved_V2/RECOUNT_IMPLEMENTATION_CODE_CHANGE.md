# Vault Recount Implementation - Code Change Guide

## 파일: cash_ending_page.dart

### 수정할 메서드: `_saveVaultTransaction` (라인 500~650)

현재 코드는 562-577줄에서 항상 `VaultTransaction`을 생성합니다:

```dart
// 현재 코드 (라인 562-577)
final now = DateTime.now();
final vaultTransaction = VaultTransaction(
  companyId: companyId,
  storeId: state.selectedStoreId,
  locationId: state.selectedVaultLocationId!,
  currencyId: currencyId,
  userId: userId,
  recordDate: now,
  createdAt: now,
  isCredit: transactionType == 'credit',
  denominations: denominationsWithQuantity,
);

// Save via VaultTabProvider
final success = await ref.read(vaultTabProvider.notifier).saveVaultTransaction(vaultTransaction);
```

### 변경 사항:

**기존 562-577줄을 다음으로 교체:**

```dart
// 라인 562부터 시작
final now = DateTime.now();

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Recount vs Normal Transaction 분기
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
bool success;
Map<String, dynamic>? recountResult;

if (transactionType == 'recount') {
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // RECOUNT: Stock → Flow 변환
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  final vaultRecount = VaultRecount(
    companyId: companyId,
    storeId: state.selectedStoreId,
    locationId: state.selectedVaultLocationId!,
    currencyId: currencyId,
    userId: userId,
    recordDate: now,
    createdAt: now,
    denominations: denominationsWithQuantity, // Stock 수량
  );

  try {
    // Call recount RPC
    recountResult = await ref.read(vaultTabProvider.notifier).recountVault(vaultRecount);
    success = recountResult['success'] == true;
  } catch (e) {
    success = false;
    if (mounted) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Recount failed: ${e.toString()}',
      );
    }
    return;
  }
} else {
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // NORMAL: In/Out Transaction
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  final vaultTransaction = VaultTransaction(
    companyId: companyId,
    storeId: state.selectedStoreId,
    locationId: state.selectedVaultLocationId!,
    currencyId: currencyId,
    userId: userId,
    recordDate: now,
    createdAt: now,
    isCredit: transactionType == 'credit',
    denominations: denominationsWithQuantity, // Flow 수량
  );

  // Call normal transaction RPC
  success = await ref.read(vaultTabProvider.notifier).saveVaultTransaction(vaultTransaction);
}
```

### 추가 변경: Completion Page에 Recount 결과 전달

**라인 610-617 부분 (CashEndingCompletionPage 호출)에 추가:**

기존 코드:
```dart
builder: (context) => CashEndingCompletionPage(
  tabType: 'vault',
  grandTotal: grandTotal,
  currencies: currenciesWithData,
  storeName: state.stores.firstWhere((s) => s.storeId == state.selectedStoreId).storeName,
  locationName: state.vaultLocations.firstWhere((l) => l.locationId == state.selectedVaultLocationId).locationName,
  denominationQuantities: denominationQuantitiesMap,
  transactionType: transactionType,
),
```

변경 후:
```dart
builder: (context) => CashEndingCompletionPage(
  tabType: 'vault',
  grandTotal: grandTotal,
  currencies: currenciesWithData,
  storeName: state.stores.firstWhere((s) => s.storeId == state.selectedStoreId).storeName,
  locationName: state.vaultLocations.firstWhere((l) => l.locationId == state.selectedVaultLocationId).locationName,
  denominationQuantities: denominationQuantitiesMap,
  transactionType: transactionType,
  recountResult: recountResult, // ⭐ Recount 결과 전달
),
```

---

## 완성된 흐름

### In/Out 버튼 (transactionType = 'debit' or 'credit')
```
1. VaultTransaction 생성 (isCredit 플래그 설정)
2. VaultTabNotifier.saveVaultTransaction() 호출
3. VaultRepository.saveVaultTransaction()
4. VaultRemoteDataSource.saveVaultTransaction()
5. vault_amount_insert RPC (debit/credit INSERT)
```

### Recount 버튼 (transactionType = 'recount')
```
1. VaultRecount 생성 (Stock 수량)
2. VaultTabNotifier.recountVault() 호출
3. VaultRepository.recountVault()
4. VaultRemoteDataSource.recountVault()
5. vault_amount_recount RPC (Stock → Flow 변환)
6. 결과 반환:
   {
     'success': true,
     'adjustment_count': 2,
     'total_variance': 2300000,
     'adjustments': [...]
   }
```

---

## 체크리스트

### Domain Layer ✅
- [x] VaultRecount entity 생성
- [x] VaultRepository.recountVault() 메서드 추가

### Data Layer ✅
- [x] VaultRecountDto 생성
- [x] VaultRemoteDataSource.recountVault() 추가
- [x] VaultRepositoryImpl.recountVault() 구현

### Presentation Layer ⏳
- [x] VaultTabNotifier.recountVault() 추가
- [ ] CashEndingPage._saveVaultTransaction() 분기 로직 추가 ← **이 파일 수정 필요**
- [ ] freezed 코드 생성 실행 필요

---

## 다음 단계

1. **이 가이드를 따라 cash_ending_page.dart 수정**
2. **Freezed 코드 생성 실행:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. **테스트**

