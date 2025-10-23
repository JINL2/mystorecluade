import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fixed_asset_model.dart';

/// Fixed Asset Data Source
/// Supabase와 직접 통신하는 데이터 소스
class FixedAssetDataSource {
  final SupabaseClient _supabase;

  FixedAssetDataSource(this._supabase);

  /// 고정자산 목록 조회
  Future<List<FixedAssetModel>> getFixedAssets({
    required String companyId,
    String? storeId,
  }) async {
    var query = _supabase
        .from('fixed_assets')
        .select('asset_id, asset_name, acquisition_date, acquisition_cost, useful_life_years, salvage_value, company_id, store_id, created_at, status')
        .eq('company_id', companyId);

    // Store filter
    if (storeId == null) {
      // Headquarters - filter for null store_id
      query = query.isFilter('store_id', null);
    } else if (storeId.isNotEmpty) {
      // Specific store
      query = query.eq('store_id', storeId);
    }
    // If storeId is empty string, no filter = all stores

    final response = await query.order('acquisition_date', ascending: false);

    return (response as List)
        .map((json) => FixedAssetModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 고정자산 단일 조회
  Future<FixedAssetModel?> getFixedAssetById(String assetId) async {
    final response = await _supabase
        .from('fixed_assets')
        .select()
        .eq('asset_id', assetId)
        .maybeSingle();

    if (response == null) return null;

    return FixedAssetModel.fromJson(response);
  }

  /// 고정자산 추가
  Future<void> createFixedAsset(FixedAssetModel model) async {
    await _supabase.from('fixed_assets').insert(model.toJson());
  }

  /// 고정자산 수정
  Future<void> updateFixedAsset(FixedAssetModel model) async {
    if (model.assetId == null) {
      throw Exception('Asset ID is required for update');
    }

    await _supabase
        .from('fixed_assets')
        .update(model.toJson())
        .eq('asset_id', model.assetId!);
  }

  /// 고정자산 삭제
  Future<void> deleteFixedAsset(String assetId) async {
    await _supabase.from('fixed_assets').delete().eq('asset_id', assetId);
  }

  /// 회사 기본 통화 조회
  Future<String?> getCompanyBaseCurrency(String companyId) async {
    final response = await _supabase
        .from('companies')
        .select('base_currency_id')
        .eq('company_id', companyId)
        .maybeSingle();

    return response?['base_currency_id'] as String?;
  }

  /// 통화 심볼 조회
  Future<String> getCurrencySymbol(String currencyId) async {
    try {
      final response = await _supabase
          .from('currency_types')
          .select('symbol')
          .eq('currency_id', currencyId)
          .single();

      return response['symbol'] as String? ?? '\$';
    } catch (e) {
      return '\$'; // Default fallback
    }
  }
}
