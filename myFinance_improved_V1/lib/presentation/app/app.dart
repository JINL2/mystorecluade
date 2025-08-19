import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/themes/app_theme.dart';
import '../providers/notification_provider.dart';
import 'app_router.dart';

class MyFinanceApp extends ConsumerStatefulWidget {
  const MyFinanceApp({super.key});

  @override
  ConsumerState<MyFinanceApp> createState() => _MyFinanceAppState();
}

class _MyFinanceAppState extends ConsumerState<MyFinanceApp> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'MyFinance',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'myfinance_app',
    );
  }
}