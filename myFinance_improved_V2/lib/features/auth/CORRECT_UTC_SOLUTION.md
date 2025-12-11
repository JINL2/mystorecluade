# ✅ 정확한 UTC 마이그레이션 해결책

## 🎯 현재 상황 정리

### INSERT 시 현재 동작

```dart
// Flutter 코드 (supabase_company_datasource.dart:67)
await _client.from('companies').insert(companyData);
```

```javascript
// companyData 내용 (예상)
{
  "company_name": "My Company",
  "owner_id": "user-123",
  "company_type_id": "type-1"
  // ❌ created_at을 명시적으로 전달하지 않음!
}
```

### Database에서 자동 처리

```sql
-- companies 테이블 정의
CREATE TABLE companies (
  company_id UUID PRIMARY KEY,
  company_name TEXT,
  owner_id UUID,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- ✅ 자동 생성
  created_at_utc TIMESTAMPTZ DEFAULT NULL          -- ❌ NULL로 저장됨
);
```

**결과**:
- ✅ `created_at`: `2025-11-24 15:30:00` (자동 생성)
- ❌ `created_at_utc`: `NULL` (기본값 없음)

---

## 🔍 문제점

### 1. created_at은 자동 생성되지만...
```sql
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```
- ✅ 자동으로 값이 들어감
- ❌ 하지만 **timezone 정보 없음** (timestamp without time zone)

### 2. created_at_utc는 NULL
```sql
created_at_utc TIMESTAMPTZ DEFAULT NULL
```
- ❌ 기본값이 없어서 **NULL로 저장됨**
- Flutter에서 명시적으로 값을 주지 않으면 비어있음

---

## ✅ 해결책: Database 트리거 사용

### 왜 트리거가 필요한가?

**Flutter 코드는 수정 안 하고** Database에서 자동으로 처리하기 위해!

```dart
// ✅ 이 코드 그대로 유지
await _client.from('companies').insert({
  'company_name': 'My Company',
  'owner_id': 'user-123',
  // created_at 전달 안 함 (Database가 자동 생성)
  // created_at_utc 전달 안 함 (트리거가 자동 생성)
});
```

### 트리거가 하는 일

```sql
-- BEFORE INSERT 트리거
-- 1. created_at이 DEFAULT로 생성됨 (CURRENT_TIMESTAMP)
-- 2. 트리거가 created_at 값을 보고 created_at_utc 자동 계산
-- 3. 최종 저장

INSERT 실행 → created_at = NOW() → 트리거 동작 → created_at_utc 계산 → 저장
```

---

## 🎯 구체적인 구현 방법

### Step 1: 트리거 함수 생성

```sql
-- 이 함수가 모든 테이블에서 재사용됨
CREATE OR REPLACE FUNCTION sync_timestamp_to_utc()
RETURNS TRIGGER AS $$
BEGIN
  -- INSERT나 UPDATE 시 자동 실행

  -- created_at이 있으면 (자동 생성되었거나 명시적으로 전달됨)
  IF NEW.created_at IS NOT NULL AND NEW.created_at_utc IS NULL THEN
    -- created_at을 UTC로 변환해서 created_at_utc에 저장
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  -- updated_at도 동일하게 처리
  IF NEW.updated_at IS NOT NULL THEN
    NEW.updated_at_utc := NEW.updated_at AT TIME ZONE 'UTC';
  END IF;

  -- deleted_at도 동일하게 처리
  IF NEW.deleted_at IS NOT NULL AND NEW.deleted_at_utc IS NULL THEN
    NEW.deleted_at_utc := NEW.deleted_at AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Step 2: 각 테이블에 트리거 적용

```sql
-- companies 테이블
DROP TRIGGER IF EXISTS sync_companies_timestamp_to_utc ON companies;
CREATE TRIGGER sync_companies_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON companies
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

-- users 테이블
DROP TRIGGER IF EXISTS sync_users_timestamp_to_utc ON users;
CREATE TRIGGER sync_users_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

-- stores 테이블
DROP TRIGGER IF EXISTS sync_stores_timestamp_to_utc ON stores;
CREATE TRIGGER sync_stores_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

-- user_companies 테이블
DROP TRIGGER IF EXISTS sync_user_companies_timestamp_to_utc ON user_companies;
CREATE TRIGGER sync_user_companies_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON user_companies
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

-- user_stores 테이블
DROP TRIGGER IF EXISTS sync_user_stores_timestamp_to_utc ON user_stores;
CREATE TRIGGER sync_user_stores_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON user_stores
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();
```

---

## 🧪 테스트: 트리거가 잘 작동하는지 확인

### 테스트 1: INSERT (created_at 전달 안 함)

```sql
-- 1. 데이터 INSERT (created_at 명시 안 함)
INSERT INTO companies (company_id, company_name, owner_id)
VALUES (
  gen_random_uuid(),
  'Test Company',
  'test-user-id'
);
-- created_at: DEFAULT로 자동 생성
-- created_at_utc: 트리거가 자동 생성

-- 2. 확인
SELECT
  company_name,
  created_at,
  created_at_utc,
  created_at_utc IS NOT NULL as utc_filled
FROM companies
WHERE company_name = 'Test Company';

-- 예상 결과:
-- created_at:     2025-11-24 15:30:00
-- created_at_utc: 2025-11-24 06:30:00+00  (UTC로 변환됨)
-- utc_filled:     true
```

### 테스트 2: UPDATE (updated_at 명시적으로 전달)

```sql
-- 1. UPDATE
UPDATE companies
SET
  company_name = 'Updated Company',
  updated_at = NOW()  -- 명시적으로 전달
WHERE company_name = 'Test Company';
-- updated_at: 전달한 값 사용
-- updated_at_utc: 트리거가 자동 생성

-- 2. 확인
SELECT
  company_name,
  updated_at,
  updated_at_utc,
  updated_at_utc IS NOT NULL as utc_filled
FROM companies
WHERE company_name = 'Updated Company';
```

### 테스트 3: Flutter에서 INSERT

```dart
// Flutter 테스트
await _client.from('companies').insert({
  'company_name': 'Flutter Test Company',
  'owner_id': 'test-user-id',
  // created_at 전달 안 함
});

// Database에서 확인
// SELECT * FROM companies WHERE company_name = 'Flutter Test Company';
// 예상:
// created_at: 자동 생성됨 ✅
// created_at_utc: 트리거가 자동 생성됨 ✅
```

---

## 🎯 각 시나리오별 동작

### 시나리오 1: INSERT - created_at 전달 안 함 (현재 방식)

```dart
// Flutter 코드
await _client.from('companies').insert({
  'company_name': 'My Company',
  'owner_id': 'user-123',
});
```

**Database 동작**:
1. INSERT 실행
2. `created_at` → `DEFAULT CURRENT_TIMESTAMP` 적용 → `2025-11-24 15:30:00`
3. 트리거 실행 → `created_at_utc` 계산 → `2025-11-24 06:30:00+00`
4. 최종 저장 ✅

### 시나리오 2: INSERT - created_at 명시적으로 전달

```dart
// Flutter 코드 (만약 명시적으로 전달한다면)
await _client.from('companies').insert({
  'company_name': 'My Company',
  'owner_id': 'user-123',
  'created_at': DateTime.now().toIso8601String(),
});
```

**Database 동작**:
1. INSERT 실행
2. `created_at` → Flutter가 전달한 값 사용 → `2025-11-24 15:30:00`
3. 트리거 실행 → `created_at_utc` 계산 → `2025-11-24 06:30:00+00`
4. 최종 저장 ✅

### 시나리오 3: UPDATE - updated_at 명시적으로 전달

```dart
// Flutter 코드
await _client.from('companies').update({
  'company_name': 'Updated Name',
  'updated_at': DateTime.now().toIso8601String(),
});
```

**Database 동작**:
1. UPDATE 실행
2. `updated_at` → Flutter가 전달한 값 사용 → `2025-11-24 15:30:00`
3. 트리거 실행 → `updated_at_utc` 계산 → `2025-11-24 06:30:00+00`
4. 최종 저장 ✅

### 시나리오 4: RPC 함수 - INSERT

```sql
-- RPC 함수 내부
INSERT INTO user_companies (user_id, company_id)
VALUES (p_user_id, v_company_id);
-- created_at: DEFAULT로 자동
-- created_at_utc: 트리거가 자동
```

**Database 동작**:
1. RPC INSERT 실행
2. `created_at` → `DEFAULT CURRENT_TIMESTAMP` 적용
3. 트리거 실행 → `created_at_utc` 계산
4. 최종 저장 ✅

---

## ✅ 최종 결론

### 코드 수정 불필요!

#### Flutter 코드
```dart
// ✅ 그대로 유지
await _client.from('companies').insert(companyData);
// created_at 전달 안 함 → Database DEFAULT 사용
// created_at_utc 전달 안 함 → 트리거가 자동 생성
```

#### RPC 함수
```sql
-- ✅ 그대로 유지
INSERT INTO user_companies (user_id, company_id)
VALUES (p_user_id, v_company_id);
-- created_at: DEFAULT
-- created_at_utc: 트리거
```

### 트리거만 설치하면 끝!

```sql
-- 1. 함수 생성 (1번만)
CREATE FUNCTION sync_timestamp_to_utc() ...

-- 2. 트리거 적용 (각 테이블)
CREATE TRIGGER ... ON companies ...
CREATE TRIGGER ... ON users ...
CREATE TRIGGER ... ON stores ...
CREATE TRIGGER ... ON user_companies ...
CREATE TRIGGER ... ON user_stores ...

-- 3. 기존 데이터 마이그레이션
UPDATE companies SET updated_at = updated_at;
UPDATE users SET updated_at = updated_at;
-- (트리거가 실행되면서 _utc 컬럼 자동 채워짐)
```

---

## 🎉 장점

1. ✅ **Flutter 코드 수정 불필요**
   - INSERT: 그대로 유지 (created_at 전달 안 함)
   - UPDATE: 그대로 유지 (updated_at만 전달)

2. ✅ **RPC 함수 수정 불필요**
   - 트리거가 자동 처리

3. ✅ **데이터 일관성 100% 보장**
   - 모든 INSERT/UPDATE에서 자동 처리
   - 실수 불가능

4. ✅ **하위 호환성 유지**
   - 기존 컬럼도 계속 사용
   - 구 앱과 신 앱 공존 가능

5. ✅ **유지보수 쉬움**
   - 트리거 하나로 모든 테이블 관리

---

## 📋 실행 계획

### 1단계: 트리거 설치 (오늘)
```sql
-- Supabase SQL Editor에서 실행
-- 위의 트리거 SQL 복사 & 실행
```

### 2단계: 테스트 (오늘)
```sql
-- 테스트 데이터 INSERT/UPDATE
-- created_at_utc 값 확인
```

### 3단계: 기존 데이터 마이그레이션 (오늘)
```sql
-- NULL인 데이터 채우기
UPDATE companies SET updated_at = updated_at;
```

### 4단계: 배포 (내일)
```
-- Flutter 앱 재배포 불필요!
-- 트리거만 설치하면 바로 적용됨
```

---

## 🤔 자주 묻는 질문

### Q1: created_at을 Flutter에서 명시적으로 전달하면?
**A**: 트리거가 그 값을 받아서 UTC로 변환합니다. 문제없습니다!

### Q2: 트리거 성능 영향은?
**A**: 거의 없습니다. 단순 계산만 하므로 밀리초 이하.

### Q3: 기존 앱에 영향은?
**A**: 전혀 없습니다. 기존 컬럼은 그대로 동작합니다.

### Q4: RPC 함수도 수정 안 해도 되나요?
**A**: 네! 트리거가 자동으로 처리합니다.

### Q5: CURRENT_TIMESTAMP는 어느 타임존인가요?
**A**: Supabase 서버의 타임존입니다. 보통 UTC입니다.

---

**핵심**: 트리거 설치로 모든 문제 해결! 코드 수정 불필요! 🚀
