/// Base Selector Widgets (Compatibility Layer)
///
/// This file re-exports from the new modular structure for backward compatibility.
/// All classes are now in `base/` folder.
///
/// ## Migration Guide
/// Old import:
/// ```dart
/// import '.../selectors/toss_base_selector.dart';
/// ```
///
/// New import (recommended):
/// ```dart
/// import '.../selectors/base/index.dart';
/// ```
library;

// Re-export all base selector components for backward compatibility
export 'base/index.dart';
