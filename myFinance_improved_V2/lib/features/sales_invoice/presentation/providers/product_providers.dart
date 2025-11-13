/// Product repository providers
///
/// Re-exports repository providers from domain layer for presentation layer use.
/// This maintains Clean Architecture by keeping presentation layer dependent only on domain interfaces.
///
/// Clean Architecture: PRESENTATION LAYER imports from DOMAIN LAYER
library;
export '../../domain/providers/repository_providers.dart' show productRepositoryProvider;
