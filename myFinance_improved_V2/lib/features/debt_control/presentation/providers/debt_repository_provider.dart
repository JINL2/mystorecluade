// Re-export from DI layer to maintain backward compatibility
// Presentation layer should NOT import Data layer directly
// All DI wiring is handled in the injection.dart file
export '../../di/injection.dart'
    show debtRepositoryProvider, debtDataSourceProvider;
