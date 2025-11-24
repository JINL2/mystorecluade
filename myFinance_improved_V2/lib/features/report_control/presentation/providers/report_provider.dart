// lib/features/report_control/presentation/providers/report_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ Clean Architecture: Presentation only imports Domain and DI
import '../../di/report_control_providers.dart';
import 'report_notifier.dart';
import 'report_state.dart';

/// Provider for ReportNotifier (State Management)
///
/// Clean Architecture Compliance:
/// - Only depends on Domain interface (ReportRepository)
/// - Gets concrete implementation from DI container
/// - No direct Data layer dependencies
final reportProvider =
    StateNotifierProvider<ReportNotifier, ReportState>((ref) {
  final repository = ref.watch(reportRepositoryProvider);
  return ReportNotifier(repository);
});
