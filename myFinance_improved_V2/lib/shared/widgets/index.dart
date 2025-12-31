/// Shared Widgets Library
///
/// Organized by functional category:
/// - toss/      : Toss-style UI components (buttons, inputs, cards, etc.)
/// - common/    : Shared UI components (scaffolds, dialogs, state views)
/// - feedback/  : User communication (dialogs, states, indicators)
/// - overlays/  : Modal/overlay interactions (sheets, pickers, menus)
/// - navigation/: App structure & navigation
/// - calendar/  : Date/time specialized components
/// - keyboard/  : Custom keyboard modal system
/// - selectors/ : Autonomous data-fetching selectors (Account, CashLocation, etc.)
/// - domain/    : Business-specific widgets
/// - ai/        : AI display components
/// - ai_chat/   : AI Chat feature (mini-feature)
library;

// Toss widgets (Main UI components)
export 'toss/index.dart';

// Common widgets (Shared UI components)
export 'common/index.dart';

// Feedback widgets
export 'feedback/index.dart';

// Overlay widgets
export 'overlays/index.dart';

// Navigation widgets
export 'navigation/index.dart';

// Calendar widgets
export 'calendar/index.dart';

// Keyboard widgets
export 'keyboard/index.dart';

// Selector widgets (Autonomous - self-managing state)
export 'selectors/index.dart';

// Domain-specific widgets
export 'domain/index.dart';

// AI widgets
export 'ai/index.dart';
