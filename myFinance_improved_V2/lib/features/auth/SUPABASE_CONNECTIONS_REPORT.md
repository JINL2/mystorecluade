# 🔍 Supabase 연결 분석 보고서 - Auth Feature

**분석 대상**: `/lib/features/auth`
**분석 일자**: 2025-11-24
**목적**: UTC 마이그레이션을 위한 모든 Supabase 연결 파악

---

## 📊 1. RPC 함수 호출

| 파일 경로 | 라인 | 타입 | 함수명 | 파라미터 | 시간 관련 컬럼 | 비고 |
|-----------|------|------|--------|----------|----------------|------|
| lib/features/auth/data/datasources/supabase_company_datasource.dart | 196-202 | RPC | join_business_by_code | p_user_id, p_business_code | ⚠️ **RPC 내부에서 user_companies INSERT** | 수동 수정 필요 |
| lib/features/auth/data/datasources/supabase_user_datasource.dart | 212-215 | RPC | get_user_companies_and_stores | p_user_id | ⚠️ **SELECT only** | 읽기 전용 - Phase 2에서 수정 |

### RPC 함수 상세 분석

#### 1. `join_business_by_code`
**파일**: `supabase_company_datasource.dart:196`

```dart
final response = await _client.rpc(
  'join_business_by_code',
  params: {
    'p_user_id': userId,
    'p_business_code': companyCode,
  },
);
```

**예상 RPC 동작**:
- `companies` 테이블에서 business_code로 조회
- `user_companies` 테이블에 관계 INSERT
- 현재: `created_at` 만 설정
- **수정 필요**: `created_at_utc` 추가

**데이터베이스 RPC 수정 예시**:
```sql
INSERT INTO user_companies (
  user_id,
  company_id,
  created_at,
  created_at_utc,  -- ✅ 추가 필요
  updated_at,
  updated_at_utc   -- ✅ 추가 필요
) VALUES (
  p_user_id,
  v_company_id,
  NOW(),
  NOW() AT TIME ZONE 'UTC',  -- ✅ 추가
  NOW(),
  NOW() AT TIME ZONE 'UTC'   -- ✅ 추가
);
```

---

#### 2. `get_user_companies_and_stores`
**파일**: `supabase_user_datasource.dart:212`

```dart
final response = await _client.rpc(
  'get_user_companies_and_stores',
  params: {'p_user_id': userId},
);
```

**예상 RPC 동작**:
- `companies`, `stores`, `user_companies`, `user_stores` JOIN
- 사용자가 접근 가능한 회사 및 매장 목록 반환
- **현재**: 기존 timestamp 컬럼 반환
- **Phase 2 수정**: `_utc` 컬럼도 함께 반환

**데이터베이스 RPC 수정 예시** (Phase 2):
```sql
SELECT
  c.company_id,
  c.company_name,
  c.created_at,
  c.created_at_utc,  -- ✅ 추가
  c.updated_at,
  c.updated_at_utc,  -- ✅ 추가
  -- ... other columns
FROM companies c
-- ... joins
```

---

## 📦 2. 테이블 쿼리 (Direct Query)

### 2.1 companies 테이블

| 파일 경로 | 라인 | 타입 | 작업 | 사용 컬럼 | 시간 관련 컬럼 | 수정 필요 |
|-----------|------|------|------|-----------|----------------|----------|
| supabase_company_datasource.dart | 66-69 | TABLE | INSERT | (companyData 전체) | created_at, updated_at | ⚠️ UseCase 수정 |
| supabase_company_datasource.dart | 81-85 | TABLE | SELECT | company_id, is_deleted | - | ❌ |
| supabase_company_datasource.dart | 99-102 | TABLE | SELECT | owner_id, is_deleted | - | ❌ |
| supabase_company_datasource.dart | 119-123 | TABLE | SELECT | company_id, owner_id, company_name, is_deleted | - | ❌ |
| supabase_company_datasource.dart | 138-145 | TABLE | UPDATE | updated_at | **updated_at** | ✅ DataSource 수정 |
| supabase_company_datasource.dart | 156-159 | TABLE | UPDATE | is_deleted, deleted_at | **deleted_at** | ✅ DataSource 수정 |
| supabase_company_datasource.dart | 168 | TABLE | SELECT | (company_types 전체) | - | ❌ |
| supabase_company_datasource.dart | 180 | TABLE | SELECT | (currency_types 전체) | - | ❌ |
| supabase_company_datasource.dart | 210-212 | TABLE | SELECT | company_id | - | ❌ |

#### INSERT - createCompany (line 66)
```dart
final createdData = await _client
    .from('companies')
    .insert(companyData)  // ⚠️ 외부에서 전달됨
    .select()
    .single();
```

**문제점**: `companyData`는 UseCase에서 생성되므로 **UseCase 레벨에서 수정 필요**

**사용 컬럼**:
- `company_id` (UUID, auto)
- `company_name`
- `owner_id`
- `business_code`
- `company_type_id`
- `created_at` ← 🔴 수정 필요
- `created_at_utc` ← 🔴 추가 필요
- `updated_at` ← 🔴 수정 필요
- `updated_at_utc` ← 🔴 추가 필요

---

#### UPDATE - updateCompany (line 138)
```dart
final updatedData = await _client
    .from('companies')
    .update({
      ...updateData,
      'updated_at': DateTime.now().toIso8601String(),  // 🔴 수정 필요
    })
    .eq('company_id', companyId)
    .select()
    .single();
```

**수정 방안**:
```dart
final now = DateTime.now();
final updatedData = await _client
    .from('companies')
    .update({
      ...updateData,
      'updated_at': now.toIso8601String(),
      'updated_at_utc': now.toUtc().toIso8601String(),  // ✅ 추가
    })
    .eq('company_id', companyId)
    .select()
    .single();
```

**시간 관련 컬럼**: `updated_at`, `updated_at_utc`

---

#### UPDATE - deleteCompany (soft delete) (line 156)
```dart
await _client.from('companies').update({
  'is_deleted': true,
  'deleted_at': DateTime.now().toIso8601String(),  // 🔴 수정 필요
}).eq('company_id', companyId);
```

**수정 방안**:
```dart
final now = DateTime.now();
await _client.from('companies').update({
  'is_deleted': true,
  'deleted_at': now.toIso8601String(),
  'deleted_at_utc': now.toUtc().toIso8601String(),  // ✅ 추가
}).eq('company_id', companyId);
```

**시간 관련 컬럼**: `deleted_at`, `deleted_at_utc`

---

### 2.2 users 테이블

| 파일 경로 | 라인 | 타입 | 작업 | 사용 컬럼 | 시간 관련 컬럼 | 수정 필요 |
|-----------|------|------|------|-----------|----------------|----------|
| supabase_user_datasource.dart | 65-69 | TABLE | SELECT | user_id, is_deleted | - | ❌ |
| supabase_user_datasource.dart | 86-93 | TABLE | UPDATE | updated_at | **updated_at** | ✅ DataSource 수정 |
| supabase_user_datasource.dart | 104-107 | TABLE | UPDATE | last_login_at, updated_at | **last_login_at, updated_at** | ✅ DataSource 수정 |
| supabase_user_datasource.dart | 118-121 | TABLE | SELECT | owner_id, is_deleted | - | ❌ |
| supabase_user_datasource.dart | 136-139 | TABLE | SELECT | store_id, stores(*), user_id, is_deleted | - | ❌ |
| supabase_user_datasource.dart | 163-167 | TABLE | SELECT | owner_id, company_id, is_deleted | - | ❌ |
| supabase_user_datasource.dart | 176-181 | TABLE | SELECT | user_company_id, user_id, company_id, is_deleted | - | ❌ |
| supabase_user_datasource.dart | 196-201 | TABLE | SELECT | user_store_id, user_id, store_id, is_deleted | - | ❌ |
| supabase_auth_datasource.dart | 77-80 | TABLE | SELECT | user_id | - | ❌ |
| supabase_auth_datasource.dart | 124-127 | TABLE | SELECT | user_id | - | ❌ |
| supabase_auth_datasource.dart | 150-153 | TABLE | UPSERT | (user 전체) | **created_at, updated_at** | ✅ DataSource 수정 |
| supabase_auth_datasource.dart | 206-209 | TABLE | SELECT | user_id | - | ❌ |

#### UPDATE - updateUserProfile (line 86)
```dart
final updatedData = await _client
    .from('users')
    .update({
      ...updates,
      'updated_at': DateTime.now().toIso8601String(),  // 🔴 수정 필요
    })
    .eq('user_id', userId)
    .select()
    .single();
```

**수정 방안**:
```dart
final now = DateTime.now();
final updatedData = await _client
    .from('users')
    .update({
      ...updates,
      'updated_at': now.toIso8601String(),
      'updated_at_utc': now.toUtc().toIso8601String(),  // ✅ 추가
    })
    .eq('user_id', userId)
    .select()
    .single();
```

**시간 관련 컬럼**: `updated_at`, `updated_at_utc`

---

#### UPDATE - updateLastLogin (line 104)
```dart
await _client.from('users').update({
  'last_login_at': DateTime.now().toIso8601String(),  // 🔴 이미 timestamptz
  'updated_at': DateTime.now().toIso8601String(),     // 🔴 수정 필요
}).eq('user_id', userId);
```

**수정 방안**:
```dart
final now = DateTime.now();
await _client.from('users').update({
  'last_login_at': now.toUtc().toIso8601String(),  // ⚠️ 이미 timestamptz이므로 UTC 사용
  'updated_at': now.toIso8601String(),
  'updated_at_utc': now.toUtc().toIso8601String(),  // ✅ 추가
}).eq('user_id', userId);
```

**시간 관련 컬럼**: `last_login_at` (이미 timestamptz), `updated_at`, `updated_at_utc`

---

#### UPSERT - signUp fallback (line 150)
```dart
final now = DateTimeUtils.nowUtc();
const timezone = 'Asia/Ho_Chi_Minh';

final userModel = UserDto(
  userId: response.user!.id,
  email: email,
  firstName: firstName,
  lastName: lastName,
  preferredTimezone: timezone,
  createdAt: now,       // 🔴 수정 필요
  updatedAt: now,       // 🔴 수정 필요
);

await _client.from('users').upsert(
  userModel.toJson(),
  onConflict: 'user_id',
);
```

**문제점**: UserDto에 `_utc` 필드가 있는지 확인 필요

**수정 방안 1** (DTO에 필드 있는 경우):
```dart
final now = DateTimeUtils.nowUtc();
final userModel = UserDto(
  userId: response.user!.id,
  email: email,
  firstName: firstName,
  lastName: lastName,
  preferredTimezone: timezone,
  createdAt: now,
  createdAtUtc: now,     // ✅ 추가
  updatedAt: now,
  updatedAtUtc: now,     // ✅ 추가
);
```

**수정 방안 2** (DTO에 필드 없는 경우):
```dart
final now = DateTimeUtils.nowUtc();
await _client.from('users').upsert({
  'user_id': response.user!.id,
  'email': email,
  'first_name': firstName,
  'last_name': lastName,
  'preferred_timezone': timezone,
  'created_at': now.toIso8601String(),
  'created_at_utc': now.toIso8601String(),  // ✅ 추가 (nowUtc()이므로 동일)
  'updated_at': now.toIso8601String(),
  'updated_at_utc': now.toIso8601String(),  // ✅ 추가
}, onConflict: 'user_id');
```

**시간 관련 컬럼**: `created_at`, `created_at_utc`, `updated_at`, `updated_at_utc`

---

### 2.3 stores 테이블

| 파일 경로 | 라인 | 타입 | 작업 | 사용 컬럼 | 시간 관련 컬럼 | 수정 필요 |
|-----------|------|------|------|-----------|----------------|----------|
| supabase_store_datasource.dart | 48-51 | TABLE | INSERT | (storeData 전체) | created_at, updated_at | ⚠️ UseCase 수정 |
| supabase_store_datasource.dart | 63-67 | TABLE | SELECT | store_id, is_deleted | - | ❌ |
| supabase_store_datasource.dart | 81-84 | TABLE | SELECT | company_id, is_deleted | - | ❌ |
| supabase_store_datasource.dart | 101-105 | TABLE | SELECT | store_id, company_id, store_code, is_deleted | - | ❌ |
| supabase_store_datasource.dart | 120-127 | TABLE | UPDATE | updated_at | **updated_at** | ✅ DataSource 수정 |
| supabase_store_datasource.dart | 138-141 | TABLE | UPDATE | is_deleted, deleted_at | **deleted_at** | ✅ DataSource 수정 |

#### INSERT - createStore (line 48)
```dart
final createdData = await _client
    .from('stores')
    .insert(storeData)  // ⚠️ 외부에서 전달됨
    .select()
    .single();
```

**문제점**: `storeData`는 UseCase에서 생성되므로 **UseCase 레벨에서 수정 필요**

**사용 컬럼**:
- `store_id` (UUID, auto)
- `store_name`
- `store_code`
- `company_id`
- `store_address`
- `phone_number`
- `created_at` ← 🔴 수정 필요
- `created_at_utc` ← 🔴 추가 필요
- `updated_at` ← 🔴 수정 필요
- `updated_at_utc` ← 🔴 추가 필요

---

#### UPDATE - updateStore (line 120)
```dart
final updatedData = await _client
    .from('stores')
    .update({
      ...updateData,
      'updated_at': DateTime.now().toIso8601String(),  // 🔴 수정 필요
    })
    .eq('store_id', storeId)
    .select()
    .single();
```

**수정 방안**:
```dart
final now = DateTime.now();
final updatedData = await _client
    .from('stores')
    .update({
      ...updateData,
      'updated_at': now.toIso8601String(),
      'updated_at_utc': now.toUtc().toIso8601String(),  // ✅ 추가
    })
    .eq('store_id', storeId)
    .select()
    .single();
```

**시간 관련 컬럼**: `updated_at`, `updated_at_utc`

---

#### UPDATE - deleteStore (soft delete) (line 138)
```dart
await _client.from('stores').update({
  'is_deleted': true,
  'deleted_at': DateTime.now().toIso8601String(),  // 🔴 수정 필요
}).eq('store_id', storeId);
```

**수정 방안**:
```dart
final now = DateTime.now();
await _client.from('stores').update({
  'is_deleted': true,
  'deleted_at': now.toIso8601String(),
  'deleted_at_utc': now.toUtc().toIso8601String(),  // ✅ 추가
}).eq('store_id', storeId);
```

**시간 관련 컬럼**: `deleted_at`, `deleted_at_utc`

---

### 2.4 user_stores 테이블

| 파일 경로 | 라인 | 타입 | 작업 | 사용 컬럼 | 시간 관련 컬럼 | 수정 필요 |
|-----------|------|------|------|-----------|----------------|----------|
| supabase_user_datasource.dart | 136-139 | TABLE | SELECT (JOIN) | store_id, stores(*), user_id, is_deleted | - | ❌ |
| supabase_user_datasource.dart | 196-201 | TABLE | SELECT | user_store_id, user_id, store_id, is_deleted | - | ❌ |

**비고**: 현재 SELECT만 사용, INSERT/UPDATE는 RPC나 다른 곳에서 처리될 가능성

---

### 2.5 user_companies 테이블

| 파일 경로 | 라인 | 타입 | 작업 | 사용 컬럼 | 시간 관련 컬럼 | 수정 필요 |
|-----------|------|------|------|-----------|----------------|----------|
| supabase_user_datasource.dart | 176-181 | TABLE | SELECT | user_company_id, user_id, company_id, is_deleted | - | ❌ |

**비고**: 현재 SELECT만 사용, INSERT는 `join_business_by_code` RPC에서 처리

---

### 2.6 company_types 테이블

| 파일 경로 | 라인 | 타입 | 작업 | 사용 컬럼 | 시간 관련 컬럼 | 수정 필요 |
|-----------|------|------|------|-----------|----------------|----------|
| supabase_company_datasource.dart | 168 | TABLE | SELECT | (전체) | created_at, updated_at | ❌ 읽기 전용 |

**비고**: 마스터 데이터, 읽기 전용

---

### 2.7 currency_types 테이블

| 파일 경로 | 라인 | 타입 | 작업 | 사용 컬럼 | 시간 관련 컬럼 | 수정 필요 |
|-----------|------|------|------|-----------|----------------|----------|
| supabase_company_datasource.dart | 180 | TABLE | SELECT | (전체) | created_at | ❌ 읽기 전용 |

**비고**: 마스터 데이터, 읽기 전용

---

## 📋 3. 시간 관련 컬럼 전체 요약

### 3.1 테이블별 시간 컬럼

| 테이블명 | 기존 컬럼 | UTC 컬럼 | 타입 (기존) | 타입 (UTC) | 상태 |
|---------|----------|----------|-------------|-----------|------|
| **companies** | created_at | created_at_utc | timestamp | timestamptz | ✅ 존재 |
| | updated_at | updated_at_utc | timestamp | timestamptz | ✅ 존재 |
| | deleted_at | deleted_at_utc | timestamp | timestamptz | ✅ 존재 |
| | plan_updated_at | plan_updated_at_utc | timestamp | timestamptz | ✅ 존재 |
| **users** | created_at | created_at_utc | timestamp | timestamptz | ✅ 존재 |
| | updated_at | updated_at_utc | timestamp | timestamptz | ✅ 존재 |
| | deleted_at | deleted_at_utc | timestamp | timestamptz | ✅ 존재 |
| | last_login_at | - | timestamptz | - | ⚠️ 이미 UTC |
| | trial_started_at | trial_started_at_utc | date | timestamptz | ✅ 존재 |
| | trial_end_date | trial_end_date_utc | date | timestamptz | ✅ 존재 |
| **stores** | created_at | created_at_utc | timestamp | timestamptz | ✅ 존재 |
| | updated_at | updated_at_utc | timestamp | timestamptz | ✅ 존재 |
| | deleted_at | deleted_at_utc | timestamp | timestamptz | ✅ 존재 |
| **user_companies** | created_at | created_at_utc | timestamp | timestamptz | ✅ 존재 |
| | updated_at | updated_at_utc | timestamp | timestamptz | ✅ 존재 |
| | deleted_at | deleted_at_utc | timestamp | timestamptz | ✅ 존재 |
| **user_stores** | created_at | created_at_utc | timestamp | timestamptz | ✅ 존재 |
| | updated_at | updated_at_utc | timestamp | timestamptz | ✅ 존재 |
| | deleted_at | deleted_at_utc | timestamp | timestamptz | ✅ 존재 |

---

### 3.2 작업 유형별 시간 컬럼 사용

| 작업 유형 | 테이블 | 시간 컬럼 | 수정 대상 |
|----------|--------|----------|----------|
| **INSERT** | companies | created_at, updated_at | UseCase |
| **INSERT** | stores | created_at, updated_at | UseCase |
| **UPSERT** | users | created_at, updated_at | DataSource |
| **UPDATE** | companies | updated_at | DataSource ✅ |
| **UPDATE** | users | updated_at | DataSource ✅ |
| **UPDATE** | users | last_login_at, updated_at | DataSource ✅ |
| **UPDATE** | stores | updated_at | DataSource ✅ |
| **SOFT DELETE** | companies | deleted_at | DataSource ✅ |
| **SOFT DELETE** | stores | deleted_at | DataSource ✅ |
| **RPC INSERT** | user_companies | created_at, updated_at | RPC 함수 ⚠️ |

---

## 🎯 4. 수정 우선순위

### 우선순위 1: DataSource 직접 수정 (즉시 가능)
- ✅ `supabase_company_datasource.dart`: updateCompany, deleteCompany
- ✅ `supabase_user_datasource.dart`: updateUserProfile, updateLastLogin
- ✅ `supabase_store_datasource.dart`: updateStore, deleteStore

### 우선순위 2: UseCase 수정 (DTO 확인 후)
- ⚠️ `CreateCompanyUseCase`: companyData 생성
- ⚠️ `CreateStoreUseCase`: storeData 생성

### 우선순위 3: RPC 함수 수정 (수동 작업)
- ⚠️ `join_business_by_code`: user_companies INSERT

### 우선순위 4: DTO 수정 (필요시)
- 📝 `CompanyDto`: _utc 필드 확인
- 📝 `UserDto`: _utc 필드 확인
- 📝 `StoreDto`: _utc 필드 확인

---

## 📊 5. 통계

- **총 파일 수**: 4개 (datasource)
- **총 RPC 호출**: 2개
- **총 테이블 쿼리**: 27개
  - SELECT: 17개
  - INSERT: 2개
  - UPDATE: 6개
  - UPSERT: 1개
  - SOFT DELETE: 2개
- **시간 관련 작업**: 11개
  - DataSource 수정 필요: 6개
  - UseCase 수정 필요: 2개
  - RPC 수정 필요: 1개
- **영향받는 테이블**: 7개
  - companies, users, stores (주요)
  - user_companies, user_stores (관계)
  - company_types, currency_types (읽기 전용)

---

## ✅ 다음 액션 아이템

### 제가 수정할 항목 (DataSource)
1. [ ] supabase_company_datasource.dart - updateCompany (line 141)
2. [ ] supabase_company_datasource.dart - deleteCompany (line 158)
3. [ ] supabase_user_datasource.dart - updateUserProfile (line 89)
4. [ ] supabase_user_datasource.dart - updateLastLogin (line 105)
5. [ ] supabase_auth_datasource.dart - signUp fallback (line 150)
6. [ ] supabase_store_datasource.dart - updateStore (line 123)
7. [ ] supabase_store_datasource.dart - deleteStore (line 140)

### 직접 수정 필요 항목
1. [ ] DTO 구조 확인 (CompanyDto, UserDto, StoreDto)
2. [ ] CreateCompanyUseCase - companyData 생성 로직
3. [ ] CreateStoreUseCase - storeData 생성 로직
4. [ ] RPC 함수 `join_business_by_code` SQL 코드
5. [ ] RPC 함수 `get_user_companies_and_stores` (Phase 2)

---

**보고서 작성**: Claude
**검토 필요**: 개발자님
**다음 단계**: DTO 구조 확인 → 수정 승인 → 구현 시작
