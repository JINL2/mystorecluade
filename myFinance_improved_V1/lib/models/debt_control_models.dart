import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// Main Response Model
class DebtControlResponse {
  final DebtMetadata metadata;
  final DebtSummary summary;
  final List<StoreAggregate> storeAggregates;
  final List<DebtRecord> records;

  DebtControlResponse({
    required this.metadata,
    required this.summary,
    required this.storeAggregates,
    required this.records,
  });

  factory DebtControlResponse.fromJson(Map<String, dynamic> json) {
    return DebtControlResponse(
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

// Metadata Model
class DebtMetadata {
  final String companyId;
  final String? storeId;
  final String perspective;
  final String filter;
  final DateTime generatedAt;
  final String currency;

  DebtMetadata({
    required this.companyId,
    this.storeId,
    required this.perspective,
    required this.filter,
    required this.generatedAt,
    required this.currency,
  });

  factory DebtMetadata.fromJson(Map<String, dynamic> json) {
    return DebtMetadata(
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      perspective: json['perspective'] as String,
      filter: json['filter'] as String,
      generatedAt: DateTime.parse(json['generated_at'] as String),
      currency: json['currency'] as String,
    );
  }
  
  bool get isCompanyPerspective => perspective == 'company';
  bool get isStorePerspective => perspective == 'store';
  
  String get displayTitle {
    if (isCompanyPerspective) {
      return 'Company Overview';
    } else {
      return 'Store View';
    }
  }
  
  String get displaySubtitle {
    if (isCompanyPerspective) {
      return 'Company-wide view (all stores aggregated)';
    } else {
      return 'Store-specific view';
    }
  }
}

// Summary Model with Formatting
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
  String get internalNetFormatted => _formatCompactCurrency(internalNet);
  String get externalNetFormatted => _formatCompactCurrency(externalNet);
  
  String get netPositionStatus => isNetReceivable ? 'Net Receivable' : 'Net Payable';
  
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    return formatter.format(amount.abs());
  }
  
  String _formatCompactCurrency(double amount) {
    if (amount == 0) return '₫0';
    final absAmount = amount.abs();
    String formatted;
    
    if (absAmount >= 1000000000) {
      formatted = '${(absAmount / 1000000000).toStringAsFixed(1)}B';
    } else if (absAmount >= 1000000) {
      formatted = '${(absAmount / 1000000).toStringAsFixed(1)}M';
    } else if (absAmount >= 1000) {
      formatted = '${(absAmount / 1000).toStringAsFixed(1)}K';
    } else {
      formatted = absAmount.toStringAsFixed(0);
    }
    
    // Always show with ₫ prefix and sign
    return amount < 0 ? '₫-$formatted' : '₫$formatted';
  }
  
  String formatCompactNumber(double number) {
    final absNumber = number.abs();
    if (absNumber >= 1000000) {
      return '${(absNumber / 1000000).toStringAsFixed(1)}M';
    } else if (absNumber >= 1000) {
      return '${(absNumber / 1000).toStringAsFixed(1)}K';
    }
    return absNumber.toStringAsFixed(0);
  }
  
  // New clearer formatting for R/P display
  String get internalReceivableFormatted => formatCompactNumber(internalReceivable.abs());
  String get internalPayableFormatted => formatCompactNumber(internalPayable.abs());
  String get externalReceivableFormatted => formatCompactNumber(externalReceivable.abs());
  String get externalPayableFormatted => formatCompactNumber(externalPayable.abs());
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
  
  String get counterpartyText => '${counterpartyCount}p';
}

// Debt Record Model
class DebtRecord {
  final String counterpartyId;
  final String counterpartyName;
  final bool isInternal;
  final String? storeId;
  final String? storeName;
  final double receivableAmount;
  final double payableAmount;
  final double netAmount;
  final DateTime? lastActivity;
  final int transactionCount;

  DebtRecord({
    required this.counterpartyId,
    required this.counterpartyName,
    required this.isInternal,
    this.storeId,
    this.storeName,
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
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
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
  String get netAmountFormatted => _formatCurrency(netAmount.abs());
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
    } else if (difference.inDays < 30) {
      return 'Last activity ${(difference.inDays / 7).floor()}w ago';
    } else {
      return 'Last activity ${(difference.inDays / 30).floor()}mo ago';
    }
  }
  
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }
}