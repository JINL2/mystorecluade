# AppState 관리 가이드

## 현재 AppState 구조 (절대 수정 금지)

```dart
class AppState {
  // ⚠️ 아래 필드들의 이름과 타입은 절대 변경 금지
  final UserWithCompanies? userWithCompanies;
  final String? selectedCompanyId;
  final String? selectedStoreId;
  final DateTime? lastSyncTime;
  final List<CategoryWithFeatures>? categoriesWithFeatures;
  final Map<String, dynamic>? rawApiData;
  final bool isRefreshNeeded;
}
```

## 새 필드 추가 방법

### 1. AppState 클래스에 필드 추가
```dart
class AppState {
  // ... 기존 필드들 ...
  final String? newFieldName;  // ✅ 새 필드 추가
}
```

### 2. 생성자 업데이트
```dart
const AppState({
  // ... 기존 매개변수들 ...
  this.newFieldName,  // 추가
});
```

### 3. copyWith 메서드 업데이트
```dart
AppState copyWith({
  // ... 기존 매개변수들 ...
  String? newFieldName,  // 추가
}) {
  return AppState(
    // ... 기존 필드들 ...
    newFieldName: newFieldName ?? this.newFieldName,
  );
}
```

### 4. toJson 메서드 업데이트
```dart
Map<String, dynamic> toJson() {
  return {
    // ... 기존 필드들 ...
    'newFieldName': newFieldName,
  };
}
```

### 5. fromJson 메서드 업데이트
```dart
factory AppState.fromJson(Map<String, dynamic> json) {
  return AppState(
    // ... 기존 필드들 ...
    newFieldName: json['newFieldName'] as String?,
  );
}
```

### 6. Notifier에 업데이트 메서드 추가
```dart
Future<void> updateNewField(String value) async {
  state = state.copyWith(newFieldName: value);
  await _saveToStorage();
}
```

## 사용 예시

```dart
// 상태 읽기
final appState = ref.watch(appStateProvider);
final companyId = appState.selectedCompanyId;

// 상태 업데이트
final notifier = ref.read(appStateProvider.notifier);
await notifier.selectCompany(companyId);
```

## 주요 Provider

- `appStateProvider` - 메인 상태 관리
- `selectedCompanyProvider` - 선택된 회사
- `selectedStoreProvider` - 선택된 매장
- `userCompaniesDataProvider` - 사용자 회사 데이터