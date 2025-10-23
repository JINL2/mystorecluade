import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/fixed_asset_data_source.dart';
import '../../data/repositories/fixed_asset_repository_impl.dart';
import '../../domain/entities/fixed_asset.dart';
import '../../domain/repositories/fixed_asset_repository.dart';

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Data Source Provider
final fixedAssetDataSourceProvider = Provider<FixedAssetDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FixedAssetDataSource(supabase);
});

/// Repository Provider
final fixedAssetRepositoryProvider = Provider<FixedAssetRepository>((ref) {
  final dataSource = ref.watch(fixedAssetDataSourceProvider);
  return FixedAssetRepositoryImpl(dataSource);
});

/// 고정자산 목록 조회 Provider
final fixedAssetsProvider = FutureProvider.family<List<FixedAsset>, FixedAssetListParams>((ref, params) async {
  final repository = ref.watch(fixedAssetRepositoryProvider);
  return await repository.getFixedAssets(
    companyId: params.companyId,
    storeId: params.storeId,
  );
});

/// 회사 기본 통화 Provider
final companyBaseCurrencyProvider = FutureProvider.family<String?, String>((ref, companyId) async {
  final repository = ref.watch(fixedAssetRepositoryProvider);
  return await repository.getCompanyBaseCurrency(companyId);
});

/// 통화 심볼 Provider
final currencySymbolProvider = FutureProvider.family<String, String>((ref, currencyId) async {
  final repository = ref.watch(fixedAssetRepositoryProvider);
  return await repository.getCurrencySymbol(currencyId);
});

/// 고정자산 생성 Provider
final createFixedAssetProvider = FutureProvider.family<void, FixedAsset>((ref, asset) async {
  final repository = ref.watch(fixedAssetRepositoryProvider);
  await repository.createFixedAsset(asset);

  // Invalidate list to refresh
  ref.invalidate(fixedAssetsProvider);
});

/// 고정자산 수정 Provider
final updateFixedAssetProvider = FutureProvider.family<void, FixedAsset>((ref, asset) async {
  final repository = ref.watch(fixedAssetRepositoryProvider);
  await repository.updateFixedAsset(asset);

  // Invalidate list to refresh
  ref.invalidate(fixedAssetsProvider);
});

/// 고정자산 삭제 Provider
final deleteFixedAssetProvider = FutureProvider.family<void, String>((ref, assetId) async {
  final repository = ref.watch(fixedAssetRepositoryProvider);
  await repository.deleteFixedAsset(assetId);

  // Invalidate list to refresh
  ref.invalidate(fixedAssetsProvider);
});

/// Parameters class for fixed asset list
class FixedAssetListParams {
  final String companyId;
  final String? storeId;

  const FixedAssetListParams({
    required this.companyId,
    this.storeId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FixedAssetListParams &&
        other.companyId == companyId &&
        other.storeId == storeId;
  }

  @override
  int get hashCode => companyId.hashCode ^ storeId.hashCode;
}
