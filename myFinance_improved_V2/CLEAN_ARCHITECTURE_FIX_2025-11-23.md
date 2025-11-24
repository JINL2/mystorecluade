# Clean Architecture 수정 완료 - Journal Input Feature

## 문제 발생 배경

Journal Entry 제출 시 다음 에러 발생:
```
UnimplementedError: JournalEntryRepository implementation must be provided by the data layer.
Make sure to override this provider with the actual implementation.
```

## 원인 분석

### 잘못된 구조 (이전)
```
Domain Layer: journalEntryRepositoryProvider → UnimplementedError
Data Layer:   journalEntryRepositoryProvider → Actual Implementation
Presentation: import domain provider → UnimplementedError 발생!
```

**문제점**: Domain과 Data layer에서 같은 이름의 provider를 정의했지만, override가 없어서 Presentation이 domain의 빈 구현체를 사용

## 해결 방법

### Clean Architecture 원칙 준수

**의존성 규칙**:
```
Presentation Layer → Domain Layer (Interface only)
Data Layer → Domain Layer (Implements interface)
```

### 구현 방법: Provider Override Pattern

#### 1. Domain Layer (Interface 정의)
**파일**: `lib/features/journal_input/domain/providers/repository_providers.dart`
```dart
final journalEntryRepositoryProvider = Provider<JournalEntryRepository>((ref) {
  throw UnimplementedError(
    'JournalEntryRepository implementation must be provided by the data layer. '
    'Make sure to override this provider with the actual implementation.',
  );
});
```

#### 2. Data Layer (Implementation 제공)
**파일**: `lib/features/journal_input/data/repositories/repository_providers.dart`
```dart
final journalEntryRepositoryProvider = Provider<JournalEntryRepository>((ref) {
  final dataSource = ref.watch(journalEntryDataSourceProvider);
  return JournalEntryRepositoryImpl(dataSource);
}, name: 'journalEntryRepositoryProvider');
```

#### 3. Presentation Layer (Domain만 import)
**파일**: `lib/features/journal_input/presentation/providers/journal_input_providers.dart`
```dart
// ✅ Only import from Domain layer
import '../../domain/providers/repository_providers.dart';

// Use the provider (implementation injected at runtime)
final journalAccountsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(journalEntryRepositoryProvider);
  return await repository.getAccounts();
});
```

#### 4. Main.dart (Dependency Injection)
**파일**: `lib/main.dart`
```dart
import 'features/journal_input/data/repositories/repository_providers.dart'
    as journal_data;
import 'features/journal_input/domain/providers/repository_providers.dart'
    as journal_domain;

runApp(
  ProviderScope(
    overrides: [
      // Override domain layer provider with data layer implementation
      journal_domain.journalEntryRepositoryProvider
          .overrideWithProvider(journal_data.journalEntryRepositoryProvider),
    ],
    child: const MyFinanceApp(),
  ),
);
```

## 최종 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                      main.dart                               │
│  ProviderScope(                                              │
│    overrides: [domain → data implementation]                │
│  )                                                           │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              Presentation Layer                              │
│  - import domain/providers/repository_providers.dart        │
│  - Uses journalEntryRepositoryProvider                       │
│  - No knowledge of Data layer                                │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                Domain Layer (Interface)                      │
│  - Defines JournalEntryRepository interface                  │
│  - Defines journalEntryRepositoryProvider (stub)             │
└─────────────────────────────────────────────────────────────┘
                           ▲
                           │ implements
┌─────────────────────────────────────────────────────────────┐
│                Data Layer (Implementation)                   │
│  - JournalEntryRepositoryImpl                                │
│  - journalEntryRepositoryProvider (actual)                   │
│  - Supabase datasources                                      │
└─────────────────────────────────────────────────────────────┘
```

## Clean Architecture 원칙 준수 체크

✅ **의존성 역전 원칙 (Dependency Inversion)**
- Presentation은 Domain interface에만 의존
- Data layer가 Domain interface를 구현

✅ **단일 책임 원칙 (Single Responsibility)**
- Domain: 비즈니스 로직 인터페이스
- Data: 외부 데이터 소스 구현
- Presentation: UI 상태 관리

✅ **의존성 규칙 (Dependency Rule)**
- Presentation → Domain (O)
- Presentation → Data (X)
- Data → Domain (O)
- Main → All layers (의존성 주입만)

## 테스트 방법

1. 앱 실행
2. Journal Entry 페이지 접근
3. 거래 입력 (Debits/Credits)
4. Submit Journal Entry 클릭
5. ✅ 정상 제출되어야 함

## 참고: 다른 Feature에도 적용 가능

이 패턴은 다음 feature들에도 동일하게 적용 가능:
- cash_ending
- cash_location
- register_denomination
- 기타 모든 feature

### 적용 방법 템플릿

1. Domain layer에 stub provider 정의
2. Data layer에 실제 구현 provider 정의
3. Presentation은 domain만 import
4. main.dart에서 override로 연결

## 변경 파일 목록

### 수정된 파일
- `lib/main.dart` - Provider overrides 추가
- `lib/features/journal_input/presentation/providers/journal_input_providers.dart` - Domain import 유지

### 유지된 파일
- `lib/features/journal_input/domain/providers/repository_providers.dart` - Interface provider
- `lib/features/journal_input/data/repositories/repository_providers.dart` - Implementation provider

## 결론

Clean Architecture의 의존성 규칙을 엄격히 준수하면서, Riverpod의 Provider Override 패턴을 사용하여 문제를 해결했습니다. 이 방식은:

1. **테스트 용이성**: Mock provider로 쉽게 교체 가능
2. **유지보수성**: Layer 간 결합도 최소화
3. **확장성**: 새로운 구현체 추가 용이
4. **명확성**: 각 layer의 책임이 명확함

---
**작성일**: 2025-11-23
**작성자**: Claude Code
