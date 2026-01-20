import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../discrepancy/di/discrepancy_providers.dart';
import '../../optimization/presentation/providers/inventory_optimization_providers.dart';
import '../../sales/presentation/providers/sales_di_provider.dart';
import '../../supply_chain/di/supply_chain_providers.dart';
import '../data/repositories/hub_repository_impl.dart';
import '../domain/repositories/hub_repository.dart';

/// Hub Repository Provider
/// 4개의 분석 시스템 repository를 조합
final hubRepositoryProvider = Provider<HubRepository>((ref) {
  return HubRepositoryImpl(
    salesRepository: ref.watch(salesRepositoryProvider),
    inventoryRepository: ref.watch(inventoryOptimizationRepositoryProvider),
    supplyChainRepository: ref.watch(supplyChainRepositoryProvider),
    discrepancyRepository: ref.watch(discrepancyRepositoryProvider),
  );
});
