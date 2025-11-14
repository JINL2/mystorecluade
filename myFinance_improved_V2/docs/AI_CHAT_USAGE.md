# AI Chat Integration Guide

## Overview

The AI Chat feature is a **core service** available across all pages in the application. It provides context-aware AI assistance using Supabase Edge Functions and maintains conversation history in the database.

## Architecture

### Location
- **Business Logic & Data**: `lib/core/ai_chat/`
- **UI Components**: `lib/shared/widgets/ai_chat/`

### Structure
```
lib/
├── core/ai_chat/                        # Core AI Chat Service
│   ├── domain/
│   │   ├── entities/
│   │   │   └── chat_message.dart        # ChatMessage entity
│   │   ├── repositories/
│   │   │   └── ai_chat_repository.dart  # Repository interface
│   │   └── usecases/
│   │       ├── send_chat_message.dart   # Send message to AI
│   │       ├── save_message_to_history.dart
│   │       └── load_chat_history.dart   # Load previous messages
│   ├── data/
│   │   ├── models/
│   │   │   ├── chat_message_model.dart
│   │   │   └── chat_response_model.dart
│   │   ├── datasources/
│   │   │   ├── ai_chat_remote_datasource.dart  # Edge Function calls
│   │   │   └── ai_chat_local_datasource.dart   # Database operations
│   │   └── repositories/
│   │       └── ai_chat_repository_impl.dart
│   └── presentation/
│       └── providers/
│           ├── ai_chat_providers.dart   # Riverpod providers
│           └── states/
│               └── ai_chat_state.dart   # Chat state management
│
└── shared/widgets/ai_chat/              # Reusable UI Components
    ├── ai_chat_fab.dart                 # Floating Action Button
    ├── ai_chat_bottom_sheet.dart        # Chat interface
    ├── chat_bubble.dart                 # Message bubble
    ├── chat_input_field.dart            # Input field
    └── typing_indicator.dart            # Loading animation
```

---

## How to Integrate AI Chat in Any Page

### Step 1: Generate Session ID in Page State

The session ID should be generated **once per page lifecycle** to maintain conversation continuity even when the chat is closed and reopened.

```dart
import 'package:uuid/uuid.dart';

class YourPageState extends State<YourPage> {
  late final String _aiChatSessionId;

  @override
  void initState() {
    super.initState();

    // Generate AI Chat session ID - persists for entire page lifecycle
    _aiChatSessionId = const Uuid().v4();
  }
}
```

### Step 2: Add the AI Chat FAB

Import and use the `AiChatFab` widget in your page's `floatingActionButton`:

```dart
import '../../../shared/widgets/ai_chat/ai_chat_fab.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Your Page')),
    body: YourPageContent(),
    floatingActionButton: AiChatFab(
      featureName: 'Your Feature Name',      // e.g., 'Time Table Manage'
      sessionId: _aiChatSessionId,           // Pass page-level session ID
      featureId: _yourFeatureId,             // Optional: for context filtering
      pageContext: _buildPageContext(),       // Optional: current page data
    ),
  );
}
```

### Step 3: Provide Page Context (Optional but Recommended)

Create a method to build context data that will be sent to the AI:

```dart
Map<String, dynamic> _buildPageContext() {
  return {
    'current_date': _selectedDate.toString(),
    'user_role': _currentUserRole,
    'selected_filters': _selectedFilters,
    // Add any relevant page state
  };
}
```

---

## Example: Time Table Manage Integration

Full example from `lib/features/time_table_manage/presentation/pages/time_table_manage_page.dart`:

```dart
import 'package:uuid/uuid.dart';
import '../../../../shared/widgets/ai_chat/ai_chat_fab.dart';

class _TimeTableManagePageState extends State<TimeTableManagePage> {
  late final String _aiChatSessionId;
  String? _featureId;
  String? _featureName;

  @override
  void initState() {
    super.initState();

    // Generate AI Chat session ID - persists for entire page lifecycle
    _aiChatSessionId = const Uuid().v4();

    // Load feature info from QuickAccess
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments
          as Map<String, dynamic>?;

      if (args != null) {
        setState(() {
          _featureId = args['featureId'] as String?;
          _featureName = args['featureName'] as String?;
        });
      }
    });
  }

  Map<String, dynamic> _buildPageContext() {
    final ref = context.read;
    final selectedDate = ref.watch(selectedDateProvider);
    final currentTab = ref.watch(currentTabProvider);

    return {
      'selected_date': selectedDate.toString(),
      'current_tab': currentTab.toString(),
      'view_mode': 'time_table_management',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Table Manage')),
      body: TimeTableContent(),
      floatingActionButton: AiChatFab(
        featureName: _featureName ?? 'Time Table Manage',
        pageContext: _buildPageContext(),
        featureId: _featureId,
        sessionId: _aiChatSessionId,  // Pass page-level session ID
      ),
    );
  }
}
```

---

## Features

### 1. **Session Persistence**
- Session ID is generated at **page level**, not widget level
- Chat history persists when Bottom Sheet is closed and reopened
- New session starts when user navigates away and returns to the page

### 2. **Chat History Loading**
- When Bottom Sheet opens, automatically loads previous messages from database
- Shows loading indicator: "Loading chat history..."
- Displays empty state if no previous messages: "Ask about [Feature Name]"

### 3. **Context-Aware Responses**
- Sends `featureName` to help AI understand the context
- Sends `pageContext` with current page state (filters, dates, etc.)
- Sends `featureId` for database context filtering

### 4. **Markdown Support**
- AI responses support full markdown formatting
- Tables are horizontally scrollable on mobile
- Code blocks, lists, headers, and bold/italic text are styled

### 5. **Database Integration**
- All messages are automatically saved to `ai_chat_history` table
- Messages are filtered by `session_id` for history loading
- Supports multiple concurrent sessions across different pages

---

## Parameters

### AiChatFab Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `featureName` | `String` | ✅ Yes | Display name of the feature (e.g., "Time Table Manage") |
| `sessionId` | `String` | ✅ Yes | Unique session ID generated at page level |
| `featureId` | `String?` | ❌ No | Feature ID from QuickAccess for context filtering |
| `pageContext` | `Map<String, dynamic>?` | ❌ No | Current page state/data to provide AI context |

### Edge Function Parameters (Sent Automatically)

The provider automatically sends these to the Edge Function:

```dart
{
  'question': 'User message',
  'company_id': 'xxx',
  'store_id': 'xxx',
  'session_id': 'xxx',
  'current_date': '2025-11-09',
  'timezone': 'Asia/Seoul',
  'feature_id': 'optional_feature_id'
}
```

---

## State Management

### AiChatState

```dart
class AiChatState {
  final List<ChatMessage> messages;      // All messages in session
  final bool isLoading;                  // AI is typing
  final bool isLoadingHistory;           // Loading previous messages
  final String? error;                   // Error message if any
  final String sessionId;                // Current session ID
}
```

### ChatMessage Entity

```dart
class ChatMessage {
  final String id;              // Unique message ID
  final String content;         // Message text
  final bool isUser;            // true = user, false = AI
  final DateTime timestamp;     // When message was sent
  final int? iterations;        // AI iterations (for AI messages)
}
```

---

## Database Schema

### ai_chat_history Table

```sql
CREATE TABLE ai_chat_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id TEXT NOT NULL,
  company_id TEXT NOT NULL,
  store_id TEXT NOT NULL,
  feature_id TEXT,
  message JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast session lookups
CREATE INDEX idx_ai_chat_history_session
  ON ai_chat_history(session_id);
```

### Message JSONB Structure

```json
{
  "role": "user" | "assistant",
  "content": "Message text",
  "timestamp": "2025-11-09T10:30:00.000Z",
  "iterations": 3  // Only for AI messages
}
```

---

## UI Components

### 1. AiChatFab
- **Purpose**: Floating action button to open chat
- **Icon**: Smart toy icon (AI assistant)
- **Action**: Opens `AiChatBottomSheet`

### 2. AiChatBottomSheet
- **Type**: Draggable bottom sheet
- **Size**: 90% of screen (adjustable from 50% to 95%)
- **Header**: Shows "AI Assistant" + feature name
- **States**:
  - **Loading History**: Circular progress + "Loading chat history..."
  - **Empty**: Chat icon + "Ask about [Feature]"
  - **Messages**: Scrollable list of chat bubbles
- **Input**: Text field at bottom with send button

### 3. ChatBubble
- **User Messages**: Blue background, right-aligned
- **AI Messages**: Gray background, left-aligned, markdown rendered
- **Styling**: Toss Design System colors and spacing

### 4. TypingIndicator
- **Purpose**: Shows AI is processing
- **Display**: Three bouncing dots animation

### 5. ChatInputField
- **Features**:
  - Multi-line text input
  - Send button (disabled when loading)
  - Auto-clears after sending

---

## Best Practices

### 1. Session Management
✅ **DO**: Generate session ID in `initState()` at page level
```dart
late final String _aiChatSessionId;

@override
void initState() {
  super.initState();
  _aiChatSessionId = const Uuid().v4();
}
```

❌ **DON'T**: Generate session ID in widget build or in provider
```dart
// BAD - creates new session every rebuild
floatingActionButton: AiChatFab(
  sessionId: const Uuid().v4(),  // ❌ Wrong!
)
```

### 2. Provide Meaningful Context
✅ **DO**: Include relevant page state
```dart
Map<String, dynamic> _buildPageContext() {
  return {
    'selected_date': _selectedDate.toString(),
    'filters': _activeFilters,
    'current_view': _viewMode,
  };
}
```

❌ **DON'T**: Send too much or sensitive data
```dart
// BAD - too much data, includes sensitive info
return {
  'entire_database': await fetchAll(),  // ❌ Too much
  'user_password': user.password,       // ❌ Sensitive
};
```

### 3. Feature Naming
✅ **DO**: Use clear, user-friendly names
```dart
featureName: 'Time Table Management'
featureName: 'Employee Attendance'
featureName: 'Cash Location Tracking'
```

❌ **DON'T**: Use technical/code names
```dart
featureName: 'time_table_manage'  // ❌ Not user-friendly
featureName: 'TTM Module'         // ❌ Too technical
```

---

## Troubleshooting

### Chat history not showing when reopening
**Cause**: Session ID is being regenerated
**Solution**: Ensure session ID is `late final` in page state, not generated in build

### Messages not saved to database
**Cause**: Missing company_id or store_id
**Solution**: Verify `AppState` provider has valid company/store IDs

### AI not responding
**Cause**: Edge Function error or network issue
**Solution**: Check Supabase Edge Function logs and network connection

### Table rendering broken on mobile
**Cause**: Table too wide for screen
**Solution**: Already handled - tables are horizontally scrollable via `SingleChildScrollView`

---

## Testing Checklist

When integrating AI Chat in a new page:

- [ ] Session ID generated in `initState()` as `late final`
- [ ] Session ID passed to `AiChatFab`
- [ ] Feature name is user-friendly and descriptive
- [ ] Page context includes relevant state (if applicable)
- [ ] Chat opens when FAB is clicked
- [ ] Messages are sent and displayed correctly
- [ ] Chat history loads when reopening Bottom Sheet
- [ ] Loading states display properly (history loading, AI typing)
- [ ] Markdown renders correctly (including tables)
- [ ] Messages are saved to database
- [ ] Session persists when closing/reopening chat
- [ ] New session starts when navigating away and back

---

## Future Enhancements

### Potential Features
- [ ] Multi-language support (currently English-only UI)
- [ ] Voice input/output
- [ ] File/image attachment support
- [ ] Export chat history as PDF
- [ ] Search within chat history
- [ ] Pin important messages
- [ ] Share chat sessions between users
- [ ] AI-suggested actions based on conversation

---

## Support

For issues or questions:
1. Check this documentation
2. Review example implementation in `time_table_manage_page.dart`
3. Check Supabase Edge Function logs for backend errors
4. Verify database schema matches expected structure

---

**Last Updated**: 2025-11-09
**Version**: 1.0.0
