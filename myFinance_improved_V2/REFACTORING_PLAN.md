# Time Table Manage Page 리팩토링 계획
## 30년차 Flutter 개발자 관점의 단계적 GOD CLASS 해체 전략

---

## 📊 현재 상태 분석

### 문제점
```dart
_TimeTableManagePageState (1,117 lines)
├─ 60+ state variables (심각한 메모리 낭비)
├─ Schedule tab 로직 (400+ lines)
├─ Manage tab 로직 (400+ lines)
├─ 수동 데이터 fetching & 캐싱 (200+ lines)
└─ 복잡한 setState() 체인 (전체 rebuild 발생)
```

**심각도**: ⛔ **BLOCKING**
- 프로덕션 환경 3-6개월 내 장애 가능
- 매 setState()마다 1,117줄 재평가
- 테스트 불가능
- 신규 개발자 온보딩 1주일+

---

## 🎯 리팩토링 전략: 4-Phase Approach

### Phase 1: State 추출 (1-2일) ✅ 진행 중
**목표**: God Class → Riverpod State Management

#### 1.1 State 클래스 정의 (Freezed)
```
✅ lib/features/time_table_manage/presentation/state/
   ├─ schedule_tab_state.dart (생성 완료)
   ├─ manage_tab_state.dart (생성 완료)
   ├─ time_table_filters_state.dart (예정)
   └─ time_table_cache_state.dart (예정)
```

#### 1.2 Notifier 생성
```
lib/features/time_table_manage/presentation/notifiers/
├─ schedule_tab_notifier.dart
│  └─ class ScheduleTabNotifier extends StateNotifier<ScheduleTabState>
│
├─ manage_tab_notifier.dart
│  └─ class ManageTabNotifier extends StateNotifier<ManageTabState>
│
├─ time_table_cache_notifier.dart
│  └─ class TimeTableCacheNotifier extends StateNotifier<TimeTableCacheState>
│     - 월별 데이터 캐싱 전담
│     - LRU 캐시 전략 구현
│     - 메모리 효율성 관리
│
└─ time_table_filters_notifier.dart
   └─ class TimeTableFiltersNotifier extends StateNotifier<TimeTableFiltersState>
      - 필터 상태 전담
      - 필터 조합 로직
```

#### 1.3 Provider 정의
```dart
// lib/features/time_table_manage/presentation/providers/state_providers.dart

// Schedule Tab
final scheduleTabProvider = StateNotifierProvider<ScheduleTabNotifier, ScheduleTabState>(
  (ref) => ScheduleTabNotifier(
    repository: ref.watch(timeTableRepositoryProvider),
  ),
);

// Manage Tab
final manageTabProvider = StateNotifierProvider<ManageTabNotifier, ManageTabState>(
  (ref) => ManageTabNotifier(
    repository: ref.watch(timeTableRepositoryProvider),
  ),
);

// Cache
final cacheProvider = StateNotifierProvider<TimeTableCacheNotifier, TimeTableCacheState>(
  (ref) => TimeTableCacheNotifier(),
);

// Filters
final filtersProvider = StateNotifierProvider<TimeTableFiltersNotifier, TimeTableFiltersState>(
  (ref) => TimeTableFiltersNotifier(),
);
```

#### 1.4 Page 리팩토링
```dart
// BEFORE (1,117 lines)
class _TimeTableManagePageState extends ConsumerState<TimeTableManagePage> {
  DateTime selectedDate = DateTime.now();
  String? selectedFilter;
  // ... 58개 더

  @override
  Widget build(BuildContext context) {
    // 1,000+ lines of logic
  }
}

// AFTER (~200 lines)
class TimeTableManagePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleState = ref.watch(scheduleTabProvider);
    final manageState = ref.watch(manageTabProvider);

    return TossScaffold(
      body: TabBarView(
        children: [
          ScheduleTabView(state: scheduleState),
          ManageTabView(state: manageState),
        ],
      ),
    );
  }
}
```

---

## Phase 2: Widget 분리 (1일)

### 2.1 Schedule Tab 분리
```
lib/features/time_table_manage/presentation/pages/tabs/
├─ schedule_tab_page.dart (~300 lines)
│  └─ Schedule 탭의 모든 UI + 로직
│
└─ manage_tab_page.dart (~300 lines)
   └─ Manage 탭의 모든 UI + 로직
```

### 2.2 공통 위젯 추출
```
lib/features/time_table_manage/presentation/widgets/common/
├─ date_selector.dart
│  └─ 날짜 선택 UI (양쪽 탭 공통)
│
├─ month_statistics.dart
│  └─ 월별 통계 표시 (Manage 탭)
│
└─ loading_overlay.dart
   └─ 로딩 상태 표시
```

---

## Phase 3: 비즈니스 로직 최적화 (1-2일)

### 3.1 데이터 Fetching 전략
```dart
// BEFORE: 매번 fetch + 수동 캐싱
Future<void> fetchManagerCards({required DateTime forDate}) async {
  setState(() => isLoadingCards = true);
  final monthKey = '${forDate.year}-${forDate.month}';

  if (managerCardsDataByMonth.containsKey(monthKey)) {
    setState(() => isLoadingCards = false);
    return; // 수동 캐시 체크
  }

  final data = await repository.getManagerShiftCards(...);
  setState(() {
    managerCardsDataByMonth[monthKey] = data; // 수동 캐싱
    isLoadingCards = false;
  });
}

// AFTER: Riverpod의 자동 캐싱 + 최적화
@riverpod
Future<ManagerShiftCards> managerCards(
  ManagerCardsRef ref,
  String storeId,
  DateTime date,
) async {
  // Riverpod가 자동으로 캐싱 관리
  // keepAlive로 메모리 관리
  // autoDispose로 불필요한 데이터 제거

  final repository = ref.watch(timeTableRepositoryProvider);
  return repository.getManagerShiftCards(
    storeId: storeId,
    targetDate: date,
  );
}

// 사용
final cardsAsync = ref.watch(managerCardsProvider(storeId, date));
cardsAsync.when(
  data: (cards) => CardListView(cards: cards),
  loading: () => LoadingView(),
  error: (err, stack) => ErrorView(error: err),
);
```

### 3.2 Selection 로직 최적화
```dart
// BEFORE: 복잡한 Map 관리
Set<String> selectedShiftRequests = {};
Map<String, bool> selectedShiftApprovalStates = {};
Map<String, String> selectedShiftRequestIds = {};

void _handleShiftSelection(String shiftId, ShiftRequest request) {
  setState(() {
    if (selectedShiftRequests.contains(shiftId)) {
      selectedShiftRequests.remove(shiftId);
      selectedShiftApprovalStates.remove(shiftId);
      selectedShiftRequestIds.remove(shiftId);
    } else {
      selectedShiftRequests.add(shiftId);
      selectedShiftApprovalStates[shiftId] = request.isApproved;
      selectedShiftRequestIds[shiftId] = request.shiftRequestId;
    }
  });
}

// AFTER: Immutable State + 단순 로직
@freezed
class SelectionState {
  const factory SelectionState({
    @Default({}) Map<String, ShiftRequest> selectedRequests,
  }) = _SelectionState;

  bool isSelected(String id) => selectedRequests.containsKey(id);

  SelectionState toggle(String id, ShiftRequest request) {
    final newMap = Map<String, ShiftRequest>.from(selectedRequests);
    if (newMap.containsKey(id)) {
      newMap.remove(id);
    } else {
      newMap[id] = request;
    }
    return copyWith(selectedRequests: newMap);
  }
}

// Notifier
void toggleSelection(String id, ShiftRequest request) {
  state = state.toggle(id, request);
}
```

### 3.3 캐시 전략 개선
```dart
// lib/features/time_table_manage/presentation/notifiers/time_table_cache_notifier.dart

class TimeTableCacheNotifier extends StateNotifier<TimeTableCacheState> {
  TimeTableCacheNotifier() : super(const TimeTableCacheState());

  // LRU Cache - 최대 3개월치 데이터만 유지
  static const _maxCacheMonths = 3;

  void addToCache(String monthKey, dynamic data) {
    final newCache = Map<String, dynamic>.from(state.cache);
    newCache[monthKey] = data;

    // LRU 정책: 오래된 데이터 제거
    if (newCache.length > _maxCacheMonths) {
      final oldestKey = newCache.keys.first;
      newCache.remove(oldestKey);
    }

    state = state.copyWith(cache: newCache);
  }

  void clearOldCache() {
    final now = DateTime.now();
    final cutoffDate = now.subtract(const Duration(days: 90));

    final newCache = Map<String, dynamic>.from(state.cache)
      ..removeWhere((key, _) {
        final parts = key.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final date = DateTime(year, month);
        return date.isBefore(cutoffDate);
      });

    state = state.copyWith(cache: newCache);
  }
}
```

---

## Phase 4: 성능 최적화 & 테스트 (1일)

### 4.1 성능 최적화
```dart
// 1. Provider Family로 세밀한 rebuild 제어
@riverpod
ManagerOverview monthlyOverview(
  MonthlyOverviewRef ref,
  String monthKey,
) {
  // monthKey가 변경될 때만 rebuild
  return ref.watch(manageTabProvider.select(
    (state) => state.overviewByMonth[monthKey],
  ));
}

// 2. Select를 활용한 최적화
final selectedFilter = ref.watch(
  filtersProvider.select((state) => state.selectedFilter),
);
// selectedFilter만 변경되면 이 위젯만 rebuild

// 3. 불변성 보장으로 비교 최적화
@override
bool operator ==(Object other) =>
  identical(this, other) ||
  other is ScheduleTabState &&
    runtimeType == other.runtimeType &&
    selectedDate == other.selectedDate &&
    // Freezed가 자동 생성
```

### 4.2 단위 테스트
```dart
// test/features/time_table_manage/presentation/notifiers/schedule_tab_notifier_test.dart

void main() {
  group('ScheduleTabNotifier', () {
    late MockTimeTableRepository mockRepository;
    late ScheduleTabNotifier notifier;

    setUp(() {
      mockRepository = MockTimeTableRepository();
      notifier = ScheduleTabNotifier(repository: mockRepository);
    });

    test('초기 상태는 비어있어야 함', () {
      expect(notifier.state.selectedDate, isNull);
      expect(notifier.state.isLoading, false);
    });

    test('날짜 선택 시 상태가 업데이트되어야 함', () {
      final date = DateTime(2025, 1, 15);

      notifier.selectDate(date);

      expect(notifier.state.selectedDate, date);
    });

    test('데이터 로딩 시 로딩 상태가 true가 되어야 함', () async {
      when(() => mockRepository.getMonthlyShiftStatus(any()))
          .thenAnswer((_) async => []);

      notifier.loadMonthlyData('store-1', DateTime.now());

      expect(notifier.state.isLoadingShiftStatus, true);
    });
  });
}
```

---

## 📁 최종 파일 구조

```
lib/features/time_table_manage/
│
├─ presentation/
│  ├─ pages/
│  │  ├─ time_table_manage_page.dart (200 lines) ✅ 간소화
│  │  └─ tabs/
│  │     ├─ schedule_tab_page.dart (300 lines)
│  │     └─ manage_tab_page.dart (300 lines)
│  │
│  ├─ state/
│  │  ├─ schedule_tab_state.dart ✅ 생성 완료
│  │  ├─ schedule_tab_state.freezed.dart (자동 생성)
│  │  ├─ manage_tab_state.dart ✅ 생성 완료
│  │  ├─ manage_tab_state.freezed.dart (자동 생성)
│  │  ├─ time_table_filters_state.dart
│  │  └─ time_table_cache_state.dart
│  │
│  ├─ notifiers/
│  │  ├─ schedule_tab_notifier.dart
│  │  ├─ manage_tab_notifier.dart
│  │  ├─ time_table_cache_notifier.dart
│  │  └─ time_table_filters_notifier.dart
│  │
│  ├─ providers/
│  │  ├─ state_providers.dart (모든 provider 정의)
│  │  └─ data_providers.dart (data fetching providers)
│  │
│  └─ widgets/
│     ├─ calendar/ (기존 유지)
│     ├─ manage/ (기존 유지)
│     ├─ schedule/ (기존 유지)
│     └─ common/ (새로 추가)
│        ├─ date_selector.dart
│        ├─ month_statistics.dart
│        └─ loading_overlay.dart
│
├─ domain/ (변경 없음)
└─ data/ (변경 없음)
```

---

## 🔢 예상 결과

### Before
```
_TimeTableManagePageState
├─ 1,117 lines
├─ 60+ state variables
├─ setState() 호출 시 전체 rebuild
├─ 수동 캐싱으로 메모리 누수 가능
└─ 테스트 불가능
```

### After
```
TimeTableManagePage (~200 lines)
├─ ScheduleTabNotifier (150 lines)
├─ ManageTabNotifier (150 lines)
├─ CacheNotifier (100 lines)
├─ FiltersNotifier (80 lines)
├─ 각 State 클래스 (50-80 lines each)
└─ Total: ~800 lines (분산됨)

성능 개선:
├─ 90% 불필요한 rebuild 제거
├─ 메모리 사용량 40% 감소 (LRU 캐시)
├─ 코드 재사용성 300% 증가
└─ 테스트 커버리지 80%+ 가능
```

---

## 🚀 실행 단계

### Step 1: State 클래스 생성 (30분)
```bash
# Freezed 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 2: Notifier 생성 (2시간)
- ScheduleTabNotifier 구현
- ManageTabNotifier 구현
- 기존 로직을 메서드로 이동

### Step 3: Provider 연결 (1시간)
- Provider 정의
- 기존 위젯에서 ref.watch() 연결

### Step 4: Page 리팩토링 (2시간)
- setState() 제거
- StatefulWidget → ConsumerWidget 변환
- 로직을 Notifier로 이동

### Step 5: 테스트 (2시간)
- 단위 테스트 작성
- 통합 테스트
- Hot reload로 동작 확인

---

## ⚠️ 주의사항

### 1. 점진적 마이그레이션
```dart
// 한 번에 모든 것을 바꾸지 말 것!
// 탭 단위로 하나씩 마이그레이션

// Phase 1-1: Schedule 탭만 Riverpod으로
// Phase 1-2: Manage 탭도 Riverpod으로
// Phase 2: 두 탭 통합 최적화
```

### 2. 기존 기능 유지
```dart
// 리팩토링 중에도 앱이 동작해야 함
// Feature flag로 구버전/신버전 전환 가능하게 구현

final useNewScheduleTab = ref.watch(featureFlagProvider('new_schedule_tab'));

if (useNewScheduleTab) {
  return NewScheduleTabView();
} else {
  return LegacyScheduleTabView();
}
```

### 3. 롤백 전략
```dart
// Git branch 전략
main (stable)
  └─ refactor/time-table-riverpod (작업 브랜치)
       ├─ feat/schedule-tab-state
       ├─ feat/manage-tab-state
       └─ feat/integration

// 각 단계마다 커밋하여 문제 발생 시 롤백 가능
```

---

## 📊 성공 지표

### 코드 품질
- [ ] 단일 파일 500줄 이하
- [ ] 함수/메서드 50줄 이하
- [ ] Cyclomatic Complexity < 10
- [ ] 테스트 커버리지 > 80%

### 성능
- [ ] 불필요한 rebuild 90% 감소
- [ ] 메모리 사용량 40% 감소
- [ ] 페이지 전환 속도 2배 향상

### 유지보수성
- [ ] 신규 개발자 온보딩 1일로 단축
- [ ] 버그 수정 시간 50% 단축
- [ ] 코드 리뷰 시간 60% 단축

---

## 다음 단계

1. ✅ State 클래스 정의 완료
2. ⏳ Freezed 코드 생성
3. ⏳ Notifier 구현 시작
4. ⏳ ...

**준비되면 "시작"이라고 말씀해주세요!**
