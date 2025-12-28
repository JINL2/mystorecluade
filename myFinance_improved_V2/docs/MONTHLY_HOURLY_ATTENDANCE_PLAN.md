# Monthly vs Hourly Attendance System - Implementation Plan

## Overview

Monthly(월급제)와 Hourly(시급제) 직원의 출퇴근 시스템을 분리하여 각각에 맞는 UI와 로직을 제공.

---

## 1. 현재 상태 분석

### 1.1 데이터 흐름

```
사용자 로그인
    ↓
getUserCompanies RPC
    ↓
AppState에 salary_type 저장 ✅ (이미 구현됨)
    ↓
Attendance 페이지 진입
    ↓
❌ 현재: salary_type 무시하고 동일 UI 표시
```

### 1.2 현재 테이블 구조

```sql
-- Hourly 직원용 (현재 사용)
shift_requests (
  shift_request_id UUID,
  user_id UUID,
  shift_id UUID,           -- store_shifts 테이블 참조
  store_id UUID,
  start_time TIMESTAMPTZ,  -- 예정 시작
  end_time TIMESTAMPTZ,    -- 예정 종료
  actual_start_time TIMESTAMPTZ,  -- 실제 체크인
  actual_end_time TIMESTAMPTZ,    -- 실제 체크아웃
  is_approved BOOLEAN,
  status status_enum
)

-- Monthly 직원용 (신규 필요)
monthly_attendance (
  attendance_id UUID,
  user_id UUID,
  company_id UUID,
  work_schedule_template_id UUID,  -- 템플릿 참조
  attendance_date DATE,
  check_in_time TIMESTAMPTZ,
  check_out_time TIMESTAMPTZ,
  check_in_location POINT,
  check_out_location POINT,
  status ('present' | 'absent' | 'late' | 'early_leave' | 'holiday'),
  notes TEXT,
  created_at_utc TIMESTAMPTZ
)
```

---

## 2. 아키텍처 설계

### 2.1 사용자 타입 확인 플로우

```
┌─────────────────────────────────────────────────────┐
│                  Attendance Page                     │
├─────────────────────────────────────────────────────┤
│                        │                            │
│              AppState.salaryType                    │
│                        │                            │
│         ┌──────────────┴──────────────┐            │
│         ▼                              ▼            │
│   ┌──────────┐                  ┌──────────┐       │
│   │ "hourly" │                  │ "monthly"│       │
│   └────┬─────┘                  └────┬─────┘       │
│        │                              │             │
│        ▼                              ▼             │
│ HourlyAttendanceContent    MonthlyAttendanceContent│
│ (기존 로직)                 (신규 구현)             │
└─────────────────────────────────────────────────────┘
```

### 2.2 UI 비교

#### Hourly 직원 (기존)
```
┌─────────────────────────────────────┐
│ December 2025          ● On Duty    │
├─────────────────────────────────────┤
│ Total Shifts: 15    Total Hours: 89 │
│ Overtime: 120min    Late: 30min     │
├─────────────────────────────────────┤
│ Estimated Salary: ₩1,200,000        │
│              (+₩45,000 overtime)    │
├─────────────────────────────────────┤
│         [ QR Check In/Out ]         │
│  (스캔 → shift 선택 → 체크인/아웃)  │
├─────────────────────────────────────┤
│ This Week Schedule                  │
│ Mon  Tue  Wed  Thu  Fri  Sat  Sun   │
│  ●    ●    ●    -    ●    -    -    │
├─────────────────────────────────────┤
│ Recent Activity                     │
│ Today 09:00 - 18:00  ✓ Complete     │
│ Yesterday 09:00 - 18:30  ⚠ Late 15m │
└─────────────────────────────────────┘
```

#### Monthly 직원 (신규)
```
┌─────────────────────────────────────┐
│ December 2025          ● Working    │
├─────────────────────────────────────┤
│ Work Days: 22       Attended: 18    │
│ Attendance: 81.8%   On-time: 94.4%  │
├─────────────────────────────────────┤
│ Monthly Salary: ₩3,000,000          │
│ Schedule: Full-time (09:00-18:00)   │
├─────────────────────────────────────┤
│         [ QR Check In/Out ]         │
│  (스캔 → 템플릿 시간 기준 체크인)   │
├─────────────────────────────────────┤
│ This Week                           │
│ Mon  Tue  Wed  Thu  Fri  Sat  Sun   │
│  ✓    ✓    ✓    ●    -    -    -    │
│ (✓=출근, ●=오늘, -=휴무)            │
├─────────────────────────────────────┤
│ Recent Attendance                   │
│ Today 09:05 (Late 5m)               │
│ Yesterday 08:58 - 18:02  ✓ Complete │
└─────────────────────────────────────┘
```

---

## 3. 데이터베이스 설계

### 3.1 신규 테이블: monthly_attendance

```sql
-- Migration: Create monthly_attendance table
CREATE TABLE monthly_attendance (
  attendance_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  company_id UUID NOT NULL REFERENCES companies(company_id),
  store_id UUID REFERENCES stores(store_id),  -- QR 스캔한 매장
  work_schedule_template_id UUID REFERENCES work_schedule_templates(template_id),

  -- 날짜 및 시간
  attendance_date DATE NOT NULL,
  scheduled_start_time TIME,  -- 템플릿에서 가져온 예정 시작
  scheduled_end_time TIME,    -- 템플릿에서 가져온 예정 종료
  check_in_time TIMESTAMPTZ,
  check_out_time TIMESTAMPTZ,

  -- 위치 정보
  check_in_lat DECIMAL(10, 8),
  check_in_lng DECIMAL(11, 8),
  check_out_lat DECIMAL(10, 8),
  check_out_lng DECIMAL(11, 8),

  -- 상태
  status TEXT NOT NULL DEFAULT 'scheduled'
    CHECK (status IN ('scheduled', 'present', 'absent', 'late', 'early_leave', 'holiday', 'leave')),

  -- 문제 감지
  is_late BOOLEAN DEFAULT false,
  late_minutes INT DEFAULT 0,
  is_early_leave BOOLEAN DEFAULT false,
  early_leave_minutes INT DEFAULT 0,
  has_location_issue BOOLEAN DEFAULT false,

  -- 메타데이터
  notes TEXT,
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW(),

  -- 유니크 제약 (하루에 한 출근 기록)
  UNIQUE(user_id, company_id, attendance_date)
);

-- 인덱스
CREATE INDEX idx_monthly_attendance_user_date
  ON monthly_attendance(user_id, attendance_date DESC);
CREATE INDEX idx_monthly_attendance_company_date
  ON monthly_attendance(company_id, attendance_date DESC);

-- RLS
ALTER TABLE monthly_attendance ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own attendance"
  ON monthly_attendance FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own attendance"
  ON monthly_attendance FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own attendance"
  ON monthly_attendance FOR UPDATE
  USING (user_id = auth.uid());
```

### 3.2 신규 RPC 함수

#### RPC 1: monthly_check_in

```sql
CREATE OR REPLACE FUNCTION monthly_check_in(
  p_user_id UUID,
  p_company_id UUID,
  p_store_id UUID,
  p_time TIMESTAMP,      -- 로컬 시간
  p_lat DECIMAL,
  p_lng DECIMAL,
  p_timezone TEXT
)
RETURNS JSONB AS $$
DECLARE
  v_template_id UUID;
  v_template RECORD;
  v_today DATE;
  v_day_of_week INT;
  v_is_work_day BOOLEAN;
  v_scheduled_start TIME;
  v_scheduled_end TIME;
  v_is_late BOOLEAN := false;
  v_late_minutes INT := 0;
  v_attendance_id UUID;
  v_check_in_utc TIMESTAMPTZ;
BEGIN
  -- 1. 현재 날짜 (로컬 타임존 기준)
  v_today := (p_time AT TIME ZONE p_timezone)::DATE;
  v_day_of_week := EXTRACT(ISODOW FROM v_today);  -- 1=Mon, 7=Sun

  -- 2. 사용자의 템플릿 가져오기
  SELECT work_schedule_template_id INTO v_template_id
  FROM user_salaries
  WHERE user_id = p_user_id AND company_id = p_company_id;

  IF v_template_id IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'NO_TEMPLATE',
      'message', 'No work schedule template assigned. Please contact your manager.'
    );
  END IF;

  -- 3. 템플릿 정보 가져오기
  SELECT * INTO v_template
  FROM work_schedule_templates
  WHERE template_id = v_template_id;

  -- 4. 오늘이 근무일인지 확인
  v_is_work_day := CASE v_day_of_week
    WHEN 1 THEN v_template.monday
    WHEN 2 THEN v_template.tuesday
    WHEN 3 THEN v_template.wednesday
    WHEN 4 THEN v_template.thursday
    WHEN 5 THEN v_template.friday
    WHEN 6 THEN v_template.saturday
    WHEN 7 THEN v_template.sunday
  END;

  IF NOT v_is_work_day THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'NOT_WORK_DAY',
      'message', 'Today is not a scheduled work day according to your template.'
    );
  END IF;

  -- 5. 이미 체크인했는지 확인
  IF EXISTS (
    SELECT 1 FROM monthly_attendance
    WHERE user_id = p_user_id
      AND company_id = p_company_id
      AND attendance_date = v_today
      AND check_in_time IS NOT NULL
  ) THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'ALREADY_CHECKED_IN',
      'message', 'You have already checked in today.'
    );
  END IF;

  -- 6. 지각 여부 계산
  v_scheduled_start := v_template.work_start_time;
  v_scheduled_end := v_template.work_end_time;

  IF (p_time::TIME) > (v_scheduled_start + INTERVAL '5 minutes') THEN
    v_is_late := true;
    v_late_minutes := EXTRACT(EPOCH FROM ((p_time::TIME) - v_scheduled_start)) / 60;
  END IF;

  -- 7. UTC로 변환
  v_check_in_utc := (p_time::TIMESTAMP AT TIME ZONE p_timezone) AT TIME ZONE 'UTC';

  -- 8. 출근 기록 생성 또는 업데이트
  INSERT INTO monthly_attendance (
    user_id, company_id, store_id, work_schedule_template_id,
    attendance_date, scheduled_start_time, scheduled_end_time,
    check_in_time, check_in_lat, check_in_lng,
    status, is_late, late_minutes
  ) VALUES (
    p_user_id, p_company_id, p_store_id, v_template_id,
    v_today, v_scheduled_start, v_scheduled_end,
    v_check_in_utc, p_lat, p_lng,
    CASE WHEN v_is_late THEN 'late' ELSE 'present' END,
    v_is_late, v_late_minutes
  )
  ON CONFLICT (user_id, company_id, attendance_date)
  DO UPDATE SET
    check_in_time = v_check_in_utc,
    check_in_lat = p_lat,
    check_in_lng = p_lng,
    status = CASE WHEN v_is_late THEN 'late' ELSE 'present' END,
    is_late = v_is_late,
    late_minutes = v_late_minutes,
    updated_at_utc = NOW()
  RETURNING attendance_id INTO v_attendance_id;

  RETURN jsonb_build_object(
    'success', true,
    'action', 'check_in',
    'attendance_id', v_attendance_id,
    'attendance_date', v_today,
    'check_in_time', v_check_in_utc,
    'scheduled_start', v_scheduled_start,
    'scheduled_end', v_scheduled_end,
    'is_late', v_is_late,
    'late_minutes', v_late_minutes,
    'message', CASE
      WHEN v_is_late THEN format('Checked in (Late by %s minutes)', v_late_minutes)
      ELSE 'Checked in successfully'
    END
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### RPC 2: monthly_check_out

```sql
CREATE OR REPLACE FUNCTION monthly_check_out(
  p_user_id UUID,
  p_company_id UUID,
  p_store_id UUID,
  p_time TIMESTAMP,
  p_lat DECIMAL,
  p_lng DECIMAL,
  p_timezone TEXT
)
RETURNS JSONB AS $$
DECLARE
  v_attendance RECORD;
  v_today DATE;
  v_is_early_leave BOOLEAN := false;
  v_early_leave_minutes INT := 0;
  v_check_out_utc TIMESTAMPTZ;
BEGIN
  v_today := (p_time AT TIME ZONE p_timezone)::DATE;
  v_check_out_utc := (p_time::TIMESTAMP AT TIME ZONE p_timezone) AT TIME ZONE 'UTC';

  -- 1. 오늘의 출근 기록 찾기
  SELECT * INTO v_attendance
  FROM monthly_attendance
  WHERE user_id = p_user_id
    AND company_id = p_company_id
    AND attendance_date = v_today;

  IF v_attendance IS NULL OR v_attendance.check_in_time IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'NOT_CHECKED_IN',
      'message', 'You have not checked in today.'
    );
  END IF;

  IF v_attendance.check_out_time IS NOT NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'ALREADY_CHECKED_OUT',
      'message', 'You have already checked out today.'
    );
  END IF;

  -- 2. 조퇴 여부 계산
  IF (p_time::TIME) < (v_attendance.scheduled_end_time - INTERVAL '5 minutes') THEN
    v_is_early_leave := true;
    v_early_leave_minutes := EXTRACT(EPOCH FROM (v_attendance.scheduled_end_time - (p_time::TIME))) / 60;
  END IF;

  -- 3. 체크아웃 업데이트
  UPDATE monthly_attendance SET
    check_out_time = v_check_out_utc,
    check_out_lat = p_lat,
    check_out_lng = p_lng,
    is_early_leave = v_is_early_leave,
    early_leave_minutes = v_early_leave_minutes,
    status = CASE
      WHEN v_is_early_leave THEN 'early_leave'
      WHEN v_attendance.is_late THEN 'late'
      ELSE 'present'
    END,
    updated_at_utc = NOW()
  WHERE attendance_id = v_attendance.attendance_id;

  RETURN jsonb_build_object(
    'success', true,
    'action', 'check_out',
    'attendance_id', v_attendance.attendance_id,
    'attendance_date', v_today,
    'check_in_time', v_attendance.check_in_time,
    'check_out_time', v_check_out_utc,
    'is_early_leave', v_is_early_leave,
    'early_leave_minutes', v_early_leave_minutes,
    'message', CASE
      WHEN v_is_early_leave THEN format('Checked out (Early by %s minutes)', v_early_leave_minutes)
      ELSE 'Checked out successfully'
    END
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### RPC 3: get_monthly_attendance_stats

```sql
CREATE OR REPLACE FUNCTION get_monthly_attendance_stats(
  p_user_id UUID,
  p_company_id UUID,
  p_year INT,
  p_month INT
)
RETURNS JSONB AS $$
DECLARE
  v_template RECORD;
  v_total_work_days INT := 0;
  v_attended_days INT := 0;
  v_late_count INT := 0;
  v_early_leave_count INT := 0;
  v_absent_count INT := 0;
  v_on_time_count INT := 0;
  v_salary_amount DECIMAL;
  v_currency_symbol TEXT;
  v_start_date DATE;
  v_end_date DATE;
  v_current_date DATE;
BEGIN
  -- 1. 템플릿 및 급여 정보 가져오기
  SELECT
    wst.*,
    us.salary_amount,
    c.symbol
  INTO v_template
  FROM user_salaries us
  JOIN work_schedule_templates wst ON wst.template_id = us.work_schedule_template_id
  JOIN currencies c ON c.currency_id = us.currency_id
  WHERE us.user_id = p_user_id AND us.company_id = p_company_id;

  IF v_template IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'NO_TEMPLATE',
      'message', 'No work schedule template assigned'
    );
  END IF;

  v_salary_amount := v_template.salary_amount;
  v_currency_symbol := v_template.symbol;

  -- 2. 해당 월의 범위 계산
  v_start_date := make_date(p_year, p_month, 1);
  v_end_date := (v_start_date + INTERVAL '1 month' - INTERVAL '1 day')::DATE;

  -- 3. 각 날짜별 근무일 계산
  v_current_date := v_start_date;
  WHILE v_current_date <= v_end_date AND v_current_date <= CURRENT_DATE LOOP
    DECLARE
      v_dow INT := EXTRACT(ISODOW FROM v_current_date);
      v_is_work_day BOOLEAN;
    BEGIN
      v_is_work_day := CASE v_dow
        WHEN 1 THEN v_template.monday
        WHEN 2 THEN v_template.tuesday
        WHEN 3 THEN v_template.wednesday
        WHEN 4 THEN v_template.thursday
        WHEN 5 THEN v_template.friday
        WHEN 6 THEN v_template.saturday
        WHEN 7 THEN v_template.sunday
      END;

      IF v_is_work_day THEN
        v_total_work_days := v_total_work_days + 1;
      END IF;
    END;
    v_current_date := v_current_date + INTERVAL '1 day';
  END LOOP;

  -- 4. 출근 통계 계산
  SELECT
    COUNT(*) FILTER (WHERE check_in_time IS NOT NULL),
    COUNT(*) FILTER (WHERE is_late = true),
    COUNT(*) FILTER (WHERE is_early_leave = true),
    COUNT(*) FILTER (WHERE check_in_time IS NOT NULL AND is_late = false)
  INTO v_attended_days, v_late_count, v_early_leave_count, v_on_time_count
  FROM monthly_attendance
  WHERE user_id = p_user_id
    AND company_id = p_company_id
    AND attendance_date >= v_start_date
    AND attendance_date <= v_end_date;

  v_absent_count := v_total_work_days - v_attended_days;

  RETURN jsonb_build_object(
    'success', true,
    'year', p_year,
    'month', p_month,
    'template_name', v_template.template_name,
    'work_start_time', v_template.work_start_time,
    'work_end_time', v_template.work_end_time,
    'total_work_days', v_total_work_days,
    'attended_days', v_attended_days,
    'absent_days', v_absent_count,
    'late_count', v_late_count,
    'early_leave_count', v_early_leave_count,
    'on_time_count', v_on_time_count,
    'attendance_rate', CASE WHEN v_total_work_days > 0
      THEN ROUND((v_attended_days::DECIMAL / v_total_work_days) * 100, 1)
      ELSE 0 END,
    'on_time_rate', CASE WHEN v_attended_days > 0
      THEN ROUND((v_on_time_count::DECIMAL / v_attended_days) * 100, 1)
      ELSE 0 END,
    'salary_amount', v_salary_amount,
    'currency_symbol', v_currency_symbol
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### RPC 4: get_monthly_attendance_list

```sql
CREATE OR REPLACE FUNCTION get_monthly_attendance_list(
  p_user_id UUID,
  p_company_id UUID,
  p_year INT,
  p_month INT
)
RETURNS TABLE (
  attendance_id UUID,
  attendance_date DATE,
  scheduled_start_time TIME,
  scheduled_end_time TIME,
  check_in_time TIMESTAMPTZ,
  check_out_time TIMESTAMPTZ,
  status TEXT,
  is_late BOOLEAN,
  late_minutes INT,
  is_early_leave BOOLEAN,
  early_leave_minutes INT,
  is_work_day BOOLEAN
) AS $$
DECLARE
  v_template RECORD;
  v_start_date DATE;
  v_end_date DATE;
BEGIN
  -- 템플릿 가져오기
  SELECT wst.* INTO v_template
  FROM user_salaries us
  JOIN work_schedule_templates wst ON wst.template_id = us.work_schedule_template_id
  WHERE us.user_id = p_user_id AND us.company_id = p_company_id;

  v_start_date := make_date(p_year, p_month, 1);
  v_end_date := (v_start_date + INTERVAL '1 month' - INTERVAL '1 day')::DATE;

  RETURN QUERY
  WITH date_series AS (
    SELECT generate_series(v_start_date, v_end_date, '1 day'::INTERVAL)::DATE AS dt
  ),
  work_days AS (
    SELECT
      dt,
      CASE EXTRACT(ISODOW FROM dt)
        WHEN 1 THEN v_template.monday
        WHEN 2 THEN v_template.tuesday
        WHEN 3 THEN v_template.wednesday
        WHEN 4 THEN v_template.thursday
        WHEN 5 THEN v_template.friday
        WHEN 6 THEN v_template.saturday
        WHEN 7 THEN v_template.sunday
      END AS is_work_day
    FROM date_series
  )
  SELECT
    ma.attendance_id,
    wd.dt AS attendance_date,
    v_template.work_start_time AS scheduled_start_time,
    v_template.work_end_time AS scheduled_end_time,
    ma.check_in_time,
    ma.check_out_time,
    COALESCE(ma.status,
      CASE
        WHEN NOT wd.is_work_day THEN 'holiday'
        WHEN wd.dt > CURRENT_DATE THEN 'scheduled'
        ELSE 'absent'
      END
    ) AS status,
    COALESCE(ma.is_late, false) AS is_late,
    COALESCE(ma.late_minutes, 0) AS late_minutes,
    COALESCE(ma.is_early_leave, false) AS is_early_leave,
    COALESCE(ma.early_leave_minutes, 0) AS early_leave_minutes,
    wd.is_work_day
  FROM work_days wd
  LEFT JOIN monthly_attendance ma ON ma.attendance_date = wd.dt
    AND ma.user_id = p_user_id
    AND ma.company_id = p_company_id
  ORDER BY wd.dt DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## 4. Flutter 구현 계획

### 4.1 디렉토리 구조

```
lib/features/attendance/
├── domain/
│   ├── entities/
│   │   ├── monthly_attendance.dart        # 신규
│   │   ├── monthly_attendance_stats.dart  # 신규
│   │   └── ... (기존 유지)
│   └── usecases/
│       ├── monthly_check_in.dart          # 신규
│       ├── monthly_check_out.dart         # 신규
│       ├── get_monthly_attendance_stats.dart  # 신규
│       └── ... (기존 유지)
├── data/
│   ├── datasources/
│   │   └── attendance_datasource.dart     # 메서드 추가
│   └── models/
│       ├── monthly_attendance_model.dart  # 신규
│       └── ... (기존 유지)
└── presentation/
    ├── pages/
    │   └── attendance_main_page.dart      # 분기 로직 추가
    └── widgets/
        ├── check_in_out/
        │   ├── attendance_content.dart        # 기존 (Hourly용)
        │   └── monthly_attendance_content.dart # 신규 (Monthly용)
        ├── monthly/                           # 신규 폴더
        │   ├── monthly_hero_section.dart
        │   ├── monthly_calendar.dart
        │   ├── monthly_recent_activity.dart
        │   └── monthly_qr_button.dart
        └── ... (기존 유지)
```

### 4.2 AttendanceMainPage 분기 로직

```dart
// attendance_main_page.dart
class AttendanceMainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final salaryType = appState.salaryType;  // 'hourly' or 'monthly'

    return TossScaffold(
      appBar: TossAppBar1(title: 'My Attendance'),
      body: salaryType == 'monthly'
          ? const MonthlyAttendanceContent()  // 신규
          : const AttendanceContent(),        // 기존
    );
  }
}
```

### 4.3 QR 체크인 분기

```dart
// qr_scanner_page.dart 수정
Future<void> _processQRScan(String storeId) async {
  final salaryType = ref.read(appStateProvider).salaryType;

  if (salaryType == 'monthly') {
    await _processMonthlyCheckIn(storeId);
  } else {
    await _processHourlyCheckIn(storeId);  // 기존 로직
  }
}

Future<void> _processMonthlyCheckIn(String storeId) async {
  // 1. GPS 위치 수집
  final position = await _getCurrentLocation();

  // 2. 오늘 이미 체크인했는지 확인
  final todayAttendance = await _getTodayAttendance();

  if (todayAttendance == null || todayAttendance.checkInTime == null) {
    // 체크인
    await ref.read(monthlyCheckInProvider)(
      storeId: storeId,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  } else if (todayAttendance.checkOutTime == null) {
    // 체크아웃
    await ref.read(monthlyCheckOutProvider)(
      storeId: storeId,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  } else {
    // 이미 완료
    _showAlreadyCompletedDialog();
  }
}
```

---

## 5. 구현 순서

### Phase 1: Database (1시간)
| Step | Task | Est |
|------|------|-----|
| 1.1 | `monthly_attendance` 테이블 생성 | 15m |
| 1.2 | `monthly_check_in` RPC 생성 | 15m |
| 1.3 | `monthly_check_out` RPC 생성 | 15m |
| 1.4 | `get_monthly_attendance_stats` RPC 생성 | 10m |
| 1.5 | `get_monthly_attendance_list` RPC 생성 | 10m |

### Phase 2: Flutter Domain Layer (1시간)
| Step | Task | Est |
|------|------|-----|
| 2.1 | `MonthlyAttendance` Entity | 15m |
| 2.2 | `MonthlyAttendanceStats` Entity | 15m |
| 2.3 | DataSource 메서드 추가 | 15m |
| 2.4 | UseCase 및 Provider 추가 | 15m |

### Phase 3: Flutter Presentation Layer (2시간)
| Step | Task | Est |
|------|------|-----|
| 3.1 | `AttendanceMainPage` 분기 로직 | 15m |
| 3.2 | `MonthlyAttendanceContent` 메인 위젯 | 30m |
| 3.3 | `MonthlyHeroSection` (통계 표시) | 30m |
| 3.4 | `MonthlyCalendar` (출근 현황) | 30m |
| 3.5 | QR 스캔 분기 로직 수정 | 15m |

### Phase 4: Testing (30분)
| Step | Task | Est |
|------|------|-----|
| 4.1 | Monthly 체크인/아웃 테스트 | 15m |
| 4.2 | 통계 표시 확인 | 15m |

**Total: ~4.5시간**

---

## 6. 고려사항

### 6.1 Edge Cases

1. **템플릿 미할당**: 체크인 시 에러 메시지 + 관리자 연락 안내
2. **휴무일 체크인**: "오늘은 근무일이 아닙니다" 메시지
3. **중복 체크인**: "이미 체크인했습니다" 메시지
4. **자정 넘김**: UTC 기준으로 처리, 로컬 날짜로 표시

### 6.2 마이그레이션

- 기존 Hourly 직원 데이터는 그대로 유지
- Monthly 직원 기존 shift_requests 데이터는 참조용으로 보관 (삭제 안함)
- 신규 monthly_attendance는 빈 상태로 시작

### 6.3 향후 확장

- 휴가/병가 신청 기능
- 재택근무 체크인 (GPS 비활성화 옵션)
- 관리자용 출근 현황 대시보드
- 급여 자동 차감 (결근, 지각 등)

---

## 7. 성공 기준

- [ ] Monthly 직원이 로그인 시 Monthly 전용 UI 표시
- [ ] QR 스캔으로 체크인/아웃 성공
- [ ] 월간 출근 통계 정확히 계산
- [ ] 지각/조퇴 자동 감지
- [ ] 휴무일에는 체크인 불가
- [ ] 기존 Hourly 직원 기능 정상 동작

---

## 8. 관련 파일

### 수정 필요
- `attendance_main_page.dart` - 분기 로직
- `qr_scanner_page.dart` - QR 체크인 분기
- `attendance_datasource.dart` - RPC 메서드 추가
- `attendance_providers.dart` - Provider 추가

### 신규 생성
- `monthly_attendance.dart` (Entity)
- `monthly_attendance_stats.dart` (Entity)
- `monthly_attendance_model.dart` (Model)
- `monthly_attendance_content.dart` (Widget)
- `monthly_hero_section.dart` (Widget)
- `monthly_calendar.dart` (Widget)
- Supabase Migration 파일들
