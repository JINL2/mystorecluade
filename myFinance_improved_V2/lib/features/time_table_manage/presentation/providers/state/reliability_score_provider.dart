/// Reliability Score Provider
///
/// Provides reliability score data (shift summary, understaffed shifts, employees)
/// for a store. Uses FutureProvider for automatic caching and error handling.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/reliability_score.dart';
import '../../../domain/usecases/get_reliability_score.dart';
import '../usecase/time_table_usecase_providers.dart';

/// Reliability Score Provider
///
/// Loads reliability score data for a given store ID.
/// Uses device local time and timezone (no conversion).
///
/// Usage:
/// ```dart
/// final reliabilityAsync = ref.watch(reliabilityScoreProvider(storeId));
/// reliabilityAsync.when(
///   data: (score) => Text('Late shifts: ${score.shiftSummary.thisMonth.lateCount}'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
///
/// To refresh:
/// ```dart
/// ref.invalidate(reliabilityScoreProvider(storeId));
/// ```
final reliabilityScoreProvider =
    FutureProvider.family<ReliabilityScore, String>((ref, storeId) async {
  if (storeId.isEmpty) {
    throw Exception('Store ID is required');
  }

  final useCase = ref.watch(getReliabilityScoreUseCaseProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  // Use device local timezone (no conversion - send as-is)
  final timezone = DateTimeUtils.getLocalTimezone();

  // Use device local time in "yyyy-MM-dd HH:mm:ss" format (no timezone conversion)
  final now = DateTime.now();
  final time = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  // 🔷 DEBUG: Log provider initialization
  debugPrint('🔷 [reliabilityScoreProvider] Fetching:');
  debugPrint('   companyId (from appState.companyChoosen): $companyId');
  debugPrint('   storeId (family param): $storeId');
  debugPrint('   time: $time');
  debugPrint('   timezone: $timezone');

  return await useCase(
    GetReliabilityScoreParams(
      companyId: companyId,
      storeId: storeId,
      time: time,
      timezone: timezone,
    ),
  );
});
