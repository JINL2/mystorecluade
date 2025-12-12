# Cash Ending Feature - Clean Architecture

## Overview

This feature follows Clean Architecture principles as defined in `/docs/ARCHITECTURE.md`.

**Key Principle: Simple & Practical** - No over-engineering, just what we need.

## Architecture

### 1. Domain Layer (Pure Business Logic)

#### Entities (`domain/entities/`)
Simple business objects with built-in validation:
- `cash_ending.dart` - Aggregate root for cash ending records
- `currency.dart` - Currency with denominations
- `denomination.dart` - Individual denomination (coin/bill)
- `location.dart` - Cash location (cash drawer, bank, vault)
- `store.dart` - Store information

**No "Entity" suffix** - follows Dart naming conventions.

**Validation in constructors**:
```dart
Denomination({required this.value, this.quantity = 0}) {
  if (value <= 0) throw ArgumentError('Value must be positive');
  if (quantity < 0) throw ArgumentError('Quantity cannot be negative');
}
```

#### Repository Interfaces (`domain/repositories/`)
- `cash_ending_repository.dart` - Save and retrieve cash endings
- `location_repository.dart` - Store and location operations
- `currency_repository.dart` - Currency and denomination operations

**No "I" prefix** - follows Dart naming conventions (not C#).

#### Exceptions (`domain/exceptions/`)
- `validation_exception.dart` - Value validation failures
- `cash_ending_exception.dart` - Business logic errors

### 2. Data Layer (Infrastructure)

#### Data Sources (`data/datasources/`)
**ONLY place where Supabase is used**:
- `cash_ending_remote_datasource.dart`
- `location_remote_datasource.dart`
- `currency_remote_datasource.dart`

#### Models/DTOs (`data/models/`)
Data Transfer Objects with JSON mappers:
- `cash_ending_model.dart`
- `currency_model.dart`
- `denomination_model.dart`
- `location_model.dart`
- `store_model.dart`

Each model has:
- `fromJson()` - Parse from database
- `toJson()` - Convert to JSON
- `toEntity()` - Convert to domain entity
- `fromEntity()` - Create from domain entity
- `toRpcParams()` - Special format for Supabase RPC (cash_ending_model only)

#### Repository Implementations (`data/repositories/`)
- `cash_ending_repository_impl.dart` - Implements `CashEndingRepository`
- `location_repository_impl.dart` - Implements `LocationRepository`
- `currency_repository_impl.dart` - Implements `CurrencyRepository`

**"Impl" suffix** - makes it clear these are implementations.

### 3. Presentation Layer (UI)

#### Providers (`presentation/providers/`)
Riverpod state management:
- `repository_providers.dart` - Provider instances
- `cash_ending_state.dart` - Immutable state class
- `cash_ending_notifier.dart` - StateNotifier with business operations
- `cash_ending_provider.dart` - Main provider + derived providers

## Dependency Flow

```
Presentation → Domain ← Data
```

- **Domain** has ZERO dependencies (pure Dart)
- **Data** depends ONLY on Domain
- **Presentation** depends ONLY on Domain
- NO reverse dependencies

## File Structure (22 Files)

```
lib/features/cash_ending/
├── domain/ (10 files)
│   ├── entities/ (5 files - simple classes with validation)
│   ├── repositories/ (3 files - abstract interfaces)
│   └── exceptions/ (2 files)
├── data/ (8 files)
│   ├── datasources/ (3 files - Supabase calls only)
│   ├── models/ (5 files - DTOs with JSON mappers)
│   └── repositories/ (3 files - implementations with _impl suffix)
└── presentation/ (4 files)
    └── providers/ (4 files - Riverpod state)
```

## What We Removed (Simplified)

### ❌ Deleted: Value Objects folder (5 files)
- `money.dart`
- `currency_code.dart`
- `denomination_value.dart`
- `quantity.dart`
- `location_type.dart`

**Why?**
- Not actually used anywhere
- Entities already use simple types (`double`, `int`, `String`)
- YAGNI principle - we don't need them
- Would require rewriting all entities to use them

### ✅ Instead: Simple validation in entities
```dart
// Before (over-engineered):
final Money amount = Money(100.50);  // Complex value object
final Quantity qty = Quantity(5);     // Unnecessary wrapper

// After (simple & clean):
final double amount = 100.50;  // With validation in entity constructor
final int quantity = 5;        // With validation in entity constructor
```

## Naming Conventions

Following Dart/Flutter best practices:

| ❌ Wrong (C# style) | ✅ Correct (Dart style) |
|---------------------|-------------------------|
| `DenominationEntity` | `Denomination` |
| `CurrencyEntity` | `Currency` |
| `ICashEndingRepository` | `CashEndingRepository` |
| `ILocationRepository` | `LocationRepository` |
| `CashEndingRepository` (data layer) | `CashEndingRepositoryImpl` |

## Database Mapping

All model fields map directly to database columns:

```dart
// Model matches database exactly
DenominationModel.fromJson({
  'denomination_id': '123',  // denomination_id column
  'currency_id': '456',      // currency_id column
  'value': 50000.0,          // value column
  'quantity': 5,             // quantity column
})
```

## Usage Example

```dart
// In UI widget:
final state = ref.watch(cashEndingProvider);
final notifier = ref.read(cashEndingProvider.notifier);

// Load data
await notifier.loadStores(companyId);
await notifier.loadCurrencies(companyId);
await notifier.loadLocations(
  companyId: companyId,
  locationType: 'cash',
  storeId: storeId,
);

// Save cash ending
final entity = CashEnding(
  companyId: companyId,
  userId: userId,
  locationId: locationId,
  recordDate: DateTime.now(),
  createdAt: DateTime.now(),
  currencies: currencies, // with denominations
);

final success = await notifier.saveCashEnding(entity);
```

## Validation Examples

```dart
// Entity validation (simple & effective)
try {
  final denom = Denomination(
    denominationId: '1',
    currencyId: '2',
    value: -100,  // ❌ throws ArgumentError
    quantity: 5,
  );
} catch (e) {
  print(e); // ArgumentError: Value must be positive
}

try {
  final location = Location(
    locationId: '1',
    locationName: 'Main Counter',
    locationType: 'invalid',  // ❌ throws ArgumentError
  );
} catch (e) {
  print(e); // ArgumentError: Invalid location type
}
```

## Benefits

1. **Simple** - No unnecessary abstractions
2. **Readable** - Clear naming without prefixes/suffixes
3. **Maintainable** - Easy to understand and modify
4. **Testable** - Each layer can be tested independently
5. **Type Safe** - Compile-time checking
6. **Practical** - Follows YAGNI (You Aren't Gonna Need It)

## Comparison: Before vs After

### Before (Over-engineered):
- ❌ Value Objects everywhere (unused)
- ❌ "Entity" suffix on all entities
- ❌ "I" prefix on repository interfaces (C# style)
- ❌ Complex validation that wasn't used
- ❌ 5 unnecessary value object files

### After (Clean & Simple):
- ✅ Simple entities with validation in constructors
- ✅ Clean Dart naming (no suffixes/prefixes)
- ✅ Clear separation: interfaces vs implementations
- ✅ Practical validation where needed
- ✅ 22 files total (well-organized)

## Next Steps

To complete the feature:
1. Migrate widgets from `lib_old/`
2. Migrate main page
3. Connect UI to providers
4. Test the complete flow

---

**Remember**: Simple and practical beats complex and theoretical. This architecture is clean, maintainable, and follows Dart best practices.
