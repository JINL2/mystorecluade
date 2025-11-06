# StoreBase Website Architecture - THE LAW 📜

> **이 문서는 이 프로젝트의 법입니다.**
> **모든 코드는 반드시 이 규칙을 따라야 합니다. 팀 논의 없이 예외는 없습니다.**

---

## 기술 스택 (Tech Stack)
- **Frontend**: React 18 + TypeScript 5
- **Build Tool**: Vite 5
- **Styling**: CSS Modules + Toss Design System
- **State Management**: React Context + Custom Hooks (필요시 Zustand)
- **Routing**: React Router v6
- **Backend**: Supabase (Auth, Database, RPC)
- **Package Manager**: npm

---

## 목차 (Table of Contents)
1. [핵심 원칙 (Core Principles)](#핵심-원칙-core-principles)
2. [전체 디렉토리 구조 (Complete Directory Structure)](#전체-디렉토리-구조-complete-directory-structure)
3. [레이어별 상세 설명 (Layer Details)](#레이어별-상세-설명-layer-details)
4. [The Law: 무엇을 어디에 두는가](#the-law-무엇을-어디에-두는가)
5. [Import 규칙 (Import Rules)](#import-규칙-import-rules)
6. [파일 분리 규칙 (File Separation Rules)](#파일-분리-규칙-file-separation-rules)
7. [실전 예제 (Practical Examples)](#실전-예제-practical-examples)
8. [흔한 실수 (Common Mistakes)](#흔한-실수-common-mistakes)
9. [집행 (Enforcement)](#집행-enforcement)

---

## 핵심 원칙 (Core Principles)

### 1. Clean Architecture (3개 레이어)
우리는 **Clean Architecture**를 따릅니다:
- **Domain Layer** (도메인): 비즈니스 엔티티, repository 인터페이스, 검증 로직
- **Data Layer** (데이터): Repository 구현체, data source (Supabase RPC), models (DTO)
- **Presentation Layer** (프레젠테이션): React 컴포넌트, Hooks, 페이지

### 2. Feature-First Organization
각 feature는 **완전히 독립**되어 있으며 자체 domain/data/presentation 레이어를 가집니다.

### 3. 명확한 분리 (Clear Separation)
```
core/     = 인프라 & 유틸리티 (서비스, 설정, 순수 함수) - TypeScript
shared/   = UI 컴포넌트 & 디자인 시스템 (React 컴포넌트, Custom Hooks)
features/ = 완전한 feature 구현 (domain/data/presentation 레이어 포함)
```

### 4. 단일 파일 크기 제한
```
TSX  ≤ 15KB   (React 컴포넌트 - 로직 복잡시 hooks로 분리)
TS   ≤ 30KB   (비즈니스 로직, 유틸리티)
CSS  ≤ 20KB   (CSS Module, 컴포넌트별 분리)
```

**절대 규칙**: 단일 파일이 50KB를 넘으면 **무조건 분리**해야 합니다.

---

## 전체 디렉토리 구조 (Complete Directory Structure)

```
website/
├── index.html                    # 📱 Vite Entry Point
├── vite.config.ts                # Vite 설정
├── tsconfig.json                 # TypeScript 설정
├── tsconfig.node.json            # Node.js용 TypeScript 설정
├── package.json                  # 프로젝트 의존성
├── .env.local                    # 환경 변수 (Supabase keys)
│
├── public/                       # 📦 정적 파일 (빌드 시 복사됨)
│   └── assets/
│       ├── images/
│       ├── icons/
│       └── fonts/
│
├── docs/                         # 📚 프로젝트 문서
│   └── ARCHITECTURE.md          # 이 문서
│
└── src/                          # 소스 코드 루트
    ├── main.tsx                  # React 애플리케이션 엔트리 포인트
    ├── App.tsx                   # 루트 컴포넌트
    ├── vite-env.d.ts            # Vite 타입 정의
    │
    ├── core/                     # 🔧 Infrastructure & Cross-Cutting Concerns
    │   ├── config/               # ✅ 앱 설정
    │   │   ├── supabase.ts      # Supabase 클라이언트 초기화
    │   │   └── routes.ts        # React Router 라우트 설정
    │   │
    │   ├── constants/            # ✅ 앱 전체 상수
    │   │   ├── app-icons.ts     # 아이콘 매핑
    │   │   ├── ui-constants.ts  # UI 상수
    │   │   └── route-paths.ts   # 라우트 경로
    │   │
    │   ├── services/             # ✅ 인프라 서비스
    │   │   ├── supabase.service.ts    # Supabase 클라이언트 래퍼
    │   │   ├── storage.service.ts     # LocalStorage/SessionStorage 관리
    │   │   ├── cache.service.ts       # 인메모리 캐싱
    │   │   └── auth.service.ts        # 인증 서비스
    │   │
    │   ├── utils/                # ✅ 순수 유틸리티 함수
    │   │   ├── formatters.ts    # 숫자, 날짜, 통화 포맷
    │   │   ├── validators.ts    # 검증 함수
    │   │   └── helpers.ts       # 공통 헬퍼 함수
    │   │
    │   └── types/                # ✅ 전역 타입 정의
    │       ├── supabase.types.ts # Supabase 자동 생성 타입
    │       └── common.types.ts   # 공통 타입
    │
    ├── shared/                   # 🎨 Shared UI Components & Hooks
    │   ├── themes/               # ✅ 디자인 시스템 토큰
    │   │   ├── variables.css    # CSS 변수 (색상, 간격, 폰트)
    │   │   ├── toss-colors.css  # Toss 색상 팔레트
    │   │   ├── typography.css   # 타이포그래피
    │   │   ├── animations.css   # 애니메이션
    │   │   └── global.css       # 전역 스타일 리셋
    │   │
    │   ├── components/           # ✅ 재사용 가능한 React 컴포넌트
    │   │   ├── common/          # 📦 프로젝트 전체 공통 컴포넌트
    │   │   │   ├── TossScaffold/
    │   │   │   │   ├── TossScaffold.tsx
    │   │   │   │   ├── TossScaffold.module.css
    │   │   │   │   └── TossScaffold.types.ts
    │   │   │   ├── TossAppBar/
    │   │   │   │   ├── TossAppBar.tsx
    │   │   │   │   └── TossAppBar.module.css
    │   │   │   ├── TossDialog/
    │   │   │   │   ├── TossDialog.tsx
    │   │   │   │   ├── TossDialog.module.css
    │   │   │   │   └── TossDialog.types.ts
    │   │   │   ├── TossLoadingView/
    │   │   │   │   ├── TossLoadingView.tsx
    │   │   │   │   └── TossLoadingView.module.css
    │   │   │   ├── TossEmptyView/
    │   │   │   │   ├── TossEmptyView.tsx
    │   │   │   │   └── TossEmptyView.module.css
    │   │   │   └── TossErrorView/
    │   │   │       ├── TossErrorView.tsx
    │   │   │       └── TossErrorView.module.css
    │   │   │
    │   │   ├── toss/            # 📦 Toss 디자인 시스템 기본 컴포넌트
    │   │   │   ├── TossButton/
    │   │   │   │   ├── TossButton.tsx
    │   │   │   │   ├── TossButton.module.css
    │   │   │   │   └── TossButton.types.ts
    │   │   │   ├── TossInput/
    │   │   │   │   ├── TossInput.tsx
    │   │   │   │   ├── TossInput.module.css
    │   │   │   │   └── TossInput.types.ts
    │   │   │   ├── TossSelect/
    │   │   │   │   ├── TossSelect.tsx
    │   │   │   │   └── TossSelect.module.css
    │   │   │   ├── TossCard/
    │   │   │   │   ├── TossCard.tsx
    │   │   │   │   └── TossCard.module.css
    │   │   │   ├── TossModal/
    │   │   │   │   ├── TossModal.tsx
    │   │   │   │   ├── TossModal.module.css
    │   │   │   │   └── TossModal.types.ts
    │   │   │   ├── TossTable/
    │   │   │   │   ├── TossTable.tsx
    │   │   │   │   ├── TossTable.module.css
    │   │   │   │   └── TossTable.types.ts
    │   │   │   └── TossAlert/
    │   │   │       ├── TossAlert.tsx
    │   │   │       └── TossAlert.module.css
    │   │   │
    │   │   └── selectors/       # 📦 Selector 전용 컴포넌트
    │   │       ├── StoreSelector/
    │   │       │   ├── StoreSelector.tsx
    │   │       │   ├── StoreSelector.module.css
    │   │       │   └── StoreSelector.types.ts
    │   │       └── CompanySelector/
    │   │           ├── CompanySelector.tsx
    │   │           └── CompanySelector.module.css
    │   │
    │   └── hooks/                # ✅ 공통 Custom Hooks
    │       ├── useAuth.ts       # 인증 관련 hook
    │       ├── useLocalStorage.ts # LocalStorage hook
    │       ├── useDebounce.ts   # Debounce hook
    │       └── useAsync.ts      # 비동기 처리 hook
    │
    ├── features/                 # 🎯 Feature Modules (Clean Architecture)
    │   ├── auth/                # 인증 feature
    │   │   ├── domain/
    │   │   │   ├── entities/
    │   │   │   │   └── User.ts # 사용자 엔티티
    │   │   │   ├── repositories/
    │   │   │   │   └── IAuthRepository.ts  # Repository 인터페이스
    │   │   │   └── validators/
    │   │   │       └── AuthValidator.ts    # 인증 검증
    │   │   ├── data/
    │   │   │   ├── datasources/
    │   │   │   │   └── AuthDataSource.ts   # Supabase Auth API
    │   │   │   ├── models/
    │   │   │   │   └── UserModel.ts        # DTO + Mapper
    │   │   │   └── repositories/
    │   │   │       └── AuthRepositoryImpl.ts
    │   │   └── presentation/
    │   │       ├── pages/
    │   │       │   ├── LoginPage.tsx        # 로그인 페이지
    │   │       │   └── RegisterPage.tsx     # 회원가입 페이지
    │   │       │
    │   │       ├── components/              # Feature 전용 컴포넌트
    │   │       │   ├── LoginForm/
    │   │       │   │   ├── LoginForm.tsx
    │   │       │   │   ├── LoginForm.module.css
    │   │       │   │   └── LoginForm.types.ts
    │   │       │   └── RegisterForm/
    │   │       │       ├── RegisterForm.tsx
    │   │       │       └── RegisterForm.module.css
    │   │       │
    │   │       └── hooks/                   # Feature 전용 Custom Hooks
    │   │           ├── useLogin.ts
    │   │           ├── useRegister.ts
    │   │           └── useAuthForm.ts
    │   │
    │   ├── dashboard/            # 대시보드 feature
    │   │   ├── domain/
    │   │   │   ├── entities/
    │   │   │   │   └── DashboardMetrics.ts
    │   │   │   └── repositories/
    │   │   │       └── IDashboardRepository.ts
    │   │   ├── data/
    │   │   │   ├── datasources/
    │   │   │   │   └── DashboardDataSource.ts
    │   │   │   ├── models/
    │   │   │   │   └── DashboardModel.ts
    │   │   │   └── repositories/
    │   │   │       └── DashboardRepositoryImpl.ts
    │   │   └── presentation/
    │   │       ├── pages/
    │   │       │   └── DashboardPage.tsx
    │   │       ├── components/
    │   │       │   ├── MetricsCard/
    │   │       │   │   ├── MetricsCard.tsx
    │   │       │   │   └── MetricsCard.module.css
    │   │       │   ├── RevenueChart/
    │   │       │   │   ├── RevenueChart.tsx
    │   │       │   │   └── RevenueChart.module.css
    │   │       │   └── QuickActions/
    │   │       │       ├── QuickActions.tsx
    │   │       │       └── QuickActions.module.css
    │   │       └── hooks/
    │   │           └── useDashboard.ts
    │   │
    │   ├── inventory/            # 재고 관리 feature
    │   │   ├── domain/
    │   │   │   ├── entities/
    │   │   │   │   ├── Product.ts
    │   │   │   │   └── Category.ts
    │   │   │   ├── repositories/
    │   │   │   │   └── IInventoryRepository.ts
    │   │   │   └── validators/
    │   │   │       └── ProductValidator.ts
    │   │   ├── data/
    │   │   │   ├── datasources/
    │   │   │   │   └── InventoryDataSource.ts  # RPC: inventory_import_excel
    │   │   │   ├── models/
    │   │   │   │   ├── ProductModel.ts
    │   │   │   │   └── CategoryModel.ts
    │   │   │   └── repositories/
    │   │   │       └── InventoryRepositoryImpl.ts
    │   │   └── presentation/
    │   │       ├── pages/
    │   │       │   └── InventoryPage.tsx       # 재고 관리 페이지
    │   │       │
    │   │       ├── components/                 # Feature 전용 컴포넌트
    │   │       │   ├── InventoryTable/
    │   │       │   │   ├── InventoryTable.tsx
    │   │       │   │   ├── InventoryTable.module.css
    │   │       │   │   └── InventoryTable.types.ts
    │   │       │   ├── ProductForm/
    │   │       │   │   ├── ProductForm.tsx
    │   │       │   │   ├── ProductForm.module.css
    │   │       │   │   └── ProductForm.types.ts
    │   │       │   ├── ExcelImporter/
    │   │       │   │   ├── ExcelImporter.tsx
    │   │       │   │   └── ExcelImporter.module.css
    │   │       │   └── ProductRow/
    │   │       │       ├── ProductRow.tsx
    │   │       │       └── ProductRow.module.css
    │   │       │
    │   │       └── hooks/
    │   │           ├── useInventory.ts
    │   │           ├── useProducts.ts
    │   │           └── useExcelImport.ts
    │   │
    │   ├── finance/              # 재무 관리 feature
    │   │   ├── domain/
    │   │   ├── data/
    │   │   └── presentation/
    │   │
    │   ├── employee/             # 직원 관리 feature
    │   │   ├── domain/
    │   │   ├── data/
    │   │   └── presentation/
    │   │
    │   └── settings/             # 설정 feature
    │       ├── domain/
    │       ├── data/
    │       └── presentation/
    │
    └── routes/                   # ✅ React Router 설정
        ├── index.tsx             # 라우트 정의
        ├── ProtectedRoute.tsx    # 인증 가드
        └── PublicRoute.tsx       # 공개 라우트
```

---

## 레이어별 상세 설명 (Layer Details)

### 🔧 `core/` - Infrastructure & Cross-Cutting Concerns

**역할**: 인프라 서비스 및 횡단 관심사

**포함되어야 하는 것**:
- ✅ 인프라 서비스 (Supabase, HTTP 클라이언트, 캐싱)
- ✅ 상수 (API 엔드포인트, 설정 값)
- ✅ 순수 유틸리티 함수 (포맷터, 검증기, 헬퍼)
- ✅ 라우터 및 네비게이션 로직
- ✅ 앱 전체 설정

**포함되면 안 되는 것**:
- ❌ UI 컴포넌트 (위젯, 버튼, 카드)
- ❌ 디자인 시스템 토큰 (색상, 타이포그래피, 간격)
- ❌ 완전한 feature 구현 (domain/data/presentation)
- ❌ Feature 특화 비즈니스 로직
- ❌ HTML/CSS 파일

**예제**:
```typescript
// ✅ core/services/supabase.service.ts
import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { Database } from '@/core/types/supabase.types';

class SupabaseService {
  private client: SupabaseClient<Database>;

  constructor() {
    this.client = createClient<Database>(
      import.meta.env.VITE_SUPABASE_URL,
      import.meta.env.VITE_SUPABASE_ANON_KEY
    );
  }

  async rpc<T>(functionName: string, params: any): Promise<T> {
    const { data, error } = await this.client.rpc(functionName, params);
    if (error) throw error;
    return data as T;
  }

  get auth() {
    return this.client.auth;
  }

  get from() {
    return this.client.from.bind(this.client);
  }
}

export const supabaseService = new SupabaseService();

// ✅ core/utils/formatters.ts
export function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('ko-KR', {
    style: 'currency',
    currency: 'KRW'
  }).format(amount);
}

export function formatDate(date: Date | string): string {
  return new Intl.DateTimeFormat('ko-KR').format(new Date(date));
}

// ✅ core/services/cache.service.ts
interface CacheItem<T> {
  value: T;
  expiry: number;
}

class CacheService {
  private cache: Map<string, CacheItem<any>>;

  constructor() {
    this.cache = new Map();
  }

  set<T>(key: string, value: T, ttl: number = 5 * 60 * 1000): void {
    this.cache.set(key, {
      value,
      expiry: Date.now() + ttl
    });
  }

  get<T>(key: string): T | null {
    const item = this.cache.get(key);
    if (!item) return null;

    if (Date.now() > item.expiry) {
      this.cache.delete(key);
      return null;
    }

    return item.value as T;
  }

  clear(): void {
    this.cache.clear();
  }
}

export const cacheService = new CacheService();
```

---

### 🎨 `shared/` - Presentation Layer (UI Only!)

**역할**: 재사용 가능한 UI 컴포넌트 및 디자인 시스템

**포함되어야 하는 것**:
- ✅ 재사용 가능한 UI 컴포넌트 (버튼, 카드, 입력)
- ✅ 디자인 시스템 토큰 (색상, 타이포그래피, 간격, 그림자)
- ✅ 테마 설정 (CSS 변수, 스타일 리셋)
- ✅ **Common components** (`shared/components/common/`) - 프로젝트 전체 공통 위젯
- ✅ HTML 템플릿

**포함되면 안 되는 것**:
- ❌ 비즈니스 로직 또는 도메인 규칙
- ❌ Data layer 코드 (repository, data source)
- ❌ 도메인 엔티티
- ❌ 인프라 서비스 (데이터베이스, API)
- ❌ 캐싱 시스템
- ❌ RPC 호출

**핵심 원칙**: 디자이너가 관심 있는 것 → `shared/`. 백엔드 엔지니어가 관심 있는 것 → `core/`.

**`shared/components/` 하위 구조**:
```
shared/components/
├── common/        # 📦 프로젝트 전체에서 사용하는 공통 컴포넌트
│                  # 예: TossScaffold, TossAppBar, TossDialog
├── toss/          # 📦 Toss 디자인 시스템 기본 컴포넌트
│                  # 예: TossButton, TossInput, TossCard
└── selectors/     # 📦 Selector 관련 컴포넌트
                   # 예: StoreSelector, CompanySelector
```

**컴포넌트 구조 규칙**:
```
shared/components/toss/TossButton/
├── TossButton.tsx          # React 컴포넌트
├── TossButton.module.css   # CSS Module 스타일
└── TossButton.types.ts     # TypeScript 타입 정의
```

**예제**:
```typescript
// ✅ shared/components/toss/TossButton/TossButton.types.ts
export interface TossButtonProps {
  label: string;
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
  size?: 'small' | 'medium' | 'large';
  onClick?: () => void;
  disabled?: boolean;
  fullWidth?: boolean;
  loading?: boolean;
}

// ✅ shared/components/toss/TossButton/TossButton.tsx
import React from 'react';
import styles from './TossButton.module.css';
import { TossButtonProps } from './TossButton.types';

export const TossButton: React.FC<TossButtonProps> = ({
  label,
  variant = 'primary',
  size = 'medium',
  onClick,
  disabled = false,
  fullWidth = false,
  loading = false
}) => {
  return (
    <button
      className={`
        ${styles.tossBtn}
        ${styles[variant]}
        ${styles[size]}
        ${fullWidth ? styles.full : ''}
        ${loading ? styles.loading : ''}
      `}
      onClick={onClick}
      disabled={disabled || loading}
    >
      {loading ? 'Loading...' : label}
    </button>
  );
};
```

```css
/* ✅ shared/components/toss/TossButton/TossButton.module.css */
.tossBtn {
  padding: var(--space-3) var(--space-5);
  border-radius: var(--radius-medium);
  font-family: var(--font-family);
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  border: none;
  outline: none;
}

.tossBtn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.primary {
  background: var(--toss-blue-600);
  color: white;
}

.primary:hover:not(:disabled) {
  background: var(--toss-blue-700);
}

.secondary {
  background: var(--toss-gray-200);
  color: var(--text-primary);
}

.secondary:hover:not(:disabled) {
  background: var(--toss-gray-300);
}

.small {
  padding: var(--space-2) var(--space-4);
  font-size: var(--font-small);
}

.large {
  padding: var(--space-4) var(--space-6);
  font-size: var(--font-large);
}

.full {
  width: 100%;
}

.loading {
  position: relative;
  pointer-events: none;
}
```

---

### 🎯 `features/` - Complete Feature Implementation

**역할**: 완전한 feature 구현 (Clean Architecture)

**포함되어야 하는 것**:
- ✅ domain/data/presentation 레이어를 가진 완전한 feature
- ✅ Feature 특화 엔티티
- ✅ Feature 특화 repository
- ✅ Feature 특화 비즈니스 로직
- ✅ Feature 특화 UI 페이지 및 위젯

**각 feature의 구조**:
```
features/my_feature/
├── domain/                    # 비즈니스 로직
│   ├── entities/             # 비즈니스 객체
│   │   └── MyEntity.js
│   ├── repositories/         # Repository 인터페이스 (추상)
│   │   └── MyRepository.js
│   └── validators/           # 검증 로직
│       └── MyValidator.js
├── data/                      # 데이터 처리
│   ├── datasources/          # API 호출, RPC 실행
│   │   └── MyDataSource.js
│   ├── models/               # DTO + Mapper
│   │   └── MyModel.js
│   └── repositories/         # Repository 구현체
│       └── MyRepositoryImpl.js
└── presentation/              # UI
    ├── pages/                # 전체 페이지
    │   └── my_page/
    │       ├── my_page.html  # HTML 구조만
    │       ├── my_page.css   # 스타일
    │       └── my_page.js    # 페이지 로직
    ├── widgets/              # Feature 전용 위젯
    │   └── MyWidget/
    │       ├── MyWidget.js
    │       └── MyWidget.css
    └── state/                # 상태 관리
        └── MyState.js
```

**예제**: [실전 예제](#실전-예제-practical-examples) 섹션 참고

---

## The Law: 무엇을 어디에 두는가

### 규칙 1: `core/` = 인프라만, UI 없음

```
✅ core/services/supabase-service.js      # 인프라 서비스
✅ core/services/cache-service.js         # 캐싱
✅ core/utils/formatters.js               # 유틸리티
✅ core/config/router-config.js           # 앱 설정

❌ core/themes/toss-colors.css            # → shared/themes/
❌ core/components/button.js              # → shared/components/
❌ core/inventory/InventoryPage.js        # → features/inventory/
```

### 규칙 2: `shared/` = UI만, 비즈니스 로직 없음

```
✅ shared/components/toss/TossButton/TossButton.js       # UI 컴포넌트
✅ shared/components/common/TossDialog/TossDialog.js     # 공통 위젯
✅ shared/themes/toss-colors.css                         # 디자인 토큰

❌ shared/services/api-service.js                        # → core/services/
❌ shared/domain/Product.js                              # → features/*/domain/
❌ shared/data/repositories/ProductRepository.js         # → features/*/data/
```

### 규칙 3: `features/` = 완전한 feature (domain/data/presentation)

```
✅ features/inventory/domain/entities/Product.js
✅ features/inventory/data/repositories/InventoryRepositoryImpl.js
✅ features/inventory/presentation/pages/inventory/inventory.js

❌ features/inventory/utils/formatters.js                # → core/utils/
❌ features/inventory/themes/colors.css                  # → shared/themes/
```

### 규칙 4: 파일 크기 제한

```
✅ inventory.html (8KB)    # HTML 구조만
✅ inventory.css (15KB)    # 스타일만
✅ inventory.js (25KB)     # 페이지 로직만

❌ inventory.html (270KB)  # 모든 것이 하나의 파일 - 절대 금지!
```

---

## Import 규칙 (Import Rules)

### 1. 테마 Imports - **항상** `shared/themes/` 사용

```html
<!-- ✅ 올바름 -->
<link rel="stylesheet" href="../../../shared/themes/toss-variables.css">
<link rel="stylesheet" href="../../../shared/themes/toss-base.css">

<!-- ❌ 틀림 (core/themes는 사용 금지) -->
<link rel="stylesheet" href="../../../core/themes/toss-variables.css">
```

### 2. 컴포넌트 Imports - `shared/components/` 사용

```javascript
// ✅ 올바름
import { TossButton } from '../../../shared/components/toss/TossButton/TossButton.js';
import { TossDialog } from '../../../shared/components/common/TossDialog/TossDialog.js';

// ❌ 틀림
import { TossButton } from '../../../core/components/TossButton.js';
```

### 3. 서비스 Imports - `core/services/` 사용

```javascript
// ✅ 올바름
import { SupabaseService } from '../../../core/services/supabase-service.js';
import { CacheService } from '../../../core/services/cache-service.js';

// ❌ 틀림
import { SupabaseService } from '../../../shared/services/supabase-service.js';
```

### 4. 유틸리티 Imports - `core/utils/` 사용

```javascript
// ✅ 올바름
import { formatCurrency } from '../../../core/utils/formatters.js';
import { validateEmail } from '../../../core/utils/validators.js';
```

### 5. 파일 내 Import 순서

```javascript
// 1. 외부 라이브러리
import ExcelJS from 'https://cdn.jsdelivr.net/npm/exceljs@4.3.0/dist/exceljs.min.js';

// 2. Shared - Theme System (CSS)
import '../../../shared/themes/toss-variables.css';
import '../../../shared/themes/toss-base.css';

// 3. Shared - Components
import { TossButton } from '../../../shared/components/toss/TossButton/TossButton.js';
import { TossDialog } from '../../../shared/components/common/TossDialog/TossDialog.js';

// 4. Core - Services & Utils
import { SupabaseService } from '../../../core/services/supabase-service.js';
import { formatCurrency } from '../../../core/utils/formatters.js';

// 5. Feature - Domain/Data/Presentation
import { Product } from '../../domain/entities/Product.js';
import { InventoryRepository } from '../../data/repositories/InventoryRepositoryImpl.js';
import { InventoryTable } from '../widgets/InventoryTable/InventoryTable.js';
```

---

## 파일 분리 규칙 (File Separation Rules)

### 규칙 1: React 컴포넌트는 **TSX + CSS Module + Types**로 분리

**나쁜 예** (기존 Vanilla JS 방식):
```html
<!-- ❌ inventory.html (270KB) - 모든 것이 하나에 -->
<!DOCTYPE html>
<html>
<head>
  <style>
    /* 1000줄의 CSS */
  </style>
</head>
<body>
  <script>
    // 5000줄의 JavaScript
  </script>
</body>
</html>
```

**좋은 예** (React + TypeScript 방식):
```
features/inventory/presentation/pages/InventoryPage/
├── InventoryPage.tsx         (≤15KB)  # React 컴포넌트
├── InventoryPage.module.css  (≤20KB)  # CSS Module
├── InventoryPage.types.ts    (≤5KB)   # Type 정의
└── index.ts                   (≤1KB)   # Barrel export
```

```typescript
// ✅ InventoryPage.types.ts - Type 정의만
export interface InventoryPageProps {
  companyId: string;
  storeId: string;
}

export interface InventoryFilters {
  category?: string;
  brand?: string;
  status?: 'active' | 'inactive';
}
```

```typescript
// ✅ InventoryPage.tsx - React 컴포넌트 (로직 복잡시 hooks로 분리)
import React from 'react';
import styles from './InventoryPage.module.css';
import type { InventoryPageProps } from './InventoryPage.types';
import { TossButton } from '@/shared/components/toss/TossButton/TossButton';
import { InventoryTable } from '@/features/inventory/presentation/components/InventoryTable/InventoryTable';
import { useInventory } from '@/features/inventory/presentation/hooks/useInventory';

export const InventoryPage: React.FC<InventoryPageProps> = ({
  companyId,
  storeId
}) => {
  const { products, loading, error, handleImport, handleExport } = useInventory(
    companyId,
    storeId
  );

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div className={styles.container}>
      <header className={styles.header}>
        <h1>Inventory Management</h1>
        <div className={styles.actions}>
          <TossButton label="Export" variant="secondary" onClick={handleExport} />
          <TossButton label="Import" variant="secondary" onClick={handleImport} />
          <TossButton label="Add Product" variant="primary" onClick={() => {}} />
        </div>
      </header>

      <main className={styles.main}>
        <InventoryTable products={products} />
      </main>
    </div>
  );
};
```

```css
/* ✅ InventoryPage.module.css - CSS Module */
.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: var(--space-6);
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-6);
}

.actions {
  display: flex;
  gap: var(--space-3);
}

.main {
  background: white;
  border-radius: var(--radius-large);
  padding: var(--space-6);
}
```

```typescript
// ✅ index.ts - Barrel export
export { InventoryPage } from './InventoryPage';
export type { InventoryPageProps } from './InventoryPage.types';
```

### 규칙 2: 컴포넌트는 **폴더 단위로 분리** (Component + Styles + Types + Hooks)

**Shared Component 구조**:
```
shared/components/toss/TossButton/
├── TossButton.tsx         # React 컴포넌트
├── TossButton.module.css  # CSS Module
├── TossButton.types.ts    # Props 타입
└── index.ts               # Barrel export
```

**Feature Component 구조** (복잡한 경우):
```
features/inventory/presentation/components/InventoryTable/
├── InventoryTable.tsx         # 메인 컴포넌트
├── InventoryTable.module.css  # 스타일
├── InventoryTable.types.ts    # 타입 정의
├── InventoryTableRow.tsx      # 서브 컴포넌트
├── useInventoryTable.ts       # 커스텀 훅 (로직 분리)
└── index.ts                   # Barrel export
```

### 규칙 3: 비즈니스 로직은 **Hooks로 분리**

```typescript
// ✅ hooks/useInventory.ts - 비즈니스 로직
import { useState, useEffect, useCallback } from 'react';
import { InventoryRepository } from '@/features/inventory/data/repositories/InventoryRepositoryImpl';
import type { Product } from '@/features/inventory/domain/entities/Product';

export const useInventory = (companyId: string, storeId: string) => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const repository = new InventoryRepository();

  const loadProducts = useCallback(async () => {
    try {
      setLoading(true);
      const data = await repository.getProducts(companyId, storeId);
      setProducts(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId]);

  useEffect(() => {
    loadProducts();
  }, [loadProducts]);

  const handleImport = useCallback(async (products: Product[]) => {
    await repository.importExcel(companyId, storeId, 'userId', products);
    await loadProducts();
  }, [companyId, storeId]);

  return { products, loading, error, handleImport, handleExport: () => {} };
};
```

### 규칙 4: Domain/Data Layer는 **클래스 기반 유지**

```typescript
// ✅ domain/entities/Product.ts - 엔티티
export class Product {
  constructor(
    public readonly id: string | null,
    public readonly sku: string,
    public readonly name: string,
    public readonly price: number
  ) {}

  get formattedPrice(): string {
    return new Intl.NumberFormat('ko-KR', {
      style: 'currency',
      currency: 'KRW'
    }).format(this.price);
  }

  static create(data: Partial<Product>): Product {
    return new Product(
      data.id ?? null,
      data.sku ?? '',
      data.name ?? '',
      data.price ?? 0
    );
  }
}

// ✅ domain/validators/ProductValidator.js - 검증
export class ProductValidator {
  static validate(product) {
    const errors = [];

    if (!product.name) {
      errors.push('Product name is required');
    }

    if (product.price < 0) {
      errors.push('Price must be positive');
    }

    return errors;
  }
}

// ✅ data/datasources/InventoryDataSource.js - API 호출
import { SupabaseService } from '../../../../core/services/supabase-service.js';

export class InventoryDataSource {
  constructor() {
    this.supabase = new SupabaseService();
  }

  async importExcel(companyId, storeId, userId, products) {
    return await this.supabase.rpc('inventory_import_excel', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_user_id: userId,
      p_products: products
    });
  }

  async getProducts(companyId, storeId) {
    const { data, error } = await this.supabase.client
      .from('products')
      .select('*')
      .eq('company_id', companyId)
      .eq('store_id', storeId);

    if (error) throw error;
    return data;
  }
}

// ✅ data/repositories/InventoryRepositoryImpl.js - Repository 구현
import { InventoryDataSource } from '../datasources/InventoryDataSource.js';
import { ProductModel } from '../models/ProductModel.js';

export class InventoryRepository {
  constructor() {
    this.dataSource = new InventoryDataSource();
  }

  async getProducts(companyId, storeId) {
    const rawData = await this.dataSource.getProducts(companyId, storeId);
    return rawData.map(data => ProductModel.fromJson(data));
  }

  async importExcel(companyId, storeId, userId, products) {
    const result = await this.dataSource.importExcel(
      companyId,
      storeId,
      userId,
      products
    );
    return result;
  }
}
```

---

## 실전 예제 (Practical Examples)

### 예제 1: 새 공통 위젯 만들기

**시나리오**: 프로젝트 전체에서 사용할 "TossLoadingView" 위젯을 만들고 싶다.

**파일 구조**:
```
shared/components/common/TossLoadingView/
├── TossLoadingView.js
└── TossLoadingView.css
```

```javascript
// ✅ shared/components/common/TossLoadingView/TossLoadingView.js
export class TossLoadingView {
  constructor(message = 'Loading...') {
    this.message = message;
  }

  render() {
    const container = document.createElement('div');
    container.className = 'toss-loading-view';
    container.innerHTML = `
      <div class="toss-loading-spinner"></div>
      <p class="toss-loading-message">${this.message}</p>
    `;
    return container;
  }

  show(parentElement) {
    const element = this.render();
    parentElement.appendChild(element);
    return element;
  }

  static hide(element) {
    element?.remove();
  }
}
```

```css
/* ✅ shared/components/common/TossLoadingView/TossLoadingView.css */
.toss-loading-view {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-8);
}

.toss-loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid var(--toss-gray-200);
  border-top-color: var(--toss-blue-600);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.toss-loading-message {
  margin-top: var(--space-4);
  color: var(--text-secondary);
  font-size: var(--font-medium);
}
```

**사용 예시**:
```javascript
import { TossLoadingView } from '../../../shared/components/common/TossLoadingView/TossLoadingView.js';

const loading = new TossLoadingView('Processing...');
const loadingElement = loading.show(document.body);

// 작업 완료 후
TossLoadingView.hide(loadingElement);
```

**왜 `shared/components/common/`?**
- 프로젝트 전체에서 사용
- 비즈니스 로직 없음
- 순수 UI 컴포넌트

---

### 예제 2: 새 Feature 만들기 (Inventory)

**시나리오**: "Inventory" feature를 Clean Architecture로 구현

**파일 구조**:
```
features/inventory/
├── domain/
│   ├── entities/
│   │   └── Product.js
│   ├── repositories/
│   │   └── InventoryRepository.js
│   └── validators/
│       └── ProductValidator.js
├── data/
│   ├── datasources/
│   │   └── InventoryDataSource.js
│   ├── models/
│   │   └── ProductModel.js
│   └── repositories/
│       └── InventoryRepositoryImpl.js
└── presentation/
    ├── pages/
    │   └── inventory/
    │       ├── inventory.html
    │       ├── inventory.css
    │       └── inventory.js
    ├── widgets/
    │   ├── InventoryTable/
    │   │   ├── InventoryTable.js
    │   │   └── InventoryTable.css
    │   ├── ProductForm/
    │   │   ├── ProductForm.js
    │   │   └── ProductForm.css
    │   └── ExcelImporter/
    │       ├── ExcelImporter.js
    │       └── ExcelImporter.css
    └── state/
        └── InventoryState.js
```

**1. Domain Layer**

```javascript
// ✅ domain/entities/Product.js
export class Product {
  constructor(data) {
    this.id = data.id;
    this.sku = data.sku;
    this.barcode = data.barcode;
    this.name = data.name;
    this.category = data.category;
    this.brand = data.brand;
    this.unit = data.unit;
    this.costPrice = data.costPrice;
    this.sellingPrice = data.sellingPrice;
    this.currentStock = data.currentStock;
    this.minStock = data.minStock;
    this.maxStock = data.maxStock;
    this.reorderPoint = data.reorderPoint;
    this.status = data.status;
  }

  get isLowStock() {
    return this.currentStock <= this.minStock;
  }

  get stockStatus() {
    if (this.currentStock <= this.minStock) return 'low';
    if (this.currentStock >= this.maxStock) return 'high';
    return 'normal';
  }
}
```

```javascript
// ✅ domain/validators/ProductValidator.js
export class ProductValidator {
  static validate(product) {
    const errors = [];

    if (!product.name || product.name.trim() === '') {
      errors.push({ field: 'name', message: 'Product name is required' });
    }

    if (product.costPrice < 0) {
      errors.push({ field: 'costPrice', message: 'Cost price must be positive' });
    }

    if (product.sellingPrice < 0) {
      errors.push({ field: 'sellingPrice', message: 'Selling price must be positive' });
    }

    if (product.sellingPrice < product.costPrice) {
      errors.push({ field: 'sellingPrice', message: 'Selling price should be higher than cost price' });
    }

    return errors;
  }
}
```

**2. Data Layer**

```javascript
// ✅ data/datasources/InventoryDataSource.js
import { SupabaseService } from '../../../../core/services/supabase-service.js';

export class InventoryDataSource {
  constructor() {
    this.supabase = new SupabaseService();
  }

  async getProducts(companyId, storeId) {
    const { data, error } = await this.supabase.client
      .from('products')
      .select('*')
      .eq('company_id', companyId)
      .eq('store_id', storeId)
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data;
  }

  async importExcel(companyId, storeId, userId, products) {
    return await this.supabase.rpc('inventory_import_excel', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_user_id: userId,
      p_products: products
    });
  }

  async createProduct(companyId, storeId, productData) {
    const { data, error } = await this.supabase.client
      .from('products')
      .insert({
        company_id: companyId,
        store_id: storeId,
        ...productData
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  }
}
```

```javascript
// ✅ data/models/ProductModel.js
export class ProductModel {
  static fromJson(json) {
    return {
      id: json.product_id,
      sku: json.sku,
      barcode: json.barcode,
      name: json.product_name,
      category: json.category,
      brand: json.brand,
      unit: json.unit,
      costPrice: json.cost_price,
      sellingPrice: json.selling_price,
      currentStock: json.current_stock,
      minStock: json.min_stock,
      maxStock: json.max_stock,
      reorderPoint: json.reorder_point,
      status: json.status
    };
  }

  static toJson(product) {
    return {
      product_id: product.id,
      sku: product.sku,
      barcode: product.barcode,
      product_name: product.name,
      category: product.category,
      brand: product.brand,
      unit: product.unit,
      cost_price: product.costPrice,
      selling_price: product.sellingPrice,
      current_stock: product.currentStock,
      min_stock: product.minStock,
      max_stock: product.maxStock,
      reorder_point: product.reorderPoint,
      status: product.status
    };
  }
}
```

```javascript
// ✅ data/repositories/InventoryRepositoryImpl.js
import { InventoryDataSource } from '../datasources/InventoryDataSource.js';
import { ProductModel } from '../models/ProductModel.js';
import { Product } from '../../domain/entities/Product.js';

export class InventoryRepository {
  constructor() {
    this.dataSource = new InventoryDataSource();
  }

  async getProducts(companyId, storeId) {
    const rawData = await this.dataSource.getProducts(companyId, storeId);
    return rawData.map(data => {
      const mapped = ProductModel.fromJson(data);
      return new Product(mapped);
    });
  }

  async importExcel(companyId, storeId, userId, products) {
    const productsJson = products.map(p => ProductModel.toJson(p));
    return await this.dataSource.importExcel(companyId, storeId, userId, productsJson);
  }

  async createProduct(companyId, storeId, product) {
    const productJson = ProductModel.toJson(product);
    const rawData = await this.dataSource.createProduct(companyId, storeId, productJson);
    const mapped = ProductModel.fromJson(rawData);
    return new Product(mapped);
  }
}
```

**3. Presentation Layer**

```html
<!-- ✅ presentation/pages/inventory/inventory.html -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inventory Management</title>

  <!-- Theme CSS -->
  <link rel="stylesheet" href="../../../../shared/themes/toss-variables.css">
  <link rel="stylesheet" href="../../../../shared/themes/toss-base.css">

  <!-- Component CSS -->
  <link rel="stylesheet" href="../../../../shared/components/toss/TossButton/TossButton.css">
  <link rel="stylesheet" href="../../../../shared/components/common/TossLoadingView/TossLoadingView.css">

  <!-- Page CSS -->
  <link rel="stylesheet" href="inventory.css">
</head>
<body>
  <div id="app">
    <header class="inventory-header">
      <h1>Inventory Management</h1>
      <div class="inventory-actions">
        <button id="exportBtn" class="toss-btn toss-btn-secondary">Export Excel</button>
        <button id="importBtn" class="toss-btn toss-btn-secondary">Import Excel</button>
        <button id="addProductBtn" class="toss-btn toss-btn-primary">Add Product</button>
      </div>
    </header>

    <main id="main" class="inventory-container">
      <!-- InventoryTable will be rendered here -->
    </main>
  </div>

  <!-- Page Script -->
  <script type="module" src="inventory.js"></script>
</body>
</html>
```

```css
/* ✅ presentation/pages/inventory/inventory.css */
.inventory-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-6);
  background: white;
  border-bottom: 1px solid var(--toss-gray-200);
}

.inventory-header h1 {
  font-size: var(--font-h1);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
}

.inventory-actions {
  display: flex;
  gap: var(--space-3);
}

.inventory-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: var(--space-6);
}
```

```javascript
// ✅ presentation/pages/inventory/inventory.js
import { TossLoadingView } from '../../../../shared/components/common/TossLoadingView/TossLoadingView.js';
import { TossButton } from '../../../../shared/components/toss/TossButton/TossButton.js';
import { InventoryRepository } from '../../../data/repositories/InventoryRepositoryImpl.js';
import { InventoryTable } from '../../widgets/InventoryTable/InventoryTable.js';
import { ExcelImporter } from '../../widgets/ExcelImporter/ExcelImporter.js';

class InventoryPage {
  constructor() {
    this.repository = new InventoryRepository();
    this.companyId = this.getCompanyId();
    this.storeId = this.getStoreId();
    this.init();
  }

  async init() {
    this.setupEventListeners();
    await this.loadProducts();
  }

  setupEventListeners() {
    document.getElementById('importBtn').addEventListener('click', () => {
      this.handleImport();
    });

    document.getElementById('exportBtn').addEventListener('click', () => {
      this.handleExport();
    });

    document.getElementById('addProductBtn').addEventListener('click', () => {
      this.handleAddProduct();
    });
  }

  async loadProducts() {
    const loading = new TossLoadingView('Loading products...');
    const loadingElement = loading.show(document.getElementById('main'));

    try {
      const products = await this.repository.getProducts(this.companyId, this.storeId);
      this.renderProducts(products);
    } catch (error) {
      console.error('Failed to load products:', error);
      alert('Failed to load products');
    } finally {
      TossLoadingView.hide(loadingElement);
    }
  }

  renderProducts(products) {
    const table = new InventoryTable(products, {
      onEdit: (product) => this.handleEdit(product),
      onDelete: (product) => this.handleDelete(product)
    });

    const main = document.getElementById('main');
    main.innerHTML = '';
    main.appendChild(table.render());
  }

  async handleImport() {
    const importer = new ExcelImporter({
      onImport: async (products) => {
        await this.repository.importExcel(
          this.companyId,
          this.storeId,
          this.getUserId(),
          products
        );
        await this.loadProducts();
      }
    });
    importer.show();
  }

  handleExport() {
    // Export logic
  }

  handleAddProduct() {
    // Add product logic
  }

  getCompanyId() {
    // Get from app state or localStorage
    return localStorage.getItem('currentCompanyId');
  }

  getStoreId() {
    // Get from app state or localStorage
    return localStorage.getItem('currentStoreId');
  }

  getUserId() {
    // Get from Supabase auth
    return window.supabaseClient.auth.getUser().then(r => r.data.user?.id);
  }
}

// Initialize
new InventoryPage();
```

**4. Widgets**

```javascript
// ✅ presentation/widgets/InventoryTable/InventoryTable.js
import { formatCurrency } from '../../../../../core/utils/formatters.js';

export class InventoryTable {
  constructor(products, options = {}) {
    this.products = products;
    this.onEdit = options.onEdit || (() => {});
    this.onDelete = options.onDelete || (() => {});
  }

  render() {
    const table = document.createElement('table');
    table.className = 'inventory-table';

    table.innerHTML = `
      <thead>
        <tr>
          <th>SKU</th>
          <th>Product Name</th>
          <th>Category</th>
          <th>Brand</th>
          <th>Cost Price</th>
          <th>Selling Price</th>
          <th>Stock</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        ${this.products.map(product => this.renderRow(product)).join('')}
      </tbody>
    `;

    return table;
  }

  renderRow(product) {
    return `
      <tr data-product-id="${product.id}">
        <td>${product.sku || '-'}</td>
        <td>${product.name}</td>
        <td>${product.category || '-'}</td>
        <td>${product.brand || '-'}</td>
        <td>${formatCurrency(product.costPrice)}</td>
        <td>${formatCurrency(product.sellingPrice)}</td>
        <td class="stock-${product.stockStatus}">${product.currentStock}</td>
        <td>
          <span class="status-badge status-${product.status.toLowerCase()}">
            ${product.status}
          </span>
        </td>
        <td>
          <button class="btn-edit" data-id="${product.id}">Edit</button>
          <button class="btn-delete" data-id="${product.id}">Delete</button>
        </td>
      </tr>
    `;
  }
}
```

```css
/* ✅ presentation/widgets/InventoryTable/InventoryTable.css */
.inventory-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: var(--radius-large);
  overflow: hidden;
}

.inventory-table thead {
  background: var(--toss-gray-50);
}

.inventory-table th {
  padding: var(--space-4);
  text-align: left;
  font-weight: 600;
  color: var(--text-secondary);
  font-size: var(--font-small);
}

.inventory-table td {
  padding: var(--space-4);
  border-top: 1px solid var(--toss-gray-200);
}

.stock-low {
  color: var(--toss-red-600);
  font-weight: 600;
}

.stock-high {
  color: var(--toss-orange-600);
}

.stock-normal {
  color: var(--toss-gray-900);
}

.status-badge {
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius-small);
  font-size: var(--font-small);
  font-weight: 600;
}

.status-active {
  background: var(--toss-green-100);
  color: var(--toss-green-700);
}

.status-inactive {
  background: var(--toss-gray-100);
  color: var(--toss-gray-700);
}
```

---

### 예제 3: Excel Importer Widget

```javascript
// ✅ presentation/widgets/ExcelImporter/ExcelImporter.js
import { TossModal } from '../../../../../shared/components/toss/TossModal/TossModal.js';
import { TossLoadingView } from '../../../../../shared/components/common/TossLoadingView/TossLoadingView.js';
import { Product } from '../../../domain/entities/Product.js';
import { ProductValidator } from '../../../domain/validators/ProductValidator.js';

export class ExcelImporter {
  constructor(options = {}) {
    this.onImport = options.onImport || (() => {});
  }

  show() {
    const modal = new TossModal({
      title: 'Import Products from Excel',
      content: this.renderContent(),
      onConfirm: () => this.handleConfirm()
    });
    modal.show();
  }

  renderContent() {
    return `
      <div class="excel-importer">
        <p>Select an Excel file (.xlsx, .xls) to import products.</p>
        <input type="file" id="excelFile" accept=".xlsx,.xls" />
        <div id="preview" class="preview-section"></div>
      </div>
    `;
  }

  async handleConfirm() {
    const fileInput = document.getElementById('excelFile');
    const file = fileInput.files[0];

    if (!file) {
      alert('Please select a file');
      return;
    }

    const loading = new TossLoadingView('Processing Excel file...');
    const loadingElement = loading.show(document.body);

    try {
      // Load ExcelJS dynamically
      const ExcelJS = await this.loadExcelJS();

      // Parse Excel
      const workbook = new ExcelJS.Workbook();
      await workbook.xlsx.load(await file.arrayBuffer());

      const worksheet = workbook.getWorksheet(1);
      const products = [];

      worksheet.eachRow((row, rowNumber) => {
        if (rowNumber === 1) return; // Skip header

        const product = new Product({
          id: null,
          sku: row.getCell(1).value,
          barcode: row.getCell(2).value,
          name: row.getCell(3).value,
          category: row.getCell(4).value,
          brand: row.getCell(5).value,
          unit: row.getCell(6).value || 'piece',
          costPrice: parseFloat(row.getCell(7).value) || 0,
          sellingPrice: parseFloat(row.getCell(8).value) || 0,
          currentStock: parseFloat(row.getCell(9).value) || 0,
          minStock: parseFloat(row.getCell(10).value) || 0,
          maxStock: parseFloat(row.getCell(11).value) || 0,
          reorderPoint: parseFloat(row.getCell(12).value) || 0,
          status: row.getCell(13).value || 'Active'
        });

        // Validate
        const errors = ProductValidator.validate(product);
        if (errors.length === 0) {
          products.push(product);
        }
      });

      // Import
      await this.onImport(products);

      alert(`Successfully imported ${products.length} products`);
    } catch (error) {
      console.error('Import failed:', error);
      alert(`Import failed: ${error.message}`);
    } finally {
      TossLoadingView.hide(loadingElement);
    }
  }

  async loadExcelJS() {
    if (window.ExcelJS) return window.ExcelJS;

    const script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/exceljs@4.3.0/dist/exceljs.min.js';
    document.head.appendChild(script);

    return new Promise((resolve) => {
      script.onload = () => resolve(window.ExcelJS);
    });
  }
}
```

**왜 이 구조인가?**
- `domain/` - 비즈니스 엔티티와 검증 로직
- `data/` - API 호출과 데이터 변환
- `presentation/` - UI 로직과 위젯
- 각 레이어는 독립적이며 테스트 가능

---

## 흔한 실수 (Common Mistakes)

### ❌ 실수 1: `shared/`에 비즈니스 로직 넣기

```typescript
// ❌ 틀림 - Shared 컴포넌트에 비즈니스 로직
// shared/components/ProductCard/ProductCard.tsx
export const ProductCard: React.FC<ProductCardProps> = ({ product }) => {
  const handleSave = async () => {
    // Supabase RPC 호출 - 비즈니스 로직!
    await supabase.rpc('save_product', { ...product });
  };

  return <div onClick={handleSave}>...</div>;
};

// ✅ 올바름 - UI만 담당, 로직은 props로 받음
// shared/components/toss/TossCard/TossCard.tsx
export const TossCard: React.FC<TossCardProps> = ({ onClick, children }) => {
  return (
    <div className={styles.card} onClick={onClick}>
      {children}
    </div>
  );
};
```

**왜 틀렸나?** `shared/`는 **순수 UI 컴포넌트 전용**입니다. 비즈니스 로직은 `features/*/hooks/` 또는 `features/*/data/`에 속합니다.

---

### ❌ 실수 2: `core/`에 UI 컴포넌트 넣기

```typescript
// ❌ 틀림
// core/components/Button.tsx

// ✅ 올바름
// shared/components/toss/TossButton/TossButton.tsx
```

**왜 틀렸나?** `core/`는 **인프라 & 유틸리티 전용**입니다. UI 컴포넌트는 `shared/components/`에 속합니다.

---

### ❌ 실수 3: 컴포넌트에 너무 많은 로직 포함

```typescript
// ❌ 틀림 - 컴포넌트에 모든 로직 (20KB)
export const InventoryPage: React.FC = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);

  // 100줄의 비즈니스 로직...
  const handleImport = async () => {
    // 복잡한 로직들...
  };

  const handleExport = async () => {
    // 복잡한 로직들...
  };

  return <div>...</div>;
};

// ✅ 올바름 - 로직을 hooks로 분리 (8KB)
export const InventoryPage: React.FC = () => {
  const { products, loading, handleImport, handleExport } = useInventory();

  return <div>...</div>;
};
```

**왜 틀렸나?** 컴포넌트는 **UI 렌더링에만 집중**해야 합니다. 복잡한 로직은 **커스텀 훅**으로 분리하세요.

---

### ❌ 실수 4: Feature 로직을 `core/`나 `shared/`에 넣기

```typescript
// ❌ 틀림
// core/inventory/InventoryService.ts
// shared/inventory/InventoryTable.tsx

// ✅ 올바름
// features/inventory/data/repositories/InventoryRepositoryImpl.ts
// features/inventory/presentation/components/InventoryTable/InventoryTable.tsx
```

**왜 틀렸나?** Feature-specific 로직은 `features/`에 속합니다.

---

### ❌ 실수 5: 일반 CSS 사용 (CSS Module 대신)

```typescript
// ❌ 틀림 - 전역 CSS 오염
import './TossButton.css';

export const TossButton = () => {
  return <button className="toss-btn">Click</button>;
};

// ✅ 올바름 - CSS Module
import styles from './TossButton.module.css';

export const TossButton = () => {
  return <button className={styles.tossBtn}>Click</button>;
};
```

**왜 틀렸나?** CSS Module을 사용하면 **스타일 충돌을 방지**하고 **컴포넌트 독립성**을 유지할 수 있습니다.

---

### ❌ 실수 6: 상대 경로 남용 (Path Alias 대신)

```typescript
// ❌ 틀림 - 상대 경로 지옥
import { TossButton } from '../../../../shared/components/toss/TossButton/TossButton';
import { SupabaseService } from '../../../../core/services/supabase.service';

// ✅ 올바름 - Path Alias 사용
import { TossButton } from '@/shared/components/toss/TossButton/TossButton';
import { SupabaseService } from '@/core/services/supabase.service';
```

**왜 틀렸나?** Path Alias(`@/`)를 사용하면 **가독성**과 **리팩토링 용이성**이 향상됩니다.

---

## 집행 (Enforcement)

### 1. 코드 리뷰 체크리스트

PR을 승인하기 전에 확인:
- [ ] `shared/`에 비즈니스 로직이 없음 (순수 UI 컴포넌트만)
- [ ] `core/`에 UI 컴포넌트가 없음 (서비스 & 유틸리티만)
- [ ] `core/`에 완전한 feature가 없음
- [ ] 모든 CSS가 CSS Module로 작성됨 (`.module.css`)
- [ ] Path Alias(`@/`) 사용 여부
- [ ] TypeScript 타입 정의 완료 (`any` 사용 최소화)
- [ ] 단일 파일 크기 제한 준수:
  - TSX: ≤15KB (복잡한 로직은 hooks로 분리)
  - TS: ≤30KB
  - CSS: ≤20KB
- [ ] Feature가 domain/data/presentation 구조를 따름
- [ ] 컴포넌트가 폴더 단위로 구성됨 (TSX + CSS Module + Types + Index)
- [ ] 비즈니스 로직이 커스텀 훅으로 분리됨

### 2. 파일 크기 검사

```bash
# React 프로젝트 파일 크기 검사
# TSX 파일: 15KB 이상 찾기
find src -type f -name "*.tsx" -size +15k

# TS 파일: 30KB 이상 찾기
find src -type f -name "*.ts" ! -name "*.types.ts" -size +30k

# CSS Module 파일: 20KB 이상 찾기
find src -type f -name "*.module.css" -size +20k

# 결과가 없어야 함 (빈 출력)
```

### 3. TypeScript 타입 체크

```bash
# TypeScript 컴파일 오류 확인
npm run type-check

# 또는
tsc --noEmit
```

### 4. ESLint & Prettier 검사

```bash
# ESLint 검사
npm run lint

# Prettier 포맷팅 확인
npm run format:check

# 자동 수정
npm run format
```

### 5. 구조 검증

```bash
# shared/에 hooks나 비즈니스 로직이 있는지 확인
find src/shared -name "*service.ts" -o -name "*repository.ts" -o -name "use*.ts"
# 결과가 없어야 함 (hooks는 features에 있어야 함)

# core/에 React 컴포넌트가 있는지 확인
find src/core -name "*.tsx"
# 결과가 없어야 함

# CSS Module 사용 확인 (일반 .css 파일이 있으면 안됨, themes 제외)
find src -name "*.css" ! -name "*.module.css" ! -path "*/themes/*"
# 결과가 없어야 함
```

### 6. 의심스러울 때

다음 질문을 해보세요:
1. **순수 UI 컴포넌트인가?** → `shared/components/`
2. **인프라/유틸리티/서비스인가?** → `core/`
3. **완전한 feature인가?** → `features/`
4. **컴포넌트 파일이 15KB를 넘는가?** → **hooks로 로직 분리 필수**
5. **상대 경로를 사용하는가?** → **Path Alias(@/) 사용 필수**
6. **일반 CSS를 사용하는가?** → **CSS Module 사용 필수**

---

## 요약: 황금 규칙 (Golden Rules)

### 1. **`core/` = 인프라 & 서비스만**
서비스, 유틸리티, 타입 정의. **UI 컴포넌트 절대 금지**.

```
core/
├── services/     # Supabase, Cache, API 클라이언트
├── utils/        # 공통 유틸리티 함수
└── types/        # 전역 타입 정의
```

### 2. **`shared/` = 순수 UI 컴포넌트만**
디자인 시스템, 재사용 가능한 UI 컴포넌트. **비즈니스 로직 & hooks 금지**.

```
shared/
├── components/
│   ├── common/     # 공통 컴포넌트 (Loading, Modal 등)
│   ├── toss/       # Toss 디자인 시스템 컴포넌트
│   └── selectors/  # Selector 컴포넌트
├── hooks/          # UI 전용 hooks (useToggle, useDebounce 등)
└── themes/         # CSS 변수, 테마
```

### 3. **`features/` = 완전한 Feature 모듈**
각 feature는 Clean Architecture 3-layer 구조를 따름.

```
features/[feature-name]/
├── domain/           # 비즈니스 로직 (엔티티, 검증)
├── data/             # 데이터 접근 (Repository, DataSource, DTO)
└── presentation/     # UI 레이어 (컴포넌트, 페이지, hooks)
    ├── pages/
    ├── components/
    └── hooks/        # Feature-specific 커스텀 훅
```

### 4. **파일 크기 제한 = 엄격히 준수**
React + TypeScript 파일 크기 규칙:
- **TSX (컴포넌트)** ≤ 15KB (복잡하면 hooks로 분리)
- **TS (로직/서비스)** ≤ 30KB
- **CSS Module** ≤ 20KB
- **Types** ≤ 5KB

### 5. **CSS Module = 필수**
일반 CSS 사용 금지. 모든 스타일은 CSS Module로 작성.

```typescript
// ✅ 올바름
import styles from './Component.module.css';
<div className={styles.container} />

// ❌ 틀림
import './Component.css';
<div className="container" />
```

### 6. **Path Alias(@/) = 필수**
상대 경로 사용 금지. 모든 import는 Path Alias 사용.

```typescript
// ✅ 올바름
import { TossButton } from '@/shared/components/toss/TossButton/TossButton';

// ❌ 틀림
import { TossButton } from '../../../../shared/components/toss/TossButton/TossButton';
```

### 7. **컴포넌트 = 폴더 단위**
```
ComponentName/
├── ComponentName.tsx         # React 컴포넌트
├── ComponentName.module.css  # CSS Module
├── ComponentName.types.ts    # Props 타입 정의
└── index.ts                  # Barrel export
```

### 8. **비즈니스 로직 = Hooks로 분리**
컴포넌트는 UI 렌더링만 담당. 복잡한 로직은 커스텀 훅으로 분리.

```typescript
// ✅ 올바름
export const InventoryPage: React.FC = () => {
  const { products, loading, handleImport } = useInventory();
  return <InventoryTable products={products} />;
};
```

---

## 이것이 법입니다 📜

**모든 코드는 이 규칙을 따라야 합니다.**
**팀 논의 없이 예외는 없습니다.**
**이 문서는 아키텍처의 단일 진실 공급원입니다.**

위반 사항을 발견하면 즉시 수정하거나 코드 리뷰에서 제기하세요.

---

## 마이그레이션 체크리스트 (Vanilla JS → React + TypeScript)

### Phase 1: 프로젝트 초기 설정
- [ ] Vite + React + TypeScript 프로젝트 생성
  ```bash
  npm create vite@latest website -- --template react-ts
  cd website
  npm install
  ```
- [ ] Path Alias 설정 (tsconfig.json + vite.config.ts)
- [ ] ESLint + Prettier 설정
- [ ] CSS Module 설정 확인

### Phase 2: 기본 폴더 구조 생성
- [ ] `src/core/` 폴더 생성
  - [ ] `core/services/` - Supabase, Cache
  - [ ] `core/utils/` - 공통 유틸리티
  - [ ] `core/types/` - 전역 타입 정의
- [ ] `src/shared/` 폴더 생성
  - [ ] `shared/components/common/` - 공통 컴포넌트
  - [ ] `shared/components/toss/` - Toss 디자인 시스템
  - [ ] `shared/hooks/` - UI 전용 hooks
  - [ ] `shared/themes/` - CSS 변수, 테마
- [ ] `src/features/` 폴더 생성
- [ ] `src/routes/` 폴더 생성 - React Router 설정

### Phase 3: Core & Shared 마이그레이션
- [ ] Supabase Service 변환 (JS → TS)
  - [ ] `core/services/supabase.service.ts` 생성
  - [ ] TypeScript 타입 정의
- [ ] Toss 디자인 시스템 변환
  - [ ] `shared/themes/` CSS 변수 이동
  - [ ] `shared/components/toss/TossButton/` 변환 (Vanilla → React)
  - [ ] `shared/components/toss/TossModal/` 변환
  - [ ] 기타 Toss 컴포넌트 변환

### Phase 4: Feature 모듈 생성 (우선순위 순)
- [ ] **1. `features/auth/`** (인증 - 최우선)
  - [ ] domain/entities/User.ts
  - [ ] data/repositories/AuthRepositoryImpl.ts
  - [ ] presentation/pages/LoginPage/
  - [ ] presentation/hooks/useAuth.ts
- [ ] **2. `features/dashboard/`** (대시보드)
  - [ ] Clean Architecture 3-layer 구조 생성
- [ ] **3. `features/inventory/`** (재고 관리 - 가장 복잡)
  - [ ] domain/ (Product 엔티티, 검증 로직)
  - [ ] data/ (Repository, DataSource, DTO)
  - [ ] presentation/ (InventoryPage, 컴포넌트, hooks)
- [ ] **4. 기타 Features**
  - [ ] features/finance/
  - [ ] features/employee/
  - [ ] features/settings/

### Phase 5: 라우팅 설정
- [ ] React Router v6 설치
  ```bash
  npm install react-router-dom
  ```
- [ ] `src/routes/index.tsx` 라우터 설정
- [ ] Protected Routes 구현 (인증 필요한 페이지)
- [ ] Layout 컴포넌트 구현

### Phase 6: 기존 HTML 페이지 변환 (270KB → React 컴포넌트)
- [ ] `backup/pages/product/inventory/index.html` (270KB) 분석
- [ ] React 컴포넌트로 분리:
  - [ ] InventoryPage.tsx (≤15KB)
  - [ ] InventoryTable 컴포넌트 (≤15KB)
  - [ ] useInventory 커스텀 훅 (≤10KB)
  - [ ] CSS Module 파일 (≤20KB)
- [ ] 다른 페이지들도 동일하게 변환

### Phase 7: 타입 안전성 강화
- [ ] Supabase Database 타입 생성
  ```bash
  npx supabase gen types typescript --project-id [project-id] > src/core/types/supabase.types.ts
  ```
- [ ] 모든 컴포넌트 Props 타입 정의
- [ ] Repository 인터페이스 타입 정의
- [ ] `any` 타입 사용 최소화 (목표: 0개)

### Phase 8: 검증 & 최적화
- [ ] TypeScript 컴파일 오류 해결
  ```bash
  npm run type-check
  ```
- [ ] ESLint 검사 통과
  ```bash
  npm run lint
  ```
- [ ] 파일 크기 검사 (TSX ≤15KB, TS ≤30KB, CSS ≤20KB)
- [ ] 번들 크기 최적화 (초기 로드 ≤500KB)
- [ ] 코드 리뷰 체크리스트 통과

### Phase 9: 테스팅
- [ ] Vitest 설정
- [ ] 주요 컴포넌트 단위 테스트 작성
- [ ] Repository 레이어 테스트 작성
- [ ] E2E 테스트 (Playwright) 설정

### Phase 10: 배포 준비
- [ ] Production 빌드 테스트
  ```bash
  npm run build
  npm run preview
  ```
- [ ] 환경 변수 설정 (.env)
- [ ] Apache XAMPP 없이 독립 실행 확인
- [ ] Vercel/Netlify 배포 설정 (선택사항)

---

**마지막 업데이트**: 2025-11-05
**버전**: 2.0 (React + TypeScript 업데이트)
**상태**: ✅ React 마이그레이션 준비 완료
