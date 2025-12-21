# Report UUID 에러 해결 가이드

## 문제 설명

```
DataSourceException: Database error in getUserReceivedReports:
invalid input syntax for type uuid: "test-cash-location-001"
```

### 원인
- `notifications` 테이블의 `data` 컬럼에 잘못된 `subscription_id` 저장됨
- 저장된 값: `"test-cash-location-001"`, `"test-cash-location-002"` (문자열)
- 필요한 값: UUID 형식 (예: `550e8400-e29b-41d4-a716-446655440000`)

### 영향받는 데이터
```json
{
  "notification_id": "1ab09bc9-8fd1-41b1-87a3-38a4e5fab9fa",
  "subscription_id": "test-cash-location-001"  // ❌ 잘못된 UUID
}
```

---

## 해결 방법 (3가지 옵션)

### ✅ 옵션 1: 마이그레이션 적용 (권장)

RPC 함수를 수정하여 잘못된 UUID를 자동으로 NULL로 처리합니다.

#### 1. Supabase CLI로 마이그레이션 적용

```bash
# Supabase 프로젝트에 연결되어 있는지 확인
supabase status

# 마이그레이션 적용
supabase db push
```

#### 2. Supabase Dashboard에서 수동 적용

1. [Supabase Dashboard](https://app.supabase.com) 접속
2. **SQL Editor** 메뉴로 이동
3. `supabase/migrations/fix_report_uuid_validation.sql` 파일 내용 복사
4. SQL Editor에 붙여넣고 **Run** 클릭

---

### 옵션 2: 잘못된 데이터 삭제

테스트 데이터이므로 삭제하는 것도 좋은 방법입니다.

```sql
-- Supabase Dashboard > SQL Editor에서 실행
DELETE FROM notifications
WHERE category = 'report'
  AND (
    data->>'subscription_id' LIKE 'test-cash-location-%'
    OR data->>'subscription_id' !~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
  );
```

---

### 옵션 3: 임시 회피 (앱 재시작)

데이터를 수정할 수 없는 경우, 앱을 재시작하여 캐시를 초기화합니다.

```bash
# Flutter 앱 재시작
flutter clean
flutter run
```

---

## 마이그레이션 후 확인

### 1. RPC 함수 테스트

```sql
-- Supabase Dashboard > SQL Editor
SELECT * FROM report_get_user_received_reports(
  '0d2e61ad-e230-454e-8b90-efbe1c1a9268'::uuid,  -- your user_id
  NULL,
  10,
  0
);
```

### 2. Flutter 앱에서 확인

1. Report Control 페이지로 이동
2. "Received Reports" 탭 확인
3. 에러 메시지가 사라지고 리포트 목록이 표시되어야 함

---

## 향후 예방 방법

### 1. Notification 생성 시 UUID 검증

[lib/core/notifications/repositories/notification_repository.dart](lib/core/notifications/repositories/notification_repository.dart)에서 UUID 검증 추가:

```dart
Future<void> createReportNotification({
  required String subscriptionId,
  // ...
}) async {
  // ✅ UUID 형식 검증
  if (!_isValidUUID(subscriptionId)) {
    throw ArgumentError('Invalid subscription_id format: $subscriptionId');
  }

  // ...
}

bool _isValidUUID(String str) {
  final uuidRegex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    caseSensitive: false,
  );
  return uuidRegex.hasMatch(str);
}
```

### 2. 데이터베이스 제약조건 추가

```sql
-- notifications 테이블에 CHECK 제약조건 추가
ALTER TABLE notifications
ADD CONSTRAINT check_report_data_uuids
CHECK (
  category != 'report' OR (
    (data->>'subscription_id' IS NULL OR
     data->>'subscription_id' ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
    AND
    (data->>'template_id' IS NULL OR
     data->>'template_id' ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
    AND
    (data->>'session_id' IS NULL OR
     data->>'session_id' ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
  )
);
```

---

## 문의

이 가이드로 해결되지 않는 경우:
1. 에러 로그 전체 내용 확인
2. Supabase logs 확인: `supabase logs db`
3. Flutter logs 확인: `flutter logs`
