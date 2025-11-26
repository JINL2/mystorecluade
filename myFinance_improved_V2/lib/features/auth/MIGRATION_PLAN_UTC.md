# 🌍 UTC Timestamp 마이그레이션 플랜 - Auth Feature

## 📋 목표
기존 `timestamp without timezone` 컬럼을 `timestamptz` (timestamp with timezone)로 마이그레이션하여 글로벌 서비스 준비

---

## 🎯 마이그레이션 전략: Dual-Write Pattern

### 배경
- **현재 배포된 앱**: `timestamp without timezone` 컬럼 사용 (created_at, updated_at, deleted_at)
- **데이터베이스**: 이미 `_utc` 접미사 컬럼 존재 (created_at_utc, updated_at_utc, deleted_at_utc)
- **목표**: 하위 호환성 유지하면서 점진적으로 UTC 컬럼으로 전환

### 3단계 마이그레이션

```
Phase 1: Dual-Write (새 앱 배포)
  ├─ 기존 컬럼 + UTC 컬럼 모두 작성
  ├─ 읽기는 여전히 기존 컬럼 사용
  └─ 구 앱과 신 앱 공존 가능

Phase 2: Dual-Read (데이터 검증)
  ├─ UTC 컬럼 우선 읽기, fallback to 기존 컬럼
  ├─ 데이터 일관성 검증
  └─ 충분한 모니터링 기간

Phase 3: UTC-Only (완전 전환)
  ├─ UTC 컬럼만 읽기/쓰기
  ├─ 기존 컬럼 deprecated 처리
  └─ 향후 기존 컬럼 제거 고려
```

---

## 📊 Auth Feature 분석 결과

### 1. 테이블별 시간 컬럼 현황

#### 🏢 companies 테이블
| 기존 컬럼 | UTC 컬럼 | 데이터 타입 (기존) | 데이터 타입 (UTC) | 사용 위치 |
|-----------|----------|-------------------|-------------------|----------|
| created_at | created_at_utc | timestamp | timestamptz | INSERT (line 66) |
| updated_at | updated_at_utc | timestamp | timestamptz | UPDATE (line 141) |
| deleted_at | deleted_at_utc | timestamp | timestamptz | DELETE (line 158) |
| plan_updated_at | plan_updated_at_utc | timestamp | timestamptz | - |

#### 👤 users 테이블
| 기존 컬럼 | UTC 컬럼 | 데이터 타입 (기존) | 데이터 타입 (UTC) | 사용 위치 |
|-----------|----------|-------------------|-------------------|----------|
| created_at | created_at_utc | timestamp | timestamptz | UPSERT (line 150) |
| updated_at | updated_at_utc | timestamp | timestamptz | UPDATE (line 89, 106) |
| deleted_at | deleted_at_utc | timestamp | timestamptz | - |
| last_login_at | - | timestamptz | - | UPDATE (line 105) ⚠️ 이미 UTC |
| trial_started_at | trial_started_at_utc | date | timestamptz | - |
| trial_end_date | trial_end_date_utc | date | timestamptz | - |

**⚠️ 주의**: `last_login_at`은 이미 `timestamptz` 타입이므로 별도 처리 불필요

#### 🏪 stores 테이블
| 기존 컬럼 | UTC 컬럼 | 데이터 타입 (기존) | 데이터 타입 (UTC) | 사용 위치 |
|-----------|----------|-------------------|-------------------|----------|
| created_at | created_at_utc | timestamp | timestamptz | INSERT (line 48) |
| updated_at | updated_at_utc | timestamp | timestamptz | UPDATE (line 123) |
| deleted_at | deleted_at_utc | timestamp | timestamptz | DELETE (line 140) |

#### 🔗 user_companies 테이블
| 기존 컬럼 | UTC 컬럼 | 데이터 타입 (기존) | 데이터 타입 (UTC) | 사용 위치 |
|-----------|----------|-------------------|-------------------|----------|
| created_at | created_at_utc | timestamp | timestamptz | (indirect) |
| updated_at | updated_at_utc | timestamp | timestamptz | (indirect) |
| deleted_at | deleted_at_utc | timestamp | timestamptz | (indirect) |

#### 🔗 user_stores 테이블
| 기존 컬럼 | UTC 컬럼 | 데이터 타입 (기존) | 데이터 타입 (UTC) | 사용 위치 |
|-----------|----------|-------------------|-------------------|----------|
| created_at | created_at_utc | timestamp | timestamptz | (indirect) |
| updated_at | updated_at_utc | timestamp | timestamptz | (indirect) |
| deleted_at | deleted_at_utc | timestamp | timestamptz | (indirect) |

---

## 🔧 수정이 필요한 파일 목록

### A. Direct Query 수정 (제가 수정)

#### 1. supabase_company_datasource.dart
**파일 경로**: `lib/features/auth/data/datasources/supabase_company_datasource.dart`

##### 수정 위치 1: `createCompany` (line 66)
```dart
// ❌ 현재
final createdData = await _client
    .from('companies')
    .insert(companyData)  // companyData는 외부에서 전달됨
    .select()
    .single();

// ✅ 수정 필요
// companyData에 created_at이 있으면 created_at_utc도 추가
```

**⚠️ 문제점**: `companyData`가 외부(UseCase)에서 전달되므로, UseCase 레벨에서 처리 필요

##### 수정 위치 2: `updateCompany` (line 141)
```dart
// ❌ 현재
'updated_at': DateTime.now().toIso8601String(),

// ✅ 수정 후
final now = DateTime.now();
'updated_at': now.toIso8601String(),
'updated_at_utc': now.toUtc().toIso8601String(),
```

##### 수정 위치 3: `deleteCompany` (line 158)
```dart
// ❌ 현재
'is_deleted': true,
'deleted_at': DateTime.now().toIso8601String(),

// ✅ 수정 후
final now = DateTime.now();
'is_deleted': true,
'deleted_at': now.toIso8601String(),
'deleted_at_utc': now.toUtc().toIso8601String(),
```

---

#### 2. supabase_user_datasource.dart
**파일 경로**: `lib/features/auth/data/datasources/supabase_user_datasource.dart`

##### 수정 위치 1: `updateUserProfile` (line 89)
```dart
// ❌ 현재
'updated_at': DateTime.now().toIso8601String(),

// ✅ 수정 후
final now = DateTime.now();
'updated_at': now.toIso8601String(),
'updated_at_utc': now.toUtc().toIso8601String(),
```

##### 수정 위치 2: `updateLastLogin` (line 105-106)
```dart
// ❌ 현재
'last_login_at': DateTime.now().toIso8601String(),
'updated_at': DateTime.now().toIso8601String(),

// ✅ 수정 후
final now = DateTime.now();
'last_login_at': now.toUtc().toIso8601String(),  // 이미 timestamptz
'updated_at': now.toIso8601String(),
'updated_at_utc': now.toUtc().toIso8601String(),
```

**⚠️ 주의**: `last_login_at`은 이미 `timestamptz` 타입이므로 항상 UTC로 저장

---

#### 3. supabase_auth_datasource.dart
**파일 경로**: `lib/features/auth/data/datasources/supabase_auth_datasource.dart`

##### 수정 위치: `signUp` fallback (line 150)
```dart
// ❌ 현재
final now = DateTimeUtils.nowUtc();
const timezone = 'Asia/Ho_Chi_Minh';

final userModel = UserDto(
  userId: response.user!.id,
  email: email,
  firstName: firstName,
  lastName: lastName,
  preferredTimezone: timezone,
  createdAt: now,
  updatedAt: now,
);

// ✅ 수정 후 - UserDto에 _utc 필드 추가 필요
// 또는 upsert 시 직접 지정
await _client.from('users').upsert({
  'user_id': response.user!.id,
  'email': email,
  'first_name': firstName,
  'last_name': lastName,
  'preferred_timezone': timezone,
  'created_at': now.toIso8601String(),
  'created_at_utc': now.toIso8601String(),  // nowUtc()이므로 동일
  'updated_at': now.toIso8601String(),
  'updated_at_utc': now.toIso8601String(),
}, onConflict: 'user_id');
```

---

#### 4. supabase_store_datasource.dart
**파일 경로**: `lib/features/auth/data/datasources/supabase_store_datasource.dart`

##### 수정 위치 1: `createStore` (line 48)
```dart
// ❌ 현재
final createdData = await _client
    .from('stores')
    .insert(storeData)  // storeData는 외부에서 전달됨
    .select()
    .single();

// ✅ 수정 필요
// storeData에 created_at이 있으면 created_at_utc도 추가
```

**⚠️ 문제점**: `storeData`가 외부(UseCase)에서 전달되므로, UseCase 레벨에서 처리 필요

##### 수정 위치 2: `updateStore` (line 123)
```dart
// ❌ 현재
'updated_at': DateTime.now().toIso8601String(),

// ✅ 수정 후
final now = DateTime.now();
'updated_at': now.toIso8601String(),
'updated_at_utc': now.toUtc().toIso8601String(),
```

##### 수정 위치 3: `deleteStore` (line 140)
```dart
// ❌ 현재
'is_deleted': true,
'deleted_at': DateTime.now().toIso8601String(),

// ✅ 수정 후
final now = DateTime.now();
'is_deleted': true,
'deleted_at': now.toIso8601String(),
'deleted_at_utc': now.toUtc().toIso8601String(),
```

---

### B. RPC 함수 수정 (직접 수정 필요)

#### 1. join_business_by_code
**위치**: Database RPC Function
**파일**: `lib/features/auth/data/datasources/supabase_company_datasource.dart:196`

**수정 필요 사항**:
- RPC 함수 내부에서 user_companies 테이블에 INSERT 시
- `created_at_utc` 컬럼도 함께 설정

**예상 RPC 수정**:
```sql
-- Supabase RPC 함수 내부
INSERT INTO user_companies (
  user_id,
  company_id,
  created_at,
  created_at_utc  -- 추가
) VALUES (
  p_user_id,
  v_company_id,
  NOW(),
  NOW() AT TIME ZONE 'UTC'  -- 추가
);
```

#### 2. get_user_companies_and_stores
**위치**: Database RPC Function
**파일**: `lib/features/auth/data/datasources/supabase_user_datasource.dart:212`

**수정 필요 사항**:
- SELECT 결과에 `_utc` 컬럼 포함 여부 확인
- 현재는 읽기 전용이므로 영향 없을 수 있음
- 하지만 향후 Dual-Read 단계에서는 `_utc` 컬럼 우선 반환 필요

---

## 📝 DTO/Model 수정 필요 여부

### 현재 DTO 구조 확인 필요
- `CompanyDto` - created_at_utc, updated_at_utc, deleted_at_utc 필드 있는지?
- `UserDto` - created_at_utc, updated_at_utc, deleted_at_utc 필드 있는지?
- `StoreDto` - created_at_utc, updated_at_utc, deleted_at_utc 필드 있는지?

**만약 없다면**:
```dart
@freezed
class CompanyDto with _$CompanyDto {
  const factory CompanyDto({
    required String companyId,
    required String companyName,
    DateTime? createdAt,      // 기존
    DateTime? updatedAt,      // 기존
    DateTime? deletedAt,      // 기존
    DateTime? createdAtUtc,   // 신규 추가
    DateTime? updatedAtUtc,   // 신규 추가
    DateTime? deletedAtUtc,   // 신규 추가
    // ... other fields
  }) = _CompanyDto;

  factory CompanyDto.fromJson(Map<String, dynamic> json) =>
      _$CompanyDtoFromJson(json);
}
```

---

## 🔄 UseCase 레벨 수정 필요

### 1. CreateCompanyUseCase
**문제**: `companyData`를 직접 전달하므로 시간 컬럼 처리 필요

```dart
// ❌ 현재
final companyData = {
  'company_name': command.companyName,
  'owner_id': userId,
  'created_at': DateTime.now().toIso8601String(),
  'updated_at': DateTime.now().toIso8601String(),
};

// ✅ 수정 후
final now = DateTime.now();
final companyData = {
  'company_name': command.companyName,
  'owner_id': userId,
  'created_at': now.toIso8601String(),
  'created_at_utc': now.toUtc().toIso8601String(),
  'updated_at': now.toIso8601String(),
  'updated_at_utc': now.toUtc().toIso8601String(),
};
```

### 2. CreateStoreUseCase
동일한 패턴으로 `storeData` 생성 시 UTC 컬럼 추가

---

## 📅 마이그레이션 단계별 실행 계획

### Phase 1: Dual-Write 구현 (1-2주)

#### Week 1: 코드 수정
1. ✅ DataSource 레벨 수정 (제가 진행)
   - [ ] supabase_company_datasource.dart
   - [ ] supabase_user_datasource.dart
   - [ ] supabase_auth_datasource.dart
   - [ ] supabase_store_datasource.dart

2. 📝 DTO 수정 (필요시)
   - [ ] CompanyDto에 _utc 필드 추가
   - [ ] UserDto에 _utc 필드 추가
   - [ ] StoreDto에 _utc 필드 추가
   - [ ] `build_runner` 실행

3. 🔄 UseCase 수정
   - [ ] CreateCompanyUseCase
   - [ ] CreateStoreUseCase
   - [ ] 기타 시간 데이터 생성하는 UseCase

4. 🗄️ RPC 함수 수정 (직접 진행)
   - [ ] join_business_by_code
   - [ ] get_user_companies_and_stores (필요시)

#### Week 2: 테스트 & 배포
5. 🧪 테스트
   - [ ] Unit Test 업데이트
   - [ ] Integration Test
   - [ ] 로컬 테스트

6. 🚀 배포
   - [ ] Staging 환경 배포
   - [ ] 데이터 검증
   - [ ] Production 배포

### Phase 2: 모니터링 & 데이터 검증 (2-4주)

7. 📊 모니터링
   - [ ] 기존 컬럼과 UTC 컬럼 일치 여부 확인
   - [ ] 에러 로그 모니터링
   - [ ] 성능 모니터링

8. 🔍 데이터 품질 체크
```sql
-- 데이터 일치 여부 확인
SELECT
  company_id,
  created_at,
  created_at_utc,
  CASE
    WHEN created_at::timestamptz = created_at_utc THEN 'OK'
    ELSE 'MISMATCH'
  END as status
FROM companies
WHERE created_at_utc IS NOT NULL;
```

### Phase 3: Dual-Read 전환 (추후 계획)

9. 📖 읽기 로직 수정
   - UTC 컬럼 우선 사용
   - Fallback to 기존 컬럼
   - 점진적 롤아웃

10. 🎯 최종 전환
   - UTC 컬럼만 사용
   - 기존 컬럼 deprecated
   - 문서화 업데이트

---

## ⚠️ 주의사항

### 1. 하위 호환성
- 구 앱에서는 여전히 기존 컬럼만 사용
- 신 앱에서는 Dual-Write로 양쪽 모두 작성
- 읽기는 당분간 기존 컬럼 사용 (Phase 2까지)

### 2. DateTime 변환 주의
```dart
// ❌ 잘못된 방법
DateTime.now().toUtc().toIso8601String()  // 두 번 변환 X

// ✅ 올바른 방법
final now = DateTime.now();
final local = now.toIso8601String();      // 로컬 타임존
final utc = now.toUtc().toIso8601String(); // UTC
```

### 3. Database Trigger 활용
- 가능하면 DB 트리거로 자동 동기화
- 코드 레벨 Dual-Write는 보험용

### 4. RLS (Row Level Security) 정책
- UTC 컬럼 추가 시 RLS 정책 업데이트 필요 여부 확인

---

## 🎬 다음 단계

### 즉시 시작 가능한 작업
1. ✅ DTO에 `_utc` 필드가 있는지 확인
2. ✅ UseCase에서 어떻게 시간 데이터를 생성하는지 확인
3. ✅ RPC 함수 SQL 코드 확인

### 제가 진행할 작업
- DataSource 레벨의 UPDATE/DELETE 쿼리 수정
- 테스트 코드 업데이트

### 직접 진행 필요한 작업
- RPC 함수 SQL 수정 (join_business_by_code)
- UseCase 레벨 시간 데이터 생성 로직 수정
- DTO 수정 (필요시)

---

## 📞 질문사항

1. **DTO 구조**: 현재 DTO에 `_utc` 필드가 이미 있나요?
2. **DB Trigger**: 데이터베이스에 timestamp 동기화 트리거가 설정되어 있나요?
3. **우선순위**: 어떤 테이블부터 먼저 마이그레이션할까요? (companies → stores → users 순서 추천)
4. **타임라인**: 언제까지 Phase 1을 완료하고 싶으신가요?

---

**작성일**: 2025-11-24
**대상 Feature**: Auth
**담당**: Claude (DataSource), 개발자님 (RPC/UseCase)
