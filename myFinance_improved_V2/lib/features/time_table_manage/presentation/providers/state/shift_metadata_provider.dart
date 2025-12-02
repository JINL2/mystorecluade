/// Shift Metadata Provider
///
/// Provides shift metadata (shift types, positions, tags) for a store.
/// Uses FutureProvider for automatic caching and error handling.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../../domain/usecases/get_shift_metadata.dart';
import '../usecase/time_table_usecase_providers.dart';

/// Shift Metadata Provider
///
/// Loads shift metadata for a given store ID.
/// Data is automatically cached by Riverpod's FutureProvider.
///
/// Usage:
/// ```dart
/// final metadataAsync = ref.watch(shiftMetadataProvider(storeId));
/// metadataAsync.when(
///   data: (metadata) => Text('Loaded: ${metadata.shiftTypes.length} types'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
///
/// To refresh:
/// ```dart
/// ref.invalidate(shiftMetadataProvider(storeId));
/// ```
final shiftMetadataProvider =
    FutureProvider.family<ShiftMetadata, String>((ref, storeId) async {
  if (storeId.isEmpty) {
    throw Exception('Store ID is required');
  }

  final useCase = ref.watch(getShiftMetadataUseCaseProvider);
  final appState = ref.watch(appStateProvider);
  // Use user's timezone from appState, fallback to device timezone (not UTC)
  final timezone = (appState.user['timezone'] as String?) ??
      DateTimeUtils.getLocalTimezone();

  return await useCase(GetShiftMetadataParams(
    storeId: storeId,
    timezone: timezone,
  ));
});
