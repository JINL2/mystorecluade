# Homepage Design Specification

## 1. Architecture Overview

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────┐
│                 Presentation Layer              │
│  ┌───────────────────────────────────────────┐  │
│  │  HomePage Widget                          │  │
│  │  HomepageProviders (Riverpod)            │  │
│  │  UI Components (Toss Style)              │  │
│  └───────────────────────────────────────────┘  │
├─────────────────────────────────────────────────┤
│                  Domain Layer                   │
│  ┌───────────────────────────────────────────┐  │
│  │  GetUserCompaniesUseCase                 │  │
│  │  GetCategoriesWithFeaturesUseCase        │  │
│  │  SwitchCompanyUseCase                    │  │
│  └───────────────────────────────────────────┘  │
├─────────────────────────────────────────────────┤
│                   Data Layer                    │
│  ┌───────────────────────────────────────────┐  │
│  │  UserRepository                          │  │
│  │  CompanyRepository                       │  │
│  │  FeatureRepository                       │  │
│  │  Supabase DataSource                     │  │
│  └───────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

## 2. Component Architecture

### Main Components Structure

```
homepage/
├── homepage_page.dart              # Main page widget
├── providers/
│   ├── homepage_state_provider.dart    # Page state management
│   ├── user_companies_provider.dart   # User & companies data
│   └── features_provider.dart          # Categories & features
├── widgets/
│   ├── homepage_app_bar.dart          # Custom app bar
│   ├── homepage_drawer.dart           # Navigation drawer
│   ├── company_selector_sheet.dart    # Company selection
│   ├── feature_grid.dart              # Features display
│   └── feature_card.dart              # Individual feature
└── models/
    ├── homepage_state.dart            # Page state model
    └── homepage_events.dart           # Page events

```

## 3. State Management Design

### Riverpod Providers

```dart
// User & Companies State
@riverpod
class UserCompanies extends _$UserCompanies {
  @override
  Future<UserWithCompanies> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) throw UnauthorizedException();
    
    final repository = ref.watch(userRepositoryProvider);
    return repository.getUserWithCompanies(userId);
  }
  
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Selected Company State
@riverpod
class SelectedCompany extends _$SelectedCompany {
  @override
  Company? build() {
    final userCompanies = ref.watch(userCompaniesProvider).valueOrNull;
    return userCompanies?.companies.firstOrNull;
  }
  
  void selectCompany(Company company) {
    state = company;
  }
}

// Categories & Features State
@riverpod
Future<List<CategoryWithFeatures>> categoriesWithFeatures(
  CategoriesWithFeaturesRef ref,
) async {
  final repository = ref.watch(featureRepositoryProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);
  final userRole = selectedCompany?.role;
  
  final categories = await repository.getCategoriesWithFeatures();
  
  // Filter features based on permissions
  return categories.map((category) {
    final filteredFeatures = category.features.where((feature) {
      return userRole?.permissions.contains(feature.id) ?? false;
    }).toList();
    
    return category.copyWith(features: filteredFeatures);
  }).toList();
}

// Homepage Loading States
@riverpod
class HomepageLoadingState extends _$HomepageLoadingState {
  @override
  HomepageLoading build() => const HomepageLoading();
  
  void setUserDataLoading(bool isLoading) {
    state = state.copyWith(isUserDataLoading: isLoading);
  }
  
  void setFeaturesLoading(bool isLoading) {
    state = state.copyWith(isFeaturesLoading: isLoading);
  }
  
  void setSyncLoading(bool isLoading) {
    state = state.copyWith(isSyncLoading: isLoading);
  }
}
```

## 4. UI Component Design

### Toss-Style Homepage Layout

```
┌────────────────────────────────────────┐
│  ┌──┐  Hello! Jin          ┌──┐ ⟲    │ ← App Bar
│  │☰ │  Company: MyCompany   │👤│      │
│  └──┘  Store: Main Store    └──┘      │
├────────────────────────────────────────┤
│                                        │
│  📊 Finance Management                 │ ← Category Header
│  ┌────────┐ ┌────────┐ ┌────────┐    │
│  │   💰   │ │   📈   │ │   🏦   │    │ ← Feature Grid
│  │ Cash   │ │Reports │ │ Bank   │    │   (3 columns)
│  │Balance │ │        │ │ Vault  │    │
│  └────────┘ └────────┘ └────────┘    │
│                                        │
│  👥 Human Resources                    │
│  ┌────────┐ ┌────────┐ ┌────────┐    │
│  │   ⏰   │ │   💼   │ │   📋   │    │
│  │ Time   │ │Employee│ │ Roles  │    │
│  │ Table  │ │Settings│ │        │    │
│  └────────┘ └────────┘ └────────┘    │
│                                        │
└────────────────────────────────────────┘

Drawer Menu:
┌────────────────────────────────────────┐
│  You are in Company MyCompany          │
│  ┌──────────────────────────────────┐  │
│  │ 🏢 MyCompany             ▼      │  │ ← Company List
│  │   📍 Main Store                 │  │
│  │   📍 Branch Store               │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │ 🏢 SecondCompany         ▶      │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │ ➕ Add Company                   │  │ ← Action Buttons
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │ ➕ Add Store                     │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │ 🔗 Add By Code                   │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │ 📋 Show Code                     │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

### Component Specifications

#### 1. TossHomepageAppBar
```dart
class TossHomepageAppBar extends StatelessWidget {
  final String userName;
  final String companyName;
  final String? storeName;
  final String profileImageUrl;
  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;
  final VoidCallback onSyncTap;
  final bool isSyncing;
}
```

Features:
- Minimal height (56dp)
- White background with subtle shadow
- Profile image: 32x32 circular
- Sync animation when loading

#### 2. TossFeatureCard
```dart
class TossFeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String route;
  final VoidCallback onTap;
}
```

Features:
- Size: 104x104
- Border radius: 16px
- Hover/tap animation (scale 0.95)
- Shadow: 2% opacity
- Icon size: 32x32
- Text: 14px, medium weight

#### 3. TossCompanyDrawer
```dart
class TossCompanyDrawer extends StatelessWidget {
  final List<Company> companies;
  final Company selectedCompany;
  final Store? selectedStore;
  final Function(Company) onCompanySelect;
  final Function(Store) onStoreSelect;
  final VoidCallback onAddCompany;
  final VoidCallback onAddStore;
  final VoidCallback onJoinByCode;
  final VoidCallback onShowCode;
  final bool canAddStore; // Based on role
}
```

Features:
- Expandable company items
- Store sub-list with indentation
- Action buttons at bottom
- Smooth transitions

## 5. API Integration

### Repository Interfaces

```dart
// Domain Layer
abstract class UserRepository {
  Future<UserWithCompanies> getUserWithCompanies(String userId);
  Future<void> updateUserProfile(String userId, UserProfileUpdate update);
}

abstract class CompanyRepository {
  Future<Company> createCompany(CompanyCreation data);
  Future<Company> joinCompanyByCode(String code, String userId);
  Future<String> getCompanyCode(String companyId);
}

abstract class FeatureRepository {
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures();
}
```

### Data Layer Implementation

```dart
// Data Layer - Supabase Implementation
class SupabaseUserRepository implements UserRepository {
  final SupabaseClient _supabase;
  
  @override
  Future<UserWithCompanies> getUserWithCompanies(String userId) async {
    final response = await _supabase.rpc(
      'get_user_companies',
      params: {'p_user_id': userId},
    );
    
    if (response.error != null) {
      throw RepositoryException(response.error!.message);
    }
    
    return UserWithCompanies.fromJson(response.data);
  }
}

class SupabaseFeatureRepository implements FeatureRepository {
  final SupabaseClient _supabase;
  
  @override
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures() async {
    final response = await _supabase.rpc('get_categories_with_features');
    
    if (response.error != null) {
      throw RepositoryException(response.error!.message);
    }
    
    return (response.data as List)
        .map((json) => CategoryWithFeatures.fromJson(json))
        .toList();
  }
}
```

## 6. Navigation & Routing

### Route Definition
```dart
// In app_router.dart
GoRoute(
  path: '/homepage',
  name: 'homepage',
  pageBuilder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return MaterialPage(
      child: HomePage(
        firstLogin: extra?['firstLogin'] as bool? ?? false,
        companyClicked: extra?['companyClicked'] as bool? ?? false,
        storeClicked: extra?['storeClicked'] as bool? ?? false,
      ),
    );
  },
),
```

### Feature Navigation
```dart
void _navigateToFeature(BuildContext context, Feature feature) {
  context.pushNamed(feature.route);
}
```

## 7. Error Handling

### Error States
```dart
@freezed
class HomepageError with _$HomepageError {
  const factory HomepageError.networkError(String message) = _NetworkError;
  const factory HomepageError.unauthorized() = _Unauthorized;
  const factory HomepageError.serverError(String message) = _ServerError;
  const factory HomepageError.unknown(String message) = _Unknown;
}
```

### Error UI
- Network errors: Show retry button
- Unauthorized: Redirect to login
- Server errors: Show error message with support contact

## 8. Loading States

### Progressive Loading
1. Initial skeleton UI
2. Load user data first
3. Load features in parallel
4. Show content as available

### Loading UI Components
- Skeleton screens for each section
- Shimmer effects on placeholders
- Smooth transitions when data loads

## 9. Animations

### Toss-Style Animations
- Page transitions: 300ms ease-out
- Card tap: Scale to 0.95 with 100ms duration
- Drawer slide: 250ms ease-in-out
- Loading spinner: Custom Toss-style animation

## 10. Testing Strategy

### Unit Tests
- Provider logic testing
- Repository mock testing
- Use case testing

### Widget Tests
- Component isolation tests
- User interaction tests
- State change verification

### Integration Tests
- Full homepage flow
- Company switching
- Feature navigation
- Error scenarios

## 11. Performance Optimizations

### Caching Strategy
- Cache user companies for session
- Cache features list (invalidate on role change)
- Image caching for profile pictures

### Lazy Loading
- Load features on demand
- Defer non-visible content
- Optimize image loading

### State Optimization
- Selective rebuilds with Riverpod
- Memoized computed values
- Efficient list rendering

## 12. Accessibility

### Requirements
- Screen reader support
- Keyboard navigation
- High contrast mode support
- Focus indicators
- Semantic labels

### Implementation
- Use Semantics widgets
- Proper focus order
- ARIA-like attributes
- Touch target sizes (48x48 minimum)