import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/join_remote_datasource.dart';
import 'package:myfinance_improved/features/homepage/data/repositories/join_repository_impl.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/join_repository.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/join_by_code.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/join_notifier.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/join_state.dart';

// ============================================================================
// Infrastructure Layer
// ============================================================================

/// Provides Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// Data Layer
// ============================================================================

/// Provides remote data source for join operations
final joinRemoteDataSourceProvider = Provider<JoinRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return JoinRemoteDataSourceImpl(supabaseClient);
});

/// Provides join repository implementation
final joinRepositoryProvider = Provider<JoinRepository>((ref) {
  final remoteDataSource = ref.watch(joinRemoteDataSourceProvider);
  return JoinRepositoryImpl(remoteDataSource);
});

// ============================================================================
// Domain Layer (Use Cases)
// ============================================================================

/// Provides JoinByCode use case
final joinByCodeUseCaseProvider = Provider<JoinByCode>((ref) {
  final repository = ref.watch(joinRepositoryProvider);
  return JoinByCode(repository);
});

// ============================================================================
// Presentation Layer (State Management)
// ============================================================================

/// Provides join state notifier
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
