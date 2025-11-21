/// Join Presentation Layer Providers
///
/// This file contains presentation-specific providers for join feature.
/// It only imports from Domain layer (Use Cases).
///
/// Following Clean Architecture:
/// - NO imports from Data layer
/// - Only Domain layer imports allowed
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/usecase_providers.dart';
import 'join_notifier.dart';
import 'states/join_state.dart';

// ============================================================================
// Presentation Layer Providers (UI State Management)
// ============================================================================

/// Join StateNotifier Provider
///
/// Manages join operations state for UI.
/// Uses JoinByCode use case from domain layer.
///
/// Usage:
/// ```dart
/// // Watch state
/// final joinState = ref.watch(joinNotifierProvider);
///
/// // Trigger action
/// ref.read(joinNotifierProvider.notifier).joinByCode(
///   userId: userId,
///   code: code,
/// );
///
/// // Reset state
/// ref.read(joinNotifierProvider.notifier).reset();
/// ```
final joinNotifierProvider = StateNotifierProvider<JoinNotifier, JoinState>((ref) {
  final joinByCode = ref.watch(joinByCodeUseCaseProvider);
  return JoinNotifier(joinByCode);
});
