/// Legacy Widget Re-exports
///
/// ⚠️ DEPRECATED: 이 폴더의 import는 하위 호환성을 위해서만 유지됩니다.
/// 새로운 코드에서는 Atomic Design 구조를 사용하세요:
/// ```dart
/// // OLD (deprecated)
/// import 'package:myfinance_improved/shared/widgets/_legacy/toss/toss_button.dart';
/// import 'package:myfinance_improved/shared/widgets/_legacy/common/toss_loading_view.dart';
/// // NEW (recommended)
/// import 'package:myfinance_improved/shared/widgets/index.dart';
/// // 또는 직접 경로:
/// import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';
/// ```
/// 이 폴더는 기존 코드의 import 경로를 새로운 위치로 re-export합니다.
/// 삭제하면 기존 코드가 깨집니다.
library;

// Legacy re-exports
export 'toss/index.dart';
export 'common/index.dart';
export 'feedback/index.dart';
export 'overlays/index.dart';
export 'navigation/index.dart';
export 'calendar/index.dart';
export 'keyboard/index.dart';
export 'domain/index.dart';
