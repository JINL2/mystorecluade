/// Enhanced Account Selector (Compatibility Layer)
///
/// This file re-exports from the new modular structure for backward compatibility.
/// All classes are now in `account/` folder.
///
/// ## Migration Guide
/// Old import:
/// ```dart
/// import '.../selectors/enhanced_account_selector.dart';
/// ```
///
/// New import (recommended):
/// ```dart
/// import '.../selectors/account/index.dart';
/// ```
///
/// ## Class Rename
/// - `EnhancedAccountSelector` -> `AccountSelector`
library;

// Re-export all account selector components for backward compatibility
export 'account/index.dart';
