/// Invoice repository providers
///
/// Re-exports repository providers from data layer for presentation layer use.
/// The data layer provides concrete implementations of domain interfaces.
///
/// Clean Architecture: PRESENTATION LAYER imports Repository Providers (DI boundary)
library;
export '../../data/repositories/repository_providers.dart'
    show invoiceRepositoryProvider, salesJournalRepositoryProvider;
