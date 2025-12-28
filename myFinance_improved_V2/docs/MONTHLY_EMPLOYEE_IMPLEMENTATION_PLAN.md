# Monthly Employee Work Schedule Template - Implementation Plan

## Overview

Monthly(월급제) 직원의 근무 스케줄 템플릿 시스템 구현 계획서.
- **목표**: 템플릿 생성 → 직원 할당 → DB 저장 확인
- **QR 체크인**은 이 단계 완료 후 별도 진행

---

## Current Database State

### Tables

```sql
-- work_schedule_templates (✅ EXISTS)
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

-- user_salaries (✅ FK EXISTS)
-- work_schedule_template_id UUID REFERENCES work_schedule_templates(template_id)
```

### RLS Policies (✅ EXISTS)

| Policy | Command | Condition |
|--------|---------|-----------|
| SELECT | Users can view | company_id IN user_companies |
| ALL | Owners can manage | role_type = 'owner' |

### Existing RPC

| RPC | Status | Description |
|-----|--------|-------------|
| `set_default_work_schedule_template` | ✅ EXISTS | 기본 템플릿 설정 |

---

## Phase 1: Database & RPC

### 1.1 Update v_user_salary View

현재 `v_user_salary` 뷰에 `work_schedule_template_id`가 없음.

```sql
-- Migration: Add work_schedule_template info to v_user_salary
CREATE OR REPLACE VIEW v_user_salary AS
SELECT
    us.salary_id,
    us.user_id,
    -- ... existing fields ...
    us.work_schedule_template_id,
    wst.template_name AS work_schedule_template_name,
    wst.work_start_time,
    wst.work_end_time
FROM user_salaries us
LEFT JOIN work_schedule_templates wst
    ON wst.template_id = us.work_schedule_template_id
-- ... rest of existing joins ...
```

### 1.2 Create RPC Functions

#### RPC 1: get_work_schedule_templates

```sql
CREATE OR REPLACE FUNCTION get_work_schedule_templates(
    p_company_id UUID
)
RETURNS TABLE (
    template_id UUID,
    company_id UUID,
    template_name TEXT,
    work_start_time TIME,
    work_end_time TIME,
    monday BOOLEAN,
    tuesday BOOLEAN,
    wednesday BOOLEAN,
    thursday BOOLEAN,
    friday BOOLEAN,
    saturday BOOLEAN,
    sunday BOOLEAN,
    is_default BOOLEAN,
    employee_count BIGINT,
    created_at_utc TIMESTAMPTZ,
    updated_at_utc TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        wst.template_id,
        wst.company_id,
        wst.template_name,
        wst.work_start_time,
        wst.work_end_time,
        wst.monday,
        wst.tuesday,
        wst.wednesday,
        wst.thursday,
        wst.friday,
        wst.saturday,
        wst.sunday,
        wst.is_default,
        COUNT(us.salary_id)::BIGINT AS employee_count,
        wst.created_at_utc,
        wst.updated_at_utc
    FROM work_schedule_templates wst
    LEFT JOIN user_salaries us ON us.work_schedule_template_id = wst.template_id
    WHERE wst.company_id = p_company_id
    GROUP BY wst.template_id
    ORDER BY wst.is_default DESC, wst.template_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### RPC 2: create_work_schedule_template

```sql
CREATE OR REPLACE FUNCTION create_work_schedule_template(
    p_company_id UUID,
    p_template_name TEXT,
    p_work_start_time TIME DEFAULT '09:00',
    p_work_end_time TIME DEFAULT '18:00',
    p_monday BOOLEAN DEFAULT true,
    p_tuesday BOOLEAN DEFAULT true,
    p_wednesday BOOLEAN DEFAULT true,
    p_thursday BOOLEAN DEFAULT true,
    p_friday BOOLEAN DEFAULT true,
    p_saturday BOOLEAN DEFAULT false,
    p_sunday BOOLEAN DEFAULT false,
    p_is_default BOOLEAN DEFAULT false
)
RETURNS JSONB AS $$
DECLARE
    v_template_id UUID;
BEGIN
    -- If setting as default, unset other defaults first
    IF p_is_default THEN
        UPDATE work_schedule_templates
        SET is_default = false
        WHERE company_id = p_company_id AND is_default = true;
    END IF;

    INSERT INTO work_schedule_templates (
        company_id, template_name, work_start_time, work_end_time,
        monday, tuesday, wednesday, thursday, friday, saturday, sunday,
        is_default
    ) VALUES (
        p_company_id, p_template_name, p_work_start_time, p_work_end_time,
        p_monday, p_tuesday, p_wednesday, p_thursday, p_friday, p_saturday, p_sunday,
        p_is_default
    )
    RETURNING template_id INTO v_template_id;

    RETURN jsonb_build_object(
        'success', true,
        'template_id', v_template_id,
        'message', 'Template created successfully'
    );
EXCEPTION
    WHEN unique_violation THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'DUPLICATE_NAME',
            'message', 'Template name already exists'
        );
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'CREATE_FAILED',
            'message', SQLERRM
        );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### RPC 3: update_work_schedule_template

```sql
CREATE OR REPLACE FUNCTION update_work_schedule_template(
    p_template_id UUID,
    p_template_name TEXT DEFAULT NULL,
    p_work_start_time TIME DEFAULT NULL,
    p_work_end_time TIME DEFAULT NULL,
    p_monday BOOLEAN DEFAULT NULL,
    p_tuesday BOOLEAN DEFAULT NULL,
    p_wednesday BOOLEAN DEFAULT NULL,
    p_thursday BOOLEAN DEFAULT NULL,
    p_friday BOOLEAN DEFAULT NULL,
    p_saturday BOOLEAN DEFAULT NULL,
    p_sunday BOOLEAN DEFAULT NULL,
    p_is_default BOOLEAN DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
    v_company_id UUID;
BEGIN
    -- Get company_id for the template
    SELECT company_id INTO v_company_id
    FROM work_schedule_templates
    WHERE template_id = p_template_id;

    IF v_company_id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'NOT_FOUND',
            'message', 'Template not found'
        );
    END IF;

    -- If setting as default, unset other defaults first
    IF p_is_default = true THEN
        UPDATE work_schedule_templates
        SET is_default = false
        WHERE company_id = v_company_id AND is_default = true AND template_id != p_template_id;
    END IF;

    UPDATE work_schedule_templates
    SET
        template_name = COALESCE(p_template_name, template_name),
        work_start_time = COALESCE(p_work_start_time, work_start_time),
        work_end_time = COALESCE(p_work_end_time, work_end_time),
        monday = COALESCE(p_monday, monday),
        tuesday = COALESCE(p_tuesday, tuesday),
        wednesday = COALESCE(p_wednesday, wednesday),
        thursday = COALESCE(p_thursday, thursday),
        friday = COALESCE(p_friday, friday),
        saturday = COALESCE(p_saturday, saturday),
        sunday = COALESCE(p_sunday, sunday),
        is_default = COALESCE(p_is_default, is_default),
        updated_at_utc = NOW()
    WHERE template_id = p_template_id;

    RETURN jsonb_build_object(
        'success', true,
        'template_id', p_template_id,
        'message', 'Template updated successfully'
    );
EXCEPTION
    WHEN unique_violation THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'DUPLICATE_NAME',
            'message', 'Template name already exists'
        );
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'UPDATE_FAILED',
            'message', SQLERRM
        );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### RPC 4: delete_work_schedule_template

```sql
CREATE OR REPLACE FUNCTION delete_work_schedule_template(
    p_template_id UUID
)
RETURNS JSONB AS $$
DECLARE
    v_employee_count BIGINT;
BEGIN
    -- Check if any employees are using this template
    SELECT COUNT(*) INTO v_employee_count
    FROM user_salaries
    WHERE work_schedule_template_id = p_template_id;

    IF v_employee_count > 0 THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'HAS_EMPLOYEES',
            'message', format('Cannot delete: %s employees are using this template', v_employee_count),
            'employee_count', v_employee_count
        );
    END IF;

    DELETE FROM work_schedule_templates
    WHERE template_id = p_template_id;

    RETURN jsonb_build_object(
        'success', true,
        'message', 'Template deleted successfully'
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'DELETE_FAILED',
            'message', SQLERRM
        );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### RPC 5: assign_work_schedule_template

```sql
CREATE OR REPLACE FUNCTION assign_work_schedule_template(
    p_user_id UUID,
    p_company_id UUID,
    p_template_id UUID  -- NULL to unassign
)
RETURNS JSONB AS $$
DECLARE
    v_salary_type TEXT;
BEGIN
    -- Check salary type
    SELECT salary_type INTO v_salary_type
    FROM user_salaries
    WHERE user_id = p_user_id AND company_id = p_company_id;

    IF v_salary_type IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'NOT_FOUND',
            'message', 'Employee salary record not found'
        );
    END IF;

    -- Warn if not monthly (but still allow)
    -- Update the template assignment
    UPDATE user_salaries
    SET
        work_schedule_template_id = p_template_id,
        updated_at = NOW(),
        updated_at_utc = NOW()
    WHERE user_id = p_user_id AND company_id = p_company_id;

    RETURN jsonb_build_object(
        'success', true,
        'message', CASE
            WHEN p_template_id IS NULL THEN 'Template unassigned'
            ELSE 'Template assigned successfully'
        END,
        'salary_type', v_salary_type,
        'warning', CASE
            WHEN v_salary_type != 'monthly' THEN 'Employee is not monthly type'
            ELSE NULL
        END
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'ASSIGN_FAILED',
            'message', SQLERRM
        );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## Phase 2: Flutter Domain Layer

### 2.1 store_shift Feature (Template CRUD)

#### File: domain/entities/work_schedule_template.dart

```dart
class WorkScheduleTemplate {
  final String templateId;
  final String companyId;
  final String templateName;
  final String workStartTime;  // "HH:mm" format
  final String workEndTime;    // "HH:mm" format
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;
  final bool isDefault;
  final int employeeCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WorkScheduleTemplate({...});

  List<String> get workDays => [...]; // ["Mon", "Tue", ...]
  String get workDaysText => workDays.join(', ');
  String get timeRangeText => '$workStartTime ~ $workEndTime';
}
```

#### File: data/models/work_schedule_template_model.dart

```dart
class WorkScheduleTemplateModel extends WorkScheduleTemplate {
  factory WorkScheduleTemplateModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

#### File: data/datasources/store_shift_data_source.dart (추가)

```dart
// Add these methods to existing StoreShiftDataSource

Future<List<Map<String, dynamic>>> getWorkScheduleTemplates(String companyId);
Future<Map<String, dynamic>> createWorkScheduleTemplate({...});
Future<Map<String, dynamic>> updateWorkScheduleTemplate({...});
Future<Map<String, dynamic>> deleteWorkScheduleTemplate(String templateId);
```

#### File: presentation/providers/store_shift_providers.dart (추가)

```dart
// Add these providers

final workScheduleTemplatesProvider = FutureProvider.autoDispose<List<WorkScheduleTemplate>>((ref) async {...});
final createWorkScheduleTemplateProvider = Provider.autoDispose<Future<...> Function({...})>((ref) {...});
final updateWorkScheduleTemplateProvider = Provider.autoDispose<Future<...> Function({...})>((ref) {...});
final deleteWorkScheduleTemplateProvider = Provider.autoDispose<Future<...> Function(String)>((ref) {...});
```

### 2.2 employee_setting Feature (Template Assignment)

#### File: domain/entities/employee_salary.dart (수정)

```dart
// Add these fields
final String? workScheduleTemplateId;
final String? workScheduleTemplateName;
final String? workStartTime;
final String? workEndTime;
```

#### File: data/models/employee_salary_model.dart (수정)

```dart
// Add JSON parsing for new fields
workScheduleTemplateId: json['work_schedule_template_id'] as String?,
workScheduleTemplateName: json['work_schedule_template_name'] as String?,
workStartTime: json['work_start_time'] as String?,
workEndTime: json['work_end_time'] as String?,
```

#### File: data/datasources/employee_remote_datasource.dart (추가)

```dart
// Add this method
Future<Map<String, dynamic>> assignWorkScheduleTemplate({
  required String userId,
  required String companyId,
  String? templateId,
});
```

---

## Phase 3: Flutter Presentation Layer

### 3.1 store_shift UI (Template Management)

#### StoreShiftPage 수정

```dart
// Change from 2 tabs to 3 tabs
TabController(length: 3, vsync: this);

tabs: const ['Shift Settings', 'Store Settings', 'Work Schedule'],

// Add third tab
_buildWorkScheduleTab(),
```

#### WorkScheduleTab Widget

```
┌─────────────────────────────────────┐
│ Work Schedule Templates        [+]  │
├─────────────────────────────────────┤
│ ⭐ Full-time (기본)            ✎ 🗑 │
│    09:00 ~ 18:00 | Mon-Fri          │
│    👥 5 employees                   │
├─────────────────────────────────────┤
│ Part-time Morning              ✎ 🗑 │
│    09:00 ~ 13:00 | Mon-Fri          │
│    👥 2 employees                   │
├─────────────────────────────────────┤
│ Weekend Shift                  ✎ 🗑 │
│    10:00 ~ 19:00 | Sat-Sun          │
│    👥 0 employees                   │
└─────────────────────────────────────┘
```

#### Template Form Dialog

```
┌─────────────────────────────────────┐
│ Create Template                     │
├─────────────────────────────────────┤
│ Template Name                       │
│ ┌─────────────────────────────────┐ │
│ │ Part-time Afternoon            │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Work Hours                          │
│ ┌───────────┐    ┌───────────┐     │
│ │ 13:00     │ ~  │ 18:00     │     │
│ └───────────┘    └───────────┘     │
│                                     │
│ Work Days                           │
│ ┌───┬───┬───┬───┬───┬───┬───┐     │
│ │Mon│Tue│Wed│Thu│Fri│Sat│Sun│     │
│ │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │   │   │     │
│ └───┴───┴───┴───┴───┴───┴───┘     │
│                                     │
│ ☐ Set as default template           │
│                                     │
│        [ Cancel ]  [ Save ]         │
└─────────────────────────────────────┘
```

### 3.2 employee_setting UI (Template Assignment)

#### EmployeeDetailSheetV2 → Salary Tab 수정

```
┌─────────────────────────────────────┐
│ Current Salary                      │
│ ₩15,000,000/mo                      │
├─────────────────────────────────────┤
│ Base Salary    ₩15,000,000 / monthly│
│ Currency       KRW (₩)              │
│ Payment Type   Monthly              │
├─────────────────────────────────────┤
│ Work Schedule  (Monthly 직원만 표시) │
│ ┌─────────────────────────────────┐ │
│ │ Full-time              ▼       │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 📋 09:00 ~ 18:00                    │
│ 📅 Mon Tue Wed Thu Fri              │
├─────────────────────────────────────┤
│           [ Edit Salary ]           │
└─────────────────────────────────────┘
```

---

## Phase 4: Testing & Verification

### 4.1 DB Verification Queries

```sql
-- 1. Check templates created
SELECT * FROM work_schedule_templates WHERE company_id = 'your-company-id';

-- 2. Check employee assignments
SELECT
    us.user_id,
    u.first_name,
    u.last_name,
    us.salary_type,
    us.work_schedule_template_id,
    wst.template_name
FROM user_salaries us
JOIN users u ON u.user_id = us.user_id
LEFT JOIN work_schedule_templates wst ON wst.template_id = us.work_schedule_template_id
WHERE us.company_id = 'your-company-id';

-- 3. Check v_user_salary includes template info
SELECT salary_id, full_name, salary_type, work_schedule_template_name
FROM v_user_salary
WHERE company_id = 'your-company-id';
```

### 4.2 Flutter Verification

1. **store_shift page**: 새 탭에서 템플릿 생성/수정/삭제
2. **employee_setting page**: 직원 상세 → Salary 탭에서 템플릿 선택
3. **DB 확인**: Supabase Dashboard에서 데이터 확인

---

## Implementation Order

| Step | Task | Location | Est. |
|------|------|----------|------|
| 1 | v_user_salary 뷰 수정 | Supabase Migration | 10min |
| 2 | RPC 함수 5개 생성 | Supabase Migration | 30min |
| 3 | WorkScheduleTemplate Entity/Model | store_shift/domain, data | 20min |
| 4 | DataSource 메서드 추가 | store_shift/data | 15min |
| 5 | Provider 추가 | store_shift/presentation | 15min |
| 6 | StoreShiftPage 3번째 탭 추가 | store_shift/presentation | 45min |
| 7 | EmployeeSalary Entity/Model 수정 | employee_setting/domain, data | 15min |
| 8 | assignWorkScheduleTemplate 메서드 | employee_setting/data | 10min |
| 9 | Salary 탭에 Dropdown 추가 | employee_setting/presentation | 30min |
| 10 | E2E 테스트 | - | 20min |

**Total: ~3.5 hours**

---

## Files to Create/Modify

### New Files
- `store_shift/domain/entities/work_schedule_template.dart`
- `store_shift/data/models/work_schedule_template_model.dart`
- `store_shift/presentation/widgets/work_schedule_tab.dart`
- `store_shift/presentation/widgets/work_schedule_template_card.dart`
- `store_shift/presentation/widgets/work_schedule_template_form.dart`

### Modified Files
- `store_shift/data/datasources/store_shift_data_source.dart`
- `store_shift/presentation/providers/store_shift_providers.dart`
- `store_shift/presentation/pages/store_shift_page.dart`
- `employee_setting/domain/entities/employee_salary.dart`
- `employee_setting/data/models/employee_salary_model.dart`
- `employee_setting/data/datasources/employee_remote_datasource.dart`
- `employee_setting/presentation/widgets/employee_detail_sheet_v2.dart`

### Supabase Migrations
- `20251228_update_v_user_salary_with_template.sql`
- `20251228_create_work_schedule_template_rpcs.sql`

---

## Success Criteria

- [ ] 템플릿 CRUD가 store_shift 페이지에서 작동
- [ ] 직원에게 템플릿 할당이 employee_setting에서 작동
- [ ] DB에서 `work_schedule_template_id` 저장 확인
- [ ] UI에서 할당된 템플릿 정보 표시 확인
