/// Shared Widgets Library - Atomic Design Structure
///
/// Organized by Atomic Design pattern:
/// - atoms/      : Basic building blocks (buttons, inputs, display, feedback, layout)
/// - molecules/  : Combinations of atoms (dropdowns, cards, navigation, menus)
/// - organisms/  : Complex UI sections (dialogs, sheets, pickers, calendars, selectors)
/// - templates/  : Page layouts (scaffold)
/// - ai/         : AI display components
/// - ai_chat/    : AI Chat feature (mini-feature)
library;

// Models - Shared data models for widgets
export '../models/selection_item.dart';

// Atomic Design - Atoms (smallest components)
export 'atoms/index.dart';

// Atomic Design - Molecules (atom combinations)
export 'molecules/index.dart';

// Atomic Design - Organisms (complex UI sections)
export 'organisms/index.dart';

// Atomic Design - Templates (page layouts)
export 'templates/index.dart';

// Selector widgets (Autonomous - self-managing state)
export 'selectors/index.dart';

// AI widgets
export 'ai/index.dart';
