// lib/app/providers/app_state_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_state.dart';
import 'app_state_notifier.dart';

/// App State Provider
///
/// Provides global app state using the Freezed AppState class
/// and AppStateNotifier for state management.
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});
