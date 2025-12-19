// lib/features/cash_location/data/models/stock_flow_model.dart

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/stock_flow.dart';

/// Data models for stock flow tracking
/// Since domain entities use Freezed, we use their factory constructors directly

class JournalFlowModel {
  static JournalFlow fromJson(Map<String, dynamic> json) {
    // Convert UTC datetime strings from database to local time ISO8601 strings
    final createdAtUtc = (json['created_at'] ?? '').toString();
    final systemTimeUtc = (json['system_time'] ?? '').toString();

    // V2 RPC returns created_by as UUID string + created_by_name + created_by_profile_image
    // Build CreatedBy from flat fields
    final createdBy = CreatedBy(
      userId: (json['created_by'] ?? '').toString(),
      fullName: (json['created_by_name'] ?? '').toString(),
      profileImage: json['created_by_profile_image']?.toString(),
    );

    // Parse attachments
    final attachmentsData = json['attachments'] as List<dynamic>? ?? [];
    final attachments = <JournalAttachment>[];
    for (final attachmentJson in attachmentsData) {
      try {
        attachments.add(JournalAttachmentModel.fromJson(attachmentJson as Map<String, dynamic>));
      } catch (e) {
        // Skip invalid attachments
      }
    }

    return JournalFlow(
      flowId: (json['flow_id'] ?? '').toString(),
      createdAt: createdAtUtc.isNotEmpty ? DateTimeUtils.toLocal(createdAtUtc).toIso8601String() : '',
      systemTime: systemTimeUtc.isNotEmpty ? DateTimeUtils.toLocal(systemTimeUtc).toIso8601String() : '',
      balanceBefore: (json['balance_before'] as num?)?.toDouble() ?? 0.0,
      flowAmount: (json['flow_amount'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      journalId: (json['journal_id'] ?? '').toString(),
      journalDescription: (json['journal_description'] ?? '').toString(),
      journalAiDescription: json['journal_ai_description']?.toString(),
      journalType: (json['journal_type'] ?? '').toString(),
      accountId: (json['account_id'] ?? '').toString(),
      accountName: (json['account_name'] ?? '').toString(),
      createdBy: createdBy,
      counterAccount: json['counter_account'] != null && json['counter_account'] is Map<String, dynamic>
          ? CounterAccountModel.fromJson(json['counter_account'] as Map<String, dynamic>)
          : null,
      attachments: attachments,
    );
  }
}

class JournalAttachmentModel {
  static JournalAttachment fromJson(Map<String, dynamic> json) {
    final fileName = json['file_name']?.toString() ?? '';
    // Infer file_type from file_name if not provided
    final fileType = json['file_type']?.toString() ?? _inferMimeType(fileName);

    return JournalAttachment(
      attachmentId: json['attachment_id']?.toString() ?? '',
      fileName: fileName,
      fileType: fileType,
      fileUrl: json['file_url']?.toString(),
      ocrText: json['ocr_text']?.toString(),
      ocrStatus: json['ocr_status']?.toString(),
    );
  }

  /// Infer MIME type from file extension
  static String _inferMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}

class ActualFlowModel {
  static ActualFlow fromJson(Map<String, dynamic> json) {
    // Convert UTC datetime strings from database to local time ISO8601 strings
    final createdAtUtc = (json['created_at'] ?? '').toString();
    final systemTimeUtc = (json['system_time'] ?? '').toString();

    // V2 RPC returns flat structure with currency_id, currency_code, etc.
    // Build CurrencyInfo from flat fields
    final currencyInfo = CurrencyInfo(
      currencyId: (json['currency_id'] ?? '').toString(),
      currencyCode: (json['currency_code'] ?? '').toString(),
      currencyName: (json['currency_name'] ?? '').toString(),
      symbol: (json['currency_symbol'] ?? '').toString(),
    );

    // V2 RPC returns created_by as UUID string + created_by_name
    // Build CreatedBy from flat fields
    final createdBy = CreatedBy(
      userId: (json['created_by'] ?? '').toString(),
      fullName: (json['created_by_name'] ?? '').toString(),
    );

    // V2 uses 'denomination_details', V1 uses 'current_denominations'
    final denominationsKey = json.containsKey('denomination_details')
        ? 'denomination_details'
        : 'current_denominations';

    return ActualFlow(
      flowId: (json['flow_id'] ?? '').toString(),
      createdAt: createdAtUtc.isNotEmpty ? DateTimeUtils.toLocal(createdAtUtc).toIso8601String() : '',
      systemTime: systemTimeUtc.isNotEmpty ? DateTimeUtils.toLocal(systemTimeUtc).toIso8601String() : '',
      balanceBefore: (json['balance_before'] as num?)?.toDouble() ?? 0.0,
      flowAmount: (json['flow_amount'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      currency: currencyInfo,
      createdBy: createdBy,
      currentDenominations: (json[denominationsKey] as List<dynamic>?)
          ?.map((e) => DenominationDetailModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class LocationSummaryModel {
  static LocationSummary fromJson(Map<String, dynamic> json) {
    return LocationSummary(
      cashLocationId: (json['cash_location_id'] ?? '').toString(),
      locationName: (json['location_name'] ?? '').toString(),
      locationType: (json['location_type'] ?? '').toString(),
      bankName: json['bank_name']?.toString(),
      bankAccount: json['bank_account']?.toString(),
      currencyCode: (json['currency_code'] ?? '').toString(),
      currencyId: (json['currency_id'] ?? '').toString(),
      baseCurrencySymbol: json['base_currency_symbol']?.toString() ?? json['currency_symbol']?.toString(),
    );
  }
}

class CounterAccountModel {
  static CounterAccount fromJson(Map<String, dynamic> json) {
    return CounterAccount(
      accountId: (json['account_id'] ?? '').toString(),
      accountName: (json['account_name'] ?? '').toString(),
      accountType: (json['account_type'] ?? '').toString(),
      debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      description: (json['description'] ?? '').toString(),
    );
  }
}

class CurrencyInfoModel {
  static CurrencyInfo fromJson(Map<String, dynamic> json) {
    return CurrencyInfo(
      currencyId: (json['currency_id'] ?? '').toString(),
      currencyCode: (json['currency_code'] ?? '').toString(),
      currencyName: (json['currency_name'] ?? '').toString(),
      symbol: (json['symbol'] ?? '').toString(),
    );
  }
}

class CreatedByModel {
  static CreatedBy fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      userId: (json['user_id'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
    );
  }
}

class DenominationDetailModel {
  static DenominationDetail fromJson(Map<String, dynamic> json) {
    return DenominationDetail(
      denominationId: (json['denomination_id'] ?? '').toString(),
      denominationValue: (json['denomination_value'] as num?)?.toDouble() ?? 0.0,
      denominationType: (json['denomination_type'] ?? '').toString(),
      previousQuantity: (json['previous_quantity'] as num?)?.toInt() ?? 0,
      currentQuantity: (json['current_quantity'] as num?)?.toInt() ?? 0,
      quantityChange: (json['quantity_change'] as num?)?.toInt() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: json['currency_symbol']?.toString(),
      // Bank multi-currency fields
      currencyId: json['currency_id']?.toString(),
      currencyCode: json['currency_code']?.toString(),
      currencyName: json['currency_name']?.toString(),
      amount: (json['amount'] as num?)?.toDouble(),
      exchangeRate: (json['exchange_rate'] as num?)?.toDouble(),
      amountInBaseCurrency: (json['amount_in_base_currency'] as num?)?.toDouble(),
    );
  }
}

class StockFlowDataModel {
  static StockFlowData fromJson(Map<String, dynamic> json) {
    return StockFlowData(
      locationSummary: json['location_summary'] != null
          ? LocationSummaryModel.fromJson(json['location_summary'] as Map<String, dynamic>)
          : null,
      journalFlows: (json['journal_flows'] as List<dynamic>?)
          ?.map((e) => JournalFlowModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      actualFlows: (json['actual_flows'] as List<dynamic>?)
          ?.map((e) => ActualFlowModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class PaginationInfoModel {
  static PaginationInfo fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      totalJournalFlows: (json['total_journal_flows'] as num?)?.toInt() ?? 0,
      totalActualFlows: (json['total_actual_flows'] as num?)?.toInt() ?? 0,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class StockFlowResponseModel {
  static StockFlowResponse fromJson(Map<String, dynamic> json) {
    // V2 RPC returns flat structure: {location, journal_flows, actual_flows, pagination}
    // V1 returns nested: {success, data: {location_summary, ...}, pagination}

    // Check if V2 structure (has 'location' field)
    final isV2 = json.containsKey('location');

    if (isV2) {
      // V2 Structure
      return StockFlowResponse(
        success: true, // V2 always successful (errors throw exceptions)
        data: StockFlowData(
          locationSummary: json['location'] != null
              ? LocationSummaryModel.fromJson(json['location'] as Map<String, dynamic>)
              : null,
          journalFlows: (json['journal_flows'] as List<dynamic>?)
              ?.map((e) => JournalFlowModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
          actualFlows: (json['actual_flows'] as List<dynamic>?)
              ?.map((e) => ActualFlowModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
        ),
        pagination: json['pagination'] != null
            ? PaginationInfoModel.fromJson(json['pagination'] as Map<String, dynamic>)
            : null,
      );
    } else {
      // V1 Structure (legacy)
      return StockFlowResponse(
        success: json['success'] as bool? ?? false,
        data: json['data'] != null
            ? StockFlowDataModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        pagination: json['pagination'] != null
            ? PaginationInfoModel.fromJson(json['pagination'] as Map<String, dynamic>)
            : null,
      );
    }
  }
}
