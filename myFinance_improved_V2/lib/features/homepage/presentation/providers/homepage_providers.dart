/// Homepage Providers Barrel File
///
/// Re-exports all homepage-related providers for backward compatibility.
/// This file was previously a God Provider (502 lines) and has been split into:
/// - user_companies_providers.dart (session & user data)
/// - revenue_providers.dart (revenue & period)
/// - feature_providers.dart (categories & quick access)
/// - alert_providers.dart (version check & alerts)
/// - company_providers.dart (company types & currencies)
///
/// Import this file to access all providers, or import specific files
/// for better tree-shaking and faster builds.
library;

// Re-export all providers for backward compatibility
export 'user_companies_providers.dart';
export 'revenue_providers.dart';
export 'feature_providers.dart';
export 'alert_providers.dart';

// Note: company_providers.dart is already separate and should be imported directly
// when needed for company types and currencies.
