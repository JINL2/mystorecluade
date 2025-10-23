# Debt Control Feature Migration Notes

## ✅ Completed Migration

### Domain Layer (`lib/features/debt_control/domain/`)
- ✅ `entities/kpi_metrics.dart` - KPI metrics with business logic
- ✅ `entities/prioritized_debt.dart` - Debt entity with risk calculation
- ✅ `entities/debt_overview.dart` - Overview aggregation
- ✅ `entities/aging_analysis.dart` - Aging analysis with trend data
- ✅ `entities/critical_alert.dart` - Alert entity with priority logic
- ✅ `entities/perspective_summary.dart` - Perspective-aware summary
- ✅ `repositories/debt_repository.dart` - Repository interface
- ✅ `value_objects/debt_filter.dart` - Filter criteria value object

### Data Layer (`lib/features/debt_control/data/`)
- ✅ `models/debt_control_dto.dart` - DTOs for API/DB
- ✅ `models/debt_control_mapper.dart` - DTO ↔ Entity mappers
- ✅ `datasources/debt_data_source.dart` - Data source interface

### Build Output
- ✅ Freezed files generated successfully
- ✅ All domain entities have business logic methods
- ✅ Mappers complete for all DTOs

## 📋 TODO: Files That Need to Be Migrated

### 1. Data Layer - Repository Implementation
**File to create**: `lib/features/debt_control/data/repositories/debt_repository_impl.dart`

**Source**: `/lib_old/data/repositories/supabase_debt_repository.dart`

**What to copy**:
- Supabase RPC call logic
- Caching implementation
- All query methods

**Changes needed**:
- Implement `DebtRepository` interface from domain
- Use `DebtDataSource` for actual DB calls
- Use `DebtControlMapper` to convert DTOs to Entities
- Update imports to new architecture

---

### 2. Data Layer - Supabase Data Source Implementation
**File to create**: `lib/features/debt_control/data/datasources/supabase_debt_data_source.dart`

**Source**: `/lib_old/data/repositories/supabase_debt_repository.dart`

**What to copy**:
- All Supabase RPC calls
- Query building logic
- Error handling

**Changes needed**:
- Implement `DebtDataSource` interface
- Return DTOs instead of entities
- Move caching logic to repository layer

---

### 3. Presentation Layer - Pages
**Files to migrate**:
1. `lib/features/debt_control/presentation/pages/smart_debt_control_page.dart`
   - Source: `/lib_old/presentation/pages/debt_control/smart_debt_control_page.dart`

2. `lib/features/debt_control/presentation/pages/debt_relationship_page.dart`
   - Source: `/lib_old/presentation/pages/debt_control/debt_relationship_page.dart`

**Changes needed**:
- Update all imports to use new architecture paths
- Update provider references to new providers
- Change theme imports from `core/themes` to `shared/themes`

---

### 4. Presentation Layer - Widgets
**Files to migrate**:
1. `lib/features/debt_control/presentation/widgets/simple_company_card.dart`
   - Source: `/lib_old/presentation/pages/debt_control/widgets/simple_company_card.dart`

2. `lib/features/debt_control/presentation/widgets/perspective_summary_card.dart`
   - Source: `/lib_old/presentation/pages/debt_control/widgets/perspective_summary_card.dart`

3. `lib/features/debt_control/presentation/widgets/edit_counterparty_sheet.dart`
   - Source: `/lib_old/presentation/pages/debt_control/widgets/edit_counterparty_sheet.dart`

**Changes needed**:
- Update imports for theme system (`shared/themes/`)
- Update imports for shared widgets (`shared/widgets/`)
- Update entity imports to use domain layer

---

### 5. Presentation Layer - Providers
**File to create**: `lib/features/debt_control/presentation/providers/debt_provider.dart`

**Source**: `/lib_old/presentation/pages/debt_control/providers/debt_control_providers.dart`

**What to copy**:
- All provider logic
- State management
- Provider families

**Changes needed**:
- Update to use new repository interface
- Update entity imports
- Use domain entities instead of old models
- Separate state classes if needed

---

### 6. Presentation Layer - Additional Providers
**Files to migrate**:
1. `lib/features/debt_control/presentation/providers/perspective_provider.dart`
   - Source: `/lib_old/presentation/pages/debt_control/providers/perspective_providers.dart`

2. `lib/features/debt_control/presentation/providers/currency_provider.dart`
   - Source: `/lib_old/presentation/pages/debt_control/providers/currency_provider.dart`

---

## 🔧 External Files That Need Updates

### Router Configuration
**File**: `lib/app/config/app_router.dart` or `lib/app/router.dart`

**Changes needed**:
```dart
// Add routes for debt control pages
GoRoute(
  path: '/debt-control',
  name: 'debt-control',
  builder: (context, state) => const SmartDebtControlPage(),
),
GoRoute(
  path: '/debtRelationship/:counterpartyId',
  name: 'debt-relationship',
  builder: (context, state) {
    final counterpartyId = state.pathParameters['counterpartyId']!;
    final extra = state.extra as Map<String, dynamic>?;
    return DebtRelationshipPage(
      counterpartyId: counterpartyId,
      counterpartyName: extra?['counterpartyName'] ?? '',
    );
  },
),
```

---

### Provider Registration
**File**: Check if there's a provider registration file

**Changes needed**:
- Register `debtRepositoryProvider`
- Register any global debt-related providers

---

## 📦 Import Path Changes Reference

### OLD → NEW Import Paths

**Theme Imports**:
```dart
// OLD
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';

// NEW
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
```

**Widget Imports**:
```dart
// OLD
import '../../widgets/common/toss_scaffold.dart';

// NEW
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
```

**Domain Entity Imports**:
```dart
// OLD
import '../models/debt_control_models.dart';

// NEW
import '../../domain/entities/debt_overview.dart';
import '../../domain/entities/prioritized_debt.dart';
import '../../domain/entities/kpi_metrics.dart';
```

**Provider Imports**:
```dart
// OLD
import 'providers/debt_control_providers.dart';

// NEW
import '../providers/debt_provider.dart';
```

**AppState Imports**:
```dart
// OLD
import '../../providers/app_state_provider.dart';

// NEW
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
```

---

## 🎯 Next Steps

1. **Copy repository implementation** from lib_old → create data source + repository
2. **Migrate presentation pages** with updated imports
3. **Migrate widgets** with updated imports
4. **Migrate providers** with new architecture
5. **Update router** to add debt control routes
6. **Test the feature** end-to-end

---

## ⚠️ Important Notes

- **DO NOT modify** files outside `lib/features/debt_control/`
- **Document** any external file paths that need updates
- **Preserve** all business logic from old implementation
- **Test** each layer independently before integration
- **Keep** the old files in lib_old until migration is complete and tested

---

## 📝 Migration Checklist

- [x] Domain layer created
- [x] Data DTOs and mappers created
- [x] Freezed files generated
- [ ] Data source implementation
- [ ] Repository implementation
- [ ] Providers migrated
- [ ] Pages migrated
- [ ] Widgets migrated
- [ ] Router updated
- [ ] Integration testing
- [ ] Delete old files from lib_old
