# Monthly 직원 출퇴근 시스템 명세서 V2

> **작성일:** 2025-12-28
> **버전:** 2.0
> **상태:** 검증 완료, 구현 대기

---

## 📋 개요

Monthly(월급제) 직원의 출퇴근 기록 시스템. **Hourly와 완전 분리**된 구조.

### 핵심 원칙

1. **완전 분리**: Hourly(`shift_requests`) / Monthly(`monthly_attendance`) 별도 테이블
2. **단순화**: Monthly는 시급 계산 불필요 → 출퇴근 시간만 기록
3. **동적 Timezone**: `companies.timezone` 조회하여 로컬 시간 계산
4. **간단한 RLS**: company 멤버면 조회 가능

---

## 🔄 아키텍처 다이어그램

```
┌──────────────────────────────────────────────────────────────┐
│                    AttendanceMainPage                        │
│                          │                                   │
│     ┌────────────────────┴────────────────────┐              │
│     │                                         │              │
│     ▼                                         ▼              │
│ salaryType == 'hourly'              salaryType == 'monthly'  │
│     │                                         │              │
│     ▼                                         ▼              │
│ ┌─────────────────────┐           ┌─────────────────────┐   │
│ │ AttendanceContent   │           │ MonthlyAttendance   │   │
│ │ (기존 위젯)          │           │ Content (신규 위젯) │   │
│ └─────────────────────┘           └─────────────────────┘   │
│           │                                 │                │
│           ▼                                 ▼                │
│ ┌─────────────────────┐           ┌─────────────────────┐   │
│ │  shift_requests     │           │ monthly_attendance  │   │
│ │  (기존 테이블)       │           │  (신규 테이블)       │   │
│ └─────────────────────┘           └─────────────────────┘   │
│           │                                 │                │
│           ▼                                 ▼                │
│ • update_shift_requests_v8()      • monthly_check_in()      │
│ • user_shift_cards_v7()           • monthly_check_out()     │
│ • huddle/payment 계산             • get_monthly_attendance_ │
│                                     stats/list              │
└──────────────────────────────────────────────────────────────┘
```

---

## 🆚 Hourly vs Monthly 비교

| 항목 | Hourly | Monthly |
|------|--------|---------|
| **테이블** | `shift_requests` | `monthly_attendance` |
| **급여 계산** | 시간 × 시급 | 고정 월급 |
| **Overtime 금액** | `huddle_time` / `payment_time` 으로 계산 | ❌ 불필요 |
| **지각/조퇴** | 분 단위 금액 차감 | Boolean만 (참고용) |
| **필요한 데이터** | 정확한 분 단위 계산 | 출근/퇴근 시간만 |
| **스케줄 기준** | `store_shifts` (시프트) | `work_schedule_templates` (템플릿) |

---

## 🗄️ 테이블 구조

### 1. monthly_attendance (단순화 버전)

```sql
CREATE TABLE monthly_attendance (
  attendance_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- 관계
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  company_id UUID NOT NULL REFERENCES companies(company_id) ON DELETE CASCADE,
  store_id UUID REFERENCES stores(store_id) ON DELETE SET NULL,
  work_schedule_template_id UUID REFERENCES work_schedule_templates(template_id) ON DELETE SET NULL,

  -- 날짜 (로컬 기준, 하루에 1개 레코드)
  attendance_date DATE NOT NULL,

  -- 예정 시간 (템플릿에서 복사, 로컬 TIME)
  scheduled_start_time TIME,  -- 09:00
  scheduled_end_time TIME,    -- 18:00

  -- 실제 출퇴근 시간 (UTC)
  check_in_time_utc TIMESTAMPTZ,
  check_out_time_utc TIMESTAMPTZ,

  -- 상태
  status TEXT NOT NULL DEFAULT 'scheduled'
    CHECK (status IN ('scheduled', 'checked_in', 'completed', 'absent', 'day_off')),

  -- 문제 플래그 (참고용, 금액 계산 없음)
  is_late BOOLEAN DEFAULT false,
  is_early_leave BOOLEAN DEFAULT false,

  -- 메타데이터
  notes TEXT,
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW(),

  -- 유니크 제약 (하루에 한 출근 기록)
  UNIQUE(user_id, company_id, attendance_date)
);
```

#### 컬럼 설명

| 컬럼명 | 타입 | 필수 | 설명 |
|--------|------|------|------|
| attendance_id | UUID | ✅ | PK |
| user_id | UUID | ✅ | 직원 FK (`auth.users`) |
| company_id | UUID | ✅ | 회사 FK |
| store_id | UUID | - | QR 스캔한 매장 |
| work_schedule_template_id | UUID | - | 적용된 템플릿 |
| attendance_date | DATE | ✅ | 출근 날짜 (로컬) |
| scheduled_start_time | TIME | - | 예정 출근 시간 (로컬) |
| scheduled_end_time | TIME | - | 예정 퇴근 시간 (로컬) |
| check_in_time_utc | TIMESTAMPTZ | - | 실제 출근 시간 (UTC) |
| check_out_time_utc | TIMESTAMPTZ | - | 실제 퇴근 시간 (UTC) |
| status | TEXT | ✅ | 상태 (아래 참조) |
| is_late | BOOLEAN | - | 지각 여부 (참고용) |
| is_early_leave | BOOLEAN | - | 조퇴 여부 (참고용) |
| notes | TEXT | - | 메모 |

#### Status 값

| 값 | 설명 |
|----|------|
| `scheduled` | 예정됨 (아직 출근 안함) |
| `checked_in` | 출근 완료 (퇴근 안함) |
| `completed` | 출퇴근 모두 완료 |
| `absent` | 결근 |
| `day_off` | 휴무일 |

---

### 2. work_schedule_templates (기존 - 변경 없음)

```sql
CREATE TABLE work_schedule_templates (
  template_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),
  template_name TEXT NOT NULL,
  work_start_time TIME NOT NULL DEFAULT '09:00',
  work_end_time TIME NOT NULL DEFAULT '18:00',
  monday BOOLEAN NOT NULL DEFAULT true,
  tuesday BOOLEAN NOT NULL DEFAULT true,
  wednesday BOOLEAN NOT NULL DEFAULT true,
  thursday BOOLEAN NOT NULL DEFAULT true,
  friday BOOLEAN NOT NULL DEFAULT true,
  saturday BOOLEAN NOT NULL DEFAULT false,
  sunday BOOLEAN NOT NULL DEFAULT false,
  is_default BOOLEAN NOT NULL DEFAULT false,
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(company_id, template_name)
);
```

---

### 3. 관련 테이블 참조

#### companies.timezone

```sql
-- 이미 존재
timezone VARCHAR DEFAULT 'Asia/Ho_Chi_Minh'
```

#### user_salaries.work_schedule_template_id

```sql
-- 이미 존재
work_schedule_template_id UUID REFERENCES work_schedule_templates(template_id)
```

---

## 🔐 RLS 정책

### monthly_attendance

```sql
-- 기존 정책 삭제 후 재생성
ALTER TABLE monthly_attendance ENABLE ROW LEVEL SECURITY;

-- 1. 본인 조회
CREATE POLICY "Users can view own monthly_attendance"
  ON monthly_attendance FOR SELECT
  USING (user_id = auth.uid());

-- 2. 본인 삽입
CREATE POLICY "Users can insert own monthly_attendance"
  ON monthly_attendance FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- 3. 본인 수정
CREATE POLICY "Users can update own monthly_attendance"
  ON monthly_attendance FOR UPDATE
  USING (user_id = auth.uid());

-- 4. 같은 회사 멤버 조회 (company_id 기반)
CREATE POLICY "Company members can view monthly_attendance"
  ON monthly_attendance FOR SELECT
  USING (
    company_id IN (
      SELECT uc.company_id
      FROM user_companies uc
      WHERE uc.user_id = auth.uid()
    )
  );
```

---

## 🔧 RPC 함수

### RPC 1: monthly_check_in (수정 필요)

**Monthly 직원 출근 체크인**

#### 호출

```dart
final result = await supabase.rpc('monthly_check_in', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
  'p_store_id': storeId,  // optional, QR 스캔한 매장
});
```

#### 수정된 로직

```sql
CREATE OR REPLACE FUNCTION monthly_check_in(
  p_user_id UUID,
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_template RECORD;
  v_company_timezone TEXT;
  v_today DATE;
  v_now_utc TIMESTAMPTZ;
  v_is_workday BOOLEAN;
  v_day_of_week INTEGER;
  v_existing RECORD;
  v_is_late BOOLEAN := false;
  v_result RECORD;
  v_scheduled_start TIMESTAMPTZ;
BEGIN
  v_now_utc := NOW();

  -- 1. 회사 timezone 조회
  SELECT timezone INTO v_company_timezone
  FROM companies WHERE company_id = p_company_id;
  v_company_timezone := COALESCE(v_company_timezone, 'UTC');

  -- 2. 로컬 날짜 계산
  v_today := (v_now_utc AT TIME ZONE v_company_timezone)::DATE;
  v_day_of_week := EXTRACT(DOW FROM v_today);  -- 0=Sunday, 1=Monday, ...

  -- 3. 템플릿 조회
  SELECT wst.* INTO v_template
  FROM user_salaries us
  JOIN work_schedule_templates wst ON us.work_schedule_template_id = wst.template_id
  WHERE us.user_id = p_user_id
    AND us.company_id = p_company_id
    AND us.salary_type = 'monthly';

  IF v_template IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'NO_TEMPLATE',
      'message', 'Monthly 직원이 아니거나 근무 스케줄 템플릿이 없습니다.'
    );
  END IF;

  -- 4. 오늘이 근무일인지 확인
  v_is_workday := CASE v_day_of_week
    WHEN 0 THEN v_template.sunday
    WHEN 1 THEN v_template.monday
    WHEN 2 THEN v_template.tuesday
    WHEN 3 THEN v_template.wednesday
    WHEN 4 THEN v_template.thursday
    WHEN 5 THEN v_template.friday
    WHEN 6 THEN v_template.saturday
  END;

  IF NOT v_is_workday THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'NOT_WORKDAY',
      'message', '오늘은 근무일이 아닙니다.',
      'template_name', v_template.template_name
    );
  END IF;

  -- 5. 이미 체크인했는지 확인
  SELECT * INTO v_existing
  FROM monthly_attendance
  WHERE user_id = p_user_id
    AND company_id = p_company_id
    AND attendance_date = v_today;

  IF v_existing IS NOT NULL AND v_existing.status IN ('checked_in', 'completed') THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'ALREADY_CHECKED_IN',
      'message', '이미 출근 체크인을 했습니다.',
      'check_in_time', v_existing.check_in_time_utc
    );
  END IF;

  -- 6. 지각 여부 판정 (Boolean만)
  v_scheduled_start := (v_today || ' ' || v_template.work_start_time)::TIMESTAMP
                       AT TIME ZONE v_company_timezone;

  IF v_now_utc > v_scheduled_start THEN
    v_is_late := true;
  END IF;

  -- 7. INSERT 또는 UPDATE
  INSERT INTO monthly_attendance (
    user_id,
    company_id,
    store_id,
    work_schedule_template_id,
    attendance_date,
    scheduled_start_time,
    scheduled_end_time,
    check_in_time_utc,
    status,
    is_late
  ) VALUES (
    p_user_id,
    p_company_id,
    p_store_id,
    v_template.template_id,
    v_today,
    v_template.work_start_time,
    v_template.work_end_time,
    v_now_utc,
    'checked_in',
    v_is_late
  )
  ON CONFLICT (user_id, company_id, attendance_date)
  DO UPDATE SET
    check_in_time_utc = v_now_utc,
    status = 'checked_in',
    is_late = v_is_late,
    updated_at_utc = NOW()
  RETURNING * INTO v_result;

  RETURN jsonb_build_object(
    'success', true,
    'data', jsonb_build_object(
      'attendance_id', v_result.attendance_id,
      'attendance_date', v_result.attendance_date,
      'check_in_time_utc', v_result.check_in_time_utc,
      'scheduled_start_time', v_result.scheduled_start_time,
      'scheduled_end_time', v_result.scheduled_end_time,
      'is_late', v_result.is_late,
      'template_name', v_template.template_name
    )
  );
END;
$$;
```

#### Response (성공)

```json
{
  "success": true,
  "data": {
    "attendance_id": "uuid",
    "attendance_date": "2025-12-28",
    "check_in_time_utc": "2025-12-28T01:00:00+00:00",
    "scheduled_start_time": "09:00:00",
    "scheduled_end_time": "18:00:00",
    "is_late": true,
    "template_name": "Full-time"
  }
}
```

#### Response (에러)

```json
// 템플릿 없음
{"success": false, "error": "NO_TEMPLATE", "message": "..."}

// 비근무일
{"success": false, "error": "NOT_WORKDAY", "message": "오늘은 근무일이 아닙니다.", "template_name": "Full-time"}

// 이미 체크인
{"success": false, "error": "ALREADY_CHECKED_IN", "message": "...", "check_in_time": "..."}
```

---

### RPC 2: monthly_check_out (수정 필요)

**Monthly 직원 퇴근 체크아웃**

#### 호출

```dart
final result = await supabase.rpc('monthly_check_out', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
});
```

#### 수정된 로직

```sql
CREATE OR REPLACE FUNCTION monthly_check_out(
  p_user_id UUID,
  p_company_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_company_timezone TEXT;
  v_today DATE;
  v_now_utc TIMESTAMPTZ;
  v_attendance RECORD;
  v_scheduled_end TIMESTAMPTZ;
  v_is_early_leave BOOLEAN := false;
  v_result RECORD;
BEGIN
  v_now_utc := NOW();

  -- 1. 회사 timezone 조회
  SELECT timezone INTO v_company_timezone
  FROM companies WHERE company_id = p_company_id;
  v_company_timezone := COALESCE(v_company_timezone, 'UTC');

  v_today := (v_now_utc AT TIME ZONE v_company_timezone)::DATE;

  -- 2. 오늘 체크인 기록 조회
  SELECT * INTO v_attendance
  FROM monthly_attendance
  WHERE user_id = p_user_id
    AND company_id = p_company_id
    AND attendance_date = v_today
    AND status = 'checked_in';

  IF v_attendance IS NULL THEN
    -- 체크인 안 했거나 이미 체크아웃 완료
    SELECT * INTO v_attendance
    FROM monthly_attendance
    WHERE user_id = p_user_id
      AND company_id = p_company_id
      AND attendance_date = v_today;

    IF v_attendance IS NULL THEN
      RETURN jsonb_build_object(
        'success', false,
        'error', 'NOT_CHECKED_IN',
        'message', '오늘 출근 체크인 기록이 없습니다.'
      );
    ELSIF v_attendance.status = 'completed' THEN
      RETURN jsonb_build_object(
        'success', false,
        'error', 'ALREADY_CHECKED_OUT',
        'message', '이미 퇴근 체크아웃을 했습니다.',
        'check_out_time', v_attendance.check_out_time_utc
      );
    END IF;
  END IF;

  -- 3. 조퇴 여부 판정 (Boolean만)
  v_scheduled_end := (v_today || ' ' || v_attendance.scheduled_end_time)::TIMESTAMP
                     AT TIME ZONE v_company_timezone;

  IF v_now_utc < v_scheduled_end THEN
    v_is_early_leave := true;
  END IF;

  -- 4. UPDATE
  UPDATE monthly_attendance
  SET
    check_out_time_utc = v_now_utc,
    status = 'completed',
    is_early_leave = v_is_early_leave,
    updated_at_utc = NOW()
  WHERE attendance_id = v_attendance.attendance_id
  RETURNING * INTO v_result;

  RETURN jsonb_build_object(
    'success', true,
    'data', jsonb_build_object(
      'attendance_id', v_result.attendance_id,
      'attendance_date', v_result.attendance_date,
      'check_in_time_utc', v_result.check_in_time_utc,
      'check_out_time_utc', v_result.check_out_time_utc,
      'is_late', v_result.is_late,
      'is_early_leave', v_result.is_early_leave
    )
  );
END;
$$;
```

#### Response (성공)

```json
{
  "success": true,
  "data": {
    "attendance_id": "uuid",
    "attendance_date": "2025-12-28",
    "check_in_time_utc": "2025-12-28T01:00:00+00:00",
    "check_out_time_utc": "2025-12-28T10:00:00+00:00",
    "is_late": false,
    "is_early_leave": false
  }
}
```

---

### RPC 3: get_monthly_attendance_stats (수정 필요)

**월간 출석 통계**

#### 호출

```dart
final result = await supabase.rpc('get_monthly_attendance_stats', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
  'p_year': 2025,      // optional
  'p_month': 12,       // optional
});
```

#### Response

```json
{
  "success": true,
  "period": {
    "year": 2025,
    "month": 12,
    "start_date": "2025-12-01",
    "end_date": "2025-12-31"
  },
  "today": {
    "attendance_id": "uuid",
    "status": "checked_in",
    "check_in_time_utc": "...",
    "check_out_time_utc": null,
    "scheduled_start_time": "09:00:00",
    "scheduled_end_time": "18:00:00",
    "is_late": false,
    "is_early_leave": false
  },
  "stats": {
    "completed_days": 20,
    "worked_days": 21,
    "absent_days": 1,
    "late_days": 3,
    "early_leave_days": 2
  }
}
```

---

### RPC 4: get_monthly_attendance_list (수정 필요)

**월간 출석 목록 (캘린더용)**

#### 호출

```dart
final result = await supabase.rpc('get_monthly_attendance_list', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
  'p_year': 2025,
  'p_month': 12,
});
```

#### Response

```json
{
  "success": true,
  "period": {...},
  "count": 22,
  "data": [
    {
      "attendance_id": "uuid",
      "attendance_date": "2025-12-28",
      "day_of_week": 6,
      "scheduled_start_time": "09:00:00",
      "scheduled_end_time": "18:00:00",
      "check_in_time_utc": "...",
      "check_out_time_utc": "...",
      "status": "completed",
      "is_late": false,
      "is_early_leave": false,
      "notes": null
    }
  ]
}
```

---

## 📱 Flutter 구현 가이드

### 1. 파일 구조

```
lib/features/attendance/
├── data/
│   ├── datasources/
│   │   ├── attendance_remote_datasource.dart      # 기존 (Hourly)
│   │   └── monthly_attendance_datasource.dart     # 신규 (Monthly)
│   └── models/
│       └── monthly_attendance_model.dart          # 신규
├── domain/
│   ├── entities/
│   │   └── monthly_attendance.dart                # 신규
│   └── repositories/
│       └── monthly_attendance_repository.dart     # 신규
└── presentation/
    ├── pages/
    │   └── attendance_main_page.dart              # 분기 로직 추가
    └── widgets/
        ├── check_in_out/                          # 기존 (Hourly)
        └── monthly/                               # 신규 (Monthly)
            ├── monthly_attendance_content.dart
            ├── monthly_hero_section.dart
            └── monthly_calendar.dart
```

### 2. 분기 로직

```dart
// attendance_main_page.dart
class AttendanceMainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final salaryType = _getSalaryType(ref);  // user_salaries에서 조회

    return TossScaffold(
      appBar: TossAppBar1(title: 'My Attendance'),
      body: salaryType == 'monthly'
          ? const MonthlyAttendanceContent()  // 신규 위젯
          : const AttendanceContent(),        // 기존 위젯 (Hourly)
    );
  }
}
```

### 3. Monthly Entity

```dart
@freezed
class MonthlyAttendance with _$MonthlyAttendance {
  const factory MonthlyAttendance({
    required String attendanceId,
    required String userId,
    required String companyId,
    String? storeId,
    String? workScheduleTemplateId,
    required DateTime attendanceDate,
    String? scheduledStartTime,  // "09:00:00"
    String? scheduledEndTime,    // "18:00:00"
    DateTime? checkInTimeUtc,
    DateTime? checkOutTimeUtc,
    required String status,  // scheduled/checked_in/completed/absent/day_off
    @Default(false) bool isLate,
    @Default(false) bool isEarlyLeave,
    String? notes,
  }) = _MonthlyAttendance;
}
```

---

## 🔁 QR 체크인 플로우

### Monthly 체크인 시퀀스

```
1. QR 스캔 → store_id 획득
   ↓
2. AppState에서 salaryType 확인
   ↓
3. salaryType == 'monthly'?
   ├── YES → monthly_check_in RPC 호출
   │         ↓
   │         ├── 성공 → "출근 완료" 표시
   │         ├── NOT_WORKDAY → "오늘은 근무일이 아닙니다" 알림
   │         ├── ALREADY_CHECKED_IN → "이미 출근했습니다" 알림
   │         └── NO_TEMPLATE → "템플릿을 먼저 설정하세요" 알림
   │
   └── NO (hourly) → 기존 update_shift_requests_v8 로직
```

### QR Handler 분기

```dart
// qr_scanner_page.dart 수정
Future<void> _processQRCode(String storeId) async {
  final salaryType = await _getSalaryType();

  if (salaryType == 'monthly') {
    await _processMonthlyCheckIn(storeId);
  } else {
    await _processHourlyCheckIn(storeId);  // 기존 로직
  }
}

Future<void> _processMonthlyCheckIn(String storeId) async {
  final result = await supabase.rpc('monthly_check_in', params: {
    'p_user_id': userId,
    'p_company_id': companyId,
    'p_store_id': storeId,
  });

  if (result['success'] == true) {
    _showSuccessDialog(result['data']['is_late']
        ? 'Check-in Complete (Late)'
        : 'Check-in Complete');
  } else {
    _showErrorDialog(result['message']);
  }
}
```

---

## 📊 데이터 예시

### work_schedule_templates

| template_name | work_start_time | work_end_time | 근무요일 | is_default |
|---------------|-----------------|---------------|----------|------------|
| Full-time | 09:00 | 18:00 | 월~금 | ✅ |
| Part-time Morning | 09:00 | 13:00 | 월~금 | |
| Manager | 08:00 | 17:00 | 월~토 | |

### monthly_attendance

| user | date | scheduled | check_in | check_out | status | is_late | is_early |
|------|------|-----------|----------|-----------|--------|---------|----------|
| LEE | 12-28 | 09:00~18:00 | 09:15 | 18:00 | completed | ✅ | |
| Jin | 12-28 | 09:00~18:00 | 08:55 | 17:30 | completed | | ✅ |
| Kim | 12-28 | 09:00~18:00 | 09:00 | - | checked_in | | |

---

## ⚠️ 제거된 항목 (Hourly에만 필요)

다음 컬럼들은 **Monthly에서 불필요**하여 제거:

| 컬럼명 | 이유 |
|--------|------|
| `late_minutes` | 시급 계산 불필요 |
| `early_leave_minutes` | 시급 계산 불필요 |
| `overtime_minutes` | 시급 계산 불필요 |
| `worked_minutes` | 시급 계산 불필요 |
| `problem_type` | Boolean 플래그로 대체 |

---

## 🔜 구현 체크리스트

### Phase 1: Database 수정

- [ ] `monthly_attendance` 테이블 컬럼 정리 (불필요 컬럼 제거)
- [ ] RLS 정책 수정 (company 멤버 허용)
- [ ] `monthly_check_in` RPC 수정 (timezone 동적 조회)
- [ ] `monthly_check_out` RPC 수정 (timezone 동적 조회)
- [ ] `get_monthly_attendance_stats` RPC 수정 (단순화)
- [ ] `get_monthly_attendance_list` RPC 수정 (단순화)

### Phase 2: Flutter Domain Layer

- [ ] `MonthlyAttendance` Entity 생성
- [ ] `MonthlyAttendanceModel` DTO 생성
- [ ] `MonthlyAttendanceDataSource` 생성
- [ ] `MonthlyAttendanceRepository` 생성

### Phase 3: Flutter Presentation Layer

- [ ] `AttendanceMainPage` 분기 로직 추가
- [ ] `MonthlyAttendanceContent` 위젯 생성
- [ ] `MonthlyHeroSection` 위젯 생성
- [ ] `MonthlyCalendar` 위젯 생성

### Phase 4: QR Integration

- [ ] `QRScannerPage` 분기 로직 추가
- [ ] Monthly 체크인 처리 로직

### Phase 5: Testing

- [ ] Monthly 체크인 테스트
- [ ] Monthly 체크아웃 테스트
- [ ] 비근무일 체크인 차단 테스트
- [ ] Timezone 변환 테스트

---

## 📝 버전 히스토리

| 버전 | 날짜 | 변경사항 |
|------|------|----------|
| 1.0 | 2025-12-28 | 초기 명세서 |
| 2.0 | 2025-12-28 | 피드백 반영: 단순화, timezone 동적 조회, RLS 수정 |
