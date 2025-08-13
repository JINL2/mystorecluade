# Company and Store Management System Design

## Executive Summary

This document outlines a comprehensive design for the company and store management system in myFinance. The design follows Clean Architecture principles with a focus on scalability, maintainability, and performance.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │   Widgets   │  │    Pages     │  │  State Notifiers │  │
│  └─────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                         │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │  Use Cases  │  │   Services   │  │      DTOs        │  │
│  └─────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │  Entities   │  │ Value Objects│  │  Repositories    │  │
│  └─────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                   Infrastructure Layer                       │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │  Supabase   │  │    Cache     │  │   Mappers        │  │
│  └─────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Domain Model Design

### Value Objects

```dart
// lib/domain/value_objects/company_id.dart
class CompanyId {
  final String value;
  
  CompanyId(this.value) {
    if (value.isEmpty) {
      throw ValidationException('Company ID cannot be empty');
    }
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyId && value == other.value;
      
  @override
  int get hashCode => value.hashCode;
}

// lib/domain/value_objects/store_id.dart
class StoreId {
  final String value;
  
  StoreId(this.value) {
    if (value.isEmpty) {
      throw ValidationException('Store ID cannot be empty');
    }
  }
}

// lib/domain/value_objects/company_code.dart
class CompanyCode {
  final String value;
  
  CompanyCode(this.value) {
    if (!_isValidCode(value)) {
      throw ValidationException('Invalid company code format');
    }
  }
  
  static bool _isValidCode(String code) {
    return RegExp(r'^[A-Z0-9]{6,12}$').hasMatch(code);
  }
}
```

### Enhanced Entities

```dart
// lib/domain/entities/company_entity.dart
class CompanyEntity {
  final CompanyId id;
  final CompanyName name;
  final CompanyCode code;
  final UserRole role;
  final List<StoreEntity> stores;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  CompanyEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.role,
    required this.stores,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // Business Logic Methods
  bool canCreateStore() {
    return role.hasPermission(Permission.createStore);
  }
  
  bool canViewCode() {
    return role.hasPermission(Permission.viewCompanyCode);
  }
  
  bool canManageUsers() {
    return role.hasPermission(Permission.manageUsers);
  }
  
  StoreEntity? getStoreById(StoreId id) {
    return stores.firstWhereOrNull((store) => store.id == id);
  }
  
  List<StoreEntity> getActiveStores() {
    return stores.where((store) => store.isActive).toList();
  }
  
  // Domain Events
  CompanyUpdatedEvent updateName(CompanyName newName) {
    return CompanyUpdatedEvent(
      companyId: id,
      changes: {'name': newName},
      timestamp: DateTime.now(),
    );
  }
}

// lib/domain/entities/store_entity.dart
class StoreEntity {
  final StoreId id;
  final StoreName name;
  final StoreCode code;
  final CompanyId companyId;
  final bool isActive;
  final StoreSettings settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  StoreEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.companyId,
    required this.isActive,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // Business Logic
  bool canProcessTransactions() {
    return isActive && settings.transactionsEnabled;
  }
  
  bool isOpenNow() {
    final now = DateTime.now();
    return settings.businessHours.isOpenAt(now);
  }
  
  // Domain Events
  StoreDeactivatedEvent deactivate() {
    return StoreDeactivatedEvent(
      storeId: id,
      companyId: companyId,
      timestamp: DateTime.now(),
    );
  }
}
```

### Repository Interfaces

```dart
// lib/domain/repositories/i_company_repository.dart
abstract class ICompanyRepository {
  Future<Either<Failure, List<CompanyEntity>>> getUserCompanies(UserId userId);
  Future<Either<Failure, CompanyEntity>> getCompanyById(CompanyId id);
  Future<Either<Failure, CompanyEntity>> createCompany(CreateCompanyCommand command);
  Future<Either<Failure, Unit>> updateCompany(UpdateCompanyCommand command);
  Future<Either<Failure, Unit>> deleteCompany(CompanyId id);
  Stream<CompanyEntity> watchCompany(CompanyId id);
}

// lib/domain/repositories/i_store_repository.dart
abstract class IStoreRepository {
  Future<Either<Failure, List<StoreEntity>>> getCompanyStores(CompanyId companyId);
  Future<Either<Failure, StoreEntity>> getStoreById(StoreId id);
  Future<Either<Failure, StoreEntity>> createStore(CreateStoreCommand command);
  Future<Either<Failure, Unit>> updateStore(UpdateStoreCommand command);
  Future<Either<Failure, Unit>> deleteStore(StoreId id);
  Stream<List<StoreEntity>> watchCompanyStores(CompanyId companyId);
}
```

## Application Layer Design

### Use Cases

```dart
// lib/application/use_cases/company/get_user_companies_use_case.dart
class GetUserCompaniesUseCase {
  final ICompanyRepository _repository;
  final IAnalyticsService _analytics;
  
  GetUserCompaniesUseCase(this._repository, this._analytics);
  
  Future<Either<Failure, List<CompanyEntity>>> execute(UserId userId) async {
    _analytics.trackEvent('get_user_companies', {'user_id': userId.value});
    
    final result = await _repository.getUserCompanies(userId);
    
    return result.fold(
      (failure) {
        _analytics.trackError('get_user_companies_failed', failure);
        return left(failure);
      },
      (companies) {
        // Sort companies by most recently accessed
        final sorted = companies.sortedBy((c) => c.updatedAt).reversed.toList();
        return right(sorted);
      },
    );
  }
}

// lib/application/use_cases/company/create_company_use_case.dart
class CreateCompanyUseCase {
  final ICompanyRepository _companyRepository;
  final ICodeGeneratorService _codeGenerator;
  final IEventBus _eventBus;
  final IValidator<CreateCompanyCommand> _validator;
  
  CreateCompanyUseCase(
    this._companyRepository,
    this._codeGenerator,
    this._eventBus,
    this._validator,
  );
  
  Future<Either<Failure, CompanyEntity>> execute(CreateCompanyCommand command) async {
    // Validate command
    final validation = _validator.validate(command);
    if (validation.isLeft()) {
      return left(validation.getLeft());
    }
    
    // Generate unique company code
    final code = await _codeGenerator.generateCompanyCode();
    final enrichedCommand = command.copyWith(code: code);
    
    // Create company
    final result = await _companyRepository.createCompany(enrichedCommand);
    
    return result.fold(
      (failure) => left(failure),
      (company) {
        // Publish domain event
        _eventBus.publish(CompanyCreatedEvent(
          company: company,
          createdBy: command.userId,
          timestamp: DateTime.now(),
        ));
        return right(company);
      },
    );
  }
}

// lib/application/use_cases/store/create_store_use_case.dart
class CreateStoreUseCase {
  final IStoreRepository _storeRepository;
  final ICompanyRepository _companyRepository;
  final ICodeGeneratorService _codeGenerator;
  final IEventBus _eventBus;
  
  CreateStoreUseCase(
    this._storeRepository,
    this._companyRepository,
    this._codeGenerator,
    this._eventBus,
  );
  
  Future<Either<Failure, StoreEntity>> execute(CreateStoreCommand command) async {
    // Verify user has permission to create store
    final companyResult = await _companyRepository.getCompanyById(command.companyId);
    
    return companyResult.fold(
      (failure) => left(failure),
      (company) async {
        if (!company.canCreateStore()) {
          return left(const PermissionFailure('Cannot create store'));
        }
        
        // Generate unique store code
        final code = await _codeGenerator.generateStoreCode(company.code);
        final enrichedCommand = command.copyWith(code: code);
        
        // Create store
        final result = await _storeRepository.createStore(enrichedCommand);
        
        return result.fold(
          (failure) => left(failure),
          (store) {
            _eventBus.publish(StoreCreatedEvent(
              store: store,
              companyId: company.id,
              createdBy: command.userId,
              timestamp: DateTime.now(),
            ));
            return right(store);
          },
        );
      },
    );
  }
}
```

### Application Services

```dart
// lib/application/services/company_selection_service.dart
class CompanySelectionService {
  final IAppStateService _appState;
  final IEventBus _eventBus;
  
  CompanySelectionService(this._appState, this._eventBus);
  
  Future<void> selectCompany(CompanyId companyId) async {
    await _appState.setSelectedCompany(companyId);
    
    _eventBus.publish(CompanySelectedEvent(
      companyId: companyId,
      timestamp: DateTime.now(),
    ));
  }
  
  Future<void> selectStore(StoreId storeId) async {
    await _appState.setSelectedStore(storeId);
    
    _eventBus.publish(StoreSelectedEvent(
      storeId: storeId,
      timestamp: DateTime.now(),
    ));
  }
  
  CompanyId? getCurrentCompanyId() {
    return _appState.getSelectedCompanyId();
  }
  
  StoreId? getCurrentStoreId() {
    return _appState.getSelectedStoreId();
  }
}
```

## State Management Design

### Riverpod Providers

```dart
// lib/presentation/providers/company_providers.dart

// Core Company State
final companyStateProvider = StateNotifierProvider<CompanyStateNotifier, CompanyState>((ref) {
  return CompanyStateNotifier(
    getUserCompaniesUseCase: ref.watch(getUserCompaniesUseCaseProvider),
    selectionService: ref.watch(companySelectionServiceProvider),
  );
});

// Derived Providers
final selectedCompanyProvider = Provider<CompanyEntity?>((ref) {
  final state = ref.watch(companyStateProvider);
  final selectedId = ref.watch(selectedCompanyIdProvider);
  
  if (selectedId == null) return null;
  
  return state.companies.firstWhereOrNull((c) => c.id == selectedId);
});

final selectedStoreProvider = Provider<StoreEntity?>((ref) {
  final company = ref.watch(selectedCompanyProvider);
  final selectedId = ref.watch(selectedStoreIdProvider);
  
  if (company == null || selectedId == null) return null;
  
  return company.getStoreById(selectedId);
});

// Async Operations
final createCompanyProvider = FutureProvider.family<CompanyEntity, CreateCompanyCommand>((ref, command) async {
  final useCase = ref.watch(createCompanyUseCaseProvider);
  final result = await useCase.execute(command);
  
  return result.fold(
    (failure) => throw failure,
    (company) => company,
  );
});

// Real-time Subscriptions
final companyStreamProvider = StreamProvider.family<CompanyEntity, CompanyId>((ref, companyId) {
  final repository = ref.watch(companyRepositoryProvider);
  return repository.watchCompany(companyId);
});
```

### State Notifier

```dart
// lib/presentation/providers/company_state_notifier.dart
class CompanyStateNotifier extends StateNotifier<CompanyState> {
  final GetUserCompaniesUseCase _getUserCompaniesUseCase;
  final CompanySelectionService _selectionService;
  
  CompanyStateNotifier({
    required GetUserCompaniesUseCase getUserCompaniesUseCase,
    required CompanySelectionService selectionService,
  }) : _getUserCompaniesUseCase = getUserCompaniesUseCase,
       _selectionService = selectionService,
       super(const CompanyState.initial());
  
  Future<void> loadUserCompanies(UserId userId) async {
    state = const CompanyState.loading();
    
    final result = await _getUserCompaniesUseCase.execute(userId);
    
    state = result.fold(
      (failure) => CompanyState.error(failure),
      (companies) => CompanyState.loaded(companies),
    );
  }
  
  Future<void> selectCompany(CompanyId companyId) async {
    await _selectionService.selectCompany(companyId);
    
    if (state is CompanyStateLoaded) {
      state = (state as CompanyStateLoaded).copyWith(
        selectedCompanyId: companyId,
      );
    }
  }
  
  Future<void> selectStore(StoreId storeId) async {
    await _selectionService.selectStore(storeId);
    
    if (state is CompanyStateLoaded) {
      state = (state as CompanyStateLoaded).copyWith(
        selectedStoreId: storeId,
      );
    }
  }
}

// lib/presentation/providers/company_state.dart
@freezed
class CompanyState with _$CompanyState {
  const factory CompanyState.initial() = CompanyStateInitial;
  const factory CompanyState.loading() = CompanyStateLoading;
  const factory CompanyState.loaded(
    List<CompanyEntity> companies, {
    CompanyId? selectedCompanyId,
    StoreId? selectedStoreId,
  }) = CompanyStateLoaded;
  const factory CompanyState.error(Failure failure) = CompanyStateError;
}
```

## UI Component Design

### Company Selector Widget

```dart
// lib/presentation/widgets/company_selector.dart
class CompanySelector extends ConsumerWidget {
  const CompanySelector({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(companyStateProvider);
    
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const TossLoadingIndicator(),
      error: (failure) => TossErrorWidget(
        message: failure.message,
        onRetry: () => ref.refresh(companyStateProvider),
      ),
      loaded: (companies, selectedId, _) => TossDropdown<CompanyEntity>(
        value: companies.firstWhereOrNull((c) => c.id == selectedId),
        items: companies,
        itemBuilder: (company) => TossDropdownItem(
          leading: const Icon(Icons.business),
          title: company.name.value,
          subtitle: company.role.name,
          trailing: company.canViewCode() 
            ? TossChip(label: company.code.value)
            : null,
        ),
        onChanged: (company) {
          if (company != null) {
            ref.read(companyStateProvider.notifier).selectCompany(company.id);
          }
        },
        hint: 'Select Company',
      ),
    );
  }
}
```

### Store Management Screen

```dart
// lib/presentation/pages/store_management/store_management_page.dart
class StoreManagementPage extends ConsumerWidget {
  const StoreManagementPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCompany = ref.watch(selectedCompanyProvider);
    
    if (selectedCompany == null) {
      return const NoCompanySelectedWidget();
    }
    
    return TossScaffold(
      appBar: TossAppBar(
        title: 'Store Management',
        subtitle: selectedCompany.name.value,
      ),
      body: Column(
        children: [
          if (selectedCompany.canCreateStore())
            _buildCreateStoreButton(context, ref, selectedCompany),
          Expanded(
            child: _buildStoreList(context, ref, selectedCompany),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCreateStoreButton(
    BuildContext context, 
    WidgetRef ref, 
    CompanyEntity company,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TossPrimaryButton(
        label: 'Create New Store',
        icon: Icons.add,
        onPressed: () => _showCreateStoreDialog(context, ref, company),
      ),
    );
  }
  
  Widget _buildStoreList(
    BuildContext context,
    WidgetRef ref,
    CompanyEntity company,
  ) {
    final stores = company.stores;
    
    if (stores.isEmpty) {
      return const EmptyStoresWidget();
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: stores.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final store = stores[index];
        return StoreCard(
          store: store,
          isSelected: ref.watch(selectedStoreIdProvider) == store.id,
          onTap: () => ref.read(companyStateProvider.notifier).selectStore(store.id),
          onEdit: company.canManageStores() 
            ? () => _showEditStoreDialog(context, ref, store)
            : null,
        );
      },
    );
  }
}
```

## Performance Optimizations

### Caching Strategy

```dart
// lib/infrastructure/cache/company_cache_manager.dart
class CompanyCacheManager {
  final ICacheService _cache;
  final Duration _ttl;
  
  CompanyCacheManager({
    required ICacheService cache,
    Duration ttl = const Duration(minutes: 5),
  }) : _cache = cache,
       _ttl = ttl;
  
  Future<List<CompanyEntity>?> getCachedCompanies(UserId userId) async {
    final key = 'companies:${userId.value}';
    final cached = await _cache.get<List<Map<String, dynamic>>>(key);
    
    if (cached == null) return null;
    
    return cached.map((json) => CompanyMapper.fromJson(json)).toList();
  }
  
  Future<void> cacheCompanies(UserId userId, List<CompanyEntity> companies) async {
    final key = 'companies:${userId.value}';
    final json = companies.map((c) => CompanyMapper.toJson(c)).toList();
    
    await _cache.set(key, json, ttl: _ttl);
  }
  
  Future<void> invalidateCompanies(UserId userId) async {
    final key = 'companies:${userId.value}';
    await _cache.delete(key);
  }
  
  Future<void> invalidateAll() async {
    await _cache.clear(pattern: 'companies:*');
  }
}
```

### Optimistic Updates

```dart
// lib/presentation/providers/optimistic_update_provider.dart
class OptimisticUpdateNotifier extends StateNotifier<CompanyState> {
  OptimisticUpdateNotifier(CompanyState initial) : super(initial);
  
  Future<void> createStoreOptimistic(CreateStoreCommand command) async {
    // Create optimistic store
    final optimisticStore = StoreEntity(
      id: StoreId.temporary(),
      name: StoreName(command.name),
      code: StoreCode.pending(),
      companyId: command.companyId,
      isActive: true,
      settings: StoreSettings.default(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Update state optimistically
    if (state is CompanyStateLoaded) {
      final currentState = state as CompanyStateLoaded;
      final companies = currentState.companies.map((company) {
        if (company.id == command.companyId) {
          return company.copyWith(
            stores: [...company.stores, optimisticStore],
          );
        }
        return company;
      }).toList();
      
      state = currentState.copyWith(companies: companies);
    }
    
    try {
      // Execute actual creation
      final result = await _createStoreUseCase.execute(command);
      
      result.fold(
        (failure) => _revertOptimisticUpdate(optimisticStore.id),
        (store) => _replaceOptimisticStore(optimisticStore.id, store),
      );
    } catch (e) {
      _revertOptimisticUpdate(optimisticStore.id);
      rethrow;
    }
  }
}
```

## Database Schema

```sql
-- Companies table
CREATE TABLE companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  code VARCHAR(12) UNIQUE NOT NULL,
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Stores table
CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(12) UNIQUE NOT NULL,
  is_active BOOLEAN DEFAULT true,
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  INDEX idx_stores_company_id (company_id),
  UNIQUE KEY unique_store_per_company (company_id, name)
);

-- User companies relationship
CREATE TABLE user_companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  role_id UUID NOT NULL REFERENCES roles(id),
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE KEY unique_user_company (user_id, company_id),
  INDEX idx_user_companies_user_id (user_id)
);

-- Roles table
CREATE TABLE roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(50) NOT NULL,
  permissions JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Audit log
CREATE TABLE company_audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  action VARCHAR(50) NOT NULL,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  INDEX idx_audit_company_id (company_id),
  INDEX idx_audit_created_at (created_at)
);
```

## API Design

### REST Endpoints

```yaml
# Company endpoints
GET    /api/companies              # Get user's companies
POST   /api/companies              # Create new company
GET    /api/companies/:id          # Get company details
PUT    /api/companies/:id          # Update company
DELETE /api/companies/:id          # Delete company

# Store endpoints  
GET    /api/companies/:id/stores   # Get company stores
POST   /api/companies/:id/stores   # Create new store
GET    /api/stores/:id             # Get store details
PUT    /api/stores/:id             # Update store
DELETE /api/stores/:id             # Delete store

# User management
GET    /api/companies/:id/users    # Get company users
POST   /api/companies/:id/users    # Invite user to company
PUT    /api/companies/:id/users/:userId # Update user role
DELETE /api/companies/:id/users/:userId # Remove user from company
```

### GraphQL Schema

```graphql
type Company {
  id: ID!
  name: String!
  code: String!
  role: UserRole!
  stores: [Store!]!
  users: [CompanyUser!]!
  settings: CompanySettings!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type Store {
  id: ID!
  name: String!
  code: String!
  company: Company!
  isActive: Boolean!
  settings: StoreSettings!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type Query {
  companies: [Company!]!
  company(id: ID!): Company
  store(id: ID!): Store
}

type Mutation {
  createCompany(input: CreateCompanyInput!): Company!
  updateCompany(id: ID!, input: UpdateCompanyInput!): Company!
  deleteCompany(id: ID!): Boolean!
  
  createStore(companyId: ID!, input: CreateStoreInput!): Store!
  updateStore(id: ID!, input: UpdateStoreInput!): Store!
  deleteStore(id: ID!): Boolean!
}

type Subscription {
  companyUpdated(id: ID!): Company!
  storeUpdated(companyId: ID!): Store!
}
```

## Testing Strategy

### Unit Tests

```dart
// test/domain/use_cases/create_company_use_case_test.dart
void main() {
  group('CreateCompanyUseCase', () {
    late CreateCompanyUseCase useCase;
    late MockCompanyRepository mockRepository;
    late MockCodeGeneratorService mockCodeGenerator;
    late MockEventBus mockEventBus;
    
    setUp(() {
      mockRepository = MockCompanyRepository();
      mockCodeGenerator = MockCodeGeneratorService();
      mockEventBus = MockEventBus();
      
      useCase = CreateCompanyUseCase(
        mockRepository,
        mockCodeGenerator,
        mockEventBus,
        CreateCompanyCommandValidator(),
      );
    });
    
    test('should create company with generated code', () async {
      // Arrange
      final command = CreateCompanyCommand(
        name: 'Test Company',
        userId: UserId('user123'),
      );
      
      when(mockCodeGenerator.generateCompanyCode())
        .thenAnswer((_) async => CompanyCode('TST123'));
        
      when(mockRepository.createCompany(any))
        .thenAnswer((_) async => right(testCompany));
      
      // Act
      final result = await useCase.execute(command);
      
      // Assert
      expect(result.isRight(), true);
      verify(mockCodeGenerator.generateCompanyCode()).called(1);
      verify(mockEventBus.publish(any)).called(1);
    });
    
    test('should return failure when repository fails', () async {
      // Arrange
      final command = CreateCompanyCommand(
        name: 'Test Company',
        userId: UserId('user123'),
      );
      
      when(mockCodeGenerator.generateCompanyCode())
        .thenAnswer((_) async => CompanyCode('TST123'));
        
      when(mockRepository.createCompany(any))
        .thenAnswer((_) async => left(const ServerFailure()));
      
      // Act
      final result = await useCase.execute(command);
      
      // Assert
      expect(result.isLeft(), true);
      verifyNever(mockEventBus.publish(any));
    });
  });
}
```

### Integration Tests

```dart
// test/integration/company_store_flow_test.dart
void main() {
  testWidgets('Complete company and store creation flow', (tester) async {
    // Setup
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Test overrides
        ],
        child: const MyFinanceApp(),
      ),
    );
    
    // Navigate to company management
    await tester.tap(find.byIcon(Icons.business));
    await tester.pumpAndSettle();
    
    // Create new company
    await tester.tap(find.text('Create Company'));
    await tester.pumpAndSettle();
    
    await tester.enterText(
      find.byType(TossTextField).first,
      'Integration Test Company',
    );
    
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    
    // Verify company created
    expect(find.text('Integration Test Company'), findsOneWidget);
    
    // Create store within company
    await tester.tap(find.text('Create Store'));
    await tester.pumpAndSettle();
    
    await tester.enterText(
      find.byType(TossTextField).first,
      'Test Store #1',
    );
    
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    
    // Verify store created
    expect(find.text('Test Store #1'), findsOneWidget);
  });
}
```

## Migration Plan

### Phase 1: Domain Layer (Week 1)
1. Create value objects
2. Enhance entities with business logic
3. Define repository interfaces
4. Set up domain events

### Phase 2: Application Layer (Week 2)
1. Implement use cases
2. Create application services
3. Set up validators
4. Configure dependency injection

### Phase 3: Infrastructure Layer (Week 3)
1. Implement repositories
2. Set up caching
3. Configure real-time subscriptions
4. Implement mappers

### Phase 4: Presentation Layer (Week 4)
1. Refactor state management
2. Update UI components
3. Implement optimistic updates
4. Add loading states

### Phase 5: Testing & Optimization (Week 5)
1. Write comprehensive tests
2. Performance optimization
3. Error handling improvements
4. Documentation

## Performance Metrics

### Target Metrics
- Company list load: < 500ms
- Store creation: < 1s (optimistic update instant)
- Company switch: < 200ms
- Cache hit rate: > 80%
- Error rate: < 0.1%

### Monitoring
- Response time tracking
- Cache performance metrics
- API call frequency
- Error rate monitoring
- User action analytics

## Security Considerations

### Access Control
- Row-level security in database
- Role-based permissions
- API rate limiting
- Input validation
- SQL injection prevention

### Data Protection
- Encryption at rest
- Secure code generation
- Audit logging
- PII handling
- GDPR compliance

## Conclusion

This design provides a scalable, maintainable architecture for company and store management with:
- Clean separation of concerns
- Strong typing and validation
- Optimistic updates for better UX
- Comprehensive error handling
- Performance optimizations
- Extensive testing coverage

The implementation follows Flutter and Dart best practices while maintaining the Toss-inspired design system.