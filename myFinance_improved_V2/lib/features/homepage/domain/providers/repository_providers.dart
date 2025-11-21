/// Repository Providers for homepage module - Domain Layer
///
/// ✅ CLEAN ARCHITECTURE COMPLIANT
///
/// This file re-exports Repository providers from the Data layer.
/// Domain layer does NOT import Data implementations directly.
///
/// Following Dependency Inversion Principle:
/// - Domain defines the interfaces (abstractions)
/// - Data defines the providers (dependency injection)
/// - Data provides the implementations (concretions)
/// - Domain re-exports Data providers for Presentation to use
/// - Presentation depends on Domain only
///
/// Dependency Flow:
///   Presentation → Domain (interfaces + re-exports) ← Data (implementations + providers)
///
/// This is the CORRECT Clean Architecture pattern:
/// - Data layer creates and configures all concrete implementations
/// - Domain layer only re-exports the providers (no Data imports)
/// - Presentation layer imports from Domain only
///
library;

// ============================================================================
// Re-export Repository Providers from Data Layer
// ============================================================================
//
// The Data layer defines all repository providers with their implementations.
// Domain layer simply re-exports them so Presentation can import from Domain.
// This maintains Clean Architecture's dependency rule:
//   Presentation → Domain ← Data (dependencies point inward)
//

export '../../data/providers/homepage_providers.dart' show homepageRepositoryProvider;
export '../../data/providers/company_providers.dart' show companyRepositoryProvider;
export '../../data/providers/store_providers.dart' show storeRepositoryProvider;
export '../../data/providers/join_providers.dart' show joinRepositoryProvider;
