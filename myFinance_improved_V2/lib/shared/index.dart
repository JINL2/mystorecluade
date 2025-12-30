/// MyFinance Shared Library
///
/// 모든 공용 위젯, 테마, 유틸리티를 단일 import로 사용할 수 있습니다.
///
/// ## Usage
/// ```dart
/// import 'package:myfinance_improved/shared/index.dart';
///
/// // 이제 모든 shared 리소스 사용 가능:
/// // - TossButton, TossPrimaryButton, TossDropdown 등 모든 위젯
/// // - TossColors, TossSpacing, TossTextStyles 등 모든 테마
/// // - EnhancedAccountSelector, AutonomousCashLocationSelector 등 셀렉터
/// // - StringExtensions 등 확장 함수
/// ```
///
/// ## 개별 Import가 필요한 경우
/// ```dart
/// // 테마만
/// import 'package:myfinance_improved/shared/themes/index.dart';
///
/// // 위젯만
/// import 'package:myfinance_improved/shared/widgets/index.dart';
/// ```
library;

// ═══════════════════════════════════════════════════════════════
// THEMES & DESIGN TOKENS
// ═══════════════════════════════════════════════════════════════
export 'themes/index.dart';

// ═══════════════════════════════════════════════════════════════
// WIDGETS
// ═══════════════════════════════════════════════════════════════
export 'widgets/index.dart';

// ═══════════════════════════════════════════════════════════════
// EXTENSIONS
// ═══════════════════════════════════════════════════════════════
export 'extensions/string_extensions.dart';

// ═══════════════════════════════════════════════════════════════
// UTILITIES (moved to core/utils/)
// ═══════════════════════════════════════════════════════════════
// Note: Utils have been consolidated to core/utils/
// Import directly from: import 'package:myfinance_improved/core/utils/...';
