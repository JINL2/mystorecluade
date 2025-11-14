/// Central export file for keyboard-aware components
/// Import this single file to get all keyboard-related widgets
library;

export '../toss_smart_action_bar.dart';
// Utilities
export 'keyboard_utils.dart';
export 'toss_numberpad_modal.dart';  // For number pad inputs with custom numberpad
// Core Components
export 'toss_textfield_keyboard_modal.dart';  // For text field inputs in modals


/// Quick import guide for migration:
/// 
/// ```dart
/// // Single import for all keyboard components
/// import '../../../widgets/toss/keyboard/index.dart';
/// 
/// // Now you can use:
/// // - TossTextFieldKeyboardModal - For text inputs in modals
/// // - TossNumberpadModal - Custom numberpad for number inputs
/// // - TossSmartActionBar
/// // - KeyboardUtils
/// ```