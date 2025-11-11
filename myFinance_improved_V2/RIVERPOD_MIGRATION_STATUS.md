# Riverpod Migration Status Report
## Time Table Manage Page State 전환 현황

---

## ✅ 완료된 전환 (Provider 사용 중)

### 1. Monthly Shift Status ✅
```dart
// ❌ BEFORE (Page State)
List<MonthlyShiftStatus> monthlyShiftStatusList = [];
bool isLoadingShiftStatus = false;

// ✅ AFTER (Provider 사용)
final state = ref.read(monthlyShiftStatusProvider(selectedStoreId!));
final allDailyShifts = state.allMonthlyStatuses.expand(...).toList();
```
**위치**: Line 391-392
**상태**: ✅ 완전히 Provider로 전환됨

### 2. Selected Shift Requests ✅
```dart
// ❌ BEFORE (Page State)
Set<String> selectedShiftRequests = {};
Map<String, bool> selectedShiftApprovalStates = {};

// ✅ AFTER (Provider 사용)
// Line 67-71: 주석으로 제거됨
// Now managed by selectedShiftRequestsProvider
```
**상태**: ✅ 완전히 제거되고 Provider 사용

### 3. Shift Metadata ✅
```dart
// ❌ BEFORE (Page State)
dynamic shiftMetadata;
bool isLoadingMetadata = false;

// ✅ AFTER (Provider 사용)
// Line 56-57: 주석으로 제거됨
// Now managed by shiftMetadataProvider
```
**상태**: ✅ 완전히 제거되고 Provider 사용

### 4. Manager Overview (부분) ✅
```dart
// ❌ BEFORE (Page State)
Map<String, ManagerOverview> managerOverviewDataByMonth = {};
bool isLoadingOverview = false;

// ✅ AFTER (Provider 사용)
// Line 73-74: 주석으로 제거됨
final managerOverviewState = ref.read(managerOverviewProvider(...));
final managerOverviewDataByMonth = managerOverviewState?.dataByMonth ?? {};
final isLoadingOverview = managerOverviewState?.isLoading ?? false;
```
**위치**: Line 178-182
**상태**: ⚠️ Provider 사용하지만 로컬 변수로 복사함 (최적화 가능)

---

## ❌ 미완료 전환 (아직 Page State 사용)

### 1. Manager Shift Cards ❌ **가장 시급!**
```dart
// ❌ STILL Page State (Line ~100)
Map<String, ManagerShiftCards> managerCardsDataByMonth = {};
bool isLoadingCards = false;

// 사용처:
Line 313: managerCardsDataByMonth: managerCardsDataByMonth,
Line 425-462: fetchManagerCards() - setState() 사용

setState() 호출:
- Line 425: setState(() { isLoadingCards = true; });
- Line 443: setState(() { isLoadingCards = false; });
- Line 457: setState(() { managerCardsDataByMonth[monthKey] = cardsData; });
- Line 462: setState(() { isLoadingCards = false; });
```

**문제점:**
- Provider가 없음! (managerShiftCardsProvider 생성 필요)
- 4번의 setState() 호출
- 수동 캐싱 (월별 데이터를 Map으로 관리)

**해결 방법:**
```dart
// 1. Provider 생성 필요
@riverpod
class ManagerShiftCards extends _$ManagerShiftCards {
  @override
  ManagerShiftCardsState build(String storeId) {
    return const ManagerShiftCardsState(
      dataByMonth: {},
      isLoading: false,
    );
  }

  Future<void> loadCards(DateTime date) async {
    // 기존 fetchManagerCards 로직을 여기로 이동
  }
}

// 2. 사용
final cardsState = ref.watch(managerShiftCardsProvider(storeId));
final cardsData = cardsState.dataByMonth;
final isLoading = cardsState.isLoading;
```

### 2. Selected Filter ❌
```dart
// ❌ STILL Page State (Line ~107)
String? selectedFilter = 'approved';

// 사용처:
Line 315-318: onFilterChanged with setState()
Line 316: setState(() { selectedFilter = filter; });
```

**문제점:**
- StateProvider가 없음
- setState() 사용

**해결 방법:**
```dart
// Provider 생성
final selectedFilterProvider = StateProvider<String?>((ref) => 'approved');

// 사용
final selectedFilter = ref.watch(selectedFilterProvider);
ref.read(selectedFilterProvider.notifier).state = newFilter;
```

### 3. Manage Selected Date ❌
```dart
// ❌ STILL Page State (Line ~102)
DateTime manageSelectedDate = DateTime.now();

// 사용처:
Line 313: manageSelectedDate: manageSelectedDate,
Line 321-323: onDateChanged with setState()
Line 322: setState(() { manageSelectedDate = date; });
Line 360: 월 키 생성에 사용
Line 401, 417: fetchManagerOverview/Cards에 사용
```

**문제점:**
- StateProvider가 없음
- setState() 사용
- Schedule tab의 selectedDate와 중복 관리

**해결 방법:**
```dart
// Provider 생성
final manageSelectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// 사용
final manageDate = ref.watch(manageSelectedDateProvider);
ref.read(manageSelectedDateProvider.notifier).state = newDate;
```

### 4. UI-Only State (유지 가능) ✅
```dart
// ✅ 유지 가능 - UI Controller
late TabController _tabController;
final ScrollController _scheduleScrollController = ScrollController();

// ✅ 유지 가능 - 상수/초기화 값
String? _featureName;
String? _featureId;
bool _featureInfoExtracted = false;
late final String _aiChatSessionId;
```

**이유:**
- UI Controller는 Page State로 유지하는 것이 Flutter 권장사항
- 단순 초기화 값은 비즈니스 로직이 아님

---

## 📊 setState() 호출 현황

### 총 14번의 setState() 호출

#### Category 1: Provider로 전환 가능 (6회)
```dart
Line 315: selectedFilter 변경                    ← StateProvider 필요
Line 321: manageSelectedDate 변경                ← StateProvider 필요
Line 425: isLoadingCards = true                  ← Provider로 이동
Line 443: isLoadingCards = false (error)         ← Provider로 이동
Line 457: managerCardsDataByMonth 업데이트       ← Provider로 이동
Line 462: isLoadingCards = false                 ← Provider로 이동
```

#### Category 2: UI 업데이트만 (유지 가능, 8회)
```dart
Line 494: selectedStoreId 변경 후 UI rebuild     ← 복잡한 비즈니스 로직 있음
Line 750: selectedDate 변경                      ← StateProvider 있음 (활용 가능)
Line 813: selectedDate 변경                      ← StateProvider 있음
Line 822: focusedMonth 변경                      ← StateProvider 있음
Line 850: selectedDate 변경                      ← StateProvider 있음
Line 973: focusedMonth 변경                      ← StateProvider 있음
Line 1021: UI rebuild만 (빈 setState)            ← 제거 가능
Line 1034: UI rebuild만 (빈 setState)            ← 제거 가능
```

---

## 🎯 우선순위별 작업 계획

### Priority 1: Manager Shift Cards Provider 생성 (2-3시간)
**가장 시급! Bottom Sheet 업데이트가 반영 안 되는 버그의 원인**

```dart
// 1. State 클래스 생성
@freezed
class ManagerShiftCardsState with _$ManagerShiftCardsState {
  const factory ManagerShiftCardsState({
    @Default({}) Map<String, ManagerShiftCards> dataByMonth,
    @Default(false) bool isLoading,
    @Default(null) String? error,
  }) = _ManagerShiftCardsState;
}

// 2. Notifier 생성
@riverpod
class ManagerShiftCardsNotifier extends _$ManagerShiftCardsNotifier {
  @override
  ManagerShiftCardsState build(String storeId) {
    return const ManagerShiftCardsState();
  }

  Future<void> loadCards(DateTime date, {bool forceRefresh = false}) async {
    // fetchManagerCards 로직 이동
  }
}

// 3. Page에서 사용
final cardsState = ref.watch(managerShiftCardsNotifierProvider(storeId));
```

**제거할 코드:**
- Line ~100: `Map<String, ManagerShiftCards> managerCardsDataByMonth = {};`
- Line ~105: `bool isLoadingCards = false;`
- Line 425-462: `fetchManagerCards()` 메서드
- Line 315-318, 321-325: setState() 호출

**예상 효과:**
- setState() 6회 제거 (14 → 8)
- Bottom Sheet 업데이트 자동 반영
- 코드 100줄 감소

### Priority 2: Filter & Date StateProvider 생성 (1시간)
```dart
// lib/features/time_table_manage/presentation/providers/ui_state_providers.dart

final selectedFilterProvider = StateProvider.autoDispose<String?>(
  (ref) => 'approved',
);

final manageSelectedDateProvider = StateProvider.autoDispose<DateTime>(
  (ref) => DateTime.now(),
);
```

**제거할 코드:**
- Line ~107: `String? selectedFilter = 'approved';`
- Line ~102: `DateTime manageSelectedDate = DateTime.now();`
- Line 315-318, 321-323: setState() 호출

**예상 효과:**
- setState() 2회 제거 (8 → 6)
- 코드 20줄 감소

### Priority 3: 기존 StateProvider 활용 (30분)
```dart
// selectedDate, focusedMonth는 이미 Provider가 있음!

// Page에서 사용
final selectedDate = ref.watch(selectedDateProvider);
ref.read(selectedDateProvider.notifier).state = newDate;

final focusedMonth = ref.watch(focusedMonthProvider);
ref.read(focusedMonthProvider.notifier).state = newMonth;
```

**제거할 코드:**
- Line 49: `DateTime selectedDate = DateTime.now();`
- Line 50: `DateTime focusedMonth = DateTime.now();`
- Line 750, 813, 822, 850, 973: setState() 호출

**예상 효과:**
- setState() 5회 제거 (6 → 1)
- 코드 30줄 감소

### Priority 4: 빈 setState() 제거 (10분)
```dart
// Line 1021, 1034: setState(() {});
// → ref.invalidate() 또는 제거
```

**예상 효과:**
- setState() 2회 제거 (1 → 0? 또는 UI Controller만 남음)

---

## 📈 최종 목표 달성률

### Before (현재)
```
Total Lines: 1,122
setState() calls: 14
Page State variables: 9
- managerCardsDataByMonth        ❌
- isLoadingCards                 ❌
- selectedFilter                 ❌
- manageSelectedDate             ❌
- selectedDate                   ⚠️ (Provider 있지만 사용 안 함)
- focusedMonth                   ⚠️ (Provider 있지만 사용 안 함)
- selectedStoreId                ⚠️ (Provider 있지만 사용 안 함)
- _tabController                 ✅ (UI Controller - 유지)
- _scrollController              ✅ (UI Controller - 유지)

Provider 활용도: 50% (있지만 일부만 사용)
```

### After (예상)
```
Total Lines: 900-950 (15-20% 감소)
setState() calls: 0-1 (UI Controller만)
Page State variables: 2-3 (UI Controller만)
- _tabController                 ✅
- _scrollController              ✅
- _featureInfo (초기화 값)      ✅

Provider 활용도: 100%
```

---

## 🚀 다음 단계

**"Priority 1 시작"이라고 말씀하시면:**
1. ManagerShiftCardsState 생성 (Freezed)
2. ManagerShiftCardsNotifier 생성
3. fetchManagerCards() 로직 이동
4. Page에서 Provider 사용
5. setState() 6회 제거

**예상 소요 시간: 2-3시간**
**코드 리뷰 난이도: 중간**
**롤백 가능 여부: 가능**

---

## ⚠️ 발견된 추가 이슈

### Issue 1: managerOverviewDataByMonth 중복
```dart
// Line 178-182: Provider에서 읽지만 로컬 변수로 복사
final managerOverviewState = ref.read(managerOverviewProvider(...));
final managerOverviewDataByMonth = managerOverviewState?.dataByMonth ?? {};
final isLoadingOverview = managerOverviewState?.isLoading ?? false;

// 최적화 가능:
// 직접 Provider에서 읽어서 ManageTabView에 전달
```

### Issue 2: selectedStoreId가 여전히 Page State
```dart
// Line 51: String? selectedStoreId;
// Line 494: setState(() { selectedStoreId = result; });

// selectedStoreIdProvider가 이미 있는데 왜 Page State로 관리?
// 확인 필요!
```

### Issue 3: 빈 setState() 호출
```dart
// Line 1021, 1034: setState(() {});
// 왜 필요한지 확인 필요
// ref.invalidate()로 대체 가능할 수도
```

---

## 결론

### 현재 상태: 60% 완료 ⚠️
- ✅ Monthly Shift Status: Provider 사용 중
- ✅ Selected Requests: Provider 사용 중
- ✅ Shift Metadata: Provider 사용 중
- ⚠️ Manager Overview: Provider 있지만 로컬 변수 복사
- ❌ Manager Shift Cards: Provider 없음 (긴급!)
- ❌ Filter/Date: StateProvider 없음

### 다음 작업
**Priority 1만 완료해도 80% 이상 문제 해결됨!**

준비되시면 말씀해주세요! 🚀
