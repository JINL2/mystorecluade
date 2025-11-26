# 🎯 UTC 마이그레이션 - 실제 해결 방법

## 🔍 발견한 문제점

### 1. **CURRENT_TIMESTAMP의 문제**
```sql
-- 현재 테이블 구조
created_at: timestamp without time zone, DEFAULT: CURRENT_TIMESTAMP
created_at_utc: timestamp with time zone, DEFAULT: NULL
```

**문제**:
- `CURRENT_TIMESTAMP`는 **서버의 로컬 타임존**을 사용
- Supabase 서버가 어느 타임존에 있는지에 따라 값이 달라짐
- `created_at_utc`는 기본값이 없어서 **NULL로 저장됨**

### 2. **Database 트리거 없음**
- `user_companies` 테이블에 자동 동기화 트리거가 **없음**
- `created_at` → `created_at_utc` 자동 변환 안 됨

---

## ✅ 해결 방법: 3가지 옵션

### 🎯 **옵션 1: Database 트리거 사용** (추천)

#### 장점
- ✅ 모든 INSERT/UPDATE에서 자동 처리
- ✅ RPC, Flutter 코드 수정 최소화
- ✅ 데이터 일관성 보장
- ✅ 실수 방지

#### 단점
- ⚠️ Database 마이그레이션 필요
- ⚠️ 모든 테이블에 트리거 생성 필요

#### 구현 방법

```sql
-- Step 1: 트리거 함수 생성 (공통)
CREATE OR REPLACE FUNCTION sync_timestamp_to_utc()
RETURNS TRIGGER AS $$
BEGIN
  -- INSERT나 UPDATE 시 자동으로 UTC 컬럼 채우기
  IF NEW.created_at IS NOT NULL THEN
    -- created_at이 timestamp without timezone이므로
    -- 서버 타임존으로 해석 후 UTC로 변환
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  IF NEW.updated_at IS NOT NULL THEN
    NEW.updated_at_utc := NEW.updated_at AT TIME ZONE 'UTC';
  END IF;

  IF NEW.deleted_at IS NOT NULL THEN
    NEW.deleted_at_utc := NEW.deleted_at AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: user_companies 테이블에 트리거 적용
CREATE TRIGGER sync_user_companies_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON user_companies
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

-- Step 3: companies 테이블에 트리거 적용
CREATE TRIGGER sync_companies_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON companies
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

-- Step 4: users 테이블에 트리거 적용
CREATE TRIGGER sync_users_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

-- Step 5: stores 테이블에 트리거 적용
CREATE TRIGGER sync_stores_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

-- Step 6: user_stores 테이블에 트리거 적용
CREATE TRIGGER sync_user_stores_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON user_stores
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();
```

#### 테스트
```sql
-- 테스트: user_companies에 데이터 INSERT
INSERT INTO user_companies (user_id, company_id)
VALUES ('test-user', 'test-company');

-- 확인: created_at_utc가 자동으로 채워졌는지 확인
SELECT
  user_id,
  created_at,
  created_at_utc,
  updated_at,
  updated_at_utc
FROM user_companies
WHERE user_id = 'test-user';
```

---

### 🎯 **옵션 2: 컬럼 기본값 변경** (간단하지만 제한적)

#### 장점
- ✅ 구현 간단
- ✅ 자동 처리

#### 단점
- ❌ DEFAULT는 INSERT에만 적용 (UPDATE 안 됨)
- ❌ 명시적으로 값 전달 시 작동 안 함

#### 구현 방법
```sql
-- created_at_utc에 기본값 설정
ALTER TABLE user_companies
  ALTER COLUMN created_at_utc
  SET DEFAULT (NOW() AT TIME ZONE 'UTC');

ALTER TABLE user_companies
  ALTER COLUMN updated_at_utc
  SET DEFAULT (NOW() AT TIME ZONE 'UTC');

-- 다른 테이블도 동일하게
ALTER TABLE companies ALTER COLUMN created_at_utc SET DEFAULT (NOW() AT TIME ZONE 'UTC');
ALTER TABLE companies ALTER COLUMN updated_at_utc SET DEFAULT (NOW() AT TIME ZONE 'UTC');
ALTER TABLE users ALTER COLUMN created_at_utc SET DEFAULT (NOW() AT TIME ZONE 'UTC');
ALTER TABLE users ALTER COLUMN updated_at_utc SET DEFAULT (NOW() AT TIME ZONE 'UTC');
ALTER TABLE stores ALTER COLUMN created_at_utc SET DEFAULT (NOW() AT TIME ZONE 'UTC');
ALTER TABLE stores ALTER COLUMN updated_at_utc SET DEFAULT (NOW() AT TIME ZONE 'UTC');
```

**문제점**:
```dart
// ❌ 이렇게 명시적으로 값을 주면 DEFAULT 작동 안 함
.update({
  'updated_at': DateTime.now().toIso8601String(),
  // updated_at_utc는 NULL로 저장됨
})
```

---

### 🎯 **옵션 3: Flutter 코드에서 직접 처리** (현재 방식)

#### 장점
- ✅ Database 변경 불필요
- ✅ 명시적 제어

#### 단점
- ❌ 모든 INSERT/UPDATE 코드 수정 필요
- ❌ 실수 가능성 높음
- ❌ RPC 함수도 전부 수정 필요

#### 구현 예시
```dart
// Flutter에서 명시적으로 전달
final now = DateTime.now();
await _client.from('user_companies').insert({
  'user_id': userId,
  'company_id': companyId,
  'created_at': now.toIso8601String(),
  'created_at_utc': now.toUtc().toIso8601String(),
  'updated_at': now.toIso8601String(),
  'updated_at_utc': now.toUtc().toIso8601String(),
});
```

---

## 🏆 추천 방안: **옵션 1 (트리거) + 옵션 3 (명시적 코드)**

### 왜?
1. **트리거 = 안전망**: 빠뜨린 코드가 있어도 자동으로 채워짐
2. **명시적 코드 = 명확성**: 어떤 값이 들어가는지 코드에서 명확히 보임
3. **Dual 방식 = 최고 안정성**: 두 가지 모두 작동

### 구현 순서

#### 1단계: Database 트리거 설정
```sql
-- 위의 트리거 SQL 실행
-- 5개 테이블 모두 적용
```

#### 2단계: Flutter 코드는 그대로 (트리거가 처리)
```dart
// ✅ 이렇게만 해도 트리거가 _utc 컬럼 자동 채움
await _client.from('companies').update({
  'updated_at': DateTime.now().toIso8601String(),
}).eq('company_id', companyId);

// 트리거가 자동으로:
// updated_at_utc = updated_at AT TIME ZONE 'UTC'
```

#### 3단계: RPC 함수도 간단하게
```sql
-- RPC에서도 기존 컬럼만 설정
INSERT INTO user_companies (user_id, company_id)
VALUES (p_user_id, v_company_id);
-- created_at은 DEFAULT로 자동
-- created_at_utc는 트리거로 자동
```

---

## 🤔 "타임존 없이 NOW()를 보낼 수 있나요?"

### 답변: 서버에서 처리하는 게 더 안전합니다

#### ❌ Flutter에서 NOW() 보내기 (문제 있음)
```dart
// 문제 1: 기기의 로컬 시간 사용
DateTime.now()  // 한국: 2025-11-24 15:00:00 KST

// 문제 2: UTC 변환 시 기기 타임존 의존
DateTime.now().toUtc()  // 2025-11-24 06:00:00 UTC

// 문제 3: 문자열로 변환 시 타임존 정보 손실
DateTime.now().toIso8601String()  // "2025-11-24T15:00:00.000"
```

**문제점**: 사용자가 **잘못된 타임존 설정**을 하면 데이터가 틀어짐

#### ✅ Database에서 NOW() 처리 (안전함)
```sql
-- 서버는 항상 정확한 시간 유지
created_at = NOW()  -- 서버의 현재 시간
created_at_utc = NOW() AT TIME ZONE 'UTC'  -- 정확한 UTC
```

---

## 🎯 최종 권장 방안

### Phase 1: 트리거 설치 (1일)

```sql
-- 1. 트리거 함수 생성
CREATE OR REPLACE FUNCTION sync_timestamp_to_utc()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.created_at IS NOT NULL THEN
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  IF NEW.updated_at IS NOT NULL THEN
    NEW.updated_at_utc := NEW.updated_at AT TIME ZONE 'UTC';
  END IF;

  IF NEW.deleted_at IS NOT NULL THEN
    NEW.deleted_at_utc := NEW.deleted_at AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. 모든 테이블에 적용
CREATE TRIGGER sync_companies_utc BEFORE INSERT OR UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION sync_timestamp_to_utc();
CREATE TRIGGER sync_users_utc BEFORE INSERT OR UPDATE ON users FOR EACH ROW EXECUTE FUNCTION sync_timestamp_to_utc();
CREATE TRIGGER sync_stores_utc BEFORE INSERT OR UPDATE ON stores FOR EACH ROW EXECUTE FUNCTION sync_timestamp_to_utc();
CREATE TRIGGER sync_user_companies_utc BEFORE INSERT OR UPDATE ON user_companies FOR EACH ROW EXECUTE FUNCTION sync_timestamp_to_utc();
CREATE TRIGGER sync_user_stores_utc BEFORE INSERT OR UPDATE ON user_stores FOR EACH ROW EXECUTE FUNCTION sync_timestamp_to_utc();

-- 3. 기존 데이터 마이그레이션
UPDATE companies SET updated_at = updated_at WHERE created_at_utc IS NULL;
UPDATE users SET updated_at = updated_at WHERE created_at_utc IS NULL;
UPDATE stores SET updated_at = updated_at WHERE created_at_utc IS NULL;
UPDATE user_companies SET updated_at = updated_at WHERE created_at_utc IS NULL;
UPDATE user_stores SET updated_at = updated_at WHERE created_at_utc IS NULL;
```

### Phase 2: Flutter 코드는 최소 수정 (1-2일)

**수정 필요한 부분만** (UPDATE에서 updated_at을 명시적으로 설정하는 곳):
```dart
// Before
'updated_at': DateTime.now().toIso8601String()

// After - 그대로 두면 됨! 트리거가 처리
'updated_at': DateTime.now().toIso8601String()
```

**RPC 함수도 수정 불필요**:
```sql
-- 트리거가 알아서 처리하므로 기존 코드 그대로
INSERT INTO user_companies (user_id, company_id)
VALUES (p_user_id, v_company_id);
```

### Phase 3: 모니터링 (2주)

```sql
-- 데이터 품질 확인
SELECT
  'companies' as table_name,
  COUNT(*) as total,
  COUNT(created_at_utc) as utc_filled,
  ROUND(100.0 * COUNT(created_at_utc) / COUNT(*), 2) as fill_rate
FROM companies
UNION ALL
SELECT 'users', COUNT(*), COUNT(created_at_utc), ROUND(100.0 * COUNT(created_at_utc) / COUNT(*), 2) FROM users
UNION ALL
SELECT 'stores', COUNT(*), COUNT(created_at_utc), ROUND(100.0 * COUNT(created_at_utc) / COUNT(*), 2) FROM stores;
```

---

## 🎉 결론

### ✅ 해야 할 일
1. **Database 트리거 설치** (가장 중요!)
2. **기존 데이터 마이그레이션** (UPDATE 문 실행)
3. **모니터링 및 검증**

### ❌ 안 해도 되는 일
1. ~~Flutter 코드 대량 수정~~ (트리거가 처리)
2. ~~RPC 함수 수정~~ (트리거가 처리)
3. ~~수동으로 UTC 변환~~ (트리거가 처리)

### 🚀 장점
- 코드 수정 최소화
- 자동으로 데이터 일관성 보장
- 실수 방지
- 유지보수 쉬움

**트리거 한 번 설치하면 모든 문제 해결!** 🎯
