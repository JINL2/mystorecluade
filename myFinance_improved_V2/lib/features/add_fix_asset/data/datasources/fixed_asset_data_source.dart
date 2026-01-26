import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fixed_asset_model.dart';

/// Fixed Asset Data Source
/// Supabase와 직접 통신하는 데이터 소스
class FixedAssetDataSource {
  final SupabaseClient _supabase;

  FixedAssetDataSource(this._supabase);

  /// 고정자산 목록 조회 (RPC 사용)
  Future<List<FixedAssetModel>> getFixedAssets({
    required String companyId,
    String? storeId,
  }) async {
    // storeId 매핑:
    // null -> 본사 자산 (store_id IS NULL)
    // "" (empty) -> 전체 자산
    // "uuid" -> 특정 매장 자산
    final includeAllStores = storeId != null && storeId.isEmpty;
    final actualStoreId =
        (storeId == null || storeId.isEmpty) ? null : storeId;

    final response = await _supabase.rpc<List<dynamic>>(
      'add_fix_asset_get_fixed_assets',
      params: {
        'p_company_id': companyId,
        'p_store_id': actualStoreId,
        'p_include_all_stores': includeAllStores,
      },
    );

    return response
        .map((json) => FixedAssetModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 고정자산 추가 (RPC 사용)
  Future<String> createFixedAsset({
    required FixedAssetModel model,
    required String timezone,
  }) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'add_fix_asset_manage_fixed_asset',
      params: {
        'p_operation': 'insert',
        'p_company_id': model.companyId,
        'p_store_id': model.storeId,
        'p_account_id': model.accountId,
        'p_asset_name': model.assetName,
        'p_acquisition_date': model.acquisitionDate,
        'p_acquisition_cost': model.acquisitionCost,
        'p_salvage_value': model.salvageValue,
        'p_useful_life_years': model.usefulLifeYears,
        'p_timezone': timezone,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to create asset');
    }

    return response['asset_id'] as String;
  }

  /// 고정자산 수정 (RPC 사용)
  Future<void> updateFixedAsset({
    required FixedAssetModel model,
    required String timezone,
  }) async {
    if (model.assetId == null) {
      throw Exception('Asset ID is required for update');
    }

    final response = await _supabase.rpc<Map<String, dynamic>>(
      'add_fix_asset_manage_fixed_asset',
      params: {
        'p_operation': 'update',
        'p_asset_id': model.assetId,
        'p_company_id': model.companyId,
        'p_store_id': model.storeId,
        'p_account_id': model.accountId,
        'p_asset_name': model.assetName,
        'p_acquisition_date': model.acquisitionDate,
        'p_acquisition_cost': model.acquisitionCost,
        'p_salvage_value': model.salvageValue,
        'p_useful_life_years': model.usefulLifeYears,
        'p_timezone': timezone,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update asset');
    }
  }

  /// 고정자산 삭제 (RPC 사용 - Soft Delete)
  Future<void> deleteFixedAsset({
    required String assetId,
    required String companyId,
    required String timezone,
  }) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'add_fix_asset_manage_fixed_asset',
      params: {
        'p_operation': 'delete',
        'p_asset_id': assetId,
        'p_company_id': companyId,
        'p_timezone': timezone,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete asset');
    }
  }

  /// 회사 기본 통화 정보 조회 (RPC 사용)
  /// Returns: {currencyId, symbol}
  Future<({String? currencyId, String symbol})> getBaseCurrencyInfo(
    String companyId,
  ) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'get_base_currency',
        params: {'p_company_id': companyId},
      );

      final baseCurrency = response['base_currency'] as Map<String, dynamic>?;
      if (baseCurrency == null) {
        return (currencyId: null, symbol: '\$');
      }

      return (
        currencyId: baseCurrency['currency_id'] as String?,
        symbol: baseCurrency['symbol'] as String? ?? '\$',
      );
    } catch (e) {
      return (currencyId: null, symbol: '\$');
    }
  }
}
