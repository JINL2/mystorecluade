/// AI Chat - Clean Architecture Module
///
/// A shared AI chat widget that can be used across all pages in the app.
/// Provides SSE streaming chat functionality with Supabase Edge Functions.
///
/// Usage:
/// ```dart
/// import 'package:myfinance/shared/widgets/ai_chat/ai_chat.dart';
///
/// // Add FAB to any page
/// AiChatFab(
///   featureName: 'CashLocation',
///   pageContext: {'account_id': '123'},
/// )
///
/// // Or show bottom sheet directly
/// AiChatBottomSheet.show(context, featureName: 'JournalInput');
/// ```
library ai_chat;

// Domain - Models
export 'domain/models/ai_event.dart';
export 'domain/models/chat_message.dart';

// Data - Services
export 'data/services/ai_chat_service.dart';

// Presentation - Providers
export 'presentation/providers/ai_chat_provider.dart';
export 'presentation/providers/ai_chat_state.dart';

// Presentation - Widgets
export 'presentation/widgets/ai_chat_bottom_sheet.dart';
export 'presentation/widgets/ai_chat_fab.dart';
export 'presentation/widgets/chat_bubble.dart';
export 'presentation/widgets/chat_input_field.dart';
export 'presentation/widgets/result_data_card.dart';
export 'presentation/widgets/typing_indicator.dart';
