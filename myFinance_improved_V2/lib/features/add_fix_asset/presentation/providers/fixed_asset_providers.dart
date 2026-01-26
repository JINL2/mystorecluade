import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/fixed_asset_injection.dart';
import 'fixed_asset_notifier.dart';
import 'states/fixed_asset_state.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 State Notifier Providers (Presentation Layer)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Clean Architecture: Presentation → Domain (via DI)
/// No direct Data layer imports in this file.

/// Fixed Asset Provider - 메인 상태 관리
final fixedAssetProvider =
    StateNotifierProvider<FixedAssetNotifier, FixedAssetState>((ref) {
  return FixedAssetNotifier(
    repository: ref.watch(fixedAssetRepositoryProvider),
  );
});

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Helper Providers (Computed/Utility)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 회사 기본 통화 정보 Provider (RPC 사용)
final baseCurrencyInfoProvider =
    FutureProvider.family<({String? currencyId, String symbol}), String>(
        (ref, companyId) async {
  final repository = ref.watch(fixedAssetRepositoryProvider);
  return await repository.getBaseCurrencyInfo(companyId);
});
