/// Autonomous Cash Location Selector (Compatibility Layer)
///
/// This file re-exports from the new modular structure for backward compatibility.
/// All classes are now in `cash_location/` folder.
///
/// ## Migration Guide
/// Old import:
/// ```dart
/// import '.../selectors/autonomous_cash_location_selector.dart';
/// ```
///
/// New import (recommended):
/// ```dart
/// import '.../selectors/cash_location/index.dart';
/// ```
///
/// ## Class Rename
/// - `AutonomousCashLocationSelector` -> `CashLocationSelector`
library;

// Re-export all cash location selector components for backward compatibility
export 'cash_location/index.dart';
