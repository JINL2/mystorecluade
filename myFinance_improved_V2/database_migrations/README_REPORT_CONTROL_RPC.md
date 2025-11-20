# Report Control RPC Functions

## Overview
이 파일은 Report Control 기능을 위한 RPC 함수들을 정의합니다. UI에서 효율적으로 데이터를 가져오고 필터링할 수 있도록 설계되었습니다.

**모든 함수는 `report_` 접두사로 시작하여 쉽게 찾을 수 있습니다.**

## 파일 구조

```
database_migrations/
├── 01_report_control_rpc_functions.sql   # RPC 함수 정의 (8개)
├── 02_report_control_rpc_metadata.sql    # RPC 메타데이터 INSERT
└── README_REPORT_CONTROL_RPC.md          # 이 문서
```

## 적용 방법 (순서대로)

### 1단계: RPC 함수 생성
```bash
# Supabase Dashboard → SQL Editor
# 01_report_control_rpc_functions.sql 파일 실행
```

### 2단계: 메타데이터 추가
```bash
# Supabase Dashboard → SQL Editor
# 02_report_control_rpc_metadata.sql 파일 실행
```

### 확인
```sql
-- 생성된 함수 확인
SELECT routine_name
FROM information_schema.routines
WHERE routine_name LIKE 'report_%'
ORDER BY routine_name;

-- 메타데이터 확인
SELECT rpc_name, description
FROM rpc_function_metadata
WHERE rpc_name LIKE 'report_%'
ORDER BY rpc_name;
```

---

## RPC 함수 목록 (8개)

### 1. `report_get_user_received_reports` ⭐⭐⭐
**목적**: 사용자가 받은 모든 리포트를 완전한 세부정보와 함께 가져오기

**파라미터**:
- `p_user_id` (uuid, required): 사용자 ID
- `p_company_id` (uuid, optional): 회사 ID로 필터링
- `p_limit` (int, default: 50): 페이지당 항목 수
- `p_offset` (int, default: 0): 페이지 오프셋

**반환 필드**:
```typescript
{
  // Notification 기본 정보
  notification_id: uuid,
  title: string,
  body: string,              // 리포트 전체 본문 (마크다운)
  is_read: boolean,
  sent_at: timestamp,
  created_at: timestamp,

  // 리포트 상세
  report_date: date,
  session_id: uuid,
  template_id: uuid,
  subscription_id: uuid,

  // 템플릿 정보
  template_name: string,
  template_code: string,
  template_icon: string,
  template_frequency: string,  // 'daily', 'weekly', 'monthly'

  // 생성 세션 상태
  session_status: string,      // 'pending', 'processing', 'completed', 'failed'
  session_started_at: timestamp,
  session_completed_at: timestamp,
  session_error_message: string,
  processing_time_ms: number,

  // 구독 정보
  subscription_enabled: boolean,
  subscription_schedule_time: time,
  subscription_schedule_days: jsonb,

  // 매장 정보
  store_id: uuid,
  store_name: string
}
```

**사용 예시**:
```dart
// Dart/Flutter
final result = await supabase.rpc('report_get_user_received_reports', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
  'p_limit': 20,
  'p_offset': 0,
});
```

**rpc_function_metadata에서 조회**:
```dart
// 메타데이터로 함수 찾기
final metadata = await supabase
  .from('rpc_function_metadata')
  .select()
  .eq('rpc_name', 'report_get_user_received_reports')
  .single();

print(metadata['description']);
print(metadata['parameters']);
```

**UI 필터링 지원**:
- ✅ 날짜별 필터링 (report_date)
- ✅ 템플릿별 필터링 (template_id, template_name)
- ✅ 매장별 필터링 (store_id, store_name)
- ✅ 상태별 필터링 (session_status)
- ✅ 읽음/안읽음 필터링 (is_read)
- ✅ 빈도별 필터링 (template_frequency)

---

### 2. `report_get_available_templates_with_status` ⭐⭐⭐
**목적**: 구독 가능한 모든 리포트 템플릿 + 사용자의 구독 상태

**파라미터**:
- `p_user_id` (uuid, required): 사용자 ID
- `p_company_id` (uuid, required): 회사 ID

**반환 필드**:
```typescript
{
  // 템플릿 정보
  template_id: uuid,
  template_name: string,
  template_code: string,
  description: string,
  frequency: string,
  icon: string,
  display_order: number,
  default_schedule_time: time,
  default_schedule_days: jsonb,
  default_monthly_day: number,
  category_id: uuid,

  // 구독 상태
  is_subscribed: boolean,      // 구독 여부 (핵심!)
  subscription_id: uuid,
  subscription_enabled: boolean,
  subscription_schedule_time: time,
  subscription_schedule_days: jsonb,
  subscription_monthly_send_day: number,
  subscription_timezone: string,
  subscription_last_sent_at: timestamp,
  subscription_next_scheduled_at: timestamp,
  subscription_created_at: timestamp,

  // 매장 정보
  store_id: uuid,
  store_name: string,

  // 최근 리포트 통계 (최근 30일)
  recent_reports_count: number,
  last_report_date: date,
  last_report_status: string
}
```

**사용 예시**:
```dart
final result = await supabase.rpc('report_get_available_templates_with_status', params: {
  'p_user_id': userId,
  'p_company_id': companyId,
});

// UI에서 사용
for (var template in result) {
  if (template['is_subscribed']) {
    // 구독 중 - ON 토글 표시
    showSubscribedBadge();
  } else {
    // 구독 가능 - 구독하기 버튼 표시
    showSubscribeButton();
  }
}
```

**UI 필터링 지원**:
- ✅ 구독 여부 (is_subscribed)
- ✅ 빈도별 (frequency: daily/weekly/monthly)
- ✅ 카테고리별 (category_id)
- ✅ 활성화 상태 (subscription_enabled)
- ✅ 매장별 (store_id)

---

### 3. `report_get_user_statistics`
**목적**: 대시보드용 통계 요약

**파라미터**:
- `p_user_id` (uuid, required)
- `p_company_id` (uuid, required)

**반환 필드**:
```typescript
{
  total_subscriptions: number,      // 총 구독 수
  active_subscriptions: number,     // 활성화된 구독 수
  total_reports_received: number,   // 받은 총 리포트 수
  unread_reports: number,           // 안 읽은 리포트 수
  reports_last_7_days: number,      // 최근 7일간 리포트 수
  reports_last_30_days: number,     // 최근 30일간 리포트 수
  failed_reports_count: number,     // 실패한 리포트 수
  pending_reports_count: number     // 대기/처리중 리포트 수
}
```

---

### 4. `report_mark_as_read`
**목적**: 리포트를 읽음으로 표시

**파라미터**:
- `p_notification_id` (uuid, required)
- `p_user_id` (uuid, required)

**반환**: `boolean` (성공 여부)

---

### 5. `report_subscribe_to_template`
**목적**: 새로운 리포트 구독 생성

**파라미터**:
- `p_user_id` (uuid, required)
- `p_company_id` (uuid, required)
- `p_store_id` (uuid, optional)
- `p_template_id` (uuid, required)
- `p_subscription_name` (varchar, optional): 커스텀 이름
- `p_schedule_time` (time, optional): 스케줄 시간 (기본값: 템플릿 기본값)
- `p_schedule_days` (jsonb, optional): [0-6] 요일 배열
- `p_monthly_send_day` (int, optional): 월간 리포트 발송일
- `p_timezone` (varchar, default: 'UTC')
- `p_notification_channels` (jsonb, default: ["push"])

**반환**:
```typescript
{
  subscription_id: uuid,
  template_name: string,
  enabled: boolean,
  created_at: timestamp
}
```

---

### 6. `report_update_subscription`
**목적**: 구독 설정 수정

**파라미터**:
- `p_subscription_id` (uuid, required)
- `p_user_id` (uuid, required)
- `p_enabled` (boolean, optional)
- `p_schedule_time` (time, optional)
- `p_schedule_days` (jsonb, optional)
- `p_monthly_send_day` (int, optional)
- `p_timezone` (varchar, optional)

**반환**: `boolean` (성공 여부)

---

### 7. `report_unsubscribe_from_template`
**목적**: 구독 삭제

**파라미터**:
- `p_subscription_id` (uuid, required)
- `p_user_id` (uuid, required)

**반환**: `boolean` (성공 여부)

---

### 8. `report_get_template_categories`
**목적**: 필터 드롭다운용 카테고리 목록

**파라미터**: 없음

**반환**:
```typescript
{
  category_id: uuid,
  category_name: string,
  template_count: number
}
```

---

## 데이터 플로우

### Tab 1: 받은 리포트 (Received Reports)
```
1. 페이지 로드 시:
   report_get_user_received_reports(user_id, company_id)
   └─> 모든 리포트 + 상태 + 템플릿 정보 가져오기

2. UI에서 필터링:
   - 날짜 필터: report_date로 필터
   - 템플릿 필터: template_name으로 필터
   - 상태 필터: session_status로 필터
   - 읽음 필터: is_read로 필터

3. 리포트 클릭:
   - body 전체 표시 (마크다운 렌더링)
   - report_mark_as_read() 호출

4. 통계 위젯:
   report_get_user_statistics()
```

### Tab 2: 새로운 보고서 신청 (Subscribe)
```
1. 페이지 로드 시:
   report_get_available_templates_with_status(user_id, company_id)
   └─> 모든 템플릿 + 구독 상태

2. UI 표시:
   if (is_subscribed):
     - ✅ 구독 중 배지
     - ON/OFF 토글 (subscription_enabled)
     - 스케줄 정보 표시
     - 수정 버튼
   else:
     - 구독하기 버튼

3. 구독 액션:
   - 구독하기: report_subscribe_to_template()
   - 토글 변경: report_update_subscription(enabled: true/false)
   - 구독 취소: report_unsubscribe_from_template()

4. 필터링:
   - 빈도별: frequency로 필터
   - 카테고리별: category_id로 필터
   - 구독 상태: is_subscribed로 필터
```

---

## 성능 최적화

### 1. 인덱스 추가 (권장)
```sql
-- notifications 테이블
CREATE INDEX IF NOT EXISTS idx_notifications_user_category
  ON notifications(user_id, category, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_notifications_data_session_id
  ON notifications USING gin((data->'session_id'));

-- report_users_subscription 테이블
CREATE INDEX IF NOT EXISTS idx_subscription_user_company
  ON report_users_subscription(user_id, company_id, enabled);

CREATE INDEX IF NOT EXISTS idx_subscription_template
  ON report_users_subscription(template_id, user_id);

-- report_generation_sessions 테이블
CREATE INDEX IF NOT EXISTS idx_sessions_status
  ON report_generation_sessions(status, created_at DESC);
```

### 2. 페이지네이션
- `get_user_received_reports`는 limit/offset 지원
- UI에서 무한 스크롤 또는 페이지네이션 구현

### 3. 클라이언트 사이드 캐싱
```dart
// 받은 리포트는 5분간 캐시
// 구독 목록은 10초간 캐시 (실시간 업데이트 필요)
```

---

## 에러 핸들링

모든 RPC 함수는 `SECURITY DEFINER`로 설정되어 있어 권한 체크를 자동으로 수행합니다.

**일반적인 에러**:
- `Template not found or not active`: 비활성화된 템플릿 구독 시도
- `Permission denied`: 다른 사용자의 데이터 접근 시도
- `Foreign key violation`: 존재하지 않는 템플릿/사용자 참조

---

## 메타데이터 활용

모든 RPC 함수는 `rpc_function_metadata` 테이블에 메타데이터가 저장되어 있습니다:

```dart
// 모든 report 함수 조회
final functions = await supabase
  .from('rpc_function_metadata')
  .select()
  .like('rpc_name', 'report_%')
  .eq('feature_id', '982fe5d5-d4d6-42bb-b8a7-cc653aa67a48');

// 함수 설명, 파라미터, 출력 형식 확인
for (var func in functions) {
  print('Function: ${func['rpc_name']}');
  print('Description: ${func['description']}');
  print('Parameters: ${func['parameters']}');
  print('Output: ${func['output_json']}');
}
```

---

## 테스트 쿼리

```sql
-- 1. 사용자의 받은 리포트 조회
SELECT * FROM report_get_user_received_reports(
  '0d2e61ad-e230-454e-8b90-efbe1c1a9268'::uuid,
  'ebd66ba7-fde7-4332-b6b5-0d8a7f615497'::uuid,
  20,
  0
);

-- 2. 구독 가능한 템플릿 + 구독 상태
SELECT * FROM report_get_available_templates_with_status(
  '0d2e61ad-e230-454e-8b90-efbe1c1a9268'::uuid,
  'ebd66ba7-fde7-4332-b6b5-0d8a7f615497'::uuid
);

-- 3. 통계
SELECT * FROM report_get_user_statistics(
  '0d2e61ad-e230-454e-8b90-efbe1c1a9268'::uuid,
  'ebd66ba7-fde7-4332-b6b5-0d8a7f615497'::uuid
);

-- 4. 리포트 읽음 표시
SELECT report_mark_as_read(
  '2c630643-5468-482c-bbd0-e8d6d47814f7'::uuid,
  '0d2e61ad-e230-454e-8b90-efbe1c1a9268'::uuid
);

-- 5. 구독 생성
SELECT * FROM report_subscribe_to_template(
  '0d2e61ad-e230-454e-8b90-efbe1c1a9268'::uuid,  -- user_id
  'ebd66ba7-fde7-4332-b6b5-0d8a7f615497'::uuid,  -- company_id
  NULL,                                           -- store_id (optional)
  'd7f54762-cfad-422b-8d85-b71d827d10f2'::uuid   -- template_id
);

-- 6. 구독 수정 (토글)
SELECT report_update_subscription(
  'cf2eb052-1317-49be-a1cd-8064c820c136'::uuid,  -- subscription_id
  '0d2e61ad-e230-454e-8b90-efbe1c1a9268'::uuid,  -- user_id
  false                                           -- enabled
);

-- 7. 구독 취소
SELECT report_unsubscribe_from_template(
  'cf2eb052-1317-49be-a1cd-8064c820c136'::uuid,
  '0d2e61ad-e230-454e-8b90-efbe1c1a9268'::uuid
);
```

---

## 다음 단계

1. ✅ RPC 함수 생성 완료
2. ⏳ Supabase에 마이그레이션 적용
3. ⏳ Domain entities 업데이트
4. ⏳ Data layer (DTOs, datasources) 업데이트
5. ⏳ Presentation layer (2-tab UI) 구현

---

## 권한 관리

현재 모든 함수는 `authenticated` 역할에 대해 실행 권한이 부여되어 있습니다.
각 함수 내부에서 `p_user_id`로 권한을 검증합니다.

추가 보안이 필요한 경우:
```sql
-- RLS (Row Level Security) 정책 추가 예시
ALTER TABLE report_users_subscription ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own subscriptions"
  ON report_users_subscription
  FOR SELECT
  USING (auth.uid() = user_id);
```
