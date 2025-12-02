/// Sales journal repository provider
///
/// Re-exports repository provider from data layer for presentation layer use.
/// The data layer provides concrete implementation of domain interface.
///
/// Clean Architecture: PRESENTATION LAYER imports Repository Providers (DI boundary)
library;

export '../../data/repositories/repository_providers.dart' show salesJournalRepositoryProvider;
