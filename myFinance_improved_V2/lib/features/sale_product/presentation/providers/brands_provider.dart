import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/sale_product_providers.dart';
import '../../domain/entities/brand.dart';

// Re-export Brand entity for consumers
export '../../domain/entities/brand.dart';

/// Provider to fetch all brands using Repository pattern
final brandsProvider = FutureProvider<List<Brand>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) return [];

  final repository = ref.watch(brandsRepositoryProvider);
  return repository.getBrands(companyId: companyId);
});
