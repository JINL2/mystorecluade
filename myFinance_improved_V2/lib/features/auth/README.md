# Auth Feature - Clean Architecture

This feature handles all authentication and onboarding flows including login, signup, company creation, store creation, and joining existing businesses.

## 📁 Architecture Overview

```
auth/
├── domain/              # 🎯 Business Logic Layer (Pure Dart)
│   ├── entities/       # Core business objects
│   ├── repositories/   # Repository interfaces (contracts)
│   ├── usecases/       # Business use cases
│   ├── validators/     # Domain validation logic
│   ├── value_objects/  # Immutable command objects
│   └── exceptions/     # Domain-specific exceptions
│
├── data/               # 💾 Data Access Layer
│   ├── datasources/    # External data sources (Supabase) - 4 files
│   ├── models/         # JSON serializable models - 5 files
│   └── repositories/   # Repository implementations - 5 files
│
└── presentation/       # 🎨 UI Layer (Flutter)
    ├── pages/          # Screen widgets
    ├── providers/      # Riverpod state management
    ├── routes/         # GoRouter route definitions
    └── widgets/        # Reusable UI components (if any)
```

## 🏗️ Clean Architecture Layers

### 1️⃣ Domain Layer (Business Logic)

**Purpose**: Contains all business rules and logic independent of frameworks

#### Entities (3 files)
Core business objects with rich behavior:
- `company_entity.dart` - Company domain model with business logic
- `store_entity.dart` - Store domain model with operational settings
- `user_entity.dart` - User domain model

#### Repositories (4 interfaces)
Contracts that define data operations:
- `auth_repository.dart` - Authentication operations
- `company_repository.dart` - Company CRUD + join operations
- `store_repository.dart` - Store CRUD operations
- `user_repository.dart` - User profile operations

#### UseCases (6 files)
Single-purpose business operations:
- `login_usecase.dart` - Login with email/password
- `signup_usecase.dart` - Create new user account
- `logout_usecase.dart` - Sign out user
- `create_company_usecase.dart` - Create new company
- `create_store_usecase.dart` - Create new store
- `join_company_usecase.dart` - Join existing company by code

#### Validators (3 files)
Domain validation rules:
- `email_validator.dart` - Email format validation
- `password_validator.dart` - Password strength validation (6+ chars)
- `name_validator.dart` - Name field validation

#### Value Objects (6 files)
Immutable command/query objects:
- `login_command.dart` - Login input data
- `signup_command.dart` - Signup input data
- `create_company_command.dart` - Company creation input
- `create_store_command.dart` - Store creation input
- `company_type.dart` - Company type value object
- `currency.dart` - Currency value object

#### Exceptions (2 files)
- `auth_exceptions.dart` - All auth-related exceptions (20+ types)
- `validation_exception.dart` - Validation error wrapper

---

### 2️⃣ Data Layer (External Communication)

**Purpose**: Handles all external data sources and persistence

#### DataSources (4 files)
Direct Supabase API communication:
- `supabase_auth_datasource.dart` - Auth API calls (signIn, signUp, signOut)
- `supabase_user_datasource.dart` - User profile and permissions queries
- `supabase_company_datasource.dart` - Company API calls + RPC
- `supabase_store_datasource.dart` - Store API calls

**Pattern**:
```dart
abstract class CompanyDataSource {
  Future<CompanyModel> createCompany(Map<String, dynamic> data);
  Future<CompanyModel> joinCompanyByCode({required String companyCode, required String userId});
}

class SupabaseCompanyDataSource implements CompanyDataSource {
  // Actual Supabase implementation
}
```

#### Models (5 files)
JSON-serializable data transfer objects:
- `user_model.dart` - Maps to/from users table
- `company_model.dart` - Maps to/from companies table
- `store_model.dart` - Maps to/from stores table
- `company_type_model.dart` - Maps company_types table
- `currency_model.dart` - Maps currency_types table

**Pattern**:
```dart
class CompanyModel {
  final String companyId;
  final String companyName;

  factory CompanyModel.fromJson(Map<String, dynamic> json) { }
  Map<String, dynamic> toJson() { }
  Company toEntity() { } // Convert to domain entity
  factory CompanyModel.fromEntity(Company entity) { }
}
```

#### Repository Implementations (5 files)
Implement domain repository interfaces:
- `base_repository.dart` - Common error handling wrapper
- `auth_repository_impl.dart` - Auth repository implementation
- `user_repository_impl.dart` - User repository implementation
- `company_repository_impl.dart` - Company repository implementation
- `store_repository_impl.dart` - Store repository implementation

**Pattern**:
```dart
class CompanyRepositoryImpl extends BaseRepository implements CompanyRepository {
  final CompanyDataSource _dataSource;

  @override
  Future<Company> create(Company company) {
    return execute(() async {
      final model = CompanyModel.fromEntity(company);
      final created = await _dataSource.createCompany(model.toInsertMap());
      return created.toEntity();
    });
  }
}
```

---

### 3️⃣ Presentation Layer (UI)

**Purpose**: Handles all user interface and state management

#### Pages (6 files)
Full-screen UI components:
- `login_page.dart` - Email/password login
- `signup_page.dart` - Create account with validation
- `choose_role_page.dart` - Create business or join business
- `create_business_page.dart` - Company creation form
- `create_store_page.dart` - Store creation form
- `join_business_page.dart` - Join by company code

#### Providers (7 files)
Riverpod dependency injection:
- `repository_providers.dart` - Repository instances
- `usecase_providers.dart` - UseCase instances
- `auth_service.dart` - Auth operations service
- `company_service.dart` - Company operations service
- `store_service.dart` - Store operations service
- `auth_state_provider.dart` - Reactive auth state
- `session_manager_provider.dart` - Session tracking

#### Routes (1 file)
- `auth_routes.dart` - All auth/onboarding routes

---

## 🔄 Data Flow

### Example: Create Company Flow

```
1. USER ACTION
   CreateBusinessPage
   └─> User fills form and presses "Create Business"

2. PRESENTATION LAYER
   └─> calls CompanyService.createCompany()
       └─> gets CreateCompanyUseCase from provider
           └─> executes usecase with CreateCompanyCommand

3. DOMAIN LAYER
   └─> CreateCompanyUseCase.execute()
       ├─> Validates input (name, type, currency)
       ├─> Checks if name exists
       └─> Calls CompanyRepository.create()

4. DATA LAYER
   └─> CompanyRepositoryImpl.create()
       ├─> Converts Company entity → CompanyModel
       ├─> Calls CompanyDataSource.createCompany()
       └─> Converts CompanyModel → Company entity

5. EXTERNAL
   └─> SupabaseCompanyDataSource.createCompany()
       ├─> Inserts into companies table
       ├─> Inserts into user_companies table
       └─> Returns created company data

6. RESPONSE FLOWS BACK
   Company Entity → UseCase → Service → Page
   └─> UI updates with success dialog
```

## 📊 Dependency Directions

```
Presentation ──depends on──> Domain <──implements── Data
                              ↑
                              │ (interfaces only)
                              │
                         No dependencies
                         (pure business logic)
```

**Key Rules**:
- ✅ Domain has NO dependencies (pure Dart)
- ✅ Data implements Domain interfaces
- ✅ Presentation depends on Domain (uses repositories/usecases)
- ❌ Domain never depends on Data or Presentation
- ❌ Data never depends on Presentation

## 🎯 Design Patterns Used

### 1. Repository Pattern
Abstracts data access behind interfaces:
```dart
// Domain defines the contract
abstract class CompanyRepository {
  Future<Company> create(Company company);
}

// Data implements the contract
class CompanyRepositoryImpl implements CompanyRepository {
  // Implementation using DataSource
}
```

### 2. UseCase Pattern (Single Responsibility)
Each use case does ONE thing:
```dart
class CreateCompanyUseCase {
  Future<Company> execute(CreateCompanyCommand command) async {
    // 1. Validate
    // 2. Check business rules
    // 3. Call repository
    // 4. Return result
  }
}
```

### 3. Command Pattern
Immutable input objects:
```dart
class CreateCompanyCommand {
  final String name;
  final String typeId;
  final String currencyId;

  const CreateCompanyCommand({required this.name, ...});
}
```

### 4. DataSource Pattern
Separate data access from business logic:
```dart
// DataSource = direct API communication
class SupabaseCompanyDataSource {
  Future<CompanyModel> createCompany(Map<String, dynamic> data) {
    return _client.from('companies').insert(data).single();
  }
}
```

### 5. Dependency Injection (Riverpod)
Inject dependencies via providers:
```dart
final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final dataSource = ref.watch(companyDataSourceProvider);
  return CompanyRepositoryImpl(dataSource);
});
```

## 🚀 Key Features

### Authentication
- ✅ Email/password login
- ✅ User registration with validation
- ✅ Password strength checking (6+ chars, no common passwords)
- ✅ Email format validation
- ✅ Session management
- ✅ Logout with cleanup

### Company Management
- ✅ Create new company
- ✅ Join existing company by code
- ✅ Company name uniqueness check
- ✅ Company types (Retail, Wholesale, etc.)
- ✅ Multi-currency support

### Store Management
- ✅ Create store within company
- ✅ Store code uniqueness check
- ✅ Operational settings (huddle time, payment days, distance)
- ✅ Address management

### Onboarding Flow
```
Signup → Choose Role → [Create Business OR Join Business] → Create Store → Dashboard
```

## 🛡️ Error Handling

### Exception-Based (No Result Pattern)
```dart
try {
  final company = await createCompanyUseCase.execute(command);
  // Handle success
} on ValidationException catch (e) {
  // Handle validation error
} on CompanyNameExistsException catch (e) {
  // Handle duplicate name
} on NetworkException catch (e) {
  // Handle network error
}
```

### Exception Hierarchy
```
AuthException (base)
├── ValidationException
├── EmailAlreadyExistsException
├── InvalidCredentialsException
├── CompanyNameExistsException
├── AlreadyMemberException
├── InvalidCompanyCodeException
└── NetworkException
... (20+ exception types)
```

## 📝 Naming Conventions

### Files
- Entities: `*_entity.dart` (e.g., `company_entity.dart`)
- Repositories: `*_repository.dart` (interface), `*_repository_impl.dart` (implementation)
- UseCases: `*_usecase.dart` (e.g., `create_company_usecase.dart`)
- Models: `*_model.dart` (e.g., `company_model.dart`)
- DataSources: `supabase_*_datasource.dart`
- Pages: `*_page.dart` (e.g., `login_page.dart`)

### Classes
- Entities: Noun (e.g., `Company`, `Store`)
- Repositories: `*Repository` (interface), `*RepositoryImpl` (implementation)
- UseCases: `*UseCase` (e.g., `CreateCompanyUseCase`)
- Models: `*Model` (e.g., `CompanyModel`)
- DataSources: `Supabase*DataSource`

## 🔧 Testing Strategy

### Unit Tests (Domain)
Test business logic in isolation:
```dart
test('CreateCompanyUseCase validates company name', () async {
  // Given
  final command = CreateCompanyCommand(name: '', ...);

  // When/Then
  expect(
    () => useCase.execute(command),
    throwsA(isA<ValidationException>()),
  );
});
```

### Integration Tests (Data)
Test repository implementations with mocked DataSource:
```dart
test('CompanyRepositoryImpl creates company via DataSource', () async {
  // Given
  when(mockDataSource.createCompany(any)).thenAnswer((_) => ...);

  // When
  final result = await repository.create(company);

  // Then
  verify(mockDataSource.createCompany(any)).called(1);
  expect(result.name, equals('Test Company'));
});
```

### Widget Tests (Presentation)
Test UI behavior:
```dart
testWidgets('LoginPage shows error on invalid credentials', (tester) async {
  // Build widget
  await tester.pumpWidget(LoginPage());

  // Interact
  await tester.enterText(emailField, 'test@example.com');
  await tester.tap(loginButton);
  await tester.pump();

  // Assert
  expect(find.text('Invalid credentials'), findsOneWidget);
});
```

## 📦 Dependencies

### Domain Layer
- ✅ **NO external dependencies** (pure Dart only)

### Data Layer
- `supabase_flutter` - Database client

### Presentation Layer
- `flutter` - UI framework
- `flutter_riverpod` - State management
- `go_router` - Navigation

## ✨ Recent Improvements (2025-10-16)

### Architecture Unification ✅
**What Changed**: Migrated Auth/User modules from Legacy pattern to Clean Architecture

**Before (Legacy Pattern)**:
```
UI → Service → UseCase → Repository (직접 Supabase 호출)
  → UserDto (3파일) + UserMapper → User Entity
```

**After (Clean Architecture)**:
```
UI → Service → UseCase → RepositoryImpl → DataSource
  → UserModel (1파일) → User Entity
```

### Files Changed:
**Created (5 new files):**
- ✅ `data/models/user_model.dart` - User data model
- ✅ `data/datasources/supabase_auth_datasource.dart` - Auth API communication
- ✅ `data/datasources/supabase_user_datasource.dart` - User data queries
- ✅ `data/repositories/auth_repository_impl.dart` - Auth repository implementation
- ✅ `data/repositories/user_repository_impl.dart` - User repository implementation

**Removed (15 legacy files):**
- ❌ `data/dtos/` folder (9 files: UserDto, CompanyDto, StoreDto + generated files)
- ❌ `data/mappers/` folder (3 files: UserMapper, CompanyMapper, StoreMapper)
- ❌ `data/exceptions/data_exceptions.dart`
- ❌ `data/repositories/supabase_auth_repository.dart`
- ❌ `data/repositories/supabase_user_repository.dart`

**Updated (2 files):**
- ✏️ `presentation/providers/repository_providers.dart` - Updated to use new DataSources
- ✏️ `data/repositories/base_repository.dart` - Simplified (removed data_exceptions dependency)

### Impact:
- 📉 **File count**: 63 → 53 files (-16%)
- 🎯 **Consistency**: 100% Clean Architecture (was 70%)
- 🧹 **Complexity**: Removed Freezed dependency for DTOs
- 🚀 **Maintainability**: All features now follow same pattern
- ✅ **Testability**: DataSource layer makes mocking easier

## 🔮 Future Improvements

### High Priority
1. ✅ ~~Remove legacy DTOs and Mappers~~ **COMPLETED**
2. Add comprehensive unit tests for UseCases
3. Add integration tests for Repositories
4. Implement password reset flow
5. Add email verification

### Medium Priority
1. Add biometric authentication
2. Implement remember me functionality
3. Add social login (Google, Apple)
4. Improve password validator (check against leaked passwords API)

### Low Priority
1. Add multi-language support
2. Add dark mode support for auth pages
3. Add custom company logo upload
4. Implement company settings page

## 📚 Related Documentation

- Main App Architecture: `/lib/README.md`
- Shared Widgets: `/lib/shared/README.md`
- Navigation: `/lib/core/navigation/README.md`
- Themes: `/lib/shared/themes/README.md`

## 🤝 Contributing

When adding new features:

1. **Start with Domain**: Define entities, repository interface, and use case
2. **Implement Data**: Create DataSource and Repository implementation
3. **Build Presentation**: Create page and wire up providers
4. **Add Tests**: Write unit tests for use cases
5. **Update Routes**: Add route to `auth_routes.dart`

## 📞 Support

For questions or issues related to the auth feature:
- Check existing code examples in this folder
- Review Clean Architecture principles
- Consult the team's architecture documentation
