import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Add this button to your homepage or any page for easy access to debug dashboard
class TestNotificationButton extends StatelessWidget {
  const TestNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Navigate to test page (notification debug)
        context.go('/test');
      },
      backgroundColor: Colors.orange,
      child: const Icon(Icons.notifications_active),
      heroTag: 'notification_test',
    );
  }
}