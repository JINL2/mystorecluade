import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// Main V2 Response Model
class DebtControlV2Response {
  final DebtPerspectiveData? company;
  final DebtPerspectiveData? store;
  final DebtV2Metadata metadata;

  DebtControlV2Response({
    this.company,
    this.store,
    required this.metadata,
  });

  factory DebtControlV2Response.fromJson(Map<String, dynamic> json) {
    return DebtControlV2Response(
      company: json['company'] != null 
        ? DebtPerspectiveData.fromJson(json['company'] as Map<String, dynamic>)
        : null,
      store: json['store'] != null 
        ? DebtPerspectiveData.fromJson(json['store'] as Map<String, dynamic>)
        : null,
      metadata: DebtV2Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }
  
  // Helper to get current perspective based on UI state
  DebtPerspectiveData? getPerspective(bool isCompanyView) {
    return isCompanyView ? company : store;
  }
}

// Perspective Data Model
class DebtPerspectiveData {
  final DebtMetadata metadata;
  final DebtSummary summary;
  final List<StoreAggregate> storeAggregates;
  final List<DebtRecord> records;

  DebtPerspectiveData({
    required this.metadata,
    required this.summary,
    required this.storeAggregates,
    required this.records,
  });

  factory DebtPerspectiveData.fromJson(Map<String, dynamic> json) {
    return DebtPerspectiveData(
      metadata: DebtMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      summary: DebtSummary.fromJson(json['summary'] as Map<String, dynamic>),
      storeAggregates: (json['store_aggregates'] as List? ?? [])
          .map((e) => StoreAggregate.fromJson(e as Map<String, dynamic>))
          .toList(),
      records: (json['records'] as List? ?? [])
          .map((e) => DebtRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// V2 Root Metadata
class DebtV2Metadata {
  final String version;
  final DateTime generatedAt;
  final bool hasBothPerspectives;

  DebtV2Metadata({
    required this.version,
    required this.generatedAt,
    required this.hasBothPerspectives,
  });

  factory DebtV2Metadata.fromJson(Map<String, dynamic> json) {
    return DebtV2Metadata(
      version: json['version'] as String,
      generatedAt: DateTime.parse(json['generated_at'] as String),
      hasBothPerspectives: json['has_both_perspectives'] as bool,
    );
  }
}

// Perspective Metadata
class DebtMetadata {
  final String companyId;
  final String? storeId;
  final String? storeName;
  final String perspective;
  final String filter;
  final DateTime generatedAt;
  final String currency;

  DebtMetadata({
    required this.companyId,
    this.storeId,
    this.storeName,
    required this.perspective,
    required this.filter,
    required this.generatedAt,
    required this.currency,
  });

  factory DebtMetadata.fromJson(Map<String, dynamic> json) {
    return DebtMetadata(
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      perspective: json['perspective'] as String,
      filter: json['filter'] as String,
      generatedAt: DateTime.parse(json['generated_at'] as String),
      currency: json['currency'] as String,
    );
  }
  
  bool get isCompanyPerspective => perspective == 'company';
  bool get isStorePerspective => perspective == 'store';
  
  String get displayTitle {
    if (isStorePerspective && storeName != null) {
      return storeName!;
    }
    return isCompanyPerspective ? 'Company Overview' : 'Store View';
  }
  
  String get displaySubtitle {
    return isCompanyPerspective
      ? 'Company-wide view (all stores aggregated)'
      : 'Store-specific view';
  }
}

// Summary Model
class DebtSummary {
  final double totalReceivable;
  final double totalPayable;
  final double netPosition;
  final double internalReceivable;
  final double internalPayable;
  final double externalReceivable;
  final double externalPayable;
  final int counterpartyCount;
  final int transactionCount;

  DebtSummary({
    required this.totalReceivable,
    required this.totalPayable,
    required this.netPosition,
    required this.internalReceivable,
    required this.internalPayable,
    required this.externalReceivable,
    required this.externalPayable,
    required this.counterpartyCount,
    required this.transactionCount,
  });

  factory DebtSummary.fromJson(Map<String, dynamic> json) {
    return DebtSummary(
      totalReceivable: (json['total_receivable'] as num? ?? 0).toDouble(),
      totalPayable: (json['total_payable'] as num? ?? 0).toDouble(),
      netPosition: (json['net_position'] as num? ?? 0).toDouble(),
      internalReceivable: (json['internal_receivable'] as num? ?? 0).toDouble(),
      internalPayable: (json['internal_payable'] as num? ?? 0).toDouble(),
      externalReceivable: (json['external_receivable'] as num? ?? 0).toDouble(),
      externalPayable: (json['external_payable'] as num? ?? 0).toDouble(),
      counterpartyCount: json['counterparty_count'] as int? ?? 0,
      transactionCount: json['transaction_count'] as int? ?? 0,
    );
  }
  
  double get internalNet => internalReceivable - internalPayable;
  double get externalNet => externalReceivable - externalPayable;
  bool get isNetReceivable => netPosition > 0;
  
  String get netPositionFormatted => _formatCurrency(netPosition);
  String get netPositionStatus => isNetReceivable ? 'Net Receivable' : 'Net Payable';
  
  String formatCompact(double value) {
    final absValue = value.abs();
    String result;
    if (absValue >= 1000000000) {
      result = '₫${(absValue / 1000000000).toStringAsFixed(1)}B';
    } else if (absValue >= 1000000) {
      result = '₫${(absValue / 1000000).toStringAsFixed(1)}M';
    } else if (absValue >= 1000) {
      result = '₫${(absValue / 1000).toStringAsFixed(1)}K';
    } else {
      result = '₫${absValue.toStringAsFixed(0)}';
    }
    return value < 0 ? '-$result' : result;
  }
  
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    return formatter.format(amount.abs());
  }
}

// Store Aggregate Model
class StoreAggregate {
  final String storeId;
  final String storeName;
  final double receivable;
  final double payable;
  final double netPosition;
  final int counterpartyCount;

  StoreAggregate({
    required this.storeId,
    required this.storeName,
    required this.receivable,
    required this.payable,
    required this.netPosition,
    required this.counterpartyCount,
  });

  factory StoreAggregate.fromJson(Map<String, dynamic> json) {
    return StoreAggregate(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      receivable: (json['receivable'] as num? ?? 0).toDouble(),
      payable: (json['payable'] as num? ?? 0).toDouble(),
      netPosition: (json['net_position'] as num? ?? 0).toDouble(),
      counterpartyCount: json['counterparty_count'] as int? ?? 0,
    );
  }
  
  String get netPositionCompact {
    final absAmount = netPosition.abs();
    if (absAmount >= 1000000) {
      return '${(absAmount / 1000000).toStringAsFixed(1)}M';
    } else if (absAmount >= 1000) {
      return '${(absAmount / 1000).toStringAsFixed(1)}K';
    }
    return absAmount.toStringAsFixed(0);
  }
}

// Debt Record Model
class DebtRecord {
  final String counterpartyId;
  final String counterpartyName;
  final bool isInternal;
  final double receivableAmount;
  final double payableAmount;
  final double netAmount;
  final DateTime? lastActivity;
  final int transactionCount;

  DebtRecord({
    required this.counterpartyId,
    required this.counterpartyName,
    required this.isInternal,
    required this.receivableAmount,
    required this.payableAmount,
    required this.netAmount,
    this.lastActivity,
    required this.transactionCount,
  });

  factory DebtRecord.fromJson(Map<String, dynamic> json) {
    return DebtRecord(
      counterpartyId: json['counterparty_id'] as String,
      counterpartyName: json['counterparty_name'] as String,
      isInternal: json['is_internal'] as bool,
      receivableAmount: (json['receivable_amount'] as num? ?? 0).toDouble(),
      payableAmount: (json['payable_amount'] as num? ?? 0).toDouble(),
      netAmount: (json['net_amount'] as num? ?? 0).toDouble(),
      lastActivity: json['last_activity'] != null 
        ? DateTime.parse(json['last_activity'] as String)
        : null,
      transactionCount: json['transaction_count'] as int? ?? 0,
    );
  }
  
  bool get isNetPayable => netAmount < 0;
  String get statusText => netAmount >= 0 ? 'They owe us' : 'We owe them';
  
  String get lastActivityText {
    if (lastActivity == null) return 'No recent activity';
    
    final now = DateTime.now();
    final difference = now.difference(lastActivity!);
    
    if (difference.inDays == 0) {
      return 'Last activity today';
    } else if (difference.inDays == 1) {
      return 'Last activity yesterday';
    } else if (difference.inDays < 7) {
      return 'Last activity ${difference.inDays}d ago';
    } else {
      return 'Last activity ${(difference.inDays / 7).floor()}w ago';
    }
  }
  
  String get netAmountFormatted {
    final formatter = NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    return formatter.format(netAmount.abs());
  }
}