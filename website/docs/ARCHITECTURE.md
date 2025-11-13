# StoreBase Website Architecture - THE LAW 📜

> **This document is the law of this project.**
> **All code must follow these rules. No exceptions without team discussion.**

---

## Tech Stack
- **Frontend**: React 18 + TypeScript 5
- **Build Tool**: Vite 5
- **Styling**: CSS Modules + Toss Design System
- **State Management**: Zustand + Custom Hooks (2025 Best Practice)
- **Routing**: React Router v6
- **Backend**: Supabase (Auth, Database, RPC)
- **Package Manager**: npm

---

## Table of Contents
1. [Core Principles](#core-principles)
2. [Complete Directory Structure](#complete-directory-structure)
3. [Layer Details](#layer-details)
4. [State Management Architecture](#state-management-architecture)
5. [The Law: What Goes Where](#the-law-what-goes-where)
6. [Import Rules](#import-rules)
7. [File Separation Rules](#file-separation-rules)
8. [Practical Examples](#practical-examples)
9. [Common Mistakes](#common-mistakes)
10. [Enforcement](#enforcement)

---

## Core Principles

### 1. Clean Architecture (3 Layers)
We follow **Clean Architecture**:
- **Domain Layer**: Business entities, repository interfaces, validation rules definition
- **Data Layer**: Repository implementations, data sources (Supabase RPC), models (DTO)
- **Presentation Layer**: React components, Custom Hooks (business logic execution), pages

### 2. Feature-First Organization
Each feature is **completely independent** and has its own domain/data/presentation layers.

### 3. Clear Separation
```
core/     = Infrastructure & utilities (services, config, pure functions) - TypeScript
shared/   = UI components & design system (React components, Custom Hooks)
features/ = Complete feature implementation (includes domain/data/presentation layers)
```

### 4. Single File Size Limits
```
TSX  ≤ 15KB   (React components - separate logic into hooks if complex)
TS   ≤ 30KB   (Business logic, utilities)
CSS  ≤ 20KB   (CSS Module, separate per component)
```

**Absolute Rule**: If a single file exceeds 50KB, it **must be split**.

---

## Complete Directory Structure

```
website/
├── index.html                    # 📱 Vite Entry Point
├── vite.config.ts                # Vite configuration
├── tsconfig.json                 # TypeScript configuration
├── tsconfig.node.json            # TypeScript configuration for Node.js
├── package.json                  # Project dependencies
├── .env.local                    # Environment variables (Supabase keys)
│
├── public/                       # 📦 Static files (copied on build)
│   └── assets/
│       ├── images/
│       ├── icons/
│       └── fonts/
│
├── docs/                         # 📚 Project documentation
│   └── ARCHITECTURE.md          # This document
│
└── src/                          # Source code root
    ├── main.tsx                  # React application entry point
    ├── App.tsx                   # Root component
    ├── vite-env.d.ts            # Vite type definitions
    │
    ├── core/                     # 🔧 Infrastructure & Cross-Cutting Concerns
    │   ├── config/               # ✅ App configuration
    │   │   ├── supabase.ts      # Supabase client initialization
    │   │   └── routes.ts        # React Router route configuration
    │   │
    │   ├── constants/            # ✅ App-wide constants
    │   │   ├── app-icons.ts     # Icon mapping
    │   │   ├── ui-constants.ts  # UI constants
    │   │   └── route-paths.ts   # Route paths
    │   │
    │   ├── services/             # ✅ Infrastructure services
    │   │   ├── supabase.service.ts    # Supabase client wrapper
    │   │   ├── storage.service.ts     # LocalStorage/SessionStorage management
    │   │   ├── cache.service.ts       # In-memory caching
    │   │   └── auth.service.ts        # Authentication service
    │   │
    │   ├── utils/                # ✅ Pure utility functions
    │   │   ├── formatters.ts    # Number, date, currency formatting
    │   │   ├── validators.ts    # Validation functions
    │   │   └── helpers.ts       # Common helper functions
    │   │
    │   └── types/                # ✅ Global type definitions
    │       ├── supabase.types.ts # Supabase auto-generated types
    │       └── common.types.ts   # Common types
    │
    ├── shared/                   # 🎨 Shared UI Components & Hooks
    │   ├── themes/               # ✅ Design system tokens
    │   │   ├── variables.css    # CSS variables (colors, spacing, fonts)
    │   │   ├── toss-colors.css  # Toss color palette
    │   │   ├── typography.css   # Typography
    │   │   ├── animations.css   # Animations
    │   │   └── global.css       # Global style reset
    │   │
    │   ├── components/           # ✅ Reusable React components
    │   │   ├── common/          # 📦 Project-wide common components
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
    │   │   ├── toss/            # 📦 Toss Design System base components
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
    │   │   └── selectors/       # 📦 Selector-specific components
    │   │       ├── StoreSelector/
    │   │       │   ├── StoreSelector.tsx
    │   │       │   ├── StoreSelector.module.css
    │   │       │   └── StoreSelector.types.ts
    │   │       └── CompanySelector/
    │   │           ├── CompanySelector.tsx
    │   │           └── CompanySelector.module.css
    │   │
    │   └── hooks/                # ✅ Global Custom Hooks (used across features)
    │       ├── useAuth.ts       # Global authentication state management
    │       ├── useLocalStorage.ts # LocalStorage hook (UI only)
    │       ├── useDebounce.ts   # Debounce hook (UI only)
    │       └── useAsync.ts      # Async handling hook (UI only)
    │
    ├── features/                 # 🎯 Feature Modules (Clean Architecture)
    │   ├── auth/                # Authentication feature
    │   │   ├── domain/
    │   │   │   ├── entities/
    │   │   │   │   └── User.ts # User entity
    │   │   │   ├── repositories/
    │   │   │   │   └── IAuthRepository.ts  # Repository interface
    │   │   │   └── validators/
    │   │   │       └── AuthValidator.ts    # Authentication validation
    │   │   ├── data/
    │   │   │   ├── datasources/
    │   │   │   │   └── AuthDataSource.ts   # Supabase Auth API
    │   │   │   ├── models/
    │   │   │   │   └── UserModel.ts        # DTO + Mapper
    │   │   │   └── repositories/
    │   │   │       └── AuthRepositoryImpl.ts
    │   │   └── presentation/
    │   │       ├── pages/
    │   │       │   ├── LoginPage.tsx        # Login page
    │   │       │   └── RegisterPage.tsx     # Registration page
    │   │       │
    │   │       ├── components/              # Feature-specific components
    │   │       │   ├── LoginForm/
    │   │       │   │   ├── LoginForm.tsx
    │   │       │   │   ├── LoginForm.module.css
    │   │       │   │   └── LoginForm.types.ts
    │   │       │   └── RegisterForm/
    │   │       │       ├── RegisterForm.tsx
    │   │       │       └── RegisterForm.module.css
    │   │       │
    │   │       ├── providers/               # State management providers
    │   │       │   ├── states/              # State type definitions
    │   │       │   │   ├── auth_state.ts    # Auth state interface
    │   │       │   │   └── types.ts         # Shared state types
    │   │       │   └── auth_provider.ts     # Zustand Auth store (2025 Best Practice)
    │   │       │
    │   │       └── hooks/                   # Feature-specific Custom Hooks
    │   │           ├── useLogin.ts          # Login logic (Validation + Repository)
    │   │           ├── useRegister.ts       # Registration logic (Validation + Repository)
    │   │           └── useAuth.ts           # Hook that uses auth provider
    │   │
    │   ├── dashboard/            # Dashboard feature
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
    │   │       ├── providers/               # State management providers
    │   │       │   ├── states/              # State type definitions
    │   │       │   │   ├── dashboard_state.ts  # Dashboard state interface
    │   │       │   │   └── types.ts         # Shared state types
    │   │       │   └── dashboard_provider.ts  # Zustand Dashboard store (2025 Best Practice)
    │   │       └── hooks/
    │   │           └── useDashboard.ts      # Dashboard logic (Repository calls + Provider)
    │   │
    │   ├── inventory/            # Inventory management feature
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
    │   │       │   └── InventoryPage.tsx       # Inventory management page
    │   │       │
    │   │       ├── components/                 # Feature-specific components
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
    │   │       ├── providers/               # State management providers
    │   │       │   ├── states/              # State type definitions
    │   │       │   │   ├── inventory_state.ts  # Inventory state interface
    │   │       │   │   └── types.ts         # Shared state types
    │   │       │   └── inventory_provider.ts  # Zustand Inventory store (2025 Best Practice)
    │   │       │
    │   │       └── hooks/
    │   │           ├── useInventory.ts      # Inventory management logic (Repository calls + Provider)
    │   │           ├── useProducts.ts       # Product management logic (Validation + Repository)
    │   │           └── useExcelImport.ts    # Excel import logic (Validation + Repository)
    │   │
    │   ├── finance/              # Finance management feature
    │   │   ├── domain/
    │   │   ├── data/
    │   │   └── presentation/
    │   │
    │   ├── employee/             # Employee management feature
    │   │   ├── domain/
    │   │   ├── data/
    │   │   └── presentation/
    │   │
    │   └── settings/             # Settings feature
    │       ├── domain/
    │       ├── data/
    │       └── presentation/
    │
    └── routes/                   # ✅ React Router configuration
        ├── index.tsx             # Route definitions
        ├── ProtectedRoute.tsx    # Authentication guard
        └── PublicRoute.tsx       # Public routes
```

---

## Layer Details

### 🔧 `core/` - Infrastructure & Cross-Cutting Concerns

**Role**: Infrastructure services and cross-cutting concerns

**What should be included**:
- ✅ Infrastructure services (Supabase, HTTP client, caching)
- ✅ Constants (API endpoints, configuration values)
- ✅ Pure utility functions (formatters, validators, helpers)
- ✅ Router and navigation logic
- ✅ App-wide configuration

**What should NOT be included**:
- ❌ UI components (widgets, buttons, cards)
- ❌ Design system tokens (colors, typography, spacing)
- ❌ Complete feature implementations (domain/data/presentation)
- ❌ Feature-specific business logic
- ❌ HTML/CSS files

**Examples**:
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

**Role**: Reusable UI components and design system

**What should be included**:
- ✅ Reusable UI components (buttons, cards, inputs)
- ✅ Design system tokens (colors, typography, spacing, shadows)
- ✅ Theme configuration (CSS variables, style reset)
- ✅ **Common components** (`shared/components/common/`) - Project-wide common widgets
- ✅ HTML templates

**What should NOT be included**:
- ❌ Business logic or domain rules
- ❌ Data layer code (repository, data source)
- ❌ Domain entities
- ❌ Infrastructure services (database, API)
- ❌ Caching system
- ❌ RPC calls

**Core Principle**: What designers care about → `shared/`. What backend engineers care about → `core/`.

**`shared/components/` sub-structure**:
```
shared/components/
├── common/        # 📦 Common components used across the entire project
│                  # e.g., TossScaffold, TossAppBar, TossDialog
├── toss/          # 📦 Toss design system basic components
│                  # e.g., TossButton, TossInput, TossCard
└── selectors/     # 📦 Selector-related components
                   # e.g., StoreSelector, CompanySelector
```

**Component structure rules**:
```
shared/components/toss/TossButton/
├── TossButton.tsx          # React component
├── TossButton.module.css   # CSS Module styles
└── TossButton.types.ts     # TypeScript type definitions
```

**Example**:
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

**`shared/hooks/` - Global Custom Hooks**:
```
shared/hooks/
├── useAuth.ts           # Global authentication state management (used across multiple features)
├── useLocalStorage.ts   # LocalStorage hook (UI only)
├── useDebounce.ts       # Debounce hook (UI only)
└── useAsync.ts          # Async processing hook (UI only)
```

**What should be included**:
- ✅ Global authentication state management (useAuth)
- ✅ UI-only hooks (useToggle, useDebounce, useMediaQuery)
- ✅ Browser API hooks (useLocalStorage, useSessionStorage)

**What should NOT be included**:
- ❌ Feature-specific business logic (→ `features/*/presentation/hooks/`)
- ❌ Complex Validation + Repository logic (→ `features/*/presentation/hooks/`)
- ❌ Feature-specific data management (→ `features/*/presentation/hooks/`)

**Example**:
```typescript
// ✅ shared/hooks/useAuth.ts - Global authentication state
import { useState, useEffect } from 'react';
import { AuthRepositoryImpl } from '@/features/auth/data/repositories/AuthRepositoryImpl';

export const useAuth = () => {
  const [user, setUser] = useState(null);
  const [authenticated, setAuthenticated] = useState(false);

  const repository = new AuthRepositoryImpl();

  const checkAuth = async () => {
    const currentUser = await repository.getCurrentUser();
    setUser(currentUser);
    setAuthenticated(currentUser !== null);
  };

  return { user, authenticated, signOut: repository.signOut };
};
```

---

### 🎯 `features/` - Complete Feature Implementation

**Role**: Complete feature implementation (Clean Architecture)

**What should be included**:
- ✅ Complete feature with domain/data/presentation layers
- ✅ Feature-specific entities
- ✅ Feature-specific repository
- ✅ Feature-specific business logic
- ✅ Feature-specific UI pages and widgets

**Structure of each feature**:
```
features/my_feature/
├── domain/                    # Business rules definition
│   ├── entities/             # Business objects
│   │   └── MyEntity.ts
│   ├── repositories/         # Repository interfaces (abstract)
│   │   └── IMyRepository.ts
│   └── validators/           # Validation rules definition (static methods)
│       └── MyValidator.ts
├── data/                      # Data processing
│   ├── datasources/          # API calls, RPC execution
│   │   └── MyDataSource.ts
│   ├── models/               # DTO + Mapper
│   │   └── MyModel.ts
│   └── repositories/         # Repository implementations
│       └── MyRepositoryImpl.ts
└── presentation/              # UI + Business logic execution
    ├── pages/                # Full pages
    │   └── MyPage/
    │       ├── MyPage.tsx         # React component
    │       ├── MyPage.module.css  # CSS Module
    │       ├── MyPage.types.ts    # Type definitions
    │       └── index.ts           # Barrel export
    ├── components/           # Feature-specific components
    │   └── MyComponent/
    │       ├── MyComponent.tsx
    │       ├── MyComponent.module.css
    │       └── MyComponent.types.ts
    ├── providers/            # State management providers
    │   ├── states/           # State type definitions
    │   │   ├── my_feature_state.ts  # Feature state interface
    │   │   └── types.ts      # Shared state types
    │   └── my_feature_provider.ts  # Zustand store (2025 Best Practice)
    └── hooks/                # Feature-specific Custom Hooks
        └── useMyFeature.ts   # Validation execution + Repository calls + Provider usage
```

**🔑 Important**:
- `domain/validators/`: Define validation **rules only** (static methods)
- `presentation/hooks/`: Validation **execution** + Repository calls (business logic execution)
```

**Example**: See [Practical Examples](#practical-examples) section

---

## State Management Architecture

### 📦 Zustand + Custom Hooks Pattern (2025 Best Practice)

**Philosophy**: Following 2025 industry trends, we use **Zustand** for state management combined with custom hooks pattern for clean separation of concerns.

**Why Zustand?**
- ✅ Lightweight and fast (minimal bundle size)
- ✅ No boilerplate code
- ✅ Simple API with hooks
- ✅ TypeScript-first
- ✅ No Provider hell
- ✅ Industry standard in 2025

### State Management Layers

#### 1. **Global State** (`shared/hooks/`)
For authentication and app-wide state that needs to be accessed across multiple features.

```typescript
// ✅ shared/hooks/useAuth.ts
// Global authentication state using Zustand or Context
```

**What belongs in global state:**
- Authentication state (user, session)
- Theme settings
- App configuration
- Shared UI state (sidebar open/closed)

#### 2. **Feature State** (`features/*/presentation/providers/`)
For feature-specific state management using Zustand.

**Folder Structure:**
```
features/journal-input/presentation/
├── providers/
│   ├── states/
│   │   ├── journal_input_state.ts  # State interface definitions
│   │   └── types.ts                # Shared state types
│   └── journal_input_provider.ts   # Zustand store definition
└── hooks/
    └── useJournalInput.ts          # Custom hook that uses the provider
```

**Example Store Definition:**
```typescript
// ✅ features/journal-input/presentation/providers/states/journal_input_state.ts
export interface JournalInputState {
  // State
  date: Date;
  description: string;
  transactionLines: TransactionLine[];
  totalDebits: number;
  totalCredits: number;
  isBalanced: boolean;
  loading: boolean;
  error: string | null;

  // Actions
  setDate: (date: Date) => void;
  setDescription: (description: string) => void;
  addTransactionLine: (line: TransactionLine) => void;
  updateTransactionLine: (index: number, line: TransactionLine) => void;
  removeTransactionLine: (index: number) => void;
  reset: () => void;

  // Async actions
  submitJournalEntry: () => Promise<{ success: boolean; error?: string }>;
}

// ✅ features/journal-input/presentation/providers/journal_input_provider.ts
import { create } from 'zustand';
import { JournalInputState } from './states/journal_input_state';
import { JournalInputDataSource } from '../../data/datasources/JournalInputDataSource';

const dataSource = new JournalInputDataSource();

export const useJournalInputStore = create<JournalInputState>((set, get) => ({
  // Initial state
  date: new Date(),
  description: '',
  transactionLines: [],
  totalDebits: 0,
  totalCredits: 0,
  isBalanced: false,
  loading: false,
  error: null,

  // Actions
  setDate: (date) => set({ date }),

  setDescription: (description) => set({ description }),

  addTransactionLine: (line) => set((state) => {
    const newLines = [...state.transactionLines, line];
    return {
      transactionLines: newLines,
      ...calculateTotals(newLines),
    };
  }),

  updateTransactionLine: (index, line) => set((state) => {
    const newLines = [...state.transactionLines];
    newLines[index] = line;
    return {
      transactionLines: newLines,
      ...calculateTotals(newLines),
    };
  }),

  removeTransactionLine: (index) => set((state) => {
    const newLines = state.transactionLines.filter((_, i) => i !== index);
    return {
      transactionLines: newLines,
      ...calculateTotals(newLines),
    };
  }),

  reset: () => set({
    date: new Date(),
    description: '',
    transactionLines: [],
    totalDebits: 0,
    totalCredits: 0,
    isBalanced: false,
    error: null,
  }),

  // Async actions
  submitJournalEntry: async () => {
    const state = get();

    if (!state.isBalanced) {
      return { success: false, error: 'Journal entry must be balanced' };
    }

    set({ loading: true, error: null });

    try {
      await dataSource.submitJournalEntry({
        companyId: '...', // Get from context
        storeId: '...',
        date: state.date,
        description: state.description,
        transactionLines: state.transactionLines,
        // ...
      });

      get().reset(); // Reset after successful submission
      return { success: true };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Unknown error';
      set({ error: errorMessage });
      return { success: false, error: errorMessage };
    } finally {
      set({ loading: false });
    }
  },
}));

// Helper function
function calculateTotals(lines: TransactionLine[]) {
  const totalDebits = lines
    .filter((line) => line.isDebit)
    .reduce((sum, line) => sum + line.amount, 0);

  const totalCredits = lines
    .filter((line) => !line.isDebit)
    .reduce((sum, line) => sum + line.amount, 0);

  const isBalanced = totalDebits === totalCredits && totalDebits > 0;

  return { totalDebits, totalCredits, isBalanced };
}
```

**Custom Hook Wrapper:**
```typescript
// ✅ features/journal-input/presentation/hooks/useJournalInput.ts
import { useJournalInputStore } from '../providers/journal_input_provider';

export const useJournalInput = () => {
  // Select only the needed state and actions
  const date = useJournalInputStore((state) => state.date);
  const description = useJournalInputStore((state) => state.description);
  const transactionLines = useJournalInputStore((state) => state.transactionLines);
  const totalDebits = useJournalInputStore((state) => state.totalDebits);
  const totalCredits = useJournalInputStore((state) => state.totalCredits);
  const isBalanced = useJournalInputStore((state) => state.isBalanced);
  const loading = useJournalInputStore((state) => state.loading);
  const error = useJournalInputStore((state) => state.error);

  const setDate = useJournalInputStore((state) => state.setDate);
  const setDescription = useJournalInputStore((state) => state.setDescription);
  const addTransactionLine = useJournalInputStore((state) => state.addTransactionLine);
  const updateTransactionLine = useJournalInputStore((state) => state.updateTransactionLine);
  const removeTransactionLine = useJournalInputStore((state) => state.removeTransactionLine);
  const reset = useJournalInputStore((state) => state.reset);
  const submitJournalEntry = useJournalInputStore((state) => state.submitJournalEntry);

  return {
    // State
    date,
    description,
    transactionLines,
    totalDebits,
    totalCredits,
    isBalanced,
    loading,
    error,

    // Actions
    setDate,
    setDescription,
    addTransactionLine,
    updateTransactionLine,
    removeTransactionLine,
    reset,
    submitJournalEntry,
  };
};
```

**Component Usage:**
```typescript
// ✅ features/journal-input/presentation/pages/JournalInputPage/JournalInputPage.tsx
import React from 'react';
import { useJournalInput } from '../../hooks/useJournalInput';

export const JournalInputPage: React.FC = () => {
  const {
    transactionLines,
    totalDebits,
    totalCredits,
    isBalanced,
    loading,
    addTransactionLine,
    submitJournalEntry,
  } = useJournalInput();

  const handleSubmit = async () => {
    const result = await submitJournalEntry();
    if (result.success) {
      alert('Journal entry submitted successfully!');
    }
  };

  return (
    <div>
      <h1>Journal Entry</h1>
      <div>Debits: {totalDebits}</div>
      <div>Credits: {totalCredits}</div>
      <div>Balanced: {isBalanced ? 'Yes' : 'No'}</div>

      <button onClick={handleSubmit} disabled={!isBalanced || loading}>
        {loading ? 'Submitting...' : 'Submit Entry'}
      </button>

      {/* Transaction list */}
    </div>
  );
};
```

### Best Practices

#### 1. **Selector Optimization**
Always select only the state you need to prevent unnecessary re-renders.

```typescript
// ❌ Bad - Component re-renders on any state change
const state = useJournalInputStore();

// ✅ Good - Component re-renders only when transactionLines changes
const transactionLines = useJournalInputStore((state) => state.transactionLines);
```

#### 2. **Actions Grouping**
Group actions logically and separate them from state.

```typescript
// ✅ Good - Actions grouped separately
const { addLine, removeLine, updateLine } = useJournalInputStore(
  (state) => ({
    addLine: state.addTransactionLine,
    removeLine: state.removeTransactionLine,
    updateLine: state.updateTransactionLine,
  })
);
```

#### 3. **Async Actions in Store**
Keep async operations (Repository calls) in the store, not in hooks.

```typescript
// ✅ Good - Async logic in store
submitJournalEntry: async () => {
  set({ loading: true });
  try {
    await dataSource.submitJournalEntry(/* ... */);
    return { success: true };
  } catch (error) {
    set({ error: error.message });
    return { success: false };
  } finally {
    set({ loading: false });
  }
}
```

#### 4. **Type Safety**
Always define comprehensive TypeScript types for your store.

```typescript
// ✅ types.ts - Separate type definitions
export interface JournalInputState {
  // State properties with explicit types
  date: Date;
  description: string;
  transactionLines: TransactionLine[];

  // Action signatures
  setDate: (date: Date) => void;
  submitJournalEntry: () => Promise<SubmitResult>;
}
```

#### 5. **Provider File Size**
Keep provider files under 30KB. If larger, split into multiple providers.

```typescript
// ✅ Good - Separate providers for different concerns
// journal_input_provider.ts - Entry state
// journal_filter_provider.ts - Filter state
// journal_history_provider.ts - History state
```

### State Management Rules

#### ✅ What belongs in Zustand Provider (`features/*/presentation/providers/`):
- Feature-specific UI state (form data, filters, selections)
- Loading/error states
- Computed values (derived state)
- Feature-specific actions
- Repository calls (async operations)

#### ❌ What does NOT belong in Provider:
- Domain entities → `features/*/domain/entities/`
- Validation rules → `features/*/domain/validators/`
- Data transformation → `features/*/data/models/`
- Repository implementations → `features/*/data/repositories/`

### Migration Path (Old → New)

**Before (useState in Component):**
```typescript
// ❌ Old way - State scattered in components
export const JournalInputPage: React.FC = () => {
  const [transactionLines, setTransactionLines] = useState([]);
  const [loading, setLoading] = useState(false);
  // ... 50 lines of state management
};
```

**After (Zustand Provider):**
```typescript
// ✅ New way - Centralized state in provider
export const JournalInputPage: React.FC = () => {
  const { transactionLines, loading, addLine } = useJournalInput();
  // Clean component focusing on UI
};
```

---

## The Law: What Goes Where

### Rule 1: `core/` = Infrastructure only, No UI

```
✅ core/services/supabase-service.js      # Infrastructure service
✅ core/services/cache-service.js         # Caching
✅ core/utils/formatters.js               # Utilities
✅ core/config/router-config.js           # App configuration

❌ core/themes/toss-colors.css            # → shared/themes/
❌ core/components/button.js              # → shared/components/
❌ core/inventory/InventoryPage.js        # → features/inventory/
```

### Rule 2: `shared/` = UI + Global Hooks only, No Feature Business Logic

```
✅ shared/components/toss/TossButton/TossButton.tsx      # UI component
✅ shared/components/common/TossDialog/TossDialog.tsx    # Common widget
✅ shared/themes/toss-colors.css                         # Design tokens
✅ shared/hooks/useAuth.ts                               # Global auth state
✅ shared/hooks/useDebounce.ts                           # UI-only Hook

❌ shared/services/api-service.ts                        # → core/services/
❌ shared/domain/Product.ts                              # → features/*/domain/
❌ shared/data/repositories/ProductRepository.ts         # → features/*/data/
❌ shared/hooks/useInventory.ts                          # → features/inventory/presentation/hooks/
```

**Core principle**:
- `shared/hooks/`: Global state management + UI-only Hooks only
- `features/*/presentation/hooks/`: Feature-specific business logic (Validation + Repository)
```

### Rule 3: `features/` = Complete feature (domain/data/presentation)

```
✅ features/inventory/domain/entities/Product.js
✅ features/inventory/data/repositories/InventoryRepositoryImpl.js
✅ features/inventory/presentation/pages/inventory/inventory.js

❌ features/inventory/utils/formatters.js                # → core/utils/
❌ features/inventory/themes/colors.css                  # → shared/themes/
```

### Rule 4: File Size Limits

```
✅ inventory.html (8KB)    # HTML structure only
✅ inventory.css (15KB)    # Styles only
✅ inventory.js (25KB)     # Page logic only

❌ inventory.html (270KB)  # Everything in one file - ABSOLUTELY FORBIDDEN!
```

---

## Import Rules

### 1. Theme Imports - **Always** use `shared/themes/`

```html
<!-- ✅ Correct -->
<link rel="stylesheet" href="../../../shared/themes/toss-variables.css">
<link rel="stylesheet" href="../../../shared/themes/toss-base.css">

<!-- ❌ Wrong (core/themes is forbidden) -->
<link rel="stylesheet" href="../../../core/themes/toss-variables.css">
```

### 2. Component Imports - Use `shared/components/`

```javascript
// ✅ Correct
import { TossButton } from '../../../shared/components/toss/TossButton/TossButton.js';
import { TossDialog } from '../../../shared/components/common/TossDialog/TossDialog.js';

// ❌ Wrong
import { TossButton } from '../../../core/components/TossButton.js';
```

### 3. Service Imports - Use `core/services/`

```javascript
// ✅ Correct
import { SupabaseService } from '../../../core/services/supabase-service.js';
import { CacheService } from '../../../core/services/cache-service.js';

// ❌ Wrong
import { SupabaseService } from '../../../shared/services/supabase-service.js';
```

### 4. Utility Imports - Use `core/utils/`

```javascript
// ✅ Correct
import { formatCurrency } from '../../../core/utils/formatters.js';
import { validateEmail } from '../../../core/utils/validators.js';
```

### 5. Import Order in Files

```javascript
// 1. External libraries
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

## File Separation Rules

### Rule 1: React Components must be separated into **TSX + CSS Module + Types**

**Bad Example** (Old Vanilla JS approach):
```html
<!-- ❌ inventory.html (270KB) - Everything in one file -->
<!DOCTYPE html>
<html>
<head>
  <style>
    /* 1000 lines of CSS */
  </style>
</head>
<body>
  <script>
    // 5000 lines of JavaScript
  </script>
</body>
</html>
```

**Good Example** (React + TypeScript approach):
```
features/inventory/presentation/pages/InventoryPage/
├── InventoryPage.tsx         (≤15KB)  # React component
├── InventoryPage.module.css  (≤20KB)  # CSS Module
├── InventoryPage.types.ts    (≤5KB)   # Type definitions
└── index.ts                   (≤1KB)   # Barrel export
```

```typescript
// ✅ InventoryPage.types.ts - Type definitions only
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
// ✅ InventoryPage.tsx - React component (separate logic into hooks if complex)
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

### Rule 2: Components must be **separated by folder** (Component + Styles + Types + Hooks)

**Shared Component Structure**:
```
shared/components/toss/TossButton/
├── TossButton.tsx         # React component
├── TossButton.module.css  # CSS Module
├── TossButton.types.ts    # Props types
└── index.ts               # Barrel export
```

**Feature Component Structure** (complex cases):
```
features/inventory/presentation/components/InventoryTable/
├── InventoryTable.tsx         # Main component
├── InventoryTable.module.css  # Styles
├── InventoryTable.types.ts    # Type definitions
├── InventoryTableRow.tsx      # Sub-component
├── useInventoryTable.ts       # Custom hook (logic separation)
└── index.ts                   # Barrel export
```

### Rule 3: Business Logic must be **separated into Hooks** (Validation execution + Repository calls)

**Core Pattern**: Custom Hooks call Validator to execute validation and call Repository.

```typescript
// ✅ 1. domain/validators/AuthValidator.ts - Define validation rules
export class AuthValidator {
  static validateEmail(email: string): ValidationError | null {
    if (!email.trim()) {
      return { field: 'email', message: 'Email is required' };
    }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return { field: 'email', message: 'Invalid email format' };
    }
    return null;
  }

  static validatePassword(password: string): ValidationError | null {
    if (!password.trim()) {
      return { field: 'password', message: 'Password is required' };
    }
    if (password.length < 6) {
      return { field: 'password', message: 'Password must be at least 6 characters' };
    }
    return null;
  }

  static validateLoginCredentials(email: string, password: string): ValidationError[] {
    const errors: ValidationError[] = [];
    const emailError = this.validateEmail(email);
    if (emailError) errors.push(emailError);
    const passwordError = this.validatePassword(password);
    if (passwordError) errors.push(passwordError);
    return errors;
  }
}
```

```typescript
// ✅ 2. presentation/hooks/useLogin.ts - Validation execution + Repository calls
import { useState } from 'react';
import { AuthRepositoryImpl } from '../../data/repositories/AuthRepositoryImpl';
import { AuthValidator } from '../../domain/validators/AuthValidator';

export const useLogin = () => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});

  const repository = new AuthRepositoryImpl();

  const login = async (email: string, password: string) => {
    // 1. Call Validator (execute validation)
    const validationErrors = AuthValidator.validateLoginCredentials(email, password);
    if (validationErrors.length > 0) {
      const errors: Record<string, string> = {};
      validationErrors.forEach((err) => {
        errors[err.field] = err.message;
      });
      setFieldErrors(errors);
      return { success: false };
    }

    // 2. Call Repository (data processing)
    setLoading(true);
    try {
      const result = await repository.signIn({ email, password });
      if (!result.success) {
        setError(result.error || 'Login failed');
        return { success: false };
      }
      return { success: true, user: result.user };
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      return { success: false };
    } finally {
      setLoading(false);
    }
  };

  return { login, loading, error, fieldErrors };
};
```

**Flow**:
```
Page → Custom Hook (Call Validator → Call Repository) → Repository → DataSource → DB
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                     Business logic execution location
```

### Rule 4: Domain/Data Layer must **remain class-based**

```typescript
// ✅ domain/entities/Product.ts - Entity
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

// ✅ domain/validators/ProductValidator.js - Validation
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

// ✅ data/datasources/InventoryDataSource.js - API calls
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

// ✅ data/repositories/InventoryRepositoryImpl.js - Repository implementation
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

## Practical Examples

### Example 1: Creating a New Common Widget

**Scenario**: I want to create a "TossLoadingView" widget to be used across the entire project.

**File structure**:
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

**Usage Example**:
```javascript
import { TossLoadingView } from '../../../shared/components/common/TossLoadingView/TossLoadingView.js';

const loading = new TossLoadingView('Processing...');
const loadingElement = loading.show(document.body);

// After work completes
TossLoadingView.hide(loadingElement);
```

**Why `shared/components/common/`?**
- Used across entire project
- No business logic
- Pure UI component

---

### Example 2: Creating a New Feature (Inventory)

**Scenario**: Implement "Inventory" feature with Clean Architecture

**File Structure**:
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

### Example 3: Excel Importer Widget

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

**Why this structure?**
- `domain/` - Business entities and validation rules definition
- `data/` - API calls and data transformation
- `presentation/` - UI logic and business logic execution (Validators + Repository calls)
- Each layer is independent and testable

---

## Common Mistakes

### ❌ Mistake 1: Putting Business Logic in `shared/`

```typescript
// ❌ Wrong - Business logic in Shared component
// shared/components/ProductCard/ProductCard.tsx
export const ProductCard: React.FC<ProductCardProps> = ({ product }) => {
  const handleSave = async () => {
    // Supabase RPC call - Business logic!
    await supabase.rpc('save_product', { ...product });
  };

  return <div onClick={handleSave}>...</div>;
};

// ✅ Correct - UI only, receive logic via props
// shared/components/toss/TossCard/TossCard.tsx
export const TossCard: React.FC<TossCardProps> = ({ onClick, children }) => {
  return (
    <div className={styles.card} onClick={onClick}>
      {children}
    </div>
  );
};
```

**Why is it wrong?** `shared/` is **for UI components + global/UI hooks only**. Feature-specific business logic belongs in `features/*/presentation/hooks/` or `features/*/data/`.

---

### ❌ Mistake 2: Putting UI Components in `core/`

```typescript
// ❌ Wrong
// core/components/Button.tsx

// ✅ Correct
// shared/components/toss/TossButton/TossButton.tsx
```

**Why is it wrong?** `core/` is **for infrastructure & utilities only**. UI components belong in `shared/components/`.

---

### ❌ Mistake 3: Including Too Much Logic in Components

```typescript
// ❌ Wrong - All logic in component (20KB)
export const InventoryPage: React.FC = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);

  // 100 lines of business logic...
  const handleImport = async () => {
    // Complex logic...
  };

  const handleExport = async () => {
    // Complex logic...
  };

  return <div>...</div>;
};

// ✅ Correct - Separate logic into hooks (8KB)
export const InventoryPage: React.FC = () => {
  const { products, loading, handleImport, handleExport } = useInventory();

  return <div>...</div>;
};
```

**Why is it wrong?** Components should **focus only on UI rendering**. Separate complex logic into **custom hooks**.

---

### ❌ Mistake 4: Putting Feature Logic in `core/` or `shared/`

```typescript
// ❌ Wrong
// core/inventory/InventoryService.ts
// shared/inventory/InventoryTable.tsx

// ✅ Correct
// features/inventory/data/repositories/InventoryRepositoryImpl.ts
// features/inventory/presentation/components/InventoryTable/InventoryTable.tsx
```

**Why is it wrong?** Feature-specific logic belongs in `features/`.

---

### ❌ Mistake 5: Using Regular CSS (Instead of CSS Modules)

```typescript
// ❌ Wrong - Global CSS pollution
import './TossButton.css';

export const TossButton = () => {
  return <button className="toss-btn">Click</button>;
};

// ✅ Correct - CSS Module
import styles from './TossButton.module.css';

export const TossButton = () => {
  return <button className={styles.tossBtn}>Click</button>;
};
```

**Why is it wrong?** CSS Modules **prevent style conflicts** and maintain **component independence**.

---

### ❌ Mistake 6: Overusing Relative Paths (Instead of Path Alias)

```typescript
// ❌ Wrong - Relative path hell
import { TossButton } from '../../../../shared/components/toss/TossButton/TossButton';
import { SupabaseService } from '../../../../core/services/supabase.service';

// ✅ Correct - Use Path Alias
import { TossButton } from '@/shared/components/toss/TossButton/TossButton';
import { SupabaseService } from '@/core/services/supabase.service';
```

**Why is it wrong?** Using Path Alias (`@/`) improves **readability** and **refactoring ease**.

---

## Enforcement

### 1. Code Review Checklist

Before approving PR, verify:
- [ ] No Feature-specific business logic in `shared/` (UI components + global/UI hooks only)
- [ ] No UI components in `core/` (services & utilities only)
- [ ] No complete features in `core/`
- [ ] All CSS written as CSS Modules (`.module.css`)
- [ ] Path Alias (`@/`) used
- [ ] TypeScript types defined (minimize `any` usage)
- [ ] Single file size limits followed:
  - TSX: ≤15KB (separate complex logic into hooks)
  - TS: ≤30KB
  - CSS: ≤20KB
- [ ] Features follow domain/data/presentation structure
- [ ] Validation rules defined in `domain/validators/` (static methods)
- [ ] Validation execution + Repository calls implemented in `presentation/hooks/`
- [ ] Components organized by folder (TSX + CSS Module + Types + Index)
- [ ] Business logic separated into custom hooks (Call Validator → Call Repository)

### 2. File Size Inspection

```bash
# React project file size inspection
# Find TSX files over 15KB
find src -type f -name "*.tsx" -size +15k

# Find TS files over 30KB
find src -type f -name "*.ts" ! -name "*.types.ts" -size +30k

# Find CSS Module files over 20KB
find src -type f -name "*.module.css" -size +20k

# Should return no results (empty output)
```

### 3. TypeScript Type Check

```bash
# Check TypeScript compilation errors
npm run type-check

# Or
tsc --noEmit
```

### 4. ESLint & Prettier Check

```bash
# ESLint check
npm run lint

# Prettier formatting check
npm run format:check

# Auto fix
npm run format
```

### 5. Structure Validation

```bash
# Check if shared/ has business logic (service, repository are forbidden)
find src/shared -name "*service.ts" -o -name "*repository.ts"
# Should return no results

# shared/hooks/ should only have global hooks (useAuth, useDebounce, etc.)
# Feature-specific hooks (useInventory, useLogin, etc.) must be in features/*/presentation/hooks/

# Check if core/ has React components
find src/core -name "*.tsx"
# Should return no results

# Check CSS Module usage (no regular .css files except in themes)
find src -name "*.css" ! -name "*.module.css" ! -path "*/themes/*"
# Should return no results
```

### 6. When in Doubt

Ask these questions:
1. **Is it a pure UI component?** → `shared/components/`
2. **Is it infrastructure/utility/service?** → `core/`
3. **Is it a complete feature?** → `features/`
4. **Does the component file exceed 15KB?** → **Must separate logic into hooks**
5. **Are you using relative paths?** → **Must use Path Alias (@/)**
6. **Are you using regular CSS?** → **Must use CSS Modules**

---

## Summary: Golden Rules

### 1. **`core/` = Infrastructure & Services Only**
Services, utilities, type definitions. **UI components ABSOLUTELY FORBIDDEN**.

```
core/
├── services/     # Supabase, Cache, API clients
├── utils/        # Common utility functions
└── types/        # Global type definitions
```

### 2. **`shared/` = UI Components + Global Hooks Only**
Design system, reusable UI components, global state management hooks. **Feature-specific business logic FORBIDDEN**.

```
shared/
├── components/
│   ├── common/     # Common components (Loading, Modal, etc.)
│   ├── toss/       # Toss design system components
│   └── selectors/  # Selector components
├── hooks/          # ✅ Global hooks (useAuth) + UI-only hooks (useToggle, useDebounce)
│                   # ❌ Feature-specific business logic → features/*/presentation/hooks/
└── themes/         # CSS variables, themes
```

### 3. **`features/` = Complete Feature Modules**
Each feature follows Clean Architecture 3-layer structure.

```
features/[feature-name]/
├── domain/           # Business rules definition (entities, validation rules)
│   └── validators/   # Define validation rules only (static methods)
├── data/             # Data access (Repository, DataSource, DTO)
└── presentation/     # UI layer + Business logic execution
    ├── pages/
    ├── components/
    ├── providers/    # State management providers (2025 Best Practice)
    │   ├── states/   # State type definitions
    │   └── *_provider.ts  # Zustand provider implementation
    └── hooks/        # Feature-specific custom hooks (Validation execution + Repository calls + Provider usage)
```

**🔑 Core Pattern**:
- `domain/validators/`: **Define validation rules only** (static methods)
- `presentation/providers/states/`: **State type definitions** (TypeScript interfaces)
- `presentation/providers/`: **Zustand providers** (feature state management)
- `presentation/hooks/`: Validation **execution** + Repository calls + Provider usage (business logic flow)

### 4. **File Size Limits = Strictly Enforced**
React + TypeScript file size rules:
- **TSX (components)** ≤ 15KB (separate into hooks if complex)
- **TS (logic/services)** ≤ 30KB
- **CSS Module** ≤ 20KB
- **Types** ≤ 5KB

### 5. **CSS Modules = Required**
Regular CSS forbidden. All styles must be written as CSS Modules.

```typescript
// ✅ Correct
import styles from './Component.module.css';
<div className={styles.container} />

// ❌ Wrong
import './Component.css';
<div className="container" />
```

### 6. **Path Alias (@/) = Required**
Relative paths forbidden. All imports must use Path Alias.

```typescript
// ✅ Correct
import { TossButton } from '@/shared/components/toss/TossButton/TossButton';

// ❌ Wrong
import { TossButton } from '../../../../shared/components/toss/TossButton/TossButton';
```

### 7. **Components = Folder-Based**
```
ComponentName/
├── ComponentName.tsx         # React component
├── ComponentName.module.css  # CSS Module
├── ComponentName.types.ts    # Props type definitions
└── index.ts                  # Barrel export
```

### 8. **Business Logic = Validators + Hooks Pattern**
Components only handle UI rendering. Validation rules defined in Domain/Validators, execution in Presentation/Hooks.

```typescript
// ✅ Correct: Component → Hook → Validator + Repository
export const LoginPage: React.FC = () => {
  const { login, loading, error } = useLogin();
  return <LoginForm onSubmit={login} />;
};

// Inside useLogin Hook:
// 1. Call AuthValidator.validateLoginCredentials() (execute validation)
// 2. Call repository.signIn() (data processing)
```

---

## This is The Law 📜

**All code must follow these rules.**
**No exceptions without team discussion.**
**This document is the single source of truth for architecture.**

If you find violations, fix them immediately or raise them in code review.

---

## Migration Checklist (Vanilla JS → React + TypeScript)

### Phase 1: Project Initial Setup
- [ ] Create Vite + React + TypeScript project
  ```bash
  npm create vite@latest website -- --template react-ts
  cd website
  npm install
  ```
- [ ] Configure Path Alias (tsconfig.json + vite.config.ts)
- [ ] Configure ESLint + Prettier
- [ ] Verify CSS Module configuration

### Phase 2: Create Basic Folder Structure
- [ ] Create `src/core/` folder
  - [ ] `core/services/` - Supabase, Cache
  - [ ] `core/utils/` - Common utilities
  - [ ] `core/types/` - Global type definitions
- [ ] Create `src/shared/` folder
  - [ ] `shared/components/common/` - Common components
  - [ ] `shared/components/toss/` - Toss design system
  - [ ] `shared/hooks/` - Global hooks (useAuth) + UI-only hooks (useDebounce)
  - [ ] `shared/themes/` - CSS variables, themes
- [ ] Create `src/features/` folder
- [ ] Create `src/routes/` folder - React Router setup

### Phase 3: Core & Shared Migration
- [ ] Convert Supabase Service (JS → TS)
  - [ ] Create `core/services/supabase.service.ts`
  - [ ] Define TypeScript types
- [ ] Convert Toss Design System
  - [ ] Move `shared/themes/` CSS variables
  - [ ] Convert `shared/components/toss/TossButton/` (Vanilla → React)
  - [ ] Convert `shared/components/toss/TossModal/`
  - [ ] Convert other Toss components

### Phase 4: Create Feature Modules (Priority Order)
- [ ] **1. `features/auth/`** (Authentication - Top Priority)
  - [ ] domain/entities/User.ts
  - [ ] data/repositories/AuthRepositoryImpl.ts
  - [ ] presentation/pages/LoginPage/
  - [ ] presentation/hooks/useAuth.ts
- [ ] **2. `features/dashboard/`** (Dashboard)
  - [ ] Create Clean Architecture 3-layer structure
- [ ] **3. `features/inventory/`** (Inventory Management - Most Complex)
  - [ ] domain/ (Product entity, validation rules definition)
  - [ ] data/ (Repository, DataSource, DTO)
  - [ ] presentation/ (InventoryPage, components, hooks - validation execution + Repository calls)
- [ ] **4. Other Features**
  - [ ] features/finance/
  - [ ] features/employee/
  - [ ] features/settings/

### Phase 5: Routing Setup
- [ ] Install React Router v6
  ```bash
  npm install react-router-dom
  ```
- [ ] Configure `src/routes/index.tsx` router
- [ ] Implement Protected Routes (pages requiring authentication)
- [ ] Implement Layout component

### Phase 6: Convert Existing HTML Pages (270KB → React Components)
- [ ] Analyze `backup/pages/product/inventory/index.html` (270KB)
- [ ] Separate into React components:
  - [ ] InventoryPage.tsx (≤15KB)
  - [ ] InventoryTable component (≤15KB)
  - [ ] useInventory custom hook (≤10KB)
  - [ ] CSS Module file (≤20KB)
- [ ] Convert other pages similarly

### Phase 7: Strengthen Type Safety
- [ ] Generate Supabase Database types
  ```bash
  npx supabase gen types typescript --project-id [project-id] > src/core/types/supabase.types.ts
  ```
- [ ] Define all component Props types
- [ ] Define Repository interface types
- [ ] Minimize `any` type usage (goal: 0)

### Phase 8: Validation & Optimization
- [ ] Resolve TypeScript compilation errors
  ```bash
  npm run type-check
  ```
- [ ] Pass ESLint checks
  ```bash
  npm run lint
  ```
- [ ] Check file sizes (TSX ≤15KB, TS ≤30KB, CSS ≤20KB)
- [ ] Optimize bundle size (initial load ≤500KB)
- [ ] Pass code review checklist

### Phase 9: Testing
- [ ] Configure Vitest
- [ ] Write unit tests for main components
- [ ] Write tests for Repository layer
- [ ] Configure E2E tests (Playwright)

### Phase 10: Deployment Preparation
- [ ] Test production build
  ```bash
  npm run build
  npm run preview
  ```
- [ ] Configure environment variables (.env)
- [ ] Verify standalone execution without Apache XAMPP
- [ ] Configure Vercel/Netlify deployment (optional)

---

**Last Updated**: 2025-11-05
**Version**: 2.0 (React + TypeScript Update)
**Status**: ✅ Ready for React Migration
