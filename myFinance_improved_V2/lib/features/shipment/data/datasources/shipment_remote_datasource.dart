import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/create_shipment_params.dart';
import '../models/shipment_model.dart';

/// Shipment Remote Datasource - handles all Supabase queries for Shipments
abstract class ShipmentRemoteDatasource {
  /// Get paginated shipment list using RPC
  Future<PaginatedShipmentResponseModel> getShipments({
    required String companyId,
    String? search,
    String? status,
    String? supplierId,
    String? orderId,
    bool? hasOrder,
    DateTime? startDate,
    DateTime? endDate,
    String timezone,
    int limit,
    int offset,
  });

  /// Get shipment detail using RPC (inventory_get_shipment_detail_v2)
  Future<ShipmentDetailModel?> getShipmentDetail({
    required String shipmentId,
    required String companyId,
    String timezone,
  });

  /// Close (cancel) a shipment using RPC (inventory_close_shipment)
  Future<Map<String, dynamic>> closeShipment({
    required String shipmentId,
    required String userId,
    required String companyId,
    String timezone,
  });

  /// Create shipment using RPC v3 (inventory_create_shipment_v3)
  Future<CreateShipmentResponse> createShipmentV3(CreateShipmentParams params);

  /// Get counterparties for shipment creation (get_counterparty_info RPC)
  Future<List<CounterpartyInfo>> getCounterparties({
    required String companyId,
  });

  /// Get linkable orders for shipment creation (inventory_get_order_info RPC)
  Future<List<LinkableOrder>> getLinkableOrders({
    required String companyId,
    String? search,
  });
}

/// Implementation of ShipmentRemoteDatasource
class ShipmentRemoteDatasourceImpl implements ShipmentRemoteDatasource {
  final SupabaseClient _supabase;

  ShipmentRemoteDatasourceImpl(this._supabase);

  @override
  Future<PaginatedShipmentResponseModel> getShipments({
    required String companyId,
    String? search,
    String? status,
    String? supplierId,
    String? orderId,
    bool? hasOrder,
    DateTime? startDate,
    DateTime? endDate,
    String timezone = 'Asia/Ho_Chi_Minh',
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'inventory_get_shipment_list',
      params: {
        'p_company_id': companyId,
        'p_search': search,
        'p_status': status,
        'p_supplier_id': supplierId,
        'p_order_id': orderId,
        'p_has_order': hasOrder,
        'p_start_date': startDate?.toIso8601String(),
        'p_end_date': endDate?.toIso8601String(),
        'p_timezone': timezone,
        'p_limit': limit,
        'p_offset': offset,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to fetch shipments');
    }

    return PaginatedShipmentResponseModel.fromRpcJson(response);
  }

  @override
  Future<ShipmentDetailModel?> getShipmentDetail({
    required String shipmentId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'inventory_get_shipment_detail_v2',
      params: {
        'p_shipment_id': shipmentId,
        'p_company_id': companyId,
        'p_timezone': timezone,
      },
    );

    if (response['success'] != true) {
      final error = response['error'] as String?;
      if (error == 'Shipment not found') {
        return null;
      }
      throw Exception(error ?? 'Failed to fetch shipment detail');
    }

    final data = response['data'] as Map<String, dynamic>?;
    if (data == null) {
      return null;
    }

    return ShipmentDetailModel.fromRpcJson(data);
  }

  @override
  Future<Map<String, dynamic>> closeShipment({
    required String shipmentId,
    required String userId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'inventory_close_shipment',
      params: {
        'p_shipment_id': shipmentId,
        'p_user_id': userId,
        'p_company_id': companyId,
        'p_timezone': timezone,
      },
    );

    return response;
  }

  @override
  Future<CreateShipmentResponse> createShipmentV3(
    CreateShipmentParams params,
  ) async {
    final itemsJson = params.items.map((item) => item.toJson()).toList();

    final response = await _supabase.rpc<Map<String, dynamic>>(
      'inventory_create_shipment_v3',
      params: {
        'p_company_id': params.companyId,
        'p_user_id': params.userId,
        'p_items': itemsJson,
        'p_time': params.time,
        'p_timezone': params.timezone,
        'p_order_ids': params.orderIds,
        'p_counterparty_id': params.counterpartyId,
        'p_supplier_info': params.supplierInfo,
        'p_tracking_number': params.trackingNumber,
        'p_notes': params.notes,
        'p_shipment_number': params.shipmentNumber,
      },
    );

    return CreateShipmentResponse.fromJson(response);
  }

  @override
  Future<List<CounterpartyInfo>> getCounterparties({
    required String companyId,
  }) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'get_counterparty_info',
      params: {'p_company_id': companyId},
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to load counterparties');
    }

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => CounterpartyInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<LinkableOrder>> getLinkableOrders({
    required String companyId,
    String? search,
  }) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'inventory_get_order_info',
      params: {
        'p_company_id': companyId,
        'p_search': search,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to load orders');
    }

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => LinkableOrder.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
