// Repository Providers: Inventory Management
// ⚠️ DEPRECATED: This file now re-exports from feature's di/ folder
//
// DI configuration has been moved to proper location:
// - Old location: app/providers/inventory_di_providers.dart
// - New location: features/inventory_management/di/inventory_providers.dart
//
// MIGRATION:
// - Old: import '../providers/repository_providers.dart';
// - New: import '../../di/inventory_providers.dart';
//
// This file re-exports the providers for backward compatibility
// Will be removed in next major version

// Re-export from feature DI configuration
export '../../di/inventory_providers.dart';
