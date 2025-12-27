import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pi_model.dart';
import '../../domain/repositories/pi_repository.dart';

/// PI Remote Datasource - handles all Supabase queries
abstract class PIRemoteDatasource {
  Future<PaginatedPIResponse> getList(PIListParams params);
  Future<PIModel> getById(String piId);
  Future<PIModel> create(PICreateParams params);
  Future<PIModel> update(String piId, PICreateParams params);
  Future<void> delete(String piId);
  Future<void> send(String piId);
  Future<void> accept(String piId);
  Future<void> reject(String piId, String? reason);
  Future<String> convertToPO(String piId);
  Future<PIModel> duplicate(String piId);
  Future<String> generateNumber(String companyId);
}

class PIRemoteDatasourceImpl implements PIRemoteDatasource {
  final SupabaseClient _supabase;

  PIRemoteDatasourceImpl(this._supabase);

  @override
  Future<PaginatedPIResponse> getList(PIListParams params) async {
    // Build query with joins for currency and counterparty
    var query = _supabase
        .from('trade_proforma_invoices')
        .select('*, currency_types(currency_code), counterparties(name)')
        .eq('company_id', params.companyId);

    if (params.storeId != null) {
      query = query.eq('store_id', params.storeId!);
    }

    if (params.statuses != null && params.statuses!.isNotEmpty) {
      query = query.inFilter('status', params.statuses!.map((e) => e.name).toList());
    }

    if (params.counterpartyId != null) {
      query = query.eq('counterparty_id', params.counterpartyId!);
    }

    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      query = query.ilike('pi_number', '%${params.searchQuery}%');
    }

    // Get total count first
    final countResponse = await _supabase
        .from('trade_proforma_invoices')
        .select('pi_id')
        .eq('company_id', params.companyId);
    final totalCount = (countResponse as List).length;

    // Get paginated data
    final offset = (params.page - 1) * params.pageSize;
    final response = await query
        .order('created_at_utc', ascending: false)
        .range(offset, offset + params.pageSize - 1);

    final data = response as List;
    final items = data.map((e) {
      final map = e as Map<String, dynamic>;
      // Extract currency code from joined table
      final currencyData = map['currency_types'] as Map<String, dynamic>?;
      map['currency_code'] = currencyData?['currency_code'] ?? 'USD';
      // Extract counterparty name from joined table
      final counterpartyData = map['counterparties'] as Map<String, dynamic>?;
      map['counterparty_name'] = counterpartyData?['name'];
      return PIModel.fromJson(map);
    }).toList();

    return PaginatedPIResponse(
      data: items,
      totalCount: totalCount,
      page: params.page,
      pageSize: params.pageSize,
      hasMore: offset + items.length < totalCount,
    );
  }

  @override
  Future<PIModel> getById(String piId) async {
    // Get PI with joins
    final piResponse = await _supabase
        .from('trade_proforma_invoices')
        .select('*, currency_types(currency_code), counterparties(name)')
        .eq('pi_id', piId)
        .single();

    final piMap = piResponse as Map<String, dynamic>;
    final currencyData = piMap['currency_types'] as Map<String, dynamic>?;
    piMap['currency_code'] = currencyData?['currency_code'] ?? 'USD';
    final counterpartyData = piMap['counterparties'] as Map<String, dynamic>?;
    piMap['counterparty_name'] = counterpartyData?['name'];

    // Get items from trade_pi_items table
    final itemsResponse = await _supabase
        .from('trade_pi_items')
        .select('*')
        .eq('pi_id', piId)
        .order('sort_order', ascending: true);

    piMap['items'] = itemsResponse as List;

    return PIModel.fromJson(piMap);
  }

  @override
  Future<PIModel> create(PICreateParams params) async {
    // Generate PI number
    final piNumber = await generateNumber(params.companyId);

    // Calculate totals
    double subtotal = 0;
    for (final item in params.items) {
      final lineTotal = item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
      subtotal += lineTotal;
    }
    final discountAmount = subtotal * (0 / 100); // No discount percent in params
    final totalAmount = subtotal - discountAmount;

    // Insert PI
    final piResponse = await _supabase
        .from('trade_proforma_invoices')
        .insert({
          'pi_number': piNumber,
          'company_id': params.companyId,
          'store_id': params.storeId,
          'counterparty_id': params.counterpartyId,
          'counterparty_info': params.counterpartyInfo,
          'currency_id': params.currencyId,
          'subtotal': subtotal,
          'discount_amount': discountAmount,
          'total_amount': totalAmount,
          'incoterms_code': params.incotermsCode,
          'incoterms_place': params.incotermsPlace,
          'port_of_loading': params.portOfLoading,
          'port_of_discharge': params.portOfDischarge,
          'final_destination': params.finalDestination,
          'country_of_origin': params.countryOfOrigin,
          'payment_terms_code': params.paymentTermsCode,
          'payment_terms_detail': params.paymentTermsDetail,
          'partial_shipment_allowed': params.partialShipmentAllowed,
          'transshipment_allowed': params.transshipmentAllowed,
          'shipping_method_code': params.shippingMethodCode,
          'estimated_shipment_date': params.estimatedShipmentDate?.toIso8601String(),
          'lead_time_days': params.leadTimeDays,
          'validity_date': params.validityDate?.toIso8601String(),
          'status': 'draft',
          'version': 1,
          'notes': params.notes,
          'internal_notes': params.internalNotes,
          'terms_and_conditions': params.termsAndConditions,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final piId = (piResponse as Map<String, dynamic>)['pi_id'] as String;

    // Insert items
    if (params.items.isNotEmpty) {
      final itemsToInsert = params.items.asMap().entries.map((entry) {
        final item = entry.value;
        final lineTotal = item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
        return {
          'pi_id': piId,
          'product_id': item.productId,
          'description': item.description,
          'sku': item.sku,
          'hs_code': item.hsCode,
          'country_of_origin': item.countryOfOrigin,
          'quantity': item.quantity,
          'unit': item.unit ?? 'PCS',
          'unit_price': item.unitPrice,
          'discount_percent': item.discountPercent,
          'total_amount': lineTotal,
          'packing_info': item.packingInfo,
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_pi_items').insert(itemsToInsert);
    }

    return getById(piId);
  }

  @override
  Future<PIModel> update(String piId, PICreateParams params) async {
    // Calculate totals
    double subtotal = 0;
    for (final item in params.items) {
      final lineTotal = item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
      subtotal += lineTotal;
    }
    final totalAmount = subtotal;

    // Update PI
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'counterparty_id': params.counterpartyId,
          'counterparty_info': params.counterpartyInfo,
          'currency_id': params.currencyId,
          'subtotal': subtotal,
          'total_amount': totalAmount,
          'incoterms_code': params.incotermsCode,
          'incoterms_place': params.incotermsPlace,
          'port_of_loading': params.portOfLoading,
          'port_of_discharge': params.portOfDischarge,
          'final_destination': params.finalDestination,
          'country_of_origin': params.countryOfOrigin,
          'payment_terms_code': params.paymentTermsCode,
          'payment_terms_detail': params.paymentTermsDetail,
          'partial_shipment_allowed': params.partialShipmentAllowed,
          'transshipment_allowed': params.transshipmentAllowed,
          'shipping_method_code': params.shippingMethodCode,
          'estimated_shipment_date': params.estimatedShipmentDate?.toIso8601String(),
          'lead_time_days': params.leadTimeDays,
          'validity_date': params.validityDate?.toIso8601String(),
          'notes': params.notes,
          'internal_notes': params.internalNotes,
          'terms_and_conditions': params.termsAndConditions,
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);

    // Delete existing items and re-insert
    await _supabase
        .from('trade_pi_items')
        .delete()
        .eq('pi_id', piId);

    if (params.items.isNotEmpty) {
      final itemsToInsert = params.items.asMap().entries.map((entry) {
        final item = entry.value;
        final lineTotal = item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
        return {
          'pi_id': piId,
          'product_id': item.productId,
          'description': item.description,
          'sku': item.sku,
          'hs_code': item.hsCode,
          'country_of_origin': item.countryOfOrigin,
          'quantity': item.quantity,
          'unit': item.unit ?? 'PCS',
          'unit_price': item.unitPrice,
          'discount_percent': item.discountPercent,
          'total_amount': lineTotal,
          'packing_info': item.packingInfo,
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_pi_items').insert(itemsToInsert);
    }

    return getById(piId);
  }

  @override
  Future<void> delete(String piId) async {
    // Delete items first
    await _supabase
        .from('trade_pi_items')
        .delete()
        .eq('pi_id', piId);

    // Delete PI (only draft can be deleted)
    await _supabase
        .from('trade_proforma_invoices')
        .delete()
        .eq('pi_id', piId)
        .eq('status', 'draft');
  }

  @override
  Future<void> send(String piId) async {
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'status': 'sent',
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);
  }

  @override
  Future<void> accept(String piId) async {
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'status': 'accepted',
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);
  }

  @override
  Future<void> reject(String piId, String? reason) async {
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'status': 'rejected',
          'internal_notes': reason,
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);
  }

  @override
  Future<String> convertToPO(String piId) async {
    // Get PI data
    final pi = await getById(piId);

    // Generate PO number
    final poNumber = 'PO-${DateTime.now().millisecondsSinceEpoch}';

    // Create PO
    final poResponse = await _supabase
        .from('trade_purchase_orders')
        .insert({
          'po_number': poNumber,
          'company_id': pi.companyId,
          'store_id': pi.storeId,
          'pi_id': piId,
          'supplier_id': pi.counterpartyId,
          'supplier_info': pi.counterpartyInfo,
          'currency_id': pi.currencyId,
          'subtotal': pi.subtotal,
          'total_amount': pi.totalAmount,
          'incoterms_code': pi.incotermsCode,
          'incoterms_place': pi.incotermsPlace,
          'port_of_loading': pi.portOfLoading,
          'port_of_discharge': pi.portOfDischarge,
          'payment_terms_code': pi.paymentTermsCode,
          'payment_terms_detail': pi.paymentTermsDetail,
          'status': 'draft',
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final newPoId = (poResponse as Map<String, dynamic>)['po_id'] as String;

    // Update PI status to converted
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'status': 'converted',
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);

    return newPoId;
  }

  @override
  Future<PIModel> duplicate(String piId) async {
    final original = await getById(piId);
    final piNumber = await generateNumber(original.companyId);

    // Insert duplicated PI
    final piResponse = await _supabase
        .from('trade_proforma_invoices')
        .insert({
          'pi_number': piNumber,
          'company_id': original.companyId,
          'store_id': original.storeId,
          'counterparty_id': original.counterpartyId,
          'counterparty_info': original.counterpartyInfo,
          'currency_id': original.currencyId,
          'subtotal': original.subtotal,
          'discount_percent': original.discountPercent,
          'discount_amount': original.discountAmount,
          'total_amount': original.totalAmount,
          'incoterms_code': original.incotermsCode,
          'incoterms_place': original.incotermsPlace,
          'port_of_loading': original.portOfLoading,
          'port_of_discharge': original.portOfDischarge,
          'final_destination': original.finalDestination,
          'country_of_origin': original.countryOfOrigin,
          'payment_terms_code': original.paymentTermsCode,
          'payment_terms_detail': original.paymentTermsDetail,
          'partial_shipment_allowed': original.partialShipmentAllowed,
          'transshipment_allowed': original.transshipmentAllowed,
          'shipping_method_code': original.shippingMethodCode,
          'status': 'draft',
          'version': 1,
          'notes': original.notes,
          'terms_and_conditions': original.termsAndConditions,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final newPiId = (piResponse as Map<String, dynamic>)['pi_id'] as String;

    // Duplicate items
    if (original.items.isNotEmpty) {
      final itemsToInsert = original.items.asMap().entries.map((entry) {
        final item = entry.value;
        return {
          'pi_id': newPiId,
          'product_id': item.productId,
          'description': item.description,
          'sku': item.sku,
          'hs_code': item.hsCode,
          'country_of_origin': item.countryOfOrigin,
          'quantity': item.quantity,
          'unit': item.unit,
          'unit_price': item.unitPrice,
          'discount_percent': item.discountPercent,
          'total_amount': item.totalAmount,
          'packing_info': item.packingInfo,
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_pi_items').insert(itemsToInsert);
    }

    return getById(newPiId);
  }

  @override
  Future<String> generateNumber(String companyId) async {
    // Get the latest PI number for this company
    final response = await _supabase
        .from('trade_proforma_invoices')
        .select('pi_number')
        .eq('company_id', companyId)
        .order('created_at_utc', ascending: false)
        .limit(1);

    final data = response as List;
    int nextNumber = 1;

    if (data.isNotEmpty) {
      final lastNumber = data[0]['pi_number'] as String;
      // Extract number from format PI-YYYYMMDD-XXXX
      final parts = lastNumber.split('-');
      if (parts.length >= 3) {
        nextNumber = (int.tryParse(parts.last) ?? 0) + 1;
      }
    }

    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'PI-$dateStr-${nextNumber.toString().padLeft(4, '0')}';
  }
}
