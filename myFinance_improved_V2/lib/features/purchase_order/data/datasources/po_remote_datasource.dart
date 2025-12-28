import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/po_model.dart';
import '../../domain/repositories/po_repository.dart';
import '../../domain/entities/purchase_order.dart';

/// PO Remote Datasource - handles all Supabase RPC calls
abstract class PORemoteDatasource {
  Future<PaginatedPOResponse> getList(POListParams params);
  Future<POModel> getById(String poId);
  Future<POModel> create(POCreateParams params);
  Future<POModel> update(String poId, int version, Map<String, dynamic> updates);
  Future<void> delete(String poId);
  Future<void> confirm(String poId);
  Future<void> updateStatus(String poId, POStatus newStatus, {String? notes});
  Future<String> convertFromPI(String piId, {Map<String, dynamic>? options});
  Future<String> generateNumber(String companyId);
}

class PORemoteDatasourceImpl implements PORemoteDatasource {
  final SupabaseClient _supabase;

  PORemoteDatasourceImpl(this._supabase);

  @override
  Future<PaginatedPOResponse> getList(POListParams params) async {
    // Build query
    var query = _supabase
        .from('trade_purchase_orders')
        .select('*')
        .eq('company_id', params.companyId);

    if (params.storeId != null) {
      query = query.or('store_id.eq.${params.storeId},store_id.is.null');
    }

    if (params.statuses != null && params.statuses!.isNotEmpty) {
      query = query.inFilter(
          'status', params.statuses!.map((e) => e.dbValue).toList());
    }

    if (params.counterpartyId != null) {
      query = query.eq('buyer_id', params.counterpartyId!);
    }

    if (params.dateFrom != null) {
      query = query.gte('order_date_utc', params.dateFrom!.toIso8601String());
    }

    if (params.dateTo != null) {
      query = query.lte('order_date_utc', params.dateTo!.toIso8601String());
    }

    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      query = query.or(
          'po_number.ilike.%${params.searchQuery}%,buyer_po_number.ilike.%${params.searchQuery}%');
    }

    // Get total count first
    var countQuery = _supabase
        .from('trade_purchase_orders')
        .select('po_id')
        .eq('company_id', params.companyId);

    if (params.storeId != null) {
      countQuery =
          countQuery.or('store_id.eq.${params.storeId},store_id.is.null');
    }
    if (params.statuses != null && params.statuses!.isNotEmpty) {
      countQuery = countQuery.inFilter(
          'status', params.statuses!.map((e) => e.dbValue).toList());
    }
    if (params.counterpartyId != null) {
      countQuery = countQuery.eq('buyer_id', params.counterpartyId!);
    }
    if (params.dateFrom != null) {
      countQuery =
          countQuery.gte('order_date_utc', params.dateFrom!.toIso8601String());
    }
    if (params.dateTo != null) {
      countQuery =
          countQuery.lte('order_date_utc', params.dateTo!.toIso8601String());
    }
    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      countQuery = countQuery.or(
          'po_number.ilike.%${params.searchQuery}%,buyer_po_number.ilike.%${params.searchQuery}%');
    }

    final countResponse = await countQuery;
    final totalCount = (countResponse as List).length;

    // Get paginated data
    final offset = (params.page - 1) * params.pageSize;
    final response = await query
        .order('created_at_utc', ascending: false)
        .range(offset, offset + params.pageSize - 1);

    final data = response as List;

    // Get all unique currency IDs to fetch currency codes
    final currencyIds = data
        .map((e) => (e as Map<String, dynamic>)['currency_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    // Fetch currency codes
    Map<String, String> currencyCodeMap = {};
    if (currencyIds.isNotEmpty) {
      final currencyResponse = await _supabase
          .from('currency_types')
          .select('currency_id, currency_code')
          .inFilter('currency_id', currencyIds);
      for (final c in currencyResponse as List) {
        currencyCodeMap[c['currency_id'] as String] =
            c['currency_code'] as String;
      }
    }

    // Get all unique buyer IDs to fetch names
    final buyerIds = data
        .map((e) => (e as Map<String, dynamic>)['buyer_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    // Fetch buyer names
    Map<String, String> buyerNameMap = {};
    if (buyerIds.isNotEmpty) {
      final buyerResponse = await _supabase
          .from('counterparties')
          .select('counterparty_id, name')
          .inFilter('counterparty_id', buyerIds);
      for (final b in buyerResponse as List) {
        buyerNameMap[b['counterparty_id'] as String] = b['name'] as String;
      }
    }

    // Get PI numbers for linked PIs
    final piIds = data
        .map((e) => (e as Map<String, dynamic>)['pi_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    Map<String, String> piNumberMap = {};
    if (piIds.isNotEmpty) {
      final piResponse = await _supabase
          .from('trade_proforma_invoices')
          .select('pi_id, pi_number')
          .inFilter('pi_id', piIds);
      for (final p in piResponse as List) {
        piNumberMap[p['pi_id'] as String] = p['pi_number'] as String;
      }
    }

    final items = data.map((e) {
      final map = e as Map<String, dynamic>;

      // Get buyer name from buyer_info JSONB or counterparties table
      final buyerInfo = map['buyer_info'] as Map<String, dynamic>?;
      String? buyerName = buyerInfo?['name'] as String?;
      if (buyerName == null) {
        final buyerId = map['buyer_id'] as String?;
        if (buyerId != null && buyerNameMap.containsKey(buyerId)) {
          buyerName = buyerNameMap[buyerId];
        }
      }
      map['buyer_name'] = buyerName;

      // Get currency code
      final currencyId = map['currency_id'] as String?;
      if (currencyId != null && currencyCodeMap.containsKey(currencyId)) {
        map['currency_code'] = currencyCodeMap[currencyId];
      }

      // Get PI number
      final piId = map['pi_id'] as String?;
      if (piId != null && piNumberMap.containsKey(piId)) {
        map['pi_number'] = piNumberMap[piId];
      }

      return POListItemModel.fromJson(map);
    }).toList();

    return PaginatedPOResponse(
      data: items.map((e) => e.toEntity()).toList(),
      totalCount: totalCount,
      page: params.page,
      pageSize: params.pageSize,
      hasMore: offset + items.length < totalCount,
    );
  }

  @override
  Future<POModel> getById(String poId) async {
    // Get PO data
    final poResponse = await _supabase
        .from('trade_purchase_orders')
        .select('*')
        .eq('po_id', poId)
        .single();

    final poMap = poResponse;

    // Get buyer name from buyer_info JSONB
    final buyerInfo = poMap['buyer_info'] as Map<String, dynamic>?;
    String? buyerName = buyerInfo?['name'] as String?;

    // If name not in buyer_info, fetch from counterparties table
    final buyerId = poMap['buyer_id'] as String?;
    if (buyerName == null && buyerId != null) {
      final buyerResponse = await _supabase
          .from('counterparties')
          .select('name, address, city, country, phone, email')
          .eq('counterparty_id', buyerId)
          .maybeSingle();
      if (buyerResponse != null) {
        buyerName = buyerResponse['name'] as String?;
        // Update buyer_info with full details if not present
        if (buyerInfo == null || buyerInfo.isEmpty) {
          poMap['buyer_info'] = {
            'name': buyerResponse['name'],
            'address': buyerResponse['address'],
            'city': buyerResponse['city'],
            'country': buyerResponse['country'],
            'phone': buyerResponse['phone'],
            'email': buyerResponse['email'],
          };
        }
      }
    }
    poMap['buyer_name'] = buyerName;

    // Get seller (our company) info for PDF generation
    final companyId = poMap['company_id'] as String?;
    if (companyId != null) {
      final companyResponse = await _supabase
          .from('companies')
          .select('company_name')
          .eq('company_id', companyId)
          .maybeSingle();
      if (companyResponse != null) {
        poMap['seller_info'] = {
          'name': companyResponse['company_name'] as String?,
        };
      }
    }

    // Get currency code
    final currencyId = poMap['currency_id'] as String?;
    if (currencyId != null) {
      final currencyResponse = await _supabase
          .from('currency_types')
          .select('currency_code')
          .eq('currency_id', currencyId)
          .maybeSingle();
      if (currencyResponse != null) {
        poMap['currency_code'] = currencyResponse['currency_code'];
      }
    }

    // Get PI number if linked
    final piId = poMap['pi_id'] as String?;
    if (piId != null) {
      final piResponse = await _supabase
          .from('trade_proforma_invoices')
          .select('pi_number')
          .eq('pi_id', piId)
          .maybeSingle();
      if (piResponse != null) {
        poMap['pi_number'] = piResponse['pi_number'];
      }
    }

    // Get items from trade_po_items table
    final itemsResponse = await _supabase
        .from('trade_po_items')
        .select('*')
        .eq('po_id', poId)
        .order('sort_order', ascending: true);

    final itemsList = itemsResponse as List;

    // Get product image URLs for items that have product_id
    final productIds = itemsList
        .map((e) => (e as Map<String, dynamic>)['product_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    Map<String, String?> productImageMap = {};
    if (productIds.isNotEmpty) {
      final productsResponse = await _supabase
          .from('inventory_products')
          .select('product_id, image_urls')
          .inFilter('product_id', productIds);

      for (final p in productsResponse as List) {
        final productId = p['product_id'] as String;
        final imageUrls = p['image_urls'];
        String? firstImageUrl;
        if (imageUrls != null) {
          if (imageUrls is List && imageUrls.isNotEmpty) {
            firstImageUrl = imageUrls[0] as String?;
          } else if (imageUrls is Map && imageUrls['urls'] is List) {
            final urls = imageUrls['urls'] as List;
            if (urls.isNotEmpty) {
              firstImageUrl = urls[0] as String?;
            }
          }
        }
        productImageMap[productId] = firstImageUrl;
      }
    }

    // Add image_url to each item
    final itemsWithImages = itemsList.map((e) {
      final item = Map<String, dynamic>.from(e as Map<String, dynamic>);
      final productId = item['product_id'] as String?;
      if (productId != null && productImageMap.containsKey(productId)) {
        item['image_url'] = productImageMap[productId];
      }
      return item;
    }).toList();

    poMap['items'] = itemsWithImages;

    return POModel.fromJson(poMap);
  }

  @override
  Future<POModel> create(POCreateParams params) async {
    // Generate PO number
    final poNumber = await generateNumber(params.companyId);

    // Calculate total
    double totalAmount = 0;
    for (final item in params.items) {
      final lineTotal =
          item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
      totalAmount += lineTotal;
    }

    // Insert PO
    final poResponse = await _supabase
        .from('trade_purchase_orders')
        .insert({
          'po_number': poNumber,
          'company_id': params.companyId,
          'store_id': params.storeId,
          'pi_id': params.piId,
          'buyer_id': params.counterpartyId,
          'buyer_po_number': params.buyerPoNumber,
          'buyer_info': params.buyerInfo,
          'currency_id': params.currencyId,
          'total_amount': totalAmount,
          'incoterms_code': params.incotermsCode,
          'incoterms_place': params.incotermsPlace,
          'payment_terms_code': params.paymentTermsCode,
          'order_date_utc': params.orderDateUtc?.toIso8601String(),
          'required_shipment_date_utc':
              params.requiredShipmentDateUtc?.toIso8601String(),
          'partial_shipment_allowed': params.partialShipmentAllowed,
          'transshipment_allowed': params.transshipmentAllowed,
          'status': 'draft',
          'version': 1,
          'shipped_percent': 0,
          'notes': params.notes,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final poId = (poResponse as Map<String, dynamic>)['po_id'] as String;

    // Insert items
    if (params.items.isNotEmpty) {
      final itemsToInsert = params.items.asMap().entries.map((entry) {
        final item = entry.value;
        final lineTotal =
            item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
        return {
          'po_id': poId,
          'product_id': item.productId,
          'description': item.description,
          'sku': item.sku,
          'hs_code': item.hsCode,
          'quantity_ordered': item.quantity,
          'quantity_shipped': 0,
          'unit': item.unit ?? 'PCS',
          'unit_price': item.unitPrice,
          'total_amount': lineTotal,
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_po_items').insert(itemsToInsert);
    }

    return getById(poId);
  }

  @override
  Future<POModel> update(
      String poId, int version, Map<String, dynamic> updates) async {
    // Add version check and update timestamp
    updates['updated_at_utc'] = DateTime.now().toUtc().toIso8601String();
    updates['version'] = version + 1;

    await _supabase
        .from('trade_purchase_orders')
        .update(updates)
        .eq('po_id', poId)
        .eq('version', version); // Optimistic locking

    // If items are included in updates, handle them
    if (updates.containsKey('items')) {
      final items = updates['items'] as List<POItemCreateParams>?;
      if (items != null) {
        // Delete existing items and re-insert
        await _supabase.from('trade_po_items').delete().eq('po_id', poId);

        if (items.isNotEmpty) {
          final itemsToInsert = items.asMap().entries.map((entry) {
            final item = entry.value;
            final lineTotal = item.quantity *
                item.unitPrice *
                (1 - item.discountPercent / 100);
            return {
              'po_id': poId,
              'product_id': item.productId,
              'description': item.description,
              'sku': item.sku,
              'hs_code': item.hsCode,
              'quantity_ordered': item.quantity,
              'quantity_shipped': 0,
              'unit': item.unit ?? 'PCS',
              'unit_price': item.unitPrice,
              'total_amount': lineTotal,
              'sort_order': entry.key,
              'created_at_utc': DateTime.now().toUtc().toIso8601String(),
            };
          }).toList();

          await _supabase.from('trade_po_items').insert(itemsToInsert);
        }
      }
    }

    return getById(poId);
  }

  @override
  Future<void> delete(String poId) async {
    // Delete items first
    await _supabase.from('trade_po_items').delete().eq('po_id', poId);

    // Delete PO (only draft can be deleted)
    await _supabase
        .from('trade_purchase_orders')
        .delete()
        .eq('po_id', poId)
        .eq('status', 'draft');
  }

  @override
  Future<void> confirm(String poId) async {
    await _supabase.from('trade_purchase_orders').update({
      'status': 'confirmed',
      'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
    }).eq('po_id', poId);
  }

  @override
  Future<void> updateStatus(String poId, POStatus newStatus,
      {String? notes}) async {
    final updates = <String, dynamic>{
      'status': newStatus.dbValue,
      'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
    };
    if (notes != null) {
      updates['notes'] = notes;
    }

    await _supabase
        .from('trade_purchase_orders')
        .update(updates)
        .eq('po_id', poId);
  }

  @override
  Future<String> convertFromPI(String piId,
      {Map<String, dynamic>? options}) async {
    // Get PI data
    final piResponse = await _supabase
        .from('trade_proforma_invoices')
        .select('*')
        .eq('pi_id', piId)
        .single();

    final pi = piResponse as Map<String, dynamic>;

    // Generate PO number
    final poNumber = await generateNumber(pi['company_id'] as String);

    // Create PO from PI
    final poResponse = await _supabase
        .from('trade_purchase_orders')
        .insert({
          'po_number': poNumber,
          'company_id': pi['company_id'],
          'store_id': pi['store_id'],
          'pi_id': piId,
          'buyer_id': pi['counterparty_id'],
          'buyer_info': pi['counterparty_info'],
          'currency_id': pi['currency_id'],
          'total_amount': pi['total_amount'],
          'incoterms_code': pi['incoterms_code'],
          'incoterms_place': pi['incoterms_place'],
          'payment_terms_code': pi['payment_terms_code'],
          'partial_shipment_allowed': pi['partial_shipment_allowed'],
          'transshipment_allowed': pi['transshipment_allowed'],
          'status': 'draft',
          'version': 1,
          'shipped_percent': 0,
          'notes': options?['notes'] ?? pi['notes'],
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final poId = (poResponse as Map<String, dynamic>)['po_id'] as String;

    // Copy PI items to PO items
    final piItemsResponse = await _supabase
        .from('trade_pi_items')
        .select('*')
        .eq('pi_id', piId)
        .order('sort_order', ascending: true);

    final piItems = piItemsResponse as List;
    if (piItems.isNotEmpty) {
      final poItemsToInsert = piItems.asMap().entries.map((entry) {
        final item = entry.value as Map<String, dynamic>;
        return {
          'po_id': poId,
          'product_id': item['product_id'],
          'description': item['description'],
          'sku': item['sku'],
          'hs_code': item['hs_code'],
          'quantity_ordered': item['quantity'],
          'quantity_shipped': 0,
          'unit': item['unit'],
          'unit_price': item['unit_price'],
          'total_amount': item['total_amount'],
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_po_items').insert(poItemsToInsert);
    }

    // Update PI status to converted
    await _supabase.from('trade_proforma_invoices').update({
      'status': 'converted',
      'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
    }).eq('pi_id', piId);

    return poId;
  }

  @override
  Future<String> generateNumber(String companyId) async {
    // Get the latest PO number for this company
    final response = await _supabase
        .from('trade_purchase_orders')
        .select('po_number')
        .eq('company_id', companyId)
        .order('created_at_utc', ascending: false)
        .limit(1);

    final data = response as List;
    int nextNumber = 1;

    if (data.isNotEmpty) {
      final lastNumber = data[0]['po_number'] as String;
      // Extract number from format PO-YYYYMMDD-XXXX
      final parts = lastNumber.split('-');
      if (parts.length >= 3) {
        nextNumber = (int.tryParse(parts.last) ?? 0) + 1;
      }
    }

    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'PO-$dateStr-${nextNumber.toString().padLeft(4, '0')}';
  }
}
