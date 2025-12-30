/// Autonomous Counterparty Selector (Compatibility Layer)
///
/// This file re-exports from the new modular structure for backward compatibility.
/// All classes are now in `counterparty/` folder.
///
/// ## Migration Guide
/// Old import:
/// ```dart
/// import '.../selectors/autonomous_counterparty_selector.dart';
/// ```
///
/// New import (recommended):
/// ```dart
/// import '.../selectors/counterparty/index.dart';
/// ```
///
/// ## Class Rename
/// - `AutonomousCounterpartySelector` -> `CounterpartySelector`
/// - `AutonomousMultiCounterpartySelector` -> `CounterpartyMultiSelector`
library;

// Re-export all counterparty selector components for backward compatibility
export 'counterparty/index.dart';
