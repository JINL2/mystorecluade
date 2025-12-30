import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/letter_of_credit.dart';
import '../../domain/repositories/lc_repository.dart';

/// LC Remote Datasource - handles all Supabase queries for Letter of Credit
abstract class LCRemoteDatasource {
  Future<PaginatedLCResponse> getList(LCListParams params);
  Future<LetterOfCredit> getById(String lcId);
  Future<LetterOfCredit> create(LCCreateParams params);
  Future<LetterOfCredit> update(
      String lcId, int version, Map<String, dynamic> updates);
  Future<void> delete(String lcId);
  Future<void> updateStatus(String lcId, LCStatus newStatus, {String? notes});
  Future<LCAmendment> addAmendment(String lcId, LCAmendmentCreateParams params);
  Future<void> updateAmendmentStatus(
      String amendmentId, LCAmendmentStatus status);
  Future<void> recordUtilization(String lcId, double amount);
  Future<String> createFromPO(String poId, {Map<String, dynamic>? options});
  Future<String> generateNumber(String companyId);
}

class LCRemoteDatasourceImpl implements LCRemoteDatasource {
  final SupabaseClient _supabase;

  LCRemoteDatasourceImpl(this._supabase);

  @override
  Future<PaginatedLCResponse> getList(LCListParams params) async {
    var query = _supabase
        .from('trade_letters_of_credit')
        .select('*')
        .eq('company_id', params.companyId);

    if (params.storeId != null) {
      query = query.or('store_id.eq.${params.storeId},store_id.is.null');
    }

    if (params.statuses != null && params.statuses!.isNotEmpty) {
      query = query.inFilter(
          'status', params.statuses!.map((e) => e.name).toList());
    }

    if (params.applicantId != null) {
      query = query.eq('applicant_id', params.applicantId!);
    }

    if (params.poId != null) {
      query = query.eq('po_id', params.poId!);
    }

    if (params.piId != null) {
      query = query.eq('pi_id', params.piId!);
    }

    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      query = query.ilike('lc_number', '%${params.searchQuery}%');
    }

    // Count query
    var countQuery = _supabase
        .from('trade_letters_of_credit')
        .select('lc_id')
        .eq('company_id', params.companyId);

    if (params.storeId != null) {
      countQuery =
          countQuery.or('store_id.eq.${params.storeId},store_id.is.null');
    }
    if (params.statuses != null && params.statuses!.isNotEmpty) {
      countQuery = countQuery.inFilter(
          'status', params.statuses!.map((e) => e.name).toList());
    }
    if (params.applicantId != null) {
      countQuery = countQuery.eq('applicant_id', params.applicantId!);
    }
    if (params.poId != null) {
      countQuery = countQuery.eq('po_id', params.poId!);
    }
    if (params.piId != null) {
      countQuery = countQuery.eq('pi_id', params.piId!);
    }
    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      countQuery = countQuery.ilike('lc_number', '%${params.searchQuery}%');
    }

    final countResponse = await countQuery;
    final totalCount = (countResponse as List).length;

    // Paginated data
    final offset = (params.page - 1) * params.pageSize;
    final response = await query
        .order('created_at_utc', ascending: false)
        .range(offset, offset + params.pageSize - 1);

    final data = response as List;

    // Fetch related names (applicants, banks, PO/PI numbers)
    final applicantIds = data
        .map((e) => (e as Map<String, dynamic>)['applicant_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    Map<String, String> applicantNameMap = {};
    if (applicantIds.isNotEmpty) {
      final applicantResponse = await _supabase
          .from('counterparties')
          .select('counterparty_id, name')
          .inFilter('counterparty_id', applicantIds);
      for (final c in applicantResponse as List) {
        applicantNameMap[c['counterparty_id'] as String] =
            c['name'] as String;
      }
    }

    // Fetch PO numbers
    final poIds = data
        .map((e) => (e as Map<String, dynamic>)['po_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    Map<String, String> poNumberMap = {};
    if (poIds.isNotEmpty) {
      final poResponse = await _supabase
          .from('trade_purchase_orders')
          .select('po_id, po_number')
          .inFilter('po_id', poIds);
      for (final p in poResponse as List) {
        poNumberMap[p['po_id'] as String] = p['po_number'] as String;
      }
    }

    // Fetch PI numbers
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

    // Fetch currency codes
    final currencyIds = data
        .map((e) => (e as Map<String, dynamic>)['currency_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

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

    final items = data.map((e) {
      final map = e as Map<String, dynamic>;

      // Get applicant name from JSONB or lookup
      final applicantInfo = map['applicant_info'] as Map<String, dynamic>?;
      String? applicantName = applicantInfo?['name'] as String?;
      if (applicantName == null) {
        final applicantId = map['applicant_id'] as String?;
        if (applicantId != null) {
          applicantName = applicantNameMap[applicantId];
        }
      }

      // Get issuing bank name from JSONB
      final issuingBankInfo =
          map['issuing_bank_info'] as Map<String, dynamic>?;
      final issuingBankName = issuingBankInfo?['name'] as String?;

      // Get currency code
      final currencyId = map['currency_id'] as String?;
      final currencyCode = currencyId != null
          ? currencyCodeMap[currencyId] ?? 'USD'
          : 'USD';

      // Get PO/PI numbers
      final poId = map['po_id'] as String?;
      final piId = map['pi_id'] as String?;
      final poNumber = poId != null ? poNumberMap[poId] : null;
      final piNumber = piId != null ? piNumberMap[piId] : null;

      return LCListItem(
        lcId: map['lc_id'] as String,
        lcNumber: map['lc_number'] as String,
        applicantName: applicantName,
        issuingBankName: issuingBankName,
        currencyCode: currencyCode,
        amount: (map['amount'] as num?)?.toDouble() ?? 0,
        amountUtilized: (map['amount_utilized'] as num?)?.toDouble() ?? 0,
        status: LCStatus.fromString(map['status'] as String? ?? 'draft'),
        expiryDateUtc: DateTime.parse(map['expiry_date_utc'] as String),
        latestShipmentDateUtc: map['latest_shipment_date_utc'] != null
            ? DateTime.parse(map['latest_shipment_date_utc'] as String)
            : null,
        createdAtUtc: map['created_at_utc'] != null
            ? DateTime.parse(map['created_at_utc'] as String)
            : null,
        piNumber: piNumber,
        poNumber: poNumber,
      );
    }).toList();

    return PaginatedLCResponse(
      data: items,
      totalCount: totalCount,
      page: params.page,
      pageSize: params.pageSize,
      hasMore: offset + items.length < totalCount,
    );
  }

  @override
  Future<LetterOfCredit> getById(String lcId) async {
    final lcResponse = await _supabase
        .from('trade_letters_of_credit')
        .select('*')
        .eq('lc_id', lcId)
        .single();

    final map = lcResponse as Map<String, dynamic>;

    // Get currency code
    final currencyId = map['currency_id'] as String?;
    String currencyCode = 'USD';
    if (currencyId != null) {
      final currencyResponse = await _supabase
          .from('currency_types')
          .select('currency_code')
          .eq('currency_id', currencyId)
          .maybeSingle();
      if (currencyResponse != null) {
        currencyCode = currencyResponse['currency_code'] as String;
      }
    }

    // Get applicant name
    final applicantInfo = map['applicant_info'] as Map<String, dynamic>?;
    String? applicantName = applicantInfo?['name'] as String?;
    final applicantId = map['applicant_id'] as String?;
    if (applicantName == null && applicantId != null) {
      final applicantResponse = await _supabase
          .from('counterparties')
          .select('name')
          .eq('counterparty_id', applicantId)
          .maybeSingle();
      if (applicantResponse != null) {
        applicantName = applicantResponse['name'] as String?;
      }
    }

    // Get bank names
    final issuingBankInfo =
        map['issuing_bank_info'] as Map<String, dynamic>?;
    final issuingBankName = issuingBankInfo?['name'] as String?;

    final advisingBankInfo =
        map['advising_bank_info'] as Map<String, dynamic>?;
    final advisingBankName = advisingBankInfo?['name'] as String?;

    final confirmingBankInfo =
        map['confirming_bank_info'] as Map<String, dynamic>?;
    final confirmingBankName = confirmingBankInfo?['name'] as String?;

    // Get PO/PI numbers
    String? poNumber;
    String? piNumber;
    final poId = map['po_id'] as String?;
    final piId = map['pi_id'] as String?;

    if (poId != null) {
      final poResponse = await _supabase
          .from('trade_purchase_orders')
          .select('po_number')
          .eq('po_id', poId)
          .maybeSingle();
      if (poResponse != null) {
        poNumber = poResponse['po_number'] as String?;
      }
    }

    if (piId != null) {
      final piResponse = await _supabase
          .from('trade_proforma_invoices')
          .select('pi_number')
          .eq('pi_id', piId)
          .maybeSingle();
      if (piResponse != null) {
        piNumber = piResponse['pi_number'] as String?;
      }
    }

    // Get amendments
    final amendmentsResponse = await _supabase
        .from('trade_lc_amendments')
        .select('*')
        .eq('lc_id', lcId)
        .order('amendment_number', ascending: true);

    final amendments = (amendmentsResponse as List).map((a) {
      final amendMap = a as Map<String, dynamic>;
      return LCAmendment(
        amendmentId: amendMap['amendment_id'] as String,
        lcId: amendMap['lc_id'] as String,
        amendmentNumber: amendMap['amendment_number'] as int,
        amendmentDateUtc: amendMap['amendment_date_utc'] != null
            ? DateTime.parse(amendMap['amendment_date_utc'] as String)
            : null,
        changesSummary: amendMap['changes_summary'] as String,
        changesDetail: amendMap['changes_detail'] as Map<String, dynamic>?,
        amendmentFee: (amendMap['amendment_fee'] as num?)?.toDouble(),
        amendmentFeeCurrencyId:
            amendMap['amendment_fee_currency_id'] as String?,
        status: LCAmendmentStatus.fromString(
            amendMap['status'] as String? ?? 'pending'),
        requestedBy: amendMap['requested_by'] as String?,
        requestedAtUtc: amendMap['requested_at_utc'] != null
            ? DateTime.parse(amendMap['requested_at_utc'] as String)
            : null,
        processedAtUtc: amendMap['processed_at_utc'] != null
            ? DateTime.parse(amendMap['processed_at_utc'] as String)
            : null,
      );
    }).toList();

    // Parse required documents
    final requiredDocsJson = map['required_documents'] as List<dynamic>?;
    final requiredDocuments = requiredDocsJson?.map((doc) {
          final docMap = doc as Map<String, dynamic>;
          return LCRequiredDocument(
            code: docMap['code'] as String,
            name: docMap['name'] as String?,
            copiesOriginal: docMap['copies_original'] as int? ?? 1,
            copiesCopy: docMap['copies_copy'] as int? ?? 1,
            notes: docMap['notes'] as String?,
          );
        }).toList() ??
        [];

    return LetterOfCredit(
      lcId: map['lc_id'] as String,
      lcNumber: map['lc_number'] as String,
      companyId: map['company_id'] as String,
      storeId: map['store_id'] as String?,
      piId: piId,
      piNumber: piNumber,
      poId: poId,
      poNumber: poNumber,
      lcTypeCode: map['lc_type_code'] as String? ?? 'irrevocable',
      applicantId: applicantId,
      applicantName: applicantName,
      applicantInfo: applicantInfo,
      beneficiaryInfo: map['beneficiary_info'] as Map<String, dynamic>?,
      issuingBankId: map['issuing_bank_id'] as String?,
      issuingBankName: issuingBankName,
      issuingBankInfo: issuingBankInfo,
      advisingBankId: map['advising_bank_id'] as String?,
      advisingBankName: advisingBankName,
      advisingBankInfo: advisingBankInfo,
      confirmingBankId: map['confirming_bank_id'] as String?,
      confirmingBankName: confirmingBankName,
      confirmingBankInfo: confirmingBankInfo,
      currencyId: currencyId,
      currencyCode: currencyCode,
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      amountUtilized: (map['amount_utilized'] as num?)?.toDouble() ?? 0,
      tolerancePlusPercent:
          (map['tolerance_plus_percent'] as num?)?.toDouble() ?? 0,
      toleranceMinusPercent:
          (map['tolerance_minus_percent'] as num?)?.toDouble() ?? 0,
      issueDateUtc: map['issue_date_utc'] != null
          ? DateTime.parse(map['issue_date_utc'] as String)
          : null,
      expiryDateUtc: DateTime.parse(map['expiry_date_utc'] as String),
      expiryPlace: map['expiry_place'] as String?,
      latestShipmentDateUtc: map['latest_shipment_date_utc'] != null
          ? DateTime.parse(map['latest_shipment_date_utc'] as String)
          : null,
      presentationPeriodDays: map['presentation_period_days'] as int? ?? 21,
      paymentTermsCode: map['payment_terms_code'] as String?,
      usanceDays: map['usance_days'] as int?,
      usanceFrom: map['usance_from'] as String?,
      incotermsCode: map['incoterms_code'] as String?,
      incotermsPlace: map['incoterms_place'] as String?,
      portOfLoading: map['port_of_loading'] as String?,
      portOfDischarge: map['port_of_discharge'] as String?,
      shippingMethodCode: map['shipping_method_code'] as String?,
      partialShipmentAllowed:
          map['partial_shipment_allowed'] as bool? ?? true,
      transshipmentAllowed: map['transshipment_allowed'] as bool? ?? true,
      requiredDocuments: requiredDocuments,
      specialConditions: map['special_conditions'] as String?,
      additionalConditions:
          map['additional_conditions'] as Map<String, dynamic>?,
      status: LCStatus.fromString(map['status'] as String? ?? 'draft'),
      version: map['version'] as int? ?? 1,
      amendmentCount: map['amendment_count'] as int? ?? 0,
      notes: map['notes'] as String?,
      internalNotes: map['internal_notes'] as String?,
      createdBy: map['created_by'] as String?,
      createdAtUtc: map['created_at_utc'] != null
          ? DateTime.parse(map['created_at_utc'] as String)
          : null,
      updatedAtUtc: map['updated_at_utc'] != null
          ? DateTime.parse(map['updated_at_utc'] as String)
          : null,
      amendments: amendments,
    );
  }

  @override
  Future<LetterOfCredit> create(LCCreateParams params) async {
    final lcNumber = await generateNumber(params.companyId);

    final lcResponse = await _supabase
        .from('trade_letters_of_credit')
        .insert({
          'lc_number': lcNumber,
          'company_id': params.companyId,
          'store_id': params.storeId,
          'pi_id': params.piId,
          'po_id': params.poId,
          'lc_type_code': params.lcTypeCode ?? 'irrevocable',
          'applicant_id': params.applicantId,
          'applicant_info': params.applicantInfo,
          'beneficiary_info': params.beneficiaryInfo,
          'issuing_bank_id': params.issuingBankId,
          'issuing_bank_info': params.issuingBankInfo,
          'advising_bank_id': params.advisingBankId,
          'advising_bank_info': params.advisingBankInfo,
          'confirming_bank_id': params.confirmingBankId,
          'confirming_bank_info': params.confirmingBankInfo,
          'currency_id': params.currencyId,
          'amount': params.amount,
          'amount_utilized': 0,
          'tolerance_plus_percent': params.tolerancePlusPercent,
          'tolerance_minus_percent': params.toleranceMinusPercent,
          'issue_date_utc': params.issueDateUtc?.toIso8601String(),
          'expiry_date_utc': params.expiryDateUtc.toIso8601String(),
          'expiry_place': params.expiryPlace,
          'latest_shipment_date_utc':
              params.latestShipmentDateUtc?.toIso8601String(),
          'presentation_period_days': params.presentationPeriodDays,
          'payment_terms_code': params.paymentTermsCode,
          'usance_days': params.usanceDays,
          'usance_from': params.usanceFrom,
          'incoterms_code': params.incotermsCode,
          'incoterms_place': params.incotermsPlace,
          'port_of_loading': params.portOfLoading,
          'port_of_discharge': params.portOfDischarge,
          'shipping_method_code': params.shippingMethodCode,
          'partial_shipment_allowed': params.partialShipmentAllowed,
          'transshipment_allowed': params.transshipmentAllowed,
          'required_documents':
              params.requiredDocuments.map((d) => d.toJson()).toList(),
          'special_conditions': params.specialConditions,
          'additional_conditions': params.additionalConditions,
          'status': 'draft',
          'version': 1,
          'amendment_count': 0,
          'notes': params.notes,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final lcId = (lcResponse as Map<String, dynamic>)['lc_id'] as String;
    return getById(lcId);
  }

  @override
  Future<LetterOfCredit> update(
      String lcId, int version, Map<String, dynamic> updates) async {
    updates['updated_at_utc'] = DateTime.now().toUtc().toIso8601String();
    updates['version'] = version + 1;

    await _supabase
        .from('trade_letters_of_credit')
        .update(updates)
        .eq('lc_id', lcId)
        .eq('version', version);

    return getById(lcId);
  }

  @override
  Future<void> delete(String lcId) async {
    // Delete amendments first
    await _supabase.from('trade_lc_amendments').delete().eq('lc_id', lcId);

    // Delete LC (only draft)
    await _supabase
        .from('trade_letters_of_credit')
        .delete()
        .eq('lc_id', lcId)
        .eq('status', 'draft');
  }

  @override
  Future<void> updateStatus(String lcId, LCStatus newStatus,
      {String? notes}) async {
    final updates = <String, dynamic>{
      'status': newStatus.name,
      'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
    };

    if (notes != null) {
      updates['notes'] = notes;
    }

    // Set issue date when status becomes issued
    if (newStatus == LCStatus.issued) {
      updates['issue_date_utc'] = DateTime.now().toUtc().toIso8601String();
    }

    await _supabase
        .from('trade_letters_of_credit')
        .update(updates)
        .eq('lc_id', lcId);
  }

  @override
  Future<LCAmendment> addAmendment(
      String lcId, LCAmendmentCreateParams params) async {
    // Get current amendment count
    final lcResponse = await _supabase
        .from('trade_letters_of_credit')
        .select('amendment_count')
        .eq('lc_id', lcId)
        .single();

    final currentCount =
        (lcResponse as Map<String, dynamic>)['amendment_count'] as int? ?? 0;
    final newAmendmentNumber = currentCount + 1;

    // Insert amendment
    final amendmentResponse = await _supabase
        .from('trade_lc_amendments')
        .insert({
          'lc_id': lcId,
          'amendment_number': newAmendmentNumber,
          'amendment_date_utc': DateTime.now().toUtc().toIso8601String(),
          'changes_summary': params.changesSummary,
          'changes_detail': params.changesDetail,
          'amendment_fee': params.amendmentFee,
          'amendment_fee_currency_id': params.amendmentFeeCurrencyId,
          'status': 'pending',
          'requested_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    // Update LC amendment count and status
    await _supabase.from('trade_letters_of_credit').update({
      'amendment_count': newAmendmentNumber,
      'status': 'amended',
      'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
    }).eq('lc_id', lcId);

    final map = amendmentResponse as Map<String, dynamic>;
    return LCAmendment(
      amendmentId: map['amendment_id'] as String,
      lcId: map['lc_id'] as String,
      amendmentNumber: map['amendment_number'] as int,
      amendmentDateUtc: map['amendment_date_utc'] != null
          ? DateTime.parse(map['amendment_date_utc'] as String)
          : null,
      changesSummary: map['changes_summary'] as String,
      changesDetail: map['changes_detail'] as Map<String, dynamic>?,
      amendmentFee: (map['amendment_fee'] as num?)?.toDouble(),
      amendmentFeeCurrencyId: map['amendment_fee_currency_id'] as String?,
      status: LCAmendmentStatus.pending,
      requestedAtUtc: map['requested_at_utc'] != null
          ? DateTime.parse(map['requested_at_utc'] as String)
          : null,
    );
  }

  @override
  Future<void> updateAmendmentStatus(
      String amendmentId, LCAmendmentStatus status) async {
    await _supabase.from('trade_lc_amendments').update({
      'status': status.name,
      'processed_at_utc': DateTime.now().toUtc().toIso8601String(),
    }).eq('amendment_id', amendmentId);
  }

  @override
  Future<void> recordUtilization(String lcId, double amount) async {
    // Get current utilized amount
    final lcResponse = await _supabase
        .from('trade_letters_of_credit')
        .select('amount_utilized, amount')
        .eq('lc_id', lcId)
        .single();

    final map = lcResponse as Map<String, dynamic>;
    final currentUtilized =
        (map['amount_utilized'] as num?)?.toDouble() ?? 0;
    final totalAmount = (map['amount'] as num?)?.toDouble() ?? 0;
    final newUtilized = currentUtilized + amount;

    // Determine if LC is fully utilized
    final status = newUtilized >= totalAmount ? 'utilized' : null;

    final updates = <String, dynamic>{
      'amount_utilized': newUtilized,
      'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
    };

    if (status != null) {
      updates['status'] = status;
    }

    await _supabase
        .from('trade_letters_of_credit')
        .update(updates)
        .eq('lc_id', lcId);
  }

  @override
  Future<String> createFromPO(String poId,
      {Map<String, dynamic>? options}) async {
    // Get PO data
    final poResponse = await _supabase
        .from('trade_purchase_orders')
        .select('*')
        .eq('po_id', poId)
        .single();

    final po = poResponse as Map<String, dynamic>;

    // Generate LC number
    final lcNumber = await generateNumber(po['company_id'] as String);

    // Get PI ID if exists
    final piId = po['pi_id'] as String?;

    // Create LC from PO data
    final lcResponse = await _supabase
        .from('trade_letters_of_credit')
        .insert({
          'lc_number': lcNumber,
          'company_id': po['company_id'],
          'store_id': po['store_id'],
          'pi_id': piId,
          'po_id': poId,
          'lc_type_code': options?['lc_type_code'] ?? 'irrevocable',
          'applicant_id': po['buyer_id'],
          'applicant_info': po['buyer_info'],
          'currency_id': po['currency_id'],
          'amount': po['total_amount'] ?? 0,
          'amount_utilized': 0,
          'tolerance_plus_percent': options?['tolerance_plus_percent'] ?? 0,
          'tolerance_minus_percent': options?['tolerance_minus_percent'] ?? 0,
          'expiry_date_utc': options?['expiry_date_utc'] ??
              DateTime.now()
                  .add(const Duration(days: 90))
                  .toUtc()
                  .toIso8601String(),
          'latest_shipment_date_utc': po['required_shipment_date_utc'],
          'presentation_period_days': 21,
          'payment_terms_code': po['payment_terms_code'],
          'incoterms_code': po['incoterms_code'],
          'incoterms_place': po['incoterms_place'],
          'partial_shipment_allowed':
              po['partial_shipment_allowed'] ?? true,
          'transshipment_allowed': po['transshipment_allowed'] ?? true,
          'status': 'draft',
          'version': 1,
          'amendment_count': 0,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    return (lcResponse as Map<String, dynamic>)['lc_id'] as String;
  }

  @override
  Future<String> generateNumber(String companyId) async {
    final response = await _supabase
        .from('trade_letters_of_credit')
        .select('lc_number')
        .eq('company_id', companyId)
        .order('created_at_utc', ascending: false)
        .limit(1);

    final data = response as List;
    int nextNumber = 1;

    if (data.isNotEmpty) {
      final lastNumber = data[0]['lc_number'] as String;
      final parts = lastNumber.split('-');
      if (parts.length >= 3) {
        nextNumber = (int.tryParse(parts.last) ?? 0) + 1;
      }
    }

    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'LC-$dateStr-${nextNumber.toString().padLeft(4, '0')}';
  }
}
