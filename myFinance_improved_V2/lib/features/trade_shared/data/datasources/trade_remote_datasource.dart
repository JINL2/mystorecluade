import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/master_data_model.dart';

/// Remote datasource for trade shared functionality (Master Data only)
/// Dashboard-specific data is handled by trade_dashboard feature
abstract class TradeRemoteDatasource {
  /// Get all master data
  Future<MasterDataResponse> getAllMasterData();

  /// Get incoterms list
  Future<List<IncotermModel>> getIncoterms();

  /// Get payment terms list
  Future<List<PaymentTermModel>> getPaymentTerms();

  /// Get L/C types list
  Future<List<LCTypeModel>> getLCTypes();

  /// Get document types list
  Future<List<DocumentTypeModel>> getDocumentTypes();

  /// Get shipping methods list
  Future<List<ShippingMethodModel>> getShippingMethods();

  /// Get freight terms list
  Future<List<FreightTermModel>> getFreightTerms();
}

class TradeRemoteDatasourceImpl implements TradeRemoteDatasource {
  final SupabaseClient _supabase;

  TradeRemoteDatasourceImpl(this._supabase);

  @override
  Future<MasterDataResponse> getAllMasterData() async {
    final response = await _supabase.rpc('trade_master_get_all');

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get master data');
    }

    return MasterDataResponse.fromJson(responseMap);
  }

  @override
  Future<List<IncotermModel>> getIncoterms() async {
    final response = await _supabase.rpc('trade_master_get_incoterms');

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get incoterms');
    }

    final data = responseMap['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => IncotermModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PaymentTermModel>> getPaymentTerms() async {
    final response = await _supabase.rpc('trade_master_get_payment_terms');

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get payment terms');
    }

    final data = responseMap['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => PaymentTermModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<LCTypeModel>> getLCTypes() async {
    final response = await _supabase.rpc('trade_master_get_lc_types');

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get L/C types');
    }

    final data = responseMap['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => LCTypeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<DocumentTypeModel>> getDocumentTypes() async {
    final response = await _supabase.rpc('trade_master_get_document_types');

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get document types');
    }

    final data = responseMap['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => DocumentTypeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ShippingMethodModel>> getShippingMethods() async {
    final response = await _supabase.rpc('trade_master_get_shipping_methods');

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get shipping methods');
    }

    final data = responseMap['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => ShippingMethodModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<FreightTermModel>> getFreightTerms() async {
    final response = await _supabase.rpc('trade_master_get_freight_terms');

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get freight terms');
    }

    final data = responseMap['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => FreightTermModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
