# MyFinance Improved Architecture

## Project Structure

```
myFinance_improved/
├── lib/
│   ├── core/                      # Core functionality and utilities
│   │   ├── constants/            # App constants
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   ├── app_dimensions.dart
│   │   │   └── app_assets.dart
│   │   ├── config/               # Configuration
│   │   │   ├── app_config.dart
│   │   │   ├── environment.dart
│   │   │   └── feature_flags.dart
│   │   ├── themes/               # Theme system
│   │   │   ├── app_theme.dart
│   │   │   ├── color_schemes.dart
│   │   │   ├── text_styles.dart
│   │   │   └── component_themes.dart
│   │   ├── utils/                # Utilities
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   ├── date_helpers.dart
│   │   │   └── currency_helpers.dart
│   │   └── errors/               # Error handling
│   │       ├── exceptions.dart
│   │       └── failures.dart
│   │
│   ├── data/                      # Data layer
│   │   ├── datasources/          # Data sources
│   │   │   ├── remote/
│   │   │   │   ├── supabase_client.dart
│   │   │   │   └── api_client.dart
│   │   │   └── local/
│   │   │       ├── shared_preferences_client.dart
│   │   │       └── secure_storage_client.dart
│   │   ├── models/               # Data models
│   │   │   ├── user_model.dart
│   │   │   ├── company_model.dart
│   │   │   ├── store_model.dart
│   │   │   └── transaction_model.dart
│   │   └── repositories/         # Repository implementations
│   │       ├── auth_repository_impl.dart
│   │       ├── company_repository_impl.dart
│   │       └── transaction_repository_impl.dart
│   │
│   ├── domain/                    # Domain layer (business logic)
│   │   ├── entities/             # Business entities
│   │   │   ├── user.dart
│   │   │   ├── company.dart
│   │   │   ├── store.dart
│   │   │   └── transaction.dart
│   │   ├── repositories/         # Repository interfaces
│   │   │   ├── auth_repository.dart
│   │   │   ├── company_repository.dart
│   │   │   └── transaction_repository.dart
│   │   └── usecases/             # Business use cases
│   │       ├── auth/
│   │       │   ├── login_usecase.dart
│   │       │   └── logout_usecase.dart
│   │       ├── company/
│   │       │   └── get_companies_usecase.dart
│   │       └── transaction/
│   │           └── create_transaction_usecase.dart
│   │
│   ├── presentation/              # Presentation layer
│   │   ├── app/                 # App entry point
│   │   │   └── app.dart
│   │   ├── router/              # Navigation
│   │   │   ├── app_router.dart
│   │   │   └── route_guards.dart
│   │   ├── providers/           # State management (Riverpod)
│   │   │   ├── auth_provider.dart
│   │   │   ├── company_provider.dart
│   │   │   └── theme_provider.dart
│   │   ├── pages/               # Feature pages
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   ├── home/
│   │   │   │   └── home_page.dart
│   │   │   ├── company/
│   │   │   │   ├── company_list_page.dart
│   │   │   │   └── company_detail_page.dart
│   │   │   └── transaction/
│   │   │       ├── transaction_list_page.dart
│   │   │       └── transaction_create_page.dart
│   │   └── widgets/             # Reusable widgets
│   │       ├── common/
│   │       │   ├── app_button.dart
│   │       │   ├── app_text_field.dart
│   │       │   ├── app_card.dart
│   │       │   └── app_loading.dart
│   │       └── specific/
│   │           ├── transaction_item.dart
│   │           └── company_selector.dart
│   │
│   └── main.dart                  # App entry point
│
├── test/                          # Test files
├── assets/                        # Assets
│   ├── images/
│   ├── fonts/
│   └── icons/
├── pubspec.yaml
└── README.md
```

## Key Architectural Decisions

### 1. Clean Architecture
- **Domain Layer**: Contains business logic, entities, and repository interfaces
- **Data Layer**: Implements repositories, handles data sources
- **Presentation Layer**: UI components, state management, and navigation

### 2. State Management: Riverpod
- Type-safe and compile-time safe
- Better testability
- Powerful dependency injection
- Easy to scale

### 3. Design System Implementation
- Centralized theme management
- Component-based architecture
- Consistent styling across the app

### 4. Modular Feature Structure
- Each feature is self-contained
- Easy to add/remove features
- Clear separation of concerns