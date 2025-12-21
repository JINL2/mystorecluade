# AI Chat Quick Start Guide

**5-Minute Integration Guide** for adding AI Chat to any page.

---

## Step 1: Import (1 line)

```dart
import '../../../shared/widgets/ai_chat/ai_chat_fab.dart';
import 'package:uuid/uuid.dart';
```

---

## Step 2: Add Session ID to State (2 lines)

```dart
class _YourPageState extends State<YourPage> {
  late final String _aiChatSessionId;  // Add this

  @override
  void initState() {
    super.initState();
    _aiChatSessionId = const Uuid().v4();  // Add this
  }
}
```

---

## Step 3: Add FAB (5 lines)

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(...),
    body: YourContent(),
    floatingActionButton: AiChatFab(           // Add this
      featureName: 'Your Feature Name',        // Add this
      sessionId: _aiChatSessionId,             // Add this
    ),                                         // Add this
  );
}
```

---

## Done! 🎉

That's it - AI Chat is now available on your page.

---

## Optional: Add Page Context

If you want AI to have context about the page:

```dart
floatingActionButton: AiChatFab(
  featureName: 'Your Feature Name',
  sessionId: _aiChatSessionId,
  pageContext: {                      // Optional
    'date': _selectedDate.toString(),
    'filter': _currentFilter,
  },
),
```

---

## Optional: Add Feature ID

If your page receives `featureId` from QuickAccess:

```dart
class _YourPageState extends State<YourPage> {
  String? _featureId;

  @override
  void initState() {
    super.initState();
    _aiChatSessionId = const Uuid().v4();

    // Get feature ID from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments
          as Map<String, dynamic>?;
      if (args != null) {
        setState(() => _featureId = args['featureId']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      floatingActionButton: AiChatFab(
        featureName: 'Your Feature Name',
        sessionId: _aiChatSessionId,
        featureId: _featureId,  // Optional
      ),
    );
  }
}
```

---

## Full Example

```dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/widgets/ai_chat/ai_chat_fab.dart';

class YourPage extends StatefulWidget {
  const YourPage({super.key});

  @override
  State<YourPage> createState() => _YourPageState();
}

class _YourPageState extends State<YourPage> {
  late final String _aiChatSessionId;
  String? _featureId;

  @override
  void initState() {
    super.initState();
    _aiChatSessionId = const Uuid().v4();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments
          as Map<String, dynamic>?;
      if (args != null) {
        setState(() => _featureId = args['featureId']);
      }
    });
  }

  Map<String, dynamic> _buildPageContext() {
    return {
      'current_date': DateTime.now().toString(),
      'view_mode': 'example',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Page'),
      ),
      body: const Center(
        child: Text('Your content here'),
      ),
      floatingActionButton: AiChatFab(
        featureName: 'Your Feature Name',
        sessionId: _aiChatSessionId,
        featureId: _featureId,
        pageContext: _buildPageContext(),
      ),
    );
  }
}
```

---

## What You Get

✅ AI chat button in bottom-right corner
✅ Chat opens in bottom sheet when clicked
✅ Previous conversations load automatically
✅ Messages saved to database
✅ Context-aware AI responses
✅ Markdown support (tables, lists, code, etc.)
✅ Loading states and error handling

---

## Need More Details?

See [AI_CHAT_USAGE.md](./AI_CHAT_USAGE.md) for comprehensive documentation.

---

## Common Mistakes

❌ **Don't** generate session ID in build:
```dart
// BAD
floatingActionButton: AiChatFab(
  sessionId: const Uuid().v4(),  // ❌ Creates new session every build
)
```

✅ **Do** generate in initState:
```dart
// GOOD
late final String _aiChatSessionId;

@override
void initState() {
  super.initState();
  _aiChatSessionId = const Uuid().v4();  // ✅ Once per page lifecycle
}
```

---

**Total Time**: ~5 minutes
**Total Lines Added**: ~10 lines
**Complexity**: Beginner-friendly

Happy coding! 🚀
