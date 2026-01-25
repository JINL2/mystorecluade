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

  /// Get shipment by ID
  Future<ShipmentModel?> getShipmentById(String shipmentId);

  /// Get shipments by Order ID
  Future<List<ShipmentListItemModel>> getShipmentsByOrderId(String orderId);

  /// Create shipment
  Future<ShipmentModel> createShipment(ShipmentModel shipment);

  /// Update shipment
  Future<ShipmentModel> updateShipment(ShipmentModel shipment);

  /// Delete shipment
  Future<void> deleteShipment(String shipmentId);

  /// Update shipment status
  Future<void> updateShipmentStatus(String shipmentId, String status);

  /// Get shipment items
  Future<List<ShipmentItemModel>> getShipmentItems(String shipmentId);

  /// Add shipment item
  Future<ShipmentItemModel> addShipmentItem(ShipmentItemModel item);

  /// Update shipment item
  Future<ShipmentItemModel> updateShipmentItem(ShipmentItemModel item);

  /// Delete shipment item
  Future<void> deleteShipmentItem(String itemId);

  /// Search shipments
  Future<PaginatedShipmentResponseModel> searchShipments({
    required String companyId,
    required String query,
    int limit,
    int offset,
  });

  /// Get shipment count by status
  Future<Map<String, int>> getShipmentCountByStatus({
    required String companyId,
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
  Future<ShipmentModel?> getShipmentById(String shipmentId) async {
    final response = await _supabase
        .from('inventory_shipments')
        .select('*')
        .eq('shipment_id', shipmentId)
        .maybeSingle();

    if (response == null) return null;

    // Fetch items
    final itemsResponse = await _supabase
        .from('inventory_shipment_items')
        .select('*')
        .eq('shipment_id', shipmentId)
        .order('sort_order', ascending: true);

    final items = (itemsResponse as List<dynamic>)
        .map((e) => ShipmentItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Fetch supplier name if supplier_id exists
    String? supplierName;
    final supplierId = response['supplier_id'] as String?;
    if (supplierId != null) {
      final supplierResponse = await _supabase
          .from('counterparties')
          .select('name')
          .eq('counterparty_id', supplierId)
          .maybeSingle();
      supplierName = supplierResponse?['name'] as String?;
    }

    // Get supplier name from supplier_info if not from counterparties
    if (supplierName == null && response['supplier_info'] != null) {
      final supplierInfo = response['supplier_info'] as Map<String, dynamic>?;
      supplierName = supplierInfo?['name'] as String?;
    }

    return ShipmentModel(
      shipmentId: response['shipment_id'] as String,
      shipmentNumber: response['shipment_number'] as String,
      companyId: response['company_id'] as String,
      trackingNumber: response['tracking_number'] as String?,
      shippedDateUtc: response['shipped_date_utc'] != null
          ? DateTime.parse(response['shipped_date_utc'] as String)
          : null,
      supplierId: response['supplier_id'] as String?,
      supplierName: supplierName,
      supplierInfo: response['supplier_info'] as Map<String, dynamic>?,
      status: response['status'] as String? ?? 'pending',
      notes: response['notes'] as String?,
      createdBy: response['created_by'] as String?,
      createdAtUtc: response['created_at_utc'] != null
          ? DateTime.parse(response['created_at_utc'] as String)
          : null,
      updatedAtUtc: response['updated_at_utc'] != null
          ? DateTime.parse(response['updated_at_utc'] as String)
          : null,
      items: items,
    );
  }

  @override
  Future<List<ShipmentListItemModel>> getShipmentsByOrderId(
    String orderId,
  ) async {
    final response = await getShipments(
      companyId: '', // Will be filtered by order_id
      orderId: orderId,
    );
    return response.data;
  }

  @override
  Future<ShipmentModel> createShipment(ShipmentModel shipment) async {
    final insertData = shipment.toJson();
    insertData['created_at_utc'] = DateTime.now().toUtc().toIso8601String();
    insertData['updated_at_utc'] = DateTime.now().toUtc().toIso8601String();
    insertData.remove('shipment_id'); // Let DB generate

    final response = await _supabase
        .from('inventory_shipments')
        .insert(insertData)
        .select()
        .single();

    final shipmentId = response['shipment_id'] as String;

    // Insert items if any
    if (shipment.items.isNotEmpty) {
      final itemsData = shipment.items.map((item) {
        final itemJson = item.toJson();
        itemJson['shipment_id'] = shipmentId;
        itemJson.remove('item_id'); // Let DB generate
        return itemJson;
      }).toList();

      await _supabase.from('inventory_shipment_items').insert(itemsData);
    }

    return (await getShipmentById(shipmentId))!;
  }

  @override
  Future<ShipmentModel> updateShipment(ShipmentModel shipment) async {
    final updateData = shipment.toJson();
    updateData['updated_at_utc'] = DateTime.now().toUtc().toIso8601String();

    await _supabase
        .from('inventory_shipments')
        .update(updateData)
        .eq('shipment_id', shipment.shipmentId);

    return (await getShipmentById(shipment.shipmentId))!;
  }

  @override
  Future<void> deleteShipment(String shipmentId) async {
    // Delete items first
    await _supabase
        .from('inventory_shipment_items')
        .delete()
        .eq('shipment_id', shipmentId);

    // Delete shipment
    await _supabase
        .from('inventory_shipments')
        .delete()
        .eq('shipment_id', shipmentId);
  }

  @override
  Future<void> updateShipmentStatus(String shipmentId, String status) async {
    await _supabase
        .from('inventory_shipments')
        .update({
          'status': status,
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('shipment_id', shipmentId);
  }

  @override
  Future<List<ShipmentItemModel>> getShipmentItems(String shipmentId) async {
    final response = await _supabase
        .from('inventory_shipment_items')
        .select('*')
        .eq('shipment_id', shipmentId)
        .order('sort_order', ascending: true);

    return (response as List<dynamic>)
        .map((e) => ShipmentItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ShipmentItemModel> addShipmentItem(ShipmentItemModel item) async {
    final insertData = item.toJson();
    insertData['created_at_utc'] = DateTime.now().toUtc().toIso8601String();
    insertData.remove('item_id'); // Let DB generate

    final response = await _supabase
        .from('inventory_shipment_items')
        .insert(insertData)
        .select()
        .single();

    return ShipmentItemModel.fromJson(response);
  }

  @override
  Future<ShipmentItemModel> updateShipmentItem(ShipmentItemModel item) async {
    final updateData = item.toJson();

    await _supabase
        .from('inventory_shipment_items')
        .update(updateData)
        .eq('item_id', item.itemId);

    final response = await _supabase
        .from('inventory_shipment_items')
        .select('*')
        .eq('item_id', item.itemId)
        .single();

    return ShipmentItemModel.fromJson(response);
  }

  @override
  Future<void> deleteShipmentItem(String itemId) async {
    await _supabase
        .from('inventory_shipment_items')
        .delete()
        .eq('item_id', itemId);
  }

  @override
  Future<PaginatedShipmentResponseModel> searchShipments({
    required String companyId,
    required String query,
    int limit = 50,
    int offset = 0,
  }) async {
    return getShipments(
      companyId: companyId,
      search: query,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Map<String, int>> getShipmentCountByStatus({
    required String companyId,
  }) async {
    final response = await _supabase
        .from('inventory_shipments')
        .select('status')
        .eq('company_id', companyId);

    final data = response as List<dynamic>;

    final countMap = <String, int>{};
    for (final item in data) {
      final status = (item as Map<String, dynamic>)['status'] as String;
      countMap[status] = (countMap[status] ?? 0) + 1;
    }

    return countMap;
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
