# MyFinance V2 Architecture - THE LAW 📜

> **이 문서는 이 프로젝트의 법입니다.**
> **모든 코드는 반드시 이 규칙을 따라야 합니다. 팀 논의 없이 예외는 없습니다.**

---

## 목차 (Table of Contents)
1. [핵심 원칙 (Core Principles)](#핵심-원칙-core-principles)
2. [전체 디렉토리 구조 (Complete Directory Structure)](#전체-디렉토리-구조-complete-directory-structure)
3. [레이어별 상세 설명 (Layer Details)](#레이어별-상세-설명-layer-details)
4. [The Law: 무엇을 어디에 두는가](#the-law-무엇을-어디에-두는가)
5. [Import 규칙 (Import Rules)](#import-규칙-import-rules)
6. [실전 예제 (Practical Examples)](#실전-예제-practical-examples)
7. [흔한 실수 (Common Mistakes)](#흔한-실수-common-mistakes)
8. [집행 (Enforcement)](#집행-enforcement)

---

## 핵심 원칙 (Core Principles)

### 1. Clean Architecture
우리는 **Clean Architecture**를 따릅니다 (3개 레이어):
- **Domain Layer** (도메인): 비즈니스 엔티티, repository 인터페이스
- **Data Layer** (데이터): Repository 구현체, data source, models
- **Presentation Layer** (프레젠테이션): UI, 위젯, 상태 관리

### 2. Feature-First Organization
각 feature는 **완전히 독립**되어 있으며 자체 domain/data/presentation 레이어를 가집니다.

### 3. 명확한 분리 (Clear Separation)
```
app/      = 앱 레벨 설정 (라우터, 글로벌 상태, 네비게이션)
core/     = 인프라 & 유틸리티 (UI 없음, 완전한 feature 없음)
shared/   = UI 컴포넌트 & 디자인 시스템 (비즈니스 로직 없음, 인프라 없음)
features/ = 완전한 feature 구현 (domain/data/presentation 레이어 포함)
```

---

## 전체 디렉토리 구조 (Complete Directory Structure)

```
lib/
├── app/                           # 📱 Application Layer (앱 레벨)
│   ├── navigation/               # 앱 레벨 네비게이션 설정
│   │   └── navigation_config.dart
│   ├── providers/                # 글로벌 앱 상태 (AppState)
│   │   ├── app_state.dart        # AppState 정의 (Freezed)
│   │   ├── app_state_provider.dart  # AppState Riverpod provider
│   │   └── homepage_providers.dart  # Homepage 관련 providers
│   └── router.dart               # 라우트 정의 (GoRouter)
│
├── core/                          # 🔧 Infrastructure & Cross-Cutting Concerns
│   ├── cache/                    # ✅ 캐싱 인프라
│   │   └── auth_data_cache.dart # 인증 데이터 캐시
│   ├── config/                   # ✅ 앱 설정
│   │   └── widget_migration_config.dart
│   ├── constants/                # ✅ 앱 전체 상수
│   │   ├── icon_mapper.dart     # 아이콘 매핑
│   │   ├── ui_constants.dart    # UI 상수
│   │   └── auth_constants.dart  # 인증 상수
│   ├── domain/                   # ✅ 공유 도메인 엔티티
│   │   └── entities/
│   │       ├── feature.dart      # 여러 feature에서 사용하는 엔티티만!
│   │       ├── company.dart
│   │       └── store.dart
│   ├── enums/                    # ✅ 공유 열거형
│   ├── errors/                   # ✅ 커스텀 예외
│   ├── infrastructure/           # ✅ 인프라 유틸리티
│   │   └── state_synchronizer.dart  # 상태 동기화
│   ├── interfaces/               # ✅ 추상 인터페이스
│   ├── navigation/               # ✅ 네비게이션 유틸리티
│   │   └── safe_navigation.dart # 안전한 네비게이션 헬퍼
│   ├── notifications/            # ⚠️ 횡단 관심사 알림 시스템
│   │   ├── config/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── services/
│   │   └── utils/
│   ├── services/                 # ✅ 인프라 서비스
│   │   └── supabase_service.dart  # Supabase 클라이언트 래퍼
│   └── utils/                    # ✅ 순수 유틸리티 함수
│       ├── number_formatter.dart # 숫자 포맷터
│       ├── text_utils.dart       # 텍스트 유틸
│       └── color_opacity_helper.dart
│
├── shared/                        # 🎨 Presentation Layer - UI Only!
│   ├── extensions/               # ✅ Dart/Flutter 확장
│   ├── styles/                   # ✅ 스타일 상수
│   ├── themes/                   # ✅ 디자인 시스템 토큰
│   │   ├── toss_colors.dart      # 색상 팔레트
│   │   ├── toss_text_styles.dart # 타이포그래피
│   │   ├── toss_spacing.dart     # 간격 시스템
│   │   ├── toss_animations.dart  # 애니메이션
│   │   ├── toss_border_radius.dart # 테두리 반경
│   │   ├── toss_shadows.dart     # 그림자
│   │   ├── toss_icons.dart       # 아이콘 시스템
│   │   └── app_theme.dart        # 앱 테마 설정
│   └── widgets/                  # ✅ 재사용 가능한 UI 컴포넌트
│       ├── common/               # 📦 공통 위젯 (프로젝트 전체에서 사용)
│       │   ├── toss_scaffold.dart
│       │   ├── toss_app_bar.dart
│       │   ├── toss_dialog.dart
│       │   ├── toss_loading_view.dart
│       │   ├── toss_empty_view.dart
│       │   ├── toss_error_view.dart
│       │   ├── toss_section_header.dart
│       │   ├── toss_white_card.dart
│       │   ├── toss_date_picker.dart
│       │   └── enhanced_quantity_selector.dart
│       ├── selectors/            # 📦 Selector 위젯
│       │   ├── toss_base_selector.dart
│       │   └── enhanced_account_selector.dart
│       └── toss/                 # 📦 Toss 디자인 시스템 컴포넌트
│           ├── toss_button.dart
│           ├── toss_text_field.dart
│           ├── toss_enhanced_text_field.dart
│           ├── toss_card.dart
│           ├── toss_card_safe.dart
│           ├── toss_chip.dart
│           ├── toss_badge.dart
│           ├── toss_bottom_sheet.dart
│           ├── toss_modal.dart
│           ├── toss_dropdown.dart
│           ├── toss_list_tile.dart
│           ├── toss_tab_bar.dart
│           ├── toss_icon_button.dart
│           ├── toss_search_field.dart
│           ├── toss_time_picker.dart
│           ├── toss_refresh_indicator.dart
│           ├── toss_smart_action_bar.dart
│           ├── toss_keyboard_toolbar.dart
│           ├── toss_selection_bottom_sheet.dart
│           ├── modal_keyboard_patterns.dart
│           └── keyboard/
│               ├── toss_numberpad_modal.dart
│               └── toss_textfield_keyboard_modal.dart
│
└── features/                      # 🎯 Feature Modules (Clean Architecture)
    ├── auth/                      # 인증 feature
    │   ├── domain/
    │   │   ├── entities/          # 비즈니스 객체
    │   │   ├── repositories/      # Repository 인터페이스
    │   │   ├── value_objects/     # Value objects (email, currency 등)
    │   │   └── exceptions/        # Feature 특화 예외
    │   ├── data/
    │   │   ├── datasources/       # API 호출, DB 쿼리
    │   │   ├── models/            # DTO + Mapper (통합)
    │   │   └── repositories/      # Repository 구현체
    │   └── presentation/
    │       ├── pages/             # 전체 페이지 스크린
    │       ├── widgets/           # Feature 특화 위젯
    │       └── providers/         # Riverpod providers
    │
    ├── homepage/                  # 홈페이지 feature
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── category_with_features.dart
    │   │   │   └── user_with_companies.dart
    │   │   └── repositories/
    │   │       └── homepage_repository.dart
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── homepage_data_source.dart
    │   │   ├── models/
    │   │   │   ├── category_features_model.dart
    │   │   │   ├── user_companies_model.dart
    │   │   │   ├── revenue_model.dart
    │   │   │   └── top_feature_model.dart
    │   │   └── repositories/
    │   │       ├── homepage_repository_impl.dart
    │   │       └── repository_providers.dart
    │   └── presentation/
    │       ├── pages/
    │       │   └── homepage.dart
    │       └── widgets/
    │           ├── feature_grid.dart
    │           ├── feature_card.dart
    │           ├── revenue_card.dart
    │           └── quick_access_section.dart
    │
    ├── transaction_template_refectore/  # 트랜잭션 템플릿 feature
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    │
    └── [other features]/          # 다른 features...
```

---

## 레이어별 상세 설명 (Layer Details)

### 📱 `app/` - Application Layer

**역할**: 앱 레벨 설정 및 글로벌 상태 관리

**포함되어야 하는 것**:
- ✅ GoRouter 라우트 정의
- ✅ 글로벌 AppState (Riverpod)
- ✅ 앱 레벨 네비게이션 설정
- ✅ 여러 feature에서 사용하는 provider 정의

**포함되면 안 되는 것**:
- ❌ 비즈니스 로직
- ❌ UI 컴포넌트
- ❌ Data source 구현

**예제**:
```dart
// ✅ app/router.dart
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
  ],
);

// ✅ app/providers/app_state_provider.dart
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});
```

---

### 🔧 `core/` - Infrastructure & Cross-Cutting Concerns

**역할**: 인프라 서비스 및 횡단 관심사

**포함되어야 하는 것**:
- ✅ 인프라 서비스 (Supabase, HTTP 클라이언트, 로깅)
- ✅ 캐싱 시스템 (AuthDataCache 등)
- ✅ 상태 동기화 유틸리티
- ✅ 여러 feature에서 공유되는 도메인 엔티티
- ✅ 상수 (API 엔드포인트, 설정 값)
- ✅ 순수 유틸리티 함수 (포맷터, 검증기)
- ✅ 커스텀 예외/오류
- ✅ 추상 인터페이스/기본 클래스
- ✅ 네비게이션 유틸리티

**포함되면 안 되는 것**:
- ❌ UI 컴포넌트 (위젯, 버튼, 카드)
- ❌ 디자인 시스템 토큰 (색상, 타이포그래피, 간격)
- ❌ Repository가 있는 완전한 feature 구현
- ❌ Feature 특화 비즈니스 로직

**핵심 규칙**: `core/`는 **횡단 관심사** (여러 feature에서 사용)를 포함하지만, Clean Architecture 레이어 (domain/data/presentation)를 포함해서는 안 됩니다.

**예제**:
```dart
// ✅ core/services/supabase_service.dart
class SupabaseService {
  SupabaseClient get client => Supabase.instance.client;
}

// ✅ core/utils/number_formatter.dart
String formatCurrency(double amount) => ...;

// ✅ core/cache/auth_data_cache.dart
class AuthDataCache {
  Future<T> deduplicate<T>(String key, Future<T> Function() apiCall) async {...}
}
```

---

### 🎨 `shared/` - Presentation Layer (UI Only!)

**역할**: 재사용 가능한 UI 컴포넌트 및 디자인 시스템

**포함되어야 하는 것**:
- ✅ 재사용 가능한 UI 위젯 (버튼, 카드, 입력)
- ✅ 디자인 시스템 토큰 (색상, 타이포그래피, 간격, 그림자)
- ✅ 테마 설정
- ✅ UI 스타일링 상수
- ✅ Dart/Flutter 확장 (편의 기능)
- ✅ **Common widgets** (`shared/widgets/common/`) - 프로젝트 전체에서 사용하는 공통 위젯

**포함되면 안 되는 것**:
- ❌ 비즈니스 로직 또는 use case
- ❌ Data layer 코드 (repository, data source)
- ❌ 도메인 엔티티
- ❌ 인프라 서비스 (데이터베이스, API)
- ❌ 캐싱 시스템
- ❌ 상태 동기화 로직

**핵심 원칙**: 디자이너가 관심 있는 것 → `shared/`. 백엔드 엔지니어가 관심 있는 것 → `core/`.

**`shared/widgets/` 하위 구조**:
```
shared/widgets/
├── common/        # 📦 프로젝트 전체에서 사용하는 공통 위젯
│                  # 예: TossScaffold, TossAppBar, TossDialog, TossLoadingView
├── selectors/     # 📦 Selector 관련 위젯
│                  # 예: TossBaseSelector, EnhancedAccountSelector
└── toss/          # 📦 Toss 디자인 시스템 기본 컴포넌트
                   # 예: TossButton, TossTextField, TossCard
```

**예제**:
```dart
// ✅ shared/widgets/toss/toss_button.dart
class TossButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  // ... UI 구현
}

// ✅ shared/themes/toss_colors.dart
class TossColors {
  static const Color blue600 = Color(0xFF3182F6);
  static const Color gray900 = Color(0xFF191F28);
}

// ✅ shared/widgets/common/toss_scaffold.dart
class TossScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  // ... 프로젝트 전체에서 사용하는 공통 Scaffold
}
```

---

### 🎯 `features/` - Complete Feature Implementation

**역할**: 완전한 feature 구현 (Clean Architecture)

**포함되어야 하는 것**:
- ✅ domain/data/presentation 레이어를 가진 완전한 feature
- ✅ Feature 특화 엔티티
- ✅ Feature 특화 repository
- ✅ Feature 특화 use case
- ✅ Feature 특화 UI 페이지 및 위젯

**각 feature의 구조**:
```
features/my_feature/
├── domain/
│   ├── entities/           # 비즈니스 객체
│   ├── repositories/       # 추상 repository 인터페이스
│   ├── value_objects/      # Value objects (email, currency 등)
│   └── exceptions/         # Feature 특화 예외
├── data/
│   ├── datasources/        # API 호출, 데이터베이스 쿼리
│   ├── models/             # DTO + Mapper (통합)
│   └── repositories/       # Repository 구현체
└── presentation/
    ├── pages/              # 전체 페이지 스크린
    ├── widgets/            # Feature 특화 위젯
    └── providers/          # Riverpod providers
```

---

## The Law: 무엇을 어디에 두는가

### 규칙 1: `app/` = 앱 레벨 설정만

```dart
✅ app/router.dart                  # 라우트 정의
✅ app/providers/app_state_provider.dart  # 글로벌 AppState
✅ app/navigation/navigation_config.dart  # 네비게이션 설정
✅ app/providers/homepage_providers.dart  # 여러 곳에서 사용하는 provider

❌ app/widgets/my_button.dart       # UI는 shared/에
❌ app/services/api_service.dart    # 서비스는 core/에
```

### 규칙 2: `core/` = 인프라만, 완전한 feature 없음

```dart
✅ core/services/supabase_service.dart      # 인프라 서비스
✅ core/cache/auth_data_cache.dart          # 캐싱
✅ core/utils/number_formatter.dart         # 유틸리티
✅ core/domain/entities/company.dart        # 공유 엔티티 (여러 feature에서 사용)
✅ core/infrastructure/state_synchronizer.dart  # 인프라 유틸리티

❌ core/notifications/repositories/notification_repository.dart  # Repository가 있는 완전한 feature
❌ core/widgets/button.dart                 # UI는 shared/에
❌ core/homepage/homepage_page.dart         # Feature는 features/에
```

### 규칙 3: `shared/` = UI만, 비즈니스 로직 없음

```dart
✅ shared/widgets/toss/toss_button.dart     # UI 위젯
✅ shared/widgets/common/toss_app_bar.dart  # 공통 위젯
✅ shared/themes/toss_colors.dart           # 디자인 토큰
✅ shared/extensions/string_extensions.dart # Flutter 확장

❌ shared/data/services/api_service.dart    # 서비스는 core/에
❌ shared/domain/entities/user.dart         # 엔티티는 core/domain/ 또는 features/에
❌ shared/cache/data_cache.dart             # 캐싱은 core/에
❌ shared/synchronization/sync.dart         # 인프라는 core/에
```

### 규칙 4: `features/` = 완전한 feature (domain/data/presentation)

```dart
✅ features/homepage/domain/entities/category_with_features.dart
✅ features/homepage/data/repositories/homepage_repository_impl.dart
✅ features/homepage/presentation/pages/homepage.dart
✅ features/auth/domain/value_objects/email.dart

❌ features/homepage/utils/string_formatter.dart  # 공통 유틸은 core/utils/에
❌ features/auth/themes/colors.dart               # 테마는 shared/themes/에
```

---

## Import 규칙 (Import Rules)

### 1. 테마 Imports - **항상** `shared/themes/` 사용

```dart
// ✅ 올바름
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

// ❌ 틀림 (core/themes는 삭제되었음)
import 'package:myfinance_improved/core/themes/toss_colors.dart';
```

### 2. 도메인 엔티티 Imports - `core/domain/entities/` 사용

```dart
// ✅ 올바름 (여러 feature에서 공유하는 엔티티)
import 'package:myfinance_improved/core/domain/entities/feature.dart';
import 'package:myfinance_improved/core/domain/entities/company.dart';

// ❌ 틀림 (shared/domain은 삭제되었음)
import 'package:myfinance_improved/shared/domain/entities/feature.dart';
```

### 3. 서비스 Imports - `core/services/` 사용

```dart
// ✅ 올바름
import 'package:myfinance_improved/core/services/supabase_service.dart';

// ❌ 틀림 (shared/data/services는 삭제되었음)
import 'package:myfinance_improved/shared/data/services/supabase_service.dart';
```

### 4. 인프라 Imports - `core/` 사용

```dart
// ✅ 올바름
import 'package:myfinance_improved/core/cache/auth_data_cache.dart';
import 'package:myfinance_improved/core/infrastructure/state_synchronizer.dart';

// ❌ 틀림 (shared/cache 및 shared/synchronization은 삭제되었음)
import 'package:myfinance_improved/shared/cache/auth_data_cache.dart';
import 'package:myfinance_improved/shared/synchronization/state_synchronizer.dart';
```

### 5. 앱 레벨 Imports - `app/` 사용

```dart
// ✅ 올바름
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/app/router.dart';
```

### 6. 파일 내 Import 순서

```dart
// 1. Flutter/Dart imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 2. 외부 패키지 imports
import 'package:supabase_flutter/supabase_flutter.dart';

// 3. Shared - Theme System (UI)
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

// 4. Shared - Widgets
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar.dart';

// 5. Core - Infrastructure
import 'package:myfinance_improved/core/services/supabase_service.dart';
import 'package:myfinance_improved/core/cache/auth_data_cache.dart';

// 6. App-level
import 'package:myfinance_improved/app/providers/app_state_provider.dart';

// 7. Feature imports (domain -> data -> presentation)
import '../../domain/entities/my_entity.dart';
import '../models/my_model.dart';
```

---

## 실전 예제 (Practical Examples)

### 예제 1: 새 공통 위젯 만들기

**시나리오**: 프로젝트 전체에서 사용할 "TossBottomSheet" 위젯을 만들고 싶다.

```dart
// ✅ 올바른 위치: shared/widgets/common/toss_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

class TossBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;

  const TossBottomSheet({
    super.key,
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossSpacing.large),
        ),
      ),
      child: Column(
        children: [
          if (title != null)
            Text(title!, style: TossTextStyles.heading1),
          child,
        ],
      ),
    );
  }
}
```

**왜 `shared/widgets/common/`?**:
- UI 컴포넌트이고
- 프로젝트 전체에서 사용되며
- 비즈니스 로직이 없음

---

### 예제 2: 새 인프라 서비스 만들기

**시나리오**: HTTP 요청을 처리하는 서비스를 만들고 싶다.

```dart
// ✅ 올바른 위치: core/services/http_service.dart
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl;

  HttpService({required this.baseUrl});

  Future<http.Response> get(String path) async {
    return await http.get(Uri.parse('$baseUrl$path'));
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse('$baseUrl$path'),
      body: body,
    );
  }
}
```

**왜 `core/services/`?**:
- 인프라 서비스이고
- 여러 feature에서 사용되며
- UI가 아님

---

### 예제 3: 새 Feature 만들기

**시나리오**: "Profile" feature를 만들고 싶다.

```
features/profile/
├── domain/
│   ├── entities/
│   │   └── user_profile.dart          # 엔티티
│   ├── repositories/
│   │   └── profile_repository.dart    # Repository 인터페이스
│   └── exceptions/
│       └── profile_exceptions.dart
├── data/
│   ├── datasources/
│   │   └── profile_data_source.dart   # API 호출
│   ├── models/
│   │   └── user_profile_model.dart    # DTO + Mapper
│   └── repositories/
│       └── profile_repository_impl.dart  # Repository 구현
└── presentation/
    ├── pages/
    │   └── profile_page.dart          # UI 페이지
    ├── widgets/
    │   ├── profile_header.dart        # Feature 특화 위젯
    │   └── profile_stats_card.dart
    └── providers/
        └── profile_provider.dart      # Riverpod provider
```

**왜 `features/profile/`?**:
- 완전한 기능이고
- domain/data/presentation 레이어가 있으며
- 독립적으로 작동함

---

## 흔한 실수 (Common Mistakes)

### ❌ 실수 1: `shared/`에 인프라 넣기

```dart
// ❌ 틀림
// shared/data/services/supabase_service.dart
// shared/cache/auth_data_cache.dart

// ✅ 올바름
// core/services/supabase_service.dart
// core/cache/auth_data_cache.dart
```

**왜 틀렸나?** `shared/`는 UI 전용입니다. 인프라는 `core/`에 속합니다.

---

### ❌ 실수 2: `shared/`에 도메인 엔티티 넣기

```dart
// ❌ 틀림
// shared/domain/entities/company.dart

// ✅ 올바름
// core/domain/entities/company.dart (여러 feature에서 공유)
// features/company_management/domain/entities/company.dart (feature 특화)
```

**왜 틀렸나?** 도메인 엔티티는 비즈니스 객체이며 UI 컴포넌트가 아닙니다.

---

### ❌ 실수 3: `core/themes/` import 사용

```dart
// ❌ 틀림
import 'package:myfinance_improved/core/themes/toss_colors.dart';

// ✅ 올바름
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
```

**왜 틀렸나?** `core/themes/`는 삭제되었습니다. 모든 테마는 `shared/themes/`에 있습니다.

---

### ❌ 실수 4: `core/`에 완전한 Feature 넣기

```dart
// ❌ 틀림
// core/notifications/repositories/notification_repository.dart
// core/notifications/models/notification_model.dart

// ✅ 올바름 (feature인 경우)
// features/notifications/data/repositories/notification_repository_impl.dart
// features/notifications/data/models/notification_model.dart

// 또는 (인프라인 경우)
// core/services/notification_service.dart
```

**왜 틀렸나?** `core/`는 인프라 유틸리티 전용이며, 완전한 feature 구현이 아닙니다.

---

### ❌ 실수 5: `app/`에 UI 위젯 넣기

```dart
// ❌ 틀림
// app/widgets/custom_button.dart

// ✅ 올바름
// shared/widgets/toss/custom_button.dart (재사용 가능한 위젯)
// features/my_feature/presentation/widgets/custom_button.dart (feature 특화)
```

**왜 틀렸나?** `app/`은 앱 레벨 설정 전용입니다. UI 위젯은 `shared/` 또는 `features/`에 속합니다.

---

## 집행 (Enforcement)

### 1. 코드 리뷰 체크리스트

PR을 승인하기 전에 확인:
- [ ] `shared/`에 인프라 코드가 없음
- [ ] `core/`에 UI 위젯이 없음
- [ ] `core/`에 완전한 feature가 없음
- [ ] 모든 테마 import가 `shared/themes/` 사용
- [ ] 모든 엔티티 import가 `core/domain/entities/` 사용 (여러 feature에서 공유하는 경우)
- [ ] 모든 서비스 import가 `core/services/` 사용
- [ ] Feature가 domain/data/presentation 구조를 따름
- [ ] 공통 위젯이 `shared/widgets/common/`에 위치

### 2. 자동 검사 (향후)

```bash
# 금지된 import 확인
grep -r "import.*core/themes/" lib/
# 결과가 없어야 함

grep -r "import.*shared/domain/" lib/
# 결과가 없어야 함

grep -r "import.*shared/data/" lib/
# 결과가 없어야 함
```

### 3. 의심스러울 때

다음 질문을 해보세요:
1. **UI인가?** → `shared/`
2. **인프라/유틸리티인가?** → `core/`
3. **완전한 feature인가?** → `features/`
4. **앱 레벨 설정인가?** → `app/`
5. **여러 feature에서 공유하는 엔티티인가?** → `core/domain/entities/`
6. **Feature 특화인가?** → `features/[feature_name]/domain/entities/`

---

## 요약: 황금 규칙 (Golden Rules)

### 1. **`app/` = 앱 레벨만**
라우터, 글로벌 상태, 네비게이션 설정. 그 외에는 없음.

### 2. **`core/` = 인프라만**
서비스, 유틸리티, 캐싱, 상수. 완전한 feature 없음.

### 3. **`shared/` = UI만**
디자인 시스템, 위젯, 테마, 스타일. 비즈니스 로직 없음.

**`shared/widgets/`의 하위 구조**:
- `common/` = 프로젝트 전체에서 사용하는 공통 위젯
- `selectors/` = Selector 관련 위젯
- `toss/` = Toss 디자인 시스템 기본 컴포넌트

### 4. **`features/` = 완전한 FEATURES**
각 feature에 domain/data/presentation 레이어.

### 5. **테마 Import = `shared/themes/`**
항상 그리고 영원히.

### 6. **여러 Feature에서 공유하는 엔티티 = `core/domain/entities/`**
진정으로 여러 feature에서 공유하는 경우에만.

---

## 이것이 법입니다 📜

**모든 코드는 이 규칙을 따라야 합니다.**
**팀 논의 없이 예외는 없습니다.**
**이 문서는 아키텍처의 단일 진실 공급원입니다.**

위반 사항을 발견하면 즉시 수정하거나 코드 리뷰에서 제기하세요.

---

## 최근 변경사항 (Migration Log)

### 2025-10-16: 아키텍처 정리
**이동됨**:
- `shared/data/services/supabase_service.dart` → `core/services/supabase_service.dart`
- `shared/domain/entities/*` → `core/domain/entities/*`
- `shared/cache/auth_data_cache.dart` → `core/cache/auth_data_cache.dart`
- `shared/synchronization/state_synchronizer.dart` → `core/infrastructure/state_synchronizer.dart`

**삭제됨**:
- `core/themes/` (`shared/themes/`의 중복)
- `shared/data/`
- `shared/domain/`
- `shared/synchronization/`
- `ARCHITECTURE_ANALYSIS.md`
- `APP_STATE_DOCUMENTATION.md`

**업데이트됨**:
- 코드베이스 전체의 모든 import가 새 위치를 반영하도록 업데이트
- 모든 테마 import가 이제 `shared/themes/` 사용
- 모든 엔티티 import가 이제 `core/domain/entities/` 사용
- 모든 서비스 import가 이제 `core/services/` 사용
- 모든 인프라 import가 이제 `core/cache/` 및 `core/infrastructure/` 사용
- `build_runner` 성공적으로 실행됨

---

**마지막 업데이트**: 2025-10-16
**버전**: 2.0 (정리 후)
**상태**: ✅ 프로덕션 준비 완료
