import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/themes/app_theme.dart';
import 'config/app_router.dart';

/// MyFinanceApp - Root widget of the application
///
/// Provides:
/// - MaterialApp router configuration
/// - Theme management
/// - App lifecycle handling
class MyFinanceApp extends ConsumerStatefulWidget {
  const MyFinanceApp({super.key});

  @override
  ConsumerState<MyFinanceApp> createState() => _MyFinanceAppState();
}

class _MyFinanceAppState extends ConsumerState<MyFinanceApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // Initialize app components after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.resumed) {
      // App came to foreground
      _handleAppResume();
    }
  }

  /// Initialize app components
  void _initializeApp() {
    // TODO: Initialize notifications when needed
    // ref.read(notificationProvider.notifier).initialize();
  }

  /// Handle app resume
  void _handleAppResume() {
    // TODO: Handle app resume logic
    // ref.read(notificationProvider.notifier).handleAppResume();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MyFinance',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'myfinance_app',

      // Global keyboard dismissal handler
      // Applies to ALL screens: TextField keyboards + custom modals (numberpad, etc.)
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Dismiss system keyboard (iOS/Android native keyboard)
            // This unfocuses any active TextField
            FocusManager.instance.primaryFocus?.unfocus();
          },
          // Allow underlying widgets to receive tap events
          behavior: HitTestBehavior.translucent,
          child: child,
        );
      },
    );
  }
}
