# MyFinance Flutter Project Guide

> AI(Claude)가 프로젝트 작업 시 참조하는 종합 가이드

---

## 프로젝트 개요

| 항목 | 내용 |
|------|------|
| **앱 이름** | MyFinance (Toss-style 금융 관리 앱) |
| **아키텍처** | Clean Architecture + Riverpod 2.5+ |
| **백엔드** | Supabase (PostgreSQL + RPC) |
| **Feature 모듈** | 34개 |
| **디자인 시스템** | Toss Design System (토큰화) |

---

## 핵심 규칙 (CRITICAL)

### 절대 금지사항
1. `lib/shared/` 폴더 파일 **절대 수정 금지**
2. **하드코딩 금지** - 모든 값은 디자인 토큰 사용 필수

```dart
// ❌ BAD - 하드코딩
fontSize: 14
Color(0xFF212529)
EdgeInsets.all(16)
BorderRadius.circular(12)

// ✅ GOOD - 디자인 토큰
TossTextStyles.body
TossColors.textPrimary
TossSpacing.paddingMD
TossBorderRadius.card
```

---

## Build Commands

```bash
# 의존성 설치
flutter pub get

# 코드 생성 (freezed, riverpod_generator, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# 정적 분석
flutter analyze

# 코드 포맷팅 (커밋 전 필수)
dart format .

# 테스트 실행
flutter test

# 앱 실행
flutter run
```

---

## Skills (명령어)

### 디자인 & 페이지 생성
| Skill | 명령어 | 용도 |
|-------|--------|------|
| Design System | `/design-system` | UI/위젯 작업 시 디자인 토큰 참조 |
| Page Template | `/page-template` | 새 페이지 생성 시 템플릿 참조 |

### 아키텍처 검수
| Skill | 명령어 | 용도 |
|-------|--------|------|
| Architecture Audit | `/architecture-audit` | Clean Architecture 전체 검수 |

### 리팩토링 가이드 (우선순위 순서)
| Skill | 명령어 | 용도 |
|-------|--------|------|
| Refactor Master | `/refactor:refactor-master(0)` | 리팩토링 종합 가이드 |
| God File Refactor | `/refactor:god-file-refactor(1)` | 1000줄+ 파일 분리 |
| God Class Split | `/refactor:god-class-split(2)` | 다중 클래스 파일 분리 |
| Entity-DTO Separation | `/refactor:entity-dto-separation(3)` | Entity/DTO 분리 |
| Riverpod Migration | `/refactor:riverpod-migration(4)` | @riverpod 마이그레이션 |
| Either Pattern | `/refactor:either-pattern(5)` | Either 에러 처리 적용 |
| DI Restructure | `/refactor:di-restructure(6)` | DI 구조 정리 |

---

## 프로젝트 구조

```
lib/
├── app/                    # 앱 설정, 라우팅 (GoRouter)
│   ├── config/            # app_router.dart
│   └── providers/         # 글로벌 Provider (auth, app state)
├── core/                   # 공통 유틸리티
│   ├── cache/             # Hive 로컬 저장소
│   ├── errors/            # Failure 클래스
│   ├── services/          # Supabase, RevenueCat
│   └── utils/             # 헬퍼 함수
├── features/               # 34개 Feature 모듈 (Clean Architecture)
│   └── [feature_name]/
│       ├── data/          # DataSource, DTO, Repository Impl
│       ├── domain/        # Entity, Repository Interface, UseCase
│       └── presentation/  # Page, Provider, Widget
└── shared/                 # 공용 위젯/테마 (수정 금지!)
    ├── themes/            # 디자인 토큰 (TossColors, TossSpacing 등)
    └── widgets/           # Atomic Design 위젯
```

---

## Clean Architecture 규칙 (2025)

### 의존성 방향 (The Dependency Rule)
```
┌─────────────────────────────────────────────────────┐
│                 PRESENTATION                         │
│  (Pages, Widgets, Providers)                        │
│              ↓ depends on ↓                         │
├─────────────────────────────────────────────────────┤
│                   DOMAIN                             │
│  (Entities, Repository Interfaces, UseCases)        │
│  ⚠️ 외부 의존성 금지 (순수 Dart만)                   │
│              ↑ implements ↑                         │
├─────────────────────────────────────────────────────┤
│                    DATA                              │
│  (Models/DTOs, DataSources, Repository Impl)        │
│  Supabase, HTTP, SharedPreferences 등 허용          │
└─────────────────────────────────────────────────────┘

✅ Presentation → Domain (OK)
✅ Data → Domain (implements interface)
❌ Domain → Data (VIOLATION)
❌ Domain → Presentation (VIOLATION)
```

### Domain 레이어 순수성
```dart
// ❌ Domain에서 금지
import 'package:flutter/material.dart';    // Flutter UI
import 'package:supabase_flutter/...';     // 외부 패키지
import '../data/...';                       // Data 레이어
@riverpod                                   // Riverpod

// ✅ Domain에서 허용
import 'package:freezed_annotation/...';   // freezed (순수 Dart)
import 'package:dartz/dartz.dart';         // Either (순수 Dart)
```

### Entity vs DTO 분리
```dart
// domain/entities/user.dart - 순수 Entity
@freezed
class User with _$User {
  const factory User({required String id, required String name}) = _User;
  // ❌ fromJson/toJson 금지
}

// data/models/user_dto.dart - DTO (JSON 직렬화)
@freezed
class UserDto with _$UserDto {
  const factory UserDto({...}) = _UserDto;
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  // ✅ Entity 변환 메서드 필수
  User toEntity() => User(id: id, name: name);
}
```

### Repository 패턴
```dart
// domain/repositories/user_repository.dart (Interface)
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);  // Either 패턴 권장
}

// data/repositories/user_repository_impl.dart (Implementation)
class UserRepositoryImpl implements UserRepository {
  final UserDataSource _dataSource;

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final dto = await _dataSource.fetchUser(id);
      return Right(dto.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

### 2025 UseCase 간소화
```dart
// ❌ 과거: 모든 것에 UseCase
class GetUserUseCase {
  final UserRepository _repo;
  Future<User> call(String id) => _repo.getUser(id);
}

// ✅ 2025: 단순 CRUD는 Provider에서 Repository 직접 사용
@riverpod
Future<User> user(UserRef ref, String id) {
  return ref.watch(userRepositoryProvider).getUser(id);
}

// ✅ UseCase는 복잡한 비즈니스 로직에만 사용
class TransferMoneyUseCase {
  // 여러 Repository 조합, 트랜잭션, 복잡한 검증
}
```

---

## Riverpod 패턴 (2025)

### @riverpod 어노테이션 사용 (권장)
```dart
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  FutureOr<User?> build() => null;

  Future<void> loadUser(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).getUser(id),
    );
  }
}

// Provider DI
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepositoryImpl(remote: ref.watch(userDataSourceProvider));
}
```

### 페이지에서 사용
```dart
final state = ref.watch(userNotifierProvider);

return state.when(
  loading: () => const TossLoadingView(),
  error: (e, st) => TossErrorView(error: e, onRetry: _loadData),
  data: (data) => _buildContent(data),
);
```

---

## 디자인 토큰 Quick Reference

### Colors (TossColors.*)
| 토큰 | 용도 |
|------|------|
| `TossColors.primary` | 주요 액션, 브랜드 |
| `TossColors.textPrimary` | 본문 텍스트 |
| `TossColors.textSecondary` | 보조 텍스트 |
| `TossColors.error` | 에러, 삭제 |
| `TossColors.success` | 성공 |
| `TossColors.gray100` | 보조 배경 |
| `TossColors.border` | 테두리 |
| `TossColors.profit` | 수익 (녹색) |
| `TossColors.loss` | 손실 (빨간) |

### Spacing (TossSpacing.* - 4px Grid)
| 토큰 | 값 | 용도 |
|------|-----|------|
| `TossSpacing.paddingXL` | 24px | 페이지 패딩 |
| `TossSpacing.paddingLG` | 20px | 섹션 패딩 |
| `TossSpacing.paddingMD` | 16px | 카드 패딩 |
| `TossSpacing.gapLG` | 16px | 카드 콘텐츠 간격 |
| `TossSpacing.gapMD` | 12px | 폼 필드 간격 |
| `TossSpacing.gapSM` | 8px | 버튼 콘텐츠 간격 |

### Typography (TossTextStyles.*)
| 토큰 | 용도 |
|------|------|
| `TossTextStyles.h1` | 페이지 제목 (28px, w700) |
| `TossTextStyles.h2` | 섹션 제목 (24px, w700) |
| `TossTextStyles.h4` | 카드 제목 (18px, w600) |
| `TossTextStyles.body` | 본문 (14px, w400) |
| `TossTextStyles.caption` | 캡션 (12px, w400) |
| `TossTextStyles.amount` | 금액 (20px, JetBrains Mono) |

### Border Radius (TossBorderRadius.*)
| 토큰 | 용도 |
|------|------|
| `TossBorderRadius.card` | 카드 (12px) |
| `TossBorderRadius.button` | 버튼 (8px) |
| `TossBorderRadius.dialog` | 다이얼로그 (16px) |
| `TossBorderRadius.bottomSheet` | 바텀시트 (20px) |

---

## 필수 컴포넌트

| 용도 | 컴포넌트 |
|------|---------|
| 페이지 래퍼 | `TossScaffold` |
| 앱바 | `TossAppBar` |
| 로딩 | `TossLoadingView` / Skeleton |
| 에러 | `TossErrorView` |
| 빈 상태 | `TossEmptyView` |
| 버튼 | `TossButton.primary()` |
| 카드 | `TossCard`, `TossWhiteCard` |

---

## Import 규칙

```dart
// 공용 Import (권장)
import 'package:myfinance_improved/shared/index.dart';

// 개별 Import
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
```

---

## Backend 연동 (Supabase)

### RPC 호출 패턴
```dart
// DataSource에서 RPC 호출
final response = await supabase.rpc(
  'get_sales_analytics',
  params: {'p_company_id': companyId, 'p_store_id': storeId},
);
```

### Error Handling (Either 패턴)
```dart
// dartz 패키지 사용
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final dto = await _dataSource.fetchUser(id);
    return Right(dto.toEntity());
  } on PostgrestException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
    return Left(UnknownFailure(e.toString()));
  }
}
```

### Failure 클래스 (core/errors/failures.dart)
- `ServerFailure` - Supabase 에러
- `ValidationFailure` - 입력 검증
- `AuthFailure` - 인증 에러
- `NotFoundFailure` - 404
- `UnknownFailure` - 예상치 못한 에러

---

## Feature 폴더 구조

```
lib/features/[feature_name]/
├── data/
│   ├── datasources/
│   │   └── [feature]_datasource.dart
│   ├── models/
│   │   └── [feature]_dto.dart          # freezed + json_serializable
│   └── repositories/
│       └── [feature]_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── [feature].dart              # freezed (순수)
│   ├── repositories/
│   │   └── [feature]_repository.dart   # abstract interface
│   └── usecases/                       # 복잡한 로직만 (Optional)
└── presentation/
    ├── pages/
    │   └── [feature]_page.dart
    ├── providers/
    │   └── [feature]_notifier.dart     # @riverpod
    └── widgets/
```

---

## 모범 Feature 예시

- `lib/features/attendance/` - Clean Architecture 완벽 적용

---

## DO's and DON'Ts

### DO (권장)
- `TossScaffold`로 모든 페이지 감싸기
- `SafeArea`로 노치/홈 인디케이터 영역 처리
- `TossSpacing.paddingXL` (24px)로 페이지 패딩
- 로딩: `TossLoadingView` 또는 Skeleton
- 에러: `TossErrorView` with `onRetry`
- 빈 상태: `TossEmptyView` with icon, title, message
- `@riverpod` 어노테이션 사용
- `Either<Failure, T>` 에러 처리 패턴

### DON'T (금지)
- 하드코딩 (색상, 폰트, 패딩, BorderRadius)
- Native `Scaffold` 직접 사용
- `lib/shared/` 파일 수정
- Domain에서 외부 패키지 import
- Page/Widget에서 Supabase 직접 호출
- Entity에 `fromJson`/`toJson` 추가

---

## God File 기준

| 줄 수 | 상태 | 조치 |
|-------|------|------|
| 500줄 이상 | ⚠️ Warning | 분리 검토 |
| 1000줄 이상 | 🔥 Critical | 반드시 리팩토링 |

---

## 참고 자료

- [Flutter Clean Architecture 2025](https://medium.com/@tiger.chirag/flutter-clean-architecture-in-2025-the-right-way-to-structure-real-apps-152cf59f39f5)
- [Code With Andrea - Flutter App Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)
- [Flutter Official Architecture Guide](https://docs.flutter.dev/app-architecture/guide)
