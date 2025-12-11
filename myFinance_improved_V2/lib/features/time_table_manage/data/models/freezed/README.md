# Freezed DTOs - Complete RPC Response Mapping

이 폴더는 **모든 RPC 응답 구조**를 위한 Freezed DTO를 포함합니다.

## 🎯 Freezed 도입 목적

1. **타입 안전성** - dynamic 타입 제거
2. **불변성 보장** - Freezed의 immutable 객체
3. **JSON 자동 직렬화** - `.fromJson()` 자동 생성
4. **RPC 필드명 100% 일치** - `@JsonKey(name:)` 사용
5. **유지보수성** - 서버 변경 시 DTO만 수정

---

## 📋 포함된 DTOs (6개 + 3 nested)

### 🔴 복잡한 RPC 응답 (Priority 1)

#### 1. **ShiftCardDto** ✅
- **RPC:** `manager_shift_get_cards`
- **복잡도:** 🔴 매우 높음 (30+ 필드, nested JSON, 시간 변환)
- **파일:**
  - `shift_card_dto.dart` - DTO 정의 (30+ 필드)
  - `shift_card_dto_mapper.dart` - Entity 변환 + 시간 파싱
  - `shift_card_dto.freezed.dart` - 생성됨 ✅
  - `shift_card_dto.g.dart` - 생성됨 ✅
- **특징:**
  - Custom `@ShiftTimeConverter()` 사용
  - "HH:MM-HH:MM" 문자열 → `ShiftTime` 객체 변환
  - Nested `TagDto` 리스트 포함

#### 2. **MonthlyShiftStatusDto** ✅
- **RPC:** `get_monthly_shift_status_manager`
- **복잡도:** 🟡 높음 (nested arrays, 3-level deep structure)
- **파일:**
  - `monthly_shift_status_dto.dart` - DTO 정의
  - `monthly_shift_status_dto_mapper.dart` - Entity 변환
  - `monthly_shift_status_dto.freezed.dart` - 생성됨 ✅
  - `monthly_shift_status_dto.g.dart` - 생성됨 ✅
- **Nested DTOs:**
  - `ShiftWithEmployeesDto` - 각 shift의 구조
  - `ShiftEmployeeDto` - 각 직원의 정보

#### 3. **CardInputResultDto** ⚠️
- **RPC:** `manager_shift_input_card`
- **복잡도:** 🟡 높음 (flat + nested hybrid structure)
- **파일:**
  - `card_input_result_dto.dart` - DTO 정의
  - `card_input_result_dto_mapper.dart` - Entity 변환
  - `card_input_result_dto.freezed.dart` - 생성됨 ✅
  - `card_input_result_dto.g.dart` - ⚠️ Custom fromJson 사용
- **특징:**
  - RPC가 flat structure로 반환 (shift_data가 root level)
  - Custom `fromJson()` 필요 - ShiftCardDto와 통합
  - 시간 파싱 로직 포함 (HH:mm → DateTime)

---

### 🟢 단순한 RPC 응답 (Priority 2)

#### 4. **ManagerOverviewDto** ✅
- **RPC:** `manager_shift_get_overview`
- **복잡도:** 🟢 낮음 (7개 필드, flat structure)
- **파일:**
  - `manager_overview_dto.dart` - DTO 정의
  - `manager_overview_dto_mapper.dart` - Entity 변환
  - `manager_overview_dto.freezed.dart` - 생성됨 ✅
  - `manager_overview_dto.g.dart` - 생성됨 ✅
- **사용처:** Manager 대시보드 통계

#### 5. **BulkApprovalResultDto** ✅
- **RPC:** `manager_shift_process_bulk_approval`
- **복잡도:** 🟢 낮음 (nested error list)
- **파일:**
  - `bulk_approval_result_dto.dart` - DTO 정의
  - `bulk_approval_result_dto_mapper.dart` - Entity 변환
  - `bulk_approval_result_dto.freezed.dart` - 생성됨 ✅
  - `bulk_approval_result_dto.g.dart` - 생성됨 ✅
- **Nested DTO:**
  - `BulkApprovalErrorDto` - 개별 에러 정보

#### 6. **OperationResultDto** ✅
- **RPC:** Multiple (generic response)
  - `insert_shift_schedule`
  - `manager_shift_delete_tag`
  - `manager_shift_insert_schedule`
  - `insert_shift_schedule_bulk`
  - `manager_shift_add_bonus`
- **복잡도:** 🟢 매우 낮음 (4개 필드)
- **파일:**
  - `operation_result_dto.dart` - DTO 정의
  - `operation_result_dto_mapper.dart` - Entity 변환
  - `operation_result_dto.freezed.dart` - 생성됨 ✅
  - `operation_result_dto.g.dart` - 생성됨 ✅
- **특징:** 범용 success/failure 응답

---

## 🔧 Converters (Custom JSON 변환)

### **ShiftTimeConverter**
- **파일:** `converters/shift_time_converter.dart`
- **목적:** "09:00-17:00" 문자열 → `ShiftTime(startTime, endTime)` 변환
- **사용처:** `shift_card_dto.dart`

```dart
@JsonKey(name: 'shift_time')
@ShiftTimeConverter()
ShiftTime? shiftTime
```

---

## 🔄 RPC → DTO 필드 매핑

### **manager_shift_get_cards** → ShiftCardDto

```json
{
  "request_date": "2025-01-15",           → requestDate
  "shift_request_id": "uuid",             → shiftRequestId
  "user_name": "John Doe",                → userName
  "profile_image": "url",                 → profileImage
  "shift_name": "Morning",                → shiftName
  "shift_time": "09:00-17:00",            → shiftTime (ShiftTimeConverter)
  "is_approved": true,                    → isApproved
  "is_problem": false,                    → isProblem
  "is_problem_solved": false,             → isProblemSolved
  "is_late": false,                       → isLate
  "late_minute": 0,                       → lateMinute
  "is_over_time": false,                  → isOverTime
  "over_time_minute": 0,                  → overTimeMinute
  "paid_hour": 8.0,                       → paidHour
  "salary_type": "hourly",                → salaryType
  "salary_amount": "15,000",              → salaryAmount
  "base_pay": "120,000",                  → basePay
  "bonus_amount": 10000.0,                → bonusAmount
  "total_pay_with_bonus": "130,000",      → totalPayWithBonus
  "actual_start": "09:05:30",             → actualStart
  "actual_end": "17:10:15",               → actualEnd
  "confirm_start_time": "09:00",          → confirmStartTime
  "confirm_end_time": "17:00",            → confirmEndTime
  "notice_tags": [...],                   → noticeTags (List<TagDto>)
  "problem_type": "late",                 → problemType
  "is_reported": false,                   → isReported
  "report_reason": null,                  → reportReason
  "is_valid_checkin_location": true,      → isValidCheckinLocation
  "checkin_distance_from_store": 50.5,    → checkinDistanceFromStore
  "is_valid_checkout_location": true,     → isValidCheckoutLocation
  "checkout_distance_from_store": 45.2,   → checkoutDistanceFromStore
  "store_name": "Main Store"              → storeName
}
```

### **get_monthly_shift_status_manager** → MonthlyShiftStatusDto

```json
{
  "request_date": "2025-01-15",           → requestDate
  "store_id": "uuid",                     → storeId
  "total_required": 10,                   → totalRequired
  "total_approved": 8,                    → totalApproved
  "total_pending": 2,                     → totalPending
  "shifts": [                             → shifts (List<ShiftWithEmployeesDto>)
    {
      "shift_id": "uuid",                 → shiftId
      "shift_name": "Morning",            → shiftName
      "required_employees": 5,            → requiredEmployees
      "approved_count": 4,                → approvedCount
      "pending_count": 1,                 → pendingCount
      "approved_employees": [...],        → approvedEmployees (List<ShiftEmployeeDto>)
      "pending_employees": [...]          → pendingEmployees (List<ShiftEmployeeDto>)
    }
  ]
}
```

### **manager_shift_get_overview** → ManagerOverviewDto

```json
{
  "month": "2025-01",                     → month
  "total_shifts": 150,                    → totalShifts
  "total_approved_requests": 120,         → totalApprovedRequests
  "total_pending_requests": 30,           → totalPendingRequests
  "total_employees": 25,                  → totalEmployees
  "total_estimated_cost": 3500000.0,      → totalEstimatedCost
  "additional_stats": {}                  → additionalStats
}
```

### **manager_shift_process_bulk_approval** → BulkApprovalResultDto

```json
{
  "total_processed": 10,                  → totalProcessed
  "success_count": 8,                     → successCount
  "failure_count": 2,                     → failureCount
  "successful_ids": ["id1", "id2"],       → successfulIds
  "errors": [                             → errors (List<BulkApprovalErrorDto>)
    {
      "shift_request_id": "id3",          → shiftRequestId
      "error_message": "Already approved", → errorMessage
      "error_code": "DUPLICATE"           → errorCode
    }
  ]
}
```

### **manager_shift_input_card** → CardInputResultDto

```json
{
  "shift_request_id": "uuid",             → shiftRequestId
  "confirm_start_time": "09:00",          → confirmStartTime
  "confirm_end_time": "17:00",            → confirmEndTime
  "is_late": false,                       → isLate
  "is_problem_solved": true,              → isProblemSolved
  "new_tag": {...},                       → newTag (TagDto?)
  "request_date": "2025-01-15",           → requestDate
  "message": "Success",                   → message
  // + All ShiftCardDto fields at root level → shiftData
}
```

### **Generic Operations** → OperationResultDto

```json
{
  "success": true,                        → success
  "message": "Operation completed",       → message
  "error_code": null,                     → errorCode
  "metadata": {}                          → metadata
}
```

---

## 📖 사용 예시

### 1. Repository에서 DTO 사용

```dart
// 기존 (dynamic 사용)
Future<Map<String, dynamic>> getManagerOverview() async {
  final response = await supabase.rpc('manager_shift_get_overview');
  return response as Map<String, dynamic>; // ❌ 타입 불안전
}

// Freezed DTO 사용
Future<ManagerOverview> getManagerOverview() async {
  final response = await supabase.rpc('manager_shift_get_overview');
  final dto = ManagerOverviewDto.fromJson(response); // ✅ 타입 안전
  return dto.toEntity(); // DTO → Entity 변환
}
```

### 2. Mapper 체인

```dart
// RPC 응답 → DTO → Entity
final json = await datasource.getManagerShiftCards(...);
final dto = ShiftCardDto.fromJson(json); // JSON → DTO
final entity = dto.toEntity();           // DTO → Entity
```

### 3. 복잡한 Nested 구조

```dart
// MonthlyShiftStatusDto 사용
final statusList = await datasource.getMonthlyShiftStatus(...);
final dtos = statusList.map((json) => MonthlyShiftStatusDto.fromJson(json));
final entities = dtos.map((dto) => dto.toEntity(month: '2025-01'));
```

---

## ⚠️ 알려진 제약사항

### **CardInputResultDto의 Custom fromJson**

- **문제:** RPC가 flat structure로 반환 (shift_data가 root level에 mixed)
- **해결:** Custom `fromJson()` 구현 - `.g.dart` 자동 생성 불가
- **영향:** `build_runner`가 `.g.dart` 파일을 생성하지 않음
- **대응:** Mapper에서 직접 JSON 파싱 처리

---

## 🔄 Migration 가이드 (기존 Model → Freezed DTO)

### Before (기존 Model)
```dart
// data/models/manager_overview_model.dart
class ManagerOverviewModel {
  factory ManagerOverviewModel.fromJson(Map<String, dynamic> json) {
    return ManagerOverviewModel(
      month: json['month'] as String? ?? '',
      // ... 수동 파싱
    );
  }
}
```

### After (Freezed DTO)
```dart
// data/models/freezed/manager_overview_dto.dart
@freezed
class ManagerOverviewDto with _$ManagerOverviewDto {
  const factory ManagerOverviewDto({
    @JsonKey(name: 'month') @Default('') String month,
    // ... 자동 생성
  }) = _ManagerOverviewDto;

  factory ManagerOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$ManagerOverviewDtoFromJson(json); // ✅ 자동 생성됨
}
```

---

## 🎯 Freezed vs 기존 Model 비교

| 항목 | 기존 Model | Freezed DTO |
|------|-----------|-------------|
| **JSON 파싱** | 수동 작성 | 자동 생성 ✅ |
| **불변성** | 수동 구현 | 자동 보장 ✅ |
| **copyWith** | 수동 작성 | 자동 생성 ✅ |
| **toString** | 수동 작성 | 자동 생성 ✅ |
| **==, hashCode** | 수동 작성 | 자동 생성 ✅ |
| **타입 안전성** | dynamic 사용 | 완벽한 타입 ✅ |
| **유지보수** | 모든 필드 수정 | DTO만 수정 ✅ |
| **코드량** | 100줄+ | 30줄 ✅ |

---

## 🚀 build_runner 명령어

```bash
# Freezed 파일 생성
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (자동 재생성)
flutter pub run build_runner watch

# Clean + Build
flutter pub run build_runner clean && flutter pub run build_runner build
```

---

## 📝 네이밍 컨벤션

1. **DTO 파일:** `{domain}_dto.dart` (예: `shift_card_dto.dart`)
2. **Mapper 파일:** `{domain}_dto_mapper.dart`
3. **Nested DTO:** 같은 파일 안에 정의 (예: `TagDto`, `ShiftEmployeeDto`)
4. **JSON Key:** RPC 필드명 100% 일치 (`@JsonKey(name: 'exact_field_name')`)

---

## 🎓 Why Freezed?

### ✅ 장점
1. **타입 안전성** - dynamic 완전 제거
2. **생산성** - 코드 70% 감소
3. **버그 감소** - 불변성 보장
4. **유지보수** - 서버 변경 시 DTO만 수정
5. **성능** - Compile-time 코드 생성 (런타임 오버헤드 없음)

### ⚠️ 단점
1. **빌드 시간** - `build_runner` 실행 필요
2. **학습 곡선** - Freezed 문법 학습 필요
3. **생성 파일** - `.freezed.dart`, `.g.dart` 파일 관리

### 📊 결론
**복잡한 RPC 응답에는 Freezed 필수, 단순한 경우는 선택적**

---

## 🔗 관련 문서

- [Freezed 공식 문서](https://pub.dev/packages/freezed)
- [json_serializable](https://pub.dev/packages/json_serializable)
- [build_runner](https://pub.dev/packages/build_runner)

---

**Last Updated:** 2025-01-10
**Total DTOs:** 6개 + 3 nested
**Supabase RPC Mapping:** 100% ✅
