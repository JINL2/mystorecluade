# Add Shift - Employee Dropdown Empty Issue

**작성일**: 2025-11-07
**상태**: 🔴 진행 중 (미해결)
**우선순위**: High

---

## 1. 문제 (Problem)

### 증상
Add Shift bottom sheet에서 **Employee dropdown을 클릭해도 아무 반응이 없고, 직원 목록이 표시되지 않음**.

<img width="714" alt="add-shift-empty-dropdown" src="https://github.com/user-attachments/assets/..." />

### 재현 방법
1. Time Table Manage 페이지 접속
2. Schedule 탭으로 이동
3. "Add Shift" 버튼 클릭
4. Employee dropdown 클릭
5. **결과**: 드롭다운이 열리지 않음 (리스트가 비어있음)

### 디버깅 로그
```
flutter: 🔍 [Add Shift] Starting to fetch schedule data...
flutter:    Store ID: ce5b0ac5-e8b0-494d-8a77-6ab923fcdb86
flutter:    Calling getScheduleData...
flutter:    ✅ Schedule data received
flutter:    Raw employees count: 0          ⬅️ 문제: 직원 수가 0
flutter:    Raw shifts count: 0             ⬅️ 문제: 시프트 수도 0
flutter:    📋 Final _employees count: 0
flutter:    📋 Final _shifts count: 0

flutter: 👆 [Add Shift] Employee dropdown tapped
flutter:    _employees.length: 0            ⬅️ 드롭다운에 데이터 없음
flutter:    _isSaving: false
flutter:    _isLoading: false
```

---

## 2. 원인 분석 (Root Cause Analysis)

### 2.1 현재 구현 상태

#### 파일: `add_shift_bottom_sheet.dart`
```dart
Future<void> _fetchScheduleData() async {
  // Store ID 가져오기
  final storeId = appState.storeChoosen;  // ✅ 정상: ce5b0ac5-e8b0-494d-8a77-6ab923fcdb86

  // Repository를 통해 RPC 호출
  final scheduleData = await ref.read(timeTableRepositoryProvider).getScheduleData(
    storeId: storeId,
  );

  // 데이터 매핑
  _employees = scheduleData.employees.map((emp) => {
    'user_id': emp.userId,
    'user_name': emp.userName,      // ⚠️ 수정됨: 'full_name' → 'user_name'
    'profile_image': emp.profileImage,
  }).toList();
}
```

#### 파일: `time_table_datasource.dart` (407-435줄)
```dart
Future<Map<String, dynamic>> getScheduleData({
  required String storeId,
}) async {
  final response = await _supabase.rpc<dynamic>(
    'manager_shift_get_schedule',  // ⬅️ 이 RPC 함수 호출
    params: {
      'p_store_id': storeId,
    },
  );

  if (response == null) return {};
  if (response is Map<String, dynamic>) return response;
  return {};
}
```

### 2.2 근본 원인

**RPC 함수 `manager_shift_get_schedule`가 빈 데이터를 반환하고 있음** (employees: 0, shifts: 0)

가능한 원인:
1. ❌ **RPC 함수가 Supabase에 존재하지 않음**
2. ❌ **RPC 함수의 로직에 문제가 있음** (잘못된 쿼리, 잘못된 조인 등)
3. ❌ **해당 store_id에 대한 직원 데이터가 실제로 DB에 없음**
4. ❌ **RPC 함수의 파라미터 이름이 잘못됨** (`p_store_id` vs 다른 이름)

---

## 3. 해결 방안 (Solution Paths)

### 방안 1: RPC 함수 확인 및 수정 (최우선)

#### Step 1: RPC 함수 존재 여부 확인
Supabase Dashboard → Database → Functions에서 `manager_shift_get_schedule` 검색

#### Step 2: RPC 함수가 없는 경우
새로운 RPC 함수를 생성해야 함:

```sql
CREATE OR REPLACE FUNCTION manager_shift_get_schedule(p_store_id UUID)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'employees', COALESCE(
      (SELECT json_agg(json_build_object(
        'user_id', u.user_id,
        'user_name', u.user_name,
        'full_name', u.user_name,  -- 호환성을 위해 둘 다 포함
        'profile_image', u.profile_image
      ))
      FROM user_info u
      INNER JOIN store_members sm ON u.user_id = sm.user_id
      WHERE sm.store_id = p_store_id
        AND sm.status = 'active'), '[]'::json
    ),
    'shifts', COALESCE(
      (SELECT json_agg(json_build_object(
        'shift_id', s.shift_id,
        'shift_name', s.shift_name,
        'start_time', s.start_time,
        'end_time', s.end_time,
        'target_count', s.target_count
      ))
      FROM store_shifts s
      WHERE s.store_id = p_store_id
        AND s.is_active = true), '[]'::json
    )
  ) INTO result;

  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### Step 3: RPC 함수가 있는 경우
함수 로직을 확인하고 디버깅:
- SELECT 문이 올바른지 확인
- JOIN 조건이 맞는지 확인
- WHERE 조건이 데이터를 필터링하고 있지 않은지 확인

### 방안 2: 기존의 다른 RPC 함수 활용

#### Option A: `get_employees_and_shifts` 사용 (이미 존재함)
`time_table_datasource.dart`의 342-371줄에 이미 구현되어 있음:

```dart
Future<Map<String, dynamic>> getAvailableEmployees({
  required String storeId,
  required String shiftDate,  // ⚠️ 날짜 필요
}) async {
  final response = await _supabase.rpc<dynamic>(
    'get_employees_and_shifts',
    params: {
      'p_store_id': storeId,
      'p_shift_date': shiftDate,
    },
  );
  // ...
}
```

**문제점**: 이 함수는 `p_shift_date` 파라미터가 필요함. Add Shift 초기 로딩 시에는 날짜가 선택되지 않았을 수 있음.

**해결**:
- 날짜 파라미터를 optional로 만들기
- 또는 오늘 날짜를 기본값으로 전달

#### Option B: `get_shift_metadata` 활용
`time_table_datasource.dart`의 16-40줄:

```dart
Future<dynamic> getShiftMetadata({
  required String storeId,
}) async {
  final response = await _supabase.rpc<dynamic>(
    'get_shift_metadata',
    params: {
      'p_store_id': storeId,
    },
  );
  // ...
}
```

이 함수는 shifts만 반환하므로, employees는 별도로 가져와야 함.

### 방안 3: 직접 테이블 쿼리 (임시 방편)

RPC 대신 직접 Supabase 테이블 쿼리:

```dart
Future<Map<String, dynamic>> getScheduleData({
  required String storeId,
}) async {
  try {
    // Get employees
    final employeesResponse = await _supabase
        .from('store_members')
        .select('user_id, user_info!inner(user_name, profile_image)')
        .eq('store_id', storeId)
        .eq('status', 'active');

    // Get shifts
    final shiftsResponse = await _supabase
        .from('store_shifts')
        .select('shift_id, shift_name, start_time, end_time, target_count')
        .eq('store_id', storeId)
        .eq('is_active', true);

    return {
      'employees': employeesResponse,
      'shifts': shiftsResponse,
    };
  } catch (e) {
    throw TimeTableException('Failed to fetch schedule data: $e');
  }
}
```

---

## 4. 이미 수정된 부분

### ✅ Fixed: Employee name field mismatch (2025-11-07)

**문제**: Dropdown에서 `employee['full_name']`을 참조했지만, 매핑 시 `user_name`만 저장됨

**수정 전**:
```dart
Text(
  employee['full_name'] ?? 'Unknown',  // ❌ 'full_name' 키 없음
)
```

**수정 후**:
```dart
Text(
  employee['user_name'] ?? 'Unknown',  // ✅ 올바른 키 사용
)
```

**파일**: `add_shift_bottom_sheet.dart:407`

---

## 5. 다음 단계 (Next Steps)

### 즉시 실행할 작업:
1. [ ] Supabase Dashboard에서 `manager_shift_get_schedule` RPC 함수 확인
2. [ ] RPC 함수가 없으면 생성 (위의 SQL 참고)
3. [ ] RPC 함수가 있으면 로직 디버깅:
   - [ ] 함수 정의 확인
   - [ ] 테스트 쿼리 실행
   - [ ] 파라미터 이름 확인 (`p_store_id`)
4. [ ] 데이터베이스에 실제 직원 데이터가 있는지 확인:
   ```sql
   SELECT * FROM store_members
   WHERE store_id = 'ce5b0ac5-e8b0-494d-8a77-6ab923fcdb86'
   AND status = 'active';
   ```

### 대안 접근법:
- [ ] `get_employees_and_shifts` RPC 사용 (날짜 파라미터를 오늘로 설정)
- [ ] 직접 테이블 쿼리로 임시 우회 (방안 3)

---

## 6. 관련 파일

### 프론트엔드
- `lib/features/time_table_manage/presentation/widgets/bottom_sheets/add_shift_bottom_sheet.dart`
  - Line 90-156: `_fetchScheduleData()` 메서드
  - Line 395-455: Employee dropdown 위젯

### 데이터 레이어
- `lib/features/time_table_manage/data/datasources/time_table_datasource.dart`
  - Line 407-435: `getScheduleData()` 메서드
  - Line 342-371: `getAvailableEmployees()` 메서드 (대안)

### 도메인 레이어
- `lib/features/time_table_manage/domain/repositories/time_table_repository.dart`
  - Line 136-143: `getScheduleData()` 인터페이스 정의

### 백엔드 (Supabase)
- RPC Function: `manager_shift_get_schedule` (확인 필요)
- Tables: `store_members`, `user_info`, `store_shifts`

---

## 7. 참고 자료

### 유사한 구현 (레거시 코드)
레거시 코드에서는 Add Shift 기능을 찾을 수 없었음. Schedule 관련 파일도 `lib_old` 폴더에 없음.

### Clean Architecture 흐름
```
Presentation (add_shift_bottom_sheet.dart)
    ↓ timeTableRepositoryProvider.getScheduleData()
Domain (time_table_repository.dart interface)
    ↓
Data (time_table_repository_impl.dart)
    ↓ datasource.getScheduleData()
Data Source (time_table_datasource.dart)
    ↓ Supabase RPC call
Supabase (manager_shift_get_schedule)
```

---

## 8. 체크리스트

작업 완료 시 체크:
- [ ] RPC 함수 존재 확인 완료
- [ ] RPC 함수 로직 검증 완료
- [ ] 테스트 데이터로 RPC 호출 성공
- [ ] Employee list가 정상적으로 표시됨
- [ ] Shift list가 정상적으로 표시됨
- [ ] Add Shift 저장 기능 테스트 완료
- [ ] 디버깅 print 문 제거

---

**마지막 업데이트**: 2025-11-07
**작성자**: Claude Code Session
**다음 담당자**: RPC 함수 확인 및 생성 필요
