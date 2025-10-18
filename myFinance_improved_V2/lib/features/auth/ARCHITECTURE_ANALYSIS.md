# 🔍 Auth Feature 아키텍처 분석 결과

**분석 날짜**: 2025-10-16
**분석 대상**: `/lib/features/auth`

---

## 📊 발견된 문제: DTO + Mapper vs Model 이중 패턴

### 🔴 핵심 문제

Auth 기능에 **두 가지 서로 다른 패턴이 공존**하고 있습니다:

#### Pattern 1: DTO + Freezed + Mapper (Legacy)
```
User 관련 코드:
- UserDto (Freezed) + user_dto.freezed.dart + user_dto.g.dart
- UserMapper (static methods)
- SupabaseAuthRepository (직접 Supabase 호출)
```

#### Pattern 2: Model + DataSource (Clean)
```
User 관련 코드 (새로 작성된 것):
- UserModel (Plain Dart class)
- SupabaseAuthDataSource (Supabase 격리)
- AuthRepositoryImpl (DataSource 호출)
```

**결과**: 같은 User 엔티티에 대해 **2개의 DTO/Model**, **2개의 Repository**가 존재합니다!

---

## 📁 파일 구조 분석

### ✅ 새로운 Clean 패턴 (권장)

```
data/
├── datasources/
│   ├── supabase_auth_datasource.dart      ✅ NEW - Supabase 격리
│   ├── supabase_company_datasource.dart   ✅ 완벽
│   └── supabase_store_datasource.dart     ✅ 완벽
│
├── models/
│   ├── user_model.dart                    ✅ NEW - Plain Dart
│   ├── company_model.dart                 ✅ 완벽
│   └── store_model.dart                   ✅ 완벽
│
└── repositories/
    ├── auth_repository_impl.dart          ✅ NEW - DataSource 사용
    ├── company_repository_impl.dart       ✅ 완벽
    └── store_repository_impl.dart         ✅ 완벽
```

### ❌ 구식 Legacy 패턴 (제거 대상)

```
data/
├── dtos/                                  ❌ 전체 폴더 제거 대상
│   ├── user_dto.dart                      ❌ Freezed + JsonSerializable
│   ├── user_dto.freezed.dart             ❌ 자동 생성 (33 KB)
│   ├── user_dto.g.dart                   ❌ 자동 생성
│   ├── company_dto.dart                  ❌ CompanyModel과 중복
│   ├── company_dto.freezed.dart          ❌ 자동 생성
│   ├── company_dto.g.dart                ❌ 자동 생성
│   ├── store_dto.dart                    ❌ StoreModel과 중복
│   ├── store_dto.freezed.dart            ❌ 자동 생성
│   └── store_dto.g.dart                  ❌ 자동 생성
│
├── mappers/                               ❌ 전체 폴더 제거 대상
│   ├── user_mapper.dart                   ❌ UserModel.toEntity()로 대체
│   ├── company_mapper.dart               ❌ CompanyModel.toEntity() 이미 있음
│   └── store_mapper.dart                 ❌ StoreModel.toEntity() 이미 있음
│
├── exceptions/
│   └── data_exceptions.dart              ❌ Domain exceptions와 중복
│
└── repositories/
    ├── supabase_auth_repository.dart      ❌ AuthRepositoryImpl로 대체됨
    └── supabase_user_repository.dart      ❌ 사용되지 않음
```

**총 제거 대상**: 15개 파일

---

## 🔍 상세 비교 분석

### 1️⃣ User Entity 데이터 흐름

#### ❌ Legacy 패턴 (복잡함)
```dart
// 1. DTO (Freezed) - 3개 파일 생성
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    @JsonKey(name: 'user_id') required String userId,
    required String email,
    // ...
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}
// → user_dto.dart, user_dto.freezed.dart (33 KB!), user_dto.g.dart

// 2. Mapper (별도 클래스)
class UserMapper {
  static User toEntity(UserDto dto) {
    return User(
      id: dto.userId,
      email: dto.email,
      // ...
    );
  }
}

// 3. Repository (Supabase 직접 호출)
class SupabaseAuthRepository extends BaseRepository implements AuthRepository {
  final SupabaseClient _client; // ❌ 직접 의존

  Future<User?> login({required String email, required String password}) {
    return executeNullable(() async {
      // ❌ Repository가 Supabase 직접 호출
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userData = await _client.from('users').select()...

      // ❌ DTO + Mapper 2단계 변환
      return UserMapper.toEntity(UserDto.fromJson(userData));
    });
  }
}
```

#### ✅ Clean 패턴 (단순함)
```dart
// 1. Model (Plain Dart) - 1개 파일
class UserModel {
  final String userId;
  final String email;
  // ...

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      // ...
    );
  }

  User toEntity() {  // ✅ 메서드로 통합
    return User(
      id: userId,
      email: email,
      // ...
    );
  }
}

// 2. DataSource (Supabase 격리)
class SupabaseAuthDataSource implements AuthDataSource {
  final SupabaseClient _client;

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(...);
    final userData = await _client.from('users').select()...

    return UserModel.fromJson(userData); // ✅ 직접 변환
  }
}

// 3. Repository (DataSource 호출)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthDataSource _dataSource; // ✅ DataSource 의존

  Future<User?> login({
    required String email,
    required String password,
  }) {
    return executeNullable(() async {
      final userModel = await _dataSource.signIn(
        email: email,
        password: password,
      );

      return userModel.toEntity(); // ✅ 1단계 변환
    });
  }
}
```

---

## 📈 패턴 비교표

| 항목 | ❌ DTO + Mapper | ✅ Model + DataSource |
|------|----------------|----------------------|
| **파일 수** | User당 5개 (dto + 2 generated + mapper + repo) | User당 3개 (model + datasource + repo) |
| **생성 파일** | .freezed.dart (33KB), .g.dart | 없음 |
| **빌드 시간** | `build_runner` 필요 | 즉시 |
| **변환 단계** | DTO → Mapper → Entity (2단계) | Model → Entity (1단계) |
| **Supabase 결합도** | Repository가 직접 호출 (높음) | DataSource로 격리 (낮음) |
| **테스트 용이성** | Supabase mock 필요 | DataSource mock만 필요 |
| **코드 가독성** | 3개 클래스 이동 필요 | 1개 파일에서 완결 |
| **유지보수** | 3곳 수정 필요 | 1곳만 수정 |

---

## 🎯 권장 해결 방안

### Phase 1: Legacy 파일 제거 (우선순위: 🔴 HIGH)

#### Step 1: Provider 업데이트 (5분)

**파일**: `presentation/providers/repository_providers.dart`

```dart
// ❌ 삭제
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepository(client); // ❌ Legacy
});

// ✅ 추가
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthDataSource(client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource); // ✅ Clean
});
```

#### Step 2: Import 수정 (10분)

전체 프로젝트에서 Legacy import 제거:

```dart
// ❌ 삭제할 import
import '../data/dtos/user_dto.dart';
import '../data/mappers/user_mapper.dart';
import '../data/repositories/supabase_auth_repository.dart';

// ✅ 이미 사용 중인 import (그대로 유지)
import '../data/models/user_model.dart';
import '../data/datasources/supabase_auth_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
```

#### Step 3: 파일 삭제 (1분)

```bash
# DTOs 폴더 전체 삭제
rm -rf lib/features/auth/data/dtos/

# Mappers 폴더 전체 삭제
rm -rf lib/features/auth/data/mappers/

# Data Exceptions 삭제 (Domain exceptions 사용)
rm lib/features/auth/data/exceptions/data_exceptions.dart

# Legacy Repositories 삭제
rm lib/features/auth/data/repositories/supabase_auth_repository.dart
rm lib/features/auth/data/repositories/supabase_user_repository.dart
```

#### Step 4: Build 검증 (2분)

```bash
# Clean build
flutter clean
flutter pub get
flutter analyze

# Test
flutter test
```

---

## 📊 Before & After

### Before (현재)
```
auth/data/
├── dtos/ (9개 파일, 총 70KB)
├── mappers/ (3개 파일)
├── models/ (5개 파일)
├── datasources/ (4개 파일)
├── repositories/ (6개 파일)
└── exceptions/ (1개 파일)

총: 28개 파일
문제: 중복 패턴, 복잡한 변환, 느린 빌드
```

### After (목표)
```
auth/data/
├── models/ (5개 파일)          ✅ JSON ↔ Entity 변환
├── datasources/ (4개 파일)      ✅ Supabase 격리
├── repositories/ (4개 파일)     ✅ DataSource 호출
└── [exceptions 삭제]            ✅ Domain exceptions 사용

총: 13개 파일 (-15개, -54%)
장점: 단일 패턴, 간단한 변환, 빠른 빌드
```

---

## 🏆 이점 요약

### 1. 파일 감소
- **Before**: 28개 파일
- **After**: 13개 파일
- **감소**: 15개 (-54%)

### 2. 코드 감소
- Freezed 생성 파일 제거: ~70KB
- Mapper 중복 로직 제거: ~2KB
- 총 코드 감소: **~75%**

### 3. 빌드 시간
- `build_runner` 불필요
- Hot reload 속도 향상
- CI/CD 빌드 시간 단축

### 4. 유지보수성
- 변환 로직 1곳에 집중 (Model)
- Supabase 변경시 DataSource만 수정
- 테스트 작성 용이

### 5. 일관성
- 전체 feature가 동일한 패턴 사용
- 신규 개발자 온보딩 시간 단축
- 코드 리뷰 효율 향상

---

## 🚨 주의사항

### 1. 마이그레이션 전 확인사항
- [ ] 모든 Provider가 `AuthRepositoryImpl` 사용하는지 확인
- [ ] DTO를 직접 참조하는 코드가 없는지 검색
- [ ] Mapper를 직접 호출하는 코드가 없는지 검색

### 2. 검색 명령어
```bash
# DTO 사용처 검색
grep -r "UserDto\|CompanyDto\|StoreDto" lib/

# Mapper 사용처 검색
grep -r "UserMapper\|CompanyMapper\|StoreMapper" lib/

# Legacy Repository 사용처 검색
grep -r "SupabaseAuthRepository\|SupabaseUserRepository" lib/
```

### 3. 롤백 계획
- 삭제 전 Git commit 생성
- 문제 발생시 `git revert` 사용

---

## ✅ 체크리스트

### Pre-Migration
- [ ] 현재 브랜치에 모든 변경사항 commit
- [ ] 새 브랜치 생성 (`git checkout -b refactor/remove-dto-mapper`)
- [ ] DTO/Mapper 사용처 검색 및 확인

### Migration
- [ ] Provider 업데이트
- [ ] Import 수정
- [ ] 파일 삭제
- [ ] Build 검증

### Post-Migration
- [ ] Flutter analyze 통과
- [ ] Flutter test 통과
- [ ] 수동 테스트 (Login/Signup 기능)
- [ ] Git commit
- [ ] Pull Request 생성

---

## 📝 결론

Auth 기능은 **Clean Architecture를 완벽히 구현**하고 있지만,
**Legacy 패턴(DTO + Mapper)과 Clean 패턴(Model + DataSource)이 공존**하여
**중복과 복잡성**이 발생하고 있습니다.

**해결책**: Legacy 패턴 15개 파일 제거 → **-54% 파일 감소**, **일관성 확보**

**예상 작업 시간**: 약 **20분**
**위험도**: ⚠️ 낮음 (이미 새 패턴이 구현되어 있음)

---

**다음 단계**: 이 분석을 바탕으로 리팩토링을 진행하시겠습니까?
