# 📂 Project Structure Guide

Understanding the MyFinance project structure and where to find/add different types of code.

## Overview

We follow **Clean Architecture** principles with clear separation between layers:

```
myFinance_improved/
├── lib/                          # Main source code
│   ├── core/                    # 🎯 Core functionality (shared across features)
│   ├── data/                    # 💾 Data layer (external data sources)
│   ├── domain/                  # 🧠 Domain layer (business logic)
│   ├── presentation/            # 🎨 Presentation layer (UI)
│   └── main.dart               # 🚀 App entry point
├── test/                        # 🧪 Test files
├── assets/                      # 🖼️ Static assets
├── docs/                        # 📚 Documentation
└── pubspec.yaml                # 📦 Dependencies
```

## Detailed Structure

### 🎯 Core Layer (`lib/core/`)

Shared utilities and configurations used throughout the app.

```
core/
├── constants/                   # App-wide constants
│   ├── app_colors.dart         # Toss color palette
│   ├── app_strings.dart        # String literals
│   ├── app_dimensions.dart     # Spacing, sizes
│   └── app_assets.dart         # Asset paths
├── themes/                      # Theming system
│   ├── app_theme.dart          # Main theme configuration
│   ├── toss_colors.dart        # Toss color system
│   ├── toss_text_styles.dart   # Typography
│   └── toss_shadows.dart       # Shadow definitions
├── utils/                       # Utility functions
│   ├── validators.dart         # Form validators
│   ├── formatters.dart         # Data formatters
│   ├── date_helpers.dart       # Date utilities
│   └── currency_helpers.dart   # Currency formatting
├── errors/                      # Error handling
│   ├── exceptions.dart         # Custom exceptions
│   └── failures.dart           # Failure types
└── config/                      # Configuration
    ├── app_config.dart         # App configuration
    └── environment.dart        # Environment settings
```

### 💾 Data Layer (`lib/data/`)

Handles all external data operations.

```
data/
├── datasources/                 # Data sources
│   ├── remote/                 # Remote data sources
│   │   ├── supabase_client.dart
│   │   └── api_client.dart
│   └── local/                  # Local data sources
│       ├── shared_preferences_client.dart
│       └── secure_storage_client.dart
├── models/                      # Data models (DTOs)
│   ├── user_model.dart         # Serializable user model
│   ├── company_model.dart
│   ├── transaction_model.dart
│   └── ...
└── repositories/                # Repository implementations
    ├── auth_repository_impl.dart
    ├── company_repository_impl.dart
    └── transaction_repository_impl.dart
```

### 🧠 Domain Layer (`lib/domain/`)

Pure business logic with no dependencies on external packages.

```
domain/
├── entities/                    # Business entities
│   ├── user.dart               # User entity
│   ├── company.dart
│   ├── transaction.dart
│   └── ...
├── repositories/                # Repository interfaces
│   ├── auth_repository.dart    # Abstract repository
│   ├── company_repository.dart
│   └── transaction_repository.dart
└── usecases/                    # Business use cases
    ├── auth/
    │   ├── login_usecase.dart
    │   └── logout_usecase.dart
    ├── transaction/
    │   ├── create_transaction_usecase.dart
    │   └── get_transactions_usecase.dart
    └── ...
```

### 🎨 Presentation Layer (`lib/presentation/`)

UI components and state management.

```
presentation/
├── app/                         # App configuration
│   ├── app.dart                # Main app widget
│   └── app_router.dart         # Navigation setup
├── providers/                   # Riverpod providers
│   ├── auth_provider.dart      # Authentication state
│   ├── company_provider.dart   # Company state
│   ├── theme_provider.dart     # Theme state
│   └── ...
├── pages/                       # Screen/Page widgets
│   ├── auth/
│   │   ├── login_page.dart
│   │   └── register_page.dart
│   ├── home/
│   │   └── home_page.dart
│   ├── transaction/
│   │   ├── transaction_list_page.dart
│   │   └── transaction_detail_page.dart
│   └── ...
└── widgets/                     # Reusable widgets
    ├── common/                  # Generic widgets
    │   ├── app_button.dart
    │   ├── app_text_field.dart
    │   └── ...
    ├── toss/                    # Toss-style widgets
    │   ├── toss_card.dart
    │   ├── toss_bottom_sheet.dart
    │   ├── toss_amount_input.dart
    │   └── ...
    └── specific/                # Feature-specific widgets
        ├── transaction_item.dart
        └── company_selector.dart
```

## 📍 Where to Put What?

### Creating a New Feature

1. **Entity** → `domain/entities/feature_name.dart`
2. **Model** → `data/models/feature_name_model.dart`
3. **Repository Interface** → `domain/repositories/feature_name_repository.dart`
4. **Repository Implementation** → `data/repositories/feature_name_repository_impl.dart`
5. **Use Cases** → `domain/usecases/feature_name/`
6. **Provider** → `presentation/providers/feature_name_provider.dart`
7. **Page** → `presentation/pages/feature_name/`
8. **Widgets** → `presentation/widgets/specific/feature_name/`

### Adding a New Toss Component

1. Create file in `presentation/widgets/toss/`
2. Follow Toss naming convention: `toss_component_name.dart`
3. Include micro-interactions and animations
4. Add example to documentation

### Adding Utilities

- **Formatters** → `core/utils/formatters.dart`
- **Validators** → `core/utils/validators.dart`
- **Constants** → `core/constants/appropriate_file.dart`
- **Themes** → `core/themes/`

## 🏗️ Architecture Rules

### Layer Dependencies
```
Presentation → Domain ← Data
     ↓           ↓        ↓
             Core Layer
```

- **Domain** has no dependencies (pure Dart)
- **Data** depends on Domain (implements interfaces)
- **Presentation** depends on Domain (uses entities/usecases)
- **Core** can be used by all layers

### Import Rules

✅ **Allowed**:
- Presentation can import from Domain and Core
- Data can import from Domain and Core
- Domain can only import from Domain
- Core can only import from Core

❌ **Not Allowed**:
- Domain importing from Data or Presentation
- Data importing from Presentation
- Core importing from other layers

## 📝 File Naming Conventions

### Dart Files
- **Use snake_case**: `user_profile_page.dart`
- **Suffix by type**: 
  - Pages: `*_page.dart`
  - Widgets: `*_widget.dart` or specific name
  - Providers: `*_provider.dart`
  - Models: `*_model.dart`
  - Repositories: `*_repository.dart`

### Test Files
- Mirror source structure in `test/`
- Suffix with `_test.dart`
- Example: `user_model_test.dart`

### Asset Files
- **Images**: `assets/images/icon_name.png`
- **Icons**: `assets/icons/ic_name.svg`
- **Fonts**: `assets/fonts/FontName-Weight.ttf`

## 🔍 Finding Code

### Common Locations

**Need to find a color?**
→ `core/themes/toss_colors.dart`

**Need to find text styles?**
→ `core/themes/toss_text_styles.dart`

**Need to find a button?**
→ `presentation/widgets/toss/toss_primary_button.dart`

**Need to find navigation?**
→ `presentation/app/app_router.dart`

**Need to find API calls?**
→ `data/datasources/remote/`

**Need to find business logic?**
→ `domain/usecases/`

**Need to find state management?**
→ `presentation/providers/`

## 💡 Best Practices

1. **Keep layers separate** - Don't mix concerns
2. **Use dependency injection** - Via Riverpod providers
3. **Follow naming conventions** - Consistency is key
4. **Write tests alongside code** - In parallel structure
5. **Document complex logic** - Add comments where needed
6. **Reuse existing components** - Check before creating new ones

## 🚀 Quick Examples

### Adding a New API Endpoint

1. Add method to `data/datasources/remote/api_client.dart`
2. Create/update model in `data/models/`
3. Add to repository implementation
4. Create use case if needed
5. Update provider to use new data

### Creating a New Toss Widget

```dart
// lib/presentation/widgets/toss/toss_new_widget.dart
class TossNewWidget extends StatefulWidget {
  // Follow Toss patterns:
  // - Micro-animations
  // - Clean design
  // - Single purpose
}
```

### Adding a New Screen

1. Create in `presentation/pages/feature/`
2. Add route in `app_router.dart`
3. Create necessary providers
4. Use Toss components for UI

---

Need more details? Check the [Architecture Guide](../architecture/ARCHITECTURE.md) or ask in #myfinance-dev! 🤝