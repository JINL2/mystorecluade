# Monthly Attendance Flutter 구현 플랜

> **작성일:** 2025-12-28
> **상태:** 검토 대기

---

## 📋 현재 구조 분석

### 1. 기존 Hourly 아키텍처

```
AttendanceMainPage (TabController: 3 tabs)
├── Tab 0: MyScheduleTab (★ 주요 변경 지점)
│   ├── ScheduleHeader (Today's Shift / QR 버튼)
│   ├── WeekDatesPicker / MonthDatesPicker
│   └── Shift Card List
├── Tab 1: ShiftRequestsTab (시프트 신청)
└── Tab 2: StatsTab (통계)

MyScheduleTab 내부:
├── monthlyShiftCardsProvider → shift_requests 테이블
├── ScheduleShiftFinder.findCurrentShift() → 현재 시프트 찾기
├── _navigateToQRScanner() → /attendance/qr-scanner 라우트
└── ShiftCard (TossWeekShiftCard 사용)
```

### 2. 핵심 파일들

| 파일 | 역할 | Monthly 영향 |
|------|------|-------------|
| `attendance_main_page.dart` | 3 탭 페이지 | 분기 로직 추가 필요 |
| `my_schedule_tab.dart` | Hourly 메인 뷰 | **변경 없음** (Hourly 전용) |
| `qr_scanner_page.dart` | QR 스캔 처리 | 분기 로직 추가 필요 |
| `attendance_providers.dart` | Riverpod providers | Monthly providers 추가 |
| `attendance_datasource.dart` | Supabase RPC 호출 | Monthly datasource 분리 |

### 3. 위험 요소

```
⚠️ 주의: 기존 Hourly 로직을 절대 건드리지 않아야 함

위험한 접근:
- MyScheduleTab 내부에 분기 추가 ❌
- AttendanceContent 수정 ❌
- 기존 Provider 수정 ❌

안전한 접근:
- 새로운 Monthly 전용 위젯 생성 ✅
- 새로운 Monthly 전용 Provider 생성 ✅
- AttendanceMainPage에서 분기 ✅
```

---

## 🎯 구현 전략: "완전 분리"

### 핵심 원칙

1. **기존 Hourly 파일 수정 최소화** - 분기 로직만 추가
2. **Monthly 전용 폴더/파일 생성** - `/monthly/` 폴더에 격리
3. **공유 가능한 것만 공유** - UI 컴포넌트, 테마, 유틸리티

---

## 📁 파일 구조 계획

### 신규 생성 파일

```
lib/features/attendance/
├── data/
│   ├── datasources/
│   │   └── monthly_attendance_datasource.dart  # ✨ 신규
│   └── models/
│       └── monthly_attendance_model.dart       # ✨ 신규
├── domain/
│   ├── entities/
│   │   └── monthly_attendance.dart             # ✨ 신규
│   └── repositories/
│       └── monthly_attendance_repository.dart  # ✨ 신규 (interface)
├── presentation/
│   ├── providers/
│   │   └── monthly_attendance_providers.dart   # ✨ 신규
│   └── widgets/
│       └── monthly/                            # ✨ 신규 폴더
│           ├── monthly_schedule_tab.dart       # Tab 0 대체
│           ├── monthly_hero_section.dart       # Today's status
│           ├── monthly_calendar.dart           # 월간 캘린더
│           └── monthly_qr_handler.dart         # QR 로직
```

### 수정 파일 (최소한)

```
# 수정 필요
├── attendance_main_page.dart         # 분기 로직 추가
├── qr_scanner_page.dart              # 분기 로직 추가
└── attendance_providers.dart         # salaryType provider 추가

# 수정 불필요 (Hourly 전용, 그대로 유지)
├── my_schedule_tab.dart              ❌ 수정 안 함
├── shift_requests_tab.dart           ❌ 수정 안 함
├── attendance_content.dart           ❌ 수정 안 함
└── 기타 기존 위젯들                   ❌ 수정 안 함
```

---

## 🔄 분기 로직

### 1. AttendanceMainPage 분기

**현재:**
```dart
// attendance_main_page.dart
TabBarView(
  children: [
    MyScheduleTab(...),      // Hourly
    ShiftRequestsTab(...),   // Hourly
    StatsTab(),              // 공통
  ],
)
```

**변경 후:**
```dart
// attendance_main_page.dart
final salaryType = ref.watch(userSalaryTypeProvider);

// Monthly면 탭 2개 (Schedule, Stats)
// Hourly면 탭 3개 (Schedule, Shift Sign Up, Stats)
final isMonthly = salaryType == 'monthly';

TabBarView(
  children: isMonthly
    ? [
        const MonthlyScheduleTab(),  // ✨ 신규
        const StatsTab(),            // 공통 (통계는 별도 구현 또는 공통)
      ]
    : [
        MyScheduleTab(...),          // 기존 Hourly
        ShiftRequestsTab(...),       // 기존 Hourly
        const StatsTab(),            // 공통
      ],
)
```

### 2. QR Scanner 분기

**현재:**
```dart
// qr_scanner_page.dart - onDetect 내부
final shiftRequestId = AttendanceHelpers.findClosestShiftRequestId(shiftCards);
final checkInResult = await checkInShift(...);
```

**변경 후:**
```dart
// qr_scanner_page.dart - onDetect 내부
final salaryType = ref.read(userSalaryTypeProvider);

if (salaryType == 'monthly') {
  // Monthly 로직 - monthly_check_in RPC 호출
  await _processMonthlyCheckIn(storeId);
} else {
  // Hourly 로직 - 기존 코드 그대로
  final shiftRequestId = AttendanceHelpers.findClosestShiftRequestId(shiftCards);
  final checkInResult = await checkInShift(...);
}
```

---

## 📊 Phase별 구현 계획

### Phase 1: Domain Layer (30분)

1. **Entity 생성**
   - `monthly_attendance.dart` - Freezed Entity

2. **Repository Interface**
   - `monthly_attendance_repository.dart`

### Phase 2: Data Layer (45분)

1. **Model 생성**
   - `monthly_attendance_model.dart` - DTO with fromJson

2. **DataSource 생성**
   - `monthly_attendance_datasource.dart` - RPC 호출

3. **Repository 구현**
   - `monthly_attendance_repository_impl.dart`

### Phase 3: Provider Layer (30분)

1. **Providers 생성**
   - `monthly_attendance_providers.dart`
   - `userSalaryTypeProvider` - AppState에서 조회

### Phase 4: Presentation Layer (1.5시간)

1. **MonthlyScheduleTab** (메인)
   - 오늘 출퇴근 상태 표시
   - QR 버튼
   - 월간 캘린더

2. **MonthlyHeroSection**
   - 현재 상태 (checked_in / not_checked_in / completed)
   - 예정 시간 표시
   - 지각/조퇴 표시

3. **MonthlyCalendar**
   - 월간 출석 현황
   - 날짜별 상태 표시 (완료/지각/조퇴/결근)

### Phase 5: QR Integration (30분)

1. **qr_scanner_page.dart 분기 추가**
2. **monthly_qr_handler.dart** - Monthly 전용 처리

### Phase 6: AttendanceMainPage 통합 (30분)

1. **Tab 분기 로직**
2. **Tab 수 동적 변경**

---

## 🔧 상세 구현

### 1. userSalaryTypeProvider

```dart
// attendance_providers.dart에 추가

/// 현재 사용자의 급여 타입 조회
/// Returns: 'monthly' | 'hourly' | null
final userSalaryTypeProvider = FutureProvider.autoDispose<String?>((ref) async {
  final appState = ref.watch(appStateProvider);
  final userId = appState.userId;
  final companyId = appState.companyChoosen;

  if (userId.isEmpty || companyId.isEmpty) return null;

  final supabase = ref.read(supabaseClientProvider);
  final result = await supabase
      .from('user_salaries')
      .select('salary_type')
      .eq('user_id', userId)
      .eq('company_id', companyId)
      .maybeSingle();

  return result?['salary_type'] as String? ?? 'hourly';
});
```

### 2. MonthlyScheduleTab 구조

```dart
class MonthlyScheduleTab extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context) {
    final todayStats = ref.watch(monthlyTodayStatsProvider);
    final monthlyList = ref.watch(monthlyAttendanceListProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. 오늘의 출퇴근 상태
          MonthlyHeroSection(
            todayAttendance: todayStats.today,
            stats: todayStats.stats,
            onCheckIn: () => _navigateToQRScanner(),
            onCheckOut: () => _navigateToQRScanner(),
          ),

          const GrayDividerSpace(),

          // 2. 월간 캘린더
          MonthlyCalendar(
            attendanceList: monthlyList,
            selectedDate: _selectedDate,
            onDateSelected: (date) => setState(() => _selectedDate = date),
          ),

          // 3. 선택된 날짜의 상세 정보
          MonthlyDayDetail(
            attendance: _getAttendanceForDate(_selectedDate),
          ),
        ],
      ),
    );
  }
}
```

### 3. MonthlyHeroSection UI

```
┌─────────────────────────────────────────────┐
│  Thursday, December 28                      │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  Today's Schedule                    │   │
│  │  09:00 - 18:00 (Full-time)          │   │
│  │                                      │   │
│  │  Status: Not Checked In              │   │
│  │                                      │   │
│  │  ┌──────────────────────────────┐   │   │
│  │  │      📱 QR Check-in          │   │   │
│  │  └──────────────────────────────┘   │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  This Month Stats:                          │
│  ✅ Worked: 20 days  ⚠️ Late: 2 days       │
└─────────────────────────────────────────────┘
```

---

## ⚠️ 위험 관리

### 기존 코드 보호

| 파일 | 변경 내용 | 위험도 |
|------|----------|--------|
| `attendance_main_page.dart` | 분기 로직 추가 | 🟡 낮음 |
| `qr_scanner_page.dart` | 분기 로직 추가 | 🟡 낮음 |
| `attendance_providers.dart` | Provider 추가 | 🟢 매우 낮음 |
| `my_schedule_tab.dart` | **변경 없음** | 🟢 없음 |
| `shift_requests_tab.dart` | **변경 없음** | 🟢 없음 |

### 롤백 전략

```dart
// 긴급 시 Monthly 비활성화
final userSalaryTypeProvider = FutureProvider.autoDispose<String?>((ref) async {
  // 긴급 비활성화: 항상 hourly 반환
  // return 'hourly';

  // 정상 로직
  ...
});
```

---

## ✅ 체크리스트

### Phase 1: Domain Layer
- [ ] `monthly_attendance.dart` Entity 생성
- [ ] `monthly_attendance_repository.dart` Interface 생성

### Phase 2: Data Layer
- [ ] `monthly_attendance_model.dart` 생성
- [ ] `monthly_attendance_datasource.dart` 생성
- [ ] Repository 구현

### Phase 3: Provider Layer
- [ ] `monthly_attendance_providers.dart` 생성
- [ ] `userSalaryTypeProvider` 추가

### Phase 4: Presentation Layer
- [ ] `monthly/` 폴더 생성
- [ ] `MonthlyScheduleTab` 생성
- [ ] `MonthlyHeroSection` 생성
- [ ] `MonthlyCalendar` 생성

### Phase 5: QR Integration
- [ ] `qr_scanner_page.dart` 분기 추가
- [ ] Monthly 체크인/체크아웃 처리

### Phase 6: Integration
- [ ] `attendance_main_page.dart` 분기 추가
- [ ] Tab 동적 변경

### Phase 7: Testing
- [ ] Monthly 사용자 체크인 테스트
- [ ] Monthly 사용자 체크아웃 테스트
- [ ] Hourly 사용자 기존 로직 확인
- [ ] 비근무일 체크인 차단 테스트

---

## 📝 승인 요청

위 플랜을 검토해주세요.

**핵심 질문:**
1. Tab 수를 Monthly는 2개, Hourly는 3개로 다르게 할까요? 아니면 Monthly도 3개 탭 유지?
2. StatsTab은 공통으로 사용할까요? (Monthly 통계와 Hourly 통계가 다를 수 있음)
3. Monthly는 시프트 신청(ShiftRequestsTab)이 필요 없는데 맞나요?
