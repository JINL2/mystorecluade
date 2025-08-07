# State Management Design with Riverpod

## Overview
We'll use Riverpod for state management as it provides:
- Type safety and compile-time safety
- Dependency injection
- Better testability
- Easy debugging with ProviderObserver
- No BuildContext required

## State Structure

### 1. Authentication State
```dart
// lib/presentation/providers/auth_provider.dart

@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null) {
      final user = await _authRepository.getCurrentUser();
      return AuthState.authenticated(user);
    }
    return const AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _authRepository.login(email, password);
      return AuthState.authenticated(user);
    });
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AsyncValue.data(AuthState.unauthenticated());
  }
}

// Auth State Model
@freezed
class AuthState with _$AuthState {
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
}
```

### 2. Company & Store State
```dart
// lib/presentation/providers/company_provider.dart

@riverpod
class SelectedCompany extends _$SelectedCompany {
  @override
  Company? build() => null;

  void selectCompany(Company company) {
    state = company;
  }
}

@riverpod
class SelectedStore extends _$SelectedStore {
  @override
  Store? build() => null;

  void selectStore(Store store) {
    state = store;
  }
}

@riverpod
Future<List<Company>> userCompanies(UserCompaniesRef ref) async {
  final auth = await ref.watch(authProvider.future);
  return auth.when(
    authenticated: (user) => ref.watch(companyRepositoryProvider).getUserCompanies(user.id),
    unauthenticated: () => [],
  );
}
```

### 3. Transaction State
```dart
// lib/presentation/providers/transaction_provider.dart

@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<Transaction>> build() async {
    final store = ref.watch(selectedStoreProvider);
    if (store == null) return [];
    
    return ref.watch(transactionRepositoryProvider).getTransactions(store.id);
  }

  Future<void> addTransaction(TransactionInput input) async {
    final repository = ref.read(transactionRepositoryProvider);
    final newTransaction = await repository.createTransaction(input);
    
    state = await AsyncValue.guard(() async {
      final current = await future;
      return [...current, newTransaction];
    });
  }
}
```

### 4. UI State Management
```dart
// lib/presentation/providers/ui_provider.dart

@riverpod
class LoadingState extends _$LoadingState {
  @override
  Map<String, bool> build() => {};

  void setLoading(String key, bool isLoading) {
    state = {...state, key: isLoading};
  }

  bool isLoading(String key) => state[key] ?? false;
}

@riverpod
class BottomNavIndex extends _$BottomNavIndex {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}
```

### 5. Theme State
```dart
// lib/presentation/providers/theme_provider.dart

@riverpod
class ThemeMode extends _$ThemeMode {
  @override
  AppThemeMode build() {
    final saved = ref.watch(sharedPreferencesProvider).getString('theme_mode');
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => AppThemeMode.system,
    );
  }

  void setTheme(AppThemeMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).setString('theme_mode', mode.name);
  }
}

enum AppThemeMode { light, dark, system }
```

### 6. Feature Permissions State
```dart
// lib/presentation/providers/permissions_provider.dart

@riverpod
Future<Set<FeaturePermission>> userPermissions(UserPermissionsRef ref) async {
  final auth = await ref.watch(authProvider.future);
  return auth.when(
    authenticated: (user) async {
      final company = ref.watch(selectedCompanyProvider);
      if (company == null) return {};
      
      final role = await ref.watch(roleRepositoryProvider).getUserRole(user.id, company.id);
      return role.permissions;
    },
    unauthenticated: () => {},
  );
}

@riverpod
bool hasPermission(HasPermissionRef ref, FeaturePermission permission) {
  final permissions = ref.watch(userPermissionsProvider).valueOrNull ?? {};
  return permissions.contains(permission);
}
```

## Global Providers

```dart
// lib/presentation/providers/global_providers.dart

// Repository providers
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
}

@riverpod
CompanyRepository companyRepository(CompanyRepositoryRef ref) {
  return CompanyRepositoryImpl(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
}

// External dependencies
@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('Override in main()');
}
```

## State Persistence

```dart
// lib/presentation/providers/persistence_provider.dart

class PersistenceObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (provider is StateNotifierProvider) {
      // Persist selected company/store
      if (provider == selectedCompanyProvider && newValue is Company?) {
        container.read(sharedPreferencesProvider)
          .setString('selected_company_id', newValue?.id ?? '');
      }
    }
  }
}
```

## Usage Example

```dart
// In a widget
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return authState.when(
      data: (auth) => auth.when(
        authenticated: (user) => _buildAuthenticatedHome(context, ref, user),
        unauthenticated: () => const LoginPage(),
      ),
      loading: () => const LoadingScreen(),
      error: (error, stack) => ErrorScreen(error: error),
    );
  }
  
  Widget _buildAuthenticatedHome(BuildContext context, WidgetRef ref, User user) {
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final hasPermission = ref.watch(hasPermissionProvider(FeaturePermission.viewTransactions));
    
    // UI based on state...
  }
}
```

## Benefits of This Approach

1. **Type Safety**: All state is strongly typed
2. **Reactive Updates**: UI automatically updates when state changes
3. **Testability**: Easy to test providers in isolation
4. **Performance**: Only rebuilds widgets that depend on changed state
5. **Debugging**: Provider observer for logging state changes
6. **Persistence**: Easy to persist and restore state
7. **Modularity**: Each feature has its own providers