/// Store Presentation Layer Providers
///
/// This file contains presentation-specific providers for store feature.
/// It only imports from Domain layer (Use Cases).
///
/// Following Clean Architecture:
/// - NO imports from Data layer
/// - Only Domain layer imports allowed
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/usecase_providers.dart';
import 'states/store_state.dart';
import 'store_notifier.dart';

// ============================================================================
// Presentation Layer Providers (UI State Management)
// ============================================================================

/// Store StateNotifier Provider
///
/// Manages store creation state for UI.
/// Uses CreateStore use case from domain layer.
final storeNotifierProvider =
    StateNotifierProvider<StoreNotifier, StoreState>((ref) {
  final createStore = ref.watch(createStoreUseCaseProvider);
  return StoreNotifier(createStore);
});
