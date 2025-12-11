# 🔧 Auth Feature - 수정 필요한 RPC 함수 목록

**대상**: `/lib/features/auth` 폴더
**수정자**: 개발자님 (직접 Supabase SQL 수정)

---

## 📋 수정해야 할 RPC 함수: **2개**

---

## 1. `join_business_by_code` ⚠️ **중요**

### 📍 위치
- **파일**: `lib/features/auth/data/datasources/supabase_company_datasource.dart`
- **라인**: 196-202
- **Supabase**: Database → Functions → `join_business_by_code`

### 🎯 호출 코드
```dart
final response = await _client.rpc(
  'join_business_by_code',
  params: {
    'p_user_id': userId,
    'p_business_code': companyCode,
  },
);
```

### 📊 현재 동작 (예상)
1. `companies` 테이블에서 `business_code`로 회사 찾기
2. **`user_companies` 테이블에 관계 INSERT** ← 여기가 문제!
3. 성공/실패 반환

### ❌ 문제점
RPC 함수 내부에서 `user_companies` 테이블에 INSERT 시:
```sql
-- 현재 (추정)
INSERT INTO user_companies (
  user_id,
  company_id,
  created_at,
  updated_at
) VALUES (
  p_user_id,
  v_company_id,
  NOW(),      -- ❌ timestamp without timezone
  NOW()       -- ❌ timestamp without timezone
);
```

### ✅ 수정 방법
```sql
-- 수정 후
INSERT INTO user_companies (
  user_id,
  company_id,
  created_at,
  created_at_utc,    -- ✅ 추가
  updated_at,
  updated_at_utc     -- ✅ 추가
) VALUES (
  p_user_id,
  v_company_id,
  NOW(),
  NOW() AT TIME ZONE 'UTC',    -- ✅ 추가
  NOW(),
  NOW() AT TIME ZONE 'UTC'     -- ✅ 추가
);
```

### 🔍 RPC 함수 찾는 방법
1. Supabase Dashboard 로그인
2. Database → Functions 메뉴
3. `join_business_by_code` 검색
4. SQL 코드 확인 및 수정

### ⚠️ 테스트 필요 사항
- 기존 앱에서 회사 참여 시도
- 신규 앱에서 회사 참여 시도
- `user_companies` 테이블에 `created_at_utc`, `updated_at_utc` 정상 입력 확인

---

## 2. `get_user_companies_and_stores` ℹ️ **선택적** (Phase 2)

### 📍 위치
- **파일**: `lib/features/auth/data/datasources/supabase_user_datasource.dart`
- **라인**: 212-215
- **Supabase**: Database → Functions → `get_user_companies_and_stores`

### 🎯 호출 코드
```dart
final response = await _client.rpc(
  'get_user_companies_and_stores',
  params: {'p_user_id': userId},
);
```

### 📊 현재 동작 (예상)
1. 사용자가 접근 가능한 회사 목록 조회
2. 각 회사별 매장 목록 조회
3. JOIN된 데이터 반환

### ❌ 현재 문제 (Phase 1에서는 괜찮음)
```sql
-- 현재 (추정)
SELECT
  c.company_id,
  c.company_name,
  c.created_at,      -- ❌ 기존 timestamp만 반환
  c.updated_at,      -- ❌ 기존 timestamp만 반환
  -- ... stores data
FROM companies c
-- ... joins
```

### ✅ 수정 방법 (Phase 2에서)
```sql
-- 수정 후
SELECT
  c.company_id,
  c.company_name,
  c.created_at,
  c.created_at_utc,      -- ✅ 추가
  c.updated_at,
  c.updated_at_utc,      -- ✅ 추가
  c.deleted_at,
  c.deleted_at_utc,      -- ✅ 추가
  s.store_id,
  s.store_name,
  s.created_at as store_created_at,
  s.created_at_utc as store_created_at_utc,    -- ✅ 추가
  s.updated_at as store_updated_at,
  s.updated_at_utc as store_updated_at_utc     -- ✅ 추가
FROM companies c
LEFT JOIN user_companies uc ON c.company_id = uc.company_id
LEFT JOIN stores s ON c.company_id = s.company_id
LEFT JOIN user_stores us ON s.store_id = us.store_id
WHERE uc.user_id = p_user_id
  AND uc.is_deleted = false
  -- ... other conditions
```

### 📅 수정 시점
- **Phase 1**: 수정 안 해도 됨 (읽기 전용, 기존 컬럼 사용)
- **Phase 2**: Dual-Read 전환 시 `_utc` 컬럼 포함 필요

### ⚠️ 주의사항
- DTO에 `_utc` 필드가 추가된 후에 수정
- Flutter 코드에서 `_utc` 컬럼 우선 읽도록 변경 후

---

## 📋 수정 우선순위

### 🔴 Phase 1 (즉시 수정 필요)
1. ✅ `join_business_by_code` - INSERT 시 `_utc` 컬럼 추가

### 🟡 Phase 2 (나중에 수정)
2. ⏳ `get_user_companies_and_stores` - SELECT 결과에 `_utc` 컬럼 포함

---

## 🧪 테스트 가이드

### join_business_by_code 테스트

#### 1. 수정 전 테스트
```sql
-- 현재 데이터 확인
SELECT
  user_id,
  company_id,
  created_at,
  created_at_utc,
  updated_at,
  updated_at_utc
FROM user_companies
ORDER BY created_at DESC
LIMIT 5;
```

#### 2. RPC 함수 수정

#### 3. 수정 후 테스트
```dart
// Flutter 테스트 코드
final result = await companyDataSource.joinCompanyByCode(
  companyCode: 'TEST123',
  userId: 'test-user-id',
);
```

#### 4. 데이터 검증
```sql
-- 최신 데이터 확인
SELECT
  user_id,
  company_id,
  created_at,
  created_at_utc,        -- ✅ 값이 있어야 함
  updated_at,
  updated_at_utc,        -- ✅ 값이 있어야 함
  CASE
    WHEN created_at::timestamptz = created_at_utc THEN 'OK'
    ELSE 'MISMATCH'
  END as sync_status
FROM user_companies
ORDER BY created_at DESC
LIMIT 1;
```

---

## 🔍 RPC 함수 찾는 방법

### Supabase Dashboard
1. https://supabase.com → 프로젝트 선택
2. 좌측 메뉴: **Database** → **Functions**
3. 검색: `join_business_by_code`
4. 함수 클릭 → SQL 코드 확인

### SQL Editor에서 직접
```sql
-- RPC 함수 정의 확인
SELECT
  proname as function_name,
  pg_get_functiondef(oid) as definition
FROM pg_proc
WHERE proname IN (
  'join_business_by_code',
  'get_user_companies_and_stores'
);
```

---

## 📝 체크리스트

### join_business_by_code 수정
- [ ] RPC 함수 SQL 코드 확인
- [ ] `user_companies` INSERT 문 찾기
- [ ] `created_at_utc`, `updated_at_utc` 컬럼 추가
- [ ] 함수 저장 및 배포
- [ ] 로컬/스테이징 환경 테스트
- [ ] 데이터베이스에서 `_utc` 값 확인
- [ ] 기존 앱 하위 호환성 확인
- [ ] 프로덕션 배포

### get_user_companies_and_stores 수정 (Phase 2)
- [ ] Phase 1 완료 및 모니터링 (2-4주)
- [ ] DTO에 `_utc` 필드 추가 확인
- [ ] Flutter 코드 Dual-Read 전환 확인
- [ ] RPC 함수 SELECT 절에 `_utc` 컬럼 추가
- [ ] 함수 저장 및 배포
- [ ] 테스트
- [ ] 프로덕션 배포

---

## 💡 팁

### 1. 안전한 수정 순서
```
1. 개발 환경에서 RPC 함수 수정
2. 로컬 Flutter 앱에서 테스트
3. 스테이징 환경 배포
4. 스테이징 테스트
5. 프로덕션 배포
```

### 2. 롤백 계획
수정 전 현재 RPC 함수 코드를 백업해두세요:
```sql
-- 백업 방법
SELECT pg_get_functiondef('join_business_by_code'::regproc);
```

### 3. 데이터 검증 쿼리
```sql
-- 전체 데이터 일치 여부 확인
SELECT
  COUNT(*) as total_rows,
  COUNT(created_at_utc) as utc_filled,
  COUNT(*) - COUNT(created_at_utc) as utc_missing,
  ROUND(100.0 * COUNT(created_at_utc) / COUNT(*), 2) as fill_percentage
FROM user_companies;
```

---

## 🆘 문제 발생 시

### RPC 함수가 안 보여요
- Database → Functions 메뉴 확인
- SQL Editor에서 `\df` 명령어 실행
- `pg_proc` 테이블 직접 조회

### 수정 후 에러 발생
1. RPC 함수 구문 오류 확인
2. 컬럼명 오타 확인 (`created_at_utc` vs `createdAtUtc`)
3. 데이터 타입 확인 (`timestamptz`)
4. 기존 코드로 롤백 후 재시도

### 기존 앱에서 에러 발생
- 기존 앱은 `_utc` 컬럼 몰라도 괜찮음 (INSERT만 추가)
- 기존 컬럼도 계속 작성하므로 호환성 유지
- 만약 문제 생기면 즉시 롤백

---

**작성일**: 2025-11-24
**담당**: 개발자님
**지원**: Claude (질문 있으면 언제든지!)
