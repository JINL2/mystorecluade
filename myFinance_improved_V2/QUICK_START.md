# ⚡ 30년차 개발자의 실전 리팩토링 Quick Start

**5분 안에 바로 적용 가능한 코드 개선 방법**

---

## 🎯 핵심 3가지 개선 (바로 적용 가능)

### 1️⃣ **Provider 보일러플레이트 제거 (지금 당장 사용 가능)**

**현재 코드 (77줄):**
```dart
// lib/features/auth/presentation/providers/usecase_providers.dart
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository: authRepo);
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return SignupUseCase(authRepository: authRepo);
});

// ... 50번 더 반복...
```

**개선 코드 (21줄):**
```dart
// 1. 한 번만 import
import 'package:myfinance_improved/core/providers/provider_factory.dart';

// 2. 간단하게 작성
final loginUseCaseProvider = ProviderFactory.useCase1(
  LoginUseCase.new,
  authRepositoryProvider,
);

final signupUseCaseProvider = ProviderFactory.useCase1(
  SignupUseCase.new,
  authRepositoryProvider,
);

// 반복 코드 73% 감소!
```

**✅ 적용 방법:**
1. `lib/core/providers/provider_factory.dart` 파일이 이미 생성됨
2. 기존 provider 파일에서 한 줄씩 교체
3. 즉시 동작 (기존 코드와 100% 호환)

---

### 2️⃣ **Entity + Model 통합 (Freezed 사용)**

**현재 코드 (293줄):**
```dart
// user_entity.dart (117줄)
class User {
  final String id;
  final String email;

  User copyWith({...}) { ... } // 수동 작성
  bool operator ==() { ... }   // 수동 작성
  int get hashCode { ... }     // 수동 작성
}

// user_model.dart (176줄)
class UserModel {
  final String userId;
  final String email;

  factory UserModel.fromJson(Map json) { ... } // 수동 작성
  Map<String, dynamic> toJson() { ... }        // 수동 작성
  User toEntity() { ... }                      // 수동 변환
}
```

**개선 코드 (70줄):**
```dart
// user.dart (하나로 통합!)
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    @JsonKey(name: 'user_id') required String id,
    required String email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // 비즈니스 로직만 직접 작성
  String get displayName => firstName ?? email.split('@').first;
}

// Freezed가 자동 생성:
// - copyWith ✅
// - == operator ✅
// - hashCode ✅
// - toString ✅
// - fromJson ✅
// - toJson ✅
```

**✅ 적용 방법:**
```bash
# 1. Freezed 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

# 2. 기존 import 교체
# Before: import 'user_entity.dart';
# After:  import 'user.dart';

# 3. toEntity() 제거
# Before: final user = userModel.toEntity();
# After:  final user = User.fromJson(json); // 직접 사용!
```

---

### 3️⃣ **Repository 보일러플레이트 제거**

**현재 코드 (반복 패턴):**
```dart
class UserRepositoryImpl extends BaseRepository implements UserRepository {
  final UserDataSource _dataSource;

  @override
  Future<User?> findById(String userId) {
    return executeNullable(() async {
      final userModel = await _dataSource.getUserById(userId);
      return userModel?.toEntity(); // 매번 수동 변환
    });
  }

  @override
  Future<List<Company>> getCompanies(String userId) {
    return execute(() async {
      final companyModels = await _dataSource.getUserCompanies(userId);
      return companyModels.map((model) => model.toEntity()).toList(); // 반복
    });
  }

  // ... 10개 메서드 더 (모두 같은 패턴)
}
```

**개선 코드 (Generic 사용):**
```dart
class UserRepositoryImpl extends GenericRepository<User, User>
    implements UserRepository {

  final UserDataSource _dataSource;
  UserRepositoryImpl(this._dataSource);

  @override
  User convertToEntity(User model) => model; // 한 번만 정의

  @override
  Future<Either<Failure, User>> getUserById(String userId) {
    return executeSingle(
      () => _dataSource.getUserById(userId),
      operationName: 'get user by id',
    ); // 자동 변환, 자동 에러 처리!
  }

  @override
  Future<Either<Failure, List<Company>>> getUserCompanies(String userId) {
    return executeList(
      () => _dataSource.getUserCompanies(userId),
      operationName: 'get user companies',
    ); // List 자동 변환!
  }
}
```

**✅ 적용 방법:**
1. `lib/core/data/generic_repository.dart` 파일이 이미 생성됨
2. 기존 Repository에서 `extends GenericRepository<Entity, Model>` 추가
3. `convertToEntity()` 한 번만 구현
4. 나머지 메서드는 `executeSingle()` / `executeList()` 사용

---

## 🚀 오늘 바로 시작하기 (30분 만에 완료)

### **Step 1: Provider 간소화 (10분)**

```bash
# 1. 기존 파일 복사 (백업)
cp lib/features/auth/presentation/providers/usecase_providers.dart \
   lib/features/auth/presentation/providers/usecase_providers_backup.dart

# 2. 기존 파일 수정
code lib/features/auth/presentation/providers/usecase_providers.dart
```

**파일 내용 수정:**
```dart
// 맨 위에 추가
import 'package:myfinance_improved/core/providers/provider_factory.dart';

// 각 Provider를 아래처럼 변경
// Before (5줄):
// final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
//   final authRepo = ref.watch(authRepositoryProvider);
//   return LoginUseCase(authRepository: authRepo);
// });

// After (3줄):
final loginUseCaseProvider = ProviderFactory.useCase1(
  LoginUseCase.new,
  authRepositoryProvider,
);
```

**✅ 테스트:**
```bash
flutter run
# 앱이 정상 동작하면 성공!
```

---

### **Step 2: User Entity 변환 (15분)**

```bash
# 1. 기존 파일 백업
mv lib/features/auth/domain/entities/user_entity.dart \
   lib/features/auth/domain/entities/user_entity_backup.dart

# 2. 새 파일 이미 생성됨 (user.dart)
# lib/features/auth/domain/entities/user.dart

# 3. Freezed 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs
```

**✅ 테스트:**
```dart
// 간단한 테스트 코드
void main() {
  final user = User(
    id: '123',
    email: 'test@test.com',
    firstName: 'John',
    createdAt: DateTime.now(),
  );

  print(user.displayName); // "John"

  final updated = user.copyWith(email: 'new@test.com');
  print(updated.email); // "new@test.com"
  print(updated.firstName); // "John" (기존 값 유지)
}
```

---

### **Step 3: Repository 개선 (5분)**

**기존 파일 옆에 새 파일 생성:**
```bash
# 이미 생성됨:
# lib/features/auth/data/repositories/user_repository_refactored.dart
```

**Provider에서 교체:**
```dart
// infrastructure/providers/repository_providers.dart

// Before:
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return UserRepositoryImpl(dataSource);
});

// After:
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return UserRepositoryRefactored(dataSource); // 새 구현체 사용
});
```

---

## 📊 즉시 확인 가능한 효과

### **Before (기존 코드):**
```
lib/features/auth/
├── domain/entities/user_entity.dart         (117줄)
├── data/models/user_model.dart             (176줄)
├── data/repositories/user_repository_impl.dart (127줄)
└── presentation/providers/usecase_providers.dart (77줄)
                                             ========
                                             497줄
```

### **After (개선된 코드):**
```
lib/features/auth/
├── domain/entities/user.dart               (70줄)
├── data/repositories/user_repository_refactored.dart (80줄)
└── presentation/providers/usecase_providers_refactored.dart (21줄)
                                             ========
                                             171줄

코드 감소: 497줄 → 171줄 (66% 감소!)
```

---

## 🎓 30년차 개발자의 핵심 조언

### ✅ **성공하는 리팩토링 3원칙**

1. **점진적으로 진행**
   - 하루에 파일 1-2개씩
   - 각 변경 후 반드시 테스트
   - 롤백 가능한 상태 유지

2. **측정 가능한 목표**
   - "코드 줄 수 50% 감소"
   - "빌드 시간 30% 단축"
   - "버그 발생률 70% 감소"

3. **팀과 공유**
   - 변경사항 문서화
   - 코드 리뷰 필수
   - 지식 공유 세션

### ❌ **실패하는 리팩토링 안티패턴**

1. ❌ 모든 파일을 한 번에 변경
2. ❌ 테스트 없이 진행
3. ❌ 기존 코드를 이해하지 않고 복붙
4. ❌ 과도한 추상화 (YAGNI 원칙 위배)

---

## 🔥 다음 단계 (우선순위)

### **Week 1: Auth Feature 완성**
- [x] User Entity 변환 (완료)
- [ ] Company Entity 변환
- [ ] Store Entity 변환
- [ ] Auth Provider 통합 테스트

### **Week 2: 다른 Feature 확장**
- [ ] time_table_manage Feature
- [ ] cash_ending Feature
- [ ] attendance Feature

### **Week 3: 통합 및 최적화**
- [ ] 전체 앱 통합 테스트
- [ ] 성능 벤치마크
- [ ] 문서 업데이트

---

## 💡 즉시 사용 가능한 코드 스니펫

### **Freezed Entity Template**
```dart
@freezed
class MyEntity with _$MyEntity {
  const MyEntity._();

  const factory MyEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _MyEntity;

  factory MyEntity.fromJson(Map<String, dynamic> json) =>
      _$MyEntityFromJson(json);

  // 비즈니스 로직
  bool get isValid => name.isNotEmpty;
}
```

### **Generic Repository Template**
```dart
class MyRepositoryImpl extends GenericRepository<MyEntity, MyEntity>
    implements MyRepository {

  final MyDataSource _dataSource;
  MyRepositoryImpl(this._dataSource);

  @override
  MyEntity convertToEntity(MyEntity model) => model;

  @override
  Future<Either<Failure, MyEntity>> getById(String id) {
    return executeSingle(
      () => _dataSource.getById(id),
      operationName: 'get entity by id',
    );
  }
}
```

### **Provider Factory Template**
```dart
final myUseCaseProvider = ProviderFactory.useCase1(
  MyUseCase.new,
  myRepositoryProvider,
);

final myRepositoryProvider = ProviderFactory.repository(
  MyRepositoryImpl.new,
  myDataSourceProvider,
);
```

---

## 🎯 성공 체크리스트

- [ ] `flutter pub run build_runner build` 성공
- [ ] `flutter analyze` 에러 0개
- [ ] 앱 실행 성공
- [ ] 기존 기능 정상 동작
- [ ] 코드 줄 수 50% 이상 감소
- [ ] 팀원과 공유 완료

---

**작성일:** 2025-11-10
**예상 적용 시간:** 30분 - 1시간
**난이도:** ⭐⭐ (중급)
**ROI:** ⭐⭐⭐⭐⭐ (매우 높음)

**지금 바로 시작하세요!** 🚀
