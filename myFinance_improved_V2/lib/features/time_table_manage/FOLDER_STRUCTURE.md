# 📁 Time Table Manage - Folder Structure

> **완전한 폴더 구조 문서** - 모든 파일의 역할과 의존성

**최종 업데이트**: 2025-01-11
**총 파일 수**: 157개 (Active: 138, Generated: 38, Docs: 3)

---

## 📊 전체 구조 (Tree View)

```
lib/features/time_table_manage/
│
├── 📄 README.md                          # 메인 가이드 문서
├── 📄 QUICK_START.md                     # 빠른 시작 가이드
├── 📄 FOLDER_STRUCTURE.md                # 이 파일!
├── 📄 DTO_VERIFICATION_REPORT.md         # DTO 검증 보고서
│
├── 📊 data/                              # 데이터 레이어
│   │
│   ├── 🔌 datasources/
│   │   └── time_table_datasource.dart    # Supabase RPC 호출 (568줄)
│   │
│   ├── 📦 models/
│   │   │
│   │   ├── converters/
│   │   │   └── shift_time_converter.dart # UTC ↔ Local 시간 변환
│   │   │
│   │   └── freezed/                      # Freezed DTOs (36 files)
│   │       ├── available_content_dto.dart
│   │       ├── available_content_dto_mapper.dart
│   │       ├── available_employees_data_dto.dart
│   │       ├── available_employees_data_dto_mapper.dart
│   │       ├── bulk_approval_result_dto.dart
│   │       ├── bulk_approval_result_dto_mapper.dart
│   │       ├── card_input_result_dto.dart
│   │       ├── card_input_result_dto_mapper.dart
│   │       ├── employee_info_dto.dart
│   │       ├── employee_info_dto_mapper.dart
│   │       ├── manager_overview_dto.dart
│   │       ├── manager_overview_dto_mapper.dart
│   │       ├── manager_shift_cards_dto.dart
│   │       ├── manager_shift_cards_dto_mapper.dart
│   │       ├── monthly_shift_status_dto.dart
│   │       ├── monthly_shift_status_dto_mapper.dart
│   │       ├── operation_result_dto.dart
│   │       ├── operation_result_dto_mapper.dart
│   │       ├── schedule_data_dto.dart
│   │       ├── schedule_data_dto_mapper.dart
│   │       ├── shift_approval_result_dto.dart
│   │       ├── shift_approval_result_dto_mapper.dart
│   │       ├── shift_card_dto.dart
│   │       ├── shift_card_dto_mapper.dart
│   │       ├── shift_dto.dart
│   │       ├── shift_dto_mapper.dart
│   │       ├── shift_metadata_dto.dart
│   │       ├── shift_metadata_dto_mapper.dart
│   │       ├── shift_request_dto.dart
│   │       ├── shift_request_dto_mapper.dart
│   │       ├── store_cards_dto.dart
│   │       ├── store_cards_dto_mapper.dart
│   │       ├── store_employee_dto.dart
│   │       ├── store_employee_dto_mapper.dart
│   │       ├── store_shift_dto.dart
│   │       ├── store_shift_dto_mapper.dart
│   │       │
│   │       └── *.freezed.dart            # Auto-generated (18 files)
│   │       └── *.g.dart                  # Auto-generated (18 files)
│   │
│   └── 🗄️ repositories/
│       └── time_table_repository_impl.dart  # Repository 구현 (505줄)
│
├── 💼 domain/                            # 도메인 레이어
│   │
│   ├── 📋 entities/                      # 비즈니스 엔티티 (15 files)
│   │   ├── available_employees_data.dart
│   │   ├── bulk_approval_result.dart
│   │   ├── card_input_result.dart
│   │   ├── daily_shift_data.dart
│   │   ├── employee_info.dart
│   │   ├── manager_overview.dart
│   │   ├── manager_shift_cards.dart
│   │   ├── monthly_shift_status.dart
│   │   ├── operation_result.dart
│   │   ├── schedule_data.dart
│   │   ├── shift.dart
│   │   ├── shift_approval_result.dart
│   │   ├── shift_card.dart
│   │   ├── shift_metadata.dart
│   │   ├── shift_metadata_item.dart
│   │   └── shift_request.dart
│   │
│   ├── ⚠️ exceptions/
│   │   └── time_table_exceptions.dart    # 도메인 예외 정의
│   │
│   ├── 🔌 repositories/
│   │   └── time_table_repository.dart    # Repository 인터페이스
│   │
│   ├── ⚙️ usecases/                      # 비즈니스 로직 (16 files)
│   │   ├── base_usecase.dart             # UseCase 베이스
│   │   ├── add_bonus.dart                # 보너스 추가
│   │   ├── create_shift.dart             # 근무 생성
│   │   ├── delete_shift.dart             # 근무 삭제
│   │   ├── delete_shift_tag.dart         # 태그 삭제
│   │   ├── get_available_employees.dart  # 사용 가능 직원 조회
│   │   ├── get_manager_overview.dart     # 관리자 오버뷰
│   │   ├── get_manager_shift_cards.dart  # 관리자 근무 카드
│   │   ├── get_monthly_shift_status.dart # 월별 근무 현황
│   │   ├── get_schedule_data.dart        # 스케줄 데이터
│   │   ├── get_shift_metadata.dart       # 근무 메타데이터
│   │   ├── get_tags_by_card_id.dart      # 카드별 태그 조회
│   │   ├── input_card.dart               # 근무 카드 입력
│   │   ├── insert_schedule.dart          # 스케줄 추가
│   │   ├── process_bulk_approval.dart    # 일괄 승인 처리
│   │   ├── toggle_shift_approval.dart    # 승인 토글
│   │   ├── update_bonus_amount.dart      # 보너스 금액 수정
│   │   └── update_shift.dart             # 근무 수정
│   │
│   └── 💎 value_objects/                 # 값 객체 (5 files)
│       ├── create_shift_params.dart      # 근무 생성 파라미터
│       ├── shift_status.dart             # 근무 상태 enum
│       ├── shift_time_formatter.dart     # 시간 포맷터
│       ├── shift_time_range.dart         # 시간 범위
│       └── tag_input.dart                # 태그 입력 검증
│
└── 🎨 presentation/                      # 프레젠테이션 레이어
    │
    ├── 📱 pages/
    │   └── time_table_manage_page.dart   # 메인 페이지 (574줄)
    │
    ├── 🔄 providers/
    │   │
    │   ├── time_table_providers.dart     # 모든 Provider 정의
    │   │
    │   ├── notifiers/
    │   │   ├── add_shift_form_notifier.dart      # 근무 추가 폼 상태
    │   │   └── shift_details_form_notifier.dart  # 근무 상세 폼 상태
    │   │
    │   └── states/
    │       ├── add_shift_form_state.dart         # 근무 추가 폼 State
    │       ├── shift_details_form_state.dart     # 근무 상세 폼 State
    │       └── time_table_state.dart             # 타임테이블 State
    │
    └── 🎨 widgets/                       # UI 컴포넌트들
        │
        ├── bottom_sheets/                # 바텀시트 (3 files)
        │   ├── add_shift_bottom_sheet.dart       # 근무 추가
        │   ├── employee_selector_sheet.dart      # 직원 선택
        │   └── shift_details_bottom_sheet.dart   # 근무 상세
        │
        ├── calendar/                     # 캘린더 (5 files)
        │   ├── calendar_day_cell.dart            # 날짜 셀
        │   ├── calendar_header.dart              # 캘린더 헤더 (요일)
        │   ├── calendar_month_header.dart        # 월 헤더
        │   ├── shift_calendar_view.dart          # 근무 캘린더 뷰
        │   └── time_table_calendar.dart          # 메인 캘린더
        │
        ├── common/                       # 공통 위젯 (5 files)
        │   ├── animated_tab_bar.dart             # 애니메이션 탭바 ⭐ NEW
        │   ├── shift_status_badge.dart           # 상태 배지
        │   ├── shift_time_display.dart           # 시간 표시
        │   ├── stat_card_widget.dart             # 통계 카드
        │   └── store_selector_card.dart          # 매장 선택 카드
        │
        ├── manage/                       # Manage 탭 (2 files)
        │   ├── manage_shift_card.dart            # 관리용 근무 카드
        │   └── manage_tab_view.dart              # Manage 탭 전체
        │
        ├── overview/                     # 오버뷰 (3 files)
        │   ├── manager_stats_card.dart           # 관리자 통계 카드
        │   ├── overview_tab_view.dart            # 오버뷰 탭
        │   └── shift_summary_section.dart        # 근무 요약 섹션
        │
        ├── schedule/                     # Schedule 탭 (6 files)
        │   ├── daily_shift_card.dart             # 일별 근무 카드
        │   ├── schedule_approve_button.dart      # 승인 버튼
        │   ├── schedule_shift_card.dart          # 스케줄 근무 카드
        │   ├── schedule_shift_data_section.dart  # 근무 데이터 섹션 ⭐ NEW
        │   ├── schedule_tab_content.dart         # Schedule 탭 전체 ⭐ NEW
        │   └── schedule_tab_view.dart            # Schedule 탭 뷰
        │
        └── shift_details/                # 근무 상세 (9 files)
            ├── bonus_management_tab.dart         # 보너스 관리 탭
            ├── confirmed_times_editor.dart       # 확정 시간 편집
            ├── problem_status_section.dart       # 문제 상태 섹션
            ├── shift_detail_row.dart             # 상세 정보 행
            ├── shift_details_tab_bar.dart        # 상세 탭바
            ├── shift_info_tab.dart               # 근무 정보 탭
            ├── shift_section_title.dart          # 섹션 제목
            └── shift_status_pill.dart            # 상태 알약
```

---

## 📈 통계

### 파일 수 통계

| 레이어 | 폴더 | 파일 수 | 비고 |
|--------|------|---------|------|
| **Data** | datasources | 1 | RPC 호출 |
| **Data** | models/converters | 1 | 시간 변환 |
| **Data** | models/freezed | 36 | DTO (18) + Mapper (18) |
| **Data** | repositories | 1 | Repository 구현 |
| **Domain** | entities | 15 | 비즈니스 모델 |
| **Domain** | exceptions | 1 | 예외 정의 |
| **Domain** | repositories | 1 | Repository 인터페이스 |
| **Domain** | usecases | 17 | 비즈니스 로직 (base 포함) |
| **Domain** | value_objects | 5 | 값 객체 |
| **Presentation** | pages | 1 | 메인 페이지 |
| **Presentation** | providers | 6 | Provider 정의 & Notifier |
| **Presentation** | widgets | 30 | UI 컴포넌트 |
| **Auto-Generated** | *.freezed.dart | 20 | Freezed 생성 |
| **Auto-Generated** | *.g.dart | 18 | JSON 직렬화 |
| **Documentation** | *.md | 4 | 문서 |
| **총계** | - | **157** | - |

### 코드 라인 수

| 파일 | 라인 수 | 역할 |
|------|---------|------|
| time_table_datasource.dart | 568 | RPC 호출 |
| time_table_repository_impl.dart | 505 | Repository 구현 |
| time_table_manage_page.dart | 574 | 메인 페이지 |
| time_table_providers.dart | ~400 | Provider 정의 |

---

## 🔗 의존성 그래프

### Data Layer

```
time_table_datasource.dart
    ↓
    Uses: Supabase Client
    ↓
    Called by: time_table_repository_impl.dart
```

### Domain Layer

```
time_table_repository.dart (Interface)
    ↑ implements
    |
time_table_repository_impl.dart (Implementation)
    ↓ uses
    |
time_table_datasource.dart
```

### Presentation Layer

```
time_table_manage_page.dart
    ↓ uses
    |
time_table_providers.dart
    ↓ uses
    |
UseCases (domain/usecases/)
    ↓ uses
    |
Repository (domain/repositories/)
```

---

## 📝 파일별 상세 설명

### Data Layer

#### time_table_datasource.dart (568줄)
**역할**: Supabase RPC 호출
**주요 메서드**:
- `getMonthlyShiftStatus()` - 월별 근무 현황
- `getManagerOverview()` - 관리자 대시보드
- `getManagerShiftCards()` - 관리자 근무 카드
- `processBulkApproval()` - 일괄 승인
- `createShift()` - 근무 생성
- `updateShift()` - 근무 수정
- `deleteShift()` - 근무 삭제
- `toggleShiftApproval()` - 승인 토글
- `getShiftMetadata()` - 근무 메타데이터
- `getAvailableEmployees()` - 사용 가능 직원
- `inputCard()` - 근무 카드 입력
- `addBonus()` - 보너스 추가
- `updateBonusAmount()` - 보너스 수정
- `getScheduleData()` - 스케줄 데이터
- `insertSchedule()` - 스케줄 추가
- `getTagsByCardId()` - 카드별 태그

**의존성**:
- `package:supabase_flutter`
- `time_table_exceptions.dart`

---

#### shift_time_converter.dart
**역할**: UTC ↔ Local 시간 변환
**주요 메서드**:
- `fromJson()` - UTC → Local
- `toJson()` - Local → UTC

**사용처**:
- Freezed DTO의 `@JsonKey(fromJson: ..., toJson: ...)`

---

#### Freezed DTOs (36 files)

**패턴**:
```
{name}_dto.dart           → DTO 정의 (Freezed)
{name}_dto_mapper.dart    → DTO ↔ Entity 변환
{name}_dto.freezed.dart   → Auto-generated
{name}_dto.g.dart         → Auto-generated
```

**DTO 목록**:
1. **available_content_dto** - 사용 가능 컨텐츠
2. **available_employees_data_dto** - 사용 가능 직원 데이터
3. **bulk_approval_result_dto** - 일괄 승인 결과
4. **card_input_result_dto** - 카드 입력 결과
5. **employee_info_dto** - 직원 정보
6. **manager_overview_dto** - 관리자 오버뷰
7. **manager_shift_cards_dto** - 관리자 근무 카드
8. **monthly_shift_status_dto** - 월별 근무 현황
9. **operation_result_dto** - 작업 결과
10. **schedule_data_dto** - 스케줄 데이터
11. **shift_approval_result_dto** - 승인 결과
12. **shift_card_dto** - 근무 카드
13. **shift_dto** - 근무
14. **shift_metadata_dto** - 근무 메타데이터
15. **shift_request_dto** - 근무 요청
16. **store_cards_dto** - 매장 카드
17. **store_employee_dto** - 매장 직원
18. **store_shift_dto** - 매장 근무

**각 DTO의 역할**:
- Supabase RPC 응답을 받아 Dart 객체로 변환
- JSON 직렬화/역직렬화
- Entity로 변환 (Mapper를 통해)

---

#### time_table_repository_impl.dart (505줄)
**역할**: Repository 인터페이스 구현
**패턴**:
```dart
@override
Future<Entity> methodName(...) async {
  final data = await _datasource.rpcMethod(...);
  final dto = Dto.fromJson(data);
  return dto.toEntity();
}
```

**주요 메서드**: Datasource와 1:1 매칭

---

### Domain Layer

#### Entities (15 files)

**역할**: 비즈니스 로직에서 사용하는 순수한 Dart 클래스

**특징**:
- 불변 객체 (immutable)
- 외부 의존성 없음
- 비즈니스 로직 포함 가능

**Entity 목록**:
1. **shift.dart** - 근무 정보
2. **shift_card.dart** - 근무 카드 (직원별)
3. **shift_metadata.dart** - 근무 메타데이터
4. **shift_metadata_item.dart** - 근무 메타데이터 아이템
5. **shift_request.dart** - 근무 요청
6. **employee_info.dart** - 직원 정보
7. **manager_overview.dart** - 관리자 오버뷰
8. **manager_shift_cards.dart** - 관리자 근무 카드
9. **monthly_shift_status.dart** - 월별 근무 현황
10. **daily_shift_data.dart** - 일별 근무 데이터
11. **schedule_data.dart** - 스케줄 데이터
12. **available_employees_data.dart** - 사용 가능 직원
13. **bulk_approval_result.dart** - 일괄 승인 결과
14. **card_input_result.dart** - 카드 입력 결과
15. **operation_result.dart** - 작업 결과
16. **shift_approval_result.dart** - 승인 결과

---

#### time_table_repository.dart
**역할**: Repository 인터페이스 정의
**패턴**:
```dart
abstract class TimeTableRepository {
  Future<Entity> methodName(...);
}
```

**메서드 수**: 16개 (각 RPC와 매칭)

---

#### UseCases (17 files)

**역할**: 비즈니스 로직 실행

**패턴**:
```dart
class GetSomething implements UseCase<ReturnType, ParamsType> {
  final TimeTableRepository _repository;

  GetSomething(this._repository);

  @override
  Future<ReturnType> call(ParamsType params) async {
    return await _repository.getSomething(...);
  }
}
```

**UseCase 목록**:
1. **add_bonus** - 보너스 추가
2. **create_shift** - 근무 생성
3. **delete_shift** - 근무 삭제
4. **delete_shift_tag** - 태그 삭제
5. **get_available_employees** - 사용 가능 직원 조회
6. **get_manager_overview** - 관리자 오버뷰
7. **get_manager_shift_cards** - 관리자 근무 카드
8. **get_monthly_shift_status** - 월별 근무 현황
9. **get_schedule_data** - 스케줄 데이터
10. **get_shift_metadata** - 근무 메타데이터
11. **get_tags_by_card_id** - 카드별 태그
12. **input_card** - 근무 카드 입력
13. **insert_schedule** - 스케줄 추가
14. **process_bulk_approval** - 일괄 승인
15. **toggle_shift_approval** - 승인 토글
16. **update_bonus_amount** - 보너스 금액 수정
17. **update_shift** - 근무 수정

---

#### Value Objects (5 files)

**역할**: 값 객체 (비즈니스 규칙 포함)

1. **create_shift_params.dart**
   - 근무 생성 파라미터
   - 유효성 검증 포함

2. **shift_status.dart**
   - 근무 상태 enum
   - `approved`, `pending`, `problem`

3. **shift_time_formatter.dart**
   - 시간 포맷팅 로직
   - HH:mm 형식 변환

4. **shift_time_range.dart**
   - 시간 범위 검증
   - 시작 < 종료 체크

5. **tag_input.dart**
   - 태그 입력 검증
   - 태그 타입 & 컨텐츠 검증

---

### Presentation Layer

#### time_table_manage_page.dart (574줄)
**역할**: 메인 페이지

**구조**:
```dart
TossScaffold(
  appBar: TossAppBar1(),
  body: SafeArea(
    child: Column([
      AnimatedTabBar(),     // 탭바
      Expanded(
        child: TabBarView([
          ManageTabView(),      // Manage 탭
          ScheduleTabContent(), // Schedule 탭
        ]),
      ),
    ]),
  ),
  floatingActionButton: AiChatFab(),
)
```

**상태**:
- `_tabController` - 탭 컨트롤러
- `selectedDate` - 선택된 날짜
- `focusedMonth` - 포커스된 월
- `selectedStoreId` - 선택된 매장
- `manageSelectedDate` - Manage 탭 날짜
- `selectedFilter` - 필터 (전체/승인/대기/문제)

**메서드**:
- `fetchMonthlyShiftStatus()` - 월별 현황 조회
- `fetchManagerOverview()` - 관리자 오버뷰 조회
- `fetchManagerCards()` - 관리자 카드 조회
- `_showAddShiftBottomSheet()` - 근무 추가 바텀시트
- `_showShiftDetailsBottomSheet()` - 근무 상세 바텀시트
- `_showStoreSelector()` - 매장 선택 바텀시트
- `_handleApprovalSuccess()` - 승인 성공 콜백
- `_getMonthName()` - 월 이름 변환

---

#### time_table_providers.dart (~400줄)
**역할**: 모든 Provider 정의

**Provider 카테고리**:

1. **Repository & Datasource**
   ```dart
   timeTableDatasourceProvider
   timeTableRepositoryProvider
   ```

2. **UseCases (16개)**
   ```dart
   getMonthlyShiftStatusUseCaseProvider
   getManagerOverviewUseCaseProvider
   getManagerShiftCardsUseCaseProvider
   // ... 등등
   ```

3. **UI State**
   ```dart
   selectedDateProvider  // 선택된 날짜
   ```

4. **Data State (Async)**
   ```dart
   shiftMetadataProvider           // FutureProvider
   monthlyShiftStatusProvider      // FutureProvider.family
   managerOverviewProvider         // FutureProvider.autoDispose.family
   managerCardsProvider            // AsyncNotifierProvider.autoDispose.family
   ```

5. **Form State (StateNotifier)**
   ```dart
   addShiftFormProvider            // StateNotifierProvider
   shiftDetailsFormProvider        // StateNotifierProvider
   selectedShiftRequestsProvider   // StateNotifierProvider
   ```

---

#### Widgets (30 files)

##### Bottom Sheets (3 files)

1. **add_shift_bottom_sheet.dart**
   - 역할: 새 근무 추가
   - 상태: `AddShiftFormNotifier`
   - 필드: 근무명, 시작/종료 시간, 직원 선택

2. **shift_details_bottom_sheet.dart**
   - 역할: 근무 상세 정보 & 수정
   - 상태: `ShiftDetailsFormNotifier`
   - 탭: 근무 정보, 보너스 관리

3. **employee_selector_sheet.dart**
   - 역할: 직원 선택
   - 기능: 검색, 필터링, 다중 선택

---

##### Calendar (5 files)

1. **time_table_calendar.dart**
   - 역할: 메인 캘린더
   - 기능: 날짜 선택, 월 변경, 근무 상태 표시

2. **calendar_day_cell.dart**
   - 역할: 날짜 셀
   - 상태 표시: 선택됨, 오늘, 근무 있음

3. **calendar_header.dart**
   - 역할: 요일 헤더 (일~토)

4. **calendar_month_header.dart**
   - 역할: 월 헤더 (이전/다음 버튼)

5. **shift_calendar_view.dart**
   - 역할: 근무 캘린더 뷰

---

##### Common (5 files)

1. **animated_tab_bar.dart** ⭐ NEW
   - 역할: 애니메이션 탭바
   - 기능: 애니메이션 인디케이터, 햅틱 피드백
   - 재사용 가능

2. **store_selector_card.dart**
   - 역할: 매장 선택 카드
   - 표시: 매장명, 드롭다운 아이콘

3. **shift_time_display.dart**
   - 역할: 시간 표시 위젯
   - 형식: HH:mm ~ HH:mm

4. **shift_status_badge.dart**
   - 역할: 상태 배지
   - 종류: 승인 (초록), 대기 (주황), 문제 (빨강)

5. **stat_card_widget.dart**
   - 역할: 통계 카드
   - 표시: 라벨, 값, 아이콘

---

##### Manage (2 files)

1. **manage_tab_view.dart**
   - 역할: Manage 탭 전체
   - 구성: 통계 카드, 날짜 선택, 필터, 근무 카드 목록

2. **manage_shift_card.dart**
   - 역할: 관리용 근무 카드
   - 표시: 직원명, 시간, 상태, 보너스, 태그
   - 액션: 탭하여 상세 보기

---

##### Schedule (6 files)

1. **schedule_tab_content.dart** ⭐ NEW
   - 역할: Schedule 탭 전체
   - 구성: 매장 선택, 캘린더, 근무 목록, FAB

2. **schedule_shift_data_section.dart** ⭐ NEW
   - 역할: 근무 데이터 섹션
   - 표시: 근무 목록 (근무별)

3. **schedule_shift_card.dart**
   - 역할: 스케줄용 근무 카드
   - 표시: 근무명, 시간, 배정 직원
   - 액션: 직원 탭하여 선택/해제

4. **schedule_approve_button.dart**
   - 역할: 일괄 승인 버튼
   - 기능: 선택된 근무 일괄 승인/거부

5. **schedule_tab_view.dart**
   - 역할: Schedule 탭 뷰 (레거시)

6. **daily_shift_card.dart**
   - 역할: 일별 근무 카드

---

##### Shift Details (9 files)

1. **shift_info_tab.dart**
   - 역할: 근무 정보 탭
   - 표시: 직원명, 시간, 태그 등

2. **bonus_management_tab.dart**
   - 역할: 보너스 관리 탭
   - 기능: 보너스 추가, 수정, 삭제

3. **confirmed_times_editor.dart**
   - 역할: 확정 시간 편집
   - 기능: 실제 근무 시간 입력

4. **problem_status_section.dart**
   - 역할: 문제 상태 섹션
   - 표시: 문제 유형, 설명

5. **shift_detail_row.dart**
   - 역할: 상세 정보 행
   - 패턴: 라벨 + 값

6. **shift_details_tab_bar.dart**
   - 역할: 상세 탭바
   - 탭: 근무 정보, 보너스 관리

7. **shift_section_title.dart**
   - 역할: 섹션 제목

8. **shift_status_pill.dart**
   - 역할: 상태 알약 (작은 배지)

9. (기타 상세 위젯)

---

##### Overview (3 files)

1. **manager_stats_card.dart**
   - 역할: 관리자 통계 카드
   - 표시: 총 근무, 승인, 대기, 문제

2. **overview_tab_view.dart**
   - 역할: 오버뷰 탭

3. **shift_summary_section.dart**
   - 역할: 근무 요약 섹션

---

## 🔄 데이터 흐름도

### 읽기 (Read) 흐름

```
[UI Component]
    ↓ watch
[Provider]
    ↓ call
[UseCase]
    ↓ call
[Repository Interface]
    ↑ implements
    ↓
[Repository Implementation]
    ↓ call
[Datasource]
    ↓ RPC
[Supabase]
    ↓ response (JSON)
[DTO.fromJson()]
    ↓ toEntity()
[Entity]
    ↓ return
[Provider]
    ↓ rebuild
[UI Component]
```

### 쓰기 (Write) 흐름

```
[UI Event (Button Tap)]
    ↓
[Event Handler]
    ↓ read
[UseCase Provider]
    ↓ call
[UseCase]
    ↓ call
[Repository]
    ↓ call
[Datasource]
    ↓ RPC
[Supabase]
    ↓ response
[Success/Error]
    ↓ update
[State Provider]
    ↓ rebuild
[UI Component]
```

---

## 📊 의존성 매트릭스

| From → To | Data | Domain | Presentation |
|-----------|------|--------|--------------|
| **Data** | ✅ | ✅ | ❌ |
| **Domain** | ❌ | ✅ | ❌ |
| **Presentation** | ❌ | ✅ | ✅ |

**규칙**:
- Data는 Domain에만 의존
- Domain은 독립적 (의존 없음)
- Presentation은 Domain에만 의존

---

## 🎯 네이밍 규칙

### 파일명
```
{purpose}_{type}.dart

예시:
- shift_card_dto.dart          (DTO)
- shift_card.dart              (Entity)
- get_monthly_shift_status.dart (UseCase)
- schedule_shift_card.dart     (Widget)
```

### 클래스명
```
{Name}{Suffix}

예시:
- ShiftCardDto                 (DTO)
- ShiftCard                    (Entity)
- GetMonthlyShiftStatus        (UseCase)
- ScheduleShiftCard            (Widget)
```

### Provider명
```
{name}{Type}Provider

예시:
- timeTableRepositoryProvider  (Repository)
- getMonthlyShiftStatusUseCaseProvider (UseCase)
- shiftMetadataProvider        (Data)
- addShiftFormProvider         (Form State)
```

---

## 🔍 빠른 검색

### "근무 승인 기능을 수정하고 싶어요"
```
1. UseCase: domain/usecases/toggle_shift_approval.dart
2. Datasource: data/datasources/time_table_datasource.dart → toggleShiftApproval()
3. UI: presentation/widgets/schedule/schedule_approve_button.dart
```

### "캘린더 UI를 바꾸고 싶어요"
```
1. Main: presentation/widgets/calendar/time_table_calendar.dart
2. Cell: presentation/widgets/calendar/calendar_day_cell.dart
3. Header: presentation/widgets/calendar/calendar_month_header.dart
```

### "새로운 RPC를 추가하고 싶어요"
```
1. DTO: data/models/freezed/my_new_data_dto.dart
2. Mapper: data/models/freezed/my_new_data_dto_mapper.dart
3. Entity: domain/entities/my_new_data.dart
4. Datasource: data/datasources/time_table_datasource.dart → myNewRpc()
5. Repository Interface: domain/repositories/time_table_repository.dart
6. Repository Impl: data/repositories/time_table_repository_impl.dart
7. UseCase: domain/usecases/get_my_new_data.dart
8. Provider: presentation/providers/time_table_providers.dart
```

---

## 📚 관련 문서

- **[README.md](README.md)** - 완전한 개발 가이드
- **[QUICK_START.md](QUICK_START.md)** - 5분 빠른 시작
- **[DTO_VERIFICATION_REPORT.md](DTO_VERIFICATION_REPORT.md)** - DTO 검증 보고서

---

**마지막 업데이트**: 2025-01-11
**작성자**: Flutter 개발자
**버전**: 2.0 (Refactored)
