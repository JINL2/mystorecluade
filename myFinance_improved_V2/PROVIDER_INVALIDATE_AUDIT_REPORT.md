# Provider Invalidate 누락 분석 보고서

**분석일**: 2025-12-29
**대상**: myFinance_improved_V2/lib/features

---

## 요약

상태 변경(Create/Update/Delete) 후 Provider invalidate가 누락되어 UI가 즉시 갱신되지 않는 문제를 분석했습니다.

| 상태 | 파일 수 |
|------|--------|
| ✅ 수정 완료 | 4개 |
| 🟡 검토 필요 | 2개 |
| ✅ 정상 | 나머지 |

---

## ✅ 수정 완료 (2025-12-29)

### 1. employee_setting/presentation/providers/employee_providers.dart
- `refreshEmployees()` 함수에 `mutableEmployeeListProvider.clear()` 추가
- 캐시 clear 후 provider invalidate 순서 보장

### 2. employee_setting/presentation/widgets/salary_edit_modal.dart
- 급여 저장 성공 후 `mutableEmployeeListProvider.clear()` + `employeeSalaryListProvider` invalidate 추가

### 3. register_denomination/presentation/widgets/edit_exchange_rate_bottom_sheet.dart
- 환율 업데이트 후 `companyCurrenciesProvider`, `companyCurrenciesStreamProvider` invalidate 추가

### 4. register_denomination/presentation/widgets/add_currency_bottom_sheet.dart
- `Future.microtask` 제거하고 `context.pop()` 전에 invalidate 실행하도록 수정

---

## 🟡 검토 필요

### 1. cash_transaction 파일들

**경로**:
- `cash_transaction/presentation/pages/expense_entry_sheet.dart`
- `cash_transaction/presentation/pages/transfer_entry_sheet.dart`
- `cash_transaction/presentation/pages/debt_entry_sheet.dart`

**현재 패턴**:
```dart
await repository.createExpenseEntry(...);

if (mounted) {
  widget.onSuccess();  // 콜백으로 부모에게 위임
}
```

**상태**: 부모 페이지에서 `onSuccess` 콜백 내에서 처리하는지 확인 필요

---

### 5. inventory_management 파일들

**경로**:
- `inventory_management/presentation/pages/add_product_page.dart`
- `inventory_management/presentation/pages/edit_product_page.dart`

**현재 코드**:
```dart
final product = await repository.createProduct(...);

if (product != null && mounted) {
  await ref.read(inventoryPageNotifierProvider.notifier).refresh();  // ✅ 정상
  ...
}
```

**상태**: `refresh()` 메서드가 충분한 invalidate를 하는지 확인 필요

---

## ✅ 정상 처리된 파일들

### role_tab.dart (employee_setting)
```dart
// 삭제 성공 시
ref.read(mutableEmployeeListProvider.notifier).update(updatedList);  // ✅ 캐시 업데이트
ref.invalidate(employeeSalaryListProvider);  // ✅ Provider invalidate
```

### add_account_page.dart (cash_location)
```dart
await useCase(CreateCashLocationParams(...));
ref.invalidate(allCashLocationsProvider);  // ✅ Provider invalidate
```

### role_selection_helper.dart (employee_setting)
```dart
await roleRepository.updateUserRole(userId, selectedItem.id);
await refreshEmployees(ref);  // ✅ 수정된 함수 사용
```

---

## 수정 가이드

### Best Practice 패턴

```dart
// 1. 데이터 변경
final result = await repository.update/create/delete(...);

// 2. 성공 시 처리
if (result.isSuccess) {
  // 2-1. 캐시가 있으면 먼저 clear
  ref.read(mutableListProvider.notifier).clear();

  // 2-2. Provider invalidate
  ref.invalidate(relatedProvider1);
  ref.invalidate(relatedProvider2);

  // 2-3. UI 업데이트 (dialog, pop 등)
  if (mounted) {
    await showSuccessDialog();
    context.pop();
  }
}
```

### 주의사항

1. **invalidate는 pop 전에**: `context.pop()` 후에는 ref가 유효하지 않을 수 있음
2. **캐시 패턴 사용 시**: `mutableListProvider.clear()` 필수
3. **콜백 위임 시**: 부모 페이지에서 반드시 invalidate 처리

---

## 파일별 수정 우선순위

| 우선순위 | 파일 | 작업 |
|---------|------|------|
| 1 | `edit_exchange_rate_bottom_sheet.dart` | invalidate 추가 |
| 2 | `add_currency_bottom_sheet.dart` | invalidate 순서 수정 |
| 3 | `cash_transaction/*.dart` | 부모 콜백 확인 |
| 4 | `inventory_management/*.dart` | refresh() 동작 확인 |
