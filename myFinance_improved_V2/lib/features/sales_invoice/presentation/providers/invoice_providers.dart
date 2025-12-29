/// Invoice repository providers
///
/// Re-exports providers from centralized DI layer.
/// Following Clean Architecture 2025 with @riverpod
///
/// Clean Architecture: PRESENTATION LAYER imports from DI layer
library;

export '../../di/sales_invoice_providers.dart'
    show invoiceRepositoryProvider, salesJournalRepositoryProvider;
