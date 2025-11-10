/// Repository Providers Facade for attendance module
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

// Export only the public repository provider
export '../../data/providers/attendance_data_providers.dart'
    show attendanceRepositoryProvider;
