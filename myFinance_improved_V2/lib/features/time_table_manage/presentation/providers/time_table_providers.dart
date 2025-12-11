/// Time Table Feature - Riverpod Providers (Barrel File)
///
/// This file re-exports all providers for the Time Table feature.
/// Organized by layer and responsibility.
///
/// Architecture:
/// ```
/// presentation/providers/
/// ├── di/ (Dependency Injection)
/// │   └── dependency_injection.dart
/// ├── usecase/ (Domain Layer)
/// │   └── time_table_usecase_providers.dart
/// ├── state/ (Presentation State)
/// │   ├── monthly_shift_status_provider.dart
/// │   ├── manager_overview_provider.dart
/// │   ├── manager_shift_cards_provider.dart
/// │   ├── selected_shift_requests_provider.dart
/// │   ├── shift_metadata_provider.dart
/// │   └── ui_state_providers.dart
/// └── time_table_providers.dart (this file - barrel export)
/// ```
///
/// Total Providers: ~35
/// - Repository & Datasource: 3 (in DI layer)
/// - UseCases: 17 (domain logic)
/// - UI State: 1 (selected date)
/// - Data State: 5 (shift metadata, monthly status, manager overview, cards, selections)
/// - Form State: 2 (add shift form, shift details form)
///
/// Clean Architecture Compliance: ✅
/// - Presentation → Domain (via DI) ✅
/// - No direct Data layer imports ✅
library;

// ============================================================================
// Dependency Injection Layer
// ============================================================================
export '../../di/dependency_injection.dart';

// ============================================================================
// UseCase Providers (Domain Layer)
// ============================================================================
export 'usecase/time_table_usecase_providers.dart';

// ============================================================================
// State Providers (Presentation Layer)
// ============================================================================
export 'state/employee_monthly_detail_provider.dart';
export 'state/manager_overview_provider.dart';
export 'state/manager_shift_cards_provider.dart';
export 'state/monthly_shift_status_provider.dart';
export 'state/selected_shift_requests_provider.dart';
export 'state/shift_metadata_provider.dart';
export 'state/ui_state_providers.dart';

// ============================================================================
// Form State Providers (Presentation Layer)
// ============================================================================
export 'form/form_providers.dart';

// ============================================================================
// Migration Notes
// ============================================================================
//
// ✅ BEFORE (Monolithic - 567 lines):
// - All providers in one file
// - Mixed concerns (DI, domain, presentation)
// - Violated Clean Architecture
// - Hard to test and maintain
//
// ✅ AFTER (Modular - 8 files):
// - Separated by responsibility
// - Clean Architecture compliant
// - Easy to test and maintain
// - Average file size: ~100 lines
//
// File Size Reduction:
// - time_table_providers.dart: 567 lines → 80 lines (barrel)
// - New files: 7 files × ~100 lines each
//
// Benefits:
// 1. Testability: Mock individual providers easily
// 2. Maintainability: Clear separation of concerns
// 3. Performance: Faster hot reload (smaller files)
// 4. Collaboration: Multiple devs can work in parallel
// 5. Clean Architecture: Proper dependency inversion
//
// ============================================================================
