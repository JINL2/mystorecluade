/// Repository Providers Facade for cash_ending module
///
/// This file re-exports repository providers from the data layer,
/// providing a clean interface for the presentation layer.
///
/// Following Clean Architecture:
/// - Presentation layer imports from domain/providers (this file)
/// - Domain layer remains independent (no data layer knowledge)
/// - Data layer implementation details are hidden
///
/// This pattern allows:
/// - Easy testing (mock repositories at domain level)
/// - Clear separation of concerns
/// - Implementation changes without affecting presentation layer

// Export all public repository providers
export '../../data/providers/cash_ending_data_providers.dart'
    show
        cashEndingRepositoryProvider,
        locationRepositoryProvider,
        currencyRepositoryProvider,
        stockFlowRepositoryProvider,
        bankRepositoryProvider,
        vaultRepositoryProvider;
